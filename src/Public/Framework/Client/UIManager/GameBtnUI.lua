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

-- 获取服务器任务数据
local function getServerTaskData()
    local serverData = UDK.Property.GetProperty(
        UDK.Player.GetLocalPlayerID(),
        KeyMap.UserData.TaskData[1],
        KeyMap.UserData.TaskData[2]
    )
    local fallback = {
        Player = {
            ID = 0
        },
        Task = {
            IsAssigned = false,
            TaskID = 1,
            IsTaskArea =false,
            TaskCurrentProgress = 0,
        },
    }
    return serverData or fallback
end

---| 🔩 - 客户端UI更新（GameBtn）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新基础UI`
---<br>
---| `更新范围`：`GameBtn` - `UI Base`
---<br>
---| `是否从服务器获取数据`：`true`
function GameBtnUI.BaseUI()
    local serverData = getServerTaskData()
    if serverData.Task.IsTaskArea and serverData.Task.IsAssigned then
        UDK.UI.SetUIVisibility(CoreUI.GameBtn.Grp_Root, true)
        UDK.UI.SetUIProgressCurrentValue(CoreUI.GameBtn.Fc_ProgresRing, serverData.Task.TaskCurrentProgress)
    else
        UDK.UI.SetUIVisibility(CoreUI.GameBtn.Grp_Root, false)
    end
end

return GameBtnUI
