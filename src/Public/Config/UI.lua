-- ==================================================
-- * Campfire Project | Config/UI.lua
-- *
-- * Info:
-- * Campfire Project UI Config
-- *
-- * Description:
-- * T : Text文本
-- * Grp : Group编组
-- * Btn : Button按钮
-- * Img : Image图片
-- * Tmp : Template模板
-- * Tgl : Toggle开关
-- * Lbl : Label标签
-- * Clr : Color颜色
-- * Fc: Function功能控件
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local UIConf = {}

UIConf.Core = {
    MainMenu = {
        Grp_Root = 100047,
        Tmp_MenuItem = {
            Grp_Root = 100064,
            Btn_MyProfile = 100068,
            Btn_Settings = 100067,
            Btn_Rank = 100066,
            Btn_EShop = 100065
        },
        Tmp_UserAccount = {
            Grp_Root = 100055,
            Tmp_UserInfo = {
                Fc_Avatar = 100208,
                T_UserName = 100061,
                T_ExtInfo = 100060
            },
            Tmp_AccountInfo = {
                T_AccInfo1 = 100058,
                T_AccInfo2 = 100057
            }
        },
        Tmp_MyProfile = {
            Grp_Root = 100163,
            T_PersonalData = 100170,
            T_HistoryData = 100169,
            Btn_Help = 100168
        },
        Tmp_Settings = {
            Grp_Root = 100139,
            Tmp_BtnGroup = {
                Grp_Root = 100159,
                Btn_General = 100162,
                Btn_Misc = 100161,
                Btn_Language = 100160,
            },
            Tmp_GeneralPage = {
                Grp_Root = 100152,
                T_Content = 100154,
                Btn_SFXSound = 100158,
                Btn_MicMode = 100157,
                Btn_ChatMode = 100156
            },
            Tmp_MiscPage = {
                Grp_Root = 100145,
                T_Content = 100147,
                Btn_Version = 100151,
                Btn_Credits = 100150,
                Btn_Feedback = 100149
            },
            Btn_Reset = 100144,
        },
        Tmp_Rank = {
            Grp_Root = 100069,
            Tmp_RedTeam = {
                RankList1 = { Fc_Avatar = 100766, T_Number = 100138, T_UserName = 100134, T_Score = 100133, T_Status = 100132, Img_IconDead = 100136, Img_IconExit = 100137 },
                RankList2 = { Fc_Avatar = 100767, T_Number = 100130, T_UserName = 100126, T_Score = 100125, T_Status = 100124, Img_IconDead = 100128, Img_IconExit = 100129 },
            },
            Tmp_BlueTeam = {
                RankList1 = { Fc_Avatar = 100768, T_Number = 100122, T_UserName = 100118, T_Score = 100117, T_Status = 100116, Img_IconDead = 100120, Img_IconExit = 100121 },
                RankList2 = { Fc_Avatar = 100769, T_Number = 100114, T_UserName = 100110, T_Score = 100109, T_Status = 100108, Img_IconDead = 100112, Img_IconExit = 100113 },
                RankList3 = { Fc_Avatar = 100770, T_Number = 100105, T_UserName = 100101, T_Score = 100100, T_Status = 100099, Img_IconDead = 100103, Img_IconExit = 100104 },
                RankList4 = { Fc_Avatar = 100771, T_Number = 100097, T_UserName = 100093, T_Score = 100092, T_Status = 100091, Img_IconDead = 100095, Img_IconExit = 100096 },
                RankList5 = { Fc_Avatar = 100772, T_Number = 100089, T_UserName = 100085, T_Score = 100084, T_Status = 100083, Img_IconDead = 100087, Img_IconExit = 100088 },
                RankList6 = { Fc_Avatar = 100773, T_Number = 100081, T_UserName = 100077, T_Score = 100076, T_Status = 100075, Img_IconDead = 100079, Img_IconExit = 100080 },
            }
        },
        Tmp_UIBase = {
            T_Title = 100051,
            T_AppInfo = 100050,
            T_UID = 101550,
            Btn_GRank = 100054,
            Btn_Close = 100053,
        }
    },
    ScoreBar = {
        Grp_Root = 100173,
        Tmp_RedTeam = {
            Grp_Root = 100180,
            T_ScoreCount = 100182,
            Img_UniBG = 100181
        },
        Tmp_BlueTeam = {
            Grp_Root = 100183,
            T_ScoreCount = 100185,
            Img_UniBG = 100184
        },
        Tmp_ToolBar = {
            Grp_Root = 100175,
            T_TimeCount = 100179,
            Btn_MainMenu = 100178,
            Btn_Rank = 100177
        },
        Tmp_ContentBar = {
            Grp_Root = 101617,
            Fc_ProgressBar = 101285,
            Tmp_TeamBar = {
                Grp_Root = 101282,
                Img_RedTeam = 101284,
                Img_BlueTeam = 101283
            },
            Tmp_TipsBar = {
                Grp_Root = 101269,
                T_PlayerIDLeft = 101281,
                T_PlayerIDRight = 101280,
                T_Content = 101278,
                Img_BG = 101277
            }
        }
    },
    TaskBar = {
        Grp_Root = 101216,
        Tmp_Expand = {
            Grp_Root = 101218,
            T_Title = 101222,
            T_Content = 101221,
            T_Footer = 101220
        },
        Tmp_UIBase = {
            Btn_Expand = 101217,
            Btn_Collapse = 101223
        },
    }
}

UIConf.UIAnim = {
    -- 动画ID，
    MainMenu = {
        UIOpen = 1,
        UIClose = 2,
        Tmp_MyProfile = {
            MenuCardScale = 1
        },
        Tmp_Settings = {
            MenuCardScale  = 1,
            Tmp_BtnGroup   = {
                BtnPress = 1
            },
            Tmp_PageLayout = {
                MenuCardScale = 1,
                BtnPress = 1
            }
        },
        Tmp_RankList = {
            MenuCardScale = 1
        },
        Tmp_MenuItem = {
            BtnPress = 1
        },
        Tmp_UIBase = {
            BtnPress = 1
        }
    },
    TaskBar = {
        UIOpen = 1,
        UIClose = 2,
    }
}

UIConf.ImgID = {}

-- 内部的值是自动计算的，不要修改
UIConf.BtnUIDResult = {}

-- 递归遍历函数，提取所有Btn开头的ID值
local function extractBtnIds(sourceTable, resultTable)
    for key, value in pairs(sourceTable) do
        if type(key) == "string" and string.sub(key, 1, 3) == "Btn" then
            -- 如果键以"Btn"开头且值为数字，则添加到结果表中
            if type(value) == "number" then
                table.insert(resultTable, value)
            end
        elseif type(value) == "table" then
            -- 如果值是表，则递归遍历
            extractBtnIds(value, resultTable)
        end
    end
end

-- 调用递归函数，提取所有Btn开头的ID值
extractBtnIds(UIConf.Core, UIConf.BtnUIDResult)

return UIConf
