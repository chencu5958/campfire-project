-- ==================================================
-- * Campfire Project | Framework/Tools/Utils.lua
-- *
-- * Info:
-- * Campfire Project Framework Utils Tools
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local UtilsTools = {}

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

---| 🧰 - 环境是否为服务端
---<br>
---@return boolean isServer 是否为服务端
function UtilsTools.EnvIsServer()
    local envInfo = envCheck()
    if envInfo.envID == CommonConf.EnvType.Server.ID then
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
    if envInfo.envID == CommonConf.EnvType.Client.ID then
        return true
    else
        local log = createFormatLog("[Utils] 当前环境不是客户端")
        Log:PrintError(log)
        return false
    end
end

return UtilsTools
