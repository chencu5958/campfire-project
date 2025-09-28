-- ==================================================
-- * Campfire Project | Framework/Client/AlizaClient.lua
-- *
-- * Info:
-- * Campfire Project Framework AlizaNoticeX ClientSide Implement
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local AlizaClient = {}

-- 统一消息队列（用于处理所有类型的消息）
local messageQueue = {}

-- 消息计数器（用于生成唯一ID）
local messageCounter = 0

-- 最近处理的消息缓存（用于去重）
local recentMessages = {}
local MAX_RECENT_MESSAGES = 50

-- 已显示完成的消息ID记录（用于防止短时间内重复显示相同消息）
local displayedMessages = {}
local MAX_DISPLAYED_MESSAGES = 50

-- TipsBar状态标记
AlizaClient.tipsBar1Busy = false
AlizaClient.tipsBar2Busy = false

-- 当前显示的消息定时器
local activeTimers = {}

-- 生成唯一消息ID
local function generateUniqueMessageId(msgType, msgContent)
    messageCounter = messageCounter + 1

    -- 基础ID组成：消息类型 + 时间戳 + 计数器
    local baseId = msgType .. "_" .. (msgContent.timestamp or UDK.Math.GetTimestamp()) .. "_" .. messageCounter

    -- 根据消息类型添加额外标识信息
    if msgType == "KillNotice" and msgContent.killer and msgContent.victim then
        -- 击杀通知：添加击杀者和被击杀者ID
        return baseId .. "_" .. (msgContent.killer.playerID or "") .. "_" .. (msgContent.victim.playerID or "")
    elseif msgType == "SystemMsg" and msgContent.message then
        -- 系统消息：添加消息内容的哈希值（简化版）
        local msgHash = 0
        for i = 1, #msgContent.message do
            msgHash = (msgHash * 31 + string.byte(msgContent.message, i)) % 1000000
        end
        return baseId .. "_" .. msgHash
    end

    return baseId
end

---| 🎮 初始化Aliza通知系统客户端逻辑
function AlizaClient.InitNet()
    local isClient = Framework.Tools.Utils.EnvIsClient()

    -- 客户端逻辑
    if isClient then
        local MsgId = Config.Engine.NetMsg.AlizaNotice.ServerBoardcast

        -- 使用增强的消息去重机制，防止重复处理相同消息
        System:BindNotify(MsgId, function(MsgID, Msg)
            -- 生成消息唯一标识
            local msgId = generateUniqueMessageId(Msg.MsgType, Msg.MsgContent)

            -- 检查是否已处理过该消息
            if recentMessages[msgId] then
                Log:PrintLog("忽略重复消息: " .. msgId)
                return
            end

            -- 记录已处理的消息
            recentMessages[msgId] = {
                timestamp = UDK.Math.GetTimestamp(),
                type = Msg.MsgType,
                content = Msg.MsgContent
            }

            -- 清理过期消息（保留最近的MAX_RECENT_MESSAGES条）
            local messageCount = 0
            local oldestTimestamp = UDK.Math.GetTimestamp() + 1
            local oldestKey = nil

            for key, data in pairs(recentMessages) do
                messageCount = messageCount + 1
                if data.timestamp < oldestTimestamp then
                    oldestTimestamp = data.timestamp
                    oldestKey = key
                end
            end

            if messageCount > MAX_RECENT_MESSAGES and oldestKey then
                recentMessages[oldestKey] = nil
            end

            -- 处理消息
            if Msg.MsgType == "KillNotice" then
                AlizaClient.AddMessageToQueue("KillNotice", Msg.MsgContent)
            elseif Msg.MsgType == "SystemMsg" then
                AlizaClient.AddMessageToQueue("SystemMsg", Msg.MsgContent)
            end
        end)
    end
end

---| 🎮 添加消息到队列
---@param msgType string 消息类型
---@param msgData table 消息数据
function AlizaClient.AddMessageToQueue(msgType, msgData)
    -- 为消息生成唯一ID
    local msgId = nil
    if msgType == "KillNotice" and msgData.killer and msgData.victim then
        -- 使用击杀者ID、被击杀者ID和武器类型（如果有）生成唯一标识
        local weaponType = msgData.weaponType or "unknown"
        msgId = msgData.killer.playerID .. "_" .. msgData.victim.playerID .. "_" .. weaponType

        -- 添加序列号，确保即使相同玩家短时间内多次击杀也能区分
        msgData.noticeId = msgId .. "_" .. UDK.Math.GetTimestamp() .. "_" .. messageCounter
        messageCounter = messageCounter + 1
        msgId = msgData.noticeId
    elseif msgType == "SystemMsg" and msgData.message then
        -- 计算消息内容的简单哈希值
        local msgHash = 0
        for i = 1, #msgData.message do
            msgHash = (msgHash * 31 + string.byte(msgData.message, i)) % 1000000
        end

        -- 生成唯一ID
        msgId = "sysMsg_" .. msgHash

        -- 添加序列号，确保相同内容的消息也能区分
        msgData.msgId = msgId .. "_" .. UDK.Math.GetTimestamp() .. "_" .. messageCounter
        messageCounter = messageCounter + 1
        msgId = msgData.msgId
    end

    -- 检查是否是刚显示完的消息（防止短时间内重复显示相同内容）
    if msgId and displayedMessages[msgId] then
        Log:PrintLog("忽略刚显示完的" .. msgType .. "消息ID: " .. msgId)
        return
    end

    -- 检查是否存在重复消息在队列中
    if msgId then
        for _, existingMsg in ipairs(messageQueue) do
            if existingMsg.id and existingMsg.id == msgId then
                Log:PrintLog("忽略重复的" .. msgType .. "消息ID: " .. msgId)
                return
            end

            -- 兼容旧版本没有msgId的情况，使用传统方式检查
            if not existingMsg.id then
                if msgType == "KillNotice" and existingMsg.type == "KillNotice" and
                    existingMsg.data.killer and msgData.killer and
                    existingMsg.data.victim and msgData.victim and
                    existingMsg.data.killer.playerID == msgData.killer.playerID and
                    existingMsg.data.victim.playerID == msgData.victim.playerID and
                    existingMsg.timestamp and msgData.timestamp and
                    math.abs(existingMsg.timestamp - msgData.timestamp) < 1 then
                    Log:PrintLog("忽略重复的击杀通知: " .. msgData.killer.playerName .. " 击杀 " .. msgData.victim.playerName)
                    return
                elseif msgType == "SystemMsg" and existingMsg.type == "SystemMsg" and
                    existingMsg.data.message == msgData.message and
                    existingMsg.timestamp and msgData.timestamp and
                    math.abs(existingMsg.timestamp - msgData.timestamp) < 1 then
                    Log:PrintLog("忽略重复的系统消息: " .. msgData.message)
                    return
                end
            end
        end
    end

    -- 确保消息有时间戳
    if not msgData.timestamp then
        msgData.timestamp = UDK.Math.GetTimestamp()
    end

    -- 构造统一消息结构
    local unifiedMsg = {
        type = msgType,
        data = msgData,
        id = msgId,
        timestamp = msgData.timestamp
    }

    table.insert(messageQueue, unifiedMsg)
    Log:PrintLog(msgType .. " added to queue. Size: " .. #messageQueue .. (msgId and (", ID: " .. msgId) or ""))

    -- 尝试处理消息（支持并行显示）
    AlizaClient.ProcessMessages()
end

---| 🎮 处理消息队列
function AlizaClient.ProcessMessages()
    if #messageQueue == 0 then
        return
    end

    local tmp_TipsBar = Config.UI.Core.ScoreBar.Tmp_ContentBar.Tmp_TipsBar

    -- 检查TipsBar1是否空闲
    if not AlizaClient.tipsBar1Busy then
        -- 查找第一个未被使用的消息
        for i = 1, #messageQueue do
            if not messageQueue[i].inUse then
                local msgData = messageQueue[i]
                msgData.inUse = true -- 标记为正在使用
                AlizaClient.tipsBar1Busy = true
                AlizaClient.ShowMessage(msgData, tmp_TipsBar.TipsBar1, 1, i)
                break
            end
        end
    end

    -- 检查TipsBar2是否空闲
    if not AlizaClient.tipsBar2Busy then
        -- 查找第一个未被使用的消息（与TipsBar1不同）
        for i = 1, #messageQueue do
            if not messageQueue[i].inUse then
                local msgData = messageQueue[i]
                msgData.inUse = true -- 标记为正在使用
                AlizaClient.tipsBar2Busy = true
                AlizaClient.ShowMessage(msgData, tmp_TipsBar.TipsBar2, 2, i)
                break
            end
        end
    end
end

---| 🎮 显示消息
---@param msgData table 消息数据
---@param tipsBarElement table 提示栏元素
---@param barIndex number 提示栏索引
---@param queueIndex number 队列索引
function AlizaClient.ShowMessage(msgData, tipsBarElement, barIndex, queueIndex)
    -- 根据消息类型显示不同内容
    if msgData.type == "KillNotice" then
        local playerID, killMsg = UDK.Player.GetLocalPlayerID(), "未指定Type"
        if msgData.data.killer.killerTipType == "KillPlayer" then
            killMsg = Framework.Tools.Utils.GetI18NKey("key.killertip.killer", playerID)
        elseif msgData.data.killer.killerTipType == "KillNPC" then
            killMsg = Framework.Tools.Utils.GetI18NKey("key.killertip.killnpc", playerID)
        elseif msgData.data.killer.killerTipType == "KillByVoid" then
            killMsg = Framework.Tools.Utils.GetI18NKey("key.killertip.suicide", playerID)
        end
        Log:PrintLog("Showing kill notice: " ..
            msgData.data.killer.playerName .. " killed " .. msgData.data.victim.playerName .. " on TipsBar" .. barIndex)
        UDK.UI.SetUIText(tipsBarElement.T_PlayerIDLeft, msgData.data.killer.playerName)
        UDK.UI.SetUITextColor(tipsBarElement.T_PlayerIDLeft, msgData.data.killer.playerColor or "#FFFFFF")
        UDK.UI.SetUIText(tipsBarElement.T_PlayerIDRight, msgData.data.victim.playerName or "")
        UDK.UI.SetUITextColor(tipsBarElement.T_PlayerIDRight, msgData.data.victim.playerColor or "#FFFFFF")
        UDK.UI.SetUIText(tipsBarElement.T_Content, killMsg)
        UDK.UI.SetUITextColor(tipsBarElement.T_Content, msgData.data.killer.killerTipColor or "#FFFFFF")
    elseif msgData.type == "SystemMsg" then
        Log:PrintLog("Showing system message: " .. msgData.data.message .. " on TipsBar" .. barIndex)
        UDK.UI.SetUIText(tipsBarElement.T_PlayerIDLeft, "")
        UDK.UI.SetUIText(tipsBarElement.T_PlayerIDRight, "")
        UDK.UI.SetUIText(tipsBarElement.T_Content, msgData.data.message)
        UDK.UI.SetUITextColor(tipsBarElement.T_Content, msgData.data.messageColor or "#FFFFFF")
    end

    UDK.Animation.FadeIn(tipsBarElement.Grp_Root)

    -- 显示时间（击杀通知显示3秒，系统消息显示3秒）
    local displayTime = 3

    -- 清除可能存在的旧定时器
    if activeTimers[barIndex] then
        TimerManager:RemoveTimer(activeTimers[barIndex])
    end

    -- 设置新的定时器
    activeTimers[barIndex] = TimerManager:AddTimer(displayTime, function()
        local options = {
            onComplete = function()
                -- 设置对应的通知栏为空闲状态
                if barIndex == 1 then
                    AlizaClient.tipsBar1Busy = false
                elseif barIndex == 2 then
                    AlizaClient.tipsBar2Busy = false
                end

                -- 清除定时器引用
                activeTimers[barIndex] = nil

                -- 记录已显示的消息ID，防止短时间内重复显示
                if msgData.id then
                    displayedMessages[msgData.id] = UDK.Math.GetTimestamp()

                    -- 清理过期的显示记录
                    local displayedCount = 0
                    local oldestTimestamp = UDK.Math.GetTimestamp() + 1
                    local oldestKey = nil

                    for key, timestamp in pairs(displayedMessages) do
                        displayedCount = displayedCount + 1
                        if timestamp < oldestTimestamp then
                            oldestTimestamp = timestamp
                            oldestKey = key
                        end
                    end

                    if displayedCount > MAX_DISPLAYED_MESSAGES and oldestKey then
                        displayedMessages[oldestKey] = nil
                    end
                end

                -- 从队列中移除已显示的消息（根据队列索引移除对应的消息）
                table.remove(messageQueue, queueIndex)
                Log:PrintLog(msgData.type .. " displayed and removed from queue on TipsBar" .. barIndex)

                -- 处理下一个消息（但首先要检查队列是否为空）
                if #messageQueue > 0 then
                    AlizaClient.ProcessMessages()
                end
            end
        }
        UDK.Animation.FadeOut(tipsBarElement.Grp_Root, options)
    end)
end

---| 🎮 清空所有队列
function AlizaClient.ClearAllQueues()
    -- 清除所有活动定时器
    for barIndex, timerId in pairs(activeTimers) do
        TimerManager:RemoveTimer(timerId)
        activeTimers[barIndex] = nil
    end

    messageQueue = {}
    recentMessages = {}
    displayedMessages = {}
    AlizaClient.tipsBar1Busy = false
    AlizaClient.tipsBar2Busy = false
    Log:PrintLog("所有消息队列已清空")
end

---| 🎮 获取队列状态
function AlizaClient.GetQueueStatus()
    local status = {
        messageQueueSize = #messageQueue,
        recentMessagesCount = 0,
        tipsBar1Busy = AlizaClient.tipsBar1Busy,
        tipsBar2Busy = AlizaClient.tipsBar2Busy
    }

    for _ in pairs(recentMessages) do
        status.recentMessagesCount = status.recentMessagesCount + 1
    end

    return status
end

---| 🎮 重置消息计数器
function AlizaClient.ResetMessageCounter()
    messageCounter = 0
    Log:PrintLog("消息计数器已重置")
end

return AlizaClient


-- * 不要问为什么AlizaNoticeX的UI处理被单独拆出去了，嘻嘻OvO
-- * 因为懒了不想和UIManager架构耦合到一起，作为单独的实现拆出去了
-- * ⣿⣿⣿⠿⠿⣿⣿⡿⢋⣶⣶⣬⣙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
-- * ⣿⡿⢡⣿⣷⣶⣦⣥⣿⣿⣿⣿⣿⣷⣮⡛⢿⣿⣿⣿⣿⣿⣿⣿
-- * ⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢮⡙⣿⣿⣯⢐⡎⣿
-- * ⣿⢹⣿⣿⣿⣿⣿⣿⡿⣡⡬⢿⣿⣿⣿⣶⣶⣼⣦⠥⣖⣩⣾⣿
-- * ⣿⢸⣿⣿⣿⡿⣿⣿⣿⣿⠇⣌⢛⣻⣿⣿⣟⣛⣿⣧⠹⣿⣿⣿
-- * ⠏⣼⣿⣿⢏⣾⣿⣟⣩⣶⣶⣿⣿⣿⣿⣿⡟⡿⢸⡿⣡⣿⣿⣿
-- * ⣼⣿⣿⠇⣼⣿⣿⢸⠋⠁⠉⢽⣿⣿⣿⣟⣠⣤⣆⢃⢻⣿⣿⣿
-- * ⣿⣿⣿⣼⣿⣿⣿⡞⣿⣿⣷⣾⣿⣿⣿⣿⡿⠟⠛⠸⢦⣙⡋⣿
-- * ⣿⣿⣿⠹⣿⣿⡿⠗⣈⣭⣭⣭⣉⠻⡟⣩⣶⣾⣿⣿⣶⡙⣱⣿
-- * ⣿⣿⣿⣷⣌⡛⠠⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⢸⣿
-- * ⣿⣿⣿⣿⢏⣴⣧⣴⡘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣱⣶⣴⡜⢸⣿
-- * ⣿⣿⣿⢃⣾⣿⣿⣿⡷⠉⢿⣿⣿⣿⣿⣿⣿⢰⣾⣿⣿⣧⢸⣿
