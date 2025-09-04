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
        CloudData = {
            Match = {
                Win = 0,
                Lose = 0,
                Draw = 0,
                Escape = 0,
                TotalRound = 0,
            },
        }
    }

    return fallback
end

---| 🔩 - 客户端UI更新（MainMenu）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新基础UI`
---<br>
---| `更新范围`：`MainMenu.Tmp_UIBase` - `UI Base`
---<br>
---| `是否从服务器获取数据`：`false`
function MainMenuUI.BaseUI()
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UIBase.T_AppInfo, "Campfire Project | UniX Framework")
    local UID = UDK.Math.EncodeToUID(UDK.Player.GetLocalPlayerID())
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UIBase.T_UID, "UID " .. UID)
end

---| 🔩 - 客户端UI更新（MainMenu）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新账户信息UI`
---<br>
---| `更新范围`：`MainMenu.Tmp_UserAccount` - `User Account`
---<br>
---| `是否从服务器获取数据`：`true`
function MainMenuUI.UserAccountPanelUI()
    local serverData = getServerPlayerProfileData()
    local playerID = UDK.Player.GetLocalPlayerID()
    local playerName = UDK.Player.GetPlayerNickName(playerID)
    local accInfo1_I18NKey = Framework.Tools.Utils.GetI18NKey("key.account_info.info1")
    local accInfo2_I18NKey = Framework.Tools.Utils.GetI18NKey("key.account_info.info2")
    local fmt_accInfo1_I18NKey = string.format(accInfo1_I18NKey, serverData.GameData.Currency.Coin)
    local fmt_accInfo2_I18NKey = string.format(accInfo2_I18NKey, serverData.GameData.Level)
    UDK.UI.SetPlayerIconAndName(CoreUI.MainMenu.Tmp_UserAccount.Tmp_UserInfo.Fc_Avatar, playerID, "Icon")
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_UserInfo.T_UserName, playerName)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_UserInfo.T_ExtInfo, "Test Content")
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_AccountInfo.T_AccInfo1, fmt_accInfo1_I18NKey)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_AccountInfo.T_AccInfo2, fmt_accInfo2_I18NKey)
end

---| 🔩 - 客户端UI更新（MainMenu）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新生涯数据UI`
---<br>
---| `更新范围`：`MainMenu.Tmp_MyProfile` - `My Profile`
---<br>
---| `是否从服务器获取数据`：`true`
function MainMenuUI.UserProfileUI()
    local serverData = getServerPlayerProfileData()
    local historyData_I18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.history_data")
    local personal_I18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.personal_data")
    local fmt_personal_I18NKey = string.format(
        personal_I18NKey,
        serverData.GameData.Level,
        serverData.GameData.Currency.Coin,
        serverData.GameData.Exp,
        serverData.GameData.ReqExp
    )
    local winRate = UDK.Math.CalcPercentage(serverData.CloudData.Match.TotalRound, serverData.CloudData.Match.Win)
    local fmt_historyData_I18NKey = string.format(
        historyData_I18NKey,
        serverData.CloudData.Match.TotalRound,
        math.ceil(winRate) .. "%",
        serverData.CloudData.Match.Win,
        serverData.CloudData.Match.Lose,
        serverData.CloudData.Match.Draw,
        serverData.CloudData.Match.Escape
    )
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_MyProfile.T_PersonalData, fmt_personal_I18NKey)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_MyProfile.T_HistoryData, fmt_historyData_I18NKey)
end

function MainMenuUI.UserSettingsUI()
    local test                = Framework.Tools.Utils.GetI18NKey("ptemplate.credits")
    local currentLang         = Framework.Tools.Utils.GetI18NKey("language")
    local setting_I18NKey     = Framework.Tools.Utils.GetI18NKey("ptemplate.setting")
    local fmt_setting_I18NKey = string.format(setting_I18NKey, "Test", "Test", "Test", currentLang)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.T_Content, fmt_setting_I18NKey)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.T_Content, test)
end

function MainMenuUI.RankListUI()
    local redTeamUI = CoreUI.MainMenu.Tmp_Rank.Tmp_RedTeam
    local blueTeamUI = CoreUI.MainMenu.Tmp_Rank.Tmp_BlueTeam
    local teamPlayer = UDK.Player.GetTeamPlayers(2)
    local length = UDK.Array.GetLength(blueTeamUI)
    --Log:PrintTable(teamPlayer)
    --print(length)
    for i = 1, length do
        local item = blueTeamUI["RankList" .. i]
        local playerID = UDK.Player.GetLocalPlayerID()
        UDK.UI.SetPlayerIconAndName(item.Fc_Avatar, playerID, "Icon")
        UDK.UI.SetUIText(item.T_Status, "Test" .. i)
    end
end

return MainMenuUI
