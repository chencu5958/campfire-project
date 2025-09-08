-- ==================================================
-- * Campfire Project | Framework/Server/Init.lua
-- *
-- * Info:
-- * Campfire Project Framework Server Init
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local ServerInit = {}
local KeyMap = Config.Engine.Property.KeyMap

-- 玩家属性初始化
local function playerPropertyInit(playerID)
    local cloudInitStatus = UDK.Storage.ArchiveGet(playerID, KeyMap.CloudData.InitStatus[1],
        KeyMap.CloudData.InitStatus[2])
    -- 如果玩家未初始化和云存储相关的持久化数据，则进行初始化，否则则读取数据并赋值给玩家
    if cloudInitStatus == nil or cloudInitStatus == false then
        cloudInitStatus = UDK.Property.SetProperty(playerID, KeyMap.CloudData.InitStatus[1],
            KeyMap.CloudData.InitStatus[2], true)
        UDK.Storage.ArchiveUpload(playerID, KeyMap.CloudData.InitStatus[1], KeyMap.CloudData.InitStatus[2],
            cloudInitStatus)
        -- 遍历PSetting中的所有属性并初始化
        for _, value in pairs(KeyMap.PSetting) do
            UDK.Property.SetProperty(playerID, value[1], value[2], value[3])
            print("玩家属性初始化: " .. value[1] .. " = " .. tostring(value[3]) .. " | " .. value[2])
            UDK.Storage.ArchiveUpload(playerID, value[1], value[2], value[3])
        end
    else
        -- 遍历PSetting中的所有属性并初始化
        for _, value in pairs(KeyMap.PSetting) do
            UDK.Storage.ArchiveGet(playerID, value[1], value[2])
            UDK.Property.SetProperty(playerID, value[1], value[2], value[3])
        end
    end
end

---| 🎮 服务器游戏逻辑初始化
function ServerInit.InitGame()
    for _, v in ipairs(UDK.Player.GetAllPlayers()) do
        playerPropertyInit(v)
    end
end

return ServerInit
