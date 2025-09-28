-- ==================================================
-- * Campfire Project | Framework/Client/Extent/TaskbarUI.lua
-- *
-- * Info:
-- * Campfire Project Framework Client UI - TaskbarUI
-- * Managed by AnivaxUI Manager
-- * !! This file does not expose external interfaces !!
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local TaskbarUI = {}
local UIConf, EngineConf = require("Public.Config.UI"), require("Public.Config.Engine")
local CoreUI, KeyMap = UIConf.Core, EngineConf.Property.KeyMap

-- 获取服务器数据
local function getServerData()
    local serverData = UDK.Property.GetProperty(
        KeyMap.ServerState.NameSpace,
        KeyMap.ServerState.GameState[1],
        KeyMap.ServerState.GameState[2]
    )
    local fallback = {
        Game = {
            PlayTime = 0,
            TaskCount = 0,
            TaskFinishedCount = 0,
        },
        Team = {
            RedTeam = {
                Score = "NaN",
            },
            BlueTeam = {
                Score = "NaN",
            }
        }
    }
    return serverData or fallback
end

-- 获取任务数据
local function getServerTaskData()
    local fallback = {
        Player = {
            ID = 0
        },
        Task = {
            IsAssigned = false,
            TaskID = 1
        },
    }

    return fallback
end

---| 🔩 - 客户端UI更新（Taskbar）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新基础UI`
---<br>
---| `更新范围`：`TaskBar.Tmp_Expand` - `UI Base`
---<br>
---| `是否从服务器获取数据`：`true`
function TaskbarUI.BaseUI()
    local playerID = UDK.Player.GetLocalPlayerID()
    local taskData = getServerTaskData()
    local serverData = getServerData()
    local isAssigned = taskData.Task.IsAssigned
    local taskSys_Title_I18NKey = Framework.Tools.Utils.GetI18NKey("key.tasksys.title", playerID)
    local taskSys_Content_I18NKey
    local taskSys_Footer_I18NKey = Framework.Tools.Utils.GetI18NKey("key.tasksys.taskprogress", playerID)
    local taskProgress = UDK.Math.Percentage(serverData.Game.TaskFinishedCount, serverData.Game.TaskCount)
    local fmt_taskSys_Footer_I18NKey = string.format(taskSys_Footer_I18NKey, math.ceil(taskProgress), 100)
    if isAssigned then
        taskSys_Content_I18NKey = "分配任务"
    else
        taskSys_Content_I18NKey = Framework.Tools.Utils.GetI18NKey("key.tasksys.unassigned", playerID)
    end
    UDK.UI.SetUIText(CoreUI.TaskBar.Tmp_Expand.T_Title, taskSys_Title_I18NKey)
    UDK.UI.SetUIText(CoreUI.TaskBar.Tmp_Expand.T_Content, taskSys_Content_I18NKey)
    UDK.UI.SetUIText(CoreUI.TaskBar.Tmp_Expand.T_Footer, fmt_taskSys_Footer_I18NKey)
end

return TaskbarUI
