-- ==================================================
-- * Campfire Project | Framework/Tools/UI.lua
-- *
-- * Info:
-- * Campfire Project Framework UI Tools
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local UI = {}
local KeyMap = Config.Engine.Property.KeyMap

---| 🧰 - 获取主菜单UI打开状态
---
---| `范围`： `客户端`
---@return boolean isOpen 主菜单UI打开状态
function UI.GetMainMenuUIOpenState()
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.MainMenuIsOpen
    local data = UDK.Property.GetProperty(playerID, queryKey[1], queryKey[2], queryKey[4])
    return data
end

---| 🧰 - 获取主菜单UI打开的子页面ID
---
---| `范围`： `客户端`
---@return number pid 子页面ID
function UI.GetMainMenuUIOpenPID()
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.MainMenuOpenPID
    local data = UDK.Property.GetProperty(playerID, queryKey[1], queryKey[2], queryKey[4])
    return data
end

---| 🧰 - 获取通用页面UI打开的页面ID
---
---| `范围`： `客户端`
---@param layoutName table 页面数据 { "Type类型", "LayoutName名称" }
---@return number pid 页面ID
function UI.GetLayoutUIOpenPID(layoutName)
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = layoutName
    local data = UDK.Property.GetProperty(playerID, queryKey[1], queryKey[2], queryKey[4])
    return data
end

---| 🧰 - 获取任务栏UI打开状态
---
---| `范围`： `客户端`
---@return boolean isOpen 任务栏UI打开状态
function UI.GetTaskbarUIOpenState()
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.TaskbarIsOpen
    local data = UDK.Property.GetProperty(playerID, queryKey[1], queryKey[2], queryKey[4])
    return data
end

---| 🧰 - 获取IMUtilsUI打开状态
---
---| `范围`： `客户端`
---@return boolean isOpen IMUtilsUI打开状态
function UI.GetIMUtilsUIOpenState()
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.IMUtilsIsOpen
    local data = UDK.Property.GetProperty(playerID, queryKey[1], queryKey[2], queryKey[4])
    return data
end

---| 🧰 - 获取IMUtilsUI打开的页面ID
---
---| `范围`： `客户端`
---@return number pid 聊天工具UI打开的页面ID
function UI.GetIMUtilsOpenPID()
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.IMUtilsOpenPID
    local data = UDK.Property.GetProperty(playerID, queryKey[1], queryKey[2], queryKey[4])
    return data
end

---| 🧰 - 获取队伍信息弹出框打开状态
---
---| `范围`： `客户端`
---@return boolean isOpen 队伍信息弹出框打开状态
function UI.GetTeamPopOpenState()
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.TeamPopIsOpen
    local data = UDK.Property.GetProperty(playerID, queryKey[1], queryKey[2], queryKey[4])
    return data
end

---| 🧰 - 设置主菜单UI打开状态
---
---| `范围`： `客户端`
---@param state boolean 主菜单UI打开状态
function UI.SetMainMenuUIOpenState(state)
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.MainMenuIsOpen
    UDK.Property.SetProperty(playerID, queryKey[1], queryKey[2], state, queryKey[4])
end

---| 🧰 - 设置主菜单UI打开的子页面ID
---
---| `范围`： `客户端`
---@param pid number 子页面ID
function UI.SetMainMenuUIOpenPID(pid)
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.MainMenuOpenPID
    UDK.Property.SetProperty(playerID, queryKey[1], queryKey[2], pid, queryKey[4])
end

---| 🧰 - 设置任务栏UI打开状态
---
---| `范围`： `客户端`
---@param state boolean 任务栏UI打开状态
function UI.SetTaskbarUIOpenState(state)
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.TaskbarIsOpen
    UDK.Property.SetProperty(playerID, queryKey[1], queryKey[2], state, queryKey[4])
end

---| 🧰 - 设置通用页面UI打开的页面ID
---
---| `范围`： `客户端`
---@param layoutName table 页面数据 { "Type类型", "LayoutName名称" }
---@param pid number 页面ID
function UI.SetLayoutUIOpenPID(layoutName, pid)
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = layoutName
    UDK.Property.SetProperty(playerID, queryKey[1], queryKey[2], pid, queryKey[4])
end

---| 🧰 - 设置IMUtilsUI打开状态
---
---| `范围`： `客户端`
---@param state boolean IMUtilsUI打开状态
function UI.SetIMUtilsUIOpenState(state)
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.IMUtilsIsOpen
    UDK.Property.SetProperty(playerID, queryKey[1], queryKey[2], state, queryKey[4])
end

---| 🧰 - 设置IMUtilsUI打开的页面ID
---
---| `范围`： `客户端`
---@param pid number 页面ID
function UI.SetIMUtilsOpenPID(pid)
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.IMUtilsOpenPID
    UDK.Property.SetProperty(playerID, queryKey[1], queryKey[2], pid, queryKey[4])
end

---| 🧰 - 设置队伍信息弹出框打开状态
---
---| `范围`： `客户端`
---@param state boolean 队伍信息弹出框打开状态
function UI.SetTeamPopOpenState(state)
    local playerID = UDK.Player.GetLocalPlayerID()
    local queryKey = KeyMap.UIState.TeamPopIsOpen
    UDK.Property.SetProperty(playerID, queryKey[1], queryKey[2], state, queryKey[4])
end

return UI
