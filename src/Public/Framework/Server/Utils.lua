-- ==================================================
-- * Campfire Project | Framework/Server/Utils.lua
-- *
-- * Info:
-- * Campfire Project Framework Server Utils
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Utils = {}
local KeyMap = Config.Engine.Property.KeyMap
local TeamIDMap = Config.Engine.Map.Team
local StatusCodeMap = Config.Engine.Map.Status

-- 玩家断线检查
local function playerDiscoonectCheck(playerID)
    local timeoutCallback = function()
        --print("Player:", playerID, "is disconnected")
        Framework.Tools.LightDMS.SetCustomProperty(
            KeyMap.GameState.PlayerIsDisconnect[1],
            KeyMap.GameState.PlayerIsDisconnect[2],
            true,
            playerID
        )
    end
    local responseCallback = function()
        --print("Player:", playerID, "is still connected")
        Framework.Tools.LightDMS.SetCustomProperty(
            KeyMap.GameState.PlayerIsDisconnect[1],
            KeyMap.GameState.PlayerIsDisconnect[2],
            false,
            playerID
        )
    end
    UDK.Heartbeat.SendWithTracking(playerID, timeoutCallback, responseCallback)
end

-- 玩家图标显示器位置修正
local function playerBindDisplayPosCorr(playerID, displayID, displayType)
    local playerPos = Character:GetPosition(playerID)
    local offsetPos_HPBar = Config.Engine.GameInstance.Offset.Icon_Dsp_PlayerHP_Bar
    local offsetPos_Team = Config.Engine.GameInstance.Offset.Icon_Dsp_Team
    local offsetPos_playerHP = UMath:GetPosOffset(playerPos, offsetPos_HPBar.X, offsetPos_HPBar.Y, offsetPos_HPBar.Z)
    local offsetPos_TeamIcon = UMath:GetPosOffset(playerPos, offsetPos_Team.X, offsetPos_Team.Y, offsetPos_Team.Z)
    if displayType == "PlayerHP_Bar" then
        Element:SetPosition(displayID, offsetPos_playerHP, Element.COORDINATE.WORLD)
    elseif displayType == "PlayerTeam_Tag" then
        Element:SetPosition(displayID, offsetPos_TeamIcon, Element.COORDINATE.WORLD)
    end
end

-- 玩家图标显示器更新
local function playerBindDisplayUpdate(playerID)
    local isExist = MiscService:IsObjectExist(MiscService.EQueryableObjectType.Player, playerID)
    local playerStatus = Framework.Tools.LightDMS.GetCustomProperty(
        KeyMap.GameState.PlayerStatus[1],
        KeyMap.GameState.PlayerStatus[2],
        false,
        playerID
    )
    local playerHPTagID = Framework.Tools.LightDMS.GetCustomProperty(
        KeyMap.GameState.PlayerBindHPBarID[1],
        KeyMap.GameState.PlayerBindHPBarID[2],
        false,
        playerID
    )
    local playerTeamTagID = Framework.Tools.LightDMS.GetCustomProperty(
        KeyMap.GameState.PlayerBindTeamTagID[1],
        KeyMap.GameState.PlayerBindTeamTagID[2],
        false,
        playerID
    )
    if type(playerHPTagID) == "number" and isExist then
        if playerStatus == StatusCodeMap.Alive.ID then
            UDK.UI.SetUIVisibility(playerHPTagID, true)
            local playerLifeMax = Damage:GetCharacterMaxLifeCount(playerID)
            local playerLife = Damage:GetCharacterLifeCount(playerID)
            local progress = UDK.Math.Percentage(playerLife, playerLifeMax, true)
            FuncElement:SetProgressBoardValue(playerHPTagID, progress)
            playerBindDisplayPosCorr(playerID, playerHPTagID, "PlayerHP_Bar")
        else
            UDK.UI.SetUIVisibility(playerHPTagID, false)
        end
    elseif type(playerHPTagID) == "number" and not isExist then
        UDK.UI.SetUIVisibility(playerHPTagID, false)
        Element:Destroy(playerHPTagID)
    end
    if type(playerTeamTagID) == "number" and isExist then
        if playerStatus == StatusCodeMap.Alive.ID then
            UDK.UI.SetUIVisibility(playerTeamTagID, true)
            playerBindDisplayPosCorr(playerID, playerTeamTagID, "PlayerTeam_Tag")
        else
            UDK.UI.SetUIVisibility(playerTeamTagID, false)
        end
    elseif type(playerTeamTagID) == "number" and not isExist then
        UDK.UI.SetUIVisibility(playerTeamTagID, false)
        Element:Destroy(playerTeamTagID)
    end
    return isExist
end

function Utils.Update()

end

---| 🎮 - 玩家状态检查
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerStatusCheck(playerID)
    playerDiscoonectCheck(playerID)
    local playerLife = Damage:GetCharacterLifeCount(playerID)
    local playerIsDisconnect = Framework.Tools.LightDMS.GetCustomProperty(
        KeyMap.GameState.PlayerIsDisconnect[1],
        KeyMap.GameState.PlayerIsDisconnect[2],
        false,
        playerID
    )
    local playerIsExist = MiscService:IsObjectExist(MiscService.EQueryableObjectType.Player, playerID)
    if playerLife <= 0 and not playerIsDisconnect then
        Framework.Tools.LightDMS.SetCustomProperty(
            KeyMap.GameState.PlayerStatus[1],
            KeyMap.GameState.PlayerStatus[2],
            StatusCodeMap.Dead.ID,
            playerID
        )
    elseif playerLife > 0 and not playerIsDisconnect then
        Framework.Tools.LightDMS.SetCustomProperty(
            KeyMap.GameState.PlayerStatus[1],
            KeyMap.GameState.PlayerStatus[2],
            StatusCodeMap.Alive.ID,
            playerID
        )
    elseif playerIsDisconnect then
        Framework.Tools.LightDMS.SetCustomProperty(
            KeyMap.GameState.PlayerStatus[1],
            KeyMap.GameState.PlayerStatus[2],
            StatusCodeMap.Disconnect.ID,
            playerID
        )
    elseif not playerIsExist then
        Framework.Tools.LightDMS.SetCustomProperty(
            KeyMap.GameState.PlayerStatus[1],
            KeyMap.GameState.PlayerStatus[2],
            StatusCodeMap.Exit.ID,
            playerID
        )
    end
end

---| 🎮 - 玩家图标显示器初始化
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerInGameDisplay(playerID)
    -- 为不同元素创建专门的绑定回调函数
    local function createCallBack(elementType)
        return function(elementID)
            print("Spawned Element:", elementID, "for player:", playerID, "Type:", elementType)
            if elementType == "PlayerHP_Bar" then
                -- 处理玩家HP条的特殊逻辑
                Framework.Tools.LightDMS.SetCustomProperty(
                    KeyMap.GameState.PlayerBindHPBarID[1],
                    KeyMap.GameState.PlayerBindHPBarID[2],
                    elementID,
                    playerID
                )
                Element:BindingToCharacterOrNPC(
                    elementID,
                    playerID,
                    Character.SOCKET_NAME.Head,
                    Character.SOCKET_MODE.KeepWorld
                )
            elseif elementType == "RedTeam" then
                Framework.Tools.LightDMS.SetCustomProperty(
                    KeyMap.GameState.PlayerBindTeamTagID[1],
                    KeyMap.GameState.PlayerBindTeamTagID[2],
                    elementID,
                    playerID
                )
                Element:BindingToCharacterOrNPC(
                    elementID,
                    playerID,
                    Character.SOCKET_NAME.Head,
                    Character.SOCKET_MODE.KeepWorld
                )
            end
        end
    end

    local Rot, Scale = Engine.Rotator(0, 0, 0), Config.Engine.GameInstance.Scale.Icon_Dsp_PlayerHP_Bar
    local ScaleTeamIcon = Config.Engine.GameInstance.Scale.Icon_Dsp_Team
    local Replicate = true
    local playerPos = Character:GetPosition(playerID)
    local offsetPos_HPBar = Config.Engine.GameInstance.Offset.Icon_Dsp_PlayerHP_Bar
    local offsetPos_Team = Config.Engine.GameInstance.Offset.Icon_Dsp_Team
    local offsetPos_playerHP = UMath:GetPosOffset(playerPos, offsetPos_HPBar.X, offsetPos_HPBar.Y, offsetPos_HPBar.Z)
    local offsetPos_TeamIcon = UMath:GetPosOffset(playerPos, offsetPos_Team.X, offsetPos_Team.Y, offsetPos_Team.Z)
    local playerHPTagID = Framework.Tools.LightDMS.GetCustomProperty(
        KeyMap.GameState.PlayerBindHPBarID[1],
        KeyMap.GameState.PlayerBindHPBarID[2],
        false,
        playerID
    )
    local playerTeamTagID = Framework.Tools.LightDMS.GetCustomProperty(
        KeyMap.GameState.PlayerBindTeamTagID[1],
        KeyMap.GameState.PlayerBindTeamTagID[2],
        false,
        playerID
    )

    if type(playerHPTagID) ~= "number" then
        Element:SpawnElement(
            Element.SPAWN_SOURCE.Scene, Config.Engine.GameInstance.Item.Icon_Dsp_PlayerHP_Bar,
            createCallBack("PlayerHP_Bar"),
            offsetPos_playerHP, Rot, Scale, Replicate
        )
    end
    if type(playerTeamTagID) ~= "number" then
        Element:SpawnElement(
            Element.SPAWN_SOURCE.Scene, Config.Engine.GameInstance.Item.Icon_Dsp_RedTeam, createCallBack("RedTeam"),
            offsetPos_TeamIcon, Rot, ScaleTeamIcon, Replicate
        )
    end
    local timerID
    timerID = TimerManager:AddLoopTimer(0.5, function()
        local isExist = playerBindDisplayUpdate(playerID)
        if not isExist then
            TimerManager:RemoveTimer(timerID)
        end
    end)
end

---| 🎮 - 玩家武器分配
---<br>
---| `范围`：`服务端`
---@param playerID number 玩家ID
function Utils.PlayerWeaponAllocate(playerID)
    local playerTeam = Team:GetTeamById(playerID)
    if TeamIDMap.Red == playerTeam then
        Inventory:AddCustomItem(playerID, Config.Engine.GameInstance.Item.Item_Weapon_Hammer, 1)
        Inventory:AddCustomItem(playerID, Config.Engine.GameInstance.Item.Item_Weapon_Gun, 1)
    end
end

return Utils
