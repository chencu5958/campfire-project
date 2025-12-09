-- ==================================================
-- * Campfire Project | Framework/Client/Extent/TeamPopUI.lua
-- *
-- * Info:
-- * Campfire Project Framework Client UI - TeamPopUI
-- * Managed by AnivaxUI Manager
-- * !! This file does not expose external interfaces !!
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local TeamPopUI = {}
local UIConf, EngineConf = require("Public.Config.UI"), require("Public.Config.Engine")
local CoreUI, KeyMap = UIConf.Core, EngineConf.Property.KeyMap
local TeamIDMap = EngineConf.Map.Team

-- 获取队伍名称文本的I18NKey
local function getTeamNameByTeamID(teamID)
    if type(teamID) ~= "number" then
        Log:PrintError("[Framework:Client] [IMUtilsUI.GetTeamNameByTeamID] 无效的队伍ID，请检查队伍ID是否为数字")
        return "InvalidTeamID"
    end
    local TeamMap = Config.Engine.Map.Team
    local playerID = UDK.Player.GetLocalPlayerID()
    if TeamMap.Red == teamID then
        return Framework.Tools.Utils.GetI18NKey("key.team.red", playerID)
    elseif TeamMap.Blue == teamID then
        return Framework.Tools.Utils.GetI18NKey("key.team.blue", playerID)
    end
end

-- 获取队伍描述文本的I18NKey
local function getTeamdescByTeamID(teamID)
    if type(teamID) ~= "number" then
        Log:PrintError("[Framework:Client] [MainMenuUI.GetTeamdescByTeamID] 无效的队伍ID，请检查队伍ID是否为数字")
        return "InvalidTeamID"
    end
    local TeamMap = Config.Engine.Map.Team
    local playerID = UDK.Player.GetLocalPlayerID()
    if TeamMap.Red == teamID then
        return Framework.Tools.Utils.GetI18NKey("key.teamdesc.red", playerID)
    elseif TeamMap.Blue == teamID then
        return Framework.Tools.Utils.GetI18NKey("key.teamdesc.blue", playerID)
    end
end

---| 🔩 - 客户端UI更新（TeamPop）
---
---| `范围`：`客户端`
---
---| `功能`：`更新基础UI`
---
---| `更新范围`：`TeamPop` - `UI Base`
---
---| `是否从服务器获取数据`：`false`
function TeamPopUI.BaseUI()
    local playerID = UDK.Player.GetLocalPlayerID()
    local playerTeam = Team:GetTeamById(playerID)
    local TeamPop_I18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.teampop", playerID)
    if playerTeam == TeamIDMap.Red then
        UDK.UI.SetUIVisibility(CoreUI.TeamPop.Grp_Root, true)
        UDK.UI.SetUIVisibility(CoreUI.TeamPop.Img_RedTeam, CoreUI.TeamPop.Img_BlueTeam)
        local fmt_TeamPop_I18NKey = string.format(
            TeamPop_I18NKey,
            getTeamNameByTeamID(playerTeam),
            getTeamdescByTeamID(playerTeam)
        )
        UDK.UI.SetUIText(CoreUI.TeamPop.T_TeamInfo, fmt_TeamPop_I18NKey)
    elseif playerTeam == TeamIDMap.Blue then
        UDK.UI.SetUIVisibility(CoreUI.TeamPop.Grp_Root, true)
        UDK.UI.SetUIVisibility(CoreUI.TeamPop.Img_BlueTeam, CoreUI.TeamPop.Img_RedTeam)
        local fmt_TeamPop_I18NKey = string.format(
            TeamPop_I18NKey,
            getTeamNameByTeamID(playerTeam),
            getTeamdescByTeamID(playerTeam)
        )
        UDK.UI.SetUIText(CoreUI.TeamPop.T_TeamInfo, fmt_TeamPop_I18NKey)
    end
end

return TeamPopUI
