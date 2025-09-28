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

-- 按钮锁定状态控制变量
local isMainMenuSwitching = false
local isSettingsPageSwitching = false
local isIMUtilsSwitching = false

-- 统一处理主菜单项按钮切换逻辑
local function handleMainMenuSwitch(itemUID, pagePID, showGroup, hideGroups)
    -- 如果正在切换中，则忽略新的切换请求
    if isMainMenuSwitching then
        return
    end

    isMainMenuSwitching = true

    Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
    Framework.Tools.UI.SetMainMenuUIOpenPID(pagePID)
    UDK.UI.SetUIVisibility(
        { showGroup },
        hideGroups
    )
    UI:PlayUIAnimation(itemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
    UI:PlayUIAnimation(showGroup, UIAnim.MainMenu.Tmp_MyProfile.MenuCardScale, 1)

    -- 0.3秒后解锁
    TimerManager:AddTimer(0.3, function()
        isMainMenuSwitching = false
    end)
end

-- 统一处理设置页面按钮切换逻辑
local function handleSettingsPageSwitch(itemUID, showGroup, hideGroup)
    -- 如果正在切换中，则忽略新的切换请求
    if isSettingsPageSwitching then
        return
    end

    isSettingsPageSwitching = true

    Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
    UDK.UI.SetUIVisibility(
        { showGroup },
        { hideGroup }
    )
    UI:PlayUIAnimation(itemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_BtnGroup.BtnPress, 1)
    UI:PlayUIAnimation(showGroup, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.MenuCardScale, 1)

    -- 0.3秒后解锁
    TimerManager:AddTimer(0.3, function()
        isSettingsPageSwitching = false
    end)
end

-- 统一处理IMUtils按钮切换逻辑
local function handleIMUtilsSwitch(targetPID)
    -- 如果正在切换中，则忽略新的切换请求
    if isIMUtilsSwitching then
        return
    end

    isIMUtilsSwitching = true
    local IMUtilsPID = EngineConf.GameUI.UI.IMUtilsPID
    Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)

    if targetPID == IMUtilsPID.TChat then
        -- 切换到TCHAT
        Framework.Tools.UI.SetIMUtilsOpenPID(IMUtilsPID.TChat)
        UI:PlayUIAnimation(CoreUI.IMUtils.Tmp_TChat.Grp_Root, UIAnim.IMUtils.UIOpen, 1)
        UDK.UI.SetUIVisibility(CoreUI.IMUtils.Tmp_TChat.Grp_Root, CoreUI.IMUtils.Tmp_VChat.Grp_Root)
        TimerManager:AddTimer(0.3, function()
            isIMUtilsSwitching = false
        end)
        --print("Switch to TChat")
    elseif targetPID == IMUtilsPID.VChat then
        -- 切换到VCHAT
        Framework.Tools.UI.SetIMUtilsOpenPID(IMUtilsPID.VChat)
        UI:PlayUIAnimation(CoreUI.IMUtils.Tmp_VChat.Grp_Root, UIAnim.IMUtils.UIOpen, 1)
        UDK.UI.SetUIVisibility(CoreUI.IMUtils.Tmp_VChat.Grp_Root, CoreUI.IMUtils.Tmp_TChat.Grp_Root)
        TimerManager:AddTimer(0.3, function()
            isIMUtilsSwitching = false
        end)
        --print("Switch to VChat")
    end
end

-- 统一处理IMUtils打开逻辑
local function handleIMUtilsOpen(targetPID)
    -- 如果正在切换中，则忽略新的切换请求
    if isIMUtilsSwitching then
        return
    end

    isIMUtilsSwitching = true
    local IMUtilsPID = EngineConf.GameUI.UI.IMUtilsPID
    Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)

    if targetPID == IMUtilsPID.TChat then
        -- 打开TCHAT
        Framework.Tools.UI.SetIMUtilsUIOpenState(true)
        Framework.Tools.UI.SetIMUtilsOpenPID(IMUtilsPID.TChat)
        UI:PlayUIAnimation(CoreUI.IMUtils.Tmp_TChat.Grp_Root, UIAnim.IMUtils.UIOpen, 1)
        UDK.UI.SetUIVisibility(CoreUI.IMUtils.Grp_Root, true)
        UDK.UI.SetUIVisibility(CoreUI.IMUtils.Tmp_TChat.Grp_Root, CoreUI.IMUtils.Tmp_VChat.Grp_Root)
        TimerManager:AddTimer(0.3, function()
            isIMUtilsSwitching = false
        end)
        --print("Open TChat")
    elseif targetPID == IMUtilsPID.VChat then
        -- 打开VCHAT
        Framework.Tools.UI.SetIMUtilsUIOpenState(true)
        Framework.Tools.UI.SetIMUtilsOpenPID(IMUtilsPID.VChat)
        UI:PlayUIAnimation(CoreUI.IMUtils.Tmp_VChat.Grp_Root, UIAnim.IMUtils.UIOpen, 1)
        UDK.UI.SetUIVisibility(CoreUI.IMUtils.Grp_Root, true)
        UDK.UI.SetUIVisibility(CoreUI.IMUtils.Tmp_VChat.Grp_Root, CoreUI.IMUtils.Tmp_TChat.Grp_Root)
        TimerManager:AddTimer(0.3, function()
            isIMUtilsSwitching = false
        end)
        --print("Open VChat")
    end
end

-- 统一处理IMUtils关闭逻辑
local function handleIMUtilsClose(targetPID)
    -- 如果正在切换中，则忽略新的切换请求
    if isIMUtilsSwitching then
        return
    end

    isIMUtilsSwitching = true
    local IMUtilsPID = EngineConf.GameUI.UI.IMUtilsPID
    Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClose)

    if targetPID == IMUtilsPID.TChat then
        -- 关闭TCHAT
        Framework.Tools.UI.SetIMUtilsUIOpenState(false)
        UI:PlayUIAnimation(CoreUI.IMUtils.Tmp_TChat.Grp_Root, UIAnim.IMUtils.UIClose, 1)
        TimerManager:AddTimer(0.3, function()
            UDK.UI.SetUIVisibility("", { CoreUI.IMUtils.Grp_Root, CoreUI.IMUtils.Tmp_TChat.Grp_Root })
            isIMUtilsSwitching = false
        end)
        --print("Close TChat")
    elseif targetPID == IMUtilsPID.VChat then
        -- 关闭VCHAT
        Framework.Tools.UI.SetIMUtilsUIOpenState(false)
        UI:PlayUIAnimation(CoreUI.IMUtils.Tmp_VChat.Grp_Root, UIAnim.IMUtils.UIClose, 1)
        TimerManager:AddTimer(0.3, function()
            UDK.UI.SetUIVisibility("", { CoreUI.IMUtils.Grp_Root, CoreUI.IMUtils.Tmp_VChat.Grp_Root })
            isIMUtilsSwitching = false
        end)
        --print("Close VChat")
    end
end

ActMap.MainMenu = {
    -- MenuItem BtnGroup
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_MyProfile] = {
        Pressed = function(ItemUID)
            handleMainMenuSwitch(
                ItemUID,
                EngineConf.GameUI.UI.MainMenuPID.MyProfile,
                CoreUI.MainMenu.Tmp_MyProfile.Grp_Root,
                { CoreUI.MainMenu.Tmp_Settings.Grp_Root, CoreUI.MainMenu.Tmp_Rank.Grp_Root }
            )
        end
    },
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_Settings] = {
        Pressed = function(ItemUID)
            handleMainMenuSwitch(
                ItemUID,
                EngineConf.GameUI.UI.MainMenuPID.Settings,
                CoreUI.MainMenu.Tmp_Settings.Grp_Root,
                { CoreUI.MainMenu.Tmp_MyProfile.Grp_Root, CoreUI.MainMenu.Tmp_Rank.Grp_Root }
            )
        end
    },
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_Rank] = {
        Pressed = function(ItemUID)
            handleMainMenuSwitch(
                ItemUID,
                EngineConf.GameUI.UI.MainMenuPID.RankList,
                CoreUI.MainMenu.Tmp_Rank.Grp_Root,
                { CoreUI.MainMenu.Tmp_MyProfile.Grp_Root, CoreUI.MainMenu.Tmp_Settings.Grp_Root }
            )
        end
    },
    [CoreUI.MainMenu.Tmp_MenuItem.Btn_EShop] = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_MenuItem.BtnPress, 1)
            UDK.Event.FireSignEvent(EngineConf.Map.SignalEvent.OpenStore)
        end
    },
    -- MyProfile Page (Btn Group / UIBase)
    [CoreUI.MainMenu.Tmp_MyProfile.Btn_Help] = {
        Pressed = function()
            local playerID = UDK.Player.GetLocalPlayerID()
            local msg = Framework.Tools.Utils.GetI18NKey("key.message.help", playerID)
            UDK.UI.ShowMessageTip(msg)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
        end
    },
    -- Settings Page (Btn Group / UIBase)
    [CoreUI.MainMenu.Tmp_Settings.Tmp_BtnGroup.Btn_General] = {
        Pressed = function(ItemUID)
            handleSettingsPageSwitch(
                ItemUID,
                CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Grp_Root,
                CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Grp_Root
            )
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_BtnGroup.Btn_Misc] = {
        Pressed = function(ItemUID)
            handleSettingsPageSwitch(
                ItemUID,
                CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Grp_Root,
                CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Grp_Root
            )
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_BtnGroup.Btn_Language] = {
        Pressed = function(ItemUID)
            Framework.Tools.Utils.I18NLangToggle(UDK.Player.GetLocalPlayerID())
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_BtnGroup.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Btn_Reset] = {
        Pressed = function()
            local playerID = UDK.Player.GetLocalPlayerID()
            local msg = Framework.Tools.Utils.GetI18NKey("key.message.reset_setting", playerID)
            UDK.UI.ShowMessageTip(msg)
            Framework.Tools.GameState.SendToServer(playerID, "Act_ResetSetting")
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
        end
    },
    -- Settings Page (General Page)
    [CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Btn_SFXSound] = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.SoundToggle(UDK.Player.GetLocalPlayerID())
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Btn_MicMode] = {
        Pressed = function(ItemUID)
            local playerID = UDK.Player.GetLocalPlayerID()
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            local value = Framework.Tools.Utils.IMChannelToggle(UDK.Player.GetLocalPlayerID(), "Voice")
            local reqMsg = {
                channelType = "Voice",
                isTeam = value
            }
            Framework.Tools.GameState.SendToServer(playerID, "Act_IMRecvToggle", reqMsg)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.Btn_ChatMode] = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            local playerID = UDK.Player.GetLocalPlayerID()
            local value = Framework.Tools.Utils.IMChannelToggle(UDK.Player.GetLocalPlayerID(), "Chat")
            local reqMsg = {
                channelType = "Chat",
                isTeam = value
            }
            Framework.Tools.GameState.SendToServer(playerID, "Act_IMRecvToggle", reqMsg)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    -- Settings Page (Misc Page)
    [CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Btn_Version] = {
        Pressed = function(ItemUID)
            local layoutProp = Config.Engine.Property.KeyMap.UIState.LayoutSettingMiscPID
            local layoutID = Config.Engine.GameUI.UI.Layout_SettingMisc.Version
            Framework.Tools.UI.SetLayoutUIOpenPID(layoutProp, layoutID)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Btn_Credits] = {
        Pressed = function(ItemUID)
            local layoutProp = Config.Engine.Property.KeyMap.UIState.LayoutSettingMiscPID
            local layoutID = Config.Engine.GameUI.UI.Layout_SettingMisc.Credits
            Framework.Tools.UI.SetLayoutUIOpenPID(layoutProp, layoutID)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    [CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.Btn_Feedback] = {
        Pressed = function(ItemUID)
            local layoutProp = Config.Engine.Property.KeyMap.UIState.LayoutSettingMiscPID
            local layoutID = Config.Engine.GameUI.UI.Layout_SettingMisc.Feedback
            Framework.Tools.UI.SetLayoutUIOpenPID(layoutProp, layoutID)
            UI:PlayUIAnimation(ItemUID, UIAnim.MainMenu.Tmp_Settings.Tmp_PageLayout.BtnPress, 1)
        end
    },
    -- Rank Page (Btn Group / UIBase)
    [CoreUI.MainMenu.Tmp_Rank.Btn_Help] = {
        Pressed = function()
            local playerID = UDK.Player.GetLocalPlayerID()
            local msg = Framework.Tools.Utils.GetI18NKey("key.copyright.framework", playerID)
            UDK.UI.ShowMessageTip(msg)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
        end
    },
    -- UIBase
    [CoreUI.MainMenu.Tmp_UIBase.Btn_GRank] = {
        Pressed = function()
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            Rank:DspRankWind()
        end
    },
    [CoreUI.MainMenu.Tmp_UIBase.Btn_Close] = {
        Pressed = function(ItemUID)
            -- 如果主菜单正在切换中，则忽略关闭请求
            if isMainMenuSwitching then
                return
            end

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

            -- 打开后切换到MyProfile子菜单
            handleMainMenuSwitch(
                ItemUID,
                EngineConf.GameUI.UI.MainMenuPID.MyProfile,
                CoreUI.MainMenu.Tmp_MyProfile.Grp_Root,
                { CoreUI.MainMenu.Tmp_Settings.Grp_Root, CoreUI.MainMenu.Tmp_Rank.Grp_Root }
            )
        end
    },
    [CoreUI.ScoreBar.Tmp_ToolBar.Btn_Rank] = {
        Pressed = function(ItemUID)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClick)
            UDK.UI.SetUIVisibility(CoreUI.MainMenu.Grp_Root)
            Framework.Tools.UI.SetMainMenuUIOpenState(true)
            UI:PlayUIAnimation(CoreUI.MainMenu.Grp_Root, UIAnim.MainMenu.UIOpen, 1)
            UI:PlayUIAnimation(ItemUID, 1, 1)

            -- 打开后切换到Rank子菜单
            handleMainMenuSwitch(
                ItemUID,
                EngineConf.GameUI.UI.MainMenuPID.RankList,
                CoreUI.MainMenu.Tmp_Rank.Grp_Root,
                { CoreUI.MainMenu.Tmp_MyProfile.Grp_Root, CoreUI.MainMenu.Tmp_Settings.Grp_Root }
            )
        end
    },
    [CoreUI.ScoreBar.Tmp_IMUtils.Btn_TChat] = {
        Pressed = function()
            local isOpen = Framework.Tools.UI.GetIMUtilsUIOpenState()
            local currentPID = Framework.Tools.UI.GetIMUtilsOpenPID()
            local IMUtilsPID = EngineConf.GameUI.UI.IMUtilsPID

            if isOpen and currentPID == IMUtilsPID.TChat then
                -- 如果TCHAT已打开，点击则关闭
                handleIMUtilsClose(IMUtilsPID.TChat)
            elseif isOpen and currentPID == IMUtilsPID.VChat then
                -- 如果VCHAT已打开，点击TCHAT按钮则切换到TCHAT
                handleIMUtilsSwitch(IMUtilsPID.TChat)
            else
                -- 如果未打开或处于其他状态，则打开TCHAT
                handleIMUtilsOpen(IMUtilsPID.TChat)
            end
        end
    },

    [CoreUI.ScoreBar.Tmp_IMUtils.Btn_VChat] = {
        Pressed = function()
            local isOpen = Framework.Tools.UI.GetIMUtilsUIOpenState()
            local currentPID = Framework.Tools.UI.GetIMUtilsOpenPID()
            local IMUtilsPID = EngineConf.GameUI.UI.IMUtilsPID

            if isOpen and currentPID == IMUtilsPID.VChat then
                -- 如果VCHAT已打开，点击则关闭
                handleIMUtilsClose(IMUtilsPID.VChat)
            elseif isOpen and currentPID == IMUtilsPID.TChat then
                -- 如果TCHAT已打开，点击VCHAT按钮则切换到VCHAT
                handleIMUtilsSwitch(IMUtilsPID.VChat)
            else
                -- 如果未打开或处于其他状态，则打开VCHAT
                handleIMUtilsOpen(IMUtilsPID.VChat)
            end
        end
    },

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

ActMap.IMUtils = {
    [CoreUI.IMUtils.Tmp_TChat.Btn_Close] = {
        Pressed = function()
            handleIMUtilsClose(EngineConf.GameUI.UI.IMUtilsPID.TChat)
        end
    },
    [CoreUI.IMUtils.Tmp_VChat.Btn_Close] = {
        Pressed = function()
            handleIMUtilsClose(EngineConf.GameUI.UI.IMUtilsPID.VChat)
        end
    }
}

ActMap.InGameBtn = {
    [CoreUI.GameBtn.Btn_DoTask] = {
        Pressed = function()
            print("DoTask")
        end
    }
}

ActMap.TeamPop = {
    [CoreUI.TeamPop.Btn_Close] = {
        Pressed = function ()
            UDK.UI.SetUIVisibility(CoreUI.TeamPop.Grp_Root, false)
            Framework.Tools.Sound.Play2DSound(EngineConf.Sound.UI.CommonClose)
            Framework.Tools.UI.SetTeamPopOpenState(false)
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
    ActMap.IMUtils,
    ActMap.InGameBtn,
    ActMap.TeamPop
}

-- 合并所有表
for _, map in ipairs(mapsToMerge) do
    mergeMappings(ActMap.MapResult, map)
end

return ActMap
