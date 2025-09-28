-- ==================================================
-- * Campfire Project | Framework/Client/Init.lua
-- *
-- * Info:
-- * Campfire Project Framework Client Init
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local ClientInit = {}
local KeyMap = Config.Engine.Property.KeyMap
local TeamIDMap = Config.Engine.Map.Team
local TimerMap = Config.Engine.Map.Timer

-- 初始化客户端属性数据
local function clientPropretyInit()
    -- 遍历 UIState 中的所有属性并初始化
    for _, value in pairs(KeyMap.UIState) do
        Framework.Tools.LightDMS.SetCustomProperty(
            value[1], -- 类型
            value[2], -- 属性名称
            value[3]  -- 默认值
        )
    end
end

-- 初始化客户端相机
local function clientCameraInit()
    local playerID = UDK.Player.GetLocalPlayerID()
    local playerTeam = Team:GetTeamById(playerID)
    if TeamIDMap.Red == playerTeam then
        Camera:SetCameraView(Camera.PRESET_TYPE.ShootView)
    elseif TeamIDMap.Blue == playerTeam then
        Camera:SetCameraView(Camera.PRESET_TYPE.DefaultFree)
    else
        Camera:SetCameraView(Camera.PRESET_TYPE.DefaultFree)
    end
end

-- 初始化客户端音乐
local function clientMusicInit()
    TimerManager:AddLoopTimer(0.1, function()
        local musicTimer = UDK.Timer.GetTimerTime(TimerMap.ClientMusicTimer)
        if musicTimer == nil or musicTimer == 0 then
            local playID = math.random(1, 5)
            local musicTime = Music:GetMusicDurationTime(playID)
            UDK.Timer.StartBackwardTimer(TimerMap.ClientMusicTimer, musicTime, false, "s", true)
            Music:PlayMusic(playID)
        end
    end)
end

-- 初始化客户端功能
local function clientFeatureInit()
    Guide:SetGuideShowLimit(Config.Engine.Core.Task.GuideShowLimit)
end

---| 🎮 客户端UI初始化
function ClientInit.InitUI()
    local GameUI, UIConf, ActMap = Config.Engine.GameUI, Config.UI, Config.ActMap
    UDK.UI.SetNativeInterfaceVisible(GameUI.Init.NativeInterfaceHidden, false)
    UDK.UI.RegisterButtonEvent(UIConf.BtnUIDResult, ActMap.MapResult)
end

---| 🎮 客户端游戏逻辑初始化
function ClientInit.InitGame()
    clientPropretyInit()
    -- 必要的延迟初始化，不这么做会遇到一些问题
    TimerManager:AddTimer(0.1, function()
        clientCameraInit()
        clientMusicInit()
        clientFeatureInit()
    end)
end

return ClientInit
