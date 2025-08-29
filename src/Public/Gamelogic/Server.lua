-- ==================================================
-- * Campfire Project | Gamelogic/Server.lua
-- *
-- * Info:
-- * Campfire Project Gamelogic Server Entry
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Server = {}

function Server.Init()

end

function Server.Update()
    Framework.Tools.Utils.EnvIsServer()
end

---| 👾 - 断线重连事件
---<br>
---| `范围`：`服务端`
---@param player number 玩家ID
---@param levelID number 场景ID
function Server.EventPlayerReconnectd(player, levelID)
    UDK.Property.SyncAuthorityData(player)
end

return Server
