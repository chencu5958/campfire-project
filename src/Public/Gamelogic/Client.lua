-- ==================================================
-- * Campfire Project | Gamelogic/Client.lua
-- *
-- * Info:
-- * Campfire Project Gamelogic Client Entry
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Client = {}

---|
function Client.Init()
    -- 检查环境
    local envType = Framework.Tools.Utils.EnvIsClient()
    if not envType then return end
    Framework.Client.Init.InitUI()
    Framework.Client.Init.InitGame()
    Framework.Client.Aliza.InitNet()
    Framework.Tools.GameState.Init()
end

---|
function Client.Update()
    -- 检查环境
    local envType = Framework.Tools.Utils.EnvIsClient()
    if not envType then return end
    Framework.Client.AnivaxUI.Update()
end

return Client
