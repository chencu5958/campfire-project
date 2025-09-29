-- ==================================================
-- * Campfire Project | Framework/Server/NetSync.lua
-- *
-- * Info:
-- * Campfire Project Framework Server NetManager - NetSync
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local NetSync = {}

local KeyMap = Config.Engine.Property.KeyMap
local Rank = require("Public.Framework.Server.Modules.Rank")
local TimerMap = Config.Engine.Map.Timer
local TeamIDMap = Config.Engine.Map.Team

-- 存储同步状态的表
local syncState = {
    gameState = {
        lastSerialized = "",
        timerId = nil
    },
    userProfile = {} -- 用于存储每个玩家的用户数据状态
}

-- 序列化表为字符串用于比较
local function serializeTable(tbl)
    if type(tbl) ~= "table" then
        return tostring(tbl)
    end

    local result = {}
    for k, v in pairs(tbl) do
        local keyStr = type(k) == "string" and '"' .. k .. '"' or tostring(k)
        local valStr = type(v) == "table" and serializeTable(v) or
            type(v) == "string" and '"' .. v .. '"' or tostring(v)
        table.insert(result, "[" .. keyStr .. "]=" .. valStr)
    end
    return "{" .. table.concat(result, ",") .. "}"
end

-- 通用的数据同步函数，支持脏检查和定时同步
local function syncDataWithDirtyCheck(currentData, namespace, category, key,
                                      stateRef, logMessage)
    -- 序列化当前数据用于比较
    local currentDataSerialized = serializeTable(currentData)

    -- 检查数据是否发生变化
    local dataChanged = (stateRef.lastSerialized ~= currentDataSerialized)

    -- 如果数据有变化，更新上次数据记录并立即发送
    if dataChanged then
        -- 更新上次数据记录
        stateRef.lastSerialized = currentDataSerialized

        -- 立即发送数据
        UDK.Property.SetProperty(namespace, category, key, currentData)
        --Log:PrintServerLog(logMessage .. " (Changed)")
    end

    -- 如果数据没有变化且没有设置定时广播，则设置一个1秒后广播的定时器
    if not dataChanged and not stateRef.timerId then
        stateRef.timerId = TimerManager:AddTimer(1, function()
            -- 发送当前数据
            UDK.Property.SetProperty(namespace, category, key, currentData)
            --Log:PrintServerLog(logMessage .. " (Timer)")

            -- 清除定时器ID
            stateRef.timerId = nil
        end)
    end
end

-- 获取玩家的经验需求值
local function getPlayerExpReq(playerID)
    local playerLevelIsMax = UDK.Property.GetProperty(playerID, KeyMap.PState.PlayerLevelIsMax[1],
        KeyMap.PState.PlayerLevelIsMax[2])
    local playerExpReq = Framework.Tools.LightDMS.GetCustomProperty(
        KeyMap.GameState.PlayerExpReq[1],
        KeyMap.GameState.PlayerExpReq[2],
        false,
        playerID
    )
    if type(playerExpReq) == "number" then
        if playerLevelIsMax then
            return "Max"
        end
        return playerExpReq
    end
    return 0
end

---| 🎮 - 同步服务器游戏状态数据
---<br>
---| `范围`：`服务端`
function NetSync.SyncServerGameState()
    local data = {
        Game = {
            PlayTime = UDK.Timer.GetTimerTime(TimerMap.GameRound) or 0,
            GameStage = Framework.Tools.Utils.GetGameStage(),
            TaskCount = UDK.Array.GetLength(Config.Engine.Task.TaskList) or 0,
            TaskFinishedCount = 0,
        },
        Team = {
            RedTeam = {
                Score = #Team:GetTeamPlayerArray(TeamIDMap.Red)
            },
            BlueTeam = {
                Score = #Team:GetTeamPlayerArray(TeamIDMap.Blue)
            }
        }
    }

    syncDataWithDirtyCheck(
        data,
        KeyMap.ServerState.NameSpace,
        KeyMap.ServerState.GameState[1],
        KeyMap.ServerState.GameState[2],
        syncState.gameState,
        "GameState Synced"
    )
end

---| 🎮 - 同步玩家个人信息
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function NetSync.SyncUserProfile(playerID)
    local data = {
        Player = {
            ID = playerID,
            TeamID = Team:GetTeamById(playerID)
        },
        GameData = {
            Level = UDK.Property.GetProperty(playerID, KeyMap.PState.PlayerLevel[1], KeyMap.PState.PlayerLevel[2]),
            LevelIsMax = UDK.Property.GetProperty(playerID, KeyMap.PState.PlayerLevelIsMax[1],
                KeyMap.PState.PlayerLevelIsMax[2]),
            Exp = UDK.Property.GetProperty(playerID, KeyMap.PState.PlayerExp[1], KeyMap.PState.PlayerExp[2]),
            ReqExp = getPlayerExpReq(playerID),
            Currency = {
                Coin = Currency:GetCurrencyCount(playerID),
                StarCoin = 0,
                SliverCoin = 0,
            }
        },
        CloudData = {
            Match = {
                Win = UDK.Property.GetProperty(playerID, KeyMap.PState.GameRoundWin[1], KeyMap.PState.GameRoundWin[2]),
                Lose = UDK.Property.GetProperty(playerID, KeyMap.PState.GameRoundLose[1], KeyMap.PState.GameRoundLose[2]),
                Draw = UDK.Property.GetProperty(playerID, KeyMap.PState.GameRoundDraw[1], KeyMap.PState.GameRoundDraw[2]),
                Escape = UDK.Property.GetProperty(playerID, KeyMap.PState.GameRoundEscape[1],
                    KeyMap.PState.GameRoundEscape[2]),
                TotalRound = UDK.Property.GetProperty(playerID, KeyMap.PState.GameRoundTotal[1],
                    KeyMap.PState.GameRoundTotal[2]),
            },
        }
    }

    -- 确保该玩家的状态表存在
    if not syncState.userProfile[playerID] then
        syncState.userProfile[playerID] = {
            lastSerialized = "",
            timerId = nil
        }
    end

    syncDataWithDirtyCheck(
        data,
        playerID,
        KeyMap.UserData.AccountProfile[1],
        KeyMap.UserData.AccountProfile[2],
        syncState.userProfile[playerID],
        "UserProfile Synced for player " .. tostring(playerID)
    )
end

---| 🎮 - 同步局内排行榜数据
---<br>
---| `范围`：`服务端`
function NetSync.SyncRankListData()
    -- 委托给Rank模块处理排行榜同步
    Rank.SyncRankListData()
end

return NetSync
