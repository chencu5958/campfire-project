-- ==================================================
-- * Campfire Project | Config/Toml.lua
-- *
-- * Info:
-- * Campfire Project Toml Config
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local Toml = {}

Toml.App = [[
[app]
name = "Campfire Project"
]]

Toml.I18N = [[
[i18n]
default = "zh-CN"

[i18n.en-US]
language = "English"
key.account_info = { info1 = "LV.%s", info2 = "Coin %s" }
ptemplate.personal_data = """
Personal Data
==================
LV.%s
Coin %s
Exp %s / %s
==================
"""
ptemplate.history_data = """
History Data
==================
Matchs：%s
WinRate：%s
Win/Lose：%s / %s
Draw：%s
Escape：%s
==================
"""
ptemplate.setting = """
Setting
==================
GameSFX：%s
MicMode：%s
ChatMode：%s
==================
Language：%s
"""
ptemplate.version = """
Version
==================
Map：%s | %s
UI：%s
SDK：%s
==================
© RoidMC Studios
"""
ptemplate.credits = """
Credits
==================
UniX SDK | UI
UniX Framework
Developing with Lua
==================
© RoidMC Studios
"""
ptemplate.feedback = """
FeedBack
==================
如果您有好的修改意见
或是发现了bug等，请
在星世界种草反馈
==================
© RoidMC Studios
"""

[i18n.zh-CN]
language = "简体中文"
key.account_info = { info1 = "等级LV.%s", info2 = "金币%s" }
ptemplate.personal_data = """
个人数据
==================
等级：%s
金币：%s
经验：%s / %s
==================
"""
ptemplate.history_data = """
历史数据
==================
场次：%s
胜率：%s
胜负：%s / %s
平局：%s
逃跑：%s
==================
"""
ptemplate.setting = """
游戏设置
==================
游戏音效：%s
语音模式：%s
聊天模式：%s
==================
游戏语言：%s
"""
ptemplate.version = """
地图版本
==================
地图版本：%s | %s
UI版本：%s
SDK版本：%s
==================
© RoidMC Studios
"""
ptemplate.credits = """
致谢声明
==================
基于UniX SDK
使用UniX UI
使用Lua开发
==================
© RoidMC Studios
"""
ptemplate.feedback = """
意见反馈
==================
如果您有好的修改意见
或是发现了bug等，请
在星世界种草反馈
==================
© RoidMC Studios
"""
]]

return Toml
