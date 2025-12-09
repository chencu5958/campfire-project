-- ==================================================
-- * Campfire Project | Framework/Tools/Modules/GState.lua
-- *
-- * Info:
-- * Campfire Project Framework GameState Implement
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local GState = {}
local KeyMap = Config.Engine.Property.KeyMap
local TeamIDMap = Config.Engine.Map.Team

local function GStateLogGenerate(log)
    local reqTimestamp = UDK.Math.GetTimestamp()
    local logStr = string.format("[GState:%s] %s (TimeStamp: %s | ApiType: %s)", log.apiName, log.logContent,
        reqTimestamp, log.apiType)
    if log.logLevel == "Error" then
        Log:PrintError(logStr)
    elseif log.logLevel == "Server" then
        Log:PrintServerLog(logStr)
    else
        Log:PrintLog(logStr)
    end
end

---| 🎮 - 游戏设置 - 重置设置
---
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param data table 请求数据
function GState.SHandle_ResetSetting(playerID, data)
    local envInfo = Framework.Tools.Utils.GetEnvInfo()
    local reqData = data or {}
    local logData
    if envInfo == Framework.Tools.Utils.Conf.EnvType.Client.ID then
        logData = {
            apiName = "ResetSetting",
            apiType = "ServerAPI",
            logContent = "该API只允许在服务端侧调用！",
            logLevel = "Error"
        }
        GStateLogGenerate(logData)
        return
    end
    local playerName = UDK.Player.GetPlayerNickName(playerID)
    logData = {
        apiName = "ResetSetting",
        apiType = "ServerAPI",
        logContent = string.format("玩家 %s 请求重置设置.", playerName),
        logLevel = "Server"
    }
    GStateLogGenerate(logData)
    if reqData.type == nil then
        reqData.type = "PSetting"
    end
    Framework.Server.Init.ResetSetting(playerID, reqData.type)
end

---| 🎮 - 聊天系统 - 聊天范围切换
---
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param data table 请求数据
function GState.SHandle_IMRecvToggle(playerID, data)
    if data.channelType == "Chat" then
        local playerTeam, teamPlayerIDs = Team:GetTeamById(playerID)
        if playerTeam == TeamIDMap.Red and data.isTeam then
            teamPlayerIDs = Team:GetTeamPlayerArray(playerTeam)
        elseif playerTeam == TeamIDMap.Blue and data.isTeam then
            teamPlayerIDs = Team:GetTeamPlayerArray(playerTeam)
        else
            teamPlayerIDs = UDK.Player.GetAllPlayers()
        end
        Chat:SetCanReceivePlayersTextChat({ playerID }, teamPlayerIDs)
    end
    if data.channelType == "Voice" then
        local playerTeam, teamPlayerIDs = Team:GetTeamById(playerID)
        if playerTeam == TeamIDMap.Red and data.isTeam then
            teamPlayerIDs = Team:GetTeamPlayerArray(playerTeam)
        elseif playerTeam == TeamIDMap.Blue and data.isTeam then
            teamPlayerIDs = Team:GetTeamPlayerArray(playerTeam)
        else
            teamPlayerIDs = UDK.Player.GetAllPlayers()
        end
        Chat:SetCanReceivePlayersVoiceChat({ playerID }, teamPlayerIDs)
    end
end

---| 🎮 - 任务系统 - 做任务
---
---| `范围`：`服务端`
---@param playerID number 玩家ID
function GState.SHandle_TaskSysDoTask(playerID)
    local isClaim = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerTaskClaimStatus[1],
        KeyMap.GameState.PlayerTaskClaimStatus[2]
    )
    local isInTaskArea = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerIsInTaskArea[1],
        KeyMap.GameState.PlayerIsInTaskArea[2]
    )
    local currentSignalBox = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerCurrentSignalBox[1],
        KeyMap.GameState.PlayerCurrentSignalBox[2]
    )

    -- 增强验证：确保玩家在正确的任务区域内
    local canStartTask = false
    local taskID = 0
    local correctSignalBox = 0

    if isClaim == 1 and isInTaskArea == 1 then
        -- 验证玩家是否有已领取的任务且在正确的任务区域
        local taskConfig = Config.Engine.Task
        for i = #taskConfig.TaskList, 1, -1 do
            if taskConfig.TaskList[i].Status.TaskCode == taskConfig.TaskCode.Claimed and
                taskConfig.TaskList[i].Status.ClaimedUIN == playerID then
                taskID = taskConfig.TaskList[i].ID
                correctSignalBox = taskConfig.TaskList[i].BindID.SignalBox

                -- 只有当玩家在正确的信号盒内时才允许开始任务
                if currentSignalBox == correctSignalBox and currentSignalBox ~= 0 then
                    canStartTask = true
                end
                break
            end
        end
    end

    if canStartTask then
        UDK.Property.SetProperty(
            playerID,
            KeyMap.GameState.PlayerIsDoTask[1],
            KeyMap.GameState.PlayerIsDoTask[2],
            1
        )
        print("[GState] TaskStarted: Player " ..
        playerID .. " started task " .. taskID .. " in correct area (SignalBox: " .. currentSignalBox .. ")")
    else
        print("[GState] TaskStartDenied: Player " ..
        playerID ..
        " cannot start task. isClaim=" ..
        isClaim ..
        ", isInTaskArea=" ..
        isInTaskArea .. ", currentSignalBox=" .. (currentSignalBox or "nil") .. ", correctSignalBox=" .. correctSignalBox)
    end
end

---| 🎮 - 角色系统 - 设置角色模型
---
---| `范围`：`客户端`
---@param playerID number 玩家ID
---@param data table 请求数据
function GState.CHandle_SetCharacterModelByNPC(playerID, data)
    Character:SetCharacterWithCreature(playerID, data.creatureID)
end

function GState.CHandle_ReconnectInit(playerID, data)
    --Framework.Common.Init.OnBeginPlay()
    --Gamelogic.Client.Init()
end

return GState
