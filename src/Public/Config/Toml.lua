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

[i18n.zh-CN]
language = "简体中文"
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
]]

return Toml
