-- ==================================================
-- * Campfire Project | Framework/Client/Init.lua
-- *
-- * Info:
-- * Campfire Project Framework Client Init
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local ClientInit = {}

local function clientPropretyInit()
    Framework.Tools.LightDMS.SetCustomProperty()
end

---| 🎮 客户端UI初始化
function ClientInit.InitUI()
    local GameUI, UIConf, ActMap = Config.Engine.GameUI, Config.UI, Config.ActMap
    UDK.UI.SetNativeInterfaceVisible(GameUI.Init.NativeInterfaceHidden, false)
    UDK.UI.RegisterButtonEvent(UIConf.BtnUIDResult, ActMap.MapResult)
end

---| 🎮 客户端游戏逻辑初始化
function ClientInit.InitGame()
    clientPropretyInit()
end

return ClientInit
