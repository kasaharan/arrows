package 
{
	import net.user1.reactor.snapshot.RoomSnapshot;
	import net.user1.reactor.snapshot.SnapshotEvent;
	import net.user1.reactor.UpdateLevels;
	import starling.core.Starling;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.events.TouchEvent;
	import flash.net.URLRequest;
	import flash.net.SharedObject;
	import net.user1.reactor.Room;
	import net.user1.reactor.Client;
	import flash.utils.ByteArray;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.utils.Dictionary;

	public class Global
	{
		public static var rootRoomName:String = "";

		public static const BUTTON_NORMAL_COLOR:int = 0x744199;
		public static const BUTTON_SELECT_COLOR:int = 0x9d73bb;
		public static const SELECTED_BORDER_COLOR:int = 0xEDAD0B;

		//--------
		public static var scenario:Scenario;
		public static var username:String = "";
		public static var pwd:String = "";
		public static var equipIdx:Vector.<int> = new Vector.<int>;
		public static var monster:Vector.<Monster>;
		public static var magatamaID:String = "";
		public static var stageNoroiValue:String = "0";	//"0":呪いなし
		public static var loginInfo:String = "";	//多重ログイン禁止用情報
		public static var expup:int = 0;			//勾玉変換しても霊力もらえる技用
		public static var dochoFlag:int = 0;		//勾玉経験値用
		public static var selectedCoopName:String = "";	//協力戦選択用
		public static var dailyReward:int = 0;			//日刊報酬用
		
		public static var isMake:Boolean = false;	//報告書作成可否フラグ
		
		public static var dailyQuestNo:int = 0;	//0:normal 1~日刊クエスト
		
		public static var favoriteData:String = "";
		
		public static var selectGamen:SelectGamen;
		public static var waitGamen:WaitGamen;
		public static var reportGamen:ReportGamen;
		public static var mixGamen:MixGamen;
		public static var itemGamen:ItemGamen;
		public static var yumishiGamen:YumishiGamen;
		public static var chatGamen:ChatGamen;
		public static var yumiSettingGamen:YumiSettingGamen;
		public static var makeGamen:MakeGamen;
		public static var soundSettingGamen:SoundSettingGamen;
		
		//--------
		public static var rnd:RandomMT = new RandomMT();
			
		//--------
		public static var usvr:UnionServer2;
		//public static var usvrChat:UnionServerChat;
		
		public static var my_so:SharedObject;
		public static function init()
		{
			//SOロード
			try
			{
				my_so = SharedObject.getLocal("arrows", "http://kasaharan.com/game/arrows/");
			}
			catch (e:Error) { }
		}
		
		//--------
		/*
		public static const LEVEL_NORMAL:int = 0;
		public static const LEVEL_HARD:int = 1;
		public static const LEVEL_NIGHTMARE:int = 2;
		public static const LEVEL_HELL:int = 3;
		public static var level:int = LEVEL_NORMAL;
		*/

		//--------
		public static var FPS:int = Starling.current.nativeStage.frameRate;
		public static var halfFPS:int = Starling.current.nativeStage.frameRate / 2;
		public static var FPSx5:int = FPS * 5;
		public static var FPSx7:int = FPS * 7;
		public static var FPSx10:int = FPS * 10;
		//public static var FPSx20:int = FPS * 20;
		//public static var FPSx30:int = FPS * 30;
		public static var halfPI:Number = Math.PI / 2;
		
		//--------
		//public static const USER_TABLE:String = "NAME,SCENARIO,EXP,RELEASE,ITEMNO,ITEMCNT";
		public static const USER_TABLE:String = "NAME,SCENARIO,EXP,RELEASE,ITEMNO,ITEMCNT,RELEASE_LV,MIX_LV";
		//public static const ITEM_TABLE:String = "NAME,ID,COUNT1,KIND1,VALUE1,COUNT2,KIND2,VALUE2,COUNT3,KIND3,VALUE3";
		public static const ITEM_TABLE:String = "NAME,ID,COUNT1,KIND1,VALUE1,COUNT2,KIND2,VALUE2,COUNT3,KIND3,VALUE3,MIX,EXP,LEVEL";
		public static const EQUIP_TABLE:String = "NAME,COUNT,ID";
		public static const SHOP_TABLE:String = "ITEMNO,PRICE,NAME";
		public static const REPORT_TABLE:String   = "NAME,STAGE,TYPE,ATTACK,TITLE,MANAGE,IMG1,IMG2,IMG3,IMG4,IMG5,NG,HP";
		public static const MYREPORT_TABLE:String = "NAME,TYPE,ATTACK,TITLE,MANAGE,IMG1,IMG2,IMG3,IMG4,IMG5";
		public static const SILHOUETTE_TABLE:String = "NAME,PAGENO";
		public static const TOBATSU_TABLE:String = "SCENARIO,PAGENO,CNT";
		public static const YUMISHI_TABLE:String = "ID,NAME,LEVEL,PRICE,NEEDID";
		public static const USERYUMI_TABLE:String = "ID,NAME,ONOFF,ENABLE";
		public static const QUEST_TABLE:String = "NO,SEED,CLEAR,GET";
		public static const FRIEND_MSG_TABLE:String = "NAME,FRIEND,DATE,MSG";
		public static const FRIEND_TABLE:String = "FLAG,FRIEND,DATE,LOGIN";
		public static const FRIEND_NEWS_TABLE:String = "MSG,RCV";
		public static const NOROI2CLEAR_TABLE:String = "IDX";

		public static var userTbl:Table = new Table(USER_TABLE, "", false);
		public static var itemTbl:Table = new Table(ITEM_TABLE, "", true);
		public static var equipTbl:Table = new Table(EQUIP_TABLE, "", false);
		//public static const shopTbl:Table = new Table(SHOP_TABLE, "0,3,女性服（赤）|1,3,男性服（赤）|2,3,女性服（青）|3,3,男性服（青）|4,3,女性服（緑）|5,3,男性服（緑）|6,3,女性服（黄）|7,3,男性服（黄）|8,3,巫|9,3,覡|10,100,勾玉整頓術|11,100,勾玉解放術|12,1000,勾玉合成道具+1|13,3000,勾玉合成道具+2|14,3,巫と年越し蕎麦", false);
		
		public static var shopNormalTbl:Table = new Table(SHOP_TABLE, "0,3,女性服（赤）|1,3,男性服（赤）|2,3,女性服（青）|3,3,男性服（青）|4,3,女性服（緑）|5,3,男性服（緑）|6,3,女性服（黄）|7,3,男性服（黄）|8,3,巫|9,3,覡|10,100,勾玉整頓術|11,100,勾玉解放術|12,1000,勾玉合成道具+1|13,3000,勾玉合成道具+2|15,10,河童装束|16,10,熊装束|17,10,忍装束", false);
		public static var shop1231Tbl:Table = new Table(SHOP_TABLE, "0,3,女性服（赤）|1,3,男性服（赤）|2,3,女性服（青）|3,3,男性服（青）|4,3,女性服（緑）|5,3,男性服（緑）|6,3,女性服（黄）|7,3,男性服（黄）|8,3,巫|9,3,覡|10,100,勾玉整頓術|11,100,勾玉解放術|12,1000,勾玉合成道具+1|13,3000,勾玉合成道具+2|14,3,巫と年越し蕎麦|15,10,河童装束|16,10,熊装束|17,10,忍装束", false);
		public static var shopTbl:Table = shopNormalTbl;
		
		public static var reportTbl:Table = new Table(REPORT_TABLE, "", false);
		public static var myReportTbl:Table = new Table(MYREPORT_TABLE, "", false);
		public static var silhouetteTbl:Table = new Table(SILHOUETTE_TABLE, "", false);
		public static var tobatsuTbl:Table = new Table(TOBATSU_TABLE, "", false);
		//public static const yumiTbl:Table = new Table(YUMI_TABLE, "EXP5,20,100,勾玉変換+1|EXP10,30,300,勾玉変換+2|EXP15,40,600,勾玉変換+3|EXP20,50,1000,勾玉変換+4|EXP25,60,3000,勾玉変換+5|HP,30,1000,体力表示|YUMI2,50,2000,二人張り|YUMI3,60,3000,三人張り|NOROI,30,1000,呪い|", false);
		public static var yumishiTbl:Table = new Table(YUMISHI_TABLE, "", false);
		public static var useryumiTbl:Table = new Table(USERYUMI_TABLE, "", false);
		public static var questTbl:Table = new Table(QUEST_TABLE, "", false);
		public static var friendMsgTbl:Table = new Table(FRIEND_MSG_TABLE, "", false);
		public static var friendTbl:Table = new Table(FRIEND_TABLE, "", false);
		public static var friendNewsTbl:Table = new Table(FRIEND_NEWS_TABLE, "", false);
		public static var noroi2ClearTbl:Table = new Table(NOROI2CLEAR_TABLE, "", false);
		
		//Sound
		//public static var volume:Number = 0.0;//1.0;
		public static var volumeBGM:Number = 0.0;//1.0;
		public static var volumeSE:Number = 0.0;//1.0;
		private static var soundTransform:SoundTransform = new SoundTransform(1.0);
		private static var soundChannelGa1:SoundChannel;
		private static var soundChannelGa2:SoundChannel;
		private static var soundChannelGa3:SoundChannel;

		public static var soundGigigi:Sound = new SoundGigigi();
		public static var soundShu:Sound = new SoundShu();
		public static var soundGa1:Sound = new SoundGa();
		public static var soundGa2:Sound = new SoundGa();
		public static var soundGa3:Sound = new SoundGa();
		public static var soundKuzureru:Sound = new SoundKuzureru();
		public static var soundDamage:Sound = new SoundDamage();
		public static var soundTodome:Sound = new SoundTodome();
		public static var soundNoDamage:Sound = new SoundNoDamage();
		public static var soundClear:Sound = new SoundClear();
		public static var soundTekiShoot:Sound = new SoundTekiShoot();
		public static var soundTame2:Sound = new SoundTame2();
		public static var soundEntry:Sound = new SoundEntry();
		public static var soundFire:Sound = new SoundFire();
		public static var soundKoori:Sound = new SoundKoori();
		
		public static var st:SoundTransform = new SoundTransform();

		public static function initSound()
		{
		/*
			st.volume = 0.0;
			soundChannelGa1 = soundGa1.play(0, 0, st);
			soundChannelGa2 = soundGa2.play(0, 0, st);
			soundChannelGa3 = soundGa3.play(0, 0, st);
			
			loadBGM();
		*/
		}

		//static init
		{
			st.volume = 0.0;
			soundChannelGa1 = soundGa1.play(0, 0, st);
			soundChannelGa2 = soundGa2.play(0, 0, st);
			soundChannelGa3 = soundGa3.play(0, 0, st);
			
			loadBGM();
		}

		//--------
		private static var soundBGM01:Sound = new Sound();
		private static var soundBGM02:Sound = new Sound();
		private static var soundBGM:Sound = soundBGM01;
		private static var soundChannelBGM:SoundChannel;
		private static function loadBGM()
		{
			//BGMロード
			var request:URLRequest = new URLRequest(Connect.getUrl() + "bgm/game_maoudamashii_6_dangeon21_.mp3");
			soundBGM01.load(request);
			var request:URLRequest = new URLRequest(Connect.getUrl() + "bgm/game_maoudamashii_1_battle27_.mp3");
			soundBGM02.load(request);
		}
		private static var playBGMCount:int = 0;
		public static function playBGM()
		{
			//一応、多重再生対策
			stopBGM();
			st.volume = 0.3 * volumeBGM;
			soundChannelBGM = soundBGM.play(0, playBGMCount, st);
		}
		public static function stopBGM()
		{
			if (soundChannelBGM != null)
			{
				soundChannelBGM.stop();
			}
		}
		public static function setBGMNo(no:int)
		{
			if (no == 1)
			{
				soundBGM = soundBGM01;
				playBGMCount = 9999;
			}
			else if (no == 2)
			{
				soundBGM = soundBGM02;
				playBGMCount = 1;
			}
		}
		//--------

		public static function playGigigi()
		{
			st.volume = 1.0 * volumeSE;
			soundGigigi.play(0, 0, st);
		}
		public static function playShu()
		{
			st.volume = 0.3 * volumeSE;
			soundShu.play(0, 0, st);
		}
		public static function playGa()
		{
/*
			if (soundGa1.length <= soundChannelGa1.position)
			{
				st.volume = 0.2 * volume;
				soundChannelGa1 = soundGa1.play(0, 0, st);
			}
			else if (soundGa2.length <= soundChannelGa2.position)
			{
				st.volume = 0.2 * volume;
				soundChannelGa2 = soundGa2.play(0, 0, st);
			}
			else if (soundGa3.length <= soundChannelGa3.position)
			{
				st.volume = 0.2 * volume;
				soundChannelGa3 = soundGa3.play(0, 0, st);
			}
			*/
			//20140713現象：氷の音を先に発生させてからヒット音を再生しようとするとsoundChannelGa1がnullになっている。
			//チャンネル数の限界に達して解放される？
			//→nullチェックを追加、かつ念のためtry-catchいれとく
			try
			{
				if (soundChannelGa1 == null)
				{
					st.volume = 0.2 * volumeSE;
					soundChannelGa1 = soundGa1.play(0, 0, st);
				}
				else if (soundGa1.length <= soundChannelGa1.position)
				{
					st.volume = 0.2 * volumeSE;
					soundChannelGa1 = soundGa1.play(0, 0, st);
				}
				//--------
				else if (soundChannelGa2 == null)
				{
					st.volume = 0.2 * volumeSE;
					soundChannelGa2 = soundGa2.play(0, 0, st);
				}
				else if (soundGa2.length <= soundChannelGa2.position)
				{
					st.volume = 0.2 * volumeSE;
					soundChannelGa2 = soundGa2.play(0, 0, st);
				}
				//--------
				else if (soundChannelGa3 == null)
				{
					st.volume = 0.2 * volumeSE;
					soundChannelGa3 = soundGa3.play(0, 0, st);
				}
				else if (soundGa3.length <= soundChannelGa3.position)
				{
					st.volume = 0.2 * volumeSE;
					soundChannelGa3 = soundGa3.play(0, 0, st);
				}
			}
			catch(e:Error){}
		}
		public static function playKuzureru()
		{
			st.volume = 1.0 * volumeSE;
			soundKuzureru.play(0, 0, st);
		}
		public static function playDamage()
		{
			st.volume = 0.2 * volumeSE;
			soundDamage.play(0, 0, st);
		}
		public static function playTodome()
		{
			st.volume = 0.3 * volumeSE;
			soundTodome.play(0, 0, st);
		}
		public static function playNoDamage()
		{
			st.volume = 0.2 * volumeSE;
			soundNoDamage.play(0, 0, st);
		}
		public static function playClear()
		{
			st.volume = 0.3 * volumeSE;
			soundClear.play(0, 0, st);
		}
		public static function playTekiShoot()
		{
			st.volume = 0.2 * volumeSE;
			soundTekiShoot.play(0, 0, st);
		}
		public static function playTame2()
		{
			st.volume = 0.2 * volumeSE;
			soundTame2.play(0, 0, st);
		}
		public static function playEntry()
		{
			st.volume = 0.4 * volumeSE;
			soundEntry.play(0, 0, st);
		}
		public static function playFire()
		{
			st.volume = 0.2 * volumeSE;
			soundFire.play(0, 0, st);
		}
		public static function playKoori()
		{
			st.volume = 0.01 * volumeSE;
			soundKoori.play(0, 0, st);
		}

		//--------
		public function Global()
		{
			// constructor code
		}

		public static function getLocalTime()
		{
			var my_date = new Date();
			var str = my_date.getFullYear() + ("00" + (my_date.getMonth() + 1)).substr(-2, 2) + ("00" + my_date.getDate()).substr(-2, 2);
			str += ("00" + my_date.getHours()).substr(-2, 2) + ("00" + my_date.getMinutes()).substr(-2, 2) + ("00" + my_date.getSeconds()).substr(-2, 2);
			return str;
		}

		public static function getHHMISS()
		{
			var my_date = new Date();
			var str = ("00" + my_date.getHours()).substr(-2, 2) + ("00" + my_date.getMinutes()).substr(-2, 2) + ("00" + my_date.getSeconds()).substr(-2, 2);
			return str;
		}

		public static function trim(str:String):String
		{
			while (str.charAt(0) == " ")
			{
				str=str.substring(1, str.length);
			}
			while (str.charAt(str.length-1) == " ")
			{
				str=str.substring(0, str.length-1);
			}
			while (str.charAt(0) == "　")
			{
				str=str.substring(1, str.length);
			}
			while (str.charAt(str.length-1) == "　")
			{
				str=str.substring(0, str.length-1);
			}
			return str;
		}

		/**
		 * 左詰め
		 * 半角全角混在スペース埋め(ketaは半角幅)
		 * @param	str
		 * @param	keta
		 */
		static public function leftStr(str:String, keta:int, moji:String = " "):String
		{
			var i:int = 0;
			var ret:String = str;
			var cnt:int = 0;
			var len:int = str.length;
			for (i = 0; i < len; i++)
			{			
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeMultiByte(str.substr(i, 1), "shift-jis");
				if ( 2 <= byteArray.length)
				{
					cnt += 2;
				}
				else
				{
					cnt++;
				}
			}

			for (i = cnt; i < keta; i++)
			{
				//ret += " ";
				ret += moji;
			}
			return ret;
		}

		/**
		 * 右詰め
		 * 半角全角混在スペース埋め(ketaは半角幅)
		 * @param	str
		 * @param	keta
		 */
		public static function rightStr(str:String, keta:int, moji:String = " "):String
		{
			var i:int = 0;
			var ret:String = str;
			var cnt:int = 0;
			var len:int = str.length;
			for (i = 0; i < len; i++)
			{				
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeMultiByte(str.substr(i, 1), "shift-jis");
				if ( 2 <= byteArray.length)
				{
					cnt += 2;
				}
				else
				{
					cnt++;
				}
			}

			for (i = cnt; i < keta; i++)
			{
				//ret = " " +ret;
				ret = moji + ret;
			}

			return ret;
		}

		/* **************************************************************** */
		// mycompress 文字列圧縮
		/* **************************************************************** */
		static public function myCompress(rawStr:String):String
		{
			var b:ByteArray = new ByteArray();
			for (var i = 0; i < rawStr.length; i++)
			{
				b[i] = rawStr.charCodeAt(i);
				//trace(b[i]);
			}
			b.compress();

			var str:String = "";
			b.position = 0;
			for (i = 0; i < b.length; i++)
			{
				str += ("00" + (b.readByte() & 0xff).toString(16)).substr(-2);
			}
			
			return str;
		}
		/* **************************************************************** */
		// myuncompress　文字列解凍
		/* **************************************************************** */
		static public function myUncompress(compressedStr:String):String
		{
			var b:ByteArray = new ByteArray();
			var len:int = compressedStr.length / 2;
			for (var i = 0; i < len; i++)
			{
				b[i] = parseInt("0x" + compressedStr.substr(2*i, 2));
				//trace(b[i]);
			}
			b.uncompress();
			
			return b.toString();
		}

		// ----------------
		// enabledIME
		// ----------------
		public static function enabledIME(bool:Boolean)
		{
			if (Capabilities.hasIME)
			{
				try
				{
					IME.enabled = bool;
				}
				catch(e:Error){}
			}
		}

		// ----------------
		//
		// ----------------
		static public function existCtrlMoji(str:String):Boolean
		{
			var i:int;
			for (i = 0; i < str.length; i++)
			{
				if (str.charCodeAt(i) < 0x20)
				{
					return true;
				}
			}
			return false;
		}
		static public function existArashiMoji(str:String):Boolean
		{
			var i:int;
			for (i = 0; i < str.length; i++)
			{
				if (str.charCodeAt(i) == 0xbcc)
				{
					return true;
				}
				if (str.charCodeAt(i) == 0x202E)	//RLO
				{
					return true;
				}
			}
			return false;
		}

		// ----------------
		// 2013/10/06 使用可能文字を制限する
		// ----------------
		static private const okMoji:String = "";
		//static public function checkMoji(str:String):String
		static public function isUseMojiOK(str:String):Boolean
		{
			var i:int;
			var retStr:String = "";
			for (i = 0; i < str.length; i++)
			{
				var c:int = str.charCodeAt(i);
				if ((0x20 <= c) && (c <= 0x7f))
				{
					//基本ラテン
					retStr += String.fromCharCode(c);
				}
				else if ((0x3000 <= c) && (c <= 0x309F))
				{
					//ひらがな
					retStr += String.fromCharCode(c);
				}
				else if ((0x30A0 <= c) && (c <= 0x30FF))
				{
					//カタカナ
					retStr += String.fromCharCode(c);
				}
				else if ((0x4E00 <= c) && (c <= 0x9FFF))
				{
					//CJK統合漢字
					retStr += String.fromCharCode(c);
				}
				else if ((0xFF00 <= c) && (c <= 0xFFEF))
				{
					//半角カタカナ、全角アルファベット
					retStr += String.fromCharCode(c);
				}
				else if ((0x0370 <= c) && (c <= 0x03FF))
				{
					//ギリシャ文字1
					retStr += String.fromCharCode(c);
				}
				else if ((0x1F00 <= c) && (c <= 0x1FFF))
				{
					//ギリシャ文字2
					retStr += String.fromCharCode(c);
				}
				else if ((0x2010 <= c) && (c <= 0x2027))
				{
					//…とか※とか’とか(1)
					retStr += String.fromCharCode(c);
				}
				else if ((0x2030 <= c) && (c <= 0x204F))
				{
					//…とか※とか’とか(2)
					retStr += String.fromCharCode(c);
				}
				else if ((0x20A0 <= c) && (c <= 0x20CF))
				{
					//通貨記号
					retStr += String.fromCharCode(c);
				}
				else if ((0x2150 <= c) && (c <= 0x218F))
				{
					//数字に準じるもの
					retStr += String.fromCharCode(c);
				}
				else if ((0x2190 <= c) && (c <= 0x21FF))
				{
					//矢印
					retStr += String.fromCharCode(c);
				}
				else if ((0x2200 <= c) && (c <= 0x22FF))
				{
					//数学記号
					retStr += String.fromCharCode(c);
				}
				else if ((0x2460 <= c) && (c <= 0x24FF))
				{
					//囲み英数字
					retStr += String.fromCharCode(c);
				}
				else if ((0x25A0 <= c) && (c <= 0x25EF))
				{
					//幾何学模様
					retStr += String.fromCharCode(c);
				}
				else if ((0x2600 <= c) && (c <= 0x266F))
				{
					//その他記号
					retStr += String.fromCharCode(c);
				}
				else if ((0x0400 <= c) && (c <= 0x04FF))
				{
					//ロシア文字１
					retStr += String.fromCharCode(c);
				}
				else if ((0x0500 <= c) && (c <= 0x052F))
				{
					//ロシア文字２
					retStr += String.fromCharCode(c);
				}
				else if ((0x2500 <= c) && (c <= 0x259F))
				{
					//？
					retStr += String.fromCharCode(c);
				}
				else if (0 <= okMoji.indexOf(String.fromCharCode(c)))
				{
					//retStr += String.fromCharCode(c);
				}
				else
				{
					//NG
				}
			}
			
			//return retStr;
			return (retStr.length == str.length);
		}
		//--------

		// ----------------
		// initEquipIdx
		// ----------------
		public static function initEquipIdx()
		{
			var i:int, k:int;

			//init
			for (i = 0; i < equipIdx.length; i++)
			{
				equipIdx[i] = -1;
			}

			//setting
			for (k = 0; k < Global.itemTbl.getCount(); k++)
			{
				for (i = 0; i < Global.equipTbl.getCount(); i++)
				{
					if (Global.itemTbl.getData(k, "ID") == Global.equipTbl.getData(i, "ID"))
					{
						equipIdx[i] = k;
					}
				}
			}
		}

		// ----------------
		// isChangeEquip
		// ----------------
		public static function isChangeEquip():Boolean
		{
			var i:int, k:int;

			var cnt:int;

			for (i = 0; i < equipIdx.length; i++)
			{
				if (0 <= equipIdx[i])
				{
					for (k = 0; k < Global.equipTbl.getCount(); k++)
					{
						if (Global.equipTbl.getData(k, "ID") == Global.itemTbl.getData(equipIdx[i], "ID"))
						{
							cnt++;
						}
					}
				}
			}
			
			return (cnt != equipIdx.length);
		}

		// ----------------
		// getKindValue
		// ----------------
		public static function getKindValue():Vector.<int>
		{
			return _getKindValue(equipIdx);
		}
		// ----------------
		// getKindValueFav
		// ----------------
		public static function getKindValueFav(favIdx:Vector.<int>):Vector.<int>
		{
			return _getKindValue(favIdx);
		}
		// ----------------
		// _getKindValue
		// ----------------
		private static function _getKindValue(_idx:Vector.<int>):Vector.<int>
		{
			var i:int;
			var k:int;
			var kind1:int;
			var kind2:int;
			var kind3:int;
			var value1:int;
			var value2:int;
			var value3:int;
			var kindValue:Vector.<int> = new Vector.<int>;

			//init
			for (i = 0; i < Item.kindName.length; i++)
			{
				kindValue[i] = 0;
			}

			for (i = 0; i < Global.itemTbl.getCount(); i++)
			{
				for (k = 0; k < _idx.length; k++)
				{
					if (i == _idx[k])
					{
						kind1 = int(Global.itemTbl.getData(i, "KIND1"));
						kind2 = int(Global.itemTbl.getData(i, "KIND2"));
						kind3 = int(Global.itemTbl.getData(i, "KIND3"));
						value1 = int(Global.itemTbl.getData(i, "VALUE1"));
						value2 = int(Global.itemTbl.getData(i, "VALUE2"));
						value3 = int(Global.itemTbl.getData(i, "VALUE3"));

						kindValue[kind1] += value1;
						kindValue[kind2] += value2;
						kindValue[kind3] += value3;
					}
				}
			}
			
			return kindValue;
		}

		// ----------------
		// getWazaKind
		// ----------------
		public static function getWazaKind():int
		{
			var i:int;
			var k:int;
			var kind1:int;
			var kind2:int;
			var kind3:int;
			var wazaKind:int = -1;

			for (i = 0; i < Global.itemTbl.getCount(); i++)
			{
				for (k = 0; k < equipIdx.length; k++)
				{
					if (i == equipIdx[k])
					{
						kind1 = int(Global.itemTbl.getData(i, "KIND1"));
						kind2 = int(Global.itemTbl.getData(i, "KIND2"));
						kind3 = int(Global.itemTbl.getData(i, "KIND3"));

						if (Item.isWaza[kind1])
						{
							wazaKind = kind1;
						}
						else if (Item.isWaza[kind2])
						{
							wazaKind = kind2;
						}
						else if (Item.isWaza[kind3])
						{
							wazaKind = kind3;
						}
					}
				}
			}
			
			return wazaKind;
		}

		// ----------------
		// getWazaKyokaKind
		// ----------------
		public static function getWazaKyokaKind():int
		{
			var i:int;
			var k:int;
			var kind1:int;
			var kind2:int;
			var kind3:int;
			var kyokaKind:int = -1;

			for (i = 0; i < Global.itemTbl.getCount(); i++)
			{
				for (k = 0; k < equipIdx.length; k++)
				{
					if (i == equipIdx[k])
					{
						kind1 = int(Global.itemTbl.getData(i, "KIND1"));
						kind2 = int(Global.itemTbl.getData(i, "KIND2"));
						kind3 = int(Global.itemTbl.getData(i, "KIND3"));

						if (Item.isWazaKyoka[kind1])
						{
							kyokaKind = kind1;
						}
						else if (Item.isWazaKyoka[kind2])
						{
							kyokaKind = kind2;
						}
						else if (Item.isWazaKyoka[kind3])
						{
							kyokaKind = kind3;
						}
					}
				}
			}
			
			return kyokaKind;
		}
		
		// ----------------
		// getItemName
		// ----------------
		public static function getItemName(idx:int):String
		{
			var i:int;
			var k:int;
			var kind1:int;
			var kind2:int;
			var kind3:int;
			var value1:int;
			var value2:int;
			var value3:int;
			var mix:int;
			
			var str:String = "";

			if (Global.itemTbl.getCount() <= idx)
			{
				return "";
			}

			i = idx;

			kind1 = int(Global.itemTbl.getData(i, "KIND1"));
			kind2 = int(Global.itemTbl.getData(i, "KIND2"));
			kind3 = int(Global.itemTbl.getData(i, "KIND3"));
			value1 = int(Global.itemTbl.getData(i, "VALUE1"));
			value2 = int(Global.itemTbl.getData(i, "VALUE2"));
			value3 = int(Global.itemTbl.getData(i, "VALUE3"));
			mix = int(Global.itemTbl.getData(i, "MIX"));

			str += "勾玉(";
			if (0 < value1)
			{
				
				if (Item.isWaza[kind1])
				{
					str += Item.kindName[kind1].substr(0, 1) + "[" + Item.kindName[kind1].substr(2, 1) + "]";
				}
				else if (Item.isWazaKyoka[kind1])
				{
					str += "変[" + Item.kindName[kind1].substr(4, 1) + "]";
				}
				else if (0 <= Item.kindName[kind1].indexOf("呪"))
				{
					str += Item.kindName[kind1];
				}
				else
				{
					str += Item.kindName[kind1].substr(0, 1) + "+" + value1;
				}
			}
			if (0 < value2)
			{
				if (Item.isWaza[kind2])
				{
					str += Item.kindName[kind2].substr(0, 1) + "[" + Item.kindName[kind2].substr(2, 1) + "]";
				}
				else if (Item.isWazaKyoka[kind2])
				{
					str += "変[" + Item.kindName[kind2].substr(4, 1) + "]";
				}
				else if (0 <= Item.kindName[kind2].indexOf("呪"))
				{
					str += Item.kindName[kind2];
				}
				else
				{
					str += Item.kindName[kind2].substr(0, 1) + "+" + value2;
				}
			}
			if (0 < value3)
			{
				if (Item.isWaza[kind3])
				{
					str += Item.kindName[kind3].substr(0, 1) + "[" + Item.kindName[kind3].substr(2, 1) + "]";
				}
				else if (Item.isWazaKyoka[kind3])
				{
					str += "変[" + Item.kindName[kind3].substr(4, 1) + "]";
				}
				else if (0 <= Item.kindName[kind3].indexOf("呪"))
				{
					str += Item.kindName[kind3];
				}
				else
				{
					str += Item.kindName[kind3].substr(0, 1) + "+" + value3;
				}
			}
			str += ")";

			return str;
		}

		// ----------------
		// getItemNameDetail
		// ----------------
		public static function getItemNameDetail(idx:int):String
		{
			var i:int;
			var k:int;
			var kind1:int;
			var kind2:int;
			var kind3:int;
			var value1:int;
			var value2:int;
			var value3:int;
			var mix:int;
			var str:String = "";

			if (Global.itemTbl.getCount() <= idx)
			{
				return "";
			}

			i = idx;

			kind1 = int(Global.itemTbl.getData(i, "KIND1"));
			kind2 = int(Global.itemTbl.getData(i, "KIND2"));
			kind3 = int(Global.itemTbl.getData(i, "KIND3"));
			value1 = int(Global.itemTbl.getData(i, "VALUE1"));
			value2 = int(Global.itemTbl.getData(i, "VALUE2"));
			value3 = int(Global.itemTbl.getData(i, "VALUE3"));
			mix = int(Global.itemTbl.getData(i, "MIX"));


			//str += "勾玉(";
			if (0 < value1)
			{
				str += Item.kindName[kind1];
				if (0 <= Item.kindName[kind1].indexOf("呪"))
				{
					//
				}
				else if (Item.isWazaKyoka[kind1])
				{
					//
				}
				else if (Item.isWaza[kind1] == false)
				{
					str += "+" + value1;
				}
			}
			str += " ";
			if (0 < value2)
			{
				str += Item.kindName[kind2];
				if (0 <= Item.kindName[kind2].indexOf("呪"))
				{
					//
				}
				else if (Item.isWazaKyoka[kind2])
				{
					//
				}
				else if (Item.isWaza[kind2] == false)
				{
					str += "+" + value2;
				}
			}
			str += " ";
			if (0 < value3)
			{
				str += Item.kindName[kind3];
				if (0 <= Item.kindName[kind3].indexOf("呪"))
				{
					//
				}
				else if (Item.isWazaKyoka[kind3])
				{
					//
				}
				else if (Item.isWaza[kind3] == false)
				{
					str += "+" + value3;
				}
			}
			
			if (mix == 1)
			{
				str += " *合成済";
			}

			return str;
		}

		// ----------------
		// isEquipWaza
		// ----------------
		public static function isEquipWaza(idx:int):Boolean
		{
			var ret:Boolean = false;
			var i:int;
			var kind1:int;
			var kind2:int;
			var kind3:int;
			var value1:int;
			var value2:int;
			var value3:int;

			if (Global.itemTbl.getCount() <= idx)
			{
				return "";
			}

			i = idx;

			kind1 = int(Global.itemTbl.getData(i, "KIND1"));
			kind2 = int(Global.itemTbl.getData(i, "KIND2"));
			kind3 = int(Global.itemTbl.getData(i, "KIND3"));
			value1 = int(Global.itemTbl.getData(i, "VALUE1"));
			value2 = int(Global.itemTbl.getData(i, "VALUE2"));
			value3 = int(Global.itemTbl.getData(i, "VALUE3"));

			if (0 < value1)
			{
				if (Item.isWaza[kind1])
				{
					ret = true;
				}
			}

			if (0 < value2)
			{
				if (Item.isWaza[kind2])
				{
					ret = true;
				}
			}

			if (0 < value3)
			{
				if (Item.isWaza[kind3])
				{
					ret = true;
				}
			}

			return ret;
		}
/*
		// ----------------
		// isEquipWazaKyoka
		// ----------------
		public static function isEquipWazaKyoka(idx:int):Boolean
		{
			var ret:Boolean = false;
			var i:int;
			var kind1:int;
			var kind2:int;
			var kind3:int;
			var value1:int;
			var value2:int;
			var value3:int;

			if (Global.itemTbl.getCount() <= idx)
			{
				return "";
			}

			i = idx;

			kind1 = Global.itemTbl.getData(i, "KIND1");
			kind2 = Global.itemTbl.getData(i, "KIND2");
			kind3 = Global.itemTbl.getData(i, "KIND3");
			value1 = Global.itemTbl.getData(i, "VALUE1");
			value2 = Global.itemTbl.getData(i, "VALUE2");
			value3 = Global.itemTbl.getData(i, "VALUE3");

			if (0 < value1)
			{
				if (Item.isWazaKyoka[kind1])
				{
					ret = true;
				}
			}

			if (0 < value2)
			{
				if (Item.isWazaKyoka[kind2])
				{
					ret = true;
				}
			}

			if (0 < value3)
			{
				if (Item.isWazaKyoka[kind3])
				{
					ret = true;
				}
			}

			return ret;
		}
*/
		// ----------------
		// getMagatamaWazaKyokaKind
		// ----------------
		public static function getMagatamaWazaKyokaKind(idx:int):int
		{
			var ret:int = -1;	//-1:なし
			var i:int;
			var kind1:int;
			var kind2:int;
			var kind3:int;

			if (Global.itemTbl.getCount() <= idx)
			{
				return -1;
			}

			i = idx;

			kind1 = int(Global.itemTbl.getData(i, "KIND1"));
			kind2 = int(Global.itemTbl.getData(i, "KIND2"));
			kind3 = int(Global.itemTbl.getData(i, "KIND3"));

			if (Item.isWazaKyoka[kind1])
			{
				ret = kind1;
			}

			if (Item.isWazaKyoka[kind2])
			{
				ret = kind2;
			}

			if (Item.isWazaKyoka[kind3])
			{
				ret = kind3;
			}

			return ret;
		}
		
		// ----------------
		// isEquipNoroi
		// ----------------
		public static function isEquipNoroi(isMagatamaOnly:Boolean = false):Boolean
		{
			var i:int;
			var bool:Boolean = false;

			var kindValue:Vector.<int> = Global.getKindValue();
			var noroiMsg:String = "";

			for (i = 1; i < Item.kindName.length; i++)
			{
				if (0 < kindValue[i])
				{
					if (0 <= Item.kindName[i].indexOf("呪"))
					{
						bool = true;
						break;
					}
				}
			}
			
			//--------
			if (isMagatamaOnly == false)
			{
				for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
				{
					if (Global.useryumiTbl.getData(i, "ID") == "NOROI")
					{
						if (Global.useryumiTbl.getData(i, "ENABLE") == "1")
						{
							bool = true;
							break;
						}
					}
				}
			}
			//--------
			
			return bool;
		}
		
		// ----------------
		// isNoroiMagatama
		// ----------------
		public static function isNoroiMagatama(_selectedIdx:int):Boolean
		{
			var ret:Boolean = false;
			var i:int;
			var kind1:int;
			var kind2:int;
			var kind3:int;

			kind1 = int(Global.itemTbl.getData(_selectedIdx, "KIND1"));
			kind2 = int(Global.itemTbl.getData(_selectedIdx, "KIND2"));
			kind3 = int(Global.itemTbl.getData(_selectedIdx, "KIND3"));
			
			var tmp:Vector.<int> = Vector.<int>([kind1, kind2, kind3]);
			
			for (i = 0; i < tmp.length; i++ )
			{
				if (tmp[i] == Item.KIND_IDX_NOROI)
				{
					ret = true;
					break;
				}
			}
			
			return ret;
		}

		// ----------------
		// getItemName
		// ----------------
		public static function getItemNameByID(ID:String)
		{
			var i:int;
			var str:String = "";

			for (i = 0; i < Global.itemTbl.getCount(); i++)
			{
				if (ID == Global.itemTbl.getData(i, "ID"))
				{
					str = getItemName(i);
					
					break;
				}
			}

			return str;
		}

		// ----------------
		// checkLogined
		// ログイン済みチェック
		// ----------------
		public static function checkLogined(_room:Room, username:String):Boolean
		{
			var ret:Boolean = false;

			try
			{
				var client:Client;
				var clients:Array = _room.getOccupants();
				var i:int;
				for (i = 0; i < clients.length; i++)
				{
					client = clients[i];
					
					if (client.isSelf())
					{
						continue;
					}
trace("checkLogined:" + client.getAttribute("username"));
					if (username == client.getAttribute("username"))
					{
						ret = true;
						break;
					}
				}
			}
			catch(e:Error){}

			return ret;
		}

		// ----------------
		// getMaxNoroi2StageIdx
		// 呪２で選択可能なステージの最大idxを返す
		// ----------------
		public static function getMaxNoroi2StageIdx():int
		{
			var i:int;
			var okMaxIdx:int = 8;	//鬼火Idx:8から開始。連続してどこまでクリアしているかチェック
			for (i = 0; i < Global.noroi2ClearTbl.getCount(); i++ )
			{
				if (okMaxIdx == int(Global.noroi2ClearTbl.getData(i, "IDX")))
				{
					okMaxIdx++;
				}
				else
				{
					break;
				}
			}
			
			return okMaxIdx;
		}
	}

}