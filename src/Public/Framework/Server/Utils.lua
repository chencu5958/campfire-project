-- ==================================================
-- * Campfire Project | Framework/Server/Utils.lua
-- *
-- * Info:
-- * Campfire Project Framework Server Utils
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Utils = {}
local KeyMap = Config.Engine.Property.KeyMap
local TeamIDMap = Config.Engine.Map.Team
local StatusCodeMap = Config.Engine.Map.Status

-- 存储玩家心跳检测定时器ID的表
local playerHeartbeatTimers = {}

local victoryCheckLock = false

-- 玩家断线检查
local function playerDisconnectCheck(playerID)
    -- 检查是否已经存在该玩家的心跳检测定时器
    if playerHeartbeatTimers[playerID] then
        --Log:PrintServerLog("Heartbeat check already exists for player: " .. playerID)
        return
    end
    local accessLevel = UDK.Property.ACCESS_LEVEL.ServerOnly

    local timeoutCallback = function()
        --Log:PrintServerLog("Player:", UDK.Player.GetPlayerNickName(playerID), "is disconnected")
        UDK.Property.SetProperty(
            playerID,
            KeyMap.GameState.PlayerIsDisconnect[1],
            KeyMap.GameState.PlayerIsDisconnect[2],
            true,
            accessLevel
        )
    end
    local responseCallback = function()
        --Log:PrintServerLog("Player:", UDK.Player.GetPlayerNickName(playerID), "is still connected")
        UDK.Property.SetProperty(
            playerID,
            KeyMap.GameState.PlayerIsDisconnect[1],
            KeyMap.GameState.PlayerIsDisconnect[2],
            false,
            accessLevel
        )
    end

    -- 发送心跳检测，并设置定时器，5秒后再次检测
    UDK.Heartbeat.SendWithTracking(playerID, timeoutCallback, responseCallback)
    --Log:PrintServerLog("Setting up heartbeat check for player: " .. playerID)
    playerHeartbeatTimers[playerID] = TimerManager:AddTimer(5, function()
        --Log:PrintServerLog("Removing heartbeat check for player: " .. playerID)
        playerHeartbeatTimers[playerID] = nil
    end)
end

-- 玩家图标显示器位置修正
local function playerBindDisplayPosCorr(playerID, displayID, displayType)
    local playerPos = Character:GetPosition(playerID)
    local offsetPos_HPBar = Config.Engine.GameInstance.Offset.Icon_Dsp_PlayerHP_Bar
    local offsetPos_Team = Config.Engine.GameInstance.Offset.Icon_Dsp_Team
    local offsetPos_playerHP = UMath:GetPosOffset(playerPos, offsetPos_HPBar.X, offsetPos_HPBar.Y, offsetPos_HPBar.Z)
    local offsetPos_TeamIcon = UMath:GetPosOffset(playerPos, offsetPos_Team.X, offsetPos_Team.Y, offsetPos_Team.Z)
    if displayType == "PlayerHP_Bar" then
        Element:SetPosition(displayID, offsetPos_playerHP, Element.COORDINATE.World)
    elseif displayType == "PlayerTeam_Tag" then
        Element:SetPosition(displayID, offsetPos_TeamIcon, Element.COORDINATE.World)
    end
end

-- 玩家图标显示器更新
local function playerBindDisplayUpdate(playerID)
    local isExist = MiscService:IsObjectExist(MiscService.EQueryableObjectType.Player, playerID)
    local playerStatus = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerStatus[1],
        KeyMap.GameState.PlayerStatus[2]
    )
    local playerHPTagID = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerBindHPBarID[1],
        KeyMap.GameState.PlayerBindHPBarID[2]
    )
    local playerTeamTagID = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerBindTeamTagID[1],
        KeyMap.GameState.PlayerBindTeamTagID[2]
    )
    if type(playerHPTagID) == "number" and isExist then
        if playerStatus == StatusCodeMap.Alive.ID then
            UDK.UI.SetUIVisibility(playerHPTagID, true)
            local playerLifeMax = Damage:GetCharacterMaxLifeCount(playerID)
            local playerLife = Damage:GetCharacterLifeCount(playerID)
            local progress = UDK.Math.Percentage(playerLife, playerLifeMax, true)
            FuncElement:SetProgressBoardValue(playerHPTagID, progress)
            playerBindDisplayPosCorr(playerID, playerHPTagID, "PlayerHP_Bar")
        else
            UDK.UI.SetUIVisibility(playerHPTagID, false)
        end
    elseif type(playerHPTagID) == "number" and not isExist then
        UDK.UI.SetUIVisibility(playerHPTagID, false)
        Element:Destroy(playerHPTagID)
    end
    if type(playerTeamTagID) == "number" and isExist then
        if playerStatus == StatusCodeMap.Alive.ID then
            UDK.UI.SetUIVisibility(playerTeamTagID, true)
            playerBindDisplayPosCorr(playerID, playerTeamTagID, "PlayerTeam_Tag")
        else
            UDK.UI.SetUIVisibility(playerTeamTagID, false)
        end
    elseif type(playerTeamTagID) == "number" and not isExist then
        UDK.UI.SetUIVisibility(playerTeamTagID, false)
        Element:Destroy(playerTeamTagID)
    end
    return isExist
end

-- 玩家NPC模型ID生成
local function playerModelIDGenerate()
    local modelEntries = Config.Engine.GameInstance.NPCModel
    -- 将关联数组的键收集到一个索引数组中，以便可以随机选择
    local keys = {}
    for key, _ in pairs(modelEntries) do
        table.insert(keys, key)
    end
    -- 使用索引数组随机选择一个键
    local randomKey = keys[math.random(#keys)]
    local selectModel = modelEntries[randomKey]
    return selectModel
end

---| 🎮 - 玩家状态检查
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerStatusCheck(playerID)
    playerDisconnectCheck(playerID)
    local playerLife = Damage:GetCharacterLifeCount(playerID)
    local accessLevel = UDK.Property.ACCESS_LEVEL.ServerOnly
    local playerIsDisconnect = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerIsDisconnect[1],
        KeyMap.GameState.PlayerIsDisconnect[2]
    )
    local playerIsExist = MiscService:IsObjectExist(MiscService.EQueryableObjectType.Player, playerID)
    if playerLife <= 0 and not playerIsDisconnect then
        UDK.Property.SetProperty(
            playerID,
            KeyMap.GameState.PlayerStatus[1],
            KeyMap.GameState.PlayerStatus[2],
            StatusCodeMap.Dead.ID,
            accessLevel
        )
    elseif playerLife > 0 and not playerIsDisconnect then
        UDK.Property.SetProperty(
            playerID,
            KeyMap.GameState.PlayerStatus[1],
            KeyMap.GameState.PlayerStatus[2],
            StatusCodeMap.Alive.ID,
            accessLevel
        )
    elseif playerIsDisconnect then
        UDK.Property.SetProperty(
            playerID,
            KeyMap.GameState.PlayerStatus[1],
            KeyMap.GameState.PlayerStatus[2],
            StatusCodeMap.Disconnect.ID,
            accessLevel
        )
    elseif not playerIsExist then
        UDK.Property.SetProperty(
            playerID,
            KeyMap.GameState.PlayerStatus[1],
            KeyMap.GameState.PlayerStatus[2],
            StatusCodeMap.Exit.ID,
            accessLevel
        )
    end
end

---| 🎮 - 玩家图标显示器初始化
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerInGameDisplay(playerID)
    local accessLevel = UDK.Property.ACCESS_LEVEL.ServerOnly
    -- 为不同元素创建专门的绑定回调函数
    local function createCallBack(elementType)
        return function(elementID)
            --print("Spawned Element:", elementID, "for player:", playerID, "Type:", elementType)
            if elementType == "PlayerHP_Bar" then
                -- 处理玩家HP条的特殊逻辑
                UDK.Property.SetProperty(
                    playerID,
                    KeyMap.GameState.PlayerBindHPBarID[1],
                    KeyMap.GameState.PlayerBindHPBarID[2],
                    elementID,
                    accessLevel
                )
                Element:BindingToCharacterOrNPC(
                    elementID,
                    playerID,
                    Character.SOCKET_NAME.Head,
                    Character.SOCKET_MODE.KeepWorld
                )
            elseif elementType == "RedTeam" then
                UDK.Property.SetProperty(
                    playerID,
                    KeyMap.GameState.PlayerBindTeamTagID[1],
                    KeyMap.GameState.PlayerBindTeamTagID[2],
                    elementID,
                    accessLevel
                )
                Element:BindingToCharacterOrNPC(
                    elementID,
                    playerID,
                    Character.SOCKET_NAME.Head,
                    Character.SOCKET_MODE.KeepWorld
                )
            end
        end
    end

    local Rot, Scale = Engine.Rotator(0, 0, 0), Config.Engine.GameInstance.Scale.Icon_Dsp_PlayerHP_Bar
    local ScaleTeamIcon = Config.Engine.GameInstance.Scale.Icon_Dsp_Team
    local Replicate = true
    local playerPos = Character:GetPosition(playerID)
    local playerTeam = Team:GetTeamById(playerID)
    local offsetPos_HPBar = Config.Engine.GameInstance.Offset.Icon_Dsp_PlayerHP_Bar
    local offsetPos_Team = Config.Engine.GameInstance.Offset.Icon_Dsp_Team
    local offsetPos_playerHP = UMath:GetPosOffset(playerPos, offsetPos_HPBar.X, offsetPos_HPBar.Y, offsetPos_HPBar.Z)
    local offsetPos_TeamIcon = UMath:GetPosOffset(playerPos, offsetPos_Team.X, offsetPos_Team.Y, offsetPos_Team.Z)
    local playerHPTagID = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerBindHPBarID[1],
        KeyMap.GameState.PlayerBindHPBarID[2]
    )
    local playerTeamTagID = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerBindTeamTagID[1],
        KeyMap.GameState.PlayerBindTeamTagID[2]
    )

    if type(playerHPTagID) ~= "number" and playerTeam ~= TeamIDMap.Blue then
        Element:SpawnElement(
            Element.SPAWN_SOURCE.Scene, Config.Engine.GameInstance.Item.Icon_Dsp_PlayerHP_Bar,
            createCallBack("PlayerHP_Bar"),
            offsetPos_playerHP, Rot, Scale, Replicate
        )
    end
    if type(playerTeamTagID) ~= "number" and playerTeam ~= TeamIDMap.Blue then
        Element:SpawnElement(
            Element.SPAWN_SOURCE.Scene, Config.Engine.GameInstance.Item.Icon_Dsp_RedTeam, createCallBack("RedTeam"),
            offsetPos_TeamIcon, Rot, ScaleTeamIcon, Replicate
        )
    end
    local timerID
    timerID = TimerManager:AddLoopTimer(0.5, function()
        local isExist = playerBindDisplayUpdate(playerID)
        if not isExist then
            TimerManager:RemoveTimer(timerID)
        end
    end)
end

---| 🎮 - 玩家武器分配
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerWeaponAllocate(playerID)
    local playerTeam = Team:GetTeamById(playerID)
    if TeamIDMap.Red == playerTeam then
        Inventory:AddCustomItem(playerID, Config.Engine.GameInstance.Item.Item_Weapon_Hammer, 1)
        --Inventory:AddCustomItem(playerID, Config.Engine.GameInstance.Item.Item_Weapon_Gun, 1)
    end
end

---| 🎮 - 玩家模型分配
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerModelAllocate(playerID)
    local selectID = playerModelIDGenerate()
    local playerTeam = Team:GetTeamById(playerID)
    if selectID and playerTeam == TeamIDMap.Blue then
        UDK.Property.SetProperty(playerID, KeyMap.GameState.PlayerModelID[1], KeyMap.GameState.PlayerModelID[2], selectID)
        local stateAction = Framework.Tools.GameState.Type.Act_Client_SetCharacterModelByNPC
        local msg = {
            creatureID = selectID
        }
        Framework.Tools.GameState.SendToAllClients(playerID, stateAction, msg)
    end
end

---| 🎮 - 玩家等级检查
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerLevelCheck(playerID)
    -- 检查玩家是否存在
    if not MiscService:IsObjectExist(MiscService.EQueryableObjectType.Player, playerID) then
        return
    end

    local levelBaseExp = Config.Engine.Core.Level.BaseExp
    local levelRatio = Config.Engine.Core.Level.Ratio
    local levelMax = Config.Engine.Core.Level.MaxLevel
    local accessLevel = UDK.Property.ACCESS_LEVEL.ServerOnly

    -- 获取玩家等级属性
    local playerLevel = UDK.Property.GetProperty(playerID, KeyMap.PState.PlayerLevel[1], KeyMap.PState.PlayerLevel[2])
    local playerLevelMax = UDK.Property.GetProperty(playerID, KeyMap.PState.PlayerLevelIsMax[1],
        KeyMap.PState.PlayerLevelIsMax[2])
    local playerExp = UDK.Property.GetProperty(playerID, KeyMap.PState.PlayerExp[1], KeyMap.PState.PlayerExp[2])
    local expReq = UDK.Math.CalcExpRequirement(levelBaseExp, levelRatio, playerLevel)
    UDK.Property.SetProperty(
        playerID,
        KeyMap.GameState.PlayerExpReq[1],
        KeyMap.GameState.PlayerExpReq[2],
        expReq,
        accessLevel
    )

    -- 检查属性是否有效
    if type(playerLevel) ~= "number" or type(playerExp) ~= "number" then
        print("玩家属性无效，无法进行等级检查")
        return
    end

    -- 确保数值非负
    playerLevel = math.max(0, playerLevel)
    playerExp = math.max(0, playerExp)
    -- 如果已经满级，直接返回
    if playerLevelMax then
        return
    end

    if playerLevel < levelMax then
        local reqExp = UDK.Math.CalcExpRequirement(levelBaseExp, levelRatio, playerLevel)

        -- 检查经验是否足够升级
        if playerExp >= reqExp then
            playerLevel = playerLevel + 1
            playerExp = playerExp - reqExp

            -- 更新玩家等级和经验
            UDK.Property.SetProperty(playerID, KeyMap.PState.PlayerLevel[1], KeyMap.PState.PlayerLevel[2], playerLevel,
                accessLevel)
            UDK.Storage.ArchiveUpload(playerID, KeyMap.PState.PlayerLevel[1], KeyMap.PState.PlayerLevel[2], playerLevel)
            UDK.Property.SetProperty(playerID, KeyMap.PState.PlayerExp[1], KeyMap.PState.PlayerExp[2], playerExp,
                accessLevel)
            UDK.Storage.ArchiveUpload(playerID, KeyMap.PState.PlayerExp[1], KeyMap.PState.PlayerExp[2], playerExp)
        end
    end

    -- 检查是否达到最大等级
    if playerLevel >= levelMax then
        UDK.Property.SetProperty(playerID, KeyMap.PState.PlayerLevelIsMax[1], KeyMap.PState.PlayerLevelIsMax[2], true,
            accessLevel)
        UDK.Storage.ArchiveUpload(playerID, KeyMap.PState.PlayerLevelIsMax[1], KeyMap.PState.PlayerLevelIsMax[2], true)
    end
end

---| 🎮 - 玩家随机出生点
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerRandomSpawnPos(playerID)
    local spawnPointList = Config.Engine.AI.SpawnPoint

    -- 初始化玩家出生点使用计数（如果尚未初始化）
    if not Utils.playerSpawnPointMeta then
        Utils.playerSpawnPointMeta = {}
    end
    if next(Utils.playerSpawnPointMeta) == nil then
        for key, point in pairs(spawnPointList) do
            Utils.playerSpawnPointMeta[key] = {
                name = key,
                pos = point.Pos,
                count = 0
            }
        end
    end

    -- 查找使用次数最少的出生点
    local minCount = math.huge
    local candidatePoints = {}

    for key, pointData in pairs(Utils.playerSpawnPointMeta) do
        if pointData.count < minCount then
            minCount = pointData.count
            candidatePoints = { pointData }
        elseif pointData.count == minCount then
            table.insert(candidatePoints, pointData)
        end
    end

    -- 在使用次数最少的出生点中随机选择一个
    local selectedPoint = candidatePoints[math.random(1, #candidatePoints)]

    -- 更新该出生点的使用次数
    Utils.playerSpawnPointMeta[selectedPoint.name].count = Utils.playerSpawnPointMeta[selectedPoint.name].count + 1

    -- 设置玩家位置
    Character:SetPosition(playerID, selectedPoint.pos)
end

---| 🎮 - 玩家离开检查
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerLeaveCheck(playerID)
    local playerStatus = UDK.Property.GetProperty(playerID, KeyMap.GameState.PlayerStatus[1],
    KeyMap.GameState.PlayerStatus[2])
    if playerStatus == Config.Engine.Map.Status.Alive.ID then
        UDK.Property.SetProperty(playerID, KeyMap.GameState.PlayerStatus[1], KeyMap.GameState.PlayerStatus[2],
            Config.Engine.Map.Status.Exit.ID)
    end
end

---| 🎮 - 检查游戏玩家数量
---<br>
---| `范围`：`服务端`
---@return boolean isEnough 是否足够
---@return number reasonCode 原因
function Utils.CheckGamePlayerCount()
    local reasonCode = Config.Engine.Map.GameReasonCode.PlayerCountCheck
    local commonCode = Config.Engine.Map.GameReasonCode.Common
    local playerCount = UDK.Player.GetTotalPlayerCount()
    local redTeamCount = Team:GetTeamPlayerArray(TeamIDMap.Red)
    local blueTeamCount = Team:GetTeamPlayerArray(TeamIDMap.Blue)
    if playerCount == 1 then
        return false, reasonCode.NotEnough
    elseif playerCount >= 2 then
        if #redTeamCount >= 1 and #blueTeamCount >= 1 then
            return true, reasonCode.CheckApproved
        else
            if #redTeamCount == 0 then
                return false, reasonCode.RedTeamNotEnough
            elseif #blueTeamCount == 0 then
                return false, reasonCode.BlueTeamNotEnough
            end
        end
    end
    return false, commonCode.Unknown
end

---| 🎮 - 计算存活玩家
---<br>
---@param playerIDs table 玩家ID列表
---@return table, number alivePlayers 存活玩家列表，存活玩家数量
function Utils.ClacAlivePlayers(playerIDs)
    local alivePlayers = {}
    for _, playerID in ipairs(playerIDs) do
        local isAlive = UDK.Property.GetProperty(
            playerID,
            KeyMap.GameState.PlayerStatus[1],
            KeyMap.GameState.PlayerStatus[2]
        )
        if isAlive == Config.Engine.Map.Status.Alive.ID then
            table.insert(alivePlayers, playerID)
        end
    end
    return alivePlayers, #alivePlayers
end

---| 🎮 - 检查生物受击
---<br>
---| `范围`：`服务端`
---@param creatureID number 生物ID
---@param killerID number 击杀者ID
---@param damage number 伤害值
function Utils.CheckCreatureTakeHurt(creatureID, killerID, damage)
    local playerTeamID = Team:GetTeamById(killerID)
    if playerTeamID == TeamIDMap.Red then
        Damage:SetCreatureFinalDamage(creatureID, damage)
    elseif playerTeamID == TeamIDMap.Blue then
        Damage:SetCreatureFinalDamage(creatureID, 0)
    end
end

---| 🎮 - 检查生物击杀
---<br>
---| `范围`：`服务端`
---@param creatureID number 生物ID
---@param killerID number 击杀者ID
function Utils.CheckCreatureKilled(creatureID, killerID)
    local playerTeamID = Team:GetTeamById(killerID)
    if playerTeamID == TeamIDMap.Red then
        Framework.Server.Aliza.CastKillCreature(creatureID, killerID)
        Damage:ApplyDamageToCharacter(killerID, 1, Config.Engine.GameInstance.Item.Element_CommonGuide)
    elseif playerTeamID == TeamIDMap.Blue then

    end
end

---| 🎮 - 检查玩家受击
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param killerID number 击杀者ID
---@param damage number 伤害值
function Utils.CheckPlayerTakeHurt(playerID, killerID, damage)
    local killerTeamID = Team:GetTeamById(killerID)
    if killerTeamID == TeamIDMap.Red and playerID ~= killerID then
        Damage:SetCharacterFinalDamage(playerID, 1)
    elseif killerTeamID == TeamIDMap.Blue and playerID ~= killerID then
        Damage:SetCharacterFinalDamage(playerID, 0)
    end
end

---| 🎮 - 检查玩家击杀
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param killerID number 击杀者ID
function Utils.CheckPlayerKilled(playerID, killerID)
    local killerTeamID = Team:GetTeamById(killerID)
    local isPlayer = MiscService:IsObjectExist(MiscService.EQueryableObjectType.Character, playerID)
    if killerTeamID == TeamIDMap.Red and isPlayer and playerID ~= killerID then
        Framework.Server.Aliza.CastKillPlayer(killerID, playerID)
        Framework.Server.DataManager.PlayerLevelExpManager(killerID, 15, "Add")
        Framework.Server.DataManager.PlayerEcomonyManager(killerID, "Coin", 15, "Add")
        Framework.Server.DataManager.PlayerTeamScoreManager(killerID, 1, "Add")
    elseif killerTeamID == TeamIDMap.Blue and isPlayer and playerID ~= killerID then
    end
end

---| 🎮 - 检查玩家进入触发盒
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param signalBoxID number 触发盒ID
function Utils.CheckPlayerEnterSignalBox(playerID, signalBoxID)
    --print("OnCharacterEnterSignalBox", playerID, signalBoxID)
    Framework.Server.Task.AreaCheck(playerID, signalBoxID, "EnterSignalBox")
end

---| 🎮 - 检查玩家离开触发盒
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param signalBoxID number 触发盒ID
function Utils.CheckPlayerLeaveSignalBox(playerID, signalBoxID)
    --print("OnCharacterLeaveSignalBox", playerID, signalBoxID)
    Framework.Server.Task.AreaCheck(playerID, signalBoxID, "LeaveSignalBox")
end

---| 🎮 - 检查游戏胜利条件
---<br>
---| `范围`：`服务端`
---@param time number 游戏时间
function Utils.CheckGameVictoryCondition(time)
    local gameTime = math.floor(time or 0)
    local gameStage = Framework.Tools.Utils.GetGameStage()
    local stageCodeMap = Config.Engine.Map.GameStage
    local taskLimit = Config.Engine.Core.Task.TaskLimit
    local taskCompleted = Config.Engine.Core.Task.TaskCompleted
    local redTeamPlayerIDs = UDK.Player.GetTeamPlayers(TeamIDMap.Red)
    local blueTeamPlayerIDs = UDK.Player.GetTeamPlayers(TeamIDMap.Blue)
    local redTeamAlivePlayers, redTeamAliveCount = Utils.ClacAlivePlayers(redTeamPlayerIDs)
    local blueTeamAlivePlayers, blueTeamAliveCount = Utils.ClacAlivePlayers(blueTeamPlayerIDs)
    local victoryTeam, fmt_Message, fmt_Message2
    if gameStage ~= stageCodeMap.Ready and gameStage ~= stageCodeMap.DisableGameFeature and not victoryCheckLock then
        if gameStage == stageCodeMap.Start then
            victoryCheckLock = true

            -- 优先检查任务完成条件（捣蛋鬼胜利条件）
            if taskCompleted >= taskLimit then
                fmt_Message = "捣蛋鬼完成所有任务，游戏胜利"
                fmt_Message2 = "农场破坏任务完成，15秒后游戏结束"
                victoryTeam = TeamIDMap.Blue
                -- 检查时间结束条件
            elseif gameTime <= 0 then
                if taskCompleted > 0 then
                    fmt_Message = "捣蛋鬼未在规定时间内完成所有任务"
                    fmt_Message2 = "游戏失败，15秒后游戏结束"
                    victoryTeam = TeamIDMap.Red
                else
                    fmt_Message = "捣蛋鬼未做任务，计时结束游戏平局"
                    fmt_Message2 = "游戏平局，15秒后游戏结束"
                end
                -- 检查团队存活条件
            elseif blueTeamAliveCount == 0 and redTeamAliveCount >= 1 then
                fmt_Message = string.format("%s获得最终胜利，15秒后游戏结束", "农场主")
                fmt_Message2 = "捣蛋鬼已被全部驱逐，游戏结束"
                victoryTeam = TeamIDMap.Red
            elseif redTeamAliveCount == 0 and blueTeamAliveCount >= 1 then
                fmt_Message = string.format("%s获得最终胜利，15秒后游戏结束", "捣蛋鬼")
                fmt_Message2 = "农场主驱逐捣蛋鬼失败，游戏结束"
                victoryTeam = TeamIDMap.Blue
            end

            -- 如果有任何胜利/平局条件满足，则处理游戏结束逻辑
            if fmt_Message then
                -- 广播通知并结算对局数据
                Framework.Tools.Utils.SetGameStage(stageCodeMap.End)
                Framework.Server.GameFeatureManager.AutoInit(stageCodeMap.End)
                Framework.Server.Aliza.BoardcastSystemMsg(fmt_Message)
                Framework.Server.Aliza.BoardcastSystemMsg(fmt_Message2)
                for _, playerID in pairs(redTeamPlayerIDs) do
                    if victoryTeam == TeamIDMap.Red then
                        Framework.Server.DataManager.PlayerMatchDataManager(playerID, "Win", "Add", 1)
                    elseif victoryTeam == TeamIDMap.Blue then
                        Framework.Server.DataManager.PlayerMatchDataManager(playerID, "Lose", "Add", 1)
                    elseif victoryTeam == nil then
                        Framework.Server.DataManager.PlayerMatchDataManager(playerID, "Draw", "Add", 1)
                    end
                end
                for _, playerID in pairs(blueTeamPlayerIDs) do
                    if victoryTeam == TeamIDMap.Red then
                        Framework.Server.DataManager.PlayerMatchDataManager(playerID, "Lose", "Add", 1)
                    elseif victoryTeam == TeamIDMap.Blue then
                        Framework.Server.DataManager.PlayerMatchDataManager(playerID, "Win", "Add", 1)
                    elseif victoryTeam == nil then
                        Framework.Server.DataManager.PlayerMatchDataManager(playerID, "Draw", "Add", 1)
                    end
                end

                -- 队伍胜利
                TimerManager:AddTimer(15, function()
                    if victoryTeam == nil then
                        Character:SetCampVictory(TeamIDMap.Red)
                        Character:SetCampVictory(TeamIDMap.Blue)
                    elseif victoryTeam == TeamIDMap.Red then
                        Character:SetCampVictory(TeamIDMap.Red)
                    elseif victoryTeam == TeamIDMap.Blue then
                        Character:SetCampVictory(TeamIDMap.Blue)
                    end
                    victoryCheckLock = false
                end)
            else
                victoryCheckLock = false
            end
        end
    end
end

---| 🎮 - 游戏对局数据自动管理
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.GameMatchDataAutoManager(playerID)
    local gameStage = Framework.Tools.Utils.GetGameStage()
    local stageCodeMap = Config.Engine.Map.GameStage
    -- 如果游戏阶段是开始阶段，则增加逃跑次数
    if gameStage == stageCodeMap.Start then
        Framework.Server.DataManager.PlayerMatchDataManager(playerID, "Escape", "Add", 1)
    end
end

return Utils
