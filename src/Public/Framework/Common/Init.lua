-- ==================================================
-- * Campfire Project | Framework/Common/Init.lua
-- *
-- * Info:
-- * Campfire Project Framework Common Init
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Init = {}

---| ⚙️ 游戏逻辑初始化
function Init.OnBeginPlay()
    if System:IsClient() then
        Gamelogic.Client.Init()
        TimerManager:AddLoopTimer(0.1, function()
            Gamelogic.Client.Update()
        end)
    end

    if System:IsServer() then
        Gamelogic.Server.Init()
        TimerManager:AddLoopTimer(0.2, function()
            Gamelogic.Server.Update()
        end)
    end
end

---| ⚙️ 脚本元件逻辑结束
function Init.OnEndPlay()
    if System:IsClient() then
        Log:PrintLog("Client End")
    end
    if System:IsServer() then
        Log:PrintServerLog("Server End")
    end
end

return Init