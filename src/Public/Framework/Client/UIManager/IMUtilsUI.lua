-- ==================================================
-- * Campfire Project | Framework/Client/Extent/IMUtilsUI.lua
-- *
-- * Info:
-- * Campfire Project Framework Client UI - IMUtilsUI
-- * Managed by AnivaxUI Manager
-- * !! This file does not expose external interfaces !!
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local IMUtilsUI = {}
local UIConf, EngineConf = require("Public.Config.UI"), require("Public.Config.Engine")
local CoreUI, KeyMap = UIConf.Core, EngineConf.Property.KeyMap

-- 获取IM频道聊天范围的I18NKey
local function getIMChannelAreaKeyByBool(boolean)
    if type(boolean) ~= "boolean" then
        Log:PrintError("[Framework:Client] [IMUtilsUI.GetIMChannelToggleKeyByBool] 无效的IM频道开关，请检查开关是否为布尔值")
        return "InvalidBool"
    end
    local playerID = UDK.Player.GetLocalPlayerID()
    if boolean then
        return Framework.Tools.Utils.GetI18NKey("key.toggle.team", playerID)
    else
        return Framework.Tools.Utils.GetI18NKey("key.toggle.global", playerID)
    end
end

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

-- 更新频道信息显示
local function updateChannelInfo(isTChat, playerIsTeamChannel, playerTeam, envInfo, playerID)
    local IMUtils_I18NKey
    if envInfo.isStandalone then
        IMUtils_I18NKey = Framework.Tools.Utils.GetI18NKey("key.imutils.standalone", playerID)
    else
        IMUtils_I18NKey = Framework.Tools.Utils.GetI18NKey("key.imutils.info", playerID)
        IMUtils_I18NKey = string.format(
            IMUtils_I18NKey,
            getTeamNameByTeamID(playerTeam),
            getIMChannelAreaKeyByBool(playerIsTeamChannel)
        )
    end

    if isTChat then
        UDK.UI.SetUIText(CoreUI.IMUtils.Tmp_TChat.T_ChannelInfo, IMUtils_I18NKey)
    else
        UDK.UI.SetUIText(CoreUI.IMUtils.Tmp_VChat.T_ChannelInfo, IMUtils_I18NKey)
    end
end

---| 🔩 - 客户端UI更新（IMUtils）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新基础UI`
---<br>
---| `更新范围`：`IMUtils` - `UI Base`
---<br>
---| `是否从服务器获取数据`：`false`
function IMUtilsUI.BaseUI()
    local playerID = UDK.Player.GetLocalPlayerID()
    local IMUtilsPID = Framework.Tools.UI.GetIMUtilsOpenPID()
    local envInfo = Framework.Tools.Utils.GetEnvInfo()
    local playerTeam = Team:GetTeamById(playerID)

    -- TChat
    if IMUtilsPID == EngineConf.GameUI.UI.IMUtilsPID.TChat then
        local playerIsTeamChannel = Framework.Tools.Utils.GetIMChatIsTeamChannel(playerID)
        updateChannelInfo(true, playerIsTeamChannel, playerTeam, envInfo, playerID)
        UDK.UI.SetUIVisibility(CoreUI.IMUtils.Tmp_TChat.Img_FuncDisable, envInfo.isStandalone)
    end

    -- VChat
    if IMUtilsPID == EngineConf.GameUI.UI.IMUtilsPID.VChat then
        local playerIsTeamChannel = Framework.Tools.Utils.GetIMVoiceIsTeamChannel(playerID)
        updateChannelInfo(false, playerIsTeamChannel, playerTeam, envInfo, playerID)
    end
end

return IMUtilsUI
