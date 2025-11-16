-- ==================================================
-- * Campfire Project | Framework/Server/Modules/AI.lua
-- *
-- * Info:
-- * Campfire Project Framework Server AI - GameAI Manager
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local AI = {}

local AIStauts = {}

-- 存储AI系统元数据，用于均匀分配出生点
local aiSystemMeta = {
    spawnPoints = {}, -- 存储所有出生点及其使用计数
    modelIDs = {}     -- 存储所有模型ID及其使用计数
}

local behaviorActions = {
    ["Move"] = function(creatureID, meta)
        -- 停止当前动画
        if AIStauts[creatureID] and AIStauts[creatureID].currentAnimation then
            local animMeta = AIStauts[creatureID].currentAnimation
            UDK.Motage.StopAnim(
                Animation.PLAYER_TYPE.Creature,
                creatureID,
                animMeta.AnimName,
                animMeta.AnimPartName,
                animMeta.AnimBleedOutTime
            )
            AIStauts[creatureID].currentAnimation = nil
        end

        Creature:SwitchBehaviorToPatrolPath(
            creatureID,
            meta.RoutinePath,
            meta.RoutinePatrolType or Creature.PATROL_TYPE.Single,
            meta.RoutineTime or 99999,
            meta.RoutineEndReturnBornPos or false
        )
    end,
    ["Jump"] = function(creatureID)
        -- 停止当前动画
        if AIStauts[creatureID] and AIStauts[creatureID].currentAnimation then
            local animMeta = AIStauts[creatureID].currentAnimation
            UDK.Motage.StopAnim(
                Animation.PLAYER_TYPE.Creature,
                creatureID,
                animMeta.AnimName,
                animMeta.AnimPartName,
                animMeta.AnimBleedOutTime
            )
            AIStauts[creatureID].currentAnimation = nil
        end

        Creature:Jump(creatureID)
    end,
    ["Dive"] = function(creatureID)
        -- 停止当前动画
        if AIStauts[creatureID] and AIStauts[creatureID].currentAnimation then
            local animMeta = AIStauts[creatureID].currentAnimation
            UDK.Motage.StopAnim(
                Animation.PLAYER_TYPE.Creature,
                creatureID,
                animMeta.AnimName,
                animMeta.AnimPartName,
                animMeta.AnimBleedOutTime
            )
            AIStauts[creatureID].currentAnimation = nil
        end

        Creature:Dive(creatureID)
    end,
    ["Stop"] = function(creatureID)
        -- 停止当前动画
        if AIStauts[creatureID] and AIStauts[creatureID].currentAnimation then
            local animMeta = AIStauts[creatureID].currentAnimation
            UDK.Motage.StopAnim(
                Animation.PLAYER_TYPE.Creature,
                creatureID,
                animMeta.AnimName,
                animMeta.AnimPartName,
                animMeta.AnimBleedOutTime
            )
            AIStauts[creatureID].currentAnimation = nil
        end

        Creature:StopBehaviorTree(creatureID)
    end,
    ["AnimPos"] = function(creatureID, meta)
        UDK.Motage.PlayAnim(
            Animation.PLAYER_TYPE.Creature,
            creatureID,
            meta.AnimName,
            meta.AnimPartName
        )

        -- 记录当前动画状态
        if not AIStauts[creatureID] then
            AIStauts[creatureID] = {}
        end
        AIStauts[creatureID].currentAnimation = {
            AnimName = meta.AnimName,
            AnimPartName = meta.AnimPartName,
            AnimBleedOutTime = meta.AnimBleedOutTime or 0.2
        }
    end,
    ["StopAnimPos"] = function(creatureID, meta)
        UDK.Motage.StopAnim(
            Animation.PLAYER_TYPE.Creature,
            creatureID,
            meta.AnimName,
            meta.AnimPartName,
            meta.AnimBleedOutTime or 0.2
        )
    end
}

-- 中文姓氏列表
local chineseLastNames = {
    "赵", "钱", "孙", "李", "周", "吴", "郑", "王", "冯", "陈",
    "褚", "卫", "蒋", "沈", "韩", "杨", "朱", "秦", "尤", "许",
    "何", "吕", "施", "张", "孔", "曹", "严", "华", "金", "魏",
    "陶", "姜", "戚", "谢", "邹", "喻", "柏", "水", "窦", "章",
    "云", "苏", "潘", "葛", "奚", "范", "彭", "郎", "鲁", "韦",
    "昌", "马", "苗", "凤", "花", "方", "俞", "任", "袁", "柳",
    "酆", "鲍", "史", "唐", "费", "廉", "岑", "薛", "雷", "贺",
    "倪", "汤", "滕", "殷", "罗", "毕", "郝", "邬", "安", "常",
    "乐", "于", "时", "傅", "皮", "卞", "齐", "康", "伍", "余",
    "元", "卜", "顾", "孟", "平", "黄", "和", "穆", "萧", "尹"
}

-- 中文名字列表（单字）
local chineseFirstNamesSingle = {
    "伟", "芳", "娜", "秀英", "敏", "静", "丽", "强", "磊", "军",
    "洋", "勇", "艳", "杰", "娟", "涛", "明", "超", "秀兰", "霞",
    "平", "刚", "桂英", "辉", "红", "梅", "飞", "荣", "华", "亮",
    "成", "琴", "兰", "峰", "洁", "波", "宁", "雪", "丹", "慧",
    "萍", "莉", "斌", "鑫", "龙", "彬", "玉", "浩", "翔", "文",
    "俊", "虎", "嘉", "菡", "婕", "茗", "卿", "琦", "绮", "婌",
    "�", "曦", "翾", "彦", "佑", "佑", "信", "凯", "仲", "修",
    "哲", "峻", "伟", "展", "哲", "盛", "睿", "圣", "然", "宁"
}

-- 中文名字列表（双字）
local chineseFirstNamesDouble = {
    "伟", "芳", "娜", "秀英", "敏", "静", "丽", "强", "磊", "军",
    "洋", "勇", "艳", "杰", "娟", "涛", "明", "超", "秀兰", "霞",
    "平", "刚", "桂英", "辉", "红", "梅", "飞", "荣", "华", "亮",
    "成", "琴", "兰", "峰", "洁", "波", "宁", "雪", "丹", "慧",
    "萍", "莉", "斌", "鑫", "龙", "彬", "玉", "浩", "翔", "文",
    "俊", "虎", "嘉", "菡", "婕", "茗", "卿", "琦", "绮", "�",
    "", "曦", "翾", "彦", "佑", "佑", "信", "凯", "仲", "修",
    "哲", "峻", "伟", "展", "哲", "盛", "睿", "圣", "然", "宁",
    "晓", "冬", "婵", "欢", "翠", "贝", "凝", "阳", "绿", "檀",
    "凡", "易", "傲", "恨", "梦", "幻", "听", "雨", "寒", "初",
    "夏", "惜", "雪", "怜", "安", "尔", "曼", "巧", "映", "雁",
    "香", "醉", "觅", "恨", "山", "桃", "冷", "谷", "夜", "青"
}

--- AI模型ID生成，根据当前模型ID使用情况均匀分配
local function aiModelIDGenerate()
    local modelEntries = Config.Engine.GameInstance.NPCModel

    -- 初始化模型ID列表（如果尚未初始化）
    if next(aiSystemMeta.modelIDs) == nil then
        for key, modelID in pairs(modelEntries) do
            aiSystemMeta.modelIDs[key] = {
                name = key,
                id = modelID,
                count = 0
            }
        end
    end

    -- 查找使用数量最少的模型ID
    local minCount = math.huge
    local candidateModels = {}

    for key, modelData in pairs(aiSystemMeta.modelIDs) do
        if modelData.count < minCount then
            minCount = modelData.count
            candidateModels = { modelData }
        elseif modelData.count == minCount then
            table.insert(candidateModels, modelData)
        end
    end

    -- 在使用数量最少的模型中随机选择一个
    local selectedModel = candidateModels[math.random(1, #candidateModels)]

    -- 更新该模型的使用数量
    aiSystemMeta.modelIDs[selectedModel.name].count = aiSystemMeta.modelIDs[selectedModel.name].count + 1

    -- 返回选中的模型ID
    return selectedModel.id
end

--- 获取地图寻路路径
---@param type string 路径类型
---@param id string? 路径名称（可选，留空默认随机选择）
---@return table | nil pathData 路径数据（nil为无路径数据）
local function getMapRoutinePath(type, id)
    local routinePaths = Config.Engine.AI.RoutinePath

    -- 如果只传入了type参数，则随机返回该类型的一个路径
    if id == nil then
        -- 收集指定类型的所有路径
        local typePaths = {}
        for _, pathData in pairs(routinePaths) do
            if pathData.Type == type then
                table.insert(typePaths, pathData)
            end
        end

        -- 如果找到了该类型的路径，则随机返回一个
        if #typePaths > 0 then
            local randomIndex = math.random(#typePaths)
            return typePaths[randomIndex]
        else
            return nil
        end
    else
        -- 根据类型和名称查找路径
        for _, pathData in pairs(routinePaths) do
            if pathData.Type == type and pathData.Name == id then
                return pathData
            end
        end

        -- 如果没找到匹配项，返回nil
        return nil
    end
end

--- 根据Z轴高度确定路径类型
---@param z number Z轴坐标
---@return string pathType 路径类型 ("Low" 或 "High")
local function getPathTypeByZ(z)
    local lowPointZ = Config.Engine.AI.PointType.LowPoint.PosZ
    if z <= lowPointZ then
        return "Low"
    else
        return "High"
    end
end

--- 获取指定类型和点类型的路径
---@param type string 路径类型 (FullMapPath 或 RoutineMapPath)
---@param pointType string 点类型 (Low 或 High)
---@param id string? 路径名称（可选，留空默认随机选择）
---@return table | nil pathData 路径数据（nil为无路径数据）
local function getMapRoutinePathByPointType(type, pointType, id)
    local routinePaths = Config.Engine.AI.RoutinePath

    -- 如果只传入了type和pointType参数，则随机返回该类型的一个路径
    if id == nil then
        -- 收集指定类型和点类型的所有路径
        local typePaths = {}
        for _, pathData in pairs(routinePaths) do
            if pathData.Type == type and pathData.PointType == pointType then
                table.insert(typePaths, pathData)
            end
        end

        -- 如果找到了该类型的路径，则随机返回一个
        if #typePaths > 0 then
            local randomIndex = math.random(#typePaths)
            return typePaths[randomIndex]
        else
            return nil
        end
    else
        -- 根据类型、点类型和名称查找路径
        for _, pathData in pairs(routinePaths) do
            if pathData.Type == type and pathData.PointType == pointType and pathData.Name == id then
                return pathData
            end
        end

        -- 如果没找到匹配项，返回nil
        return nil
    end
end

--- 获取随机NPC名称
---@return string 随机生成的中文名称
local function getRandomNpcName()
    -- 50%概率生成网络梗名称
    if math.random(100) <= 50 then
        local memeNames = {
            "PVP大佬", "五杀选手", "国服第一", "电竞天才", "上分机器",
            "carry全场", "野王殿下", "辅助之神", "团战噩梦", "操作怪兽",
            "意识帝", "走A怪", "泉水指挥官", "逆风翻盘王", "KDA之神",
            "暴击之王", "吸血鬼", "推塔狂魔", "兵线掌控者", "视野之神",
            "抢人头专业户", "背锅侠", "抗塔先锋", "传送大师", "闪现专家",
            "蹲坑之王", "反野达人", "偷家能手", "打野哲学家", "辅助艺术家",
            "牢大"
        }
        return memeNames[math.random(#memeNames)]
    end

    -- 随机选择姓氏
    local lastName = chineseLastNames[math.random(#chineseLastNames)]

    -- 随机决定是单字名还是双字名 (70%概率单字名, 30%概率双字名)
    local fullName
    if math.random(100) <= 70 then
        -- 单字名
        local firstName = chineseFirstNamesSingle[math.random(#chineseFirstNamesSingle)]
        fullName = lastName .. firstName
    else
        -- 双字名
        local firstName1 = chineseFirstNamesDouble[math.random(#chineseFirstNamesDouble)]
        local firstName2 = chineseFirstNamesDouble[math.random(#chineseFirstNamesDouble)]
        -- 确保双字名不重复
        while firstName1 == firstName2 do
            firstName2 = chineseFirstNamesDouble[math.random(#chineseFirstNamesDouble)]
        end
        fullName = lastName .. firstName1 .. firstName2
    end

    return fullName
end

--- 实现AI系统元数据管理器，用于均匀分配出生点并记录生成数量
local function aiSystemMetaManager()
    local spawnPointList = Config.Engine.AI.SpawnPoint

    -- 初始化出生点列表（如果尚未初始化）
    if next(aiSystemMeta.spawnPoints) == nil then
        for key, point in pairs(spawnPointList) do
            aiSystemMeta.spawnPoints[key] = {
                name = key,
                pos = point.Pos,
                count = 0
            }
        end
    end

    -- 查找生成AI数量最少的出生点
    local minCount = math.huge
    local candidatePoints = {}

    for key, pointData in pairs(aiSystemMeta.spawnPoints) do
        if pointData.count < minCount then
            minCount = pointData.count
            candidatePoints = { pointData }
        elseif pointData.count == minCount then
            table.insert(candidatePoints, pointData)
        end
    end

    -- 在生成数量最少的出生点中随机选择一个
    local selectedPoint = candidatePoints[math.random(1, #candidatePoints)]

    -- 更新该出生点的生成数量
    aiSystemMeta.spawnPoints[selectedPoint.name].count = aiSystemMeta.spawnPoints[selectedPoint.name].count + 1

    -- 返回选中的出生点位置
    return selectedPoint.pos, selectedPoint.name
end

--- 获取出生点位置
---@param type string 出生点类型（H: 高位出生点，L: 低位出生点）
---@param id string? 出生点名称（可选，留空默认随机选择）
---@return table | nil pos 出生点位置（获取失败返回nil）
local function getSpawnPos(type, id)
    local spawnPointList = Config.Engine.AI.SpawnPoint

    -- 如果提供了id，则直接返回对应出生点的位置
    if id ~= nil then
        for key, point in pairs(spawnPointList) do
            if key == id then
                return point.Pos
            end
        end
        return nil -- 如果没有找到匹配的id，返回nil
    end

    -- 如果只提供了type，则筛选该类型的出生点并随机选择
    if type ~= nil then
        local spawnPoints = {}
        for key, point in pairs(spawnPointList) do
            -- 根据type筛选出生点（例如"type"为"H"时匹配"Point_H_1"这样的键名）
            if string.find(key, "_" .. type .. "_") then
                table.insert(spawnPoints, point.Pos)
            end
        end

        -- 如果找到了该类型的出生点，则随机选择一个
        if #spawnPoints > 0 then
            local randomIndex = math.random(1, #spawnPoints)
            return spawnPoints[randomIndex]
        else
            return nil -- 如果没有找到该类型的出生点，返回nil
        end
    end

    -- 如果type和id都没有提供，则从所有出生点中随机选择
    local spawnPoints = {}
    for _, point in pairs(spawnPointList) do
        table.insert(spawnPoints, point.Pos)
    end

    -- 随机选择一个出生点
    local randomIndex = math.random(1, #spawnPoints)
    return spawnPoints[randomIndex]
end

--- 获取一个0.1到1.0之间的随机小数
local function getRandomDecimal()
    local randomInt = math.random(1, 10) -- 生成1到10之间的随机整数
    return randomInt * 0.1               -- 将整数乘以0.1得到0.1、0.2...0.9、1.0之间的随机小数
end

--- 从NexAnimate中随机选择一个动画或根据索引选择动画
---@param index number? 可选的索引参数，如果不提供则随机选择
---@return string animName 选中的动画名称
local function nexAnimateRandomSelect(index)
    local nexAnimates = Config.Engine.Map.NexAnimate
    local anims = {}

    -- 将所有动画名称收集到索引数组中
    for _, animName in pairs(nexAnimates) do
        table.insert(anims, animName)
    end

    -- 如果提供了索引参数，则根据索引选择动画（确保索引在有效范围内）
    if index ~= nil then
        if index > 0 and index <= #anims then
            return anims[index]
        else
            -- 索引超出范围时，使用模运算确保在范围内
            local validIndex = ((index - 1) % #anims) + 1
            return anims[validIndex]
        end
    else
        -- 如果没有提供索引，则随机选择一个动画
        local randomIndex = math.random(1, #anims)
        return anims[randomIndex]
    end
end

--- AI状态机
---@param creatureID number 生物ID
---@param spawnZ number 出生点Z轴坐标
local function aiStateMachine(creatureID, spawnZ)
    local timerID
    local timerName = string.format("AI_%d_BehaviorTimer", creatureID)
    local slotMap = { ["1"] = Animation.PART_NAME.UpperBody, ["2"] = Animation.PART_NAME.FullBody }
    local mapRoutineType = { ["1"] = "FullMapPath", ["2"] = "RoutineMapPath" }
    local isFirstExecution = true -- 标记是否为首次执行
    -- 根据出生点Z轴坐标确定路径类型
    local initialPathPointType = getPathTypeByZ(spawnZ)

    timerID = TimerManager:AddLoopTimer(0.5, function()
        local creatureHP = Damage:GetNPCHealth(creatureID)
        local timerTime = UDK.Timer.GetTimerTime(timerName)
        if creatureHP <= 0 then
            print("Stop AI State Machine!")
            -- 清理当前生物的动画状态
            if AIStauts[creatureID] then
                if AIStauts[creatureID].currentAnimation then
                    local animMeta = AIStauts[creatureID].currentAnimation
                    behaviorActions["StopAnimPos"](creatureID, animMeta)
                end
                AIStauts[creatureID] = nil
            end
            UDK.Timer.RemoveTimer(timerName)
            TimerManager:RemoveTimer(timerID)
        end
        if timerTime == nil then
            UDK.Timer.StartBackwardTimer(timerName, 0, false)
            print("Start AI State Machine!")
            return
        end
        if timerTime <= 0 and creatureHP > 0 then
            -- 随机选择一种行为
            local behaviorChoice = math.random(1, 100)

            -- 如果是首次执行，提高移动概率以避免生成后僵直
            if isFirstExecution then
                -- 首次执行时80%概率移动，10%概率停止并跳舞，10%概率跳跃
                if behaviorChoice <= 80 then
                    -- 移动行为
                    UDK.Timer.StartBackwardTimer(timerName, math.random(3, 10), false, "s", true)
                    Creature:StartBehaviorTree(creatureID)
                    local routineType = mapRoutineType[tostring(math.random(1, UDK.Array.GetLength(mapRoutineType)))]
                    local routinePath
                    -- 如果AI出生在低位，则优先使用与出生点匹配的路径类型
                    if initialPathPointType == "Low" and routineType == "RoutineMapPath" then
                        -- 30%概率使用低位路径，70%概率使用常规随机路径
                        if math.random(1, 100) <= 30 then
                            routinePath = getMapRoutinePathByPointType(routineType, "Low")
                        else
                            routinePath = getMapRoutinePath(routineType)
                        end
                    else
                        routinePath = getMapRoutinePath(routineType)
                    end

                    if routinePath then
                        local meta = {
                            RoutinePath = routinePath.Name,
                        }
                        behaviorActions["Move"](creatureID, meta)
                    end
                elseif behaviorChoice <= 90 then
                    -- 停止并跳舞
                    UDK.Timer.StartBackwardTimer(timerName, 6, false, "s", true)
                    behaviorActions["Stop"](creatureID)
                    local danceAnim = nexAnimateRandomSelect()
                    -- 随机选择动画部位
                    local slotKeys = {}
                    for key, _ in pairs(slotMap) do
                        table.insert(slotKeys, key)
                    end
                    local randomSlotKey = slotKeys[math.random(#slotKeys)]
                    local animPartName = slotMap[randomSlotKey]

                    local meta = {
                        AnimName = danceAnim,
                        AnimPartName = animPartName
                    }
                    behaviorActions["AnimPos"](creatureID, meta)
                else
                    -- 跳跃
                    UDK.Timer.StartBackwardTimer(timerName, 4, false, "s", true)
                    Creature:StartBehaviorTree(creatureID)
                    behaviorActions["Jump"](creatureID)
                end
                isFirstExecution = false -- 标记首次执行已完成
            else
                -- 5% 概率进行跳跃+前扑
                if behaviorChoice <= 5 then
                    UDK.Timer.StartBackwardTimer(timerName, 5, false, "s", true)
                    Creature:StartBehaviorTree(creatureID)
                    behaviorActions["Jump"](creatureID)
                    -- 延迟一点时间再执行前扑动作
                    TimerManager:AddTimer(0.5, function()
                        behaviorActions["Dive"](creatureID)
                    end)

                    -- 15% 概率停止并跳舞
                elseif behaviorChoice <= 20 then
                    UDK.Timer.StartBackwardTimer(timerName, 6, false, "s", true)
                    behaviorActions["Stop"](creatureID)
                    local danceAnim = nexAnimateRandomSelect()
                    -- 随机选择动画部位
                    local slotKeys = {}
                    for key, _ in pairs(slotMap) do
                        table.insert(slotKeys, key)
                    end
                    local randomSlotKey = slotKeys[math.random(#slotKeys)]
                    local animPartName = slotMap[randomSlotKey]

                    local meta = {
                        AnimName = danceAnim,
                        AnimPartName = animPartName
                    }
                    behaviorActions["AnimPos"](creatureID, meta)

                    -- 20% 概率只跳跃
                elseif behaviorChoice <= 40 then
                    UDK.Timer.StartBackwardTimer(timerName, 4, false, "s", true)
                    Creature:StartBehaviorTree(creatureID)
                    behaviorActions["Jump"](creatureID)

                    -- 60% 概率移动
                else
                    UDK.Timer.StartBackwardTimer(timerName, math.random(5, 10), false, "s", true)
                    Creature:StartBehaviorTree(creatureID)
                    local routineType = mapRoutineType[tostring(math.random(1, UDK.Array.GetLength(mapRoutineType)))]
                    local routinePath
                    -- 如果AI出生在低位，则优先使用与出生点匹配的路径类型
                    if initialPathPointType == "Low" and routineType == "RoutineMapPath" then
                        -- 30%概率使用低位路径，70%概率使用常规随机路径
                        if math.random(1, 100) <= 30 then
                            routinePath = getMapRoutinePathByPointType(routineType, "Low")
                        else
                            routinePath = getMapRoutinePath(routineType)
                        end
                    else
                        routinePath = getMapRoutinePath(routineType)
                    end

                    if routinePath then
                        local meta = {
                            RoutinePath = routinePath.Name,
                        }
                        behaviorActions["Move"](creatureID, meta)
                    end
                end
            end
        end
    end)
end

---| 🎮 初始化AI
---<br>
---| `范围`：`服务端`
function AI.Init()
    local i = 0
    local timerID
    timerID = TimerManager:AddLoopTimer(0.1, function()
        if i < Config.Engine.Core.AI.SpawnLimit then
            i = i + 1
            -- 使用aiSystemMetaManager来均匀分配出生点
            local spawnPos, spawnPointName = aiSystemMetaManager()
            AI.SpawnAI(
                aiModelIDGenerate(),
                spawnPos,
                { X = 0, Y = 0, Z = 0 }
            )
        else
            TimerManager:RemoveTimer(timerID)
        end
    end)
end

---| 🎮 生成NPC
---<br>
---| `范围`：`服务端`
---@param id number 生物ID
---@param spawnPos table 出生点位置
---@param spawnRot table 出生点旋转角度
function AI.SpawnAI(id, spawnPos, spawnRot)
    local npcID = Creature:SpawnCreatureBySceneID(id, spawnPos, spawnRot)
    local npcName = Creature:GetName(npcID)
    local npcTypeID = Creature:GetCreatureTypeID(npcID)
    local npcXID = string.format("DianaAI_%s_%s_%s", npcName, npcID, npcTypeID)
    Creature:SetCreatureName(npcID, getRandomNpcName())
    Framework.Tools.LightDMS.SetCustomProperty("String", "DianaAI_UUID", npcXID, npcID)
    aiStateMachine(npcID, spawnPos.Z)
    --Log:PrintLog("Spawn AI: " .. tostring(npcXID))
end

return AI
