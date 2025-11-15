-- ==================================================
-- * Campfire Project | Framework/Tools/GameState.lua
-- *
-- * Info:
-- * Campfire Project Framework GameState Tools
-- *
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local GameState = {}
local GState = require("Public.Framework.Tools.Modules.GState")

GameState.Type = {
    Act_ResetSetting = "Act_ResetSetting",
    Act_IMRecvToggle = "Act_IMRecvToggle",
    Act_TaskSysDoTask = "Act_TaskSysDoTask",
    Act_Client_SetCharacterModelByNPC = "Act_Client_SetCharacterModelByNPC",
    Act_Client_ReconnectInit = "Act_Client_ReconnectInit"
}

local actionHandlers = {
    [GameState.Type.Act_ResetSetting] = GState.SHandle_ResetSetting,
    [GameState.Type.Act_IMRecvToggle] = GState.SHandle_IMRecvToggle,
    [GameState.Type.Act_TaskSysDoTask] = GState.SHandle_TaskSysDoTask,
    [GameState.Type.Act_Client_SetCharacterModelByNPC] = GState.CHandle_SetCharacterModelByNPC,
    [GameState.Type.Act_Client_ReconnectInit] = GState.CHandle_ReconnectInit
}

GameState.Conf = {
    DebugLog = false
}

-- 游戏状态处理函数
local function gameStateHandle()
    return function(msgId, msg, playerID)
        if GameState.Conf.DebugLog then
            Log:PrintLog("[GameState:Debug] Received message:")
            Log:PrintTable(msg)
        end
        -- 增加类型检查
        if type(msg) ~= "table" or not msg.action then
            print("Invalid message format or missing action")
            return
        end

        local action = msg.action
        local playerID = msg.playerID or 0

        -- 增加data字段类型安全检查
        local data = type(msg.data) == "table" and msg.data or {}

        local handler = actionHandlers[action]
        if handler then
            -- 自动解包表参数
            handler(playerID, table.unpack(data))
        else
            local log = string.format("[GameState:Handle] Unknown action: %s from player %d", action, playerID)
            Log:PrintError(log)
        end
    end
end

-- 网络绑定通知初始化
local function networkBindNotifyInit()
    if System.IsServer() then
        System:BindNotify(Config.Engine.NetMsg.GameStateSync.Client, gameStateHandle())
    end

    if System.IsClient() then
        System:BindNotify(Config.Engine.NetMsg.GameStateSync.Server, gameStateHandle())
    end
end

---| 🧰 - 初始化游戏状态网络系统
function GameState.Init()
    networkBindNotifyInit()
end

---|🧰 - 向服务器发送游戏状态同步消息
---<br>
---| `范围`：`客户端`
---@param playerID number 玩家ID
---@param action string 状态动作
---@param ... any? 可变参数，包含需要同步的数据
function GameState.SendToServer(playerID, action, ...)
    local msgID = Config.Engine.NetMsg.GameStateSync.Client
    local msg = {
        playerID = playerID,
        action = action,
        data = { ... }
    }
    System:SendToServer(msgID, msg)
end

---|🧰 - 向客户端发送游戏状态同步消息
---<br>
---@param playerID number 玩家ID
---@param action string 状态动作
---@param ... any? 可变参数，包含需要同步的数据
function GameState.SendToClient(playerID, action, ...)
    local msgID = Config.Engine.NetMsg.GameStateSync.Server
    local msg = {
        playerID = playerID,
        action = action,
        data = { ... }
    }
    System:SendToClient(playerID, msgID, msg)
end

---|🧰 - 向所有客户端发送游戏状态同步消息
---<br>
---@param action string 状态动作
---@param ... any? 可变参数，包含需要同步的数据
function GameState.SendToAllClients(playerID, action, ...)
    local msgID = Config.Engine.NetMsg.GameStateSync.Server
    local msg = {
        playerID = playerID,
        action = action,
        data = { ... }
    }
    System:SendToAllClients(msgID, msg)
end

return GameState
