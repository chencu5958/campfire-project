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
local TeamIDMap = Config.Engine.Map.Team

-- 玩家属性初始化
local function playerPropertyInit(playerID)
    local cloudInitStatus = UDK.Storage.ArchiveGet(playerID, KeyMap.CloudData.InitStatus[1],
        KeyMap.CloudData.InitStatus[2])
    local accessLevel = UDK.Property.ACCESS_LEVEL.ServerOnly
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
            UDK.Property.SetProperty(playerID, value[1], value[2], value[3], accessLevel)
            UDK.Storage.ArchiveUpload(playerID, value[1], value[2], value[3])
            --local data = UDK.Storage.ArchiveGet(playerID, value[1], value[2])
            --print("玩家状态初始化: " .. value[1] .. " = " .. tostring(value[3]) .. " | " .. value[2])
        end
    else
        -- 遍历PSetting中的所有属性并初始化
        for _, value in pairs(KeyMap.PSetting) do
            local cloudValue = UDK.Storage.ArchiveGet(playerID, value[1], value[2])
            UDK.Property.SetProperty(playerID, value[1], value[2], cloudValue)
        end
        -- 遍历PState中的所有属性并初始化
        for _, value in pairs(KeyMap.PState) do
            local cloudValue = UDK.Storage.ArchiveGet(playerID, value[1], value[2])
            UDK.Property.SetProperty(playerID, value[1], value[2], cloudValue, accessLevel)
        end
    end
    -- GameState部分数据初始化
    for _, value in pairs(KeyMap.GameState) do
        if value[3] ~= nil then
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

-- 玩家生命初始化
local function playerLifeInit(playerID)
    local playerTeam = Team:GetTeamById(playerID)
    local lifeConf = Config.Engine.Core.Team
    if playerTeam == TeamIDMap.Red then
        Damage:ModifyCharacterMaxLifeCount(playerID, lifeConf.Red.MaxLife - 1)
        Damage:ModifyCharacterLifeCount(playerID, lifeConf.Red.AddLife)
        Damage:ModifyCharacterMaxHealth(playerID, lifeConf.Red.MaxHealth - 1)
        Damage:ModifyCharacterHealth(playerID, lifeConf.Red.AddHealth)
    elseif playerTeam == TeamIDMap.Blue then
        Damage:ModifyCharacterMaxLifeCount(playerID, lifeConf.Blue.MaxLife - 1)
        Damage:ModifyCharacterLifeCount(playerID, lifeConf.Blue.AddLife)
    end
end

-- 游戏核心系统初始化（包括功能开关和时间管理器）
local function gameCoreSystemInit()
    local envInfo = Framework.Tools.Utils.GetEnvInfo()
    if envInfo.isStandalone then
        Framework.Server.Aliza.BoardcastSystemMsg("检测到单机环境，将禁用IM功能")
        Framework.Server.Aliza.BoardcastSystemMsg("系统将禁用大部分功能，请创建房间后游玩")
        Framework.Server.Aliza.BoardcastSystemMsg("该模式下您可以游览地图，但无法进行游戏")
        Framework.Tools.Utils.SetGameStage(GameStageMap.DisableGameFeature)
    else
        Framework.Tools.Utils.SetGameStage(GameStageMap.Ready)
    end

    -- 根据游戏阶段初始化功能开关
    Framework.Server.GameFeatureManager.AutoInit(Framework.Tools.Utils.GetGameStage())
    local gameStage = Framework.Tools.Utils.GetGameStage()
    if gameStage == GameStageMap.DisableGameFeature then
        return
    end
    -- 检查玩家人数
    local reasonCodeMap = Config.Engine.Map.GameReasonCode
    local isEnough, reasonCode = Framework.Server.Utils.CheckGamePlayerCount()
    local returnCode, fmt_Message
    if not isEnough and reasonCode == reasonCodeMap.PlayerCountCheck.NotEnough then
        fmt_Message = "玩家人数不足，当前只有1名玩家，无法开始"
        returnCode = "NotEnough"
    elseif not isEnough and reasonCode == reasonCodeMap.PlayerCountCheck.RedTeamNotEnough then
        fmt_Message = string.format("%s 玩家数不足，15秒后自动结束游戏", "农场主")
        returnCode = "RedTeamNotEnough"
    elseif not isEnough and reasonCode == reasonCodeMap.PlayerCountCheck.BlueTeamNotEnough then
        fmt_Message = string.format("%s 玩家数不足，15秒后自动结束游戏", "捣蛋鬼")
        returnCode = "BlueTeamNotEnough"
    end
    if returnCode ~= nil then
        Framework.Tools.Utils.SetGameStage(GameStageMap.DisableGameFeature)
        Framework.Server.Aliza.BoardcastSystemMsg(fmt_Message)
        if returnCode == "NotEnough" then
            Framework.Server.Aliza.BoardcastSystemMsg("游戏将在15秒后自动结束")
        end
        TimerManager:AddTimer(15, function()
            Character:SetCampVictory(TeamIDMap.Red)
            Character:SetCampVictory(TeamIDMap.Blue)
        end)
    end
    if isEnough and reasonCode == reasonCodeMap.PlayerCountCheck.CheckApproved then
        -- 初始化游戏时间管理器
        UDK.Timer.StartBackwardTimer(TimerMap.GameRound, Config.Engine.Core.Game.RoundPreparationTime)
        local timerID
        Framework.Server.Aliza.BoardcastSystemMsg("现在是准备阶段，10秒后开始游戏")
        timerID = TimerManager:AddLoopTimer(0.5, function()
            local TimerTime = UDK.Timer.GetTimerTime(TimerMap.GameRound)
            if TimerTime <= 0 then
                TimerManager:RemoveTimer(timerID)
                TimerManager:AddTimer(0.1, function()
                    Framework.Tools.Utils.SetGameStage(GameStageMap.Start)
                    Framework.Server.GameFeatureManager.AutoInit(GameStageMap.Start)
                    Framework.Server.Aliza.BoardcastSystemMsg("当前人数满足游戏开始条件，游戏开始")
                    Framework.Server.Aliza.BoardcastSystemMsg("点击右侧UI按钮展开查看任务目标")
                    local callback = function()
                        --print("游戏开始")
                    end
                    UDK.Timer.StartBackwardTimer(TimerMap.GameRound, Config.Engine.Core.Game.RoundTime, false, "s", true,
                        callback)
                end)
            else
                --print("游戏时间：" .. TimerTime)
            end
        end)
    end
end

---| 🎮 服务器游戏玩家逻辑初始化
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function ServerInit.InitGame(playerID)
    playerLifeInit(playerID)
    playerPropertyInit(playerID)
    playerIMChannelInit(playerID)
end

---| 🎮 服务器游戏核心逻辑初始化
---<br>
---| `范围`：`服务端`
function ServerInit.InitGameCore()
    gameCoreSystemInit()
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
