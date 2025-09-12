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
name = "Diana X"
version = "1.0.0"
version.env = "Dev"
version.ui = "2.0"
version.sdk = "0.0.2"
version.build = "Git #8eb60c (main)"

]]

-- 这次按照Toml规范来写了喵 =^•ω•^=
Toml.I18N = [[
[i18n]
default = "zh-CN"

[i18n.en-US]
language = "English"
key.account_info = { info1 = "LV.%s", info2 = "Coin %s" }
key.message = { help = "View the rules or wiki.roidmc.com", wip = "Developing", reset_setting = "Reset Setting" }
key.toggle = { on = "ON", off = "OFF", global = "All", team = "Team"}
key.team = { red = "Red", blue = "Blue" }
key.teamdesc = { red= "Red Team Description", blue = "Blue Team Description" }
key.status = { dead = "Dead", alive = "Alive", escape = "Escape", win = "Win", exit = "Exit", neterror = "NetError", missing = "Missing", uninit = "Uninit" }
key.uid = "UID %s"
key.copyright = { framework = "Powered By UniX SDK | UI | Framework" }
key.tasksys = { title = "Task System", unassigned = "No Task, Please Wait for System to Assign", taskprogress = "Destroy Progress: %s / %s"}
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
key.message = { help = "查看玩法说明或wiki.roidmc.com", wip = "开发中", reset_setting = "重置设置" }
key.toggle = { on = "开启", off = "关闭", global = "全体", team = "队伍"}
key.team = { red = "红队", blue = "蓝队" }
key.teamdesc = { red= "红队描述文本", blue = "蓝队描述文本" }
key.status = { dead = "死亡", alive = "存活", escape = "逃跑", win = "胜利", exit = "退出", neterror = "网络错误", missing = "缺失", uninit = "未初始化" }
key.uid = "UID %s"
key.copyright = { framework = "基于UniX SDK | UI | Framework强力驱动" }
key.tasksys = { title = "任务系统", unassigned = "无任务，请等待系统分配", taskprogress = "破坏进度：%s / %s"}
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
基于UniX SDK | UI
UniX框架强力驱动
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
