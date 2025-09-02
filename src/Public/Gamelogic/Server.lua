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
    local envType = Framework.Tools.Utils.EnvIsServer()
    if not envType then return end
    Framework.Server.Init.InitGame()
end

function Server.Update()
    local envType = Framework.Tools.Utils.EnvIsServer()
    if not envType then return end
    --print("Server Update")
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
end

return Server
