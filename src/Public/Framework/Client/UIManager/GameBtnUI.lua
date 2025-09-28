-- ==================================================
-- * Campfire Project | Framework/Client/Extent/GameBtnUI.lua
-- *
-- * Info:
-- * Campfire Project Framework Client UI - GameBtnUi
-- * Managed by AnivaxUI Manager
-- * !! This file does not expose external interfaces !!
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local GameBtnUI = {}
local UIConf, EngineConf = require("Public.Config.UI"), require("Public.Config.Engine")
local CoreUI, KeyMap = UIConf.Core, EngineConf.Property.KeyMap

local function getServerTaskData()
    local fallback = {
        Player = {
            ID = 0
        },
        Task = {
            IsAssigned = true,
            TaskID = 1,
            IsTaskArea = true,
            TaskCurrentProgress = 0,
        },
    }

    return fallback
end

function GameBtnUI.BaseUI()
    local serverData = getServerTaskData()
    if serverData.Task.IsTaskArea and serverData.Task.IsAssigned then
        UDK.UI.SetUIVisibility(CoreUI.GameBtn.Grp_Root, true)
        for i = 1, 100 do
            
            --UDK.UI.SetUIProgressCurrentValue(CoreUI.GameBtn.Fc_ProgresRing, i)
        end
        -- UDK.UI.SetUIProgressCurrentValue(CoreUI.GameBtn.Fc_ProgresRing, 20)
    else
        UDK.UI.SetUIVisibility(CoreUI.GameBtn.Grp_Root, false)
    end
end
local i = 0
TimerManager:AddLoopTimer(0.1,function ()
    i = i + 1
     UDK.UI.SetUIProgressCurrentValue(CoreUI.GameBtn.Fc_ProgresRing, i)
end)

return GameBtnUI
