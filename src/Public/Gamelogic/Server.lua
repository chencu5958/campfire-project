-- ==================================================
-- * Campfire Project | Gamelogic/Server.lua
-- *
-- * Info:
-- * Campfire Project Gamelogic Server Entry
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Server = {}
local updateLock = false

---| 🎮 服务端初始化
function Server.Init()
    local envType = Framework.Tools.Utils.EnvIsServer()
    if not envType then return end
    TimerManager:AddTimer(0.1, function()
        UDK.Heartbeat.SetAutoSend(false)
        Framework.Tools.GameState.Init()
        for _, v in ipairs(UDK.Player.GetAllPlayers()) do
            Framework.Server.Init.InitGame(v)
            Framework.Server.Utils.PlayerWeaponAllocate(v)
            Framework.Server.Utils.PlayerInGameDisplay(v)
        end
    end)
    TimerManager:AddLoopTimer(3, function()
        --Framework.Server.Aliza.BoardcastSystemMsg("Server Boardcast Test #" .. math.random(1, 100))
        local data = {
            killer = {
                playerID = math.random(1, 100),
                playerName = "Test",
                playerColor = MiscService:RandomColor(),
                killerTipColor = MiscService:RandomColor(),
                killerTipType = "KillerTipType"
            },
            victim = {
                playerID = 1,
                playerName = "Test" .. math.random(1, 100),
                playerColor = MiscService:RandomColor()
            }
        }
        --Framework.Server.Aliza.BoardcastKillNotice(data.killer, data.victim)
    end)
end

---| 🎮 服务端更新
function Server.Update()
    local envType = Framework.Tools.Utils.EnvIsServer()
    if not envType then return end
    local playerIDs = UDK.Player.GetAllPlayers()
    --Framework.Server.DataManager.PlayerMatchDataManager(v, "Win", "Add", 1)
    --Framework.Server.DataManager.PlayerMatchDataManager(v, "Lose", "Sub", 1)
    --Framework.Server.DataManager.PlayerMatchDataManager(v, "Draw", "Sub", 1)
    --Framework.Server.DataManager.PlayerMatchDataManager(v, "Escape", "Sub", 1)
    Framework.Server.NetSync.SyncServerGameState()
    Framework.Server.NetSync.SyncRankListData(playerIDs)
    for _, v in ipairs(playerIDs) do
        if not updateLock then
            updateLock = true
            TimerManager:AddTimer(0.5, function()
                Framework.Server.Utils.PlayerStatusCheck(v)
                Framework.Server.Utils.PlayerLevelCheck(v)
                Framework.Server.NetSync.SyncUserProfile(v)
                updateLock = false
            end)
        end
    end
end

---| 👾 - 玩家离开事件
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Server.EventPlayerLeave(playerID)
    Framework.Server.DataManager.PlayerArchiveUpload(playerID)
end

---| 👾 - 玩家销毁事件
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Server.EventPlayerDestory(playerID)
    local killerData = {
        playerID = playerID,
        playerName = UDK.Player.GetPlayerNickName(playerID),
        playerColor = Framework.Tools.Utils.GetTeamHexByPlayerID(playerID),
        killerTipType = "KillByVoid"
    }
    local victimData = {
        playerID = 0,
        playerName = ""
    }
    Framework.Server.Aliza.BoardcastKillNotice(killerData, victimData)
end

---| 👾 - 玩家死亡事件
---<br>
---| `范围`：`服务端`
---@param killerID number 击杀者ID
---@param victimID number 被击杀者ID
function Server.EventPlayerKilled(killerID, victimID)
    local killerData = {
        playerID = killerID,
        playerName = UDK.Player.GetPlayerNickName(killerID),
        playerColor = Framework.Tools.Utils.GetTeamHexByPlayerID(killerID),
        killerTipType = "KillPlayer"
    }
    local victimData = {
        playerID = victimID,
        playerName = UDK.Player.GetPlayerNickName(victimID),
        playerColor = Framework.Tools.Utils.GetTeamHexByPlayerID(victimID),
    }
    Framework.Server.Aliza.BoardcastKillNotice(killerData, victimData)
end

---| 👾 - 生物死亡事件
---<br>
---| `范围`：`服务端`
---@param creatureID number 生物ID
---@param killerID number 击杀者ID
function Server.EventCreatureKilled(creatureID, killerID)
    local killerData = {
        playerID = killerID,
        playerName = UDK.Player.GetPlayerNickName(killerID),
        playerColor = Framework.Tools.Utils.GetTeamHexByPlayerID(killerID),
        killerTipType = "KillNPC"
    }
    local victimData = {
        playerID = creatureID,
        playerName = Creature:GetName(creatureID),
        playerColor = Framework.Tools.Utils.GetTeamHexByCode("NPC"),
    }
    Framework.Server.Aliza.BoardcastKillNotice(killerData, victimData)
end

---| 👾 - 玩家进入触发盒事件
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param signalBoxID number 触发盒ID
function Server.EventPlayerEnterSignalBox(playerID, signalBoxID)
    print("OnCharacterEnterSignalBox", playerID, signalBoxID)
end

---| 👾 - 玩家离开触发盒事件
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param signalBoxID number 触发盒ID
function Server.EventPlayerLeaveSignalBox(playerID, signalBoxID)
    print("OnCharacterLeaveSignalBox", playerID, signalBoxID)
end

---| 👾 - 玩家受伤事件
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param killerID number 击杀者ID
---@param damage number 伤害值
function Server.EventPlayerTakeHurt(playerID, killerID, damage)
    local gameFeatureName = Framework.Server.GameFeatureManager.Type.CharacterCanTakeHurt
    local featureIsEnabled = Framework.Server.GameFeatureManager.IsFeatureEnabled(gameFeatureName)
    if not featureIsEnabled then
        Damage:SetCharacterFinalDamage(playerID, 0)
        return
    end
    Framework.Server.Utils.CheckPlayerTakeHurt(playerID, killerID, damage)
end

---| 👾 - 生物受伤事件
---<br>
---| `范围`：`服务端`
---@param creatureID number 生物ID
---@param killerID number 击杀者ID
---@param damage number 伤害值
function Server.EventCreatureTakeHurt(creatureID, killerID, damage)
    local gameFeatureName = Framework.Server.GameFeatureManager.Type.CreatureCanTakeHurt
    local featureIsEnabled = Framework.Server.GameFeatureManager.IsFeatureEnabled(gameFeatureName)
    if not featureIsEnabled then
        Damage:SetCreatureFinalDamage(creatureID, 0)
        return
    end
    Framework.Server.Utils.CheckCreatureTakeHurt(creatureID, killerID, damage)
end

---| 👾 - 断线重连事件
---<br>
---| `范围`：`服务端`
---@param player number 玩家ID
---@param levelID number 场景ID
function Server.EventPlayerReconnectd(player, levelID)
    local envType = Framework.Tools.Utils.EnvIsServer()
    if not envType then return end
    UDK.Property.SyncAuthorityData(player)
    Framework.Tools.GameState.SendToClient(player, "Act_Client_ReconnectInit")
    Log:PrintServerLog("Player " .. player .. " reconnected")
end

return Server
