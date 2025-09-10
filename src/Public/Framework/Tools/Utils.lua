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

local CommonConf = {
    EnvType = {
        Standalone = { ID = 0, Name = "Standalone" },
        Server = { ID = 1, Name = "Server" },
        Client = { ID = 2, Name = "Client" }
    }
}

---| 🧰 - 环境检查
---<br>
---| `范围`：`服务端` `客户端`
---@return table {
---     envID: number,       -- 环境ID（Server=1, Client=2, Standalone=0）
---     envName: string,     -- 环境名称（"Server", "Client", "Standalone"）
---     isStandalone: boolean -- 是否为单机模式
---}
local function envCheck()
    local isStandalone = System:IsStandalone()
    local envType = isStandalone and CommonConf.EnvType.Standalone or
        (System:IsServer() and CommonConf.EnvType.Server or CommonConf.EnvType.Client)

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
---<br>
---@return boolean isServer 是否为服务端
function UtilsTools.EnvIsServer()
    local envInfo = envCheck()
    if envInfo.envID == CommonConf.EnvType.Server.ID or envInfo.isStandalone then
        return true
    else
        local log = createFormatLog("[Utils] 当前环境不是服务端")
        Log:PrintError(log)
        return false
    end
end

---| 🧰 - 环境是否为客户端
---<br>
---@return boolean isClient 是否为客户端
function UtilsTools.EnvIsClient()
    local envInfo = envCheck()
    if envInfo.envID == CommonConf.EnvType.Client.ID or envInfo.isStandalone then
        return true
    else
        local log = createFormatLog("[Utils] 当前环境不是客户端")
        Log:PrintError(log)
        return false
    end
end

---| 🧰 - 获取I18N文本
---<br>
---| `范围`：`服务端` | `客户端`
---@param key string 键值
---@param playerID number 玩家ID
---@param lang string? 语言（留空则根据玩家设置自动获取）
---@return string langText 语言文本
function UtilsTools.GetI18NKey(key, playerID, lang)
    local queryLang = lang or getCurrentLang(playerID)
    if type(queryLang) ~= "string" then
        Log:PrintError("[Utils] I18N语言参数类型错误")
    end
    return UDK.I18N.I18NGetKey(key, queryLang, LangStr)
end

---| 🧰 - 切换I18N语言
---<br>
---| `范围`：`服务端` | `客户端`
---@param playerID number 玩家ID
function UtilsTools.I18NLangToggle(playerID)
    local currentLang = getCurrentLang(playerID)
    local nextLang = currentLang == "zh-CN" and "en-US" or "zh-CN"
    UDK.Property.SetProperty(playerID, KeyMap.PSetting.Lang[1], KeyMap.PSetting.Lang[2], nextLang)
    UDK.Storage.ArchiveUpload(playerID, KeyMap.PSetting.Lang[1], KeyMap.PSetting.Lang[2], nextLang)
end

---| 🧰 - 获取App信息文本
---<br>
---| `范围`：`服务端` | `客户端`
---@param key string 键值
---@return string langText 语言文本
function UtilsTools.GetAppInfoKey(key)
    return UDK.I18N.I18NGetKey(key, "App", AppStr)
end

---| 🧰 - IM频道切换
---<br>
---| `范围`：`服务端` | `客户端`
---@param playerID number 玩家ID
---@param channelType string 频道类型 ("Voice", "Chat")
function UtilsTools.IMChannelToggle(playerID, channelType)
    if channelType == "Voice" then
        local isTeamChannel = UtilsTools.GetIMVoiceIsTeamChannel(playerID)
        UDK.Property.SetProperty(playerID, KeyMap.PSetting.TeamMic[1], KeyMap.PSetting.TeamMic[2], not isTeamChannel)
        UDK.Storage.ArchiveUpload(playerID, KeyMap.PSetting.TeamMic[1], KeyMap.PSetting.TeamMic[2], not isTeamChannel)
    elseif channelType == "Chat" then
        local isTeamChannel = UtilsTools.GetIMChatIsTeamChannel(playerID)
        UDK.Property.SetProperty(playerID, KeyMap.PSetting.TeamChat[1], KeyMap.PSetting.TeamChat[2], not isTeamChannel)
        UDK.Storage.ArchiveUpload(playerID, KeyMap.PSetting.TeamChat[1], KeyMap.PSetting.TeamChat[2], not isTeamChannel)
    else
        local log = createFormatLog("[Utils] IM频道切换参数错误")
        Log:PrintError(log)
    end
end

---| 🧰 - 获取IM语音是否为团队频道
---<br>
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
---<br>
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

return UtilsTools
