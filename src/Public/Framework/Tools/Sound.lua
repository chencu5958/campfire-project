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

-- 获取音效启用状态
local function getSoundEnableStatus(playerID)
    local value = UDK.Property.GetProperty(playerID, KeyMap.PSetting.SFXSound[1], KeyMap.PSetting.SFXSound[2])
    if value == nil then
        value = true
    end
    return value
end

---| 🧰 - 播放2D音效
---<br>
---| `范围`：`客户端`
---| `功能`：`播放2D音效`
---@param soundID number 音效ID
---@param volume number? 音量
---@param duration number? 持续时间
---@param tune number? 调音
---@return boolean isPlayed 是否成功播放
function SoundTools.Play2DSound(soundID, volume, duration, tune)
    local soundEnableStatus = getSoundEnableStatus(UDK.Player.GetLocalPlayerID())
    if soundEnableStatus then
        UDK.Sound.Play2DAudio(soundID, volume or 50, duration or 0, tune or 0)
    end
    return soundEnableStatus
end

---| 🧰 - 切换音效启用状态
---<br>
---| `范围`：`服务端` | `客户端`
---@param playerID number 玩家ID
function SoundTools.SoundToggle(playerID)
    local soundEnableStatus = getSoundEnableStatus(playerID)
    if soundEnableStatus then
        UDK.Property.SetProperty(playerID, KeyMap.PSetting.SFXSound[1], KeyMap.PSetting.SFXSound[2], false)
        UDK.Storage.ArchiveUpload(playerID, KeyMap.PSetting.SFXSound[1], KeyMap.PSetting.SFXSound[2], false)
    else
        UDK.Property.SetProperty(playerID, KeyMap.PSetting.SFXSound[1], KeyMap.PSetting.SFXSound[2], true)
        UDK.Storage.ArchiveUpload(playerID, KeyMap.PSetting.SFXSound[1], KeyMap.PSetting.SFXSound[2], true)
    end
end

---| 🧰 - 获取音效启用状态
---<br>
---| `范围`：`服务端` | `客户端`
---@param playerID number 玩家ID\
---@return boolean isEnable 启用状态
function SoundTools.GetSoundEnableStatus(playerID)
    return getSoundEnableStatus(playerID)
end

return SoundTools
