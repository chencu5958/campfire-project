-- ==================================================
-- * Campfire Project | Framework/Tools/LightDMS.lua
-- *
-- * Info:
-- * Campfire Project Framework LightDMS Tools
-- * 基于引擎接口二次封装的DMS工具
-- *
-- * Framework Powered By UniX Architecture
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local LightDMS = {}

-- 属性类型映射表
local PropertyTypeMap = {
    Number = 1,
    String = 2,
    Bool = 3,
    Boolean = 3,
    Color = 4,
    Vector = 5,
    Element = 9,
    Particle = 10,
    ChainParticle = 11,
    Audio = 12,
    Image = 13,
    CustomUI = 18,
    CharacterPart = 19,
    Animation = 20,
    RechargeAbility = 21,
    Prop = 22
}

-- 转换属性类型
local function ConvertPropertyType(propertyType)
    if type(propertyType) == "string" then
        return PropertyTypeMap[propertyType] or propertyType
    end
    return propertyType
end

-- 根据玩家ID生成查询名称
local function GenerateQueryNameByPlayerID(propertyName, playerID)
    return propertyName .. "_" .. playerID
    -- body
end

---| 🧰 - 设置自定义属性
---<br>
---| `警告`：`该工具不支持C/S同步`
---<br>
---| `范围`：`服务端` | `客户端`
---@param propertyType string 属性类型
---@param propertyName string|number 属性名称
---@param value any 属性值
---@param playerID number? 玩家ID，用于生成查询名称
function LightDMS.SetCustomProperty(propertyType, propertyName, value, playerID)
    local ElementId = System:GetScriptParentID()
    -- 转换属性类型
    local convertedType, queryName = ConvertPropertyType(propertyType), propertyName
    if playerID then
        -- 生成查询名称
        queryName = GenerateQueryNameByPlayerID(propertyName, playerID)
    end

    if type(value) == "table" then
        CustomProperty:SetCustomPropertyArray(ElementId, queryName, convertedType, value)
    else
        CustomProperty:SetCustomProperty(ElementId, queryName, convertedType, value)
    end
end

---| 🧰 - 获取自定义属性
---<br>
---| `警告`：`该工具不支持C/S同步`
---<br>
---| `范围`：`服务端` | `客户端`
---@param propertyType string 属性类型
---@param propertyName string|number 属性名称
---@param preferArray boolean? 是否优先返回数组属性
---@param playerID number? 玩家ID，用于生成查询名称
---@return any result 属性值，如果不存在返回nil，数组属性不存在返回{}
function LightDMS.GetCustomProperty(propertyType, propertyName, preferArray, playerID)
    local ElementId = System:GetScriptParentID()
    -- 转换属性类型
    local convertedType, queryName = ConvertPropertyType(propertyType), propertyName
    if playerID then
        -- 生成查询名称
        queryName = GenerateQueryNameByPlayerID(propertyName, playerID)
    end

    -- 获取普通属性和数组属性
    local normalResult = CustomProperty:GetCustomProperty(ElementId, queryName, convertedType)
    local arrayResult = CustomProperty:GetCustomPropertyArray(ElementId, queryName, convertedType)

    -- 如果指定优先返回数组属性，则直接返回数组属性（引擎保证至少返回{}）
    if preferArray then
        return arrayResult
    end

    -- 默认情况下，如果有普通属性则返回普通属性，否则返回数组属性
    if normalResult ~= nil then
        return normalResult
    else
        return arrayResult
    end
end

---| 🧰 - 获取自定义属性数组
---<br>
---| `警告`：`该工具不支持C/S同步`
---<br>
---| `范围`：`服务端` | `客户端`
---@param propertyType string 属性类型
---@param propertyName string|number 属性名称
---@return any[] result 数组属性，如果不存在返回{}
function LightDMS.GetCustomPropertyArray(propertyType, propertyName, playerID)
    local ElementId = System:GetScriptParentID()
    -- 转换属性类型
    local convertedType, queryName = ConvertPropertyType(propertyType), propertyName
    if playerID then
        -- 生成查询名称
        queryName = GenerateQueryNameByPlayerID(propertyName, playerID)
    end

    return CustomProperty:GetCustomPropertyArray(ElementId, queryName, convertedType)
end

return LightDMS
