-- ==================================================
-- * Campfire Project | Framework/Client/Extent/ScorebarUI.lua
-- *
-- * Info:
-- * Campfire Project Framework Client UI - ScorebarUI
-- * Managed by AnivaxUI Manager
-- * !! This file does not expose external interfaces !!
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local ScorebarUI = {}
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

---| 🔩 - 客户端UI更新（Scorebar）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新基础UI`
---<br>
---| `更新范围`：`ScoreBar.Tmp_ToolBar.T_TimeCount` - `TimeCountUI`
---<br>
---| `是否从服务器获取数据`：`true`
function ScorebarUI.TimeCountUI()
    local serverData = getServerData()
    local time = UDK.Math.ConvertSecondsToHMS(serverData.Game.PlayTime, "ms")
    UDK.UI.SetUIText(CoreUI.ScoreBar.Tmp_ToolBar.T_TimeCount, time)
end

---| 🔩 - 客户端UI更新（Scorebar）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新基础UI`
---<br>
---| `更新范围`：`ScoreBar.Tmp_*Team.T_ScoreCount` - `TeamScoreUI`
---<br>
---| `是否从服务器获取数据`：`true`
function ScorebarUI.TeamScoreUI()
    local serverData = getServerData()
    local redScore, blueScore = tostring(serverData.Team.RedTeam.Score), tostring(serverData.Team.BlueTeam.Score)
    UDK.UI.SetUIText(CoreUI.ScoreBar.Tmp_RedTeam.T_ScoreCount, redScore)
    UDK.UI.SetUIText(CoreUI.ScoreBar.Tmp_BlueTeam.T_ScoreCount, blueScore)
end

---| 🔩 - 客户端UI更新（Scorebar）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新基础UI`
---<br>
---| `更新范围`：`ScoreBar.Tmp_ContentBar.Fc_ProgressBar` - `ContentBarUI`
---<br>
---| `是否从服务器获取数据`：`true`
function ScorebarUI.ContentBarUI()
    local serverData = getServerData()
    local taskCount, taskFinishedCount = serverData.Game.TaskCount, serverData.Game.TaskFinishedCount
    local progressCount = UDK.Math.Percentage(taskFinishedCount, taskCount)
    --UDK.UI.SetUIProgressMaxValue(CoreUI.ScoreBar.Tmp_ContentBar.Fc_ProgressBar, taskCount)
    UDK.UI.SetUIProgressCurrentValue(CoreUI.ScoreBar.Tmp_ContentBar.Fc_ProgressBar, math.ceil(progressCount))
    --alizaNoticeXUIManager()
end

return ScorebarUI
