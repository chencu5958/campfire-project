-- ==================================================
-- * Campfire Project | Framework/Client/Extent/MainMenuUI.lua
-- *
-- * Info:
-- * Campfire Project Framework Client UI - MainMenuUI
-- * Managed by AnivaxUI Manager
-- * !! This file does not expose external interfaces !!
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local MainMenuUI = {}
local UIConf, EngineConf = require("Public.Config.UI"), require("Public.Config.Engine")
local CoreUI, KeyMap = UIConf.Core, EngineConf.Property.KeyMap

-- 获取服务器玩家用户数据
local function getServerPlayerProfileData()
    local serverData = UDK.Property.GetProperty(
        UDK.Player.GetLocalPlayerID(),
        KeyMap.UserData.AccountProfile[1],
        KeyMap.UserData.AccountProfile[2]
    )
    local fallback = {
        Player = {
            ID = "NaN",
            TeamID = Team:GetTeamById(UDK.Player.GetLocalPlayerID())
        },
        GameData = {
            Level = 0,
            Exp = 0,
            ReqExp = 0,
            Currency = {
                Coin = 0,
                StarCoin = 0,
                SliverCoin = 0
            }
        },
        CloudData = {
            Match = {
                Win = 0,
                Lose = 0,
                Draw = 0,
                Escape = 0,
                TotalRound = 0,
            },
        }
    }

    return serverData or fallback
end

-- 用于脏检查的变量
local lastRankDataSerialized = ""

-- 获取服务器排行榜数据
local function getServerRankListData()
    local serverData = UDK.Property.GetProperty(
        KeyMap.ServerState.NameSpace,
        KeyMap.ServerState.RankList[1],
        KeyMap.ServerState.RankList[2]
    )
    local fallback = {
        [1] = { PlayerID = 0, Score = 1, Status = "NetError", TeamID = 0 },
        [2] = { PlayerID = 1, Score = 0, Status = "NetError", TeamID = 0 },
        [3] = { PlayerID = 2, Score = "NaN", Status = "NetError", TeamID = 1 },
        [4] = { PlayerID = 3, Score = "NaN", Status = "NetError", TeamID = 1 },
        [5] = { PlayerID = 4, Score = "NaN", Status = "NetError", TeamID = 1 },
        [6] = { PlayerID = 5, Score = "NaN", Status = "NetError", TeamID = 1 },
        [7] = { PlayerID = 6, Score = "NaN", Status = "NetError", TeamID = 1 },
        [8] = { PlayerID = 7, Score = "NaN", Status = "NetError", TeamID = 1 }
    }

    return serverData or fallback
end

-- 序列化表为字符串用于比较
local function serializeTable(tbl)
    if type(tbl) ~= "table" then
        return tostring(tbl)
    end

    local result = {}
    for k, v in pairs(tbl) do
        local keyStr = type(k) == "string" and '"' .. k .. '"' or tostring(k)
        local valStr = type(v) == "table" and serializeTable(v) or
            type(v) == "string" and '"' .. v .. '"' or tostring(v)
        table.insert(result, "[" .. keyStr .. "]=" .. valStr)
    end
    return "{" .. table.concat(result, ",") .. "}"
end

-- 对排行榜数据按TeamID进行排序
local function sortRankListData(rankData)
    local sortedData = {
        redTeam = {},
        blueTeam = {}
    }

    -- 按队伍分类数据
    for _, playerData in pairs(rankData) do
        if playerData.TeamID == 0 then
            table.insert(sortedData.redTeam, playerData)
        elseif playerData.TeamID == 1 then
            table.insert(sortedData.blueTeam, playerData)
        end
    end

    -- 对红队按分数排序
    table.sort(sortedData.redTeam, function(a, b)
        local scoreA = tonumber(a.Score) or 0
        local scoreB = tonumber(b.Score) or 0
        return scoreA > scoreB
    end)

    -- 对蓝队按分数排序
    table.sort(sortedData.blueTeam, function(a, b)
        local scoreA = tonumber(a.Score) or 0
        local scoreB = tonumber(b.Score) or 0
        return scoreA > scoreB
    end)

    return sortedData
end

-- 根据状态码获取状态文本
local function getStatusKeyByCode(code)
    if type(code) ~= "string" then
        Log:PrintError("[Framework:Client] [MainMenuUI.GetStatusKeyByCode] 无效的状态码，请检查状态码是否为字符串")
        return "InvalidCode"
    end
    local queryCode = string.lower(code) or "missing"
    local queryParam = string.format("%s.%s", "key.status", queryCode)
    return Framework.Tools.Utils.GetI18NKey(queryParam)
end

-- 获取开关文本的I18NKey
local function getToggleKeyByBool(boolean)
    if type(boolean) ~= "boolean" then
        Log:PrintError("[Framework:Client] [MainMenuUI.GetToggleKeyByBool] 无效的开关，请检查开关是否为布尔值")
        return "InvalidBool"
    end
    local returnCode
    if boolean then
        returnCode = Framework.Tools.Utils.GetI18NKey("key.toggle.on")
    else
        returnCode = Framework.Tools.Utils.GetI18NKey("key.toggle.off")
    end
    return returnCode
end

-- 获取IM频道聊天范围的I18NKey
local function getIMChannelAreaKeyByBool(boolean)
    if type(boolean) ~= "boolean" then
        Log:PrintError("[Framework:Client] [MainMenuUI.GetIMChannelToggleKeyByBool] 无效的IM频道开关，请检查开关是否为布尔值")
        return "InvalidBool"
    end
    local returnCode
    if boolean then
        returnCode = Framework.Tools.Utils.GetI18NKey("key.toggle.team")
    else
        returnCode = Framework.Tools.Utils.GetI18NKey("key.toggle.global")
    end
    return returnCode
end

---| 🔩 - 客户端UI更新（MainMenu）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新基础UI`
---<br>
---| `更新范围`：`MainMenu.Tmp_UIBase` - `UI Base`
---<br>
---| `是否从服务器获取数据`：`false`
function MainMenuUI.BaseUI()
    local appInfo_Name = Framework.Tools.Utils.GetAppInfoKey("name")
    local appInfo_Build = Framework.Tools.Utils.GetAppInfoKey("version.build")
    local fmt_appInfo = string.format("%s | %s", appInfo_Name, appInfo_Build)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UIBase.T_AppInfo, fmt_appInfo)
    local UID = UDK.Math.EncodeToUID(UDK.Player.GetLocalPlayerID())
    local UID_I18NKey = Framework.Tools.Utils.GetI18NKey("key.uid")
    local fmt_UID_I18NKey = string.format(UID_I18NKey, UID)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UIBase.T_UID, fmt_UID_I18NKey)
end

---| 🔩 - 客户端UI更新（MainMenu）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新账户信息UI`
---<br>
---| `更新范围`：`MainMenu.Tmp_UserAccount` - `User Account`
---<br>
---| `是否从服务器获取数据`：`true`
function MainMenuUI.UserAccountPanelUI()
    local serverData = getServerPlayerProfileData()
    local playerID = UDK.Player.GetLocalPlayerID()
    local playerName = UDK.Player.GetPlayerNickName(playerID)
    local accInfo1_I18NKey = Framework.Tools.Utils.GetI18NKey("key.account_info.info1")
    local accInfo2_I18NKey = Framework.Tools.Utils.GetI18NKey("key.account_info.info2")
    local fmt_accInfo1_I18NKey = string.format(accInfo1_I18NKey, serverData.GameData.Level)
    local fmt_accInfo2_I18NKey = string.format(accInfo2_I18NKey, serverData.GameData.Currency.Coin)
    UDK.UI.SetPlayerIconAndName(CoreUI.MainMenu.Tmp_UserAccount.Tmp_UserInfo.Fc_Avatar, playerID, "Icon")
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_UserInfo.T_UserName, playerName)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_UserInfo.T_ExtInfo, tostring(serverData.Player.TeamID))
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_AccountInfo.T_AccInfo1, fmt_accInfo1_I18NKey)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_UserAccount.Tmp_AccountInfo.T_AccInfo2, fmt_accInfo2_I18NKey)
end

---| 🔩 - 客户端UI更新（MainMenu）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新生涯数据UI`
---<br>
---| `更新范围`：`MainMenu.Tmp_MyProfile` - `My Profile`
---<br>
---| `是否从服务器获取数据`：`true`
function MainMenuUI.UserProfileUI()
    local serverData = getServerPlayerProfileData()
    local historyData_I18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.history_data")
    local personal_I18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.personal_data")
    local fmt_personal_I18NKey = string.format(
        personal_I18NKey,
        serverData.GameData.Level,
        serverData.GameData.Currency.Coin,
        serverData.GameData.Exp,
        serverData.GameData.ReqExp
    )
    local winRate = UDK.Math.CalcPercentage(serverData.CloudData.Match.TotalRound, serverData.CloudData.Match.Win)
    local fmt_historyData_I18NKey = string.format(
        historyData_I18NKey,
        serverData.CloudData.Match.TotalRound,
        math.ceil(winRate) .. "%",
        serverData.CloudData.Match.Win,
        serverData.CloudData.Match.Lose,
        serverData.CloudData.Match.Draw,
        serverData.CloudData.Match.Escape
    )
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_MyProfile.T_PersonalData, fmt_personal_I18NKey)
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_MyProfile.T_HistoryData, fmt_historyData_I18NKey)
end

---| 🔩 - 客户端UI更新（MainMenu）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新设置UI`
---<br>
---| `更新范围`：`MainMenu.Tmp_Settings` - `Settings`
---<br>
---| `是否从服务器获取数据`：`false`
function MainMenuUI.UserSettingsUI()
    local playerID            = UDK.Player.GetLocalPlayerID()
    local currentLang         = Framework.Tools.Utils.GetI18NKey("language")
    local setting_I18NKey     = Framework.Tools.Utils.GetI18NKey("ptemplate.setting")
    local i18NKey, fmt_I18NKey
    local fmt_setting_I18NKey = string.format(
        setting_I18NKey,
        getToggleKeyByBool(Framework.Tools.Sound.GetSoundEnableStatus(playerID)),
        getIMChannelAreaKeyByBool(Framework.Tools.Utils.GetIMVoiceIsTeamChannel(playerID)),
        getIMChannelAreaKeyByBool(Framework.Tools.Utils.GetIMChatIsTeamChannel(playerID)),
        currentLang
    )
    UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_Settings.Tmp_GeneralPage.T_Content, fmt_setting_I18NKey)
    local layoutProp = Config.Engine.Property.KeyMap.UIState.LayoutSettingMiscPID
    local layoutID   = Config.Engine.GameUI.UI.Layout_SettingMisc
    local openPID    = Framework.Tools.UI.GetLayoutUIOpenPID(layoutProp)
    if openPID == layoutID.Version then
        i18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.version")
        fmt_I18NKey = string.format(
            i18NKey,
            Framework.Tools.Utils.GetAppInfoKey("version"),
            Framework.Tools.Utils.GetAppInfoKey("version.env"),
            Framework.Tools.Utils.GetAppInfoKey("version.ui"),
            Framework.Tools.Utils.GetAppInfoKey("version.sdk")
        )
        UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.T_Content, fmt_I18NKey)
    elseif openPID == layoutID.Credits then
        i18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.credits")
        UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.T_Content, i18NKey)
    elseif openPID == layoutID.Feedback then
        i18NKey = Framework.Tools.Utils.GetI18NKey("ptemplate.feedback")
        UDK.UI.SetUIText(CoreUI.MainMenu.Tmp_Settings.Tmp_MiscPage.T_Content, i18NKey)
    end
end

---| 🔩 - 客户端UI更新（MainMenu）
---<br>
---| `范围`：`客户端`
---<br>
---| `功能`：`更新排行榜UI`
---<br>
---| `更新范围`：`MainMenu.Tmp_Rank` - `Rank List`
---<br>
---| `是否从服务器获取数据`：`true`
function MainMenuUI.RankListUI()
    local serverRankData = getServerRankListData()

    -- 脏检查：只有当数据发生变化时才更新UI
    local currentDataSerialized = serializeTable(serverRankData)
    if lastRankDataSerialized == currentDataSerialized then
        -- 即使数据未变化，也要更新状态文本（因为可能语言已切换）
        local sortedData = sortRankListData(serverRankData)

        -- 更新红队排行榜状态文本
        local redTeamUI = CoreUI.MainMenu.Tmp_Rank.Tmp_RedTeam
        for i = 1, #sortedData.redTeam do
            local item = redTeamUI["RankList" .. i]
            if item then
                local playerData = sortedData.redTeam[i]
                UDK.UI.SetUIText(item.T_Status, getStatusKeyByCode(playerData.Status))
            end
        end

        -- 更新蓝队排行榜状态文本
        local blueTeamUI = CoreUI.MainMenu.Tmp_Rank.Tmp_BlueTeam
        for i = 1, #sortedData.blueTeam do
            local item = blueTeamUI["RankList" .. i]
            if item then
                local playerData = sortedData.blueTeam[i]
                UDK.UI.SetUIText(item.T_Status, getStatusKeyByCode(playerData.Status))
            end
        end

        return -- 数据未变化，直接返回
    end

    -- 更新上次数据记录
    lastRankDataSerialized = currentDataSerialized

    local sortedData = sortRankListData(serverRankData)

    -- 更新红队排行榜
    local redTeamUI = CoreUI.MainMenu.Tmp_Rank.Tmp_RedTeam
    local redTeamCount = #sortedData.redTeam
    local redTeamTotalSlots = UDK.Array.GetLength(redTeamUI)

    for i = 1, redTeamTotalSlots do
        local item = redTeamUI["RankList" .. i]
        if item then
            -- 如果有数据则显示，否则隐藏
            if i <= redTeamCount then
                local playerData = sortedData.redTeam[i]
                UDK.UI.SetPlayerIconAndName(item.Fc_Avatar, playerData.PlayerID, "Icon")
                UDK.UI.SetUIText(item.T_Number, "#" .. i)
                UDK.UI.SetUIText(item.T_UserName, UDK.Player.GetPlayerNickName(playerData.PlayerID))
                UDK.UI.SetUIText(item.T_Score, tostring(playerData.Score))
                UDK.UI.SetUIText(item.T_Status, getStatusKeyByCode(playerData.Status))
                UDK.UI.SetUIVisibility(item.Grp_Root, true) -- 显示该项

                -- 根据状态显示图标
                if playerData.Status == "Dead" then
                    UDK.UI.SetUIVisibility(item.Img_IconDead, true)
                    UDK.UI.SetUIVisibility(item.Img_IconExit, false)
                elseif playerData.Status == "Exit" then
                    UDK.UI.SetUIVisibility(item.Img_IconDead, false)
                    UDK.UI.SetUIVisibility(item.Img_IconExit, true)
                else
                    UDK.UI.SetUIVisibility(item.Img_IconDead, false)
                    UDK.UI.SetUIVisibility(item.Img_IconExit, false)
                end
            else
                -- 没有数据的项隐藏
                UDK.UI.SetUIVisibility(item.Grp_Root, false)
            end
        end
    end

    -- 更新蓝队排行榜
    local blueTeamUI = CoreUI.MainMenu.Tmp_Rank.Tmp_BlueTeam
    local blueTeamCount = #sortedData.blueTeam
    local blueTeamTotalSlots = UDK.Array.GetLength(blueTeamUI)

    for i = 1, blueTeamTotalSlots do
        local item = blueTeamUI["RankList" .. i]
        if item then
            -- 如果有数据则显示，否则隐藏
            if i <= blueTeamCount then
                local playerData = sortedData.blueTeam[i]
                UDK.UI.SetPlayerIconAndName(item.Fc_Avatar, playerData.PlayerID, "Icon")
                UDK.UI.SetUIText(item.T_Number, "#" .. i)
                UDK.UI.SetUIText(item.T_UserName, UDK.Player.GetPlayerNickName(playerData.PlayerID))
                UDK.UI.SetUIText(item.T_Score, tostring(playerData.Score))
                UDK.UI.SetUIText(item.T_Status, getStatusKeyByCode(playerData.Status))
                UDK.UI.SetUIVisibility(item.Grp_Root, true) -- 显示该项

                -- 根据状态显示图标
                if playerData.Status == "Dead" then
                    UDK.UI.SetUIVisibility(item.Img_IconDead, true)
                    UDK.UI.SetUIVisibility(item.Img_IconExit, false)
                elseif playerData.Status == "Exit" then
                    UDK.UI.SetUIVisibility(item.Img_IconDead, false)
                    UDK.UI.SetUIVisibility(item.Img_IconExit, true)
                else
                    UDK.UI.SetUIVisibility(item.Img_IconDead, false)
                    UDK.UI.SetUIVisibility(item.Img_IconExit, false)
                end
            else
                -- 没有数据的项隐藏
                UDK.UI.SetUIVisibility(item.Grp_Root, false)
            end
        end
    end
end

return MainMenuUI
