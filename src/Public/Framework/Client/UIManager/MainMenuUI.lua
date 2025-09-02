-- ==================================================
-- * Campfire Project | Framework/Client/Extent/MainMenuUI.lua
-- *
-- * Info:
-- * Campfire Project Framework Client UI - MainMenuUI
-- * Managed by AnivaxUI Manager
-- * !! This file does not expose external interfaces !!
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local MainMenuUI = {}
local UIConf, EngineConf = require("Public.Config.UI"), require("Public.Config.Engine")
local CoreUI, KeyMap = UIConf.Core, EngineConf.Property.KeyMap

local function getServerPlayerProfileData()
    local fallback = {
        Player = {
            ID = "NaN",
        },
        GameData = {
            Level = 0,
            Exp = 0,
            ReqExp = 0,
            Currency = {
                Coin = 0,
                StarCoin = 0,
                SliverCoin = 0
            }
        },
        CloudData = {}
    }

    return fallback
end

function MainMenuUI.BaseUI()
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UIBase.T_AppInfo, "Campfire Project | UniX Framework")
end

function MainMenuUI.UserAccountPanelUI()
    local playerID = UDK.Player.GetLocalPlayerID()
    local playerName = UDK.Player.GetPlayerNickName(playerID)
    UDK.UI.SetPlayerIconAndName(CoreUI.MainMenu.Tmp_UserAccount.Tmp_UserInfo.Fc_Avatar, playerID, "Icon")
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_UserInfo.T_UserName, playerName)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_UserInfo.T_ExtInfo, "Test Content")
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_AccountInfo.T_AccInfo1, "Test Content")
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_AccountInfo.T_AccInfo2, "Test Content")
end

function MainMenuUI.UserProfileUI()
    local serverData = getServerPlayerProfileData()
    local historyData_I18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.history_data")
    local personal_I18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.personal_data")
    local fmt_personal_I18NKey = string.format(personal_I18NKey, "0", "0", "0", "0")
    local fmt_historyData_I18NKey = string.format(historyData_I18NKey, "0", "0", "0", "0", "0", "0")
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_MyProfile.T_PersonalData, fmt_personal_I18NKey)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_MyProfile.T_HistoryData, fmt_historyData_I18NKey)
end

function MainMenuUI.UserSettingsUI()

end

function MainMenuUI.RankListUI()

end

return MainMenuUI
