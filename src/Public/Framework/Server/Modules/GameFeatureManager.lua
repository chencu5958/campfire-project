-- ==================================================
-- * Campfire Project | Framework/Server/Modules/GameFeatureManager.lua
-- *
-- * Info:
-- * Campfire Project Framework Server - GameFeatureManager
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local GameFeatureManager = {}
local GameStageMap = Config.Engine.Map.GameStage

-- 功能列表和默认值
local gameFeatureList = {
    CharacterCanTakeHurt = true,
    CreatureCanTakeHurt = true,
    TaskAreaCanInteract = true,
    TaskAutoAssign = true,
    GameMatchDataManager = true
}

-- 各阶段功能配置
local stageFeatureConfig = {
    [GameStageMap.Ready] = {  -- Ready
        CharacterCanTakeHurt = false,
        CreatureCanTakeHurt = false,
        TaskAreaCanInteract = false,
        TaskAutoAssign = false,
        GameMatchDataManager = false
    },
    [GameStageMap.Start] = {  -- Start
        CharacterCanTakeHurt = true,
        CreatureCanTakeHurt = true,
        TaskAreaCanInteract = true,
        TaskAutoAssign = true,
        GameMatchDataManager = true
    },
    [GameStageMap.End] = {  -- End
        CharacterCanTakeHurt = false,
        CreatureCanTakeHurt = false,
        TaskAreaCanInteract = false,
        TaskAutoAssign = false,
        GameMatchDataManager = true
    },
    [GameStageMap.DisableGameFeature] = { -- DisableGameFeature
        CharacterCanTakeHurt = false,
        CreatureCanTakeHurt = false,
        TaskAreaCanInteract = false,
        TaskAutoAssign = false,
        GameMatchDataManager = false
    }
}

GameFeatureManager.Type = {
    CharacterCanTakeHurt = "CharacterCanTakeHurt",
    CreatureCanTakeHurt = "CreatureCanTakeHurt",
    TaskAreaCanInteract = "TaskAreaCanInteract",
    TaskAutoAssign = "TaskAutoAssign",
    GameMatchDataManager = "GameMatchDataManager"
}

---| 🎮 获取功能列表
---<br>
---| `范围`：`服务端`
function GameFeatureManager.GetFeatureList()
    return gameFeatureList
end

---| 🎮 检查特定功能是否启用
---<br>
---| `范围`：`服务端`
---@param featureType string 功能类型
function GameFeatureManager.IsFeatureEnabled(featureType)
    return gameFeatureList[featureType] or false
end

---| 🎮 设置特定功能的启用状态
---<br>
---| `范围`：`服务端`
---@param featureType string 功能类型
---@param enabled boolean 是否启用
function GameFeatureManager.SetFeatureEnabled(featureType, enabled)
    if GameFeatureManager.Type[featureType] then
        gameFeatureList[featureType] = enabled
    end
end

---| 🎮 获取功能类型列表
---<br>
---| `范围`：`服务端`
function GameFeatureManager.GetFeatureTypes()
    local types = {}
    for key, _ in pairs(GameFeatureManager.Type) do
        table.insert(types, key)
    end
    return types
end

---| 🎮 根据游戏阶段自动初始化功能开关
---<br>
---| `范围`：`服务端`
---@param gameStage number 游戏阶段
function GameFeatureManager.AutoInit(gameStage)
    local config = stageFeatureConfig[gameStage]
    if config then
        for featureType, enabled in pairs(config) do
            gameFeatureList[featureType] = enabled
        end
    else
        -- 默认情况下启用所有功能
        for featureType, _ in pairs(gameFeatureList) do
            gameFeatureList[featureType] = true
        end
    end
end

---| 🎮 获取当前阶段的功能配置
---<br>
---| `范围`：`服务端`
---@param gameStage number 游戏阶段
function GameFeatureManager.GetStageConfig(gameStage)
    return stageFeatureConfig[gameStage] or stageFeatureConfig[1] -- 默认返回Start阶段配置
end

return GameFeatureManager