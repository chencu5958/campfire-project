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
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param type string 玩家对局数据类型（Win | Lose | Draw | Escape）
---@param mode string 玩家对局数据模式（Add | Sub | Set）
---@param value number 玩家对局数据值
function DataManager.PlayerMatchDataManager(playerID, type, mode, value)
    updateMatchData(playerID, type, mode, value)
end

---| 🎮 玩家团队分数管理
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param value number 玩家团队分数值
---@param mode string 玩家团队分数模式（Add | Sub | Set）
function DataManager.PlayerTeamScoreManager(playerID, value, mode)
    local playerScore = Team:GetPlayerCurrentScore(playerID)
    if mode == "Add" then
        playerScore = playerScore + value
    elseif mode == "Sub" then
        playerScore = playerScore - value
    elseif mode == "Set" then
        playerScore = value
    end
    Team:SetPlayerScore(playerID, playerScore)
end

---| 🎮 玩家等级经验管理
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param value number 玩家等级经验值
---@param mode string 玩家等级经验模式（Add | Sub | Set）
function DataManager.PlayerLevelExpManager(playerID, value, mode)
    local playerExp = UDK.Property.GetProperty(playerID, KeyMap.PState.PlayerExp[1], KeyMap.PState.PlayerExp[2])
    if mode == "Add" then
        playerExp = playerExp + value
    elseif mode == "Sub" then
        playerExp = playerExp - value
    elseif mode == "Set" then
        playerExp = value
    end
    UDK.Property.SetProperty(playerID, KeyMap.PState.PlayerExp[1], KeyMap.PState.PlayerExp[2], playerExp)
    UDK.Storage.ArchiveUpload(playerID, KeyMap.PState.PlayerExp[1], KeyMap.PState.PlayerExp[2], playerExp)
end

---| 🎮 玩家经济管理
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param type string 玩家经济类型（Coin）
---@param value number 玩家经济值
---@param mode string 玩家经济模式（Add | Sub）
function DataManager.PlayerEcomonyManager(playerID, type, value, mode)
    if mode == "Add" then
        if type == "Coin" then
            Currency:AddCurrencyCount(playerID, value)
        end
    end
    if mode == "Sub" then
        if type == "Coin" then
            Currency:ReduceCurrencyCount(playerID, value)
        end
    end
end

---| 🎮 玩家存档上传
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function DataManager.PlayerArchiveUpload(playerID)
    -- 遍历PSetting中的所有属性并上传
    for _, value in pairs(KeyMap.PSetting) do
        local uploadValue = UDK.Property.GetProperty(playerID, value[1], value[2])
        UDK.Storage.ArchiveUpload(playerID, value[1], value[2], uploadValue)
        --print("玩家属性上传云存档 " .. value[1] .. " = " .. tostring(value[3]) .. " | " .. value[2])
    end
    -- 遍历PState中的所有属性并上传
    for _, value in pairs(KeyMap.PState) do
        local uploadValue = UDK.Property.GetProperty(playerID, value[1], value[2])
        UDK.Storage.ArchiveUpload(playerID, value[1], value[2], uploadValue)
        if value == KeyMap.PState.PlayerLevel then
            local playerLevel = UDK.Property.GetProperty(playerID, value[1], value[2])
            local rankIndex = Config.Engine.Map.Rank.GRank_Level
            Rank:SetRankById(rankIndex, playerID, playerLevel)
        end
        --print("玩家状态上传云存档: " .. value[1] .. " = " .. tostring(value[3]) .. " | " .. value[2])
    end

    local playerCoin = Currency:GetCurrencyCount(playerID)
    local rankIndex = Config.Engine.Map.Rank.GRank_Economy
    Rank:SetRankById(rankIndex, playerID, playerCoin)
end

return DataManager
