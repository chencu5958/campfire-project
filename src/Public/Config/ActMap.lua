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
local CoreUI = UIConf.Core
local UIAnim = UIConf.UIAnim

ActMap.MainMenu = {
    -- MenuItem BtnGroup
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_MyProfile] = {
        Pressed = function(ItemUID)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_MyProfile.Grp_Root },
                { CoreUI.MainMenu.Tmp_Settings.Grp_Root, CoreUI.MainMenu.Tmp_Rank.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_MyProfile.Grp_Root, UIAnim.MainMenu.Tmp_MyProfile.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_Settings] = {
        Pressed = function(ItemUID)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_Settings.Grp_Root },
                { CoreUI.MainMenu.Tmp_MyProfile.Grp_Root, CoreUI.MainMenu.Tmp_Rank.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_Settings.Grp_Root, UIAnim.MainMenu.Tmp_MyProfile.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_Rank] = {
        Pressed = function(ItemUID)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_Rank.Grp_Root },
                { CoreUI.MainMenu.Tmp_MyProfile.Grp_Root, CoreUI.MainMenu.Tmp_Settings.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_Rank.Grp_Root, UIAnim.MainMenu.Tmp_MyProfile.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_EShop] = {
        Pressed = function(ItemUID)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
        end
    },
    -- Settings Page
    [CoreUI.MainMenu.Tmp_Settings.Tmp_BtnGroup.Btn_General] = {
        Pressed = function(ItemUID)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Grp_Root },
                { CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_BtnGroup.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Grp_Root,
                UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_BtnGroup.Btn_Misc] = {
        Pressed = function(ItemUID)
            UDK.UI.SetUIVisibility(
                { CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Grp_Root },
                { CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Grp_Root }
            )
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_BtnGroup.BtnPress, 1)
            UI:PlayUIAnimation(CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Grp_Root,
                UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.MenuCardScale, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_BtnGroup.Btn_Language] = {
        Pressed = function(ItemUID)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_BtnGroup.BtnPress, 1)
        end
    },
    -- UIBase
    [CoreUI.MainMenu.Tmp_UIBase.Btn_GRank] = {
        Pressed = function()
            Rank:DspRankWind()
        end
    },
    [CoreUI.MainMenu.Tmp_UIBase.Btn_Close] = {
        Pressed = function(ItemUID)
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
        Pressed = function()
            UDK.UI.SetUIVisibility(CoreUI.MainMenu.Grp_Root)
            UI:PlayUIAnimation(CoreUI.MainMenu.Grp_Root, UIAnim.MainMenu.UIOpen, 1)
        end
    },
    [CoreUI.ScoreBar.Tmp_ToolBar.Btn_Rank] = {
        Pressed = function()
            UDK.UI.SetUIVisibility(CoreUI.MainMenu.Grp_Root)
            UI:PlayUIAnimation(CoreUI.MainMenu.Grp_Root, UIAnim.MainMenu.UIOpen, 1)
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
    ActMap.ScoreBar
}

-- 合并所有表
for _, map in ipairs(mapsToMerge) do
    mergeMappings(ActMap.MapResult, map)
end

return ActMap
