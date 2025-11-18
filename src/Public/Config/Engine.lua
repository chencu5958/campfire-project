-- ==================================================
-- * Campfire Project | Config/Engine.lua
-- *
-- * Info:
-- * Campfire Project Engine Config
-- *
-- * 2025 © RoidMC Studios | Powered by UniX SDK
-- ==================================================

local EngineConf = {}

EngineConf.Core = {
    Game = {
        RoundTime = 900,
        RoundPreparationTime = 10
    },
    Level = {
        BaseExp = 100,
        Ratio = 1.2,
        MaxLevel = 99999
    },
    Task = {
        DoTaskCDTime = 5,
        ClaimTimeLimit = 120, -- 保留，暂未启用
        AutoAssignTime = 8,
        GuideShowLimit = 5,
        GuideAutoDestory = 10,
        TaskLimit = 12,    -- 数据同步Task系统
        TaskCompleted = 0, -- 数据同步Task系统
    },
    AI = {
        SpawnLimit = 15
    },
    Team = {
        Red = {
            MaxLife = 3,
            AddLife = 2,
            MaxHealth = 3,
            AddHealth = 1
        },
        Blue = {
            MaxLife = 1,
            AddLife = 0,
        }
    }
}

EngineConf.GameUI = {
    Init = {
        NativeInterfaceHidden = {
            "Promotion",        -- 竞速的晋级界面
            "Countdown",        -- 竞速的倒计时界面
            "TargetPoints",     -- 竞速目标积分
            "Leaderboard",      -- 竞速排行榜
            "Settings",         -- 通用设置
            "RemainingPlayers", -- FPS剩余人数
            "MapHint",          -- 通用地图提示
            "EmotesAndActions", -- 表情/动作
            "QuickChat",        -- 快速聊天
            "MoreSetting"       -- 更多设置
        },
    },
    UI = {
        MainMenuPID = {
            MyProfile = 1,
            Settings = 2,
            RankList = 3
        },
        Layout_SettingMisc = {
            Version = 1,
            Credits = 2,
            Feedback = 3
        },
        IMUtilsPID = {
            TChat = 1,
            VChat = 2
        }
    }
}

EngineConf.GameInstance = {
    Item = {
        Icon_Dsp_RedTeam = 268,
        Icon_Dsp_BlueTeam = 238,
        Icon_Dsp_PlayerHP_Bar = 486,
        Item_Weapon_Gun = "weapon1126663746893194317575190881",
        Item_Weapon_Hammer = "weapon1126663746893194317582111851",
        Element_CommonGuide = 313
    },
    Scale = {
        Icon_Dsp_Team = { X = 0.1, Y = 0.35, Z = 0.17 },
        Icon_Dsp_PlayerHP_Bar = { X = 0.1, Y = 0.74, Z = 0.1 },
        Element_CommonGuide = { X = 1, Y = 1, Z = 1 }
    },
    Offset = {
        Icon_Dsp_Team = { X = 0, Y = 0, Z = 185 },
        Icon_Dsp_PlayerHP_Bar = { X = 0, Y = 0, Z = 160 }
    },
    NPCModel = {
        NPC_1 = 257,
        NPC_2 = 261,
        NPC_3 = 240,
        NPC_4 = 242,
        NPC_5 = 264,
        NPC_6 = 265,
    },
    GuideIcon = {
        Icon_Target = 10001,  -- 120000001
        Icon_Target_Hex = "#FFFF00",
        Icon_Warning = 50002, --120000015
        Icon_Warning_Hex = "#FF0000"
    },
}

EngineConf.Map = {
    Team = {
        Red = 0,
        Blue = 1
    },
    TeamHex = {
        Red = "#FF0000",
        Blue = "#3661C6",
        NPC = "#FFCC28",
        None = "#FFFFFF"
    },
    Timer = {
        GameRound = "GamdRound_Timer",
        ClientMusicTimer = "ClientMusicTimer",
        TaskAutoAssign = "TaskAutoAssignTimer",
        DoTaskTime = "DoTaskTime",
    },
    Status = {
        Alive = { ID = 0, Name = "Alive" },
        Dead = { ID = 1, Name = "Dead" },
        Exit = { ID = 2, Name = "Exit" },
        Disconnect = { ID = 3, Name = "Disconnect" },
        NetError = { ID = 98, Name = "NetError" },
        Missing = { ID = 99, Name = "Missing" }
    },
    SignalEvent = {
        OpenStore = "OpenStore"
    },
    Rank = {
        GRank_Economy = 1,
        GRank_Level = 2,
        GRank_Reserved = 3
    },
    GameStage = {
        Ready = 0,
        Start = 1,
        End = 2,
        DisableGameFeature = 99
    },
    GameReasonCode = {
        PlayerCountCheck = {
            NotEnough = 1,
            CheckApproved = 2,
            RedTeamNotEnough = 3,
            BlueTeamNotEnough = 4,
        },
        Common = {
            Unknown = 9999
        }
    },
    NexAnimate = {
        Dance_Fun = "DanceSS",
        Dance_JSC = "DanceJSC",
        TouchHead = "TouchHead",
        BastBallBat = "BastBallBat",
        Stretch = "Stretch",
        ChooseMale = "ChooseMale",
        Drink001 = "Drink001",
        SitThought = "SitThought"
    },
}

EngineConf.AI = {
    PointType = {
        LowPoint = {
            PosZ = 100,
        },
        HighPoint = {
            PosZ = 400,
        }
    },
    SpawnPoint = {
        Point_H_1 = {
            Name = "Point_H_1",
            Pos = { X = -420, Y = -4120, Z = 400 }
        },
        Point_H_2 = {
            Name = "Point_H_2",
            Pos = { X = -1850, Y = -4120, Z = 400 }
        },
        Point_H_3 = {
            Name = "Point_H_3",
            Pos = { X = -4120, Y = -4120, Z = 400 }
        },
        Point_H_4 = {
            Name = "Point_H_4",
            Pos = { X = -4120, Y = -2880, Z = 400 }
        },
        Point_H_5 = {
            Name = "Point_H_5",
            Pos = { X = -4120, Y = -1170, Z = 400 }
        },
        Point_H_6 = {
            Name = "Point_H_6",
            Pos = { X = -4320, Y = 170, Z = 400 }
        },
        Point_H_7 = {
            Name = "Point_H_7",
            Pos = { X = -3260, Y = 1980, Z = 400 }
        },
        Point_H_8 = {
            Name = "Point_H_8",
            Pos = { X = -1830, Y = 1980, Z = 400 }
        },
        Point_H_9 = {
            Name = "Point_H_9",
            Pos = { X = -1830, Y = -40, Z = 400 }
        },
        Point_H_10 = {
            Name = "Point_H_10",
            Pos = { X = -1850, Y = -1580, Z = 400 }
        },
        Point_H_11 = {
            Name = "Point_H_11",
            Pos = { X = -450, Y = -1580, Z = 400 }
        },
        Point_H_12 = {
            Name = "Point_H_12",
            Pos = { X = -450, Y = -40, Z = 400 }
        },
        Point_L_1 = {
            Name = "Point_L_1",
            Pos = { X = 170, Y = 910, Z = 100 }
        },
        Point_L_2 = {
            Name = "Point_L_2",
            Pos = { X = 170, Y = -450, Z = 100 }
        },
        Point_L_3 = {
            Name = "Point_L_3",
            Pos = { X = 170, Y = -1270, Z = 100 }
        },
        Point_L_4 = {
            Name = "Point_L_4",
            Pos = { X = 1310, Y = -450, Z = 100 }
        }
    },
    RoutinePath = {
        MapRoute_Full_1 = {
            Type = "FullMapPath",
            Name = "FullMapPath_01",
            PointType = "High"
        },
        MapRoute_Full_2 = {
            Type = "FullMapPath",
            Name = "FullMapPath_02",
            PointType = "High"
        },
        MapRoute_Routine_01 = {
            Type = "RoutineMapPath",
            Name = "RoutineMapPath_01",
            PointType = "High"
        },
        MapRoute_Routine_02 = {
            Type = "RoutineMapPath",
            Name = "RoutineMapPath_02",
            PointType = "High"
        },
        MapRoute_Routine_03 = {
            Type = "RoutineMapPath",
            Name = "RoutineMapPath_L_01",
            PointType = "Low"
        },
        MapRoute_Routine_04 = {
            Type = "RoutineMapPath",
            Name = "RoutineMapPath_L_02",
            PointType = "Low"
        },
    }
}

EngineConf.Sound = {
    UI = {
        CommonClick = 700125, -- 通用点击音效5
        CommonClose = 700126, -- 通用返回按钮点击音效
    }
}

EngineConf.Task = {
    TaskCode = {
        Unclaim = "Unclaim",     -- 未认领
        Claimed = "Claimed",     -- 已认领
        Completed = "Completed", -- 已完成
        Recycled = "Recycled"    -- 已回收（未使用）
    },
    -- 不做I18N 了，炫技功能做了意义不大
    TaskList = {
        {
            ID = 1,
            Name = {
                Default = "前往小铺拿取物品",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 4125, SignalBox = 752, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "小铺的商品被捣蛋鬼拿走了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 100 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 4165, 4166, 4167 },
        },
        {
            ID = 2,
            Name = {
                Default = "破坏农场小屋玻璃",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 4384, SignalBox = 5203, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "农场小屋的玻璃被捣蛋鬼打碎了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 100 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 4937, 4938 },
        },
        {
            ID = 3,
            Name = {
                Default = "前往农场菜地偷菜",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 1563, SignalBox = 5206, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "菜地的菜被捣蛋鬼偷走了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 100 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 1726 },
        },
        {
            ID = 4,
            Name = {
                Default = "把农场工具藏起来",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 1679, SignalBox = 5207, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "农场工具被捣蛋鬼藏起来了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 50 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 4173, 4739 },
        },
        {
            ID = 5,
            Name = {
                Default = "拿走农场休息小屋架子上的物品",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 4689, SignalBox = 5209, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "农场休息小屋架子上的物品被捣蛋鬼拿走了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 50 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 4733, 4747, 4748, 4755 },
        },
        {
            ID = 6,
            Name = {
                Default = "弄乱电脑里的文件",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 4359, SignalBox = 5211, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "电脑里的文件被捣蛋鬼弄乱了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 50 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 4360, 4364 },
        },
        {
            ID = 7,
            Name = {
                Default = "破坏墙壁上的涂鸦",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 2929, SignalBox = 5212, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "墙壁上的涂鸦被捣蛋鬼破坏了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 50 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 2924, 3629 },
        },
        {
            ID = 8,
            Name = {
                Default = "搬走小屋堆放的草垛",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 4346, SignalBox = 5213, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "小屋堆放的草垛被捣蛋鬼搬走了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 50 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 4349 },
        },
        {
            ID = 9,
            Name = {
                Default = "拿走工具放置处的物品",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 1505, SignalBox = 5214, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "工具放置处的物品被捣蛋鬼拿走了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 50 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 1501, 1516 },
        },
        {
            ID = 10,
            Name = {
                Default = "破坏稻草人",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 1601, SignalBox = 5215, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "稻草人被捣蛋鬼破坏了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 50 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 1699, 1609, 1607 },
        },
        {
            ID = 11,
            Name = {
                Default = "在花坛上留下标记",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 4947, SignalBox = 5216, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "捣蛋鬼在花坛上留下标记！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 50 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = {},
        },
        {
            ID = 12,
            Name = {
                Default = "拿走放在树下的收音机",
            },
            Desc = {
                Default = "TaskDesc",
            },
            Reward = { Coin = 15, Exp = 20, Score = 1 },
            BindID = { Element = 4024, SignalBox = 5219, Guide = 0 },
            Feature = { IsGuide = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "收音机被捣蛋鬼拿走了！",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 50 }, },
            Status = { ClaimedUIN = 0, TaskCode = "Unclaim" },
            DestoryItem = { 4037 },
        }
    },
}

EngineConf.NetMsg = {
    GameStateSync = {
        Server = 10000,
        Client = 10001
    },
    AlizaNotice = {
        ServerBoardcast = 10002,
    }
}

--- 属性配置（1为类型，2为属性名称，3是默认值）
--- <br>
--- 说明：LightDMS如果管理玩家属性，对应调用名称为PropertyName_PlayerID拼接，例如：GameRoundTotal_PlayerID
--- <br>
--- 无特殊说明则使用属性名称，例如UIState下面的所有属性
EngineConf.Property = {
    KeyMap = {
        -- 云存储同步
        PSetting = {
            Lang = { "String", "PSetting_Lang", "zh-CN" },
            SFXSound = { "Boolean", "PSetting_SFXSound", true },
            TeamMic = { "Boolean", "PSetting_TeamMic", true },
            TeamChat = { "Boolean", "PSetting_TeamChat", true },
        },
        UserData = {
            AccountProfile = { "Map", "UserData_AccountProfile" },
            TaskData = { "Map", "UserData_TaskData" },
        },
        -- 云存储同步，ACL规则为ServerOnly
        PState = {
            GameRoundTotal = { "Number", "PState_GameRoundTotal", 0 },
            GameRoundWin = { "Number", "PState_GameRoundWin", 0 },
            GameRoundLose = { "Number", "PState_GameRoundLose", 0 },
            GameRoundDraw = { "Number", "PState_GameRoundDraw", 0 },
            GameRoundEscape = { "Number", "PState_GameRoundEscape", 0 },
            PlayerLevel = { "Number", "PState_PlayerLevel", 1 },
            PlayerLevelIsMax = { "Boolean", "PState_PlayerLevelIsMax", false },
            PlayerExp = { "Number", "PState_PlayerExp", 0 },
        },
        -- GameState由UDK Property管理，ACL规则ServerOnly
        GameState = {
            NameSpace = "GameState",
            PlayerIsDisconnect = { "Boolean", "GameState_PlayerIsDisconnect", false },
            PlayerStatus = { "Number", "GameState_PlayerStatus", 0 },
            PlayerBindTeamTagID = { "Number", "GameState_PlayerBindTeamTagID" },
            PlayerBindHPBarID = { "Number", "GameState_PlayerBindHPBarID" },
            PlayerExpReq = { "Number", "GameState_PlayerExpRequire", 0 },
            PlayerTaskClaimStatus = { "Number", "GameState_PlayerTaskClaimStatus", 0 },
            PlayerTaskColddownStatus = { "Number", "GameState_PlayerTaskColddownStatus", 0 }, -- 暂时不使用
            PlayerIsInTaskArea = { "Number", "GameState_PlayerIsInTaskArea", 0 },
            PlayerCurrentSignalBox = { "Number", "GameState_PlayerCurrentSignalBox", 0 },
            PlayerClaimTaskInfo = { "Map", "GameState_PlayerTaskClaimInfo" },
            PlayerIsDoTask = { "Number", "GameState_PlayerIsDoTask", 0 },
            PlayerModelID = { "Number", "GameState_PlayerModelID" }, -- 这个ID是NPC模型ID，正常红队是不会被分配到这个数据的
            GameStage = { "Number", "GameState_GameStage" }          -- 由NameSpace管理
        },
        -- UIState全部由客户端的LightDMS管理，UDK Property不参与管理
        UIState = {
            MainMenuIsOpen = { "Boolean", "UIState_MainMenuIsOpen", false },
            MainMenuOpenPID = { "Number", "UIState_MainMenuOpenPID", 1 },
            LayoutSettingMiscPID = { "Number", "UIState_LayoutSettingMiscPID", 1 },
            TaskbarIsOpen = { "Boolean", "UIState_TaskbarIsOpen", false },
            IMUtilsIsOpen = { "Boolean", "UIState_IMUtilsIsOpen", false },
            IMUtilsOpenPID = { "Number", "UIState_IMUtilsOpenPID", 1 },
            TeamPopIsOpen = { "Boolean", "UIState_TeamPopIsOpen", true }
        },
        -- ClientState全部由客户端的LightDMS管理，UDK Property不参与管理
        ClientState = {
            ClientIsInit = { "Boolean", "ClientState_ClientIsInit" },
        },
        ServerState = {
            NameSpace = "ServerState",
            GameState = { "Map", "ServerState_GameState" },
            RankList = { "Map", "ServerState_RankList" },
        },
        CloudData = {
            InitStatus = { "Boolean", "CloudData_InitStatus", true }
        },
    }
}

return EngineConf
