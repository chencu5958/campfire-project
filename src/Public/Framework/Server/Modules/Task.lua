-- ==================================================
-- * Campfire Project | Framework/Server/Modules/Task.lua
-- *
-- * Info:
-- * Campfire Project Framework Server Task - GameTask Manager
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Task = {}
local KeyMap = Config.Engine.Property.KeyMap
local TeamIDMap = Config.Engine.Map.Team
local GameStageMap = Config.Engine.Map.GameStage
local AnimList = Config.Engine.Map.NexAnimate

local taskConfig = Config.Engine.Task
local guideIcon = Config.Engine.GameInstance.GuideIcon
local coreConfig = Config.Engine.Core.Task
local playerStatusCode = Config.Engine.Map.Status


---| 获取玩家任务领取状态
---@param playerID number 玩家ID
---@return number isClaim  任务领取状态（0:未领取 | 1:已领取）
local function getTaskClaimStatus(playerID)
    local isClaim = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerTaskClaimStatus[1],
        KeyMap.GameState.PlayerTaskClaimStatus[2]
    )
    return isClaim
end

---| 获取玩家状态
---@param playerID number 玩家ID
---@return number status 玩家状态
local function getPlayerStatus(playerID)
    local status = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerStatus[1],
        KeyMap.GameState.PlayerStatus[2]
    )
    return status
end

---| 获取完成任务数量
---@param taskTable table 任务表
---@return table completedTasks 完成任务表
---@return number completedTasksCount 完成任务数量
local function getCompletedTasks(taskTable)
    local completedTasks = {}
    for _, task in ipairs(taskTable) do
        if task.Status.TaskCode == taskConfig.TaskCode.Completed then
            table.insert(completedTasks, task)
        end
    end
    local completedTasksCount = #completedTasks
    return completedTasks, completedTasksCount
end

---| 获取玩家是否在做任务
---@param playerID number 玩家ID
---@return number isDoTask 玩家是否在做任务（0:否 | 1:是）
local function getPlayerIsDoTask(playerID)
    local isDoTask = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerIsDoTask[1],
        KeyMap.GameState.PlayerIsDoTask[2]
    )
    return isDoTask
end

---| 获取玩家是否在任务区域
---@param playerID number 玩家ID
---@return number isInTaskArea 玩家是否在任务区域（0:否 | 1:是）
local function getPlayerIsInTaskArea(playerID)
    local isInTaskArea = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerIsInTaskArea[1],
        KeyMap.GameState.PlayerIsInTaskArea[2]
    )
    return isInTaskArea
end

---| 获取玩家任务领取信息
---@param playerID number 玩家ID
---@return table claimInfo 任务领取信息
local function getTaskClaimInfo(playerID)
    local claimInfo = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerClaimTaskInfo[1],
        KeyMap.GameState.PlayerClaimTaskInfo[2]
    )
    return claimInfo
end

---| 获取玩家任务领取CD时间
---@param playerID number 玩家ID
local function getTackCDTime(playerID)
    local fmt_TimerName = string.format(Config.Engine.Map.Timer.DoTaskTime .. "_%s", playerID)
    local time = UDK.Timer.GetTimerTime(fmt_TimerName)
    return time
end

---| 设置玩家任务领取状态
---@param playerID number 玩家ID
---@param value number 任务领取状态（0:未领取 | 1:已领取）
local function setTaskClaimStatus(playerID, value)
    UDK.Property.SetProperty(
        playerID,
        KeyMap.GameState.PlayerTaskClaimStatus[1],
        KeyMap.GameState.PlayerTaskClaimStatus[2],
        value
    )
end

---| 设置玩家任务领取信息
---@param playerID number 玩家ID
---@param taskID number 任务ID
local function setTackClaimInfo(playerID, taskID)
    local taskInfo = {
        ClaimTaskID = taskID,
    }
    UDK.Property.SetProperty(
        playerID,
        KeyMap.GameState.PlayerClaimTaskInfo[1],
        KeyMap.GameState.PlayerClaimTaskInfo[2],
        taskInfo
    )
end

---| 设置玩家是否在任务区域
---@param playerID number 玩家ID
---@param value number 玩家是否在任务区域（0:否 | 1:是）
local function setPlayerIsInTaskArea(playerID, value)
    UDK.Property.SetProperty(
        playerID,
        KeyMap.GameState.PlayerIsInTaskArea[1],
        KeyMap.GameState.PlayerIsInTaskArea[2],
        value
    )
end

---| 获取玩家当前所在信号盒ID
---@param playerID number 玩家ID
---@return number currentSignalBoxID 当前信号盒ID
local function getPlayerCurrentSignalBox(playerID)
    local currentSignalBoxID = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerCurrentSignalBox[1],
        KeyMap.GameState.PlayerCurrentSignalBox[2]
    )
    return currentSignalBoxID or 0
end

---| 设置玩家当前所在信号盒ID
---@param playerID number 玩家ID
---@param signalBoxID number 信号盒ID
local function setPlayerCurrentSignalBox(playerID, signalBoxID)
    UDK.Property.SetProperty(
        playerID,
        KeyMap.GameState.PlayerCurrentSignalBox[1],
        KeyMap.GameState.PlayerCurrentSignalBox[2],
        signalBoxID
    )
end

---| 验证玩家是否在正确的任务区域
---@param playerID number 玩家ID
---@return boolean isInCorrectArea 是否在正确的任务区域
---@return number taskID 任务ID
---@return number correctSignalBox 正确的信号盒ID
---@return number currentSignalBox 当前信号盒ID
local function validatePlayerTaskArea(playerID)
    local claimStatus = getTaskClaimStatus(playerID)
    local isInTaskArea = getPlayerIsInTaskArea(playerID)
    local currentSignalBox = getPlayerCurrentSignalBox(playerID)

    if claimStatus ~= 1 or isInTaskArea ~= 1 then
        return false, 0, 0, currentSignalBox
    end

    local taskID = 0
    local correctSignalBox = 0

    for i = #taskConfig.TaskList, 1, -1 do
        if taskConfig.TaskList[i].Status.TaskCode == taskConfig.TaskCode.Claimed and
            taskConfig.TaskList[i].Status.ClaimedUIN == playerID then
            taskID = taskConfig.TaskList[i].ID
            correctSignalBox = taskConfig.TaskList[i].BindID.SignalBox
            break
        end
    end

    local isInCorrectArea = (currentSignalBox == correctSignalBox) and (currentSignalBox ~= 0)
    return isInCorrectArea, taskID, correctSignalBox, currentSignalBox
end

---| 设置玩家是否在做任务
---@param playerID number 玩家ID
---@param value number 玩家是否在做任务（0:否 | 1:是）
local function setPlayerIsDoTask(playerID, value)
    UDK.Property.SetProperty(
        playerID,
        KeyMap.GameState.PlayerIsDoTask[1],
        KeyMap.GameState.PlayerIsDoTask[2],
        value
    )
end

---| 任务区域物品销毁
---@param itemTable table 任务区域物品表
local function taskAreaItemDestory(itemTable)
    if #itemTable == 0 then return end
    for _, item in ipairs(itemTable) do
        Element:SetEnableCollision(item, false)
        Element:SetVisibility(item, false)
    end
end

---| 任务指示器显示
---@param playerID number | table 玩家ID
---@param taskTable table 任务表
---@param indexID number 任务索引
---@param mode string 指引显示模式（`Duplicate` | `Warning` | `Destory` | `Update`）
---@param durationTime number? 指示器持续时间（可选）
local function taskManagerGuideDisplay(playerID, taskTable, indexID, mode, durationTime)
    local ElementPos = Element:GetPosition(taskTable[indexID].BindID.Element)
    local PosOffset = taskTable[indexID].Location.Offset
    local ElementOffsetPos = UMath:GetPosOffset(ElementPos, PosOffset.X, PosOffset.Y, PosOffset.Z)
    local TaskInfo = taskTable[indexID]
    local guideInstance = Config.Engine.GameInstance.Item.Element_CommonGuide
    local guideScale = Config.Engine.GameInstance.Scale.Element_CommonGuide
    local guideRot = Engine.Rotator(0, 0, 0)

    -- 更新目标指示器
    local function updateGuideDisplay(int_playerID, int_guideID, int_icon, int_iconHex, int_durationTime)
        UDK.Guide.SetGuidePicture(int_guideID, int_icon, int_iconHex, 1)
        UDK.Guide.SetGuideVisible(int_guideID, true, int_playerID)
        if durationTime ~= nil then
            Element:DestroyByTime(int_guideID, int_durationTime)
        end
    end

    -- 检查目标指示器是否存在
    local function checkGuideElementIsExist(int_ElementID)
        local isExist = MiscService:IsObjectExist(MiscService.EQueryableObjectType.Element, int_ElementID)
        return isExist
    end

    if mode == "Duplicate" then
        local callback = function(elementID)
            TaskInfo.BindID.Guide = elementID
            updateGuideDisplay(playerID, elementID, guideIcon.Icon_Target, guideIcon.Icon_Target_Hex, durationTime)
            UDK.Guide.SetGuideLabelText(elementID, "可破坏")
        end
        Element:SpawnElement(Element.SPAWN_SOURCE.Scene, guideInstance, callback, ElementOffsetPos, guideRot, guideScale)
    elseif mode == "Warning" then
        local elementID = TaskInfo.BindID.Guide
        if not checkGuideElementIsExist(elementID) then
            Log:PrintError("[Framework:Server] TaskManagerGuideDisplay - 指定的目标指引器不存在 " .. elementID)
            return
        end
        updateGuideDisplay(playerID, elementID, guideIcon.Icon_Warning, guideIcon.Icon_Warning_Hex, durationTime)
        UDK.Guide.SetGuideLabelText(elementID, "被破坏")
    elseif mode == "Destory" then
        local elementID = TaskInfo.BindID.Guide
        if not checkGuideElementIsExist(elementID) then
            Log:PrintError("[Framework:Server] TaskManagerGuideDisplay - 指定的目标指引器不存在 " .. elementID)
            return
        end
        Element:Destroy(elementID)
    elseif mode == "Update" then
        local elementID = TaskInfo.BindID.Guide
        if not checkGuideElementIsExist(elementID) then
            Log:PrintError("[Framework:Server] TaskManagerGuideDisplay - 指定的目标指引器不存在 " .. elementID)
            return
        end
        updateGuideDisplay(playerID, elementID, guideIcon.Icon_Target, guideIcon.Icon_Target_Hex, durationTime)
    else
        Log:PrintError("[Framework:Server] TaskManagerGuideDisplay - 无效的模式 " .. mode)
    end
end

---| 任务奖励发放
---@param playerID number 玩家ID
---@param rewardTable table 任务奖励表
local function taskManagerSendReward(playerID, rewardTable)
    local reward = rewardTable
    if reward.Exp ~= nil and type(reward.Exp) == "number" then
        Framework.Server.DataManager.PlayerLevelExpManager(playerID, reward.Exp, "Add")
    end
    if reward.Coin ~= nil and type(reward.Coin) == "number" then
        Framework.Server.DataManager.PlayerEcomonyManager(playerID, "Coin", reward.Coin, "Add")
    end
    if reward.Score ~= nil and type(reward.Score) == "number" then
        Framework.Server.DataManager.PlayerTeamScoreManager(playerID, reward.Score, "Add")
    end
end

---| 任务自动分配
---@param playerID number 玩家ID
local function taskAutoAssign(playerID)
    local ClaimStatus = getTaskClaimStatus(playerID)
    local ClaimColddownStatus = UDK.Property.GetProperty(
        playerID,
        KeyMap.GameState.PlayerTaskColddownStatus[1],
        KeyMap.GameState.PlayerTaskColddownStatus[2]
    )
    local fmt_TimerName = string.format(Config.Engine.Map.Timer.TaskAutoAssign .. "_%s", playerID)
    local AutoAssignTimer = UDK.Timer.GetTimerTime(fmt_TimerName)
    local gameFeatureName = Framework.Server.GameFeatureManager.Type.TaskAutoAssign
    local featureIsEnabled = Framework.Server.GameFeatureManager.IsFeatureEnabled(gameFeatureName)
    if ClaimStatus == 0 and ClaimColddownStatus == 0 and featureIsEnabled then
        if AutoAssignTimer == 0 or AutoAssignTimer == nil then
            print("[Task] Auto Assign Task for Player: " .. playerID)
            Task.ClaimTask(playerID)
            UDK.Timer.StartBackwardTimer(fmt_TimerName, coreConfig.AutoAssignTime, false, "s", true)
        else
            print("[Task] Auto Assign Task for Player: " .. playerID .. " | Timer: " .. AutoAssignTimer)
        end
    end
end

---| 更新任务核心配置
---@param taskTable table 任务表
local function updateTaskCoreConfig(taskTable)
    local taskList, taskCount = getCompletedTasks(taskTable)
    Config.Engine.Core.Task.TaskCompleted = tonumber(taskCount)
end

---| 玩家做任务检查
---@param playerID number 玩家ID
local function playerDoTaskCheck(playerID)
    local isDoTask = getPlayerIsDoTask(playerID)
    local claimStatus = getTaskClaimStatus(playerID)
    local taskCDTime = getTackCDTime(playerID)
    local fmt_TimerName = string.format(Config.Engine.Map.Timer.DoTaskTime .. "_%s", playerID)
    local confTime = coreConfig.DoTaskCDTime
    local animPlayPart = "UpperBody"

    -- 使用新的验证函数检查玩家是否在正确的任务区域
    local isInCorrectArea, taskID, correctSignalBox, currentSignalBox = validatePlayerTaskArea(playerID)

    if isDoTask == 1 and isInCorrectArea and claimStatus == 1 then
        if taskCDTime == 0 or taskCDTime == nil then
            UDK.Motage.PlayAnim(Animation.PLAYER_TYPE.Character, playerID, AnimList.Dance_Fun, animPlayPart)
            local callback = function()
                local time = getTackCDTime(playerID)

                -- 再次验证玩家是否仍在正确的任务区域内
                local isInCorrectArea_Local, taskID_Local, correctSignalBox_Local, currentSignalBox_Local =
                    validatePlayerTaskArea(playerID)

                if not isInCorrectArea_Local then
                    setPlayerIsDoTask(playerID, 0)
                    UDK.Timer.PauseTimer(fmt_TimerName)
                    UDK.Timer.ResetTimer(fmt_TimerName, 0)
                    print("[Task] TaskInterrupted: Player " ..
                        playerID ..
                        " left correct task area. Current: " ..
                        currentSignalBox_Local .. ", Correct: " .. correctSignalBox_Local)
                elseif time >= confTime then
                    setPlayerIsDoTask(playerID, 0)
                    UDK.Motage.StopAnim(Animation.PLAYER_TYPE.Character, playerID, AnimList.Dance_Fun, animPlayPart)
                    UDK.Motage.PlayAnim(Animation.PLAYER_TYPE.Character, playerID, AnimList.TouchHead, animPlayPart)
                    Task.CompleteTask(playerID)
                    UDK.Timer.PauseTimer(fmt_TimerName)
                    UDK.Timer.ResetTimer(fmt_TimerName, 0)
                    print("[Task] TaskCompleted: Player " ..
                        playerID .. " completed task " .. taskID_Local .. " in correct area")
                end
            end
            UDK.Timer.StartForwardTimer(fmt_TimerName, 0, "s", true, callback)
        end
    elseif isDoTask == 1 and not isInCorrectArea then
        -- 如果玩家正在做任务但不在正确区域，中断任务
        setPlayerIsDoTask(playerID, 0)
        UDK.Timer.PauseTimer(fmt_TimerName)
        UDK.Timer.ResetTimer(fmt_TimerName, 0)
        print("[Task] TaskForceInterrupted: Player " ..
            playerID .. " is in wrong area. Current: " .. currentSignalBox .. ", Correct: " .. correctSignalBox)
    end
end

---| 🎮 任务更新
---
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Task.Update(playerID)
    local playerTeamID = Team:GetTeamById(playerID)
    local gameStage = Framework.Tools.Utils.GetGameStage()
    local playerStatus = getPlayerStatus(playerID)
    local claimStatus = getTaskClaimStatus(playerID)
    updateTaskCoreConfig(taskConfig.TaskList)
    if playerStatus ~= playerStatusCode.Alive.ID and claimStatus == 1 then
        Task.RecycleTask(playerID)
        return
    end
    if playerTeamID == TeamIDMap.Blue and gameStage == GameStageMap.Start then
        taskAutoAssign(playerID)
        playerDoTaskCheck(playerID)
    end
end

---| 🎮 领取任务
---
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Task.ClaimTask(playerID)
    local ClaimStatus = getTaskClaimStatus(playerID)
    if ClaimStatus == 0 then
        for i = #taskConfig.TaskList, 1, -1 do
            if taskConfig.TaskList[i].Status.TaskCode == taskConfig.TaskCode.Unclaim then
                taskConfig.TaskList[i].Status.TaskCode = taskConfig.TaskCode.Claimed
                taskConfig.TaskList[i].Status.ClaimedUIN = playerID
                local playerUIN = taskConfig.TaskList[i].Status.ClaimedUIN
                setTaskClaimStatus(playerUIN, 1)
                setTackClaimInfo(playerUIN, taskConfig.TaskList[i].ID)
                taskManagerGuideDisplay(playerUIN, taskConfig.TaskList, i, "Duplicate")
                break -- 修复：确保只领取一个任务就退出循环
            end
        end
    end
end

---| 🎮 完成任务
---
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Task.CompleteTask(playerID)
    local ClaimStatus = getTaskClaimStatus(playerID)
    if ClaimStatus == 1 then
        for i = #taskConfig.TaskList, 1, -1 do
            if taskConfig.TaskList[i].Status.TaskCode == taskConfig.TaskCode.Claimed and taskConfig.TaskList[i].Status.ClaimedUIN == playerID then
                taskConfig.TaskList[i].Status.TaskCode = taskConfig.TaskCode.Completed
                taskConfig.TaskList[i].Status.ClaimedUIN = playerID
                setTaskClaimStatus(playerID, 0)
                setTackClaimInfo(playerID, 0)
                setPlayerIsInTaskArea(playerID, 0)
                setPlayerCurrentSignalBox(playerID, 0)
                setPlayerIsDoTask(playerID, 0)
                if taskConfig.TaskList[i].Feature.AlizaNotice then
                    local alizaNotice = taskConfig.TaskList[i].AlizaNotice
                    if alizaNotice.Type == "SystemMsg" then
                        Framework.Server.Aliza.BoardcastSystemMsg(alizaNotice.Message, alizaNotice.Color)
                    end
                end
                taskAreaItemDestory(taskConfig.TaskList[i].DestoryItem)
                taskManagerSendReward(playerID, taskConfig.TaskList[i].Reward)
                taskManagerGuideDisplay(UDK.Player.GetAllPlayers(), taskConfig.TaskList, i, "Warning",
                    coreConfig.GuideAutoDestory)
                print("[Task] TaskCompleted: Player " ..
                    playerID .. " completed task " .. taskConfig.TaskList[i].ID .. ", all task states reset")
                break -- 修复：确保只完成一个任务就退出循环
            end
        end
    end
end

---| 🎮 回收任务
---
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Task.RecycleTask(playerID)
    local ClaimStatus = getTaskClaimStatus(playerID)
    if ClaimStatus == 1 then
        for i = #taskConfig.TaskList, 1, -1 do
            if taskConfig.TaskList[i].Status.TaskCode == taskConfig.TaskCode.Claimed and taskConfig.TaskList[i].Status.ClaimedUIN == playerID then
                taskConfig.TaskList[i].Status.TaskCode = taskConfig.TaskCode.Unclaim
                taskConfig.TaskList[i].Status.ClaimedUIN = 0
                setTaskClaimStatus(playerID, 0)
                setTackClaimInfo(playerID, 0)
                setPlayerIsInTaskArea(playerID, 0)
                setPlayerCurrentSignalBox(playerID, 0)
                setPlayerIsDoTask(playerID, 0)
                taskManagerGuideDisplay(UDK.Player.GetAllPlayers(), taskConfig.TaskList, i, "Destory")
                print("[Task] TaskRecycled: Player " .. playerID .. " task recycled, all task states reset")
                break -- 修复：确保只回收一个任务就退出循环
            end
        end
    end
end

---| 🎮 添加任务
---
---| `范围`：`服务端`
---@param name string 任务名称
---@param desc string 任务描述
---@param reward table 任务奖励（标准格式  { Coin = 15, Exp = 20, Score = 1 }）
---@param bindID number 任务绑定ID
---@param feature table 任务特性（标准格式 { IsGuide = true, AlizaNotice = true }）
---@param alizaNotice table 任务通知（标准格式 {Type = "SystemMsg", Message = "任务完成", Color = "#FFFFFF"}）
---@param posOffset table 任务位置偏移（格式标准 {X=0, Y=0, Z=0}）
---@param destoryItem table 任务回收物品（标准数组）
---@param taskID number 任务ID
function Task.AddTask(name, desc, reward, bindID, feature, alizaNotice, posOffset, destoryItem, taskID)
    local taskLimit = coreConfig.TaskLimit
    if #taskConfig.TaskList < taskLimit then
        if taskID == nil then
            taskID = #taskConfig.TaskList + 1
        end
        if name == nil or desc == nil then
            Log:PrintError("[Framework:Server] TaskManagerAddTask - 任务名称或描述不能为空")
        end
        local newTask = {
            ID = taskID,
            Name = {
                Default = name,
            },
            Desc = {
                Default = desc,
            },
            Reward = reward or { Coin = 0, Exp = 0, Score = 0 },
            BindID = bindID,
            Feature = feature or {},
            AlizaNotice = alizaNotice or {},
            Location = {
                Offset = posOffset or { X = 0, Y = 0, Z = 0 },
            },
            Status = {
                ClaimedUIN = 0,
                TaskCode = taskConfig.TaskCode.Unclaim,
            },
            DestoryItem = destoryItem,
        }
        table.insert(taskConfig.TaskList, newTask)
        Log:PrintLog("[Framework:Server] TaskManagerAddTask - 添加任务 " .. name)
    else
        Log:PrintError("[Framework:Server] TaskManagerAddTask - 任务数量已达上限 " .. taskLimit)
    end
end

---| 🎮 移除任务
---
---| `范围`：`服务端`
---@param target number 任务ID或任务名称
function Task.RemoveTask(target)
    for i = #taskConfig.TaskList, 1, -1 do
        if taskConfig.TaskList[i].ID == target or taskConfig.TaskList[i].Name.Default == target then
            table.remove(taskConfig.TaskList, i)
            Log:PrintLog("[Framework:Server] TaskManagerRemoveTask - 移除任务 " .. target)
        end
    end
end

---| 🎮 任务区域检测
---
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@param signalBoxID number 信号触发盒ID
---@param eventType string 事件类型（`EnterSignalBox` / `LeaveSignalBox`）
function Task.AreaCheck(playerID, signalBoxID, eventType)
    local ClaimStatus = getTaskClaimStatus(playerID)

    -- 更新玩家当前所在信号盒
    if eventType == "EnterSignalBox" then
        setPlayerCurrentSignalBox(playerID, signalBoxID)
    elseif eventType == "LeaveSignalBox" then
        setPlayerCurrentSignalBox(playerID, 0)
    end

    if ClaimStatus == 1 then
        local isInCorrectTaskArea = false
        local playerTaskID = 0

        for i = #taskConfig.TaskList, 1, -1 do
            if taskConfig.TaskList[i].Status.TaskCode == taskConfig.TaskCode.Claimed and taskConfig.TaskList[i].Status.ClaimedUIN == playerID then
                local taskSignalBox = taskConfig.TaskList[i].BindID.SignalBox
                playerTaskID = taskConfig.TaskList[i].ID

                if signalBoxID == taskSignalBox then
                    isInCorrectTaskArea = true
                    if eventType == "EnterSignalBox" then
                        setPlayerIsInTaskArea(playerID, 1)
                        print("[Task] AreaCheckPass: " ..
                            playerID .. " | " .. signalBoxID .. " | " .. eventType .. " | TaskID: " .. playerTaskID)
                    elseif eventType == "LeaveSignalBox" then
                        setPlayerIsInTaskArea(playerID, 0)
                        print("[Task] PlayerLeaveSignalBox: " ..
                            playerID .. " | " .. signalBoxID .. " | " .. eventType .. " | TaskID: " .. playerTaskID)
                    end
                else
                    -- 如果玩家进入了不属于自己的任务信号盒，确保区域状态为false
                    if eventType == "EnterSignalBox" then
                        setPlayerIsInTaskArea(playerID, 0)
                        print("[Task] WrongTaskArea: " ..
                            playerID ..
                            " entered signalBox " ..
                            signalBoxID .. " but belongs to task " .. playerTaskID .. " with signalBox " .. taskSignalBox)
                    end
                end
                break -- 找到玩家的任务后立即退出循环
            end
        end
    end
    --print("[Task] AreaCheck: " .. playerID .. " | " .. signalBoxID .. " | " .. eventType)
end

---| 🎮 获取玩家任务状态
---
---| `范围`：`服务端`
---@param playerID number 玩家ID
---@return table returnData 返回数据
function Task.GetPlayetTaskStatus(playerID)
    local taskClaimInfo = getTaskClaimInfo(playerID)
    local isInTaskArea = getPlayerIsInTaskArea(playerID)
    local isClaimed = getTaskClaimStatus(playerID)
    local taskCDTime = getTackCDTime(playerID)
    local currentSignalBox = getPlayerCurrentSignalBox(playerID)
    local progress = UDK.Math.Percentage(taskCDTime or 0, coreConfig.DoTaskCDTime)

    if taskClaimInfo ~= nil then
        taskClaimInfo = taskClaimInfo
    else
        taskClaimInfo = {
            ClaimTaskID = 0,
        }
    end

    -- 获取玩家任务的正确信号盒ID用于验证
    local correctSignalBox = 0
    if isClaimed == 1 then
        for i = #taskConfig.TaskList, 1, -1 do
            if taskConfig.TaskList[i].Status.TaskCode == taskConfig.TaskCode.Claimed and
                taskConfig.TaskList[i].Status.ClaimedUIN == playerID then
                correctSignalBox = taskConfig.TaskList[i].BindID.SignalBox
                break
            end
        end
    end

    local returnData = {
        Player = {
            ID = playerID
        },
        Task = {
            IsAssigned = isClaimed == 1,
            TaskID = taskClaimInfo.ClaimTaskID,
            IsTaskArea = isInTaskArea == 1,
            TaskCurrentProgress = progress,
            CurrentSignalBox = currentSignalBox,
            CorrectSignalBox = correctSignalBox,
            IsInCorrectArea = (isInTaskArea == 1) and (currentSignalBox == correctSignalBox),
        },
    }
    return returnData
end

return Task
