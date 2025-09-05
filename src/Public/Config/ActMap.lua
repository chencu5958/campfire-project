-- ==================================================
-- * Campfire Project | Config/ActMap.lua
-- *
-- * Info:
-- * Campfire Project ActMapping Config
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local ActMap = {}
local UIConf = require("Public.Config.UI")
local EngineConf = require("Public.Config.Engine")
local CoreUI = UIConf.Core
local UIAnim = UIConf.UIAnim

ActMap.MainMenu = {
    -- MenuItem BtnGroup
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_MyProfile]                = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            Framework.Tools.UI.SetMainMenuUIOpenPID(EngineConf.GameUI.UI.MainMenuPID.MyProfile)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_MyProfile.Grp_Root },
                { CoreUI.MainMenu.Tmp_Settings.Grp_Root, CoreUI.MainMenu.Tmp_Rank.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_MyProfile.Grp_Root, UIAnim.MainMenu.Tmp_MyProfile.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_Settings]                 = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            Framework.Tools.UI.SetMainMenuUIOpenPID(EngineConf.GameUI.UI.MainMenuPID.Settings)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_Settings.Grp_Root },
                { CoreUI.MainMenu.Tmp_MyProfile.Grp_Root, CoreUI.MainMenu.Tmp_Rank.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_Settings.Grp_Root, UIAnim.MainMenu.Tmp_MyProfile.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_Rank]                     = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            Framework.Tools.UI.SetMainMenuUIOpenPID(EngineConf.GameUI.UI.MainMenuPID.RankList)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_Rank.Grp_Root },
                { CoreUI.MainMenu.Tmp_MyProfile.Grp_Root, CoreUI.MainMenu.Tmp_Settings.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_Rank.Grp_Root, UIAnim.MainMenu.Tmp_MyProfile.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_EShop]                    = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
        end
    },
    -- MyProfile Page (Btn Group / UIBase)
    [CoreUI.MainMenu.Tmp_MyProfile.Btn_Help]                    = {
        Pressed = function()
            local msg = Framework.Tools.Utils.GetI18NKey("key.message.help")
            UDK.UI.ShowMessageTip(msg)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
        end
    },
    -- Settings Page (Btn Group / UIBase)
    [CoreUI.MainMenu.Tmp_Settings.Tmp_BtnGroup.Btn_General]     = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Grp_Root },
                { CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_BtnGroup.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Grp_Root,
                UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_BtnGroup.Btn_Misc]        = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Grp_Root },
                { CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_BtnGroup.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Grp_Root,
                UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_BtnGroup.Btn_Language]    = {
        Pressed = function(ItemUID)
            Framework.Tools.Utils.I18NLangToggle()
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_BtnGroup.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Btn_Reset]                    = {
        Pressed = function()
            local msg = Framework.Tools.Utils.GetI18NKey("key.message.reset_setting")
            UDK.UI.ShowMessageTip(msg)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
        end
    },
    -- Settings Page (General Page)
    [CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Btn_SFXSound] = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Btn_MicMode]  = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Btn_ChatMode] = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    -- Settings Page (Misc Page)
    [CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Btn_Version]     = {
        Pressed = function(ItemUID)
            local layoutProp = Config.Engine.Property.KeyMap.UIState.LayoutSettingMiscPID
            local layoutID = Config.Engine.GameUI.UI.Layout_SettingMisc.Version
            Framework.Tools.UI.SetLayoutUIOpenPID(layoutProp, layoutID)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Btn_Credits]     = {
        Pressed = function(ItemUID)
            local layoutProp = Config.Engine.Property.KeyMap.UIState.LayoutSettingMiscPID
            local layoutID = Config.Engine.GameUI.UI.Layout_SettingMisc.Credits
            Framework.Tools.UI.SetLayoutUIOpenPID(layoutProp, layoutID)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Btn_Feedback]    = {
        Pressed = function(ItemUID)
            local layoutProp = Config.Engine.Property.KeyMap.UIState.LayoutSettingMiscPID
            local layoutID = Config.Engine.GameUI.UI.Layout_SettingMisc.Feedback
            Framework.Tools.UI.SetLayoutUIOpenPID(layoutProp, layoutID)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    -- UIBase
    [CoreUI.MainMenu.Tmp_UIBase.Btn_GRank]                      = {
        Pressed = function()
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            Rank:DspRankWind()
        end
    },
    [CoreUI.MainMenu.Tmp_UIBase.Btn_Close]                      = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClose)
            if Framework.Tools.UI.GetMainMenuUIOpenState() then
                Framework.Tools.UI.SetMainMenuUIOpenState(false)
            end
            UI:PlayUIAnimation(CoreUI.MainMenu.Grp_Root, UIAnim.MainMenu.UIClose, 1)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_UIBase.BtnPress, 1)
            TimerManager:AddTimer(0.4, function()
                UDK.UI.SetUIVisibility("", CoreUI.MainMenu.Grp_Root)
            end)
        end
    }
}

ActMap.ScoreBar = {
    [CoreUI.ScoreBar.Tmp_ToolBar.Btn_MainMenu] = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UDK.UI.SetUIVisibility(CoreUI.MainMenu.Grp_Root)
            Framework.Tools.UI.SetMainMenuUIOpenState(true)
            UI:PlayUIAnimation(CoreUI.MainMenu.Grp_Root, UIAnim.MainMenu.UIOpen, 1)
            UI:PlayUIAnimation(ItemUID, 1, 1)
        end
    },
    [CoreUI.ScoreBar.Tmp_ToolBar.Btn_Rank] = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UDK.UI.SetUIVisibility(CoreUI.MainMenu.Grp_Root)
            Framework.Tools.UI.SetMainMenuUIOpenState(true)
            UI:PlayUIAnimation(CoreUI.MainMenu.Grp_Root, UIAnim.MainMenu.UIOpen, 1)
            UI:PlayUIAnimation(ItemUID, 1, 1)
        end
    }
}

ActMap.Taskbar = {
    [CoreUI.TaskBar.Tmp_UIBase.Btn_Expand] = {
        Pressed = function()
            Framework.Tools.UI.SetTaskbarUIOpenState(true)
            UDK.UI.SetUIVisibility(
                {
                    CoreUI.TaskBar.Tmp_Expand.Grp_Root,
                },
                {
                    CoreUI.TaskBar.Tmp_UIBase.Btn_Expand
                }
            )
            UI:PlayUIAnimation(CoreUI.TaskBar.Tmp_Expand.Grp_Root, UIAnim.TaskBar.UIOpen, 1)
        end
    },
    [CoreUI.TaskBar.Tmp_UIBase.Btn_Collapse] = {
        Pressed = function()
            Framework.Tools.UI.SetTaskbarUIOpenState(false)
            TimerManager:AddTimer(0.4, function()
                UDK.UI.SetUIVisibility(
                    {
                        CoreUI.TaskBar.Tmp_UIBase.Btn_Expand
                    },
                    {
                        CoreUI.TaskBar.Tmp_Expand.Grp_Root
                    }
                )
            end)
            UI:PlayUIAnimation(CoreUI.TaskBar.Tmp_Expand.Grp_Root, UIAnim.TaskBar.UIClose, 1)
        end
    }
}

ActMap.MapResult = {}

local function mergeMappings(target, source)
    for k, v in pairs(source) do
        target[k] = v
    end
end

-- 定义需要合并的表列表
local mapsToMerge = {
    ActMap.MainMenu,
    ActMap.ScoreBar,
    ActMap.Taskbar,
}

-- 合并所有表
for _, map in ipairs(mapsToMerge) do
    mergeMappings(ActMap.MapResult, map)
end

return ActMap
