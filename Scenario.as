package 
{
	import flash.utils.Dictionary;
	import starling.display.Image;

	public class Scenario
	{
		public static var TEST:int = 0;
		public static var KYUDO:int = 1;
		public static var SHIKA:int = 2;
		public static var YAMADORI:int = 3;
		public static var YOICHI:int = 4;
		public static var TAMETOMO:int = 5;
		public static var TELL:int = 6;
		public static var RAM:int = 7;
		public static var ONLINE_TEST:int = 8;
		public static var TOOSHIYA:int = 9;
		public static var YABUSAME:int = 10;
		public static var MUKADE:int = 11;
		public static var ONIBI:int = 12;
		public static var ONI:int = 13;
		public static var TUCHIGUMO:int = 14;
		public static var ONI3:int = 15;
		public static var SHUTENDOUJI:int = 16;
		public static var DAIJA:int = 17;
		public static var OROCHI:int = 18;
		public static var ZOMBIE:int = 19;
		public static var SKELETON:int = 20;
		public static var SLIME:int = 21;
		public static var ARMOR_DEMON:int = 22;
		public static var TREE:int = 23;
		public static var HARPY:int = 24;
		public static var WISP:int = 25;
		public static var LONGWITTON:int = 26;
		public static var TANK:int = 27;
		public static var FIGHTER:int = 28;
		public static var BATTLE_SHIP:int = 29;
		public static var STEALTH:int = 30;
		public static var UFO:int = 31;
		public static var TREX:int = 32;
		public static var PTERANODON:int = 33;
		public static var METEORITE:int = 34;
		
		public static var REPORT_LV1:int = 35;	//報告用Lv1
		public static var REPORT_LV2:int = 36;	//報告用Lv2
		public static var REPORT_LV3:int = 37;	//報告用Lv3
		public static var REPORT_LV4:int = 38;	//報告用Lv4
		public static var REPORT_LV5:int = 39;	//報告用Lv5
		public static var REPORT_LV6:int = 40;	//報告用Lv6
		public static var REPORT_LV7:int = 41;	//報告用Lv7
		public static var REPORT_LV8:int = 42;	//報告用Lv8

		public static var ROSE:int = 43;
		public static var REPORT_LV9:int = 44;	//報告用Lv9
		public static var CHAMAELEON:int = 45;
		public static var REPORT_LV10:int = 46;	//報告用Lv10
		public static var TENGU:int = 47;
		public static var REPORT_LV11:int = 48;	//報告用Lv11
		public static var MAGATAMA_QUEST:int = 49;	//勾玉クエスト用
		public static var REPORT_LV12:int = 50;	//報告用Lv12
		public static var GARUDA:int = 51;

		public var scenarioNo:Vector.<int>;
		public static var scenarioName:Dictionary = new Dictionary();
		//private var scenarioClear:Dictionary = new Dictionary();
		private var explain:Dictionary = new Dictionary();
		//private var exp:Dictionary = new Dictionary();
		private var reportStage:Dictionary = new Dictionary();
		private var reidan10bai:Dictionary = new Dictionary();
		
		public static var YUMI_NORMAL:int = 0;
		public static var YUMI_HAMAYUMI:int = 1;
		public var bowKind:Dictionary = new Dictionary();
		//public var magatamaChange:Dictionary = new Dictionary();

		//public static var syncLevel:Dictionary = new Dictionary();
		private static var syncLevel:Dictionary = new Dictionary();

		public var no:int = KYUDO;
		public var lastClearIndex:int = -1;

		public var haikeiData:Vector.<int>;
		public var haikeiData2:Vector.<int>;
		public var haikeiData3:Vector.<int>;

		//static init
		{
			syncLevel[KYUDO]    = 1;
			syncLevel[YABUSAME] = 1;
			syncLevel[TOOSHIYA] = 1;
			syncLevel[SHIKA]    = 1;
			syncLevel[YAMADORI] = 1;
			syncLevel[YOICHI]   = 1;
			syncLevel[TAMETOMO] = 1;
			syncLevel[TELL]     = 1;
			
			syncLevel[ONIBI]       = 20;
			syncLevel[ONI]         = 20;
			syncLevel[DAIJA]       = 20;
			syncLevel[MUKADE]      = 20;
			syncLevel[TUCHIGUMO]   = 25;
			syncLevel[ONI3]        = 25;
			syncLevel[OROCHI]      = 25;
			syncLevel[SHUTENDOUJI] = 25;

			syncLevel[ZOMBIE]      = 30;
			syncLevel[SKELETON]    = 30;
			syncLevel[SLIME]       = 30;
			syncLevel[ARMOR_DEMON] = 30;
			syncLevel[TREE]        = 35;
			syncLevel[HARPY]       = 35;
			syncLevel[WISP]        = 35;
			syncLevel[LONGWITTON]  = 35;
			
			syncLevel[TANK]  		= 40;
			syncLevel[FIGHTER] 		= 40;
			syncLevel[BATTLE_SHIP]  = 40;
			syncLevel[STEALTH]      = 40;
			syncLevel[UFO]      	= 45;
			syncLevel[TREX]      	= 45;
			syncLevel[PTERANODON]   = 45;
			syncLevel[METEORITE]    = 50;
			
			syncLevel[REPORT_LV1]  	= 55;
			syncLevel[REPORT_LV2]  	= 56;
			syncLevel[REPORT_LV3]  	= 57;
			syncLevel[REPORT_LV4]  	= 58;
			syncLevel[REPORT_LV5]  	= 59;
			syncLevel[REPORT_LV6]  	= 60;
			syncLevel[REPORT_LV7]  	= 61;
			syncLevel[REPORT_LV8]  	= 62;
			
			syncLevel[ROSE]			= 65;
			syncLevel[REPORT_LV9]  	= 66;
			syncLevel[CHAMAELEON]   = 67;
			syncLevel[REPORT_LV10]  = 68;
			syncLevel[TENGU] 		= 69;
			syncLevel[REPORT_LV11]  = 72;
			syncLevel[REPORT_LV12]  = 75;
			syncLevel[GARUDA] 		= 78;
		}

		//--------
		private static var syncYakazu:Dictionary = new Dictionary();

		//static init
		{
			//自動射出で協力戦一人で60秒で倒せるのを目安に調整
			
			syncYakazu[ONIBI]       = 10;
			syncYakazu[ONI]         = 10;
			syncYakazu[DAIJA]       = 10;
			syncYakazu[MUKADE]      = 15;
			syncYakazu[TUCHIGUMO]   = 15;
			syncYakazu[ONI3]        = 20;
			syncYakazu[OROCHI]      = 25;
			syncYakazu[SHUTENDOUJI] = 25;

			//SHUTENDOUJIまでのMAX勾玉１個で計測（矢8飛5速3）
			//50秒台
			syncYakazu[ZOMBIE]      = 20;
			syncYakazu[SKELETON]    = 30;
			syncYakazu[SLIME]       = 40;
			syncYakazu[ARMOR_DEMON] = 45;
			syncYakazu[TREE]        = 45;
			syncYakazu[HARPY]       = 30;
			syncYakazu[WISP]        = 50;
			syncYakazu[LONGWITTON]  = 60;

			//LONGWITTONまでのMAX勾玉１個で計測（矢8飛6速6）
			syncYakazu[TANK]  		= 60;
			syncYakazu[FIGHTER] 	= 55;
			syncYakazu[BATTLE_SHIP] = 55;
			syncYakazu[STEALTH]     = 60;
			//STEALTHまでのMAX勾玉１個で計測（矢8飛7速7密8貫9）
			syncYakazu[UFO]      	= 85;
			syncYakazu[TREX]      	= 65;
			syncYakazu[PTERANODON]  = 65;
			syncYakazu[METEORITE]   = 85;

			//METEORITEまでのMAX勾玉１個で計測（矢9飛10速7密9貫10）
			syncYakazu[REPORT_LV1]  	= 80;
			syncYakazu[REPORT_LV2]  	= 80;
			syncYakazu[REPORT_LV3]  	= 85;
			syncYakazu[REPORT_LV4]  	= 85;
			//REPORT_LV4までのMAX勾玉１個で計測（矢13飛11速9密12貫12）
			syncYakazu[REPORT_LV5]  	= 90;
			syncYakazu[REPORT_LV6]  	= 95;
			syncYakazu[REPORT_LV7]  	= 100;
//REPORT_LV8からは未計測
			syncYakazu[REPORT_LV8]  	= 999;

			syncYakazu[ROSE]			= 999;
			syncYakazu[REPORT_LV9]  	= 999;
			syncYakazu[CHAMAELEON]  	= 999;
			syncYakazu[REPORT_LV10] 	= 999;
			syncYakazu[TENGU] 			= 999;
			syncYakazu[REPORT_LV11]  	= 999;
			syncYakazu[REPORT_LV12]  	= 999;
			syncYakazu[GARUDA]  		= 999;
		}
		public static function getSyncYakazu(_no:int):int
		{
			var ret:int = syncYakazu[_no];

			//呪い
			if (Global.stageNoroiValue == "1")
			{
				ret = ret * 1.5;
			}
			//--------
			if (Global.stageNoroiValue == "2")
			{
				//呪２保留
				ret = ret + 999;
			}
			//--------

			return ret;
		}
		//--------

		public static function getSyncLevel(_no:int):int
		{
			var ret:int = syncLevel[_no];

			//呪い
			if (Global.stageNoroiValue == "1")
			{
				ret += 10;
			}
			//--------
			if (Global.stageNoroiValue == "2")
			{
				//呪２保留
				ret += 60;
			}
			//--------

			return ret;
		}

		//参加可能な最小レベル
		public function getMinLevel():int
		{
			//return getSyncLevel(no) - 15;
			/*
			//--------
			var minLv:int = getSyncLevel(no) - 15;
			//参加必要レベルの最大値45とする20140814
			if (45 < minLv)
			{
				minLv = 45;
			}
			return minLv;
			//--------
			*/
			
			var minLv:int = syncLevel[no] - 15;

			//呪い
			if (Global.stageNoroiValue == "1")
			{
				minLv += 5;
			}
			//--------
			if (Global.stageNoroiValue == "2")
			{
				//呪２保留
				minLv = 80;
			}
			//--------

			return minLv;
		}
		//Global.stageNoroiValueの値が未確定用のときに呪いを考慮した関数
		public function getMinLevelNoroiFlag(isNoroi:Boolean):int
		{
			var minLv:int = syncLevel[no] - 15;

			//呪い
			if (isNoroi)
			{
				minLv += 5;
			}

			return minLv;
		}
		public function getMinLevelNoroi2Flag(isNoroi2:Boolean):int
		{
			var minLv:int = syncLevel[no] - 15;

			//呪い
			if (isNoroi2)
			{
				//呪２保留
				minLv = 80;
			}

			return minLv;
		}
		
		//描画方法
		public function isReportStage():Boolean
		{
			return reportStage[no];
		}
		public function isReportStageFromNo(_no:int):Boolean
		{
			return reportStage[_no];
		}
		
		//霊力10倍の霊弾？
		public function isReidan10bai():Boolean
		{
			return reidan10bai[no];
		}
		
		public function Scenario()
		{
			var i:int;

			scenarioNo = Vector.<int>
			([
				 KYUDO			//0
				,YABUSAME		//1
				,TOOSHIYA
				,SHIKA
				,YAMADORI
				,YOICHI			//5
				,TAMETOMO
				,TELL
				
				,ONIBI
				,ONI
				,DAIJA			//10
				,MUKADE
				,TUCHIGUMO
				,ONI3
				,OROCHI
				,SHUTENDOUJI	//15
				
				,ZOMBIE
				,SKELETON
				,SLIME
				,ARMOR_DEMON
				,TREE			//20
				,HARPY
				,WISP
				,LONGWITTON
				
				,TANK
				,FIGHTER
				,BATTLE_SHIP
				,STEALTH
				,UFO
				,TREX
				,PTERANODON		//30
				,METEORITE
				
				,REPORT_LV1
				,REPORT_LV2
				,REPORT_LV3
				,REPORT_LV4
				,REPORT_LV5
				,REPORT_LV6
				,REPORT_LV7
				,REPORT_LV8
				
				,ROSE
				,REPORT_LV9
				,CHAMAELEON
				,REPORT_LV10
				,TENGU
				,REPORT_LV11
				,REPORT_LV12
				,GARUDA
			]);

			//--------
			bowKind[KYUDO]    = YUMI_NORMAL;
			bowKind[YABUSAME] = YUMI_NORMAL;
			bowKind[TOOSHIYA] = YUMI_NORMAL;
			bowKind[SHIKA]    = YUMI_NORMAL;
			bowKind[YAMADORI] = YUMI_NORMAL;
			bowKind[YOICHI]   = YUMI_NORMAL;
			bowKind[TAMETOMO] = YUMI_NORMAL;
			bowKind[TELL]     = YUMI_NORMAL;
			
			bowKind[ONIBI]       = YUMI_HAMAYUMI;
			bowKind[ONI]         = YUMI_HAMAYUMI;
			bowKind[DAIJA]       = YUMI_HAMAYUMI;
			bowKind[MUKADE]      = YUMI_HAMAYUMI;
			bowKind[TUCHIGUMO]   = YUMI_HAMAYUMI;
			bowKind[ONI3]        = YUMI_HAMAYUMI;
			bowKind[OROCHI]      = YUMI_HAMAYUMI;
			bowKind[SHUTENDOUJI] = YUMI_HAMAYUMI;
			
			bowKind[ZOMBIE]      = YUMI_HAMAYUMI;
			bowKind[SKELETON]    = YUMI_HAMAYUMI;
			bowKind[SLIME]       = YUMI_HAMAYUMI;
			bowKind[ARMOR_DEMON] = YUMI_HAMAYUMI;
			bowKind[TREE]        = YUMI_HAMAYUMI;
			bowKind[HARPY]       = YUMI_HAMAYUMI;
			bowKind[WISP]        = YUMI_HAMAYUMI;
			bowKind[LONGWITTON]  = YUMI_HAMAYUMI;
			
			bowKind[TANK]		= YUMI_HAMAYUMI;
			bowKind[FIGHTER]	= YUMI_HAMAYUMI;
			bowKind[BATTLE_SHIP]= YUMI_HAMAYUMI;
			bowKind[STEALTH]    = YUMI_HAMAYUMI;
			bowKind[UFO]    	= YUMI_HAMAYUMI;
			bowKind[TREX]    	= YUMI_HAMAYUMI;
			bowKind[PTERANODON] = YUMI_HAMAYUMI;
			bowKind[METEORITE]  = YUMI_HAMAYUMI;
			
			bowKind[REPORT_LV1]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV2]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV3]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV4]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV5]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV6]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV7]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV8]  = YUMI_HAMAYUMI;
			bowKind[ROSE]   = YUMI_HAMAYUMI;
			bowKind[REPORT_LV9]  = YUMI_HAMAYUMI;
			bowKind[CHAMAELEON]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV10]  = YUMI_HAMAYUMI;
			bowKind[TENGU]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV11]  = YUMI_HAMAYUMI;
			bowKind[REPORT_LV12]  = YUMI_HAMAYUMI;
			bowKind[GARUDA]  = YUMI_HAMAYUMI;

			//--------
			var id:String = "";
			for (id in scenarioNo)
			{
				reportStage[id] = false;
			}
			reportStage[REPORT_LV1] = true;
			reportStage[REPORT_LV2] = true;
			reportStage[REPORT_LV3] = true;
			reportStage[REPORT_LV4] = true;
			reportStage[REPORT_LV5] = true;
			reportStage[REPORT_LV6] = true;
			reportStage[REPORT_LV7] = true;
			reportStage[REPORT_LV8] = true;
			reportStage[ROSE] = false;
			reportStage[REPORT_LV9] = true;
			reportStage[CHAMAELEON] = false;
			reportStage[REPORT_LV10] = true;
			reportStage[TENGU] = false;
			reportStage[REPORT_LV11] = true;
			reportStage[REPORT_LV12] = true;
			reportStage[GARUDA] = false;
			
			//--------
			for (id in scenarioNo)
			{
				reidan10bai[id] = false;
			}
			//報告書Lv4から霊弾は取得霊力x10
			reidan10bai[REPORT_LV4] = true;
			reidan10bai[REPORT_LV5] = true;
			reidan10bai[REPORT_LV6] = true;
			reidan10bai[REPORT_LV7] = true;
			reidan10bai[REPORT_LV8] = true;
			reidan10bai[ROSE]  = true;
			reidan10bai[REPORT_LV9] = true;
			reidan10bai[CHAMAELEON] = true;
			reidan10bai[REPORT_LV10] = true;
			reidan10bai[TENGU] = true;
			reidan10bai[REPORT_LV11] = true;
			reidan10bai[REPORT_LV12] = true;
			reidan10bai[GARUDA] = true;
			
			//--------
			scenarioName[KYUDO] = "弓道場";
			scenarioName[SHIKA] = "鹿狩り";
			scenarioName[YAMADORI] = "山鳥狩り";
			scenarioName[YOICHI] = "那須与一";
			scenarioName[TAMETOMO] = "源為朝";
			scenarioName[TELL] = "ウイリアム・テル";
			//scenarioName[RAM] = "ラーマ";
			scenarioName[ONLINE_TEST] = "ONLINE TEST";
			scenarioName[TOOSHIYA] = "通し矢";
			scenarioName[YABUSAME] = "流鏑馬";
			//scenarioName[MUKADE] = "俵藤太";
			scenarioName[MUKADE] = "大百足";
			scenarioName[ONIBI] = "鬼火";
			scenarioName[ONI] = "鬼";
			scenarioName[TUCHIGUMO] = "土蜘蛛";
			scenarioName[ONI3] = "英胡・軽足・土熊";
			scenarioName[SHUTENDOUJI] = "酒呑童子";
			scenarioName[DAIJA] = "大蛇";
			scenarioName[OROCHI] = "八岐大蛇";
			scenarioName[ZOMBIE] = "ゾンビ";
			scenarioName[SKELETON] = "スケルトン";
			scenarioName[SLIME] = "スライム";
			scenarioName[ARMOR_DEMON] = "リビングアーマー";
			scenarioName[TREE] = "マンイーティングツリー";
			scenarioName[HARPY] = "ハーピー";
			scenarioName[WISP] = "ウィル・オ・ウィスプ";
			scenarioName[LONGWITTON] = "ロングウィットンの魔竜";
			scenarioName[TANK] = "タンク";
			scenarioName[FIGHTER] = "ボンバー";
			scenarioName[BATTLE_SHIP] = "バトルシップ";
			scenarioName[STEALTH] = "ステルス";
			scenarioName[UFO] = "ＵＦＯ";
			scenarioName[TREX] = "ティラノサウルス";
			scenarioName[PTERANODON] = "プテラノドン";
			scenarioName[METEORITE] = "メテオライト";
			scenarioName[REPORT_LV1] = "--未選択--";
			scenarioName[REPORT_LV2] = "--未選択--";
			scenarioName[REPORT_LV3] = "--未選択--";
			scenarioName[REPORT_LV4] = "--未選択--";
			scenarioName[REPORT_LV5] = "--未選択--";
			scenarioName[REPORT_LV6] = "--未選択--";
			scenarioName[REPORT_LV7] = "--未選択--";
			scenarioName[REPORT_LV8] = "--未選択--";
			scenarioName[ROSE]  = "ローズ";
			scenarioName[REPORT_LV9] = "--未選択--";
			scenarioName[CHAMAELEON]  = "カメレオン";
			scenarioName[REPORT_LV10] = "--未選択--";
			scenarioName[TENGU]  = "天狗";
			scenarioName[REPORT_LV11] = "--未選択--";
			scenarioName[REPORT_LV12] = "--未選択--";
			scenarioName[GARUDA]  = "ガルダ";
			
			/*
			for (id in scenarioNo)
			{
				if (reportStage[id])
				{
					scenarioName[id] = "--未選択--";
				}
			}
			*/

			//explain[KYUDO] = "■鍛錬■\n弓道場\n\n「当家は弓術で代々妖魔退治をしてきた一族。当神社の跡取りたるもの弓術の鍛錬を怠ってはならない。」\n\n的に矢を１本当てよう。\n制限時間６０秒";
			explain[KYUDO] = "《鍛錬》\n";
			explain[KYUDO]+= "『弓道場』\n";
			explain[KYUDO]+= "\n";
			explain[KYUDO]+= "祖父「当家は弓術で代々妖魔退治をしてきた一族じゃ。";
			explain[KYUDO]+= "当神社の跡取りたるもの弓術の鍛錬を怠ってはならない。」\n";
			explain[KYUDO]+= "\n";
			explain[KYUDO]+= "・的に矢を１本当てよう\n";
			explain[KYUDO]+= "・制限時間60秒\n";

			//explain[YABUSAME] = "■鍛錬■\n流鏑馬\n\n「日本の伝統的な射術をきちんと習得して型を作ることが肝要だ。」\n\n馬で走りながら的に矢を１本ずつ計３本当てよう。\n制限時間６０秒";
			explain[YABUSAME] = "《鍛錬》\n";
			explain[YABUSAME]+= "『流鏑馬』\n";
			explain[YABUSAME]+= "\n";
			explain[YABUSAME]+= "祖父「日本の伝統的な射術をきちんと習得して型を作ることが肝要じゃ。";
			explain[YABUSAME]+= "型がなければ型破りはできん。」\n";
			explain[YABUSAME]+= "\n";
			explain[YABUSAME]+= "・３つの的に矢を当てよう\n";
			explain[YABUSAME]+= "・馬が走りきるまでが制限時間\n";

			//explain[TOOSHIYA] = "■鍛錬■\n通し矢\n\n「通し矢とは平安時代から続くものだ。競技では速さと正確性が求められる。」\n\n的に５回矢を当てよう。制限時間２０秒";
			explain[TOOSHIYA] = "《鍛錬》\n";
			explain[TOOSHIYA]+= "『通し矢』\n";
			explain[TOOSHIYA]+= "\n";
			explain[TOOSHIYA]+= "祖父「通し矢は三十三間堂で矢を射通すことじゃ。";
			explain[TOOSHIYA]+= "競技では速さと正確性が求められる。";
			explain[TOOSHIYA]+= "わしも若い頃は星野勘左衛門に憧れて大矢数をやったが記録は抜けんかった。」\n";
			explain[TOOSHIYA]+= "\n";
			explain[TOOSHIYA]+= "・的に５回矢を当てよう\n";
			explain[TOOSHIYA]+= "・制限時間30秒\n";

			//explain[SHIKA] = "■潜行演習■\n鹿狩り\n\n「当神社に代々伝わる霊器、破魔弓。過去の弓の名手の記憶に潜行できる。まずは習うより慣れろ。」\n\nある弓の名手の鹿狩りの記憶に潜行して技術を学びます。鹿を３頭射よう。\n制限時間６０秒";
			explain[SHIKA] = "《潜行演習》\n";
			explain[SHIKA]+= "『鹿狩り』\n";
			explain[SHIKA]+= "\n";
			explain[SHIKA]+= "祖父「当家、つまり当神社に代々伝わる霊器、破魔弓がある。";
			explain[SHIKA]+= "破魔弓の霊力により、当神社の第十五代神主の鹿狩りの記憶に潜行してもらう。」\n";
			//explain[SHIKA]+= "この破魔弓は霊力により、弓の名手の記憶に潜行する力を持つ。";
			//explain[SHIKA]+= "まずは当神社の第十五代神主の鹿狩りの記憶に潜行してもらう。」\n";
			explain[SHIKA]+= "\n";
			explain[SHIKA]+= "・記憶に潜行して技術を体得。\n";
			explain[SHIKA]+= "・制限時間60秒\n";

			//explain[YAMADORI] = "■潜行演習■\n山鳥狩り\n\n「破魔弓の霊力により過去の記憶に潜り、経験を追体験することで、技術を身をもって学ぶことが出来る。」\n\nある弓の名手の山鳥狩りの記憶に潜行して技術を学びます。山鳥を３羽射よう。\n制限時間６０秒";
			explain[YAMADORI] = "《潜行演習》\n";
			explain[YAMADORI]+= "『山鳥狩り』\n";
			explain[YAMADORI]+= "\n";
			explain[YAMADORI]+= "祖父「この破魔弓は弓の名手の記憶に潜行する力を持つ。";
			explain[YAMADORI]+= "次は十五代神主の山鳥狩りの記憶に潜行じゃ。」\n";
			explain[YAMADORI]+= "\n";
			explain[YAMADORI]+= "・記憶に潜行して技術を体得。\n";
			explain[YAMADORI]+= "・制限時間60秒\n";

			//explain[YOICHI] = "■潜行演習■\n那須与一\n\n「扇の的を射抜く話で有名な平安時代の武将だ。」\n\n那須与一の記憶に潜行します。\n扇の的を射抜こう。\n制限時間６０秒";
			explain[YOICHI] = "《潜行演習》\n";
			explain[YOICHI]+= "『那須与一』\n";
			explain[YOICHI]+= "\n";
			explain[YOICHI]+= "祖父「扇の的を射抜く話で有名な平安時代の武将の記憶に潜行じゃ。";
			explain[YOICHI]+= "集中力と命中力を身をもって体験してこい。」\n";
			explain[YOICHI]+= "\n";
			explain[YOICHI]+= "・扇の的を射抜こう。\n";
			explain[YOICHI]+= "・制限時間60秒\n";

			//explain[TAMETOMO] = "■潜行演習■\n源為朝\n\n「五人張りの強弓を使っていたと言われ、一矢で二人を倒したという。」\n\n源為朝の記憶に潜行します。\n門に攻めてくる敵兵を倒そう。\n制限時間６０秒";
			explain[TAMETOMO] = "《潜行演習》\n";
			explain[TAMETOMO]+= "『源為朝』\n";
			explain[TAMETOMO]+= "\n";
			explain[TAMETOMO]+= "祖父「五人張りの強弓を使い、一矢で二人を倒したという武将じゃ。";
			explain[TAMETOMO]+= "源為朝の豪腕を学んでこい。」\n";
			explain[TAMETOMO]+= "\n";
			explain[TAMETOMO]+= "・門に攻めてくる敵兵を倒そう。\n";
			explain[TAMETOMO]+= "・制限時間60秒\n";

			//explain[TELL] = "■潜行演習■\nウイリアム・テル\n\n「妖魔退治の海外遠征のときに技術交換したものだ。息子の頭の上の林檎をクロスボウで見事射抜いたという。」\n\nウイリアム・テルの記憶に潜行します。\n林檎を射抜こう。\n制限時間６０秒";
			explain[TELL] = "《潜行演習》\n";
			explain[TELL]+= "『ウイリアム・テル』\n";
			explain[TELL]+= "\n";
			explain[TELL]+= "祖父「息子の頭の上の林檎をクロスボウで見事射抜いたと言われる人物じゃ。\n";
			explain[TELL]+= "わしが海外遠征した際に、技術交流をしてもらってきた記憶だよ。」\n";
			explain[TELL]+= "\n";
			explain[TELL]+= "・林檎のみを射抜こう。\n";
			explain[TELL]+= "・制限時間60秒\n";

			//explain[ONIBI] = "■実戦■\n鬼火\n\n「鬼火自体は害のない妖魔だ。だが数が集まることで他の妖魔を呼び寄せる門となる。」\n\n集まっている鬼火を退治しよう。\n実戦では他の神社の射手が協力に現れることがあります。\n制限時間６０秒";
			explain[ONIBI] = "《実戦》\n";
			explain[ONIBI]+= "『鬼火』\n";
			explain[ONIBI]+= "\n";
			explain[ONIBI]+= "祖父「ここからは実戦じゃ。実戦では妖魔が相手なので破魔弓を使うことになる。";
			explain[ONIBI]+= "まずは鬼火退治に向かってもらう。";
			explain[ONIBI]+= "鬼火自体は害のない妖魔だが数が集まることで他の妖魔を呼び寄せる門となる。」\n";
			explain[ONIBI]+= "\n";
			explain[ONIBI]+= "・鬼火を退治しよう。\n";
			explain[ONIBI]+= "・制限時間60秒\n";
			//explain[ONIBI]+= "\n";
			//explain[ONIBI]+= "実戦では他の神社の射手が協力に現れることがあります。\n";

/*
			explain[MUKADE] = "《実戦》\n";
			explain[MUKADE]+= "『大百足』\n";
			explain[MUKADE]+= "\n";
			explain[MUKADE]+= "俵藤太が退治したという大百足が復活。\n";
			//explain[MUKADE]+= "妖魔退治の実戦の記憶に潜行して技術を体得。\n";
			explain[MUKADE]+= "\n";
			explain[MUKADE]+= "・大百足を退治しよう。\n";
			explain[MUKADE]+= "・制限時間120秒\n";
*/
			explain[ONI] = "《実戦》\n";
			explain[ONI]+= "『鬼』\n";
			explain[ONI]+= "\n";
			explain[ONI]+= "祖父「発見が遅れた鬼火の門から鬼の軍団が現れた。";
			explain[ONI]+= "被害が出る前に退治して、魔界に帰してやるんじゃ。」\n";
			explain[ONI]+= "\n";
			explain[ONI]+= "・鬼が矢倉に来る前に退治しよう。\n";
			explain[ONI]+= "・制限時間90秒。\n";
			explain[ONI]+= "\n";

			explain[DAIJA] = "《実戦》\n";
			explain[DAIJA]+= "『黒髪山の大蛇退治』\n";
			explain[DAIJA]+= "\n";
			explain[DAIJA]+= "祖父「退治依頼が来ている。黒髪山で退治された大蛇が復活したようじゃ。";
			explain[DAIJA]+= "矢倉は霊力により防壁が張られているが、何度も大蛇の攻撃を防げん。";
			explain[DAIJA]+= "矢倉を破壊される前に退治じゃ。」\n";
			explain[DAIJA]+= "\n";
			explain[DAIJA]+= "・大蛇を退治しよう。\n";
			explain[DAIJA]+= "・制限時間120秒\n";

			explain[MUKADE] = "《実戦》\n";
			explain[MUKADE]+= "『大百足退治』\n";
			explain[MUKADE]+= "\n";
			explain[MUKADE]+= "祖父「俵藤太が倒したといわれる大百足が再び現れた。";
			explain[MUKADE]+= "百足の殻は非常に硬い。弱点を狙うんじゃ！」\n";
			//explain[MUKADE]+= "妖魔退治の実戦の記憶に潜行して技術を体得。\n";
			explain[MUKADE]+= "\n";
			explain[MUKADE]+= "・大百足を退治しよう。\n";
			explain[MUKADE]+= "・制限時間120秒\n";

			explain[TUCHIGUMO] = "《実戦》\n";
			explain[TUCHIGUMO]+= "『土蜘蛛』\n";
			explain[TUCHIGUMO]+= "\n";
			explain[TUCHIGUMO]+= "祖父「日子坐王（ひこいますのみこ）が退治したという陸耳御笠（くがみみのみかさ）が復活したそうじゃ。ややこしい名前じゃが、ようはクモの妖魔じゃ。」\n";
			//explain[MUKADE]+= "妖魔退治の実戦の記憶に潜行して技術を体得。\n";
			explain[TUCHIGUMO]+= "\n";
			explain[TUCHIGUMO]+= "・陸耳御笠を退治しよう。\n";
			explain[TUCHIGUMO]+= "・制限時間120秒\n";

			explain[ONI3] = "《実戦》\n";
			explain[ONI3]+= "『英胡・軽足・土熊』\n";
			explain[ONI3]+= "\n";
			explain[ONI3]+= "祖父「麻呂子親王が退治したという英胡・軽足・土熊が現れたそうじゃ。奴らの連携攻撃は厄介じゃぞ。」\n";
			//explain[ONI3]+= "妖魔退治の実戦の記憶に潜行して技術を体得。\n";
			explain[ONI3]+= "\n";
			explain[ONI3]+= "・英胡・軽足・土熊を退治しよう。\n";
			explain[ONI3]+= "・制限時間120秒\n";

			explain[SHUTENDOUJI] = "《実戦》\n";
			explain[SHUTENDOUJI]+= "『酒呑童子』\n";
			explain[SHUTENDOUJI]+= "\n";
			explain[SHUTENDOUJI]+= "祖父「妖魔のくせに破魔弓を使う厄介な鬼じゃ。気をつけてな。」\n";
			explain[SHUTENDOUJI]+= "\n";
			explain[SHUTENDOUJI]+= "・酒呑童子を退治しよう。\n";
			explain[SHUTENDOUJI]+= "・制限時間120秒\n";

/*
			explain[DAIJA] = "《実戦》\n";
			explain[DAIJA]+= "『大蛇』\n";
			explain[DAIJA]+= "\n";
			explain[DAIJA]+= "大蛇が復活。\n";
			explain[DAIJA]+= "\n";
			explain[DAIJA]+= "・大蛇を退治しよう。\n";
			explain[DAIJA]+= "・制限時間120秒\n";
*/
			explain[OROCHI] = "《実戦》\n";
			explain[OROCHI]+= "『八岐大蛇』\n";
			explain[OROCHI]+= "\n";
			explain[OROCHI]+= "祖父「ついに八岐大蛇が現れた。第76代神主、つまりおまえの父親の仇じゃ。」\n";
			explain[OROCHI]+= "\n";
			explain[OROCHI]+= "・大蛇を退治しよう。\n";
			explain[OROCHI]+= "・制限時間120秒\n";

			//explain[RAM] = "ラーマ";
			explain[ONLINE_TEST] = "ONLINE TEST";

			explain[ZOMBIE] = "《実戦》\n";
			explain[ZOMBIE]+= "『ゾンビ』\n";
			explain[ZOMBIE]+= "\n";
			explain[ZOMBIE]+= "祖父「酒呑童子を倒したな。";
			explain[ZOMBIE]+= "これで日本の妖魔はしばらくおとなしくしているじゃろう。\n";
			explain[ZOMBIE]+= "そこで早速、お前の活躍を聞いて海外から依頼がきている。";
			explain[ZOMBIE]+= "欧米では一般的な妖魔じゃ。日本では大人気なんじゃろ？」\n";
			explain[ZOMBIE]+= "\n";
			explain[ZOMBIE]+= "・ゾンビを退治しよう。\n";
			explain[ZOMBIE]+= "・制限時間120秒\n";

			explain[SKELETON] = "《実戦》\n";
			explain[SKELETON]+= "『スケルトン』\n";
			explain[SKELETON]+= "\n";
			explain[SKELETON]+= "ロビン「イングランドのデーモン退治担当のロビンです。よろしく。";
			explain[SKELETON]+= "ジャパンではデーモンのことをヨーマと言うのですね。";
			explain[SKELETON]+= "ガイコツをハラキリで倒してください。お願いします。」\n";
			explain[SKELETON]+= "";
			explain[SKELETON]+= "\n";
			explain[SKELETON]+= "・スケルトンを退治しよう。\n";
			explain[SKELETON]+= "・制限時間120秒\n";

			explain[SLIME] = "《実戦》\n";
			explain[SLIME]+= "『スライム』\n";
			explain[SLIME]+= "\n";
			explain[SLIME]+= "ロビン「次のヨーマね。スライムのファイアボールはローリングストーン。";
			explain[SLIME]+= "油断大敵。カミカゼで倒してください。」\n";
			explain[SLIME]+= "\n";
			explain[SLIME]+= "・スライムを退治しよう。\n";
			explain[SLIME]+= "・制限時間120秒\n";
//explain[SLIME]+= "\n\n※本バージョンではここまでです。";

			explain[ARMOR_DEMON] = "《実戦》\n";
			explain[ARMOR_DEMON]+= "『リビングアーマー』\n";
			explain[ARMOR_DEMON]+= "\n";
			explain[ARMOR_DEMON]+= "ロビン「甲冑騎士のデーモンだ。デーモンも私たちをよく研究している。鎧への攻撃は無効ネ！";
			explain[ARMOR_DEMON]+= "ジシン、カミナリ、スシ、ゲイシャ！」\n";
			explain[ARMOR_DEMON]+= "\n";
			explain[ARMOR_DEMON]+= "・リビングアーマーを退治しよう。\n";
			explain[ARMOR_DEMON]+= "・制限時間120秒\n";
//explain[ARMOR_DEMON]+= "\n\n※本バージョンではここまでです。";

			explain[TREE] = "《実戦》\n";
			explain[TREE]+= "『マンイーティングツリー』\n";
			explain[TREE]+= "\n";
			explain[TREE]+= "ロビン「デーモンソウルが葉になるほど侵食された巨木です。核は１点ですが木の中にうまく隠れてます。";
			explain[TREE]+= "フジヤマニンジャオイシイネ！」\n";
			explain[TREE]+= "\n";
			explain[TREE]+= "・マンイーティングツリーを退治しよう。\n";
			explain[TREE]+= "・制限時間120秒\n";

			explain[HARPY] = "《実戦》\n";
			explain[HARPY]+= "『ハーピー』\n";
			explain[HARPY]+= "\n";
			explain[HARPY]+= "ロビン「ハーピーは空高くから攻撃をしてくる。しかも数が多い。";
			explain[HARPY]+= "サムライ、クナイ、クサリカタビラ！」\n";
			explain[HARPY]+= "\n";
			explain[HARPY]+= "・ハーピーを退治しよう。\n";
			explain[HARPY]+= "・制限時間120秒\n";

			explain[WISP] = "《実戦》\n";
			explain[WISP]+= "『ウィル・オ・ウィスプ』\n";
			explain[WISP]+= "\n";
			explain[WISP]+= "ロビン「ウィル・オ・ウィスプはオニビのビッグなやつさ。";
			explain[WISP]+= "連弾が厄介なデーモンダ！」\n";
			explain[WISP]+= "\n";
			explain[WISP]+= "・ウィル・オ・ウィスプを退治しよう。\n";
			explain[WISP]+= "・制限時間120秒\n";

			explain[LONGWITTON] = "《実戦》\n";
			explain[LONGWITTON]+= "『ロングウィットンの魔竜』\n";
			explain[LONGWITTON]+= "\n";
			explain[LONGWITTON]+= "ロビン「ノーサンバーランド州のロングウィットン近辺の森に棲んでいたと言われているデーモンだ。";
			explain[LONGWITTON]+= "たしか不死身で、原因があったはズ！ワスレタヨ、スミマセン。」\n";
			explain[LONGWITTON]+= "\n";
			explain[LONGWITTON]+= "・ロングウィットンの魔竜を退治しよう。\n";
			explain[LONGWITTON]+= "・制限時間120秒\n";

			explain[TANK] = "《実戦》\n";
			explain[TANK]+= "『タンク』\n";
			explain[TANK]+= "\n";
			explain[TANK]+= "ジェシー「アメリカ合衆国のデーモン退治担当のジェシーだ。";
			explain[TANK]+= "デーモンも我々から学んでいる。我々の兵器の真似をし始めたようだ。」\n";
			explain[TANK]+= "\n";
			explain[TANK]+= "・タンクを退治しよう。\n";
			explain[TANK]+= "・制限時間120秒\n";

			explain[FIGHTER] = "《実戦》\n";
			explain[FIGHTER]+= "『ボンバー』\n";
			explain[FIGHTER]+= "\n";
			explain[FIGHTER]+= "ジェシー「ボンバー、ニホンゴでは爆撃機。所詮、真似は真似だ！我々の戦闘機が世界一！";
			explain[FIGHTER]+= "」\n";
			explain[FIGHTER]+= "\n";
			explain[FIGHTER]+= "・ボンバーを退治しよう。\n";
			explain[FIGHTER]+= "・制限時間120秒\n";

			explain[BATTLE_SHIP] = "《実戦》\n";
			explain[BATTLE_SHIP]+= "『バトルシップ』\n";
			explain[BATTLE_SHIP]+= "\n";
			explain[BATTLE_SHIP]+= "ジェシー「バトルシップ、ニホンゴでは戦艦だな。だが地上だ。応用のつもりかわからんが、";
			explain[BATTLE_SHIP]+= "地上戦艦だ。それよりもサブマリンのほうが脅威だな。」\n";
			explain[BATTLE_SHIP]+= "\n";
			explain[BATTLE_SHIP]+= "・バトルシップを退治しよう。\n";
			explain[BATTLE_SHIP]+= "・制限時間120秒\n";

			explain[STEALTH] = "《実戦》\n";
			explain[STEALTH]+= "『ステルス』\n";
			explain[STEALTH]+= "\n";
			explain[STEALTH]+= "ジェシー「ステルス戦闘機だ。どういう仕組みか分からんが、";
			explain[STEALTH]+= "デーモンの戦闘機は姿を消す！レーダーから消えるのではなく視覚的にだ！";
			explain[STEALTH]+= "今回はサブマリンも来ている。空、地の戦闘となる。」\n";
			explain[STEALTH]+= "\n";
			explain[STEALTH]+= "・ステルスを退治しよう。\n";
			explain[STEALTH]+= "・制限時間120秒\n";

			explain[UFO] = "《実戦》\n";
			explain[UFO]+= "『ＵＦＯ』\n";
			explain[UFO]+= "\n";
			explain[UFO]+= "ジェシー「何を真似たのかわからん。我が国は関係ない。ノーコメントだ。";
			explain[UFO]+= "";
			explain[UFO]+= "」\n";
			explain[UFO]+= "\n";
			explain[UFO]+= "・ＵＦＯを退治しよう。\n";
			explain[UFO]+= "・制限時間120秒\n";

			explain[TREX] = "《実戦》\n";
			explain[TREX]+= "『ティラノサウルス』\n";
			explain[TREX]+= "\n";
			explain[TREX]+= "ジェシー「おそらくティラノサウルスを模したものだろう。";
			explain[TREX]+= "かつて北アメリカ大陸に生息していた肉食恐竜であり、";
			explain[TREX]+= "現在知られている中で最大の肉食獣だ。」\n";
			explain[TREX]+= "\n";
			explain[TREX]+= "・ティラノサウルスを退治しよう。\n";
			explain[TREX] += "・制限時間120秒\n";

			explain[PTERANODON] = "《実戦》\n";
			explain[PTERANODON] += "『プテラノドン』\n";
			explain[PTERANODON] += "\n";
			explain[PTERANODON] += "ジェシー「今回はプテラノドンに化けたのだろう。";
			explain[PTERANODON] += "北アメリカ大陸で化石が多く発見される翼竜だ。";
			explain[PTERANODON] += "実際に飛べたかどうかは不明らしいが、デーモンには関係ないようだ。」\n";
			explain[PTERANODON] += "\n"
			explain[PTERANODON] += "・プテラノドンを退治しよう。\n";
			explain[PTERANODON] += "・制限時間120秒\n";

			explain[METEORITE] = "《実戦》\n";
			explain[METEORITE] += "『メテオライト』\n";
			explain[METEORITE] += "\n";
			explain[METEORITE] += "ジェシー「恐竜絶滅説のことを学んだのか定かではないが、デーモンは総力を上げて来ている。";
			explain[METEORITE] += "しかし、これを殲滅すれば我々の出番もしばらく無くなるだろう。休暇だ喜べ！」\n";
			explain[METEORITE] += "\n"
			explain[METEORITE] += "・メテオライトを退治しよう。\n";
			explain[METEORITE] += "・制限時間120秒\n";

			explain[REPORT_LV1] = "《実戦》\n";
			//explain[TEISATSU] += "『メテオライト』\n";
			explain[REPORT_LV1] += "\n";
			explain[REPORT_LV1] += "祖父「地上の妖魔の活動は落ち着いた。これを機に";
			explain[REPORT_LV1] += "妖魔とはいったい何なのか、妖魔調査団が妖魔界に向かい報告書が届いている。";
			explain[REPORT_LV1] += "調査団に同行して報告書の妖魔を討伐して欲しいとのことじゃ。」\n";
			explain[REPORT_LV1] += "\n"
			explain[REPORT_LV1] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV1] += "・制限時間120秒\n";

			explain[REPORT_LV2] = "《実戦》\n";
			//explain[TEISATSU] += "『メテオライト』\n";
			explain[REPORT_LV2] += "\n";
			explain[REPORT_LV2] += "祖父「妖魔界のほんの入口じゃ。";
			explain[REPORT_LV2] += "地上の生物を模したものからロボットや伝説で見受けられる妖魔まで、";
			explain[REPORT_LV2] += "全く検討がつかん。妖魔に我々の常識は通じないということじゃな。心してかかれ。」\n";
			explain[REPORT_LV2] += "\n"
			explain[REPORT_LV2] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV2] += "・制限時間120秒\n";

			explain[REPORT_LV3] = "《実戦》\n";
			//explain[TEISATSU] += "『メテオライト』\n";
			explain[REPORT_LV3] += "\n";
			explain[REPORT_LV3] += "祖父「今回はいかにも強そうな妖魔から、かわいさで油断を誘う妖魔まで様々じゃ。";
			explain[REPORT_LV3] += "";
			explain[REPORT_LV3] += "心してかかれ。」\n";
			explain[REPORT_LV3] += "\n"
			explain[REPORT_LV3] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV3] += "・制限時間120秒\n";

			explain[REPORT_LV4] = "《実戦》\n";
			//explain[TEISATSU] += "『メテオライト』\n";
			explain[REPORT_LV4] += "\n";
			explain[REPORT_LV4] += "祖父「妖魔界もこのあたりの深度になると、鬼火弾の霊力が高まっている。";
			explain[REPORT_LV4] += "威力はあまり変わっていないようじゃが、何があるか分からん。";
			explain[REPORT_LV4] += "心してかかれ。」\n";
			explain[REPORT_LV4] += "\n"
			explain[REPORT_LV4] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV4] += "・制限時間120秒\n";

			explain[REPORT_LV5] = "《実戦》\n";
			explain[REPORT_LV5] += "\n";
			/*
			explain[REPORT_LV5] += "祖父「透過色の設定と動きを付けること、当たった矢が動きのせいで何も無いところに刺さる状態を無くすのが良い。";
			explain[REPORT_LV5] += "それには当たり判定用の画像で工夫してみよう、惜しい、とのお告げが神社であったのじゃが。わしには意味がわからん。";
			*/
			explain[REPORT_LV5] += "祖父「深度が深くなってきた。妖魔も警戒を始めたな。";
			explain[REPORT_LV5] += "この深度からは全ての妖魔を倒さんと先には進ませないようじゃ。";
			explain[REPORT_LV5] += "心してかかれ。」\n";
			explain[REPORT_LV5] += "\n"
			explain[REPORT_LV5] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV5] += "・制限時間120秒\n";

			explain[REPORT_LV6] = "《実戦》\n";
			//explain[TEISATSU] += "『メテオライト』\n";
			explain[REPORT_LV6] += "\n";
			explain[REPORT_LV6] += "祖父「妖魔にも耐性が出来てきたようじゃ。";
			explain[REPORT_LV6] += "何度も退治されると以前より強くなることがある。";
			explain[REPORT_LV6] += "特定の妖魔を退治しすぎるのも注意じゃ。";
			explain[REPORT_LV6] += "心してかかれ。」\n";
			explain[REPORT_LV6] += "\n"
			explain[REPORT_LV6] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV6] += "・制限時間120秒\n";

			explain[REPORT_LV7] = "《実戦》\n";
			//explain[TEISATSU] += "『メテオライト』\n";
			explain[REPORT_LV7] += "\n";
			explain[REPORT_LV7] += "祖父「";
			explain[REPORT_LV7] += "今回も多種多様な妖魔が報告されている。鬼火弾の形状が変化しているとの報告もある。";
			explain[REPORT_LV7] += "心してかかれ。」\n";
			explain[REPORT_LV7] += "\n"
			explain[REPORT_LV7] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV7] += "・制限時間120秒\n";

			explain[REPORT_LV8] = "《実戦》\n";
			//explain[TEISATSU] += "『メテオライト』\n";
			explain[REPORT_LV8] += "\n";
			explain[REPORT_LV8] += "祖父「";
			explain[REPORT_LV8] += "今回も多種多様な妖魔が報告された。";
			explain[REPORT_LV8] += "心してかかれ。」\n";
			explain[REPORT_LV8] += "\n"
			explain[REPORT_LV8] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV8] += "・制限時間120秒\n";

			explain[ROSE] = "《実戦》\n";
			explain[ROSE] += "『ローズ』\n";
			explain[ROSE] += "\n";
			explain[ROSE] += "祖父「";
			explain[ROSE] += "妖魔界の自然といったものじゃろうか。";
			explain[ROSE] += "薔薇のような姿をした妖魔じゃ。";
			explain[ROSE] += "棘は無いが花と枝の先端から鬼火弾を発射してくる。";
			explain[ROSE] += "心してかかれ。」\n";
			explain[ROSE] += "\n"
			explain[ROSE] += "・制限時間120秒\n";

			explain[REPORT_LV9] = "《実戦》\n";
			explain[REPORT_LV9] += "\n";
			explain[REPORT_LV9] += "祖父「";
			explain[REPORT_LV9] += "今回も多種多様な妖魔が報告された。";
			explain[REPORT_LV9] += "心してかかれ。」\n";
			explain[REPORT_LV9] += "\n"
			explain[REPORT_LV9] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV9] += "・制限時間120秒\n";

			explain[CHAMAELEON] = "《実戦》\n";
			explain[CHAMAELEON] += "『カメレオン』\n";
			explain[CHAMAELEON] += "\n";
			explain[CHAMAELEON] += "祖父「";
			explain[CHAMAELEON] += "カメレオンのような姿をした妖魔じゃ。";
			explain[CHAMAELEON] += "こちらの世界のカメレオンと同じように背景に溶け込むが、この妖魔は物理的に消えるという報告もある。";
			explain[CHAMAELEON] += "心してかかれ。」\n";
			explain[CHAMAELEON] += "\n"
			explain[CHAMAELEON] += "・制限時間120秒\n";

			explain[REPORT_LV10] = "《実戦》\n";
			explain[REPORT_LV10] += "\n";
			explain[REPORT_LV10] += "祖父「";
			explain[REPORT_LV10] += "今回も多種多様な妖魔が報告された。遠距離、上空からの攻撃に注意だ。";
			explain[REPORT_LV10] += "心してかかれ。」\n";
			explain[REPORT_LV10] += "\n"
			explain[REPORT_LV10] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV10] += "・制限時間120秒\n";

			explain[TENGU] = "《実戦》\n";
			explain[TENGU] += "『天狗』\n";
			explain[TENGU] += "\n";
			explain[TENGU] += "祖父「";
			explain[TENGU] += "団扇の風が厄介な妖魔じゃ。";
			explain[TENGU] += "破魔矢もあの風にははじかれてしまうじゃろう。";
			explain[TENGU] += "心してかかれ。」\n";
			explain[TENGU] += "\n"
			explain[TENGU] += "・制限時間120秒\n";

			explain[REPORT_LV11] = "《実戦》\n";
			explain[REPORT_LV11] += "\n";
			explain[REPORT_LV11] += "祖父「";
			explain[REPORT_LV11] += "今回も多種多様な妖魔が報告された。人間の欲望を取り込んで増幅させた妖魔や、我々のまねをする妖魔、矢をはじく妖魔がいるようじゃ。";
			explain[REPORT_LV11] += "心してかかれ。」\n";
			explain[REPORT_LV11] += "\n"
			explain[REPORT_LV11] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV11] += "・制限時間120秒\n";

			explain[REPORT_LV12] = "《実戦》\n";
			explain[REPORT_LV12] += "\n";
			explain[REPORT_LV12] += "祖父「";
			explain[REPORT_LV12] += "今回も多種多様な妖魔が報告された。気合の入った妖魔や、こちらの情報を掴んでいるのか否か、挨拶にきた妖魔などさまざまじゃ。";
			explain[REPORT_LV12] += "心してかかれ。」\n";
			explain[REPORT_LV12] += "\n"
			explain[REPORT_LV12] += "・報告書の妖魔を退治しよう。\n";
			explain[REPORT_LV12] += "・制限時間120秒\n";

			explain[GARUDA] = "《実戦》\n";
			explain[GARUDA] += "『ガルダ』\n";
			explain[GARUDA] += "\n";
			explain[GARUDA] += "ジェシー「";
			explain[GARUDA] += "どうやら我々はガルダ族とナーガ族の争いに巻き込まれたようだ。";
			explain[GARUDA] += "ガルダを討伐したら撤退せよとの命令が来ている。妖魔界の入口を封じる準備は完了した。";
			explain[GARUDA] += "これで妖魔との戦いも落ち着くだろう。」\n";
			explain[GARUDA] += "\n"
			explain[GARUDA] += "・制限時間120秒\n";

//explain[scenarioNo[scenarioNo.length-1]] += "\n※本バージョンではここまでです。";

/*
			for (i = 0; i < scenarioNo.length; i++)
			{
				scenarioClear[scenarioNo[i]] = true;//false;
			}
			//scenarioClear[KYUDO] = false;
*/
		}
		
		public function getBattleTypeName(no:int):String
		{
			var str:String = explain[no].split("\n")[0];
			return str;
		}

		public function getCount():int
		{
			return scenarioNo.length;
		}

		public function getNo(idx:int):int
		{
			if (scenarioNo.length <= idx)
			{
				return -1;
			}
			return scenarioNo[idx];
		}

		public function getName(idx:int):String
		{
			return scenarioName[scenarioNo[idx]];
		}
		
		public function getExplain(sidx:int):String
		{
			//return explain[scenarioNo[idx]];
			
			var midx:int = -1;
			var msg:String = explain[scenarioNo[sidx]];
			//if (Global.isEquipNoroi())
			if (Global.isEquipNoroi() || (0 < Global.dailyQuestNo))
			{
				midx = msg.indexOf("《実戦》");
				if (0 <= midx)
				{
					midx = msg.indexOf("』");
					
					//--------
					//報告書用
					if (midx < 0)
					{
						midx = msg.indexOf("》") + 1;
					}
					//--------
					
					msg = msg.substr(0, midx) + "[呪]" + msg.substr(midx);
				}
			}
			//--------
			else if (Global.yumiSettingGamen.isNoroi2())
			{
				midx = msg.indexOf("《実戦》");
				if (0 <= midx)
				{
					midx = msg.indexOf("』");
					
					//--------
					//報告書用
					if (midx < 0)
					{
						midx = msg.indexOf("》") + 1;
					}
					//--------
					
					msg = msg.substr(0, midx) + "[呪×呪]" + msg.substr(midx);
				}
			}
			//--------
			
			//--------
			//日刊稲荷依頼
			if (0 < Global.dailyQuestNo)
			{
				midx = msg.indexOf("《実戦》");
				if (0 <= midx)
				{
					msg = msg.substr(0, midx) + "【日刊稲荷依頼】" + msg.substr(midx);
				}
			}
			//--------
			
			return msg;
		}
/*
		public function isClear(idx:int):Boolean
		{
			return scenarioClear[scenarioNo[idx]];
		}

		public function clearStage()
		{
			scenarioClear[no] = true;
		}
*/
		public function clearStage():void
		{
			var i:int;

			for (i = 0; i < scenarioNo.length; i++)
			{
				if (no == scenarioNo[i])
				{
					if (lastClearIndex < i)
					{
						lastClearIndex = i;
trace("###" + i);
					}
					break;
				}
			}
		}
		
		//これstaticでよくない？
		public function getStageIdx(_no:int):int
		{
			var i:int;
			for (i = 0; i < scenarioNo.length; i++)
			{
				if (_no == scenarioNo[i])
				{
					return i;
				}
			}
			return -1;
		}
		/*
		public function getExp()
		{
			return exp[no];
		}
		*/

		public static function clearScenerioName():void
		{
			Scenario.scenarioName[Scenario.REPORT_LV1] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV2] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV3] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV4] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV5] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV6] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV7] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV8] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV9] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV10] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV11] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV12] = "--未選択--";
		}

		// ----------------
		// isClearStage
		// ----------------
		public static function isClear(scenarioNo:int):Boolean
		{
			var ret:Boolean = false;

			//if (Scenario.REPORT_LV5 <= scenarioNo)
			if ((Scenario.REPORT_LV5 <= scenarioNo) && (Global.scenario.isReportStageFromNo(scenarioNo)))
			{
				var reportLv:Dictionary = new Dictionary();
				reportLv[Scenario.REPORT_LV5] = 5;
				reportLv[Scenario.REPORT_LV6] = 6;
				reportLv[Scenario.REPORT_LV7] = 7;
				reportLv[Scenario.REPORT_LV8] = 8;
				reportLv[Scenario.REPORT_LV9] = 9;
				reportLv[Scenario.REPORT_LV10] = 10;
				reportLv[Scenario.REPORT_LV11] = 11;
				reportLv[Scenario.REPORT_LV12] = 12;
				ret = isClearShindo(reportLv[scenarioNo]);
			}
			else
			{
				if (Global.scenario.getStageIdx(scenarioNo) <= Global.scenario.lastClearIndex)
				{
					ret = true;
				}
			}
			
			return ret;
		}
		// ----------------
		// isClearShindo
		// ----------------
		private static function isClearShindo(reportLv:int):Boolean
		{
			//報告書Lv6からは全て退治で次表示
			//(報告書Lv5 = 深度5 = stage4)
			var i:int;
			var k:int;
			var lvXStageCnt:int = 0;
			var clearCnt:int = 0;
			for (i = 0; i < Global.reportTbl.getCount(); i++ )
			{
				if ((reportLv - 1) == int(Global.reportTbl.getData(i, "STAGE")))
				{
					lvXStageCnt++;
					
					//--------
					//NGはクリア済みとする
					if (Global.reportTbl.getData(i, "NG") != "0")
					{
						clearCnt++;
						continue;
					}
					//--------
					
					for (k = 0; k < Global.silhouetteTbl.getCount(); k++ )
					{
						if (i == int(Global.silhouetteTbl.getData(k, "PAGENO")))
						{
							clearCnt++;
						}
					}
				}
			}
			
			if (lvXStageCnt == 0)
			{
				return false;
			}
			
			return (lvXStageCnt == clearCnt);
		}

	}

}