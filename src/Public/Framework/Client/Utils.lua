-- ==================================================
-- * Campfire Project | Framework/Client/Utils.lua
-- *
-- * Info:
-- * Campfire Project Framework Client Utils
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Utils = {}
local KeyMap = Config.Engine.Property.KeyMap

---| 🎮 设置客户端初始化状态
function Utils.SetClientInitStatus()
    Framework.Tools.LightDMS.SetCustomProperty(KeyMap.ClientState.ClientIsInit[1],
        KeyMap.ClientState.ClientIsInit[2], true)
end

---| 🎮 获取客户端初始化状态
function Utils.GetClientInitStatus()
    local isInit = Framework.Tools.LightDMS.GetCustomProperty(KeyMap.ClientState.ClientIsInit[1],
        KeyMap.ClientState.ClientIsInit[2], false)
    if type(isInit) ~= "boolean" then
        return false
    else
        return isInit
    end
end

return Utils
