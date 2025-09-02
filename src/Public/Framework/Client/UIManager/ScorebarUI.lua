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

---| 🎮 更新计时器UI
function ScorebarUI.TimeCountUI()
    local serverData = getServerData()
    local time = UDK.Math.ConvertSecondsTohms(serverData.Game.PlayTime, "ms")
    UDK.UI.SetUIText(CoreUI.ScoreBar.Tmp_ToolBar.T_TimeCount, time)
end

---| 🎮 更新队伍计分UI
function ScorebarUI.TeamScoreUI()
    local serverData = getServerData()
    local redScore, blueScore = tostring(serverData.Team.RedTeam.Score), tostring(serverData.Team.BlueTeam.Score)
    UDK.UI.SetUIText(CoreUI.ScoreBar.Tmp_RedTeam.T_ScoreCount, redScore)
    UDK.UI.SetUIText(CoreUI.ScoreBar.Tmp_BlueTeam.T_ScoreCount, blueScore)
end

return ScorebarUI
