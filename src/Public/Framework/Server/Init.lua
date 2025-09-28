-- ==================================================
-- * Campfire Project | Framework/Server/Init.lua
-- *
-- * Info:
-- * Campfire Project Framework Server Init
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local ServerInit = {}
local KeyMap = Config.Engine.Property.KeyMap
local TimerMap = Config.Engine.Map.Timer
local GameStageMap = Config.Engine.Map.GameStage

-- 玩家属性初始化
local function playerPropertyInit(playerID)
    local cloudInitStatus = UDK.Storage.ArchiveGet(playerID, KeyMap.CloudData.InitStatus[1],
        KeyMap.CloudData.InitStatus[2])
    -- 如果玩家未初始化和云存储相关的持久化数据，则进行初始化，否则则读取数据并赋值给玩家
    if cloudInitStatus == nil or cloudInitStatus == false then
        cloudInitStatus = UDK.Property.SetProperty(playerID, KeyMap.CloudData.InitStatus[1],
            KeyMap.CloudData.InitStatus[2], true)
        UDK.Storage.ArchiveUpload(playerID, KeyMap.CloudData.InitStatus[1], KeyMap.CloudData.InitStatus[2],
            cloudInitStatus)
        -- 遍历PSetting中的所有属性并初始化
        for _, value in pairs(KeyMap.PSetting) do
            UDK.Property.SetProperty(playerID, value[1], value[2], value[3])
            UDK.Storage.ArchiveUpload(playerID, value[1], value[2], value[3])
            --print("玩家属性初始化: " .. value[1] .. " = " .. tostring(value[3]) .. " | " .. value[2])
        end
        -- 遍历PState中的所有属性并初始化
        for _, value in pairs(KeyMap.PState) do
            UDK.Property.SetProperty(playerID, value[1], value[2], value[3])
            UDK.Storage.ArchiveUpload(playerID, value[1], value[2], value[3])
            --print("玩家状态初始化: " .. value[1] .. " = " .. tostring(value[3]) .. " | " .. value[2])
        end
    else
        -- 遍历PSetting中的所有属性并初始化
        for _, value in pairs(KeyMap.PSetting) do
            UDK.Storage.ArchiveGet(playerID, value[1], value[2])
            UDK.Property.SetProperty(playerID, value[1], value[2], value[3])
        end
        -- 遍历PState中的所有属性并初始化
        for _, value in pairs(KeyMap.PState) do
            UDK.Storage.ArchiveGet(playerID, value[1], value[2])
            UDK.Property.SetProperty(playerID, value[1], value[2], value[3])
        end
    end
end

-- 玩家IM频道初始化
local function playerIMChannelInit(playerID)
    local pTChatIsTeam = UDK.Property.GetProperty(playerID, KeyMap.PSetting.TeamChat[1], KeyMap.PSetting.TeamChat[2])
    local pVChatIsTeam = UDK.Property.GetProperty(playerID, KeyMap.PSetting.TeamChat[1], KeyMap.PSetting.TeamChat[2])
    local playerTeam = Team:GetTeamById(playerID)
    local playerTeamPlayers = Team:GetTeamPlayerArray(playerTeam)
    local allPlayers = UDK.Player.GetAllPlayers()
    if pTChatIsTeam then
        Chat:SetCanReceivePlayersTextChat({ playerID }, playerTeamPlayers)
    else
        Chat:SetCanReceivePlayersTextChat({ playerID }, allPlayers)
    end
    if pVChatIsTeam then
        Chat:SetCanReceivePlayersVoiceChat({ playerID }, playerTeamPlayers)
    else
        Chat:SetCanReceivePlayersVoiceChat({ playerID }, allPlayers)
    end
end

-- 游戏时间管理器初始化
local function gameTimeManagerInit()
    UDK.Timer.StartBackwardTimer(TimerMap.GameRound, Config.Engine.Core.Game.RoundPreparationTime)
    local timerID
    Framework.Server.Aliza.BoardcastSystemMsg("现在是准备阶段，10秒后开始游戏")
    timerID = TimerManager:AddLoopTimer(0.5, function()
        local TimerTime = UDK.Timer.GetTimerTime(TimerMap.GameRound)
        if TimerTime <= 0 then
            TimerManager:RemoveTimer(timerID)
            TimerManager:AddTimer(3, function()
                print("测试")
            end)
            print("游戏开始")
        else
            --print("游戏时间：" .. TimerTime)
        end
    end)
end

-- 游戏功能初始化
local function gameFeatureInit()
    local envInfo = Framework.Tools.Utils.GetEnvInfo()
    if envInfo.isStandalone then
        Framework.Server.Aliza.BoardcastSystemMsg("检测到单机环境，将禁用IM功能")
        Framework.Server.Aliza.BoardcastSystemMsg("系统将禁用大部分功能，请创建房间后游玩")
        Framework.Server.Aliza.BoardcastSystemMsg("该模式下您可以游览地图，但无法进行游戏")
        Framework.Tools.Utils.SetGameStage(GameStageMap.DisableGameFeature)
    else
        Framework.Tools.Utils.SetGameStage(GameStageMap.Ready)
    end
end

---| 🎮 服务器游戏逻辑初始化
---<br>
---| `范围`：`服务端`
function ServerInit.InitGame()
    gameFeatureInit()
    gameTimeManagerInit()
    for _, v in ipairs(UDK.Player.GetAllPlayers()) do
        playerPropertyInit(v)
        playerIMChannelInit(v)
    end
end

---| 🎮 重置玩家设置属性数据
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param resetType string 重置类型（PSetting, PState, All）
function ServerInit.ResetSetting(playerID, resetType)
    if resetType == "PSetting" or resetType == "All" then
        -- 遍历PSetting中的所有属性并初始化
        for _, value in pairs(KeyMap.PSetting) do
            UDK.Storage.ArchiveUpload(playerID, value[1], value[2], value[3])
            UDK.Property.SetProperty(playerID, value[1], value[2], value[3])
        end
    end
    if resetType == "PState" or resetType == "All" then
        -- 遍历PState中的所有属性并初始化
        for _, value in pairs(KeyMap.PState) do
            UDK.Storage.ArchiveUpload(playerID, value[1], value[2], value[3])
            UDK.Property.SetProperty(playerID, value[1], value[2], value[3])
        end
    end
end

return ServerInit
