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

return Aliza
