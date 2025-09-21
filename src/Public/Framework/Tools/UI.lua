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
---<br>
---| `范围`： `客户端`
---@return boolean isOpen 主菜单UI打开状态
function UI.GetMainMenuUIOpenState()
    return Framework.Tools.LightDMS.GetCustomProperty(KeyMap.UIState.MainMenuIsOpen[1], KeyMap.UIState.MainMenuIsOpen[2])
end

---| 🧰 - 获取主菜单UI打开的子页面ID
---<br>
---| `范围`： `客户端`
---@return number pid 子页面ID
function UI.GetMainMenuUIOpenPID()
    return Framework.Tools.LightDMS.GetCustomProperty(
        KeyMap.UIState.MainMenuOpenPID[1],
        KeyMap.UIState.MainMenuOpenPID[2]
    )
end

---| 🧰 - 获取通用页面UI打开的页面ID
---<br>
---| `说明`： `该函数实现基于LightDMS，遵从EnginePropertyKeyMap规则`
---<br>
---| `范围`： `客户端`
---@param layoutName table 页面数据 { "Type类型", "LayoutName名称" }
---@return number pid 页面ID
function UI.GetLayoutUIOpenPID(layoutName)
    return Framework.Tools.LightDMS.GetCustomProperty(layoutName[1], layoutName[2])
end

---| 🧰 - 获取任务栏UI打开状态
---<br>
---| `范围`： `客户端`
---@return boolean isOpen 任务栏UI打开状态
function UI.GetTaskbarUIOpenState()
    return Framework.Tools.LightDMS.GetCustomProperty(KeyMap.UIState.TaskbarIsOpen[1], KeyMap.UIState.TaskbarIsOpen[2])
end

---| 🧰 - 获取IMUtilsUI打开状态
---<br>
---| `范围`： `客户端`
---@return boolean isOpen IMUtilsUI打开状态
function UI.GetIMUtilsUIOpenState()
    return Framework.Tools.LightDMS.GetCustomProperty(KeyMap.UIState.IMUtilsIsOpen[1], KeyMap.UIState.IMUtilsIsOpen[2])
end

---| 🧰 - 获取IMUtilsUI打开的页面ID
---<br>
---| `范围`： `客户端`
---@return number pid 聊天工具UI打开的页面ID
function UI.GetIMUtilsOpenPID()
    return Framework.Tools.LightDMS.GetCustomProperty(KeyMap.UIState.IMUtilsOpenPID[1], KeyMap.UIState.IMUtilsOpenPID[2])
end

---| 🧰 - 设置主菜单UI打开状态
---<br>
---| `范围`： `客户端`
---@param state boolean 主菜单UI打开状态
function UI.SetMainMenuUIOpenState(state)
    Framework.Tools.LightDMS.SetCustomProperty(KeyMap.UIState.MainMenuIsOpen[1], KeyMap.UIState.MainMenuIsOpen[2], state)
end

---| 🧰 - 设置主菜单UI打开的子页面ID
---<br>
---| `范围`： `客户端`
---@param pid number 子页面ID
function UI.SetMainMenuUIOpenPID(pid)
    Framework.Tools.LightDMS.SetCustomProperty(KeyMap.UIState.MainMenuOpenPID[1], KeyMap.UIState.MainMenuOpenPID[2], pid)
end

---| 🧰 - 设置任务栏UI打开状态
---<br>
---| `范围`： `客户端`
---@param state boolean 任务栏UI打开状态
function UI.SetTaskbarUIOpenState(state)
    Framework.Tools.LightDMS.SetCustomProperty(KeyMap.UIState.TaskbarIsOpen[1], KeyMap.UIState.TaskbarIsOpen[2], state)
end

---| 🧰 - 设置通用页面UI打开的页面ID
---<br>
---| `说明`： `该函数实现基于LightDMS，遵从EnginePropertyKeyMap规则`
---<br>
---| `范围`： `客户端`
---@param layoutName table 页面数据 { "Type类型", "LayoutName名称" }
---@param pid number 页面ID
function UI.SetLayoutUIOpenPID(layoutName, pid)
    Framework.Tools.LightDMS.SetCustomProperty(layoutName[1], layoutName[2], pid)
end

---| 🧰 - 设置IMUtilsUI打开状态
---<br>
---| `范围`： `客户端`
---@param state boolean IMUtilsUI打开状态
function UI.SetIMUtilsUIOpenState(state)
    Framework.Tools.LightDMS.SetCustomProperty(KeyMap.UIState.IMUtilsIsOpen[1], KeyMap.UIState.IMUtilsIsOpen[2], state)
end

---| 🧰 - 设置IMUtilsUI打开的页面ID
---<br>
---| `范围`： `客户端`
---@param pid number 页面ID
function UI.SetIMUtilsOpenPID(pid)
    Framework.Tools.LightDMS.SetCustomProperty(KeyMap.UIState.IMUtilsOpenPID[1], KeyMap.UIState.IMUtilsOpenPID[2], pid)
end

return UI
