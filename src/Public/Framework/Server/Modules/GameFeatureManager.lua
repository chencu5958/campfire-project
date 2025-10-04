-- ==================================================
-- * Campfire Project | Framework/Server/Modules/GameFeatureManager.lua
-- *
-- * Info:
-- * Campfire Project Framework Server - GameFeatureManager
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local GameFeatureManager = {}

local gameFeatureList = {
    CharacterCanTakeHurt = true,
    CreatureCanTakeHurt = true,
    TaskAreaCanInteract = false,
}

GameFeatureManager.Type = {
    CharacterCanTakeHurt = "CharacterCanTakeHurt",
    CreatureCanTakeHurt = "CreatureCanTakeHurt",
    TaskAreaCanInteract = "TaskAreaCanInteract",
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

return GameFeatureManager