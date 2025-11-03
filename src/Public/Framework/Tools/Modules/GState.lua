-- ==================================================
-- * Campfire Project | Framework/Tools/Modules/GState.lua
-- *
-- * Info:
-- * Campfire Project Framework GameState Implement
-- *
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

function GState.CHandle_SetCharacterModelByNPC(playerID, data)
    Character:SetCharacterWithCreature(playerID, data.creatureID)
end

function GState.CHandle_ReconnectInit(playerID, data)
    --Framework.Common.Init.OnBeginPlay()
    --Gamelogic.Client.Init()
end

return GState
