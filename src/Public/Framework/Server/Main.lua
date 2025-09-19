-- ==================================================
-- * Campfire Project | Framework/Server/Main.lua
-- *
-- * Info:
-- * Campfire Project Framework Server Entry
-- *
-- * Framework Powered By UniX Architecture
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Server = {
    Init = require("Public.Framework.Server.Init"),
    Utils = require("Public.Framework.Server.Utils"),
    NetSync = require("Public.Framework.Server.NetSync"),
    Aliza = require("Public.Framework.Server.Modules.Aliza"),
    DataManager = require("Public.Framework.Server.Modules.DataManager")
}

return Server
