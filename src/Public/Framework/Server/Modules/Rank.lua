-- ==================================================
-- * Campfire Project | Framework/Server/Modules/Rank.lua
-- *
-- * Info:
-- * Campfire Project Framework Server Rank - RankList Manager
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Rank = {}

local KeyMap = Config.Engine.Property.KeyMap
local StatusCodeMap = Config.Engine.Map.Status

-- 存储上次排行榜数据的序列化字符串，用于比较数据变化
local lastRankListDataSerialized = ""

-- 定时广播排行榜数据的定时器
local rankListBroadcastTimer = nil

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

-- 生成排行榜数据列
local function rankDataColumnGenerate(playerID)
    local playerStatus = Framework.Tools.LightDMS.GetCustomProperty(
        KeyMap.GameState.PlayerStatus[1],
        KeyMap.GameState.PlayerStatus[2],
        false,
        playerID
    )
    local status = StatusCodeMap.Missing.ID
    if type(playerStatus) == "number" then
        status = playerStatus
    end
    local score = Team:GetPlayerCurrentScore(playerID)
    local teamID = Team:GetTeamById(playerID)
    return {
        PlayerID = playerID,
        Score = score,
        Status = status,
        TeamID = teamID
    }
end

-- 根据玩家ID列表自动生成排行榜数据列
local function rankDataGenerateByPlayerIDs(playerIDs)
    local result = {}

    for _, playerID in ipairs(playerIDs) do
        local rankData = rankDataColumnGenerate(playerID)
        --print(rankData)
        table.insert(result, rankData)
    end

    return result
end

function Rank.SyncRankListData()
    local data = rankDataGenerateByPlayerIDs(UDK.Player.GetAllPlayers())

    -- 序列化当前数据用于比较
    local currentDataSerialized = serializeTable(data)

    -- 检查数据是否发生变化
    local dataChanged = (lastRankListDataSerialized ~= currentDataSerialized)

    -- 如果数据有变化，更新上次数据记录
    if dataChanged then
        lastRankListDataSerialized = currentDataSerialized
        -- 立即发送数据
        UDK.Property.SetProperty(
            KeyMap.ServerState.NameSpace,
            KeyMap.ServerState.RankList[1],
            KeyMap.ServerState.RankList[2],
            data
        )
        Log:PrintServerLog("RankList Synced")
    end

    -- 如果还没有设置定时广播，则设置一个
    if not rankListBroadcastTimer and not dataChanged then
        rankListBroadcastTimer = true

        -- 设置定时器，定期广播数据（无论数据是否变化）
        local timer
        timer = TimerManager:AddLoopTimer(1, function()
            -- 发送当前数据
            UDK.Property.SetProperty(
                KeyMap.ServerState.NameSpace,
                KeyMap.ServerState.RankList[1],
                KeyMap.ServerState.RankList[2],
                data
            )
            rankListBroadcastTimer = false
            --Log:PrintServerLog("RankList Synced Late")
            TimerManager:RemoveTimer(timer)
        end)
    end
end

return Rank
