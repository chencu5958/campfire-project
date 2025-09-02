-- ==================================================
-- * Campfire Project | Framework/Client/Extent/AnivaxUI.lua
-- *
-- * Info:
-- * Campfire Project Framework Client UI - UI Manager
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local MainMenuUI = require("Public.Framework.Client.UIManager.MainMenuUI")
local ScorebarUI = require("Public.Framework.Client.UIManager.ScorebarUI")
local TaskbarUI = require("Public.Framework.Client.UIManager.TaskbarUI")
local EngineConf = require("Public.Config.Engine")

local AnivaxUI = {}

-- 私有变量和函数
local MAIN_MENU_PAGE_HANDLERS
local MAIN_MENU_UI_PID

local function initializeMainMenuHandlers()
    MAIN_MENU_UI_PID = EngineConf.GameUI.UI.MainMenuPID
    MAIN_MENU_PAGE_HANDLERS = {
        [MAIN_MENU_UI_PID.MyProfile] = MainMenuUI.UserProfileUI,
        [MAIN_MENU_UI_PID.Settings] = MainMenuUI.UserSettingsUI,
        [MAIN_MENU_UI_PID.RankList] = MainMenuUI.RankListUI
    }
end

local function updateMainMenu()
    if not Framework.Tools.UI.GetMainMenuUIOpenState() then
        return
    end

    -- 基础面板（总是显示）
    MainMenuUI.BaseUI()
    MainMenuUI.UserAccountPanelUI()

    -- 页面特定UI（按需显示）
    local currentPagePID = Framework.Tools.UI.GetMainMenuUIOpenPID()
    local pageHandler = MAIN_MENU_PAGE_HANDLERS[currentPagePID]
    if pageHandler then
        pageHandler()
    end
end

local function updateTaskbar()
    if Framework.Tools.UI.GetTaskbarUIOpenState() then
        -- TODO: 任务栏处理逻辑
    end
end

-- 公共接口
function AnivaxUI.Update()
    -- 基础UI更新（总是显示）
    ScorebarUI.TimeCountUI()
    ScorebarUI.TeamScoreUI()

    -- 条件性UI更新
    updateMainMenu()
    updateTaskbar()
end

-- 初始化
initializeMainMenuHandlers()

return AnivaxUI
