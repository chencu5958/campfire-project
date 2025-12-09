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
local TeamIDMap = EngineConf.Map.Team

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
---
---| `范围`：`客户端`
---
---| `功能`：`更新基础UI`
---
---| `更新范围`：`ScoreBar.Tmp_ToolBar.T_TimeCount` - `TimeCountUI`
---
---| `是否从服务器获取数据`：`true`
function ScorebarUI.TimeCountUI()
    local serverData = getServerData()
    local time = UDK.Math.ConvertSecondsToHMS(serverData.Game.PlayTime, "ms")
    UDK.UI.SetUIText(CoreUI.ScoreBar.Tmp_ToolBar.T_TimeCount, time)
end

---| 🔩 - 客户端UI更新（Scorebar）
---
---| `范围`：`客户端`
---
---| `功能`：`更新基础UI`
---
---| `更新范围`：`ScoreBar.Tmp_*Team.T_ScoreCount` - `TeamScoreUI`
---
---| `是否从服务器获取数据`：`true`
function ScorebarUI.TeamScoreUI()
    local serverData = getServerData()
    local redScore, blueScore = tostring(serverData.Team.RedTeam.Score), tostring(serverData.Team.BlueTeam.Score)
    UDK.UI.SetUIText(CoreUI.ScoreBar.Tmp_RedTeam.T_ScoreCount, redScore)
    UDK.UI.SetUIText(CoreUI.ScoreBar.Tmp_BlueTeam.T_ScoreCount, blueScore)
end

---| 🔩 - 客户端UI更新（Scorebar）
---
---| `范围`：`客户端`
---
---| `功能`：`更新基础UI`
---
---| `更新范围`：`ScoreBar.Tmp_ContentBar.Fc_ProgressBar` - `ContentBarUI`
---
---| `是否从服务器获取数据`：`true`
function ScorebarUI.ContentBarUI()
    local serverData = getServerData()
    local taskCount, taskFinishedCount = serverData.Game.TaskCount, serverData.Game.TaskFinishedCount
    local progressCount = UDK.Math.Percentage(taskFinishedCount, taskCount)
    -- 根据玩家队伍自动判断TeamBar UI显示（这部分数据不重要，写在客户端内处理）
    local playerID = UDK.Player.GetLocalPlayerID()
    local playerTeam = Team:GetTeamById(playerID)
    if TeamIDMap.Red == playerTeam then
        UDK.UI.SetUIVisibility(CoreUI.ScoreBar.Tmp_ContentBar.Tmp_TeamBar.Img_RedTeam, true)
        UDK.UI.SetUIVisibility(CoreUI.ScoreBar.Tmp_ContentBar.Tmp_TeamBar.Img_BlueTeam, false)
    elseif TeamIDMap.Blue == playerTeam then
        UDK.UI.SetUIVisibility(CoreUI.ScoreBar.Tmp_ContentBar.Tmp_TeamBar.Img_RedTeam, false)
        UDK.UI.SetUIVisibility(CoreUI.ScoreBar.Tmp_ContentBar.Tmp_TeamBar.Img_BlueTeam, true)
    else
        UDK.UI.SetUIVisibility(CoreUI.ScoreBar.Tmp_ContentBar.Tmp_TeamBar.Img_RedTeam, false)
        UDK.UI.SetUIVisibility(CoreUI.ScoreBar.Tmp_ContentBar.Tmp_TeamBar.Img_BlueTeam, false)
    end
    -- 使用服务器数据，计算并设置进度条
    UDK.UI.SetUIProgressCurrentValue(CoreUI.ScoreBar.Tmp_ContentBar.Fc_ProgressBar, math.ceil(progressCount))
end

return ScorebarUI
