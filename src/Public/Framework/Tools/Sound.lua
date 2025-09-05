-- ==================================================
-- * Campfire Project | Framework/Tools/Sound.lua
-- *
-- * Info:
-- * Campfire Project Framework Sound Tools
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local SoundTools = {}
local KeyMap = Config.Engine.Property.KeyMap

local function getSoundEnableStatus()
    local playerID = UDK.Player.GetLocalPlayerID()
    local value = UDK.Property.GetProperty(playerID, KeyMap.PSetting.SFXSound[1], KeyMap.PSetting.SFXSound[2])
    return value or true
end

---| 🎵 - 播放2D音效
---<br>
---| `范围`：`客户端`
---| `功能`：`播放2D音效`
---@param soundID number 音效ID
---@param volume number? 音量
---@param duration number? 持续时间
---@param tune number? 调音
---@return boolean isPlayed 是否成功播放
function SoundTools.Play2DSound(soundID, volume, duration, tune)
    local soundEnableStatus = getSoundEnableStatus()
    if soundEnableStatus then
        UDK.Sound.Play2DAudio(soundID, volume or 50, duration or 0, tune or 0)
    end
    return soundEnableStatus
end

function SoundTools.SoundToggle()
    local soundEnableStatus = getSoundEnableStatus()
    if soundEnableStatus then
        UDK.Property.SetProperty(
            UDK.Player.GetLocalPlayerID(),
            KeyMap.PSetting.SFXSound[1],
            KeyMap.PSetting.SFXSound[2],
            false
        )
    else
        UDK.Property.SetProperty(
            UDK.Player.GetLocalPlayerID(),
            KeyMap.PSetting.SFXSound[1],
            KeyMap.PSetting.SFXSound[2],
            true
        )
    end
end

function SoundTools.GetSoundEnableStatus()
    return getSoundEnableStatus()
end

return SoundTools
