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
        RoundTime = 1200,
        RoundPreparationTime = 10
    },
    Level = {
        BaseExp = 100,
        Ratio = 1.2,
        MaxLevel = 99999
    },
    Task = {
        DoTaskCDTime = 5,
        ClaimTimeLimit = 120,
        AutoAssignTime = 8,
        GuideShowLimit = 5,
        GuideAutoDestory = 10
    },
    AI = {
        SpawnLimit = 15,
        SpawnCount = 0
    }
}

EngineConf.GameUI = {
    Init = {
        NativeInterfaceHidden = {
            "Promotion",        -- 竞速的晋级界面
            "Countdown",        -- 竞速的倒计时界面
            "TargetPoints",     -- 竞速目标积分
            "Leaderboard",      -- 竞速排行榜
            "HealthBar",        -- 通用血条
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
        Icon_Dsp_PlayerHP_Bar = { X = 0.1, Y = 0.74, Z = 0.1 }
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
        Icon_Target = 120000001,
        Icon_Target_Hex = "#FFFF00",
        Icon_Warning = 120000015,
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
        ClientMusicTimer = "ClientMusicTimer"
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
        Countdown = 3,
        DisableGameFeature = 99
    },
    GameReasonCode = {
        PlayerCountCheck = {
            NotEnough = 1,
            CheckApproved = 2,
            RedTeamNotEnough = 3,
            BlueTeamNotEnough = 4,
        },
        VictoryCondition = {},
        GameTime = {},
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

EngineConf.AI = {}

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
    TaskList = {
        {
            ID = 1,
            Name = "TestTask",
            Desc = "This is a test task",
            Reward = { Coin = 0, Exp = 0, Score = 0 },
            BindID = { Element = 1, SignalBox = 1 },
            Feature = { IsGuide = true, IsI18N = true, AlizaNotice = true },
            AlizaNotice = {
                Type    = "SystemMsg",
                Message = "This is a test task",
                Color   = "#FFFFFF"
            },
            Location = { Offset = { X = 0, Y = 0, Z = 0 }, },
            Status = { IsClamed = false, ClamedUIN = 0, TaskCode = 0 }
        }
    }
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
            GameRoundEscape = { "Number", "PState_GameRoundTime", 0 },
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
            GameStage = { "Number", "GameState_GameStage" } -- 由NameSpace管理
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
