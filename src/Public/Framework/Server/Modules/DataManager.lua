-- ==================================================
-- * Campfire Project | Framework/Server/Modules/DataManager.lua
-- *
-- * Info:
-- * Campfire Project Framework Server Data - DataManager
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local DataManager = {}
local KeyMap = Config.Engine.Property.KeyMap

-- 更新对局数据
local function updateMatchData(updPlayerID, updType, updMode, updValue)
    local queryTypeKeyMap, matchData, totalRound
    if updType == "Win" then
        queryTypeKeyMap = KeyMap.PState.GameRoundWin
    elseif updType == "Lose" then
        queryTypeKeyMap = KeyMap.PState.GameRoundLose
    elseif updType == "Draw" then
        queryTypeKeyMap = KeyMap.PState.GameRoundDraw
    elseif updType == "Escape" then
        queryTypeKeyMap = KeyMap.PState.GameRoundEscape
    end

    totalRound = UDK.Property.GetProperty(updPlayerID, KeyMap.PState.GameRoundTotal[1], KeyMap.PState.GameRoundTotal[2])
    matchData = UDK.Property.GetProperty(updPlayerID, queryTypeKeyMap[1], queryTypeKeyMap[2])
    if updMode == "Add" then
        matchData = matchData + updValue
        totalRound = totalRound + updValue
        -- 确保不会出现负数
        matchData = math.max(0, matchData)
        totalRound = math.max(0, totalRound)
    elseif updMode == "Sub" then
        matchData = matchData - updValue
        if matchData <= 0 then
            matchData = 0
        else
            totalRound = totalRound - updValue
        end
    elseif updMode == "Set" then
        local oldValue = matchData
        matchData = updValue
        -- 确保设置的值不会是负数
        matchData = math.max(0, matchData)
        -- 正确计算totalRound的变化
        totalRound = totalRound - oldValue + matchData
        -- 确保totalRound不会是负数
        totalRound = math.max(0, totalRound)
    end

    UDK.Property.SetProperty(updPlayerID, queryTypeKeyMap[1], queryTypeKeyMap[2], matchData)
    UDK.Property.SetProperty(updPlayerID, KeyMap.PState.GameRoundTotal[1], KeyMap.PState.GameRoundTotal[2], totalRound)
    UDK.Storage.ArchiveUpload(updPlayerID, queryTypeKeyMap[1], queryTypeKeyMap[2], matchData)
    UDK.Storage.ArchiveUpload(updPlayerID, KeyMap.PState.GameRoundTotal[1], KeyMap.PState.GameRoundTotal[2], totalRound)
end

---| 🎮 玩家对局数据管理
---@param playerID number 玩家ID
---@param type string 玩家对局数据类型（Win | Lose | Draw | Escape）
---@param mode string 玩家对局数据模式（Add | Sub | Set）
---@param value number 玩家对局数据值
function DataManager.PlayerMatchDataManager(playerID, type, mode, value)
    updateMatchData(playerID, type, mode, value)
end

function DataManager.PlayerTeamScoreManager()

end

function DataManager.PlayerLevel()
    
end

return DataManager