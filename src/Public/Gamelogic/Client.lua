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
end

---|
function Client.Update()
    -- 检查环境
    local envType = Framework.Tools.Utils.EnvIsClient()
    if not envType then return end
    Framework.Client.AnivaxUI.Update()
    --print("Client Update")
end

return Client
