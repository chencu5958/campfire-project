-- ==================================================
-- * Campfire Project | Framework/Tools/Utils.lua
-- *
-- * Info:
-- * Campfire Project Framework Utils Tools
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local UtilsTools = {}
local parsedTomlI18N = UDK.TomlUtils.Parse(Config.Toml.I18N)
local AppStr = UDK.TomlUtils.Parse(Config.Toml.App)
local LangStr = parsedTomlI18N.i18n
local KeyMap = Config.Engine.Property.KeyMap
local TeamIDMap, TeamHex = Config.Engine.Map.Team, Config.Engine.Map.TeamHex

---| 🧰 - 通用配置
UtilsTools.Conf = {
    EnvType = {
        Standalone = { ID = 0, Name = "Standalone" },
        Server = { ID = 1, Name = "Server" },
        Client = { ID = 2, Name = "Client" }
    }
}

---| 🧰 - 环境检查
---
---| `范围`：`服务端` `客户端`
---@return table {
---     envID: number,       -- 环境ID（Server=1, Client=2, Standalone=0）
---     envName: string,     -- 环境名称（"Server", "Client", "Standalone"）
---     isStandalone: boolean -- 是否为单机模式
---}
local function envCheck()
    local isStandalone = System:IsStandalone()
    local envType = isStandalone and UtilsTools.Conf.EnvType.Standalone or
        (System:IsServer() and UtilsTools.Conf.EnvType.Server or UtilsTools.Conf.EnvType.Client)

    return {
        envID = envType.ID,
        envName = envType.Name,
        isStandalone = isStandalone
    }
end

-- 创建格式化日志
local function createFormatLog(msg)
    local prefix = "[Framework:Tools]"
    local log = string.format("%s %s", prefix, msg)
    return log
end

-- 获取当前语言
local function getCurrentLang(playerID)
    local value = UDK.Property.GetProperty(playerID, KeyMap.PSetting.Lang[1], KeyMap.PSetting.Lang[2])
    if value == nil then
        value = "zh-CN"
    end
    return value
end

---| 🧰 - 环境是否为服务端
---
---@return boolean isServer 是否为服务端
function UtilsTools.EnvIsServer()
    local envInfo = envCheck()
    if envInfo.envID == UtilsTools.Conf.EnvType.Server.ID or envInfo.isStandalone then
        return true
    else
        local log = createFormatLog("[Utils] 当前环境不是服务端")
        Log:PrintError(log)
        return false
    end
end

---| 🧰 - 环境是否为客户端
---
---@return boolean isClient 是否为客户端
function UtilsTools.EnvIsClient()
    local envInfo = envCheck()
    if envInfo.envID == UtilsTools.Conf.EnvType.Client.ID or envInfo.isStandalone then
        return true
    else
        local log = createFormatLog("[Utils] 当前环境不是客户端")
        Log:PrintError(log)
        return false
    end
end

---| 🧰 - 获取环境信息
---
---@return table {
---     envID: number,       -- 环境ID（Server=1, Client=2, Standalone=0）
---     envName: string,     -- 环境名称（"Server", "Client", "Standalone"）
---     isStandalone: boolean -- 是否为单机模式
---}
function UtilsTools.GetEnvInfo()
    return envCheck()
end

---| 🧰 - 获取I18N文本
---
---| `范围`：`服务端` | `客户端`
---@param key string 键值
---@param playerID number 玩家ID
---@param lang string? 语言（留空则根据玩家设置自动获取）
---@return string langText 语言文本
---@return boolean isExist 键值是否存在
function UtilsTools.GetI18NKey(key, playerID, lang)
    local queryLang = lang or getCurrentLang(playerID)
    if type(queryLang) ~= "string" then
        Log:PrintError("[Utils] I18N语言参数类型错误")
    end
    return UDK.I18N.I18NGetKey(key, queryLang, LangStr)
end

---| 🧰 - 切换I18N语言
---
---| `范围`：`服务端` | `客户端`
---@param playerID number 玩家ID
function UtilsTools.I18NLangToggle(playerID)
    local currentLang = getCurrentLang(playerID)
    local nextLang = currentLang == "zh-CN" and "en-US" or "zh-CN"
    UDK.Property.SetProperty(playerID, KeyMap.PSetting.Lang[1], KeyMap.PSetting.Lang[2], nextLang)
    UDK.Storage.ArchiveUpload(playerID, KeyMap.PSetting.Lang[1], KeyMap.PSetting.Lang[2], nextLang)
end

---| 🧰 - 获取App信息文本
---
---| `范围`：`服务端` | `客户端`
---@param key string 键值
---@return string langText 语言文本
---@return boolean isExist 键值是否存在
function UtilsTools.GetAppInfoKey(key)
    return UDK.I18N.I18NGetKey(key, "App", AppStr)
end

---| 🧰 - IM频道切换
---
---| `范围`：`服务端` | `客户端`
---@param playerID number 玩家ID
---@param channelType string 频道类型 ("Voice", "Chat")
---@return boolean newValue 是否为团队频道
function UtilsTools.IMChannelToggle(playerID, channelType)
    local newValue
    if channelType == "Voice" then
        local isTeamChannel = UtilsTools.GetIMVoiceIsTeamChannel(playerID)
        newValue = not isTeamChannel
        UDK.Property.SetProperty(playerID, KeyMap.PSetting.TeamMic[1], KeyMap.PSetting.TeamMic[2], newValue)
        UDK.Storage.ArchiveUpload(playerID, KeyMap.PSetting.TeamMic[1], KeyMap.PSetting.TeamMic[2], newValue)
    elseif channelType == "Chat" then
        local isTeamChannel = UtilsTools.GetIMChatIsTeamChannel(playerID)
        newValue = not isTeamChannel
        UDK.Property.SetProperty(playerID, KeyMap.PSetting.TeamChat[1], KeyMap.PSetting.TeamChat[2], newValue)
        UDK.Storage.ArchiveUpload(playerID, KeyMap.PSetting.TeamChat[1], KeyMap.PSetting.TeamChat[2], newValue)
    else
        local log = createFormatLog("[Utils] IM频道切换参数错误")
        Log:PrintError(log)
    end
    return newValue
end

---| 🧰 - 获取IM语音是否为团队频道
---
---| `范围`：`服务端` | `客户端`
---@param playerID number 玩家ID
---@return boolean isTeamChannel 是否为团队频道
function UtilsTools.GetIMVoiceIsTeamChannel(playerID)
    local value = UDK.Property.GetProperty(playerID, KeyMap.PSetting.TeamMic[1], KeyMap.PSetting.TeamMic[2])
    if value == nil then
        value = false
    end
    return value
end

---| 🧰 - 获取IM聊天是否为团队频道
---
---| `范围`：`服务端` | `客户端`
---@param playerID number 玩家ID
---@return boolean isTeamChannel 是否为团队频道
function UtilsTools.GetIMChatIsTeamChannel(playerID)
    local value = UDK.Property.GetProperty(playerID, KeyMap.PSetting.TeamChat[1], KeyMap.PSetting.TeamChat[2])
    if value == nil then
        value = false
    end
    return value
end

---| 🧰 - 获取玩家队伍Hex代码
---
---| `范围`：`服务端` | `客户端`
---@param playerID number 玩家ID
---@return string teamHex 队伍Hex代码
function UtilsTools.GetTeamHexByPlayerID(playerID)
    local playerTeam = Team:GetTeamById(playerID)
    if playerTeam == TeamIDMap.Red then
        return TeamHex.Red
    elseif playerTeam == TeamIDMap.Blue then
        return TeamHex.Blue
    else
        return TeamHex.None
    end
end

---| 🧰 - 获取队伍名称Hex代码
---
---| `范围`：`服务端` | `客户端`
---@param code string 队伍名称
---@return string teamHex 队伍Hex代码
function UtilsTools.GetTeamHexByCode(code)
    if type(code) ~= "string" then
        Log:PrintError("[Utils] 获取队伍名称Hex代码参数错误")
    end
    if code == "Red" then
        return TeamHex.Red
    elseif code == "Blue" then
        return TeamHex.Blue
    elseif code == "NPC" then
        return TeamHex.NPC
    else
        return TeamHex.None
    end
end

---| 🧰 - 设置游戏阶段
---
---| `范围`：`服务端`
function UtilsTools.SetGameStage(stageCode)
    if type(stageCode) ~= "number" then
        Log:PrintError("[Utils] 设置游戏阶段参数错误")
    end
    local queryKey = KeyMap.GameState.GameStage
    UDK.Property.SetProperty(KeyMap.GameState.NameSpace, queryKey[1], queryKey[2], stageCode, queryKey[4])
end

---| 🧰 - 获取游戏阶段
---
---| `范围`：`服务端`
function UtilsTools.GetGameStage()
    return UDK.Property.GetProperty(
        KeyMap.GameState.NameSpace,
        KeyMap.GameState.GameStage[1],
        KeyMap.GameState.GameStage[2],
        KeyMap.GameState.GameStage[4]
    )
end

return UtilsTools
