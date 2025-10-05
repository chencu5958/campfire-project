-- ==================================================
-- * Campfire Project | Framework/Server/Aliza.lua
-- *
-- * Info:
-- * Campfire Project Framework Server Aliza Client Notice Manager
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Aliza = {}

---| 🎮 推送消息
---@param MsgContent table {
---    MsgType: number,
---    MsgContent: string
---}
---@param MsgType string|number 消息类型（KillerMsg | SystemMsg）
---@return boolean 是否成功
function Aliza.BoardcastMsg(MsgContent, MsgType)
    local Msg = {
        MsgType = MsgType,
        MsgContent = MsgContent
    }
    local MsgId = Config.Engine.NetMsg.AlizaNotice.ServerBoardcast
    System:SendToAllClients(MsgId, Msg)
    return true
end

---| 🎮 推送击杀通知
---@param killerData table 击杀者信息 {playerID, playerName, playerColor, killerTipType, killerTipColor}
---@param victimData table 被击杀者信息 {playerID, playerName, playerColor}
---@return boolean 是否成功
function Aliza.BoardcastKillNotice(killerData, victimData)
    local MsgContent = {
        killer = killerData,
        victim = victimData,
        killerTip = killerData,
        timestamp = UDK.Math.GetTimestamp()
    }

    return Aliza.BoardcastMsg(MsgContent, "KillNotice")
end

---| 🎮 推送系统消息
---@param message string 系统消息内容
---@return boolean 是否成功
function Aliza.BoardcastSystemMsg(message, messageColor)
    local MsgContent = {
        message = message,
        messageColor = messageColor,
        timestamp = UDK.Math.GetTimestamp()
    }

    return Aliza.BoardcastMsg(MsgContent, "SystemMsg")
end

---| 🎮 推送击杀玩家通知
---@param killerID number 击杀者ID
---@param victimID number 被击杀者ID
function Aliza.CastKillPlayer(killerID, victimID)
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
    Aliza.BoardcastKillNotice(killerData, victimData)
end

---| 🎮 推送击杀生物通知
---@param creatureID number 生物ID
---@param killerID number 击杀者ID
function Aliza.CastKillCreature(creatureID, killerID)
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
    Aliza.BoardcastKillNotice(killerData, victimData)
end

---| 🎮 推送玩家自杀通知
---@param playerID number 玩家ID
function Aliza.CastKillBySelf(playerID)
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
    Aliza.BoardcastKillNotice(killerData, victimData)
end

return Aliza
