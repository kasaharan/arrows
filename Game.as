package 
{
	import flash.display.Stage3D;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import net.user1.reactor.SynchronizationState;
	import starling.display.Sprite;
	import starling.text.TextField;
    import starling.display.Quad;
    import starling.utils.Color;
	import starling.display.Image;
	import starling.filters.BlurFilter;

	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.RenderTexture;
	import starling.core.Starling;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import flash.utils.escapeMultiByte;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import starling.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.ui.Keyboard;
	import starling.events.TouchPhase;
	import flash.geom.Point;
	import flash.display.Stage;
	import starling.utils.rad2deg;
	import starling.utils.deg2rad;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import starling.textures.TextureSmoothing;
	import starling.events.EventDispatcher;
	import starling.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import starling.utils.VAlign;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.net.URLLoader;
	import starling.display.QuadBatch;
	import flash.text.TextField;
	import starling.display.BlendMode;

	public class Game extends Sprite
	{
		public static var flashStage:Stage;
		public static var mStarling:Starling;

		[Embed(source="/img/normalArrow00.atf", mimeType="application/octet-stream")]
		public static const NormalArrowImageData:Class;
		[Embed(source="/img/arrow00.atf", mimeType="application/octet-stream")]
		public static const ArrowImageData:Class;
		[Embed(source="/img/image00.atf", mimeType="application/octet-stream")]
		public static const ImageData:Class;

		[Embed(source="/img/normalArrow00Atlas.xml", mimeType="application/octet-stream")]
		private static const NormalArrowAtlasData:Class;
		[Embed(source="/img/arrow00Atlas.xml", mimeType="application/octet-stream")]
		private static const ArrowAtlasData:Class;
		[Embed(source="/img/image00Atlas.xml", mimeType="application/octet-stream")]
		private static const AtlasData:Class;

		private var image:Vector.<Image> = new Vector.<Image>();
		private var arrowImage:Vector.<Image>;// = new Vector.<Image>();
		private var monsterImage:Vector.<Image> = new Vector.<Image>();

		private var renderTexture:RenderTexture;
		private var renderTextureFixed:RenderTexture;
		private var renderTextureJimen:RenderTexture;
		private var renderTextureHeader:RenderTexture;
		private var renderTextureYagura:RenderTexture;
		private var canvas:Image;
		private var canvasFixed:Image;
		private var canvasJimen:Image;
		private var canvasHeader:Image;
		private var canvasYagura:Image;

		private var skyQuad:Quad;
		
		private var stageTitleShowCnt:int = 0;
		private var stageTitle:starling.text.TextField = new starling.text.TextField(480, 64, "", "_等幅", 16, 0xfffefefe, true);
		
		//
		private var arrows:Vector.<Arrow> = new Vector.<Arrow>();

		//private const maxArrowCnt:int = Arrow.MAX_CNT;
		private var maxPower:Number = Arrow.MAX_POWER;
		private var addPowerValue:Number = Arrow.ADD_POWER_VALUE;
		//private var fallSpeed:Number = Arrow.FALL_SPEED;
		private var fallSpeed:Number = Arrow.FALL_SPEED;
		private var power:Number = 0.0;

		private var stageNo:int = 0;
		//private var shootArrowCnt:int = 128;
		private var shootArrowCnt:Value = new Value();
		
		private var monster:Vector.<Monster> = new Vector.<Monster>;
		private var meterQuad:Quad;
		private var meterQuad2:Quad;
		private var jimenQuad:Quad;
		private var wazaBreakQuad:Quad;

		private var scenario:Scenario = new Scenario();

		private var clearMC:MovieClip = new ClearMC();
		private var registGamen:RegistGamen;
		private var loginGamen:LoginGamen;
		private var titleGamen:TitleGamen;
		private var selectGamen:SelectGamen;
		private var makeGamen:MakeGamen;
		private var waitGamen:WaitGamen;
		private var itemGamen:ItemGamen;
		private var messageGamen:MessageGamen;
		private var joinFailedGamen:MessageGamen;
		private var messageSelectGamen:MessageSelectGamen;
		private var chatGamen:ChatGamen;
		private var reportGamen:ReportGamen;
		//private var mixGamen:MixGamen;
		
		private var nowRcvMc:NowRcvMC = new NowRcvMC();
		
		//テクスチャが別ATFだとQuadBatchも別にしないと画像が出ない（表示が壊れる）
		private var arrowQuadBatch:QuadBatch = new QuadBatch();
		private var mainQuadBatch:QuadBatch = new QuadBatch();

		//テクスチャNoからモンスターNo取得用
		private var monsterImgNo:Dictionary = new Dictionary();

		private var usvr:UnionServer2 = new UnionServer2();

		private var myArcher:Archer;
		private var archer:Vector.<Archer> = new Vector.<Archer>;
		
		//private var selectPageNo:int = 0;
		
		private var yagura:Yagura = new Yagura();
		
		private const WAIT_CLEAR_CNT:int = Global.FPS * 2.5
		private const WAIT_CLEAR_CNT_FAST:int = Global.FPS * 1.5;
		private var waitClearCnt:int = WAIT_CLEAR_CNT;
		
		//撃った矢数
		private var shotCount:int = 0;
		//当たった矢数
		//private var hitCount:int = 0;
		private var hitCount:Value = new Value();
		//与えたダメージ
		private var damageCount:Value = new Value();
		//
		private var wazaTameGauge:Value = new Value();
		//技タメ
		private var wazaMaxPower:Number = 2 * Arrow.MAX_POWER;
		
		//10倍霊弾用
		private var hitCountReidan10bai:Value = new Value();
		
		//矢倉HP壁index
		private var yaguraImgIdx:Vector.<int> = Vector.<int>
		//([143,144,145,146,147,148,149,150,151,152]);
		([143,144,145,146,147,148]);

		//================
		//送信用ダメージデータ
		private var damageData:Vector.<int> = new Vector.<int>;
		//================
		
		private var userItem:Vector.<Item> = new Vector.<Item>;
		
		private var mt:RandomMT = new RandomMT();
		
		private var makeStageFunc:Dictionary = new Dictionary();
		
		//強化花火
		private var kyokaHanabi:Vector.<KyokaHanabi> = new Vector.<KyokaHanabi>;
		private var hiya:Vector.<Hiya> = new Vector.<Hiya>;
		
		private var kooriya:Vector.<Kooriya> = new Vector.<Kooriya>;
		
		//HP表示用Quad
		private var monsterHP:Vector.<Quad> = new Vector.<Quad>;
		private var monsterHPBG:Vector.<Quad> = new Vector.<Quad>;

		//ステージ開始時に当たり判定用の画像が見える対策
		private var kakushiBmp:Bitmap = new Bitmap(new BitmapData(64, 48, false, 0x00000000));
		
		private var isShowedGarudaMesg:Boolean = true;	//何度も表示させないフラグ
		
		// ----------------
		// Game
		// ----------------
		public function Game()
		{
			var i:int;

			var imageATF:Texture = Texture.fromAtfData(new ImageData());
			var atlasXml:XML = XML(new AtlasData());

			var textureAtlas:TextureAtlas = new TextureAtlas(imageATF, atlasXml);
			var textures:Vector.<Texture> = textureAtlas.getTextures("img_");

			//--------
			var arrowImageATF:Texture = Texture.fromAtfData(new ArrowImageData());
			var arrowAtlasXml:XML = XML(new ArrowAtlasData());
			var arrowTextureAtlas:TextureAtlas = new TextureAtlas(arrowImageATF, arrowAtlasXml);
			var arrowTextures:Vector.<Texture> = arrowTextureAtlas.getTextures("img_");
			//--------
			//--------
			var normalArrowImageATF:Texture = Texture.fromAtfData(new NormalArrowImageData());
			var normalAtlasXml:XML = XML(new NormalArrowAtlasData());
			var normalArrowTextureAtlas:TextureAtlas = new TextureAtlas(normalArrowImageATF, normalAtlasXml);
			var normalArrowTextures:Vector.<Texture> = normalArrowTextureAtlas.getTextures("img_");
			//--------

			var monsterTextureNo:Vector.<int>;

			BitmapManager.init(
				 image
				,arrowImage
				,monsterImage
				,textures
				,arrowTextures
				,normalArrowTextures
				,monsterTextureNo
				,monsterImgNo
			);

			//--------
			for (i = 0; i < Monster.COUNT; i++)
			{
				monster[i] = new Monster();
				//================
				damageData[i] = 0;
				//================
				monsterHP[i] = new Quad(1, 3, 0xffff0000);
				monsterHPBG[i] = new Quad(30, 3, 0xff000000);
				monsterHP[i].visible = false;
				monsterHPBG[i].visible = false;
			}
			Global.monster = monster;

			//for (i = 0; i < maxArrowCnt; i++)
			for (i = 0; i < Arrow.maxArrowCnt; i++)
			{
				arrows[i] = new Arrow();
			}

			//for (i = 0; i < 4; i++)
			for (i = 0; i < Archer.COOP_XY.length; i++)
			{
				archer[i] = new Archer();
				archer[i].initCoop(i);
			}
			myArcher = archer[0];

			//var skyQuad:Quad = new Quad(640, 480-32, 0xff88bbff);
			skyQuad = new Quad(640, 480-32, 0xff88bbff);
//			addChild(skyQuad);
			skyQuad.setVertexColor(0, 0x007fff);
			skyQuad.setVertexColor(1, 0x007fff);

			//renderTextureFixed = new RenderTexture(640, 32);
			renderTextureFixed = new RenderTexture(320, 240);
			canvasFixed = new Image(renderTextureFixed);
//			addChild(canvasFixed);
			canvasFixed.scaleX = 2;
			canvasFixed.scaleY = 2;
			canvasFixed.smoothing = TextureSmoothing.NONE;

			renderTexture = new RenderTexture(640, 480);
			canvas = new Image(renderTexture);
			canvas.smoothing = TextureSmoothing.NONE;
//			addChild(canvas);

			//var jimenQuad:Quad = new Quad(640, 32, 0xff7f3f00);
			jimenQuad = new Quad(640, 32, 0xff7f3f00);
//			addChild(jimenQuad);
			jimenQuad.setVertexColor(0, 0x3f1f00);
			jimenQuad.setVertexColor(1, 0x3f1f00);
			jimenQuad.y = 480 - 32;

			renderTextureJimen = new RenderTexture(320, 16);
			canvasJimen = new Image(renderTextureJimen);
//			addChild(canvasJimen);
			canvasJimen.scaleX = 2;
			canvasJimen.scaleY = 2;
			canvasJimen.smoothing = TextureSmoothing.NONE;
			canvasJimen.y = 480 - 32;

			renderTextureHeader = new RenderTexture(320, 16);
			canvasHeader = new Image(renderTextureHeader);
//			addChild(canvasFixed);
			canvasHeader.scaleX = 2;
			canvasHeader.scaleY = 2;
			canvasHeader.smoothing = TextureSmoothing.NONE;

			renderTextureYagura = new RenderTexture(48*2, 64*2);
			canvasYagura = new Image(renderTextureYagura);
			//canvasYagura.scaleX = 2;
			//canvasYagura.scaleY = 2;
			canvasYagura.smoothing = TextureSmoothing.NONE;

			meterQuad = new Quad(8, 8, 0xffff8844);
			meterQuad.x = 0;
			meterQuad.y = 480 - 8;

			meterQuad2 = new Quad(8, 8, 0x81d674);
			meterQuad2.x = meterQuad.x;
			meterQuad2.y = meterQuad.y;

			//--------
			//wazaBreakQuad = new Quad(8, 8, 0x9a0079);
			//wazaBreakQuad = new Quad(8, 8, 0xc7b2de);
			wazaBreakQuad = new Quad(8, 8, 0x8858AA);
			wazaBreakQuad.x = meterQuad.x;
			wazaBreakQuad.y = meterQuad.y - 8;
			//--------
			
			//--------
			Global.scenario = scenario;

			//チャット画面
			chatGamen = new ChatGamen(new ChatMC(), clickChatClose);
			flashStage.addChild(chatGamen);
			Global.chatGamen = chatGamen;
//			chatGamen.visible = false;
			chatGamen.init()
			function clickChat(e:MouseEvent):void
			{
				//================
				//if (usvr.isReady)
				if ((usvr.isReady == true) && (usvr.reactor.isReady() == true))
				{
					selectGamen.visible = false;
//					chatGamen.visible = true;
					chatGamen.startChat();
				}
				//================
			}
			function clickChatClose(e:MouseEvent):void
			{
				selectGamen.visible = true;
//				chatGamen.visible = false;
//				chatGamen.stop();
				chatGamen.stopChat();
			}

			//ユーザ登録画面
			registGamen = new RegistGamen(new RegistMC(), clickCloseRegist, loginOKFunc);
			function clickCloseRegist(e:MouseEvent):void
			{
				registGamen.visible = false;
				selectGamen.visible = true;
				selectGamen.showStatus();
			}
			flashStage.addChild(registGamen);
			registGamen.visible = false;

			//ログイン画面
			loginGamen = new LoginGamen(new LoginMC(), clickCloseLogin, loginOKFunc);
			function clickCloseLogin(e:MouseEvent):void
			{
				loginGamen.visible = false;
				titleGamen.visible = true;
			}
			function loginOKFunc():void
			{
				registGamen.visible = false;
				loginGamen.visible = false;
				selectGamen.visible = true;
				selectGamen.showStatus();

				gotoSelect();
				
				flashStage.removeChild(titleGamen);
				flashStage.removeChild(registGamen);
				flashStage.removeChild(loginGamen);
				
				selectGamen.setName(Global.userTbl.getData(0, "NAME"));
				selectGamen.refreshPage();
				
				itemGamen.setFavData();
				
				//usvr = new UnionServer2();
				usvr.init();
				usvr.memberShoot = memberShoot;
				usvr.recieveCoopMsg = recieveCoopMsg;

				try
				{
					Global.my_so.data.username = Global.userTbl.getData(0,"NAME");
					Global.my_so.flush();
				}
				catch (e:Error){}
				
				//--------
				try
				{
					if (LocalStorage.getItem("arrows_arrowCnt") == "")
					{
						Arrow.maxArrowCnt = 192;
					}
					else
					{
						Arrow.maxArrowCnt = int(LocalStorage.getItem("arrows_arrowCnt"));
					}
				}
				catch (err:Error)
				{
					Arrow.maxArrowCnt = 192;
				}
				selectGamen.refreshPage();
				//--------
			}
			flashStage.addChild(loginGamen);
			loginGamen.visible = false;

			//アイテム画面
			itemGamen = new ItemGamen(new ItemMC(), clickCloseItem);
			flashStage.addChild(itemGamen);
			Global.itemGamen = itemGamen;
			itemGamen.visible = false;
			function clickCloseItem():void
			{
				selectGamen.visible = true;
				selectGamen.showStatus();
				selectGamen.setScenarioExplain();
				itemGamen.visible = false;
				itemGamen.close();
			}

			//待機画面
			waitGamen = new WaitGamen(new WaitMC(), clickStartCoop, clickCancelCoop);
			flashStage.addChild(waitGamen);
			Global.waitGamen = waitGamen;
			waitGamen.visible = false;
			usvr.recieveHostCancel = clickCancelWaitGamen;
			function clickStartCoop(e:MouseEvent):void
			{
				if ((usvr.isReady == true) && (usvr.reactor.isReady() == true))
				{
					usvr.shimekiriRoom();
				}
			}
			function clickCancelCoop(e:MouseEvent):void
			{				
				if ((usvr.isReady == true) && (usvr.reactor.isReady() == true))
				{					
					if (usvr.isHost())
					{
						//ホストが取り消したら全員へ募集終了
						usvr.sendMessage("HOST_CANCEL", "");
					}

					//--------
					//開始と同時に取り消すと、選択画面で選択していたものが一人で開始される。対策
					if ((usvr.isRoomFull()) || (usvr.isClose()))
					{
						//開始決定済み
						return;
					}
					//--------

					removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameWait);
					removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameJoin);
					usvr.reconnect();

					waitGamen.visible = false;
					gotoSelect();
					chatGamen.startChat();
					
					waitGamen.mc.msg_txt.text = "";
				}
			}
			function clickCancelWaitGamen():void
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameWait);
				removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameJoin);
				usvr.reconnect();

				//ホストキャンセルによる再参加
				waitGamen.mc.cancel_txt.visible = false;
				addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameResetJoin);

				waitGamen.mc.msg_txt.text = "協力戦募集者が募集を取り消しました。";
				waitGamen.mc.sync_txt.text = "";	//再接続まで文字が残るので消す
			}
			function enterFrameResetJoin(e:EnterFrameEvent):void
			{
				//ホストキャンセルによる再参加
				//================
				//if (usvr.isReady)
				if ((usvr.isReady == true) && (usvr.reactor.isReady() == true))
				{
					gotoJoin();

					waitGamen.mc.cancel_txt.visible = true;
					removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameResetJoin);
				}
				//================
			}
			
			//選択画面
			selectGamen = new SelectGamen(new SelectMC(), scenario, clickStart, clickSave, clickWaitCoop, clickItem, clickChat, clickMake);
			Global.selectGamen = selectGamen;
			flashStage.addChild(selectGamen);
			selectGamen.visible = false;
			selectGamen.refreshPage();
			function clickStart(e:MouseEvent):void
			{
				startCoop();
			}
			function clickSave(e:MouseEvent):void
			{
				selectGamen.visible = false;
				registGamen.visible = true;
				registGamen.setInitFocus(flashStage);
			}
			function clickWaitCoop(e:MouseEvent):void
			{
				waitGamen.setMemberText("");

				//--------
				Global.dailyQuestNo = 0;	//日刊クエストクリア
				//--------

				//================
				//if (usvr.isReady)
				if ((usvr.isReady == true) && (usvr.reactor.isReady() == true))
				{
					gotoJoin();
				}
				//================
			}
			function clickItem(e:MouseEvent):void
			{
				selectGamen.visible = false;
				itemGamen.visible = true;
				itemGamen.show();
			}
			function clickMake(e:MouseEvent):void
			{
				selectGamen.visible = false;
				//makeGamen.show();
				reportGamen.show();
				
				//--------
				Global.dailyQuestNo = 0;	//日刊クエストクリア
				//--------
			}

			//報告書トップページ
			reportGamen = new ReportGamen(new ReportMC(), clickMakeReport, clickDecideReport, clickCloseReport);
			reportGamen.visible = false;
			Global.reportGamen = reportGamen;
			flashStage.addChild(reportGamen);
			function clickMakeReport(e:MouseEvent):void
			{
				//makeGamen.visible = true;
				makeGamen.show();
			}
			function clickDecideReport(e:MouseEvent):void
			{
				reportGamen.visible = false;
				selectGamen.visible = true;
				
				//scenario.no = Scenario.REPORT_LV1;
				selectGamen.showNowPage();
			}
			function clickCloseReport(e:MouseEvent):void
			{
				reportGamen.visible = false;
				selectGamen.visible = true;
				
				selectGamen.showNowPage();
			}

			//妖魔作成画面
			makeGamen = new MakeGamen(new MakeMC(), clickTeisatsu, clickMakeClose);
			makeGamen.visible = false;
			Global.makeGamen = makeGamen;
			flashStage.addChild(makeGamen);
			makeGamen.report = new Report();
			function clickMakeClose(e:MouseEvent):void
			{
				makeGamen.visible = false;
				//selectGamen.visible = true;
				selectGamen.showStatus();
			}
			function clickTeisatsu(e:MouseEvent):void
			{
				reportGamen.visible = false;
				makeGamen.visible = false;
				scenario.no = Scenario.REPORT_LV1;	//これはこのままでＯＫ？とりあえず20140810
				isTeisatsu = true;
				gotoMain();
			}
			
			/*
			//勾玉合成画面
			mixGamen = new MixGamen(new MixGamenMC());
			mixGamen.visible = false;
			flashStage.addChild(mixGamen);
			Global.mixGamen = mixGamen;
			*/

			//Title画面
			titleGamen = new TitleGamen(new TitleMC(), clickNewGame, clickContinue, clickDemo);
			flashStage.addChild(titleGamen);
			//function clickTitle(e:MouseEvent)
			function clickNewGame(e:MouseEvent):void
			{
				titleGamen.visible = false;
				selectGamen.visible = true;
				selectGamen.showStatus();
				//Global.playTekiShoot();
				gotoSelect();
			}
			function clickContinue(e:MouseEvent):void
			{
				titleGamen.visible = false;
				loginGamen.visible = true;
				loginGamen.setInitFocus(flashStage);
				//Global.playTekiShoot();
			}
			function clickDemo(e:MouseEvent):void
			{
				titleGamen.visible = false;
			}

			//クリア画面
			//var clearMC:MovieClip = new ClearMC();
			flashStage.addChild(clearMC);
			clearMC.visible = false;
			clearMC.addEventListener(MouseEvent.CLICK, clickClear);
			function clickClear(e:MouseEvent):void
			{
				if (clearMC.click_txt.visible)
				{
					if (0 < waitClearCnt)
					{
						return;
					}
					
					//--------セーブ完了を待たずにselect画面に行ってしまうので追加
					if (clearMC.msg_txt.text != "【クリックして終了】")
					{
						return;
					}
					//--------
					
					clearMC.click_txt.visible = false;

					//================
					if (0 < usvr.memberNo.length)
					{
						//切断
						usvr.reconnect();
					}
					//================

					/*
					//if ((isGameOver) || (Global.userTbl.getCount() == 0))
					if (Global.userTbl.getCount() == 0)
					{
						clearMC.visible = false;
						selectGamen.refreshPage();
						gotoSelect();
						return;
					}

					//SAVE
					save();
					*/
					//@@@@@@@@
					clearMC.visible = false;
					clearMC.msg_txt.text = "";
					selectGamen.refreshPage();
					gotoSelect();
					
					//勾玉使用可能メッセージ
					if ((scenario.no == Scenario.SHUTENDOUJI)
					&& (isGameOver == false)
					&& (Global.itemTbl.getCount() == 0))
					{
						messageGamen.setMessage("酒呑童子の弓の力により、戦闘終了後に霊力を勾玉に変換できるようになりました。勾玉は破魔弓に装備し能力を追加することができます。");
						//================
						if (0 < usvr.memberNo.length)
						{
							if (usvr.isRoomMakeHost)
							{
								messageGamen.visible = true;
							}
						}
						//================
						else
						{
							messageGamen.visible = true;
						}
					}
					//@@@@@@@@
					
					//[呪×呪]購入可能メッセージ
					if ((scenario.no == Scenario.GARUDA)
					&& (isGameOver == false)
					&& (Global.yumiSettingGamen.hasNoroi2() == false))
					{
						if (isShowedGarudaMesg)
						{
							messageGamen.setMessage("さらなる戦いを求める弓術士向けに禁断の破魔弓強化が追加されました。");
							messageGamen.visible = true;
						}
						isShowedGarudaMesg = false;
					}
					
				}
			}

			//メッセージ
			messageGamen = new MessageGamen(new MessageMC(), clickMsgOK);
			flashStage.addChild(messageGamen);
			messageGamen.visible = false;
			function clickMsgOK(e:MouseEvent):void
			{
				messageGamen.visible = false;
			}
/*
			//参加失敗メッセージ
			//20140521すでに4人入っているところに入ったとの報告があったのでログ出力
			joinFailedGamen = new MessageGamen(new MessageMC(), clickFailedOK);
			joinFailedGamen.visible = false;
			joinFailedGamen.setMessage("協力戦の参加に失敗しました。");
			flashStage.addChild(joinFailedGamen);
			function clickFailedOK():void
			{
				joinFailedGamen.visible = false;
				
				//================
				if (0 < usvr.memberNo.length)
				{
					//切断
					usvr.finalize();
				}
				//================
			
				clearMC.visible = false;
				selectGamen.refreshPage();
				gotoSelect();
			}
*/
			//メッセージ選択画面
			messageSelectGamen = new MessageSelectGamen(new MessageSelectMC(), clickMsgSelectYes, clickMsgSelectNo);
			flashStage.addChild(messageSelectGamen);
			messageSelectGamen.visible = false;
			function clickMsgSelectYes(e:MouseEvent):void
			{
				messageSelectGamen.visible = false;
				save(true);
			}
			function clickMsgSelectNo(e:MouseEvent):void
			{
				messageSelectGamen.visible = false;
				/*
				clearMC.msg_txt.text = "【クリックして終了】";
				if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
				{
					if  (beforeLevel < Hamayumi.level)
					{
						clearMC.click_txt.appendText("\nレベルアップ！破魔弓レベルが" + Hamayumi.level + "になった！");
					}
				}
				*/
				save(false);
			}


			//タイトル画面が出る前に一瞬表示されるのでここでaddする
			var initFrameCnt:int = 0;
			addEventListener(EnterFrameEvent.ENTER_FRAME, initGamen);
			function initGamen(e:EnterFrameEvent):void
			{
				var i:int;

				if (Global.FPS * 2 <= initFrameCnt)
				{
					addChild(skyQuad);
					addChild(canvasFixed);
					addChild(canvasYagura);
					addChild(arrowQuadBatch);
					addChild(mainQuadBatch);
					addChild(canvas);
					
					for (i = 0; i < monster.length; i++)
					{
						addChild(monsterHPBG[i]);
						addChild(monsterHP[i]);
					}

					addChild(jimenQuad);
					addChild(canvasJimen);
					addChild(canvasHeader);
					addChild(meterQuad);
					addChild(meterQuad2);
					addChild(wazaBreakQuad);
					addChild(stageTitle);
					
					//--------負荷軽減対策20141213
					skyQuad.touchable = false;
					canvasFixed.touchable = false;
					canvasYagura.touchable = false;
					arrowQuadBatch.touchable = false;
					mainQuadBatch.touchable = false;
					//canvas.touchable = false;
					
					for (i = 0; i < monster.length; i++)
					{
						monsterHPBG[i].touchable = false;
						monsterHP[i].touchable = false;
					}

					jimenQuad.touchable = false;
					canvasJimen.touchable = false;
					canvasHeader.touchable = false;
					meterQuad.touchable = false;
					meterQuad2.touchable = false;
					wazaBreakQuad.touchable = false;
					stageTitle.touchable = false;
					
					//----
					jimenQuad.blendMode = BlendMode.NONE;
					meterQuad.blendMode = BlendMode.NONE;
					meterQuad2.blendMode = BlendMode.NONE;
					wazaBreakQuad.blendMode = BlendMode.NONE;
					for (i = 0; i < monster.length; i++)
					{
						monsterHPBG[i].blendMode = BlendMode.NONE;
						monsterHP[i].blendMode = BlendMode.NONE;
					}
					//--------

					removeEventListener(EnterFrameEvent.ENTER_FRAME, initGamen);
				}
				initFrameCnt++;
			}

			//--------
			makeStageFunc[Scenario.ZOMBIE] = makeStageZombie;
			makeStageFunc[Scenario.SKELETON] = makeStageSkeleton;
			makeStageFunc[Scenario.SLIME] = makeStageSlime;
			makeStageFunc[Scenario.ARMOR_DEMON] = makeStageArmor;
			makeStageFunc[Scenario.TREE] = makeStageTree;
			makeStageFunc[Scenario.HARPY] = makeStageHarpy;
			//makeStageFunc[Scenario.GOLEM] = makeStageGolem;
			makeStageFunc[Scenario.WISP] = makeStageWisp;
			makeStageFunc[Scenario.LONGWITTON] = makeStageLongwitton;
			makeStageFunc[Scenario.TANK] = makeStageTank;
			makeStageFunc[Scenario.FIGHTER] = makeStageFighter;
			makeStageFunc[Scenario.BATTLE_SHIP] = makeStageBattleShip;
			makeStageFunc[Scenario.STEALTH] = makeStageStealthSubmarine;
			makeStageFunc[Scenario.UFO] = makeStageUFO;
			makeStageFunc[Scenario.TREX] = makeStageTREX;
			makeStageFunc[Scenario.PTERANODON] = makeStagePteranodon;
			makeStageFunc[Scenario.METEORITE] = makeStageMeteorite;
			makeStageFunc[Scenario.REPORT_LV1] = makeStageTeisatsuA;
			makeStageFunc[Scenario.REPORT_LV2] = makeStageTeisatsuA;
			makeStageFunc[Scenario.REPORT_LV3] = makeStageTeisatsuA;
			makeStageFunc[Scenario.REPORT_LV4] = makeStageTeisatsuA;
			makeStageFunc[Scenario.REPORT_LV5] = makeStageTeisatsuA;
			makeStageFunc[Scenario.REPORT_LV6] = makeStageTeisatsuA;
			makeStageFunc[Scenario.REPORT_LV7] = makeStageTeisatsuA;
			makeStageFunc[Scenario.REPORT_LV8] = makeStageTeisatsuA;
			makeStageFunc[Scenario.ROSE] = makeStageRose;
			makeStageFunc[Scenario.REPORT_LV9] = makeStageTeisatsuA;
			makeStageFunc[Scenario.CHAMAELEON] = makeStageChamaeleon;
			makeStageFunc[Scenario.REPORT_LV10] = makeStageTeisatsuA;
			makeStageFunc[Scenario.TENGU] = makeStageTengu;
			makeStageFunc[Scenario.REPORT_LV11] = makeStageTeisatsuA;
			makeStageFunc[Scenario.REPORT_LV12] = makeStageTeisatsuA;
			makeStageFunc[Scenario.GARUDA] = makeStageGaruda;

			//--------
			//usvr.memberShoot = memberShoot;

			Global.usvr = usvr;

			Global.init();
			Global.initSound();
			
			//--------20140723人多すぎ対策
			if (Start.flashVars["rootRoomNo"])
			{
				if (Start.flashVars["rootRoomNo"] == "0")
				{
					Global.rootRoomName = "A";
				}
				else if (Start.flashVars["rootRoomNo"] == "1")
				{
					Global.rootRoomName = "B";
				}
				else if (Start.flashVars["rootRoomNo"] == "3")
				{
					Global.rootRoomName = "C";
				}
				else if (Start.flashVars["rootRoomNo"] == "4")
				{
					Global.rootRoomName = "D";
				}
				else if (Start.flashVars["rootRoomNo"] == "5")
				{
					Global.rootRoomName = "E";
				}
				else if (Start.flashVars["rootRoomNo"] == "6")
				{
					Global.rootRoomName = "F";
				}
				else if (Start.flashVars["rootRoomNo"] == "7")
				{
					Global.rootRoomName = "G";
				}
				else if (Start.flashVars["rootRoomNo"] == "8")
				{
					Global.rootRoomName = "H";
				}
				else if (Start.flashVars["rootRoomNo"] == "9")
				{
					Global.rootRoomName = "I";
				}
				else if (Start.flashVars["rootRoomNo"] == "10")
				{
					Global.rootRoomName = "J";
				}
				else if (Start.flashVars["rootRoomNo"] == "11")
				{
					Global.rootRoomName = "K";
				}
			}
			//--------
			
			/*
			//--------
			//放置対策
			flashStage.addEventListener(Event.ENTER_FRAME, enterFrameFlashStage);
			//--------
			*/
			
			kakushiBmp.scaleX = 10;
			kakushiBmp.scaleY = 10;
			kakushiBmp.visible = false;
			flashStage.addChild(kakushiBmp);
		}

		// ----------------
		// enterFrameFlashStage
		// 放置対策
		// ----------------
		public static var flashStageFrameCnt:int = 0;
		private static var flashStageMouseXY:Point = new Point();
		//private function enterFrameFlashStage(e:Event):void
		private function enterFrameCheckLogout(e:Event):void
		{
			//++++++++
			////setLogInfo("enterFrameFlashStage");
			//++++++++
			
			if (Global.userTbl.getCount() <= 0)
			{
				return;
			}

			if (Global.FPS * 60 * 15 <= flashStageFrameCnt)
			{
				//usvr.reconnect();	//これじゃ再接続してる
				//usvr.reactor.disconnect();
				usvr.finalize();
				
				var tf:flash.text.TextField = new flash.text.TextField();
				tf.textColor = 0xffffff;
				tf.background = true;
				tf.backgroundColor = 0x512D6B;//
				tf.text = "ログアウトしました。";
				tf.width = 640;
				tf.height = 480;
				flashStage.addChild(tf);
				
				//flashStage.removeEventListener(Event.ENTER_FRAME, enterFrameFlashStage);
				flashStage.removeEventListener(Event.ENTER_FRAME, enterFrameCheckLogout);
				
				//++++++++
				//setLogInfo("ログアウトしました。");
				//++++++++
			}
			if ((flashStageMouseXY.x == flashStage.mouseX) && (flashStageMouseXY.y == flashStage.mouseY))
			{
				//
			}
			else
			{
				flashStageFrameCnt = 0;
			}
			flashStageMouseXY.x = flashStage.mouseX;
			flashStageMouseXY.y = flashStage.mouseY;
			flashStageFrameCnt++;
		}

		// ----------------
		// save
		// ----------------
		//private var isSaveOk:Boolean = false;
		private function save(isMagatama:Boolean = false):void
		{
			//++++++++
			//setLogInfo("save");
			//++++++++

			/*
			if (isSaveOk)
			{
				//セーブ済み
				clearMC.visible = false;
				clearMC.msg_txt.text = "";
				selectGamen.refreshPage();
				gotoSelect();

				return;
			}
			*/
			
			if (hitCount.value == 0)
			{
				isMagatama = false;
				messageSelectGamen.visible  = false;

				//================
				if (0 < usvr.memberNo.length)
				{
					//切断
					usvr.reconnect();
				}
				//================

				clearMC.visible = false;
				clearMC.msg_txt.text = "";
				selectGamen.refreshPage();
				gotoSelect();
				return;
			}

			if (Global.userTbl.getCount() == 0)
			{
				return;
			}
			
			var sc:SaveConnect = new SaveConnect();
			var obj:Object = new Object();
			obj.name = Global.userTbl.getData(0, "NAME");
			obj.pwd = Global.pwd;
			obj.scenarioIdx = Global.scenario.lastClearIndex;
			obj.scenarioNo = Global.scenario.no;
			obj.exp = Hamayumi.exp;
			obj.magatama = (isMagatama ? 1 : 0);
			obj.noroi = Global.stageNoroiValue;
			obj.clearframecnt = clearFrameCnt;
			obj.cleartime = clearTime;
			obj.personcnt = personcnt;
			obj.win = (isGameOver ? 0 : 1);
			obj.dmgrate = magatamaQuality;
			obj.addexp = addExp.value;
			obj.shootArrowCnt = shootArrowCnt.value;
			obj.daily = Global.dailyQuestNo;
			obj.thisIdx = Global.scenario.getStageIdx(Global.scenario.no);
			if (Global.scenario.isReportStage())
			{
				obj.pageno = Global.reportGamen.pageNo;
			}
			else
			{
				obj.pageno = "";
			}

			obj.ch = 0;
			if (frameCntValue.isCheat)
			{
				obj.ch = 30;
			}
			if (Hamayumi.isCheat)
			{
				obj.ch = 10;
			}
			if (hitCount.isCheat)
			{
				obj.ch = 20;
			}
			if (addExp.isCheat)
			{
				obj.ch = 25;
			}
			if (shootArrowCnt.isCheat)
			{
				obj.ch = 40;
			}
			if (Global.itemTbl.isHashOK() == false)
			{
				obj.ch = 50;
			}
			//加速チートチェック
			if (isSpeedCheat)
			{
				obj.ch = 60;
			}
			
			sc.connect(obj, saveOkFunc);
			clearMC.msg_txt.text = "セーブ中…";

			var nowIndex:int = int(Global.userTbl.getData(0, "SCENARIO"));

			function saveOkFunc(bool:Boolean):void
			{
				if (bool)
				{
					//--------
					//セーブ後に来るのでこのセーブで勾玉カンストすると表示されない
					//→勾玉選択を行ったかで判断する。
					//if (enableMessageSelectGamen())
					//if (isShowedMagatamaSelect)	
					{
						if (isMagatama)
						{
							clearMC.click_txt.text = Global.getItemNameByID(Global.magatamaID) + "を手に入れた。";
							if (0 < Global.expup)
							{
								clearMC.click_txt.appendText("霊力" + Global.expup + "取得。");
								Global.expup = 0; //init
							}
						}
						clearMC.msg_txt.text = "【クリックして終了】";
						
						if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
						{
							if (beforeLevel < Hamayumi.level)
							{
								clearMC.click_txt.appendText("\nレベルアップ！破魔弓レベルが" + Hamayumi.level + "になった！");
							}
						}

						//--------
						//セーブ完了前に[クリックして終了画面]がクリックできて消えて戻れなくなるので、ここで表示trueとして、クリック終了とさせる
						clearMC.click_txt.visible = true;
						clearMC.visible = true;
						//--------
						
						//--------
						//10/20 連打で終了すると、退治結果が残るバグの応急処置
						if (Global.selectGamen.visible)
						{
							clearMC.visible = false;
						}
						//--------
					}
					/*
					else
					{
						//勾玉変換が出来ないのなら終了

						clearMC.visible = false;
						clearMC.msg_txt.text = "";
						selectGamen.refreshPage();
						gotoSelect();
						
						//勾玉使用可能メッセージ
						if ((scenario.no == Scenario.SHUTENDOUJI)
						&& (isGameOver == false)
						&& (Global.itemTbl.getCount() == 0))
						{
							messageGamen.setMessage("酒呑童子の弓の力により、戦闘終了後に霊力を勾玉に変換できるようになりました。勾玉は破魔弓に装備し能力を追加することができます。");
							//================
							if (0 < usvr.memberNo.length)
							{
								if (usvr.isRoomMakeHost)
								{
									messageGamen.visible = true;
								}
							}
							//================
							else
							{
								messageGamen.visible = true;
							}
						}
					}
					*/
					//--------
					
					//--------
					if (Global.dochoFlag == 1)
					{
						clearMC.click_txt.appendText(" 装備勾玉に霊力を蓄積。");
						Global.dochoFlag = 0; //init
					}
					//--------
					
					//--------
					if (0 < Global.dailyReward)
					{
						clearMC.click_txt.appendText(" 霊銭" + Global.dailyReward + "文を獲得。");
					}
					//--------
					
					//isSaveOk = true;
				}
				else
				{
					//retry
					clearMC.msg_txt.text = "セーブに失敗しました。" + sc.message;
					
					if (sc.message == "ログイン情報が無効です。")
					{
						return;
					}
					
					if (isMagatama)
					{
						messageSelectGamen.visible = true;
					}
					else
					{
						clearMC.click_txt.visible = true;
					}
				}
			}
		}
		
		// ----------------
		// isSpeedCheat
		// ----------------
		private var isSpeedCheat:Boolean = false;
		private function checkSpeedCheat(_frameCnt:int, _realMSec:int, saSec:int):void 
		{
			var tm1:Number = _frameCnt / Global.FPS;
			var tm2:Number = _realMSec / 1000;
			
			//実時間よりフレームカウントが異常に多いのがおかしい。saSec秒以上フレームカウントが進んでいたら加速チート
			if (saSec <= tm1 - tm2)
			{
				isSpeedCheat = true;
			}
		}

		// ----------------
		// touch
		// ----------------
		private var isMouseUp:Boolean = false;
		private var isMouseDown:Boolean = false;
		//private var mousePoint:Point = new Point();
		private function touch(e:TouchEvent):void
		{
			//++++++++
			//setLogInfo("touch");
			//++++++++

			var i:int;
			var touch:Touch = e.getTouch(stage);

			if (isClear)
			{
				return;
			}

			if (touch)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					//trace("BEGAN");
					isMouseUp = false;
					isMouseDown = true;
//					power = 0.0;
//allPower = 0.0;
				}
				if (touch.phase == TouchPhase.ENDED)
				{
					//trace("ENDED");
					isMouseUp = true;
					isMouseDown = false;
				}
			}
		}

		// ----------------
		// gotoMain
		// ----------------
		private var isOnibi1Normal:Boolean = false;
		private var isOnibi2Normal:Boolean = false;
		private var personcnt:int = 0;
		private var isReportStage:Boolean = false;
		private function gotoMain():void
		{
			//++++++++
			//setLogInfo("gotoMain");
			//++++++++

			var i:int;
			var msg:String = "";

			//--------
			canvas.visible = true;
			canvasFixed.visible = true;
			canvasJimen.visible = true;
			canvasHeader.visible = true;
			canvasYagura.visible = true;
			skyQuad.visible = true;
			jimenQuad.visible = true;
			meterQuad.visible = true;
			meterQuad2.visible = true;
			wazaBreakQuad.visible = true;
			stageTitle.visible = true;
			//--------
			
			//--------
			//var stageTitle:starling.text.TextField = new starling.text.TextField(320, 64, "", "_等幅", 16, 0xfffefefe, true);
			stageTitle.x = 10;
			stageTitle.y = 10;
			stageTitle.hAlign = HAlign.LEFT;
			stageTitle.vAlign = VAlign.TOP;
			//addChild(stageTitle);
			stageTitle.text = waitGamen.mc.title_txt.text;
			stageTitleShowCnt = 7 * Global.FPS;
			//--------

			addEventListener(TouchEvent.TOUCH, touch);
			addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameMain);
			addEventListener(KeyboardEvent.KEY_DOWN, keydownListener);
			addEventListener(KeyboardEvent.KEY_UP, keyupListener);

			Global.enabledIME(false);

			selectGamen.visible = false;
			chatGamen.finalize();

			//--------
			//放置対策OFF
			flashStage.removeEventListener(Event.ENTER_FRAME, enterFrameCheckLogout);
			//--------
			
			//--------
			//矢数再設定
			startArrowIdx = 0;
			arrows = null;	//不要かな
			arrows = new Vector.<Arrow>;
			for (i = 0; i < Arrow.maxArrowCnt; i++)
			{
				arrows[i] = new Arrow();
				arrows[i].lightNoSelf = i % 3;	//軽量化用番号（mod(%)計算が重い）
				arrows[i].lightNoNotSelf = i % 6;
			}
			//--------
			
			//矢数保存--------
			LocalStorage.setItem("arrows_arrowCnt", Arrow.maxArrowCnt.toString());
			//--------
			
			//--------
			//関数オーバーヘッドを無くすために代入(enterFrame内で使用するため)
			isReportStage = scenario.isReportStage();
			//--------
			
			//--------
			//報告書ステージ選択チェック
			//if (scenario.no == Scenario.REPORT_LV1)
			//if (scenario.isReportStage())
			if (isReportStage)
			{
				var reportStageType:int = 0;
				var reportAttackType:int = 0;

				if (isTeisatsu)
				{
					//偵察
					reportStageType = makeGamen.report.stageType;
					reportAttackType = makeGamen.report.attackType;
				}
				else
				{
					//報告書実戦
					//reportGamen.isDecide = true;	//協力者用に強制的にtrue
					reportGamen.isDecide[scenario.no] = true;	//協力者用に強制的にtrue
					//OK
					var idx:int = reportGamen.pageNo;
					var tbl:Table = Global.reportTbl;
					//makeGamen.setTextData(tbl.getData(idx, "MANAGE"), Vector.<String>([tbl.getData(idx, "IMG1"), tbl.getData(idx, "IMG2"), tbl.getData(idx, "IMG3")]));
					makeGamen.setTextData(tbl.getData(idx, "MANAGE"), Vector.<String>([tbl.getData(idx, "IMG1"), tbl.getData(idx, "IMG2"), tbl.getData(idx, "IMG3"), tbl.getData(idx, "IMG4"), tbl.getData(idx, "IMG5")]));
					//--------鬼火弾カスタマイズ可能にしたので無い場合はデフォルトにする
					isOnibi1Normal = false;
					isOnibi2Normal = false;
					if (tbl.getData(idx, "IMG4").length == 0)
					{
						isOnibi1Normal = true;
					}
					if (tbl.getData(idx, "IMG5").length == 0)
					{
						isOnibi2Normal = true;
					}
					//--------
					makeGamen.convertText2Bmp();
					//scenario.no = Scenario.REPORT_LV1;
					reportStageType = int(tbl.getData(idx, "TYPE"));
					
					//--------攻撃パターン追加したので設定値がない場合はデフォルトにする
					reportAttackType = int(tbl.getData(idx, "ATTACK"));
					if (reportAttackType == -1)
					{
						reportAttackType = reportStageType;
					}
					//--------
				}

				//var reportStageFunc:Vector.<Function> = Vector.<Function>([makeStageTeisatsuA, makeStageTeisatsuB, makeStageTeisatsuC]);
				var reportStageFunc:Vector.<Function> = Vector.<Function>
				([
					makeStageTeisatsuA,
					makeStageTeisatsuB,
					makeStageTeisatsuC,
					makeStageTeisatsuD
					//makeStageTeisatsuE
				]);
				makeStageFunc[scenario.no] = reportStageFunc[reportStageType];
				
				//var reportAttackFunc:Vector.<Function> = Vector.<Function>([setAttackPattern0, setAttackPattern1, setAttackPattern2]);
				var reportAttackFunc:Vector.<Function> = Vector.<Function>
				([
					setAttackPattern0,
					setAttackPattern1,
					setAttackPattern2,
					setAttackPattern3
				]);
				setAttackPattern = reportAttackFunc[reportAttackType];
			}
			//--------
			
			//--------
			//makeScenario();
			try
			{
				makeScenario();
			}
			catch (e:Error)
			{
				new TextLogConnect().connect("makeScenario Error:" + e.errorID);
				sorryPleaseReLogin(e.errorID.toString());
				return;
			}

			//================
			if (usvr.isJoinSuccess)
			{
				//モンスターHP調整
				usvr.setGameLevel(monster);
			}
			//================
			//else if (Global.isEquipNoroi())
			//呪い　OR 日刊稲荷依頼
			else if (Global.isEquipNoroi() || (0 < Global.dailyQuestNo))
			{
				if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
				{
					//呪い設定(OFFLINE)
					Global.stageNoroiValue = "1";
					//モンスターHP調整
					usvr.setNoroiLevel(monster);
				}
			}
			//--------
			else if (Global.yumiSettingGamen.isNoroi2())
			{
				if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
				{
					//呪2設定(OFFLINE)
					Global.stageNoroiValue = "2";
					//モンスターHP調整
					usvr.setNoroi2Level(monster);
				}
			}
			//--------

			Global.stopBGM();
			if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
			{
				Global.setBGMNo(2);
				Global.playBGM();
			}

			//================
			chatGamen.removeMsgListener();
			usvr.leaveTop();
			//================

			//--------
			isClear = false;
			clearMC.visible = false;
			isMouseUp = false;
			isMouseDown = false;
			for (i = 0; i < arrows.length; i++)
			{
				arrows[i].hitIdx = -1;
				arrows[i].x = -32;
				arrows[i].y = 640;
				arrows[i].status = Arrow.STATUS_STOP;
			}
			
			//初回の説明表示
			if (scenario.lastClearIndex == -1)
			{
				messageGamen.visible = true;
				msg += "《矢を射る方法》\n";
				msg += "マウスをクリックしたまま→弓を引く\n";
				msg += "マウスカーソルを動かす　→角度調整\n";
				msg += "クリックを離す　　　　　→矢を放つ";
				messageGamen.setMessage(msg);
			}
			
			//--------
			stageTotalHp = 0;
			for (i = 0; i < monster.length; i++ )
			{
				if (monster[i].isMissile == false)
				{
					stageTotalHp += monster[i].hp;
				}
				
				//--------偵察モンスターが討伐されるので
				if (isTeisatsu)
				{
					monster[i].hp *= 100;
				}
				
				//--------HPゲージ用
				monster[i].maxHP = monster[i].hp;
			}
/*
//--------
//TEST
var dps:int = 24 / (maxPower / addPowerValue) * shootArrowCnt.value * Hamayumi.damage;
trace(stageTotalHp / dps);
var ttttest:int = stageTotalHp / dps;
//--------
*/
			
			//--------
			arrowsLength = arrows.length;
			monsterLength = monster.length;
		}

		// ----------------
		// clearReportStatus
		// ----------------
		private function clearReportStatus():void
		{
			//++++++++
			//setLogInfo("clearReportStatus");
			//++++++++

			//ハーピー亜種とソロで戦闘した後、協力戦をして雷獣と戦い
			//ステージ選択でハーピー亜種を選び戦闘へ入ると雷獣が出現しました。の対策
			reportGamen.clearDecideFlag();
			Scenario.clearScenerioName();
		}
		
		// ----------------
		// gotoSelect
		// ----------------
		private function gotoSelect():void
		{
			//++++++++
			//setLogInfo("gotoSelect");
			//++++++++

			var i:int;

			//協力戦に参加すると画面上選択しているものと、シナリオNOがずれるので合わせる。報告書はクリアする。
			if (selectGamen.lastSelectedScenerioNo != scenario.no)
			{
				scenario.no = selectGamen.lastSelectedScenerioNo;
				clearReportStatus();
			}
			
			//呪い初期化(OFFLINE)
			Global.stageNoroiValue = "0";
			
			//日刊初期化
			//Global.dailyQuestNo = 0;	//日刊クエストクリア
			if (isGameOver)
			{
				//ゲームオーバーならクリアしない
			}
			else
			{
				Global.dailyQuestNo = 0;	//日刊クエストクリア
			}
			
			selectGamen.refreshPage();
			selectGamen.visible = true;
			selectGamen.showStatus();
			
			chatGamen.init();
			
			isClickWaitCoop = false;
			//isClickStartCoop = false;

			Global.stopBGM();
			Global.setBGMNo(1);
			Global.playBGM();

			if (isTeisatsu)
			{
				isTeisatsu = false;
				selectGamen.visible = false;
				reportGamen.show();
				makeGamen.show(false);
			}
			
			removeEventListener(TouchEvent.TOUCH, touch);
			removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameMain);
			removeEventListener(KeyboardEvent.KEY_DOWN, keydownListener);
			removeEventListener(KeyboardEvent.KEY_UP, keyupListener);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameSelectGamen);

			//--------
			//放置対策ON
			flashStage.addEventListener(Event.ENTER_FRAME, enterFrameCheckLogout);
			//--------

			Global.enabledIME(true);
			
			//version up check
			checkVersion();

			/*
			//呪い初期化(OFFLINE)
			Global.stageNoroiValue = "0";
			*/

			//--------
			arrowQuadBatch.reset();
			mainQuadBatch.reset();
			canvas.visible = false;
			canvasFixed.visible = false;
			canvasJimen.visible = false;
			canvasHeader.visible = false;
			canvasYagura.visible = false;
			skyQuad.visible = false;
			jimenQuad.visible = false;
			meterQuad.visible = false;
			meterQuad2.visible = false;
			wazaBreakQuad.visible = false;
			stageTitle.visible = false;
			//--------
			
			waitGamen.mc.title_txt.text = "";
			
			//--------
			// 報告書データを読み込んでいなければ読み込む(lv.55-15の40以上が条件)
			// またはメテオライトクリア
			//if (40 <= Hamayumi.level)
			if ((40 <= Hamayumi.level) || (scenario.getStageIdx(Scenario.METEORITE) <= scenario.lastClearIndex))
			{
				if (Global.reportTbl.getCount() <= 0)
				{
					flashStage.addChild(nowRcvMc);

					//--------
					var rc:ReportConnect = new ReportConnect();
					rc.connect(reportOK);
					function reportOK(bool:Boolean):void
					{
						if (bool)
						{
							flashStage.removeChild(nowRcvMc);
						}
						else
						{
							nowRcvMc.msg_txt.text = "データ受信に失敗しました。";
						}
					}
				}
			}
			//--------
			
			//--------
			//11/16 退治結果が残るという報告の応急処置
			if (Global.selectGamen.visible)
			{
				clearMC.visible = false;
			}
			//--------
		}

		// ----------------
		// checkVersion
		// ----------------
		private function checkVersion():void
		{
			try
			{
				var url:URLRequest = new URLRequest(Connect.getUrl() + "version.txt?dummy=" + (new Date).time);
				var urlLoader:URLLoader = new URLLoader();
				
				// 読み込み完了時に呼び出されるイベント
				urlLoader.addEventListener (Event.COMPLETE, loaderInfoCompleteFunc);
				urlLoader.load(url);
				function loaderInfoCompleteFunc(e:Event):void
				{
					var str:String = urlLoader.data;
					trace(str);
					if (TitleGamen.version < str)
					{
						selectGamen.setMsg("新しいバージョンがあります ver." + str + " ページを更新(F5キー)してください");
					}
	
					urlLoader.removeEventListener (Event.COMPLETE, loaderInfoCompleteFunc);
				}
			}
			catch (e:Error)
			{
				//++++++++
				//Game.setLogInfo("checkVersion:" + e.errorID);
				//++++++++
			}
		}

		//----------------
		// enterFrameSelectGamen
		//----------------
		private function enterFrameSelectGamen(e:EnterFrameEvent):void
		{
			//++++++++
			//setLogInfo("enterFrameSelectGamen");
			//++++++++

			//if (usvr.isReady)
			if ((usvr.isReady == true) && (usvr.reactor.isReady() == true))
			{			
				if (usvr.isChatReady == false)
				{		
					usvr.joinTop();
					chatGamen.addMsgListener();
					removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameSelectGamen);
					
					addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHitoOsugi);
				}
			}
		}
		
		//20140723人多すぎ対策(32人ずつ部屋分ける)
		private var isFirstConnect:Boolean = true;
		private function enterFrameHitoOsugi(e:EnterFrameEvent):void
		{
			//++++++++
			//setLogInfo("enterFrameHitoOsugi");
			//++++++++

			if (isFirstConnect)
			{
				var cnt:int = Global.usvr.getPlayerCnt();
				if (cnt <= 0)
				{
					//error retry
				}
				else if (cnt < UnionServer2.MAX_ROOM_CNT)
				{
					//OK
					isFirstConnect = false;
				}
				else
				{
					//NG:切断
					isFirstConnect = false;
					//Global.usvr.reactor.disconnect();
					usvr.finalize();

					var tf:flash.text.TextField = new flash.text.TextField();
					tf.textColor = 0xffffff;
					tf.background = true;
					tf.backgroundColor = 0x512D6B;//
					//tf.text = "人がいっぱいです。ゲーム画面上の部屋名をクリックして、他の部屋へ移動をお願いします。";
					tf.text = "満員です。お手数ですが部屋選択ページに戻って入室できる部屋へ移動をお願いします。";
					tf.width = 640;
					tf.height = 480;
					flashStage.addChild(tf);
					
					//++++++++
					//setLogInfo("満員です。");
					//++++++++
				}
			}
			else
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHitoOsugi);
			}
		}

		// ================
		// gotoWait
		// ================
		private function gotoWait():void
		{
			//++++++++
			//setLogInfo("gotoWait");
			//++++++++

			selectGamen.visible = false;
			waitGamen.visible = true;
			waitGamen.initGamen();

			addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameWait);

			//================
			//chatGamen.selfClientID = "";
			chatGamen.removeMsgListener();
			usvr.leaveTop();
			//================
		}
		private function enterFrameWait(e:EnterFrameEvent):void
		{
			//++++++++
			//setLogInfo("enterFrameWait");
			//++++++++

			if ((usvr.isReady == false) || (usvr.reactor.isReady() == false))
			{
				return;
			}
			
			//一秒に一回でよい？→ 開始ラグが発生するのでやらないほうがいい
	
			if (usvr.isJoinSuccess)
			{

				if (checkRoomData() == false)
				{
					//roomデータが不完全なため参加やり直し → JOINにupdatelevelを設定するようにしたら発生しなくなった...

					removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameWait);
					if (usvr.isHost())
					{
						usvr.reconnect();
						(new TextLogConnect()).connect(Global.username + " NG retry host");
						startCoop();
					}
					else
					{
						usvr.reconnect();
						(new TextLogConnect()).connect(Global.username + " NG retry member");
						gotoJoin();
					}
					
					return;
				}

				waitGamen.setMemberText(usvr.getRoomMemberStr());

				//--------
				//協力戦に参加ボタンを押したのにホストになってしまったらキャンセルする
				if (isClickWaitCoop)
				{
					if (usvr.isHost())
					{
						usvr.sendMessage("HOST_CANCEL", "", true);
						return;
					}
				}
				//--------

				waitGamen.initGamen(usvr.isHost());

				if ((usvr.isRoomFull()) || (usvr.isClose()))
				{
					usvr.shimekiriRoom();
					scenario.no = int(usvr.room.getAttribute("scenarioNo"));
					
					removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameWait);
					
					//--------念のためwait → おそらく不要
					var timer:Timer = new Timer(500, 1);
					timer.addEventListener(TimerEvent.TIMER, startBattle);
					function startBattle(e:TimerEvent):void 
					{
						waitGamen.visible = false;
						//removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameWait);
						timer.removeEventListener(TimerEvent.TIMER, startBattle);
						gotoMain();
					}
					timer.start();
					//--------
				}
			}
		}

		//----------------
		// checkRoomData
		//----------------
		private function checkRoomData():Boolean
		{
			//++++++++
			//setLogInfo("checkGameOver");
			//++++++++

			var i:int, k:int;

			if (usvr.room == null)
			{
				//textLog.connect(Global.username, "ありえない？");
				return false;	//ありえない？
			}

			/*
			if (usvr.room.getSyncState() != SynchronizationState.SYNCHRONIZED)
			{
				textLog.connect(Global.username, "" + usvr.room.getSyncState());
			}
			*/

			var attr:Vector.<String> = Vector.<String>
			(["minLevel", "scenarioNo", "reportNo", "noroi", "join", "host", "aikotoba", "close", "tobatsu", "username", "level"]);
			for (i = 0; i < attr.length; i++ )
			{
				if (usvr.room.getAttribute(attr[i]) == null)
				{
					/*
					textLog.connect(Global.username, "#" + attr[i]);
					for (k = 0; k < attr.length; k++ )
					{
						textLog.connect(Global.username, "" + attr[k] + ":" + usvr.room.getAttribute(attr[i]));
					}
					*/
					//部屋情報更新してみる
					usvr.updateRoomAttributes(usvr.room.getRoomID());
					
					return false;
				}
			}
			
			return true;
		}
		
		// ================
		// startCoop
		// ================
		//private var isClickStartCoop:Boolean = false;
		private function startCoop():void
		{
			//++++++++
			//setLogInfo("startCoop");
			//++++++++
			
			//isClickStartCoop = true;
			usvr.docho.clear();
			
			//--------
			if (selectGamen.isCoop)
			{
				//必要レベルチェック
				if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
				{
					/*
					if (Hamayumi.level < scenario.getMinLevel())
					{
						selectGamen.setMsg("その妖魔を協力して退治するには " + scenario.getMinLevel() + " レベル以上である必要があります。");
						return;
					}
					*/
					var _needLv:int = scenario.getMinLevelNoroiFlag(Global.isEquipNoroi());
					//--------
					if (Global.yumiSettingGamen.isNoroi2())
					{
						_needLv = scenario.getMinLevelNoroi2Flag(true);
					}
					//--------
					if (Hamayumi.level < _needLv)
					{
						selectGamen.setMsg("その妖魔を協力して退治するには " + _needLv + " レベル以上である必要があります。");
						return;
					}
				}
			}
			//--------

			//--------
			//報告書ステージ選択チェック
			//if (scenario.no == Scenario.REPORT_LV1)
			if (scenario.isReportStage())
			{
				//if (reportGamen.isDecide)
				if (reportGamen.isDecide[scenario.no])
				{
					//設定はgotoMainで行う
					isTeisatsu = false;
				}
				else
				{
					selectGamen.setMsg("報告書から退治する妖魔を選んでください。");
					return;
				}
			}
			//--------
			
			if (selectGamen.isCoop)
			{
				//================
				//init
				Global.selectedCoopName = "";

				//if (usvr.isReady)
				if ((usvr.isReady == true) && (usvr.reactor.isReady() == true))
				{
					//usvr.start();
					//usvr.start(selectGamen.mc.aikotoba_txt.text);
					usvr.start(selectGamen.mc.aikotoba_txt.text, selectGamen.boshuMinLv, selectGamen.boshuMaxLv);
					gotoWait();
				}
				//================
			}
			else
			{
				gotoMain();
			}
		}
		
		// ================
		// gotoJoin
		// ================
		private var isNowJoinCheck:Boolean = false;
		private var joinWaitCnt:int = 0;
		private var isClickWaitCoop:Boolean = false;
		private function gotoJoin():void
		{
			//++++++++
			//setLogInfo("gotoJoin");
			//++++++++

			isClickWaitCoop = true;
			usvr.docho.clear();
			
			selectGamen.visible = false;
			waitGamen.visible = true;
			waitGamen.initGamen();

			isNowJoinCheck = false;

			addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameJoin);

			//================
			chatGamen.removeMsgListener();
			usvr.leaveTop();
			//================
		}
		private function enterFrameJoin(e:EnterFrameEvent):void
		{
			//++++++++
			//setLogInfo("enterFrameJoin");
			//++++++++

			if ((usvr.isReady == false) || (usvr.reactor.isReady() == false))
			{
				return;
			}
			
			waitGamen.setMemberText("");

			if ((joinWaitCnt % Global.halfFPS) == 0)
			{
				if (isNowJoinCheck)
				{
					//※ROOM_FULL なら usvr.isSuccess=false
					if (usvr.isJoinSuccess)
					{
						removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameJoin);
						gotoWait();
					}
					else
					{
						//ROOM_FULL または JOIN中 のときここに来るはず → いろいろ試した結果、JOIN中は無いみたい。
						if (usvr.joinPhase == UnionServer2.PHASE_JOIN_END)	//join処理終了
						{
							isNowJoinCheck = false;
							(new TextLogConnect()).connect(Global.username + " NG join failed " + usvr.joinPhase + " " + usvr.isJoinSuccess);
							
							//参加やり直し
							//失敗してそのままリトライすると、先に入室しているメンバーにメッセージが飛ばない。
							//４人表示されるので入室は認識されている。こちらからの矢発射は全員に飛ぶ。先に入室したメンバーからは来ない。
							//切断して再接続で正常動作した。一度失敗すると再入室がうまくいかないのは不明
							removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameJoin);
							usvr.reconnect();
							gotoJoin();
						}
					}
				}
				else
				{
					var isRoomUpdate:Boolean = (joinWaitCnt % (5 * Global.FPS) == 0);
					
					if (usvr.join(selectGamen.mc.aikotoba_txt.text, isRoomUpdate))
					{
						//※ROOM_FULL でもここに来る →?
						isNowJoinCheck = true;
					}
				}
				
			}
			
			joinWaitCnt++;
		}

		// ----------------
		// makeScenario
		// ----------------
		private var jimenData:Vector.<int>;
		private var haikeiData:Vector.<int>;
		private var haikeiData2:Vector.<int>;
		private var haikeiData3:Vector.<int>;
		private var clearFrameCnt:int = 0;
		private var clearTime:int = 0;
		private var stageTotalHp:int = 0;
		private function makeScenario():void
		{
			//++++++++
			//setLogInfo("makeScenario");
			//++++++++

			var i:int, k:int, a:int;
			var idx:int, idx2:int, idx3:int, idx4:int;

			//--------init
			clearMC.msg_txt.text = "";
			clearMC.click_txt.visible = false;
			//isSaveOk = false;
			Hamayumi.isShowHP = false;
			Hamayumi.damage = 1;
			
			withdrawCount = 0;
			
			mt.init_genrand(0x12345678);
			
			jimenData = null;
			haikeiData = null;
			haikeiData2 = null;
			haikeiData3 = null;
			
			myArcher = archer[0];

			for (i = 0; i < monster.length; i++)
			{
				monster[i].hp = 0;
				monster[i].vanishCnt = 0;
				monster[i].x = 0;
				monster[i].y = 0;
				monster[i].v = 0;
				monster[i].moveValX = 0;
				monster[i].moveValY = 0;
				monster[i].dir = Monster.DIR_LEFT;
				monster[i].vdir = Monster.VDIR_DOWN;
				monster[i].isNowMove = false;
				monster[i].dir = Monster.DIR_LEFT;
				monster[i].isEnemy = true;
				monster[i].enableBreak = false;
				monster[i].hitRange = 0;
				
				monster[i].hitRange2 = 0;
				monster[i].hitRange2X = 0;
				monster[i].hitRange2Y = 0;
				monster[i].isNoDamage = false;
				
				monster[i].hitRect.width = 0;	//0で点と点の距離の当たり判定
				monster[i].hitRect.height = 0;
				monster[i].hitRect.x = 0;
				monster[i].hitRect.y = 0;
				monster[i].isNGHit = false;
				monster[i].turnRate = -1;
				monster[i].minX = 0;
				monster[i].maxX = 0;
				monster[i].minY = 0;
				monster[i].maxY = 0;
				monster[i].maxV = 0;
				monster[i].movePattern = Monster.MOVE_NORMAL;
				monster[i].moveInterval = -1;
				monster[i].isBmpHit = false;
				monster[i].isMissile = false;
				monster[i].startShootFrameCnt = -1;
				monster[i].shootInterval = Global.FPS * 60 * 5;
				monster[i].isHitEachOther = false;
				monster[i].isReflect = false;	
				monster[i].imgChangeInterval = Global.halfFPS;
				monster[i].shooterIdx = -1;
				monster[i].bodyIdx = -1;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].isDieFall = false;
				monster[i].isVanish = true;
				monster[i].isShootSound = true;
				//monster[i].dieKanseiX = 0.0;
				monster[i].phase = 0;
				monster[i].imgNoWalkLeft1 = monsterImgNo[166];
				monster[i].imgNoWalkLeft2 = monsterImgNo[166];
				monster[i].imgNoWalkRight1 = monsterImgNo[166];
				monster[i].imgNoWalkRight2 = monsterImgNo[166];
				monster[i].imgNoDeadLeft = monsterImgNo[166];
				monster[i].imgNoDeadRight = monsterImgNo[166];
				monster[i].moveCnt = 0;
				//monster[i].shootStart = false;
				monster[i].hontaiIdx = -1;
				monster[i].isNoCount = false;
				monster[i].isUnbreakableMissile = false;
				monster[i].isShow = true;
				monster[i].commandArrowHide = false;
			}
			renderTexture.clear();
			renderTextureFixed.clear();
			renderTextureJimen.clear();
			renderTextureHeader.clear();
			renderTextureYagura.clear();
			for (i = 0; i < arrows.length; i++)
			{
				arrows[i].penetrateCnt = 0;
				arrows[i].shootWait = 0;
				arrows[i].x = -32;
				arrows[i].y = 640;
				arrows[i].hitIdx = -1;
				arrows[i].status = Arrow.STATUS_STOP;

				for (a = 0; a < Arrow.routeCnt; a++ )
				{
					arrows[i].routeX[a] = -32;
					arrows[i].routeY[a] = -32;
				}
			}
			arrowImage = BitmapManager.normalArrowImage;
			for (i = 0; i < damageData.length; i++)
			{
				damageData[i] = 0;
			}

			myArcher.initSolo();

			bmpForHit.x = 0;
			bmpForHit.y = 0;
			//bmpForHit.bitmapData.fillRect(bmpForHit.bitmapData.rect, 0x00000000);
			bmpForHit.bitmapData.fillRect(bmpForHit.bitmapData.rect, 0x000000);
			isMouseDown = false;
			isMouseUp = false;
			isClear = false;
			clearFrameCnt = 0;
			clearTime = 0;
			personcnt = 1;
			isGameOver = false;
			clearMC.visible = false;
			////オフライン座標
			//playerXY = soloXY;
			remainTime = 60 * Global.FPS;
			yagura.init(false, 0);
			lastYaguraHP = -1;
			lastYaguraHPForDraw = -1;
			frameCnt = 0;
			stageStartTime = (new Date()).time;
			
			isSpeedCheat = false;
			
			monsterFrameCnt = 1;
			lastMonsterFrameCnt = 0;
			sendDamagaInterval = 0;
			gameoverFrameCnt = 0;
			waitClearCnt = WAIT_CLEAR_CNT;
			power = 0.0;
			allPower = 0.0;
			shotCount = 0;
			//hitCount = 0;
			hitCount.value = 0;
			damageCount.value = 0;
			wazaTameGauge.value = 0;
			
			wazaBreakQuad.width = 0;
			
			hitCountReidan10bai.value = 0;

			beforeLevel = Hamayumi.level;
			
			hiya = new Vector.<Hiya>;
			kooriya = new Vector.<Kooriya>;
			
			//--------
			if (scenario.no == Scenario.KYUDO)
			{
				//通常弓
				shootArrowCnt.value = 1;
				maxPower = Arrow.MAX_POWER;
				addPowerValue = maxPower / Global.FPS;

				myArcher.addInitXY(64, -8);

				//敵設定

				//当たり判定用bmp作成
				makeHitBmp(11);
				//flashStage.addChild(bmpForHit);

				//的
				i = 0;
				//monster[i].x = 640 - 24;
				monster[i].x = 640 - 86-6;
				monster[i].y = 480 - 48-9;
				monster[i].hp = 1;
				monster[i].hitRect.x = 0;
				monster[i].hitRect.y = 2;
				monster[i].hitRect.width = 5*2;//6*2;
				monster[i].hitRect.height = 8*2;
				//monster[i].hitRect.x = monster[i].x;
				//monster[i].hitRect.y = monster[i].y;
				monster[i].imgNoWalkLeft1 = monsterImgNo[12];
				monster[i].imgNoWalkLeft2 = monsterImgNo[12];
				monster[i].imgNoWalkRight1 = monsterImgNo[12];
				monster[i].imgNoWalkRight2 = monsterImgNo[12];
				monster[i].imgNoDeadLeft = monsterImgNo[12];
				monster[i].imgNoDeadRight = monsterImgNo[12];

				//壁
				i = 1;
				monster[i].x = 640 - 96;
				monster[i].y = 480 - 32 - 96;
				monster[i].hp = int.MAX_VALUE;
				monster[i].imgNoWalkLeft1 = monsterImgNo[11];
				monster[i].imgNoWalkLeft2 = monsterImgNo[11];
				monster[i].imgNoWalkRight1 = monsterImgNo[11];
				monster[i].imgNoWalkRight2 = monsterImgNo[11];
				monster[i].imgNoDeadLeft = monsterImgNo[11];
				monster[i].imgNoDeadRight = monsterImgNo[11];
				monster[i].isEnemy = false;
				monster[i].isBmpHit = true;
				monster[i].isVanish = false;

				//空描画
				drawSky();
				//テキスト設定
				setEndTextTanren();

				//背景描画
				jimenData   = Vector.<int>([20,20,20,10,10, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,10,10,20,20,20]);
				haikeiData  = Vector.<int>([23,-1,-1,-1,-1,-1,22,14,15, 7,-1,21,-1, 7,-1,-1,-1,-1]);
				haikeiData2 = Vector.<int>([-1,-1,-1,-1,66,66,66,66,66,66,66,66,66,66,66,66,-1,-1,-1,-1]);
				drawBackground(jimenData, haikeiData, haikeiData2);
			}
			else if (scenario.no == Scenario.SHIKA)
			{
				//通常弓
				shootArrowCnt.value = 1;
				maxPower = Arrow.MAX_POWER;
				addPowerValue = maxPower / Global.FPS;

				//背景描画
				haikeiData  = Vector.<int>([67,67,67,66,67,66,66,67,66,66,66,67,66,66,67,66,66,66,66,66]);
				haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
				haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,61]);
				drawBackground(null, haikeiData, haikeiData2, haikeiData3);
				
				//敵設定
				for (i = 0; i < 3; i++)
				{
					//monster[i].x = 500 + (int)(Math.random() * 100);
					monster[i].x = 500 + mt.getRandInt(100);
					monster[i].y = 480 - 32 - 32/2
					monster[i].hp = 1;
					monster[i].moveValX = 1;
					monster[i].isNowMove = true;
					monster[i].hitRange = 16;
					monster[i].imgNoWalkLeft1 = 1;
					monster[i].imgNoWalkLeft2 = 2;
					monster[i].imgNoWalkRight1 = 3;
					monster[i].imgNoWalkRight2 = 4;
					monster[i].imgNoDeadLeft = 5;
					monster[i].imgNoDeadRight = 6;
					monster[i].turnRate = 32;
					monster[i].minX = 320;
					monster[i].maxX = 640 - 32;
					monster[i].isDieFall = true;
				}
				
				//空描画
				drawDarkSky();
				//テキスト設定
				setEndTextEnshu();
			}
			else if (scenario.no == Scenario.YAMADORI)
			{
				//通常弓
				shootArrowCnt.value = 1;
				maxPower = Arrow.MAX_POWER;
				addPowerValue = maxPower / Global.FPS;

				//背景描画
				haikeiData  = Vector.<int>([67,66,67,67,67,66,67,67,66,67,67,67,66,67,66,66,67,67,66,66]);
				haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
				haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,61]);
				drawBackground(null, haikeiData, haikeiData2, haikeiData3);

				//敵設定
				for (i = 0; i < 3; i++)
				{
					//monster[i].x = 500 + (int)(Math.random() * 100);
					monster[i].x = 500 + mt.getRandInt(100);
					monster[i].y = 240 + i * 32;//200 + i * 32;
					monster[i].hp = 1;
					monster[i].moveValX = 2;
					monster[i].isNowMove = true;
					monster[i].hitRange = 12;
					monster[i].imgNoWalkLeft1 = 7;
					monster[i].imgNoWalkLeft2 = 8;
					monster[i].imgNoWalkRight1 = 9;
					monster[i].imgNoWalkRight2 = 10;
					monster[i].imgNoDeadLeft = 11;
					monster[i].imgNoDeadRight = 12;
					monster[i].turnRate = 64;
					monster[i].minX = 160;
					monster[i].maxX = 640 - 32;
					monster[i].isDieFall = true;
				}

				//空描画
				drawDarkSky();
				//テキスト設定
				setEndTextEnshu();
			}
			else if (scenario.no == Scenario.YOICHI)
			{
				//通常弓
				shootArrowCnt.value = 1;
				maxPower = Arrow.MAX_POWER;
				addPowerValue = maxPower / Global.FPS;

				//背景描画
				jimenData  = Vector.<int>([18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18]);
				haikeiData = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,17]);
				drawBackground(jimenData, haikeiData);

				myArcher.addInitXY(16, 2);

				idx = 57;
				image[idx].x = 0;
				image[idx].y = (480 - 48 + 4) / 2;
				image[idx].scaleX = 1;
				image[idx].scaleY = 1;
				renderTextureFixed.draw(image[idx]);
				
				//敵設定
				for (i = 0; i < 1; i++)
				{
					monster[i].x = 522 - 7 - 20;
					monster[i].y = 480 - 96 + 16 - 7;
					monster[i].hp = 1;
					monster[i].isNowMove = true;
					monster[i].hitRange = 8;
					monster[i].imgNoWalkLeft1 = 13;
					monster[i].imgNoWalkLeft2 = 13;
					monster[i].imgNoWalkRight1 = 13;
					monster[i].imgNoWalkRight2 = 13;
					monster[i].imgNoDeadLeft = 13;
					monster[i].imgNoDeadRight = 13;
					monster[i].turnRate = 64;
					monster[i].minX = 0;
					monster[i].maxX = 640 - 32;
					monster[i].isDieFall = true;
				}

				//空描画
				drawDarkSky();
				//テキスト設定
				setEndTextEnshu();
			}
			else if (scenario.no == Scenario.TAMETOMO)
			{
				//強弓
				shootArrowCnt.value = 1;
				//maxPower = 2 * Arrow.MAX_POWER;
				maxPower = 1.5 * Arrow.MAX_POWER;
				addPowerValue = maxPower / Global.FPS;

				myArcher.addInitXY(48, 0);

				//背景描画
				jimenData   = Vector.<int>([63,63,63,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]);
				haikeiData  = Vector.<int>([-1,-1,-1,-1,67,67,67,67,-1,67,67,67,-1,67,67,-1,-1,67,-1,67]);
				haikeiData2 = Vector.<int>([62,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]);
				drawBackground(jimenData, haikeiData, haikeiData2);
				
				//敵設定
				for (i = 0; i < 6; i++)
				{
					monster[i].x = 400 + i * 48
					monster[i].y = 480 - 32 - 32/2
					monster[i].hp = 1;
					monster[i].moveValX = 1;
					monster[i].isNowMove = true;
					monster[i].hitRange = 16;
					monster[i].imgNoWalkLeft1 = 14;
					monster[i].imgNoWalkLeft2 = 15;
					//monster[i].imgNoWalkRight1 = 16;
					//monster[i].imgNoWalkRight2 = 17;
					monster[i].imgNoDeadLeft = 18;
					//monster[i].imgNoDeadRight = 19;
					monster[i].turnRate = -1;
					monster[i].minX = -64;
					monster[i].maxX = 640 - 32;
					monster[i].isDieFall = true;
				}

				//空描画
				drawDarkSky();
				//テキスト設定
				setEndTextEnshu();
			}
			else if (scenario.no == Scenario.TELL)
			{
				//通常弓
				shootArrowCnt.value = 1;
				maxPower = Arrow.MAX_POWER;
				addPowerValue = maxPower / Global.FPS;

				//背景描画
				//haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,67,66,67,66,67]);
				haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,67,67,67,66,67,66,67]);
				haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16]);
				drawBackground(null, haikeiData, haikeiData2);

				//敵設定
				//りんご
				i = 2;
				monster[i].x = 360 + 1;
				monster[i].y = 480 - 16 - 56;
				monster[i].hp = 1;
				monster[i].hitRange = 8;
				monster[i].imgNoWalkLeft1 = 22;
				monster[i].imgNoWalkLeft2 = 22;
				monster[i].imgNoWalkRight1 = 22;
				monster[i].imgNoWalkRight2 = 22;
				monster[i].imgNoDeadLeft = 22;
				monster[i].imgNoDeadRight = 22;
				monster[i].isDieFall = true;

				//人
				i = 1;
				monster[i].x = 360;
				monster[i].y = 480 - 16 - 32;
				monster[i].hp = 1;
				monster[i].hitRange = 16;
				monster[i].imgNoWalkLeft1 = 23;
				monster[i].imgNoWalkLeft2 = 23;
				monster[i].imgNoWalkRight1 = 23;
				monster[i].imgNoWalkRight2 = 23;
				monster[i].imgNoDeadLeft = 23;
				monster[i].imgNoDeadRight = 23;
				monster[i].isEnemy = false;
				monster[i].isNGHit = true;
				monster[i].isDieFall = false;
				monster[i].isVanish = false;

				//木
				i = 0;
				monster[i].x = 360 - 16;
				monster[i].y = 480 - 32 - 96;
				monster[i].hp = 100;
				monster[i].hitRange = 16;
				monster[i].imgNoWalkLeft1 = 24;
				monster[i].imgNoWalkLeft2 = 24;
				monster[i].imgNoWalkRight1 = 24;
				monster[i].imgNoWalkRight2 = 24;
				monster[i].imgNoDeadLeft = 24;
				monster[i].imgNoDeadRight = 24;
				monster[i].isEnemy = false;
				monster[i].hitRect.width = Arrow.MAX_POWER;
				monster[i].hitRect.height = 96;
				monster[i].hitRect.x = 32;
				//monster[i].hitRect.y = monster[i].y - monster[i].hitRect.height / 2 + 4;
				monster[i].isVanish = false;
				monster[i].isNoCount = true;

				//空描画
				drawDarkSky();
				//テキスト設定
				setEndTextEnshu();
			}
/*
			else if (scenario.no == Scenario.RAM)
			{
//TEST
shootArrowCnt = 32;
maxPower = 2 * Arrow.MAX_POWER;

				//敵設定
				for (i = 0; i < monster.length; i++)
				{
					monster[i].x = 320 + (int)(i * 64 - Math.random() * 32) % 320;
					monster[i].y = -1 * (i % 8) * 32;//-1 * Math.random() * 160; 
					monster[i].hp = 1;
					monster[i].moveValX = 1;
					monster[i].moveValY = 2;
					monster[i].isNowMove = true;
					monster[i].hitRange = 16;
					monster[i].imgNoWalkLeft1 = 20;
					monster[i].imgNoWalkLeft2 = 20;
					monster[i].imgNoWalkRight1 = 20;
					monster[i].imgNoWalkRight2 = 20;
					monster[i].imgNoDeadLeft = 21;
					monster[i].imgNoDeadRight = 21;
					monster[i].turnRate = -1;
					monster[i].minX = 0;
					monster[i].maxX = 640 - 32;
					monster[i].minY = 0;
					monster[i].maxY = 480 - 32;
				}

				//空描画
				drawSky();
			}
*/
			else if (scenario.no == Scenario.ONLINE_TEST)
			{
				//破魔弓
				setHamayumi();

				var mikanX:Vector.<int> = Vector.<int>([1,2,3,4,5,6,7,8,9, 2,3,4,5,6,7,8, 3,4,5,6,7, 4,5,6, 5]);
				var mikanY:Vector.<int> = Vector.<int>([0,0,0,0,0,0,0,0,0, 1,1,1,1,1,1,1, 2,2,2,2,2, 3,3,3, 4]);
				for (i = 0; i < mikanX.length; i++)
				{
					monster[i].x = 320 + mikanX[i] * 32;
					monster[i].y = 480 - 16 - (mikanY[i] + 1) * 32;
					monster[i].hp = 10;
					monster[i].hitRange = 16;
					monster[i].imgNoWalkLeft1 = 0;
					monster[i].imgNoWalkLeft2 = 0;
					monster[i].imgNoWalkRight1 = 0;
					monster[i].imgNoWalkRight2 = 0;
					monster[i].imgNoDeadLeft = 0;
					monster[i].imgNoDeadRight = 0;
				}

				//空描画
				drawDarkSky();
				//テキスト設定
				setEndTextEnshu();
			}
			else if (scenario.no == Scenario.TOOSHIYA)
			{
				//通常弓
				shootArrowCnt.value = 1;
				maxPower = Arrow.MAX_POWER;
				addPowerValue = maxPower / Global.FPS;

				//射手向き
				archer[0].initSoloRight();
				//射出位置
				myArcher.addInitXY(610, -32);
				//時間
				remainTime = 30 * Global.FPS;

				/*
				//背景描画
				jimenData  = Vector.<int>([ 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9]);
				haikeiData = Vector.<int>([46,47,47,47,47,47,47,47,47,48,49,47,47,47,47,47,47,47,47,50]);
				drawBackground(jimenData, haikeiData);
				*/

				//敵設定
//当たり判定用bmp作成
makeHitBmp(55);
				for (i = 0; i < 1; i++)
				{
					monster[i].x = 8;
					monster[i].y = 480 - 88; 
					monster[i].hp = 5;
					//monster[i].hitRange = 7;
					/*
					monster[i].hitRect.width = 7 * 2;
					monster[i].hitRect.height = 10 * 2;
					monster[i].hitRect.x = 1;
					monster[i].hitRect.y = 1;
					*/
					monster[i].isBmpHit = true;
					
					monster[i].imgNoWalkLeft1 = monsterImgNo[55];
					monster[i].imgNoWalkLeft2 = monsterImgNo[55];
					monster[i].imgNoWalkRight1 = monsterImgNo[55];
					monster[i].imgNoWalkRight2 = monsterImgNo[55];
					monster[i].imgNoDeadLeft = monsterImgNo[55];
					monster[i].imgNoDeadRight = monsterImgNo[55];
				}

				//背景描画
				jimenData  = Vector.<int>([ 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9]);
				haikeiData = Vector.<int>([46,47,47,47,47,47,47,47,47,48,49,47,47,47,47,47,47,47,47,50]);
				drawBackground(jimenData, haikeiData);
				
				//空描画
				drawSky();
				//テキスト設定
				setEndTextTanren();
			}
			else if (scenario.no == Scenario.YABUSAME)
			{
				//通常弓
				shootArrowCnt.value = 1;
				maxPower = Arrow.MAX_POWER;
				addPowerValue = maxPower / Global.FPS;

				//射出位置
				myArcher.addInitXY(0, -16);
				//馬
				myArcher.enabledUma(true);

				//馬拡大率設定
				image[56].scaleX = 2;
				image[56].scaleY = 2;
				image[57].scaleX = 2;
				image[57].scaleY = 2;
				image[58].scaleX = 2;
				image[58].scaleY = 2;

				//背景描画
				//haikeiData = Vector.<int>([21,-1, 7,-1,21,-1, 7,-1,21,-1, 7,-1,21,-1, 7,-1,21,-1, 7]);
				haikeiData  = Vector.<int>([21,-1, 7,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]);
				haikeiData2 = Vector.<int>([66,66,66,66,67,67,67,67,67,-1,-1,67,67,-1,-1,67,67,-1,-1,67]);
				drawBackground(null, haikeiData, haikeiData2);

				//敵設定
				//i = 1;
				for (k = 0; k < 3; k++)
				{
					i = k * 2;
					monster[i].isEnemy = false;
					monster[i].x = 320 + k * 128;
					monster[i].y = 480 - 42; 
					monster[i].hp = 100;
					monster[i].hitRange = 0;
					monster[i].hitRect.width = 1;
					monster[i].hitRect.height = 16;
					monster[i].hitRect.x = monster[i].x;
					monster[i].hitRect.y = monster[i].y;
					monster[i].imgNoWalkLeft1 = monsterImgNo[60];
					monster[i].imgNoWalkLeft2 = monsterImgNo[60];
					monster[i].imgNoWalkRight1 = monsterImgNo[60];
					monster[i].imgNoWalkRight2 = monsterImgNo[60];
					monster[i].imgNoDeadLeft = monsterImgNo[60];
					monster[i].imgNoDeadRight = monsterImgNo[60];

					i = k * 2 + 1;
					monster[i].x = 320 + k * 128;
					monster[i].y = 480 - 64; 
					monster[i].hp = 1;
					monster[i].hitRange = 8;
					monster[i].hitRect.width = 0;
					monster[i].hitRect.height = 0;
					monster[i].hitRect.x = monster[i].x;
					monster[i].hitRect.y = monster[i].y;
					monster[i].imgNoWalkLeft1 = monsterImgNo[59];
					monster[i].imgNoWalkLeft2 = monsterImgNo[59];
					monster[i].imgNoWalkRight1 = monsterImgNo[59];
					monster[i].imgNoWalkRight2 = monsterImgNo[59];
					monster[i].imgNoDeadLeft = monsterImgNo[59];
					monster[i].imgNoDeadRight = monsterImgNo[59];
					monster[i].isDieFall = true;
				}

				//空描画
				drawSky();
				//テキスト設定
				setEndTextTanren();
			}
			else if (scenario.no == Scenario.MUKADE)
			{
				//破魔弓
				setHamayumi();

				remainTime = 120 * Global.FPS;

				for (i = 0; i < archer.length; i++)
				{
					archer[i].initCoop(i);
				}


				//矢倉設定
				yagura.init(true, 5);

				//モンスター設定
				//当たり判定用bmp作成
				makeHitBmp(119);
				//大百足 頭
				i = 0;
				monster[i].x = 640 + 4;
				monster[i].y = 480 - 32 - monsterImage[monsterImgNo[64]].height + 12;
				monster[i].hp = 100;
				monster[i].hitRect.width = 8 * monsterImage[monsterImgNo[118]].scaleX;
				monster[i].hitRect.height = 6 * monsterImage[monsterImgNo[118]].scaleY;
				monster[i].imgNoWalkLeft1 = monsterImgNo[118];
				monster[i].imgNoWalkLeft2 = monsterImgNo[118];
				monster[i].imgNoWalkRight1 = monsterImgNo[118];
				monster[i].imgNoWalkRight2 = monsterImgNo[118];
				monster[i].imgNoDeadLeft = monsterImgNo[118];
				monster[i].imgNoDeadRight = monsterImgNo[118];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				monster[i].moveValX = -1;
				monster[i].minX = 480 + 4;
				monster[i].isBmpHit = false;
				monster[i].isReflect = false;
				monster[i].isDieFall = true;

				i = 1;
				monster[i].x = 640;
				monster[i].y = 480 - 32 - monsterImage[monsterImgNo[64]].height;
				monster[i].hp = 1;
				monster[i].imgNoWalkLeft1 = monsterImgNo[64];
				monster[i].imgNoWalkLeft2 = monsterImgNo[65];
				monster[i].imgNoWalkRight1 = monsterImgNo[64];
				monster[i].imgNoWalkRight2 = monsterImgNo[65];
				monster[i].imgNoDeadLeft = monsterImgNo[64];
				monster[i].imgNoDeadRight = monsterImgNo[65];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				monster[i].moveValX = -1;
				monster[i].minX = 480;
				monster[i].isEnemy = false;
				monster[i].isBmpHit = true;
				monster[i].isReflect = true;
				monster[i].isDieFall = true;
monster[i].bodyIdx = 0;

//flashStage.addChild(bmpForHit);

				//敵（弾）
				i = 2;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				//monster[i].x = 480;
				//monster[i].y = 480 - 32 - monsterImage[monsterImgNo[64]].height + 64;
				//monster[i].hp = 0;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];

				monster[i].moveValX = 3;
				monster[i].moveValY = 0.9;//1;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].vdir = Monster.VDIR_DOWN;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				monster[i].isMissile = true;
				//monster[i].missileX = monster[i].x;
				//monster[i].missileY = monster[i].y;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 24;
				monster[i].missileHP = 3;//monster[i].hp;
				monster[i].startShootFrameCnt = Global.FPS * 10;
				monster[i].shootInterval = Global.FPS * 10;
				monster[i].shooterIdx = 0;
				monster[i].isDieFall = true;

monster[i].movePattern = Monster.MOVE_FALL;
monster[i].missilePower = -8;
monster[i].moveValX = 4.5;
monster[i].fallValue = 0.2;
monster[i].power = monster[i].missilePower;


				//背景描画
				haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,61]);
				haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
				haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
				drawBackground(null, haikeiData, haikeiData2, haikeiData3);

				//空描画
				drawPurpleSky();
				//テキスト設定
				setEndTextJissen();
			}
			else if (scenario.no == Scenario.ONIBI)
			{
				//破魔弓
				setHamayumi();
				
				//--------
				for (i = 0; i < archer.length; i++)
				{
					archer[i].initCoop(i);
				}

				//矢倉設定
				yagura.init(true, 5);

				//var mikanX:Vector.<int> = Vector.<int>([1,2,3,4,5,6,7, 2,3,4,5,6, 3,4,5, 4]);
				//var mikanY:Vector.<int> = Vector.<int>([0,0,0,0,0,0,0, 1,1,1,1,1, 2,2,2, 3]);
				var onibiX:Vector.<int> = Vector.<int>([1,2,3,4,5, 1,2,3,4,5, 2,3,4, 3]);
				var onibiY:Vector.<int> = Vector.<int>([0,0,0,0,0, 1,1,1,1,1, 2,2,2, 3]);
				for (i = 0; i < onibiX.length; i++)
				{
					monster[i].x = 300 + onibiX[i] * 32;
					monster[i].y = 480 - 16 - (onibiY[i] + 1) * 32;
					monster[i].hp = 3;
					//monster[i].hitRange = 16;
					monster[i].hitRange = 12;
					monster[i].imgNoWalkLeft1 = monsterImgNo[85];
					monster[i].imgNoWalkLeft2 = monsterImgNo[86];
					monster[i].imgNoWalkRight1 = monsterImgNo[85];
					monster[i].imgNoWalkRight2 = monsterImgNo[86];
					monster[i].imgNoDeadLeft = monsterImgNo[85];
					monster[i].imgNoDeadRight = monsterImgNo[86];
					monster[i].isDieFall = true;
				}

				//背景描画
				//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
				haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
				drawBackground(null, haikeiData, null, null);

				//空描画
				drawPurpleSky();
				//テキスト設定
				setEndTextJissen();
			}
			else if (scenario.no == Scenario.ONI)
			{
				//破魔弓
				setHamayumi();

				remainTime = 90 * Global.FPS;

				for (i = 0; i < archer.length; i++)
				{
					archer[i].initCoop(i);
				}

				//矢倉設定
				yagura.init(true, 5);

				//モンスター設定
				//盾
				i = 0;
				monster[i].x = 640 + i * 32 + 6;
				monster[i].y = 480 - 32 - monsterImage[monsterImgNo[105]].height;
				monster[i].hp = 50;
				monster[i].moveValX = 1;
				monster[i].hitRect.width = monsterImage[monsterImgNo[105]].width;
				monster[i].hitRect.height = monsterImage[monsterImgNo[105]].height;
				//monster[i].hitRect.x = monster[i].x;
				//monster[i].hitRect.y = monster[i].y;
				monster[i].imgNoWalkLeft1 = monsterImgNo[105];
				monster[i].imgNoWalkLeft2 = monsterImgNo[105];
				monster[i].imgNoWalkRight1 = monsterImgNo[105];
				monster[i].imgNoWalkRight2 = monsterImgNo[105];
				monster[i].imgNoDeadLeft = monsterImgNo[105];
				monster[i].imgNoDeadRight = monsterImgNo[105];
				monster[i].minX = -64;
				monster[i].isDieFall = true;
				monster[i].bodyIdx = 1;

				//盾持ち
				i = 1;
				monster[i].x = 640 + i * 32;
				monster[i].y = 480 - 32 - 16;
				monster[i].hp = 10;
				monster[i].moveValX = 1;

				//monster[i].hitRange = 16;
				monster[i].hitRect.width = 8 * 2;
				monster[i].hitRect.height = 16 * 2;
				monster[i].hitRect.x = -16 + 2;
				monster[i].hitRect.y = -16;

				monster[i].imgNoWalkLeft1 = monsterImgNo[103];
				monster[i].imgNoWalkLeft2 = monsterImgNo[104];
				monster[i].imgNoWalkRight1 = monsterImgNo[103];
				monster[i].imgNoWalkRight2 = monsterImgNo[104];
				monster[i].imgNoDeadLeft = monsterImgNo[103];
				monster[i].imgNoDeadRight = monsterImgNo[104];
				monster[i].minX = -64;
				monster[i].isDieFall = true;

				//通常鬼
				for (i = 2; i < 11; i++)
				{
					monster[i].x = 640 + i * 32;
					monster[i].y = 480 - 32 - 16;
					monster[i].hp = 10;
					monster[i].moveValX = 1;
					
					//monster[i].hitRange = 16;
					monster[i].hitRect.width = 8 * 2;
					monster[i].hitRect.height = 16 * 2;
					monster[i].hitRect.x = -16 + 8;
					monster[i].hitRect.y = -16;
					
					monster[i].imgNoWalkLeft1 = monsterImgNo[87];
					monster[i].imgNoWalkLeft2 = monsterImgNo[88];
					monster[i].imgNoWalkRight1 = monsterImgNo[87];
					monster[i].imgNoWalkRight2 = monsterImgNo[88];
					monster[i].imgNoDeadLeft = monsterImgNo[87];
					monster[i].imgNoDeadRight = monsterImgNo[88];
					monster[i].minX = -64;
					monster[i].isDieFall = true;
				}


				//背景描画
				haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
				drawBackground(null, haikeiData, haikeiData2, haikeiData3);

				//空描画
				drawPurpleSky();
				//テキスト設定
				setEndTextJissen();
			}
			else if (scenario.no == Scenario.TUCHIGUMO)
			{
				//破魔弓
				setHamayumi();

				remainTime = 120 * Global.FPS;

				for (i = 0; i < archer.length; i++)
				{
					archer[i].initCoop(i);
				}

				//矢倉設定
				yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(106);

				//モンスター設定
				i = 0;
				monster[i].x = 360;//640;
				monster[i].y = (480 - 32 - monsterImage[monsterImgNo[106]].height) - 8 * 60;
				monster[i].hp = 200;
				monster[i].imgNoWalkLeft1 = monsterImgNo[106];
				monster[i].imgNoWalkLeft2 = monsterImgNo[107];
				monster[i].imgNoWalkRight1 = monsterImgNo[106];
				monster[i].imgNoWalkRight2 = monsterImgNo[107];
				monster[i].imgNoDeadLeft = monsterImgNo[106];
				monster[i].imgNoDeadRight = monsterImgNo[107];
				monster[i].movePattern = Monster.MOVE_DOWN_STOP;
				monster[i].moveValY = 8;
				monster[i].minY = -1;
				monster[i].maxY = 480 - 32 - monsterImage[monsterImgNo[106]].height;
				monster[i].isBmpHit = true;
				monster[i].isNowMove = false;
				monster[i].isDieFall = true;

//flashStage.addChild(bmpForHit);

				//敵（防御弾）
				//i = 1;
				for (i = 1; i < 10; i++)
				{
					idx = 108;
					idx2 = 109;
					//monster[i].x = 360 + 32;
					//monster[i].y = 480 - 32 - 16 - 8;
					//monster[i].hp = 0;//100;
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoWalkRight1 = monsterImgNo[idx];
					monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx];
					monster[i].imgNoDeadRight = monsterImgNo[idx2];
					monster[i].movePattern = Monster.MOVE_FALL;
					//monster[i].moveInterval = Global.halfFPS;
					monster[i].moveValX = 2;
					monster[i].moveValY = 0;
					monster[i].minX = 64;
					monster[i].maxX = monster[i].x;
					monster[i].minY = monster[i].y;
					monster[i].maxY = 480 - 32 - 16;
					monster[i].hitRange = 16;
					monster[i].isEnemy = false;
					monster[i].isMissile = true;
					//monster[i].missileX = monster[i].x;
					//monster[i].missileY = monster[i].y;
					monster[i].missilePlusX = 32;
					monster[i].missilePlusY = 96;
					monster[i].missileHP = 100;//monster[i].hp;
					monster[i].missilePower = -8;
					monster[i].fallValue = 0.2;
					monster[i].power = monster[i].missilePower;
					monster[i].startShootFrameCnt = Global.FPS * 3 + Global.FPS * i;
					monster[i].isNowMove = false;
					monster[i].isHitEachOther = true;
					monster[i].shooterIdx = 0;
					monster[i].isDieFall = true;
					monster[i].isShootSound = false;
				}

				i = 10;
				idx = 110;
				idx2 = 111;
				//monster[i].x = 360 + 32;
				//monster[i].y = 480 - 32 - 16 - 8;
				//monster[i].hp = 0;	//弾非表示はhp0
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				//monster[i].moveInterval = Global.halfFPS;
				monster[i].moveValX = 5;//3;
				monster[i].moveValY = 0;
				monster[i].minX = 0;
				monster[i].maxX = monster[i].x;
				monster[i].minY = monster[i].y;
				monster[i].maxY = 480;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				monster[i].isMissile = true;
				//monster[i].missileX = monster[i].x;
				//monster[i].missileY = monster[i].y;
				monster[i].missilePlusX = 32;
				monster[i].missilePlusY = 96;
				monster[i].missileHP = 10;//monster[i].hp;
				monster[i].startShootFrameCnt = Global.FPS * 15;
				monster[i].shootInterval = Global.FPS * 10;
				monster[i].shooterIdx = 0;
				monster[i].isDieFall = true;

				//背景描画
				haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,61]);
				haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
				haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
				drawBackground(null, haikeiData, haikeiData2, haikeiData3);

				//空描画
				drawPurpleSky();
				//テキスト設定
				setEndTextJissen();
			}
			else if (scenario.no == Scenario.ONI3)
			{
				//破魔弓
				setHamayumi();

				remainTime = 120 * Global.FPS;

				for (i = 0; i < archer.length; i++)
				{
					archer[i].initCoop(i);
				}

				//矢倉設定
				yagura.init(true, 5);

				//モンスター設定
				i = 0;
				idx = 112;
				idx2 = 113;
				monster[i].x = 960;//400;
				monster[i].y = 432 - 240;
				monster[i].hp = 50;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				
				//monster[i].hitRange = 16;
				monster[i].hitRect.width = 8 * 2;
				monster[i].hitRect.height = 16 * 2;
				monster[i].hitRect.x = -16 + 8;
				monster[i].hitRect.y = -16;
				
				monster[i].moveValX = -2;
				monster[i].minX = 240;
				monster[i].maxX = 640 - 32;
				monster[i].isDieFall = true;

				i = 1;
				idx = 114;
				idx2 = 115;
				monster[i].x = 800;
				monster[i].y = 432 - 32;
				monster[i].hp = 50;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				
				//monster[i].hitRange = 16;
				monster[i].hitRect.width = 8 * 2;
				monster[i].hitRect.height = 16 * 2;
				monster[i].hitRect.x = -16 + 8;
				monster[i].hitRect.y = -16;
				
				monster[i].moveValX = -2;
				monster[i].minX = 480;
				monster[i].maxX = 640 - 32;
				monster[i].isDieFall = true;

				i = 2;
				idx = 116;
				idx2 = 117;
				monster[i].x = 640;
				monster[i].y = 432
				monster[i].hp = 50;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;

				//monster[i].hitRange = 16;
				monster[i].hitRect.width = 8 * 2;
				monster[i].hitRect.height = 16 * 2;
				monster[i].hitRect.x = -16 + 8;
				monster[i].hitRect.y = -16;
				
				monster[i].moveValX = -2;
				monster[i].minX = 400;
				monster[i].maxX = 640 - 32;
				monster[i].isDieFall = true;

				//敵（雨弾）
				for (k = 0; k < 16; k++)
				{
					i = k + 3;
					idx  = 122;
					idx2 = 123;
					//monster[i].x = monster[0].minX;
					//monster[i].y = monster[0].y + 24;
					//monster[i].hp = 0;	//発射中にhpが設定される
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoWalkRight1 = monsterImgNo[idx];
					monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx];
					monster[i].imgNoDeadRight = monsterImgNo[idx2];
					monster[i].movePattern = Monster.MOVE_DOWN_STOP;
					//monster[i].moveInterval = Global.halfFPS;
					monster[i].moveValY = 4;
					monster[i].minY = 0;
					monster[i].maxY = 480;
					monster[i].hitRange = 16;
					monster[i].isEnemy = false;
					monster[i].isMissile = true;
					//monster[i].missileX = monster[i].x;
					//monster[i].missileY = monster[i].y;
					monster[i].missilePlusX = 0;
					monster[i].missilePlusY = 32;
					monster[i].missileHP = 30;
					monster[i].startShootFrameCnt = Global.FPS * 16 + Global.halfFPS * k;
					monster[i].shootInterval = Global.FPS * 8;
					monster[i].shooterIdx = 0;
					monster[i].isDieFall = true;
					monster[i].isShootSound = false;
				}

				//敵（風弾）
				for (k = 0; k < 16; k++)
				{
					i = k + 19;
					idx  = 120;
					idx2 = 121;
					//monster[i].x = monster[1].minX - 24;
					//monster[i].y = monster[1].y;
					//monster[i].hp = 0;	//発射中にhpが設定される
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoWalkRight1 = monsterImgNo[idx];
					monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx];
					monster[i].imgNoDeadRight = monsterImgNo[idx2];
					monster[i].movePattern = Monster.MOVE_LEFT_VANISH;
					//monster[i].moveInterval = Global.halfFPS;
					monster[i].moveValX = -4;
					monster[i].minX = 200;
					monster[i].maxX = 480;
					monster[i].hitRange = 16;
					monster[i].isEnemy = false;
					monster[i].isMissile = true;
					//monster[i].missileX = monster[i].x;
					//monster[i].missileY = monster[i].y;
					monster[i].missilePlusX = -32;
					monster[i].missilePlusY = 0;
					monster[i].missileHP = 30;
					monster[i].startShootFrameCnt = Global.FPS * 7 + Global.halfFPS * k;
					monster[i].shootInterval = Global.FPS * 8;
					monster[i].shooterIdx = 1;
					monster[i].isDieFall = true;
					monster[i].isShootSound = false;
				}

				//敵（炎弾）
				i = 35;
				idx = 124;
				idx2 = 125;
				//monster[i].x = monster[2].minX - 24;
				//monster[i].y = monster[2].y;
				//monster[i].hp = 0;	//発射中にhpが設定される
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				//monster[i].moveInterval = Global.halfFPS;
				monster[i].moveValX = -3;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				monster[i].isMissile = true;
				//monster[i].missileX = monster[i].x;
				//monster[i].missileY = monster[i].y;
				monster[i].missilePlusX = -32;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 15;
				monster[i].startShootFrameCnt = Global.FPS * 10;
				monster[i].shootInterval = Global.FPS * 15;
				monster[i].shooterIdx = 2;
				monster[i].isDieFall = true;

				//背景描画
				haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,61]);
				haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
				haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
				drawBackground(null, haikeiData, haikeiData2, haikeiData3);

				//空描画
				drawPurpleSky();
				//テキスト設定
				setEndTextJissen();
			}
			else if (scenario.no == Scenario.SHUTENDOUJI)
			{
				//破魔弓
				setHamayumi();

				remainTime = 120 * Global.FPS;

				for (i = 0; i < archer.length; i++)
				{
					archer[i].initCoop(i);
				}

				//矢倉設定
				yagura.init(true, 5);

				//モンスター設定
				//防御用の木
				i = 0;
				idx = 16;
				monster[i].x = 640 - 38;
				monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
				monster[i].hp = 100;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx];
				monster[i].imgChangeInterval = Global.halfFPS;
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				monster[i].minX = 480 - 38;
				monster[i].moveValX = -1;
				//monster[i].isBmpHit = true;
				//monster[i].isEnemy = false;
				monster[i].hitRect.x = 13 * 2;
				monster[i].hitRect.y = 1 * 2;
				monster[i].hitRect.width = 6 * 2;
				monster[i].hitRect.height = 47 * 2;
				monster[i].isDieFall = true;

				//--------
				//敵
				i = 1;
				idx = 126;
				idx2 = 127;
				idx3 = 129;
				idx4 = 128;
				monster[i].x = 640;
				monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
				monster[i].hp = 300;
				monster[i].hitRect.width = 12 * 2;
				monster[i].hitRect.height = 40 * 2;
				monster[i].hitRect.x = 16 * 2;
				monster[i].hitRect.y = 2 * 2;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx4];
				monster[i].imgNoDeadRight = monsterImgNo[idx4];
				monster[i].imgChangeInterval = Global.halfFPS;
				monster[i].imgNoWalkLeft3 = monsterImgNo[idx3];
				monster[i].imgNoWalkLeft4 = monsterImgNo[idx4];
				monster[i].imgNoWalkRight3 = monsterImgNo[idx3];
				monster[i].imgNoWalkRight4 = monsterImgNo[idx4];
				monster[i].imgChangeInterval2 = Global.FPS * 6 / 2;
				monster[i].movePattern = Monster.MOVE_LEFT_STOP_CHANGE;
				monster[i].minX = 480;
				monster[i].moveValX = -1;
				monster[i].isDieFall = true;
				//monster[i].minY = monster[i].y;
				//monster[i].maxY = monster[i].y + 2;
				//monster[i].isBmpHit = true;

//flashStage.addChild(bmpForHit);

				//--------
				//矢
				i = 2
				idx = 130;
				//monster[i].x = 480;
				//monster[i].y = 480 - 60;
				//monster[i].hp = 0;	//弾非表示はhp0
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				//monster[i].moveInterval = Global.halfFPS;
				monster[i].moveValX = -8;//3;
				monster[i].moveValY = 0;
				monster[i].minX = -64;
				monster[i].maxX = monster[i].x;
				monster[i].hitRect.width = 64;
				monster[i].hitRect.height = 4;
				monster[i].isEnemy = false;
				monster[i].isMissile = true;
				//monster[i].missileX = monster[i].x;
				//monster[i].missileY = monster[i].y;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 38;
				monster[i].missileHP = 5;//monster[i].hp;
				monster[i].startShootFrameCnt = Global.FPS * 12;
				monster[i].shootInterval = Global.FPS * 6;
				monster[i].shooterIdx = 1;
				monster[i].isDieFall = true;

				//背景描画
				haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,61]);
				//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
				haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
				drawBackground(null, haikeiData, null, haikeiData3);

				//空描画
				drawPurpleSky();
				//テキスト設定
				setEndTextJissen();
			}
			else if (scenario.no == Scenario.DAIJA)
			{
				//破魔弓
				setHamayumi();

				remainTime = 120 * Global.FPS;

				for (i = 0; i < archer.length; i++)
				{
					archer[i].initCoop(i);
				}

				//矢倉設定
				yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(133);


				//モンスター設定
				i = 0;
				idx  = 131;
				idx2 = 132;
				monster[i].x = 640;
				monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
				monster[i].hp = 300;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				monster[i].minX = 280;
				monster[i].moveValX = -1;
				//monster[i].minY = monster[i].y;
				//monster[i].maxY = monster[i].y + 2;
				monster[i].isBmpHit = true;
				monster[i].isDieFall = true;

				//--------
				i = 1;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_NORMAL;
				monster[i].moveValX = 4;//3;
				monster[i].moveValY = 0.5;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				monster[i].isMissile = true;
				monster[i].missilePlusX = 32;
				monster[i].missilePlusY = 32;//i * 32 - 64;
				monster[i].missileHP = 3;//monster[i].hp;
				monster[i].startShootFrameCnt = Global.FPS * 15;
				monster[i].shootInterval = Global.FPS * 10;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;

monster[i].movePattern = Monster.MOVE_FALL;
monster[i].missilePower = -8;
monster[i].moveValX = 3;
monster[i].fallValue = 0.2;
monster[i].power = monster[i].missilePower;

//flashStage.addChild(bmpForHit);


				//背景描画
				//haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,61]);
				//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
				haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
				drawBackground(null, haikeiData, null, null);

				//空描画
				drawPurpleSky();
				//テキスト設定
				setEndTextJissen();
			}
			else if (scenario.no == Scenario.OROCHI)
			{
				//破魔弓
				setHamayumi();

				remainTime = 120 * Global.FPS;

				for (i = 0; i < archer.length; i++)
				{
					archer[i].initCoop(i);
				}

				//矢倉設定
				yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(139);


				//モンスター設定
				i = 0;
				idx  = 137;
				idx2 = 138;
				monster[i].x = 640;
				monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
				monster[i].hp = 888;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				monster[i].minX = 280;
				monster[i].moveValX = -1;
				//monster[i].minY = monster[i].y;
				//monster[i].maxY = monster[i].y + 2;
				monster[i].isBmpHit = true;
				monster[i].isDieFall = true;

				//--------
				for (k = 0; k < 8; k++)
				{
					i = k + 1;
					idx  = 134;
					idx2 = 135;
					idx3 = 149;
					//monster[i].x = 480;
					//monster[i].y = 480 - 32;
					//monster[i].hp = 0;	//弾非表示はhp0
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoWalkRight1 = monsterImgNo[idx];
					monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx3];
					monster[i].imgNoDeadRight = monsterImgNo[idx3];
					monster[i].movePattern = Monster.MOVE_NORMAL;
					//monster[i].moveInterval = Global.halfFPS;
					monster[i].moveValX = 3;//3;
					monster[i].moveValY = (k % 8) * 0.05 + 0.3;
					monster[i].minX = -64;
					monster[i].maxX = 640;
					monster[i].minY = 0;
					monster[i].maxY = 480;
					monster[i].hitRange = 8;
					monster[i].isEnemy = false;
					
					monster[i].isMissile = true;
					//monster[i].missilePlusX = 32;
					//monster[i].missilePlusY = 96 + i * 12;//96;//i * 32 - 64;
					monster[i].missilePlusX = 32 + k * 3;
					monster[i].missilePlusY = 80 + i * 12;
					monster[i].missileHP = 1;//10;//monster[i].hp;
					//monster[i].startShootFrameCnt = Global.FPS * ((k < 8) ? 10 : 30);
					monster[i].startShootFrameCnt = Global.FPS * 15;
					monster[i].shootInterval = Global.FPS * 10;
					monster[i].isDieFall = true;
					
					monster[i].shooterIdx = 0;
					
monster[i].movePattern = Monster.MOVE_FALL;
monster[i].missilePower = -8;
monster[i].moveValX = 3;
monster[i].fallValue = 0.2;
monster[i].power = monster[i].missilePower;
				}

//flashStage.addChild(bmpForHit);


				//背景描画
				//haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,61]);
				//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
				haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
				drawBackground(null, haikeiData, null, null);

				//空描画
				drawPurpleSky();
				//テキスト設定
				setEndTextJissen();
			}
			else
			{
				makeStageFunc[scenario.no]();
			}

			//--------
			//ここでは呪いの５倍がまだ計算されていない
			/*
			for (i = 0; i < monster.length; i++ )
			{
				monster[i].maxHP = monster[i].hp;
			}
			*/
			
			//--------
			stageTimeSec = remainTime / Global.FPS;

		}

		// ----------------
		// setHamayumi
		// ----------------
		private var penetrateMaxCnt:int = 0;
		private var shuchu:Number = 0.0;
		private var sanran:Number = 0.0;
		private var maxWazaTameCnt:int = int.MAX_VALUE;
		private function setHamayumi():void
		{
			//++++++++
			//setLogInfo("setHamayumi");
			//++++++++

			//破魔弓
			var i:int;

			//shootArrowCnt = Hamayumi.getShootArrowCnt(selectGamen.isCoop, scenario.no);
			shootArrowCnt.value = Hamayumi.getShootArrowCnt(usvr.isJoinSuccess, scenario.no);

			maxPower = Hamayumi.maxPower;
			wazaMaxPower = 2 * maxPower;
			addPowerValue = Hamayumi.addPowerValue;
			penetrateMaxCnt = Hamayumi.penetrateMaxCnt;
			shuchu = Hamayumi.shuchu;
			sanran = Hamayumi.sanran;
			wazaKind = Global.getWazaKind();
			wazaKyokaKind = Global.getWazaKyokaKind();
			
			fallSpeed = Arrow.FALL_SPEED;
			
			arrowImage = BitmapManager.hamayumiArrowImage;
			
			//--------
			//HP表示
			Hamayumi.isShowHP = Global.yumiSettingGamen.isShowHP();
			
			//--------
			//霊力抑制
			if (Global.yumiSettingGamen.isDocho())
			{
				if (0 < usvr.memberNo.length)
				{
					if (personcnt < usvr.memberNo.length)
					{
						personcnt = usvr.memberNo.length;
					}
				}
				if (2 <= personcnt)
				{
					/*
					var yakazu:int = usvr.docho.yakazu + usvr.docho.level;
					if (Scenario.getSyncLevel(scenario.no) < usvr.docho.level)
					{
						//レベルシンク
						yakazu = usvr.docho.yakazu + Scenario.getSyncLevel(scenario.no);
					}
					shootArrowCnt.value = yakazu;
					
					maxPower = usvr.docho.maxPower;
					addPowerValue = usvr.docho.addPowerValue;
					penetrateMaxCnt = usvr.docho.penetrateMaxCnt
					shuchu = usvr.docho.shuchu;
					sanran = usvr.docho.sanran;
					wazaKind = usvr.docho.waza;
					wazaKyokaKind = usvr.docho.wazaKyoka;
					
					new TextLogConnect().connect("#" + Global.username + ":" + yakazu + "," + maxPower + "," + addPowerValue + "," + penetrateMaxCnt + "," + shuchu + "," + sanran + "," + wazaKind + "," + wazaKyokaKind);
					*/
					
					/*
					//初心者が弱すぎてクリアできないことが多いので仕様変更（協力戦がやりたくなくなる）。

					//(案1)参加者の最低レベルにレベルを合わせる。全員Lv60なら60だから高レベル同士で邪魔にならない
					var yakazu:int = Hamayumi.yakazu + usvr.docho.level;
					if (Scenario.getSyncLevel(scenario.no) < usvr.docho.level)
					{
						//レベルシンク
						yakazu = Hamayumi.yakazu + Scenario.getSyncLevel(scenario.no);
					}
					shootArrowCnt.value = yakazu;
					*/
					
					/*
					//(案2)レベルを参加可能な最低レベルにまで落とす、とする。
					shootArrowCnt.value = Hamayumi.yakazu + scenario.getMinLevel();
					*/

					//--------
					//(仕様変更20141121)
					if (Scenario.getSyncYakazu(scenario.no) < Hamayumi.getShootArrowCnt(usvr.isJoinSuccess, scenario.no))
					{
						shootArrowCnt.value = Scenario.getSyncYakazu(scenario.no);
					}
					//--------
				}
			}
			
			//--------
			Hamayumi.damage = 1;
			//--------
			//--------
			//二人張り
			//メモ：通常弓、速度最大で0.4秒
			Hamayumi.is2ninbari = Global.yumiSettingGamen.is2ninbari();
			if (Hamayumi.is2ninbari)
			{
				//ダメージ4倍 矢数半分 勾玉効果半分(飛距離、速射、密集)
				Hamayumi.damage = 4;
				shootArrowCnt.value = Hamayumi.getShootArrowCnt(usvr.isJoinSuccess, scenario.no) * 0.5;
				maxPower = Hamayumi.maxPowerFor2ninbari;
				wazaMaxPower = 2 * maxPower;
				addPowerValue = Hamayumi.addPowerValueFor2ninbari;
				//penetrateMaxCnt = Hamayumi.penetrateMaxCnt * 0.5;
				shuchu = Hamayumi.shuchu * 0.5;
				sanran = Hamayumi.sanran * 0.5;

				//--------
				//********矢数設定が上書きされるので二人張りを考慮して再設定********
				//霊力抑制
				if (Global.yumiSettingGamen.isDocho())
				{
					if (2 <= personcnt)
					{
						if (Scenario.getSyncYakazu(scenario.no) < Hamayumi.getShootArrowCnt(usvr.isJoinSuccess, scenario.no))
						{
							shootArrowCnt.value = Scenario.getSyncYakazu(scenario.no) * 0.5;
						}
					}
				}
				//--------

			}
			//--------
			
//--------
//三人張り
Hamayumi.is3ninbari = Global.yumiSettingGamen.is3ninbari();
if (Hamayumi.is3ninbari)
{
	//ダメージ6倍 矢数1/3 勾玉効果1/3(飛距離、速射、密集)
	Hamayumi.damage = 8;
	shootArrowCnt.value = Hamayumi.getShootArrowCnt(usvr.isJoinSuccess, scenario.no) * (1/3);
	maxPower = Hamayumi.maxPowerFor3ninbari;
	wazaMaxPower = 2 * maxPower;
	addPowerValue = Hamayumi.addPowerValueFor3ninbari;
	shuchu = Hamayumi.shuchu * (1/3);
	sanran = Hamayumi.sanran * (1/3);

	//--------
	//********矢数設定が上書きされるので三人張りを考慮して再設定********
	//霊力抑制
	if (Global.yumiSettingGamen.isDocho())
	{
		if (2 <= personcnt)
		{
			if (Scenario.getSyncYakazu(scenario.no) < Hamayumi.getShootArrowCnt(usvr.isJoinSuccess, scenario.no))
			{
				shootArrowCnt.value = Scenario.getSyncYakazu(scenario.no) * (1/3);
			}
		}
	}
	//--------

}
//--------
			
			//--------貫通強化
			Hamayumi.is2danHit = Global.yumiSettingGamen.is2danHit();
			Hamayumi.is3danHit = Global.yumiSettingGamen.is3danHit();
			//--------
			
			//--------軽量化
			Hamayumi.isLight = Global.yumiSettingGamen.isLight();
			//--------
			
			//--------技ダメージ
			Hamayumi.hanabiDamage = Hamayumi.damage;
			Hamayumi.bababaDamage = Hamayumi.damage;
			Hamayumi.ittenDamage = Hamayumi.damage;
			Hamayumi.renDamage = Hamayumi.damage;
			Hamayumi.souDamage = Hamayumi.damage;
			if (Global.yumiSettingGamen.isKyokaHanabi())
			{
				Hamayumi.hanabiDamage *= 2;
			}
			if (Global.yumiSettingGamen.isKyokaBababa())
			{
				Hamayumi.bababaDamage *= 2;
			}
			if (Global.yumiSettingGamen.isKyokaItten())
			{
				Hamayumi.ittenDamage *= 2;
			}
			if (Global.yumiSettingGamen.isKyokaRen())
			{
				Hamayumi.renDamage *= 2;
			}
			if (Global.yumiSettingGamen.isKyokaSou())
			{
				Hamayumi.souDamage *= 2;
			}
			//--------

			//--------技タメ
			Hamayumi.isWazaTame = Global.yumiSettingGamen.isWazaTame();
			
			if (wazaKind == Item.KIND_IDX_WAZA_HANABI)
			{
				//花火
				maxWazaTameCnt = Global.FPS * 30;
			}
			else if (wazaKind == Item.KIND_IDX_WAZA_SOU)
			{
				//送
				maxWazaTameCnt = Global.FPS * 35;
			}
			else if (wazaKind == Item.KIND_IDX_WAZA_REN)
			{
				//連
				maxWazaTameCnt = Global.FPS * 55;
			}
			else if ((wazaKind == Item.KIND_IDX_WAZA_ITTEN)
				 ||  (wazaKind == Item.KIND_IDX_WAZA_BABABA))
			{
				//一、バババ
				maxWazaTameCnt = Global.FPS * 20;
			}
			//--------
			
			//--------自動射出
			Hamayumi.isAuto = Global.yumiSettingGamen.isAuto();
			Hamayumi.isAuto1 = Global.yumiSettingGamen.isAuto1();
			//--------
		}

		// ****************
		// makeStageZombie
		// ****************
		private function makeStageZombie():void
		{
			//++++++++
			//setLogInfo("makeStageZombie");
			//++++++++

			var i:int;
			var idx:int;
			var idx2:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

			//モンスター設定
			//ゾンビ
			idx = 150;
			idx2 = 151
			for (i = 0; i < 32; i++)
			//for (i = 0; i < 1; i++)
			{
				monster[i].x = 640 + (i % 8) * 32;//640 + i * 32;
				monster[i].y = 480 + int(i / 8) * 32 ;//480 - 32 - 16;
				monster[i].v = -0.5 * (i % 3);
				monster[i].hp = 15;
				monster[i].moveValX = 0.5;
				monster[i].moveValY = -0.5;
				monster[i].hitRange = 16;
				monster[i].phase = 0;
				monster[i].movePattern = Monster.MOVE_JUMPPING;
				monster[i].maxY = 480 - 32 - 16;
				monster[i].maxV = -5 + (i % 2);
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].minX = -64;
				monster[i].isDieFall = true;
			}

			//背景描画
			haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,67,67,67,67,67]);
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,152,152,152,152]);
			drawBackground(null, haikeiData, haikeiData2, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageSkeleton
		// ****************
		private function makeStageSkeleton():void
		{
			//++++++++
			//setLogInfo("makeStageSkeleton");
			//++++++++

			var i:int, ii:int
			var idx:int;
			var idx2:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

			//モンスター設定
			//スケルトン
//当たり判定用bmp作成
makeHitBmp(153);
			idx  = 153;
			idx2 = 154;
			for (ii = 0; ii < 16; ii++)
			{
				i = ii + 16;
				monster[i].x = 640 + (ii % 8) * 32;//640 + i * 32;
				monster[i].y = 480 + int(ii / 8) * 32 ;//480 - 32 - 16;
				monster[i].v = -0.5 * (ii % 3);
				monster[i].hp = 15;
				monster[i].moveValX = 0.4;
				monster[i].moveValY = -0.5;
				//monster[i].hitRange = 16;
				/*
				monster[i].hitRect.x = 4;
				monster[i].hitRect.y = 0;
				monster[i].hitRect.width = 8 * 2;
				monster[i].hitRect.height = 16 * 2;
				*/
				monster[i].isBmpHit = true;
				
				monster[i].phase = 0;
				monster[i].movePattern = Monster.MOVE_JUMPPING;
				monster[i].maxY = 480 - 32 - 16;
				monster[i].maxV = -4 + (ii % 2);
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].minX = -64;
				monster[i].isDieFall = true;
			}

			//スケルトン盾
			idx  = 155;
			idx2 = 156;
			for (ii = 0; ii < 16; ii++)
			{
				i = ii + 0;
				monster[i].x = monster[ii + 16].x - 4;
				monster[i].y = monster[ii + 16].y;
				monster[i].v = monster[ii + 16].v;
				monster[i].hp = 15;
				monster[i].moveValX = monster[ii + 16].moveValX;
				monster[i].moveValY = monster[ii + 16].moveValY;
				//monster[i].hitRange = 16;
				monster[i].hitRect.x = -5 * 2;
				monster[i].hitRect.y = 0;
				monster[i].hitRect.width = 5 * 2;
				monster[i].hitRect.height = 16 * 2;
				monster[i].phase = 0;
				monster[i].movePattern = Monster.MOVE_JUMPPING;
				monster[i].maxY = monster[ii + 16].maxY;
				monster[i].maxV = monster[ii +　16].maxV;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].minX = -64;
				monster[i].isDieFall = true;
				monster[i].isReflect = true;
				monster[i].isEnemy = false;
				//monster[i].isMissile = true;
				monster[i].bodyIdx = ii + 16;
			}
		
			//背景描画
			haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,67,67,67,67,67]);
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,152,152,152,152]);
			drawBackground(null, haikeiData, haikeiData2, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageSlime
		// ****************
		private function makeStageSlime():void
		{
			//++++++++
			//setLogInfo("makeStageSlime");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

			//モンスター設定
			//スライム
			idx  = 157;
			idx2 = 158;
			for (i = 0; i < 16; i++)
			{
				monster[i].x = 640 - (i % 8 + 1) * 32;
				monster[i].y = 480 + int(i / 8) * 32 ;
				monster[i].v = -0.5 * (i % 3);
				monster[i].hp = 50;
				monster[i].moveValX = 0;//0.5;
				monster[i].moveValY = -0.5;
				//monster[i].hitRange = 14;
				monster[i].hitRange = 13;
				monster[i].phase = 0;
				monster[i].movePattern = Monster.MOVE_JUMPPING;
				monster[i].maxY = 480 - 32 - 16;
				monster[i].maxV = -6 + (i % 2);
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].imgNoDeadRight = monsterImgNo[idx2];
				monster[i].minX = -64;
				monster[i].isDieFall = true;
			}

			//--------
			for (k = 0; k < 16; k++)
			{
				i = k + 16;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_NORMAL;
				monster[i].moveValX = 2;//3;
				monster[i].moveValY = (k % 8) * 0.1 + 0.3;//(k % 8) * 0.05 + 0.3;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480 - 32 - 16;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = monster[i].x;
				monster[i].missilePlusY = monster[i].y;
				monster[i].missileHP = 1;
				monster[i].startShootFrameCnt = Global.FPS * 15;
				monster[i].shootInterval = Global.FPS * 10;
				//monster[i].startShootFrameCnt = Global.FPS * 15 * (k % 1 + 1);
				//monster[i].shootInterval = Global.FPS * 10 * (k % 1 + 1);
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = k;
				
monster[i].movePattern = Monster.MOVE_FALL2;
monster[i].missilePower = -8;
monster[i].moveValX = 3;
monster[i].fallValue = 0.2;
monster[i].power = monster[i].missilePower;
			}

			//背景描画
			haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,67,67,67,67,67]);
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,152,152,152,152]);
			drawBackground(null, haikeiData, haikeiData2, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}
		
		// ****************
		// makeStageArmor
		// ****************
		private function makeStageArmor():void
		{
			//++++++++
			//setLogInfo("makeStageArmor");
			//++++++++

			var i:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

			//モンスター設定
			//当たり判定用bmp作成
			makeHitBmp(164);

			//本体、鬼火
			i = 1;
			idx  = 134;
			idx2 = 135;
			idx3 = 149;
			monster[i].x = 640 - 32 + 64;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[161]].height + 128 + 8;
			monster[i].hp = 200;
			monster[i].hitRange = 12;// 8;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].imgNoDeadRight = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].moveValX = -0.5;//-0.2;
			monster[i].minX = 320 + 48;//320 + 32;
			monster[i].isDieFall = true;


			//鎧
			i = 2;
			idx  = 159;
			idx2 = 160;
			monster[i].x = monster[1].x - 298;//640 - 32;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
			monster[i].hp = 1;
			//monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			//monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			//monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			//monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_ARMOR;
			monster[i].moveValX = monster[1].moveValX;
			monster[i].minX = monster[1].minX + (monster[i].x - monster[1].x);
			monster[i].isEnemy = false;
			monster[i].isBmpHit = true;
			monster[i].isReflect = true;
			//monster[i].enableBreak = true;
			monster[i].isDieFall = true;
			monster[i].bodyIdx = 1;

			//敵（弾）
			i = 3;
			idx = 166;
			//idx = 130;
			//monster[i].x = 480;
			//monster[i].y = 480 - 60;
			//monster[i].hp = 0;	//弾非表示はhp0
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			//monster[i].moveInterval = Global.halfFPS;
			monster[i].moveValX = -8;//3;
			monster[i].moveValY = 0;
			monster[i].minX = -64;
			monster[i].maxX = monster[i].x;
			//monster[i].hitRect.width = 64;
			//monster[i].hitRect.height = 4;
			monster[i].isEnemy = false;
			monster[i].isMissile = true;
			//monster[i].missileX = monster[i].x;
			//monster[i].missileY = monster[i].y;
			monster[i].missilePlusX = -300;
			monster[i].missilePlusY = 150;
			monster[i].missileHP = 1000;//monster[i].hp;
			monster[i].startShootFrameCnt = Global.FPS * 35;
			monster[i].shootInterval = Global.FPS * 15;
			monster[i].shooterIdx = 1;
			monster[i].isDieFall = true;

			//背景描画
			haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,-1,-1,-1,168,-1,169,-1,168]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			haikeiData = Vector.<int>([-1,-1,-1,-1,67,67,66,67,67,67,67,66,67,67,67,67,67,67,67,66]);
			//jimenData  = Vector.<int>([-1,-1,-1,-1,-1,165,165,165,165,165,165,165,165,165,165,165,165,165,165,165,165,165,165]);
			drawBackground(null, haikeiData, null, haikeiData3);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageTree
		// ****************
		private function makeStageTree():void
		{
			//++++++++
			//setLogInfo("makeStageTree");
			//++++++++

			var i:int, ii:int, cnt:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(173);

			//モンスター設定
			//木
			i = 0;
			idx  = 170;
			idx2 = 170;
			monster[i].x = 300;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height + 16;
			monster[i].hp = 1000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//葉
			cnt = 1;
			for (ii = 0; ii < 4; ii++)
			{
				i = cnt + ii;
				idx  = 85;
				idx2 = 86;
				idx3 = 149;
				monster[i].x = monster[0].x + ii * 32 + 48 + 4;
				monster[i].y = monster[0].y - 8;
				monster[i].hp = 10;
				monster[i].hitRange = 12;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].isDieFall = true;
			}
			cnt += ii;
			for (ii = 0; ii < 5; ii++)
			{
				i = cnt + ii;
				idx  = 85;
				idx2 = 86;
				idx3 = 149;
				monster[i].x = monster[0].x + ii * 32 + 32 + 4;
				monster[i].y = monster[0].y + 40 - 8;
				monster[i].hp = 10;
				monster[i].hitRange = 12;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].isDieFall = true;
			}
			cnt += ii;
			for (ii = 0; ii < 6; ii++)
			{
				i = cnt + ii;
				idx  = 85;
				idx2 = 86;
				idx3 = 149;
				monster[i].x = monster[0].x + ii * 32 + 16 + 4;
				monster[i].y = monster[0].y + 80 - 8;
				monster[i].hp = 10;
				monster[i].hitRange = 12;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].isDieFall = true;
			}
			cnt += ii;
			for (ii = 0; ii < 7; ii++)
			{
				i = cnt + ii;
				idx  = 85;
				idx2 = 86;
				idx3 = 149;
				monster[i].x = monster[0].x + ii * 32 + 4;
				monster[i].y = monster[0].y + 120 - 8;
				monster[i].hp = 10;
				monster[i].hitRange = 12;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].isDieFall = true;
			}

			//鬼火
			i = 30;
			cnt++;
			idx  = 85;
			idx2 = 86;
			idx3 = 149;
			monster[i].x = monster[0].x + 100;
			monster[i].y = monster[0].y + 120;
			monster[i].hp = 50;
			monster[i].hitRange = 12;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].imgNoDeadRight = monsterImgNo[idx3];
			monster[i].isDieFall = true;

			//--------
			//弾
			for (ii = 0; ii < 3; ii++)
			{
				i = 31 + ii;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_FALL;
				monster[i].moveValX = 3;
				monster[i].moveValY = 0.5;
				monster[i].fallValue = 0.2;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 3;
				monster[i].missilePower = -10;
				monster[i].power = monster[i].missilePower;
				monster[i].startShootFrameCnt = Global.FPS * (15 + ii);
				monster[i].shootInterval = Global.FPS * 10;
				monster[i].isDieFall = true;
				monster[i].shooterIdx = 30;
			}

			//背景描画
			//haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,61]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
			drawBackground(null, haikeiData, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageHarpy
		// ****************
		private function makeStageHarpy():void
		{
			//++++++++
			//setLogInfo("makeStageHarpy");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

			//モンスター設定
			//ハーピー
			cnt = 20;
			for (i = 0; i < cnt; i++)
			{
				idx  = 174;
				idx2 = 175;
				idx3 = 176;
				idx4 = 177;
				idx5 = 178;
				monster[i].x = 640 + 32 * i;
				monster[i].y = 96 + (i % 4) * 32;
				monster[i].hp = 20;
				monster[i].moveValX = 2;
				monster[i].moveValY = 0;
				monster[i].isNowMove = true;
				monster[i].dir = Monster.DIR_LEFT;
				monster[i].hitRange = 12;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx3];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx4];
				monster[i].imgNoDeadLeft = monsterImgNo[idx5];
				monster[i].imgNoDeadRight = monsterImgNo[idx5];
				monster[i].movePattern = Monster.MOVE_NORMAL_FROM_RANGE;
				monster[i].turnRate = 64;
				monster[i].minX = 32;
				monster[i].maxX = 640 - 32;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].isDieFall = true;
			}

			//--------
			for (k = 0; k < cnt; k++)
			{
				i = k + cnt;
				idx  = 179;
				idx2 = 179;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 3;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;//monster[i].x;
				monster[i].missilePlusY = 0;//monster[i].y;
				monster[i].missileHP = 1;
				monster[i].startShootFrameCnt = Global.FPS * 15;
				monster[i].shootInterval = Global.FPS * 20;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = k;
/*
monster[i].movePattern = Monster.MOVE_FALL2;
monster[i].missilePower = -8;
monster[i].moveValX = 3;
monster[i].fallValue = 0.2;
monster[i].power = monster[i].missilePower;
*/
			}

			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,67,67,66,67,67]);
			haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, haikeiData2, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageGolem
		// ****************
		/*
		private function makeStageGolem():void
		{
			//++++++++
			//setLogInfo("makeStageGolem");
			//++++++++

			var i:int, ii:int;
			var idx:int, idx2:int, idx3:int, idx4:int, idx5:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

			//モンスター設定
			//ストーンゴーレム核
			i = 0;
			idx  = 134;
			idx2 = 135;
			idx3 = 149;
			monster[i].x = 640 + i * 64;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height - 48;
			monster[i].hp = 30;
			monster[i].moveValX = 1;

			monster[i].hitRange = 12;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft  = monsterImgNo[idx3];
			monster[i].minX = -64;
			monster[i].isDieFall = true;

			//ゴーレム核
			idx  = 134;
			idx2 = 135;
			idx3 = 149;
			for (i = 1; i < 10; i++)
			{
				monster[i].x = 640 + i * 64;
				monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
				monster[i].hp = 10;
				monster[i].moveValX = 1;

				monster[i].hitRange = 12;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft  = monsterImgNo[idx3];
				monster[i].minX = -64;
				monster[i].isDieFall = true;

//monster[i].movePattern = Monster.MOVE_JUMPPING;
			}

			//ストーンゴーレム
			ii = 0;
			i = ii + 11;
			idx  = 184;
			idx2 = 185;
			idx3 = 186;
			monster[i].x = monster[ii].x - 48;//640 + ii * 48;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
			monster[i].hp = 500;
			monster[i].moveValX = 1;
			monster[i].hitRect.x = 11 * 2;
			monster[i].hitRect.y = 12 * 2;
			monster[i].hitRect.width = 16 * 2;
			monster[i].hitRect.height = 52 * 2;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft  = monsterImgNo[idx3];
			monster[i].minX = -64;
			monster[i].isDieFall = true;
			monster[i].bodyIdx = ii;

			//ゴーレム
			idx  = 181;
			idx2 = 182;
			idx3 = 183;
			for (ii = 1; ii < 10; ii++)
			{
				i = ii + 12
				monster[i].x = monster[ii].x - 52;//640 + ii * 48;
				monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
				monster[i].hp = 100;
				monster[i].moveValX = 1;
				monster[i].hitRect.x = 12 * 2;
				monster[i].hitRect.y =  7 * 2;
				monster[i].hitRect.width = 15 * 2;
				monster[i].hitRect.height = 32 * 2;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft  = monsterImgNo[idx3];
				monster[i].minX = -64;
				monster[i].isDieFall = true;
				monster[i].bodyIdx = ii;
			}

			//--------
			idx  = 134;
			idx2 = 135;
			idx3 = 149;
			for (ii = 1; ii < 10; ii++)
			{
				i = ii + 22;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].moveValX = 4;//3;
				monster[i].moveValY = 0.5;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;//i * 32 - 64;
				monster[i].missileHP = 1;//monster[i].hp;
				monster[i].startShootFrameCnt = Global.FPS * 15;
				monster[i].shootInterval = Global.FPS * 10;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = ii;

				monster[i].movePattern = Monster.MOVE_FALL3;
				monster[i].missilePower = -12;
				monster[i].moveValX = 3;
				monster[i].fallValue = 0.2;
				monster[i].power = monster[i].missilePower;
				
				monster[i].moveVal = 3;
			}


			//背景描画
			haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,-1,-1,-1,168,-1,169,-1,168]);
			haikeiData = Vector.<int>([-1,-1,-1,-1,67,67,66,67,67,67,67,66,67,67,67,67,67,67,67,66]);
			drawBackground(null, haikeiData, null, haikeiData3);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}
		*/

		// ****************
		// makeStageWisp
		// ****************
		private function makeStageWisp():void
		{
			//++++++++
			//setLogInfo("makeStageWisp");
			//++++++++

			var i:int, k:int;
			var idx:int, idx2:int, idx3:int, idx4:int, idx5:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
//makeHitBmp(198);


			//モンスター設定
			i = 0;
			idx  = 196;
			idx2 = 197;
			monster[i].x = 640;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height * 0.75;
			monster[i].hp = 1000;
			monster[i].hitRange = 48;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP_CHANGE2;
			monster[i].minX = 540;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			//monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

/*
			//--------
			//狙い攻撃
			i = 1
			idx  = 134;
			idx2 = 135;
			idx3 = 149;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_TAN2;
			monster[i].moveVal = 1;
			monster[i].hitRange = 8;
			monster[i].isEnemy = false;
			
			monster[i].isMissile = true;
			monster[i].missilePlusX = 0;//monster[i].x;
			monster[i].missilePlusY = 0;//monster[i].y;
			monster[i].missileHP = 50;
			monster[i].startShootFrameCnt = Global.FPS * 15;
			monster[i].shootInterval = Global.FPS * 20;
			monster[i].isDieFall = true;
			
			monster[i].shooterIdx = 0;
*/

/*
			//連弾 上下
			for (k = 0; k < 15; k++)
			{
				i = k + 2;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_FALL;
				//monster[i].moveValX = 4;//3;
				//monster[i].moveValY = 0.5;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;//i * 32 - 64;
				monster[i].missileHP = 1;//monster[i].hp;
				monster[i].startShootFrameCnt = Global.FPS * 15 + k * 3;
				monster[i].shootInterval = Global.FPS * 30;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
	
				monster[i].missilePower = -10 * 2;
				monster[i].moveValX = 4;
				monster[i].fallValue = 0.2 * 2;
				monster[i].power = monster[i].missilePower;
			}
*/

			//連弾 横
			//--------
			for (k = 0; k < 10; k++)
			{
				i = k + 1;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 10;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;//monster[i].x;
				monster[i].missilePlusY = 0;//monster[i].y;
				monster[i].missileHP = 1;
				monster[i].startShootFrameCnt = Global.FPS * 15 + k * 3;
				monster[i].shootInterval = Global.FPS * 30;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
			}

			//連弾 上へ
			for (k = 0; k < 10; k++)
			{
				i = k + 11;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_FALL;
				//monster[i].moveValX = 4;//3;
				//monster[i].moveValY = 0.5;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;//i * 32 - 64;
				monster[i].missileHP = 1;//monster[i].hp;
				monster[i].startShootFrameCnt = Global.FPS * 20 + k * 3;
				monster[i].shootInterval = Global.FPS * 30;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
	
				monster[i].missilePower = -10 * 2 - 3;
				monster[i].moveValX = 4;
				monster[i].fallValue = 0.2 * 2;
				monster[i].power = monster[i].missilePower;
			}

//TEST
/*
			//--------
			for (k = 0; k < 5; k++)
			{
				i = 2 + k;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_ROTATION;//MOVE_TAN2;
				monster[i].moveVal = 3;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;//monster[i].x;
				monster[i].missilePlusY = 0;//monster[i].y;
				monster[i].missileHP = 100;
				monster[i].startShootFrameCnt = Global.FPS * (15 + k);
				monster[i].shootInterval = Global.FPS * 9999;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;

monster[i].moveVal = 128;
			}
*/

			//背景描画
			haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,-1,-1,-1,168,-1,169,-1,168]);
			haikeiData = Vector.<int>([-1,-1,-1,-1,67,67,66,67,67,67,67,66,67,67,67,67,67,67,67,66]);
			drawBackground(null, haikeiData, null, haikeiData3);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageLongwitton
		// ****************
		private function makeStageLongwitton():void
		{
			//++++++++
			//setLogInfo("makeStageLongwitton");
			//++++++++

			var i:int, k:int;
			var idx:int, idx2:int, idx3:int, idx4:int, idx5:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
//makeHitBmp(199);
makeHitBmp(254);

			//モンスター設定
			i = 0;
			idx  = 199;
			idx2 = 202;
			monster[i].x = 500 - 92;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height - 16;
			monster[i].hp = 1000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;
			
			monster[i].isReflect = true;
			monster[i].hontaiIdx = 1;
			
			//井戸
			i = 1;
			idx  = 200;
			idx2 = 201;
			monster[i].x = 500;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
			monster[i].hp = 150;
			monster[i].hitRect.x = 0;
			monster[i].hitRect.y = 12 * 2;
			monster[i].hitRect.width = 16 * 2;
			monster[i].hitRect.height = 12 * 2;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx];
			monster[i].imgNoDeadLeft = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;


			//連弾 横
			//--------
			for (k = 0; k < 5; k++)
			{
				i = k + 2;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 2;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;//monster[i].x;
				monster[i].missilePlusY = 50;//monster[i].y;
				monster[i].missileHP = 10;
				monster[i].startShootFrameCnt = Global.FPS * 15 + k * 3;
				monster[i].shootInterval = Global.FPS * 30;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
			}

			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,67,67,66,67,67]);
			haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, haikeiData2, null);

//flashStage.addChild(bmpForHit);


			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}
		
		// ****************
		// makeStageTank
		// ****************
		private function makeStageTank():void
		{
			//++++++++
			//setLogInfo("makeStageTank");
			//++++++++

			var i:int, k:int;
			var idx:int, idx2:int, idx3:int, idx4:int, idx5:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

			//モンスター設定

			//
			for (i = 0; i < 8; i++)
			{
				idx  = 203;
				idx2 = 204;

				monster[i].x = 640;
				monster[i].y = 480 - 32 - 27 - 54 * i;
				monster[i].hp = 250;
				monster[i].hitRange = 27;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].movePattern = Monster.MOVE_TANK;
				monster[i].maxY = 480 - 32 - 27;
				monster[i].minX = 480;
				monster[i].moveValX = -1;
				monster[i].isBmpHit = false;
				monster[i].isDieFall = true;
			}

			//連弾 横
			//--------
			var shootIntervals:Vector.<int> = Vector.<int>([10,15,15,15,15,15,5,10]);
			for (k = 0; k < 8; k++)
			{
				i = k + 8;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];

				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 4;
				monster[i].isMissile = true;
				monster[i].missilePlusX = -48;//monster[i].x;
				monster[i].missilePlusY = -16;//monster[i].y;
				monster[i].missileHP = 4;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 2;
				monster[i].shootInterval = Global.FPS * shootIntervals[k];//Global.FPS * 15;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = k;
			}

			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,22,-1,-1,14,22,-1,-1,14,-1]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, null, null);

//flashStage.addChild(bmpForHit);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageFighter
		// ****************
		private function makeStageFighter():void
		{
			//++++++++
			//setLogInfo("makeStageFighter");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

			//モンスター設定
			//爆撃機ボンバー
			cnt = 12;
			for (i = 0; i < cnt; i++)
			{
				idx  = 205;
				idx2 = 205;
				idx3 = 206;
				idx4 = 206;
				idx5 = 207;
				monster[i].x = 640 + 64 * i;
				monster[i].y = 48 + (i % 3) * 32;
				monster[i].hp = 80;
				monster[i].moveValX = 2;
				monster[i].moveValY = 0;
				monster[i].isNowMove = true;
				monster[i].dir = Monster.DIR_LEFT;
				
				//monster[i].hitRange = 12;
				monster[i].hitRect.x = 4;// -44;
				monster[i].hitRect.y = 8 * 2;
				monster[i].hitRect.width = 44 * 2;
				monster[i].hitRect.height = 6 * 2;

				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx3];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx4];
				monster[i].imgNoDeadLeft = monsterImgNo[idx5];
				monster[i].imgNoDeadRight = monsterImgNo[idx5];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP_TURN;
				//monster[i].turnRate = 64;
				monster[i].minX = 32;
				monster[i].maxX = 640 - 32;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].isDieFall = true;
			}

			//--------
			for (k = 0; k < cnt; k++)
			{
				i = k + cnt;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 3;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;//monster[i].x;
				monster[i].missilePlusY = 0;//monster[i].y;
				monster[i].missileHP = 3;
				monster[i].startShootFrameCnt = Global.FPS * 15 + k * 2;
				monster[i].shootInterval = Global.FPS * 15;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = k;
/*
monster[i].movePattern = Monster.MOVE_FALL2;
monster[i].missilePower = -8;
monster[i].moveValX = 3;
monster[i].fallValue = 0.2;
monster[i].power = monster[i].missilePower;
*/
			}

			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,22,-1,-1,14,22,-1,-1,14,-1]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageBattleShip
		// ****************
		private function makeStageBattleShip():void
		{
			//++++++++
			//setLogInfo("makeStageBattleShip");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(208);


			//モンスター設定
			i = 0;
			idx  = 208;
			idx2 = 208;
			monster[i].x = 640;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
			monster[i].hp = 1200;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 320;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//--------
			//弾
			for (k = 0; k < 3; k++)
			{
				i = k + 1;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				//monster[i].x = 480;
				//monster[i].y = 480 - 32;
				//monster[i].hp = 0;	//弾非表示はhp0
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				//monster[i].movePattern = Monster.MOVE_ROTATION;
				//monster[i].moveInterval = Global.halfFPS;
				//monster[i].moveValX = 3;//3;
				//monster[i].moveValY = (k % 16) * 0.05 + 0.3;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				//monster[i].missilePlusX = 32;
				//monster[i].missilePlusY = 96 + i * 12;//96;//i * 32 - 64;
				monster[i].missilePlusX = 112;
				monster[i].missilePlusY = 64;
				monster[i].missileHP = 8;//10;//monster[i].hp;
				//monster[i].startShootFrameCnt = Global.FPS * ((k < 8) ? 10 : 30);
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * Global.FPS;
				monster[i].shootInterval = Global.FPS * 15;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;

//monster[i].movePattern = Monster.MOVE_FALL3;
monster[i].movePattern = Monster.MOVE_FALL;
monster[i].missilePower = -12;
monster[i].moveValX = 3;
monster[i].moveVal = 4;
monster[i].fallValue = 0.2;
monster[i].power = 1;
			}

			//--------
			//シールド
			//for (k = 0; k < 1; k++)
			{
				i = 10;
				idx  = 209;
				idx2 = 210;
				idx3 = 209;
				//monster[i].x = 640;
				//monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
				//monster[i].hp = 1;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				monster[i].minX = 280;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].moveValX = -1;
				//monster[i].minY = monster[i].y;
				//monster[i].maxY = monster[i].y + 2;
				
				monster[i].hitRect.x = 0;
				monster[i].hitRect.y = 0;
				monster[i].hitRect.width = 7 * 4;
				monster[i].hitRect.height = 48 * 4;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = -32;// 160;
				monster[i].missilePlusY = -96;
				monster[i].missileHP = 20;
				monster[i].startShootFrameCnt = Global.FPS * 20;
				monster[i].shootInterval = Global.FPS * 999;
				
				monster[i].isBmpHit = false;
				monster[i].isDieFall = true;
				monster[i].isReflect = true;
				monster[i].isEnemy = false;
				
				monster[i].bodyIdx  = 11;
				monster[i].shooterIdx = 11;
			}

			//--------
			//シールド発生元
			//for (k = 0; k < 1; k++)
			{
				i = 11;
				idx  = 85;
				idx2 = 86;
				idx3 = 149;
				//monster[i].x = 640;
				//monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
				//monster[i].hp = 1;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				monster[i].minX = 312;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480;
				monster[i].moveValX = -1;
				//monster[i].minY = monster[i].y;
				//monster[i].maxY = monster[i].y + 2;
				
				/*
				monster[i].hitRect.x = 0;
				monster[i].hitRect.y = 0;
				monster[i].hitRect.width = 7 * 4;
				monster[i].hitRect.height = 48 * 4;
				*/
				monster[i].hitRange = 12;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 160;
				monster[i].missilePlusY = 32;
				monster[i].missileHP = 20;
				monster[i].startShootFrameCnt = Global.FPS * 20;
				monster[i].shootInterval = Global.FPS * 999;
				
				monster[i].isBmpHit = false;
				monster[i].isDieFall = true;
				monster[i].isReflect = false;
				monster[i].isEnemy = false;
				
				monster[i].bodyIdx  = 0;
				monster[i].shooterIdx = 0;
			}

			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,22,-1,-1,14,22,-1,-1,14,-1]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageStealthSubmarine
		// ****************
		private function makeStageStealthSubmarine():void
		{
			//++++++++
			//setLogInfo("makeStageStealthSubmarine");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);


			//モンスター設定
			//ステルス
			i = 0;
			idx  = 211;
			idx2 = 214;
			//idx5 = 207;
			monster[i].x = 640 + 64 * i;
			monster[i].y = 48 + (i % 3) * 32;
			monster[i].hp = 600;
			monster[i].moveValX = 2;
			monster[i].moveValY = 0;
			monster[i].isNowMove = true;
			monster[i].dir = Monster.DIR_LEFT;
			//monster[i].hitRange = 12;
			monster[i].hitRect.x = 1 * monsterImage[monsterImgNo[idx]].scaleX;
			monster[i].hitRect.y = 5 * monsterImage[monsterImgNo[idx]].scaleY;
			monster[i].hitRect.width = (32 - 3) * monsterImage[monsterImgNo[idx]].scaleX;
			monster[i].hitRect.height = 6 * monsterImage[monsterImgNo[idx]].scaleY;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_STEALTH;
			//monster[i].turnRate = 64;
			monster[i].minX = 32;
			monster[i].maxX = 640 - 32;
			monster[i].minY = 0;
			monster[i].maxY = 480;
			monster[i].isDieFall = true;

			//連弾 横
			//--------
			for (k = 0; k < 5; k++)
			{
				i = k + 1;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 8;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = monsterImage[monsterImgNo[211]].width * 0.5;
				monster[i].missilePlusY = 5 * monsterImage[monsterImgNo[idx]].scaleY;
				monster[i].missileHP = 1;
				monster[i].startShootFrameCnt = Global.FPS * 15 + k * 3;
				monster[i].shootInterval = Global.FPS * 30;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
			}
			
			//モンスター設定
			//サブマリン
			i = 10;
			idx  = 213;
			idx2 = 213;
			//idx5 = 207;
			monster[i].x = 420;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height + (Global.FPS * 5);
			monster[i].hp = 400;
			monster[i].hitRect.x = 1 * monsterImage[monsterImgNo[idx]].scaleX;
			monster[i].hitRect.y = 5 * monsterImage[monsterImgNo[idx]].scaleY;
			monster[i].hitRect.width = (48 - 3) * monsterImage[monsterImgNo[idx]].scaleX;
			monster[i].hitRect.height = 10 * monsterImage[monsterImgNo[idx]].scaleY;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_SUBMARINE;
			//monster[i].minX = 320 + 32;
			//monster[i].maxX = 480 - 32 - monsterImage[monsterImgNo[idx]].height + (Global.FPS * 5);
			monster[i].minY = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
			monster[i].maxY = 640;
			monster[i].moveValX = 1;
			monster[i].moveValY = 1;
			monster[i].isNowMove = true;
			monster[i].vdir = Monster.VDIR_TOP;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = false;
			monster[i].isDieFall = true;

			//--------
			for (k = 0; k < 5; k++)
			{
				i = k + 11;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 8;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = monsterImage[monsterImgNo[213]].width * 0.5;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 1;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 3;
				monster[i].shootInterval = Global.FPS * 30;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 10;
			}

			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,22,-1,-1,14,22,-1,-1,14,-1]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageUFO
		// ****************
		private function makeStageUFO():void
		{
			//++++++++
			//setLogInfo("makeStageUFO");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(217);

			//モンスター設定
			//UFO
			i = 0;
			idx  = 217;
			idx2 = 217;
			//idx5 = 207;
			monster[i].x = 640;
			monster[i].y = 64;
			monster[i].hp = 1200;//1500;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 320;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//シールドコントローラー
			i = 1;
			idx  = 219;
			idx2 = 220;
			//idx5 = 207;
			monster[i].x = 640 + Global.FPS * 9;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height * 0.5;
			monster[i].hp = 400;//500;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 600;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].hitRange = 12;
			monster[i].isBmpHit = false;
			monster[i].isDieFall = true;
			
			//シールド
			for (k = 0; k < 16; k++ )
			{
				i = 2 + k;
				idx  = 218;
				idx2 = 218;
				//idx5 = 207;
				//monster[i].x = 640;
				//monster[i].y = 64;
				//monster[i].hp = 1;
				//monster[i].moveValX = 2;
				//monster[i].moveValY = 0;
				//monster[i].isNowMove = true;
				//monster[i].dir = Monster.DIR_LEFT;
				monster[i].hitRange = 12;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].movePattern = Monster.MOVE_ROTATION;
				//monster[i].turnRate = 64;
				//monster[i].minX = 32;
				//monster[i].maxX = 640 - 32;
				//monster[i].minY = 0;
				//monster[i].maxY = 480;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = monsterImage[monsterImgNo[217]].width * 0.5 + monsterImage[monsterImgNo[idx]].width * 0.5;
				monster[i].missilePlusY = monsterImage[monsterImgNo[217]].height * 0.5 + monsterImage[monsterImgNo[idx]].height * 0.5;
				monster[i].missileHP = 1;
				monster[i].moveVal = 80;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 2;
				monster[i].shootInterval = Global.FPS * 999;
				monster[i].isDieFall = true;
				monster[i].isReflect = true;
				monster[i].isBmpHit = false;
				
monster[i].isEnemy = false;
				
				monster[i].shooterIdx = 0;
				monster[i].bodyIdx = 1;
			}

			//連弾 横
			//--------
			for (k = 0; k < 3; k++)
			{
				i = k + 20;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 5;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = monsterImage[monsterImgNo[217]].width * 0.5 + monsterImage[monsterImgNo[idx]].width * 0.5;
				monster[i].missilePlusY = monsterImage[monsterImgNo[217]].height * 0.5 + monsterImage[monsterImgNo[idx]].height * 0.5;
				monster[i].missileHP = 15;
				monster[i].startShootFrameCnt = Global.FPS * 15 + k * 3;
				monster[i].shootInterval = Global.FPS * 25;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
			}

			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,22,-1,-1,14,22,-1,-1,14,-1]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}
		
		// ****************
		// makeStageTREX
		// ****************
		private function makeStageTREX():void
		{
			//++++++++
			//setLogInfo("makeStageTREX");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(221);


			//モンスター設定
			i = 0;
			idx  = 221;
			idx2 = 222;
			monster[i].x = 640;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
			monster[i].hp = 2400;//3000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 320;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;
				
			//--------
			for (k = 0; k < 10; k++)
			{
				i = k + 16;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				//monster[i].movePattern = Monster.MOVE_NORMAL;
				monster[i].moveValX = 2;//3;
				monster[i].moveValY = (k % 8) * 0.1 + 0.3;//(k % 8) * 0.05 + 0.3;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480 - 32 - 16;
				monster[i].hitRange = 8;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = monster[i].x + 48;
				monster[i].missilePlusY = monster[i].y + 80;
				monster[i].missileHP = 4;
				monster[i].startShootFrameCnt = Global.FPS * 15 + k * 2;
				monster[i].shootInterval = Global.FPS * 20;
				//monster[i].startShootFrameCnt = Global.FPS * 15 * (k % 1 + 1);
				//monster[i].shootInterval = Global.FPS * 10 * (k % 1 + 1);
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
				
monster[i].movePattern = Monster.MOVE_FALL2;
monster[i].missilePower = - k * 0.1;
monster[i].moveValX = 5;
monster[i].fallValue = 0.2;
monster[i].power = monster[i].missilePower;
			}

				
			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,22,-1,-1,14,22,-1,-1,14,-1]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStagePteranodon
		// ****************
		private function makeStagePteranodon():void
		{
			//++++++++
			//setLogInfo("makeStagePteranodon");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(226);


			//モンスター設定
			i = 0;
			idx  = 224;
			idx2 = 225;
			monster[i].x = 640;
			monster[i].y = 96;
			monster[i].hp = 600;//3000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 400;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			i = 1;
			idx  = 224;
			idx2 = 225;
			monster[i].x = 640;
			monster[i].y = 176;
			monster[i].hp = 600;//3000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 400;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			i = 2;
			idx  = 224;
			idx2 = 225;
			monster[i].x = 640;
			monster[i].y = 256;
			monster[i].hp = 600;//3000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 400;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			i = 3;
			idx  = 224;
			idx2 = 225;
			monster[i].x = 640;
			monster[i].y = 336;
			monster[i].hp = 600;//3000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 400;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//小--------
			i = 4;
			idx  = 227;
			idx2 = 228;
			monster[i].x = 640 + 200;
			monster[i].y = 96 + 64;
			monster[i].hp = 60;//3000;
			monster[i].hitRange = 12;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 640 - 48;
			monster[i].moveValX = -1;
			monster[i].isBmpHit = false;
			monster[i].isDieFall = true;

			i = 5;
			idx  = 227;
			idx2 = 228;
			monster[i].x = 640 + 200;
			monster[i].y = 176 + 64;
			monster[i].hp = 60;//3000;
			monster[i].hitRange = 12;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 640 - 48;
			monster[i].moveValX = -1;
			monster[i].isBmpHit = false;
			monster[i].isDieFall = true;

			i = 6;
			idx  = 227;
			idx2 = 228;
			monster[i].x = 640 + 200;
			monster[i].y = 256 + 64;
			monster[i].hp = 60;//3000;
			monster[i].hitRange = 12;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 640 - 48;
			monster[i].moveValX = -1;
			monster[i].isBmpHit = false;
			monster[i].isDieFall = true;

			i = 7;
			idx  = 227;
			idx2 = 228;
			monster[i].x = 640 + 200;
			monster[i].y = 336 + 64;
			monster[i].hp = 60;//3000;
			monster[i].hitRange = 12;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoWalkRight1 = monsterImgNo[idx];
			monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].imgNoDeadRight = monsterImgNo[idx2];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 640 - 48;
			monster[i].moveValX = -1;
			monster[i].isBmpHit = false;
			monster[i].isDieFall = true;

			//--------
			for (k = 0; k < 3; k++)
			{
				i = k + 8;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 9;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 3;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 3;
				monster[i].shootInterval = Global.FPS * 25;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 4;
			}
			for (k = 0; k < 3; k++)
			{
				i = k + 11;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 9;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 3;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 3;
				monster[i].shootInterval = Global.FPS * 25;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 5;
			}
			for (k = 0; k < 3; k++)
			{
				i = k + 14;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 9;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 3;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 3;
				monster[i].shootInterval = Global.FPS * 25;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 6;
			}
			for (k = 0; k < 3; k++)
			{
				i = k + 17;
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 9;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 3;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 3;
				monster[i].shootInterval = Global.FPS * 25;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 7;
			}

				
			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,22,-1,-1,14,22,-1,-1,14,-1]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageMeteorite
		// ****************
		private function makeStageMeteorite():void
		{
			//++++++++
			//setLogInfo("makeStageMeteorite");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(231);

			i = 0;
			idx  = 231;
			idx2 = 231;
			idx3 = 232;
			monster[i].x = 640 + 200;
			monster[i].y = 240;
			monster[i].hp = 4000;
			//monster[i].hitRange = 12;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 400;
			monster[i].moveValX = -1;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//モンスター設定
			for (i = 1; i < monster.length; i++ )
			{
				//i = 0;
				idx  = 229;
				idx2 = 229;
				idx3 = 149;//230;

				monster[i].x = i * 32;
				monster[i].y = -32;
				
				//var r:Number = (Math.PI * 0.5) / monster.length * i;
				var r:Number = (Math.PI * 0.33) / monster.length * i;
				var d:int = 640 + mt.getRandInt(1920);
				monster[i].x = (64) + Math.cos(r) * d;
				monster[i].y = (480 - 64) + Math.sin(r) * -1 * d;
				
				monster[i].hp = 8;// 30; //50;

				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 1;// 0.5;
				monster[i].hitRange = 13;
				monster[i].isEnemy = false;
				monster[i].isBmpHit = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 1;
				monster[i].startShootFrameCnt = Global.FPS * 999;
				monster[i].shootInterval = Global.FPS * 999;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = i;
				monster[i].isUnbreakableMissile = false;// true;
			}

				
			//背景描画
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageOniParty
		// ****************
		/*
		private function makeStageOniParty():void
		{
			//++++++++
			//setLogInfo("makeStageOniParty");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(247);

			//モンスター設定
			//DPS1
			i = 0;
			idx  = 241;
			idx2 = 242;
			monster[i].x = 760;
			monster[i].y = 96;
			monster[i].hp = 2000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 440;
			monster[i].moveValX = -1;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//DPS2
			i = 1;
			idx  = 243;
			idx2 = 244;
			monster[i].x = 760;
			monster[i].y = 256;
			monster[i].hp = 2000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 440;
			monster[i].moveValX = -1;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//タンク
			i = 2;
			idx  = 239;
			idx2 = 240;
			monster[i].x = 640;
			monster[i].y = 176;
			monster[i].hp = 3000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_UPDOWN;
			monster[i].minX = 320;
			monster[i].moveValX = -1;
			monster[i].moveValY = 2;
			monster[i].minY = monster[i].y - 100;
			monster[i].maxY = monster[i].y + 100;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//ヒーラー1
			i = 3;
			idx  = 245;
			idx2 = 246;
			monster[i].x = 880;
			monster[i].y = 176 - 40;
			monster[i].hp = 1500;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 560;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//ヒーラー2
			i = 4;
			idx  = 245;
			idx2 = 246;
			monster[i].x = 880;
			monster[i].y = 176 + 40;
			monster[i].hp = 1500;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].minX = 560;
			monster[i].moveValX = -1;
			//monster[i].minY = monster[i].y;
			//monster[i].maxY = monster[i].y + 2;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//シールド
			idx  = 248;
			idx2 = 248;
			var scale:int = monsterImage[monsterImgNo[idx]].scaleX;
			for (k = 0; k < 3; k++ )
			{
				i = (i + 1) + k;
				//monster[i].x = monster[k].x - 4 * 3;
				//monster[i].y = monster[k].y;
				//monster[i].hp = 1000;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].movePattern = monster[k].movePattern;
				monster[i].minX = monster[k].minX;
				monster[i].moveValX = monster[k].moveValX;
				monster[i].moveValY = monster[k].moveValY;
				monster[i].minY = monster[k].minY;
				monster[i].maxY = monster[k].maxY;
				monster[i].isReflect = true;
				monster[i].isMissile = true;

				monster[i].isMissile = true;
				monster[i].missilePlusX = -4 * scale;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 1;
				//monster[i].moveVal = 80;
				monster[i].startShootFrameCnt = Global.FPS * 15 + k * 2;
				monster[i].shootInterval = Global.FPS * 999;
				monster[i].isDieFall = true;
				monster[i].isReflect = true;
				monster[i].isBmpHit = false;
				
				monster[i].hitRect.x = 0;
				monster[i].hitRect.y = 0;
				monster[i].hitRect.width = 4 * scale;
				monster[i].hitRect.height = 16 * scale;
				
				monster[i].shooterIdx = k;			//シールド対象者
				monster[i].bodyIdx = 3 + (k % 2);	//術者
			}
			
			//タンクには２つシールド
			k = 2;
			i = (i + 1);
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = monster[k].movePattern;
			monster[i].minX = monster[k].minX;
			monster[i].moveValX = monster[k].moveValX;
			monster[i].moveValY = monster[k].moveValY;
			monster[i].minY = monster[k].minY;
			monster[i].maxY = monster[k].maxY;
			monster[i].isReflect = true;
			monster[i].isMissile = true;

			monster[i].isMissile = true;
			monster[i].missilePlusX = -8 * scale;
			monster[i].missilePlusY = 0;
			monster[i].missileHP = 1;
			//monster[i].moveVal = 80;
			monster[i].startShootFrameCnt = Global.FPS * 15 + k * 2;
			monster[i].shootInterval = Global.FPS * 999;
			monster[i].isDieFall = true;
			monster[i].isReflect = true;
			monster[i].isBmpHit = false;
			
			monster[i].hitRect.x = 0;
			monster[i].hitRect.y = 0;
			monster[i].hitRect.width = 4 * scale;
			monster[i].hitRect.height = 16 * scale;
			
			monster[i].shooterIdx = k;	//シールド対象者
			monster[i].bodyIdx = 4;		//術者

			//攻撃弾
			//--------
			for (k = 0; k < 4; k++)
			{
				i = k + 7;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 4;
				monster[i].hitRange = 12;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 8;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 3;
				monster[i].shootInterval = Global.FPS * 20;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
			}
			//--------
			for (k = 0; k < 4; k++)
			{
				i = k + 11;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 4;
				monster[i].hitRange = 12;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 8;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 3;
				monster[i].shootInterval = Global.FPS * 20;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 1;
			}
				
			//背景描画
			haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1,14,-1,-1,22,-1,-1,14,22,-1,-1,14,-1]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			drawBackground(null, haikeiData, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}
		*/

		// ****************
		// makeStageRose
		// ****************
		private function makeStageRose():void
		{
			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(243);

			//モンスター設定(枯れ木)
			i = 0;
			idx  = 243;
			idx2 = 243;
			idx3 = 242;
			monster[i].x = 0;
			monster[i].y = 4;
			monster[i].hp = 1;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_NONE;
			monster[i].isEnemy = false;

			//モンスター設定(体)
			i = 1;
			idx  = 240;
			idx2 = 240;
			idx3 = 242;
			monster[i].x = 0;
			monster[i].y = 4;
			monster[i].hp = 6000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_NONE;
			monster[i].isBmpHit = true;
			//monster[i].isDieFall = true;

			//モンスター設定(花)
			i = 2;
			idx  = 239;
			idx2 = 239;
			idx = 239;
			monster[i].x = 540;
			monster[i].y = 84;
			monster[i].hp = 2000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];
			monster[i].movePattern = Monster.MOVE_NONE;
			monster[i].hitRange = 16 * 4;
			monster[i].isDieFall = true;
			
			monster[i].isReflect = true;
			monster[i].hontaiIdx = 1;
			
			//--------
			var _scale:int = monsterImage[monsterImgNo[240]].scaleX;
			var _tamaXY:Vector.<Point> = Vector.<Point>
			([
				new Point(9, 39),
				new Point(30, 35),
				new Point(49, 43),
				new Point(61, 38),
				new Point(72, 38),
				new Point(90, 35),
				new Point(102, 41),
				new Point(120, 50),
				new Point(131, 57),
				new Point(117, 70),
				new Point(120, 84),
				new Point(112, 92)
			]);
			/*
			for (k = 0; k < _tamaXY.length; k++)
			{
				i = 2 + k;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 1;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = _tamaXY[k].x * _scale;
				monster[i].missilePlusY = _tamaXY[k].y * _scale;
				monster[i].missileHP = 8;
				monster[i].startShootFrameCnt = Global.FPS * 15;
				monster[i].shootInterval = Global.FPS * 20;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
			}
			*/
			for (k = 0; k < _tamaXY.length; k++)
			{
				i = 3 + k;
				idx  = 241;
				idx2 = 241;
				idx3 = 241;
				monster[i].x = _tamaXY[k].x * _scale;
				monster[i].y = _tamaXY[k].y * _scale;
				monster[i].hp = 300;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_NONE;
				monster[i].hitRange = 14;
				monster[i].isDieFall = true;
			}
			for (k = 0; k < _tamaXY.length; k++)
			{
				i = 3 + 12 + k;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				//monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].movePattern = Monster.MOVE_TAN2WAVE;
				monster[i].moveVal = 3;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 1;
				monster[i].startShootFrameCnt = Global.FPS * 15 + k;
				monster[i].shootInterval = Global.FPS * 20;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 3 + k;
			}
			for (k = 0; k < _tamaXY.length; k++)
			{
				i = 3 + 24 + k;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				//monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].movePattern = Monster.MOVE_TAN2WAVE;
				monster[i].moveVal = 3;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 1;
				monster[i].startShootFrameCnt = Global.FPS * 16 + k;
				monster[i].shootInterval = Global.FPS * 20;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 3 + k;
			}
			for (k = 0; k < _tamaXY.length; k++)
			{
				i = 3 + 36 + k;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				//monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].movePattern = Monster.MOVE_TAN2WAVE;
				monster[i].moveVal = 3;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 1;
				monster[i].startShootFrameCnt = Global.FPS * 17 + k;
				monster[i].shootInterval = Global.FPS * 20;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 3 + k;
			}
			
			for (k = 0; k < 8; k++)
			{
				i = 3 + 48 + k;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 3;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 0;
				monster[i].missileHP = 3;
				monster[i].startShootFrameCnt = Global.FPS * 10 + (k * 12);
				monster[i].shootInterval = Global.FPS * 20;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 2;
			}

//flashStage.addChild(bmpForHit);


			//背景描画
			//haikeiData3 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,61]);
			//haikeiData2 = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16,-1,16]);
			//haikeiData  = Vector.<int>([-1,-1,-1,-1,-1,-1,67,67,66,67,67,67,66,67,67,66,66,67,66,67]);
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageChamaeleon
		// ****************
		private function makeStageChamaeleon():void
		{
			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(244);

			//モンスター設定(枯れ木)
/*
			i = 0;
			idx  = 246;
			idx2 = 246;
			idx3 = 242;
			monster[i].x = 0;
			monster[i].y = 0;
			monster[i].hp = 1;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_NONE;
			monster[i].isEnemy = false;
*/
			//モンスター設定
			i = 0;
			idx  = 244;
			idx2 = 245;
			idx3 = 244;
			monster[i].x = 0;
			monster[i].y = 4;
			monster[i].hp = 7000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_CHAMAELEON;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			//--------
			for (k = 0; k < 8; k++)
			{
				i = k + 1;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 9;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 9 * 2;
				monster[i].missilePlusY = 30 * 2;
				monster[i].missileHP = 8;
				monster[i].startShootFrameCnt = Global.FPS * 8 + k * 3;
				monster[i].shootInterval = Global.FPS * 10;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
			}
			//--------

			//背景描画
			drawBackground(null, null, null, null);
			image[246].x = 0;
			image[246].y = 0;
			image[246].scaleX = 2;
			image[246].scaleY = 2;
			image[246].smoothing = TextureSmoothing.NONE;
			renderTextureFixed.draw(image[246]);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageTengu
		// ****************
		private function makeStageTengu():void
		{
			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(248);

			//モンスター設定
			i = 1;
			idx  = 247;
			idx2 = 248;
			idx3 = 247;
			monster[i].x = 450;// 400;
			monster[i].y = 0;// 120;
			monster[i].hp = 14000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_TENGU;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;
			
			monster[i].maxY = 120;
			monster[i].moveValY = 4;


			//団扇
			i = 0;
			idx  = 249;
			idx2 = 249;
			idx3 = 242;
			monster[i].x = monster[1].x - 32;
			monster[i].y = monster[1].y - 42;
			monster[i].hp = 1100;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_UCHIWA;
			monster[i].hitRange2 = 24 * 24;
			monster[i].hitRange2X = 0;	//move処理で値を代入
			monster[i].hitRange2Y = 0;	//move処理で値を代入
			monster[i].isDieFall = true;
			monster[i].bodyIdx = 1;	//1:本体
			
			monster[i].maxY = monster[1].maxY - 42;
			monster[i].moveValY = 4;

			//--------
			//風
			for (k = 0; k < 2; k++)
			{
				i = k + 2;
				//idx  = 242;
				//idx2 = 242;
				idx  = 253;
				idx2 = 253;
				idx3 = 242;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				//monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 10;// 6;// 4;
				monster[i].hitRange = 64;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 32 * 4;
				monster[i].missileHP = 8;
				monster[i].startShootFrameCnt = Global.FPS * 4 + k * 8;
				monster[i].shootInterval = Global.FPS * 5;
				monster[i].isDieFall = true;
				
				monster[i].isNoDamage = true;
				monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveValX = -4;
				monster[i].minX = 100;
				monster[i].maxX = 480;
				
				monster[i].shooterIdx = 0;	//団扇
				
				monster[i].isReflect = true;
			}
			//--------
			//鬼火弾
			for (k = 0; k < 1; k++)
			{
				i = k + 10;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				//monster[i].movePattern = Monster.MOVE_TAN2;
				monster[i].moveVal = 10;// 6;// 4;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 0;
				monster[i].missilePlusY = 24 * 4;// 32 * 4;
				monster[i].missileHP = 50;
				//monster[i].startShootFrameCnt = Global.FPS * 4 + k * 8;
				monster[i].startShootFrameCnt = Global.FPS * 9 + 1 * 8 - 6;
				monster[i].shootInterval = Global.FPS * 10;
				monster[i].isDieFall = true;
				
				monster[i].movePattern = Monster.MOVE_TAN2;// _VANISH;
				monster[i].moveValX = -4;
				monster[i].minX = 100;
				monster[i].maxX = 480;
				
				monster[i].shooterIdx = 1;
			}
			//--------

			//背景描画
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageGaruda
		// ****************
		private function makeStageGaruda():void
		{
			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;

			//破魔弓
			setHamayumi();

			remainTime = 120 * Global.FPS;

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//矢倉設定
			yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(257);

			//モンスター設定
			i = 0;
			idx  = 255;
			idx2 = 256;
			idx3 = 255;
			monster[i].x = 320;// 400;
			monster[i].y = -320;// 120;
			monster[i].hp = 30000;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_GARUDA;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;
			
			//monster[i].maxY = 120;
			//monster[i].moveValY = 4;

			//--------
			//鬼火弾A
			for (k = 0; k < 5; k++)
			{
				i = k + 1;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_TAN2WAVE;
				monster[i].moveVal = 8;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 16 * 4 + k * 4;
				monster[i].missilePlusY = 24 * 4 + k * 4;
				monster[i].missileHP = 50;
				monster[i].startShootFrameCnt = Global.FPS * 10 + k * 8;
				monster[i].shootInterval = Global.FPS * 30;
				monster[i].isDieFall = true;
				
				monster[i].shooterIdx = 0;
			}
			//鬼火弾B
			for (k = 0; k < 5; k++)
			{
				i = k + 6;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_FALL_AUTO;
				monster[i].moveVal = 8;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 16 * 4 + k * 4;
				monster[i].missilePlusY = 24 * 4 + k * 4;
				monster[i].missileHP = 50;
				monster[i].startShootFrameCnt = Global.FPS * 20 + k * 8;
				monster[i].shootInterval = Global.FPS * 30;
				monster[i].isDieFall = true;
				
				monster[i].movePattern = Monster.MOVE_FALL_AUTO;
				//monster[i].missilePower = -8;
				monster[i].missilePower = -10 - (k * 0.2);//-8 - (k * 0.2);
				monster[i].moveValX = 3;
				monster[i].fallValue = 0.2;
				monster[i].power = monster[i].missilePower;
				
				monster[i].shooterIdx = 0;
			}
			//鬼火弾C
			for (k = 0; k < 5; k++)
			{
				i = k + 11;
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoWalkRight1 = monsterImgNo[idx];
				monster[i].imgNoWalkRight2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx3];
				monster[i].imgNoDeadRight = monsterImgNo[idx3];
				monster[i].movePattern = Monster.MOVE_FALL2B;
				monster[i].moveVal = 8;
				monster[i].hitRange = 10;
				monster[i].isEnemy = false;
				
				monster[i].isMissile = true;
				monster[i].missilePlusX = 16 * 4 + k * 4;
				monster[i].missilePlusY = 24 * 4 + k * 4;
				monster[i].missileHP = 50;
				monster[i].startShootFrameCnt = Global.FPS * 30 + k * 8;
				monster[i].shootInterval = Global.FPS * 30;
				monster[i].isDieFall = true;
				
				monster[i].movePattern = Monster.MOVE_FALL2B;
				monster[i].missilePower = 0;// -8 - (k * 0.2);
				monster[i].moveValX = 3;
				monster[i].fallValue = 0.4;// 0.2;
				monster[i].power = monster[i].missilePower;
				monster[i].minX = -64;
				monster[i].maxX = 640;
				monster[i].minY = 0;
				monster[i].maxY = 480 - 32 - 16;
				
				monster[i].shooterIdx = 0;
			}
			//--------

			//背景描画
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
		}

		// ****************
		// makeStageTeisatsuA
		// ****************
		private var isTeisatsu:Boolean = false;
		private var setAttackPattern:Function = setAttackPattern0;
		private function makeStageTeisatsuA():void
		{
			//++++++++
			//setLogInfo("makeStageTeisatsuA");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			//remainTime = 120 * Global.FPS;
			if (isTeisatsu)
			{
				//remainTime = 18 * Global.FPS;
				remainTime = 20 * Global.FPS;
				//矢倉設定
				yagura.init(true, 1);
			}
			else
			{
				remainTime = 120 * Global.FPS;
				//矢倉設定
				yagura.init(true, 5);
			}
			
			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			////矢倉設定
			//yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(235);

			i = 0;
			idx  = 233;
			idx2 = 234;
			idx3 = 233;
			monster[i].x = 640;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
			monster[i].minX = 640 - monsterImage[monsterImgNo[idx]].width;
			monster[i].hp = 4000;
			//monster[i].hitRange = 12;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].moveValX = -1;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;

			setAttackPattern(1);

			//背景描画
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
			
			//-------- ステージNoとドット数に応じてHP変動 --------
			changeReportHP(0);
			//--------
		}
		
		// ****************
		// makeStageTeisatsuB
		// ****************
		private function makeStageTeisatsuB():void
		{
			//++++++++
			//setLogInfo("makeStageTeisatsuB");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;

			//破魔弓
			setHamayumi();

			//remainTime = 120 * Global.FPS;
			if (isTeisatsu)
			{
				//remainTime = 18 * Global.FPS;
				remainTime = 20 * Global.FPS;
				//矢倉設定
				yagura.init(true, 1);
			}
			else
			{
				remainTime = 120 * Global.FPS;
				//矢倉設定
				yagura.init(true, 5);
			}

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			////矢倉設定
			//yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(235);

			//モンスター設定
			//スライム
			idx  = 233;
			idx2 = 234;
			var tekiCnt:int = 15;
			var mi:Image = monsterImage[monsterImgNo[233]];
			for (i = 0; i < tekiCnt; i++)
			{
				//monster[i].x = 400 + (i % 8) * 32;
				monster[i].x = 376 + (i % 8) * 32;
				monster[i].y = 480 + int(i / 8) * 32 ;
				monster[i].v = -0.5 * (i % 3);
				monster[i].hp = 150;
				monster[i].moveValX = 0;//0.5;
				monster[i].moveValY = -0.5;
				//monster[i].hitRange = 14;
				monster[i].phase = 0;
				monster[i].movePattern = Monster.MOVE_JUMPPING;
				//monster[i].maxY = 480 - 32 - 16;
				monster[i].maxY = 480 - 32 - mi.height;
				
				monster[i].maxV = -6 + (i % 2);
				//var h:int = mi.height / mi.scaleY;
				//monster[i].maxV = -1 * Math.sqrt(h) + (i % 2);
				
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].minX = -64;
				monster[i].isDieFall = true;

				monster[i].isBmpHit = true;
			}

			setAttackPattern(tekiCnt);

			//背景描画
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
			
			//-------- ステージNoとドット数に応じてHP変動 --------
			changeReportHP(1);
			//--------
		}

		// ****************
		// makeStageTeisatsuC
		// ****************
		private function makeStageTeisatsuC():void
		{
			//++++++++
			//setLogInfo("makeStageTeisatsuC");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;

			//破魔弓
			setHamayumi();

			//remainTime = 120 * Global.FPS;
			if (isTeisatsu)
			{
				//remainTime = 18 * Global.FPS;
				remainTime = 20 * Global.FPS;
				//矢倉設定
				yagura.init(true, 1);
			}
			else
			{
				remainTime = 120 * Global.FPS;
				//矢倉設定
				yagura.init(true, 5);
			}

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			////矢倉設定
			//yagura.init(true, 5);

			//モンスター設定
			//上空
//当たり判定用bmp作成
makeHitBmp(235);

			idx = 233;
			idx2 = 234;
			var tekiCnt:int = 10;
			var mi:Image = monsterImage[monsterImgNo[idx]];
			for (i = 0; i < tekiCnt; i++)
			{
				//monster[i].x = 160 + mt.getRandInt(480 - mi.width)
				//monster[i].y = 0 - mi.height + mt.getRandInt(3) * mi.height;
				
				monster[i].x = 128 + i * 48;
				monster[i].y = 0 - (i % 3) * 32;
				
				monster[i].hp = 200;
				//monster[i].moveValX = 1;
				monster[i].moveValY = 1;
				//monster[i].hitRange = 16;
				monster[i].isBmpHit = true;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];

				//monster[i].minX = -64;
				monster[i].minY = -64;
				//monster[i].maxY = 80 + mt.getRandInt(3) * mi.height;
				monster[i].maxY = (32*3) - (i % 3) * 32;

				monster[i].isDieFall = true;

			}

			setAttackPattern(tekiCnt);

			//背景描画
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
			
			//-------- ステージNoとドット数に応じてHP変動 --------
			changeReportHP(2);
			//--------
		}

		// ****************
		// makeStageTeisatsuD
		// ****************
		private function makeStageTeisatsuD():void
		{
			//++++++++
			//setLogInfo("makeStageTeisatsuD");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;
			var idx4:int;
			var idx5:int;
			var idx6:int;
			var cnt:int = 0;

			//破魔弓
			setHamayumi();

			//remainTime = 120 * Global.FPS;
			if (isTeisatsu)
			{
				//remainTime = 18 * Global.FPS;
				remainTime = 20 * Global.FPS;
				//矢倉設定
				yagura.init(true, 1);
			}
			else
			{
				remainTime = 120 * Global.FPS;
				//矢倉設定
				yagura.init(true, 5);
			}
			
			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			////矢倉設定
			//yagura.init(true, 5);

//当たり判定用bmp作成
makeHitBmp(235);

			i = 0;
			idx  = 233;
			idx2 = 234;
			idx3 = 233;
/*
			monster[i].x = 640;
			monster[i].y = 480 - 32 - monsterImage[monsterImgNo[idx]].height;
			monster[i].minX = 640 - monsterImage[monsterImgNo[idx]].width;
			monster[i].hp = 4000;
			//monster[i].hitRange = 12;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx3];
			monster[i].movePattern = Monster.MOVE_LEFT_STOP;
			monster[i].moveValX = -1;
			monster[i].isBmpHit = true;
			monster[i].isDieFall = true;
*/

			monster[i].x = 640 - monsterImage[monsterImgNo[idx]].width;
			monster[i].y = -1 * monsterImage[monsterImgNo[idx]].height;

			monster[i].hp = 3000;
			monster[i].moveValY = 2;
			monster[i].isBmpHit = true;
			monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
			monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
			monster[i].imgNoDeadLeft = monsterImgNo[idx];

			monster[i].minY = monster[i].y;
			monster[i].maxY = 0;

			monster[i].isDieFall = true;


			setAttackPattern(1);

			//背景描画
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
			
			//-------- ステージNoとドット数に応じてHP変動 --------
			changeReportHP(3);
			//--------
		}

		// ****************
		// makeStageTeisatsuD
		// ****************
		/*
		private function makeStageTeisatsuD():void
		{
			//++++++++
			//setLogInfo("makeStageTeisatsuD");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;

			//破魔弓
			setHamayumi();

			//remainTime = 120 * Global.FPS;
			if (isTeisatsu)
			{
				remainTime = 18 * Global.FPS;
				//矢倉設定
				yagura.init(true, 1);
			}
			else
			{
				remainTime = 120 * Global.FPS;
				//矢倉設定
				yagura.init(true, 5);
			}

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//モンスター設定

			//当たり判定用bmp作成
			makeHitBmp(235);

			idx = 233;
			idx2 = 234;
			var tekiCnt:int = 10;
			var mi:Image = monsterImage[monsterImgNo[idx]];
			for (i = 0; i < tekiCnt; i++)
			{				
				monster[i].x = 640 + (i * mi.width);
				monster[i].y = (480 - 32) - mi.height;
				monster[i].hp = 300;
				monster[i].isBmpHit = true;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].movePattern = Monster.MOVE_LEFT_STOP;
				monster[i].maxY = (480 - 32);
				monster[i].minX = 140 + (i * 50);
				monster[i].moveValX = -1;
				monster[i].isDieFall = true;
			}

			setAttackPattern(tekiCnt);

			//背景描画
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
			
			//-------- ステージNoとドット数に応じてHP変動 --------
			changeReportHP(2);
			//--------
		}
		*/

		// ****************
		// makeStageTeisatsuE
		// ****************
		/*
		private function makeStageTeisatsuE():void
		{
			//++++++++
			//setLogInfo("makeStageTeisatsuE");
			//++++++++

			var i:int;
			var k:int;
			var idx:int;
			var idx2:int;
			var idx3:int;

			//破魔弓
			setHamayumi();

			//remainTime = 120 * Global.FPS;
			if (isTeisatsu)
			{
				remainTime = 18 * Global.FPS;
				//矢倉設定
				yagura.init(true, 1);
			}
			else
			{
				remainTime = 120 * Global.FPS;
				//矢倉設定
				yagura.init(true, 5);
			}

			for (i = 0; i < archer.length; i++)
			{
				archer[i].initCoop(i);
			}

			//モンスター設定

			//当たり判定用bmp作成
			makeHitBmp(235);

			idx = 233;
			idx2 = 234;
			var tekiCnt:int = 8;
			var mi:Image = monsterImage[monsterImgNo[idx]];
			for (i = 0; i < tekiCnt; i++)
			{				
				monster[i].x = 640;
				monster[i].y = (480 - 32) - (mi.height * (i + 1));
				monster[i].hp = 300;
				monster[i].isBmpHit = true;
				monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
				monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
				monster[i].imgNoDeadLeft = monsterImgNo[idx];
				monster[i].movePattern = Monster.MOVE_TSUMIKI;
				monster[i].maxY = (480 - 32) - mi.height;
				monster[i].minX = 480;
				monster[i].moveValX = -1;
				monster[i].isDieFall = true;
				
				monster[i].dotHeight = mi.height;
			}

			setAttackPattern(tekiCnt);

			//背景描画
			drawBackground(null, null, null, null);

			//空描画
			drawPurpleSky();
			//テキスト設定
			setEndTextJissen();
			
			//-------- ステージNoとドット数に応じてHP変動 --------
			changeReportHP(2);
			//--------
		}
		*/

		//--------
		// changeReportHP
		// ステージNoとドット数に応じてHP変動
		//--------
		private function changeReportHP(_stageType:int):void
		{
			//++++++++
			//setLogInfo("changeReportHP:" + _stageType + ":" + scenario.no);
			//++++++++
			
			var i:int;
			var baseDot:int = 1;
			var baseHeight:int = 1;
			var baseHP:int = 1;
			var baseScle:int = 1;
			var dotCnt:int = 1;
			var dotHeight:int = 1;
			var dotScale:int = 1;
			var _hp:int = 0;
			
			//REPORT_LV1はそのまま
			
			if (scenario.no == Scenario.REPORT_LV2)
			{
				if (_stageType == 0)
				{
					//基準は大蛇亜種 2517dot -> HP:4000 scale:4
					baseDot = 2517 * 4;
					baseHP = 4000 + 200;	//ステージ補正+5%
				}
				else if (_stageType == 1)
				{
					//青鬼 dot103 -> HP:150 scale:2
					baseDot = 103 * 2;
					baseHP = 150 - 15;		//硬いのでステージ補正なし、むしろ減らす-10%
				}
				else if (_stageType == 2)
				{
					//ハーピー dot74 -> HP:200 scale:3
					baseDot = 74 * 3;
					baseHP = 200 - 20;		//硬いのでステージ補正なし、むしろ減らす-10%
				}
				
				dotCnt = Global.reportGamen.getDotCnt();
				dotScale = Global.reportGamen.getDotScale();
				dotCnt = dotCnt * dotScale;
				for (i = 0; i < monster.length; i++ )
				{
					if ((0 < monster[i].hp) && (monster[i].isEnemy))
					{
						if (baseDot <= dotCnt)
						{
							monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
						}
						else
						{
							monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 2);
						}
					}
				}
			}
			else if (scenario.no == Scenario.REPORT_LV3)
			{
				if (_stageType == 0)
				{
					//基準は大蛇亜種 height:54 -> HP:4000 scale:4
					baseHeight = 54 * 4;
					baseHP = 4000 * 1.3;	//ステージ補正+30%
				}
				else if (_stageType == 1)
				{
					//青鬼 dot103 -> HP:150 scale:2
					baseDot = 103 * 2;
					baseHP = 150 * 1.1;		//ステージ補正+10%
				}
				else if (_stageType == 2)
				{
					//ハーピー dot74 -> HP:200 scale:3
					baseDot = 74 * 3;
					baseHP = 200 - 0;		//硬いのでステージ補正なし
				}

				dotCnt = Global.reportGamen.getDotCnt();
				dotHeight = Global.reportGamen.getDotHeight();
				dotScale = Global.reportGamen.getDotScale();
				dotHeight = dotHeight * dotScale;
				dotCnt = dotCnt * dotScale;
				for (i = 0; i < monster.length; i++ )
				{
					if ((0 < monster[i].hp) && (monster[i].isEnemy))
					{
						if (_stageType == 0)
						{
							//単体(ドットの高さで計算)
							monster[i].hp = baseHP * (dotHeight / baseHeight);
						}
						else
						{
							//複数体（ドット数で計算）
							monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
						}
					}
				}
			}
			else if (scenario.no == Scenario.REPORT_LV4)
			{
				if (_stageType == 0)
				{
					//基準は大蛇亜種 2517dot -> HP:4000 scale:4
					baseDot = 2517 * 4;
					baseHP = 4000 * 1.4;	//ステージ補正+40%
				}
				else if (_stageType == 1)
				{
					//青鬼 dot103 -> HP:150 scale:2
					baseDot = 103 * 2;
					baseHP = 150 * 1.25;	//ステージ補正+25%
				}
				else if (_stageType == 2)
				{
					//ハーピー dot74 -> HP:200 scale:3
					baseDot = 74 * 3;
					baseHP = 200 * 1.25;	//ステージ補正+25%
				}
				
				dotCnt = Global.reportGamen.getDotCnt();
				dotScale = Global.reportGamen.getDotScale();
				dotCnt = dotCnt * dotScale;
				for (i = 0; i < monster.length; i++ )
				{
					if ((0 < monster[i].hp) && (monster[i].isEnemy))
					{
						if (_stageType == 0)
						{
							//単体
							if (baseDot <= dotCnt)
							{
								monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 2);
							}
							else
							{
								monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
							}
						}
						else
						{
							//複数体
							monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
						}
					}

					if (monster[i].isMissile)
					{
						monster[i].missileHP = 7;
					}
				}
			}
			else if (scenario.no == Scenario.REPORT_LV5)
			{
				if (_stageType == 0)
				{
					//基準は大蛇亜種 2517dot -> HP:4000 scale:4
					baseDot = 2517 * 4;
					baseHP = 4000 * 1.6;	//ステージ補正+60%
				}
				else if (_stageType == 1)
				{
					//青鬼 dot103 -> HP:150 scale:2
					baseDot = 103 * 2;
					baseHP = 150 * 1.4;	//ステージ補正+40%
				}
				else if (_stageType == 2)
				{
					//ハーピー dot74 -> HP:200 scale:3
					baseDot = 74 * 3;
					baseHP = 200 * 1.4;	//ステージ補正+40%
				}
				
				dotCnt = Global.reportGamen.getDotCnt();
				dotScale = Global.reportGamen.getDotScale();
				dotCnt = dotCnt * dotScale;
				for (i = 0; i < monster.length; i++ )
				{
					if ((0 < monster[i].hp) && (monster[i].isEnemy))
					{
						if (_stageType == 0)
						{
							//単体
							if (baseDot <= dotCnt)
							{
								monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 2);
							}
							else
							{
								monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
							}
						}
						else
						{
							//複数体
							monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
						}
					}

					if (monster[i].isMissile)
					{
						monster[i].missileHP = 8;
					}
				}
			}
			else if (scenario.no == Scenario.REPORT_LV6)
			{
				if (_stageType == 0)
				{
					//基準は大蛇亜種 2517dot -> HP:4000 scale:4
					baseDot = 2517 * 4;
					baseHP = 4000 * 2.0;	//ステージ補正+100%
				}
				else if (_stageType == 1)
				{
					//青鬼 dot103 -> HP:150 scale:2
					baseDot = 103 * 2;
					baseHP = 150 * 1.6;	//ステージ補正+60%
				}
				else if (_stageType == 2)
				{
					//ハーピー dot74 -> HP:200 scale:3
					baseDot = 74 * 3;
					baseHP = 200 * 1.6;	//ステージ補正+60%
				}

				//討伐情報によるHP補正率取得
				var hoseiRate:Number = 1.0;
				// ================
				if (usvr.isJoinSuccess)
				{
					try
					{
						hoseiRate = (Number)(usvr.room.getAttribute("tobatsu"));
					}
					catch (e:Error)
					{
						//++++++++
						//Game.setLogInfo("Scenario.REPORT_LV6:" + e.errorID);
						//++++++++
					}

					if (hoseiRate <= 0.0)
					{
						//念のため
						(new TextLogConnect()).connect(Global.username + " NG hoseiRate" + hoseiRate);
						hoseiRate = 1.0;
					}
				}
				else
				{
					//OFFLINE
					hoseiRate = Global.reportGamen.getTobatsuHosei(scenario.no);
				}
				// ================

				dotCnt = Global.reportGamen.getDotCnt();
				dotScale = Global.reportGamen.getDotScale();
				dotCnt = dotCnt * dotScale;
				for (i = 0; i < monster.length; i++ )
				{
					if ((0 < monster[i].hp) && (monster[i].isEnemy))
					{
						if (_stageType == 0)
						{
							//単体
							monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
							
							//吸血鬼の当たり判定が小さくて倒せない対策
							if (dotCnt < 200)
							{
								monster[i].hp *= 0.5;
							}
						}
						else
						{
							//複数体
							monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
						}					
						//討伐情報による補正
						monster[i].hp *= hoseiRate;
						
						if (Connect.isLocalSite())
						{
							stageTitle.text = "HP:" + monster[i].hp + " DOT:" + dotCnt;
						}
					}

					if (monster[i].isMissile)
					{
						monster[i].missileHP = 8;
					}
				}
			}
			else if (scenario.no == Scenario.REPORT_LV7)
			{
				if (_stageType == 0)
				{
					//基準は大蛇亜種 2517dot -> HP:4000 scale:4
					baseDot = 2517 * 4;
					baseHP = 4000 * 2.0;	//ステージ補正+100%
				}
				else if (_stageType == 1)
				{
					//青鬼 dot103 -> HP:150 scale:2
					baseDot = 103 * 2;
					baseHP = 150 * 1.7;	//ステージ補正+70%
				}
				else if (_stageType == 2)
				{
					//ハーピー dot74 -> HP:200 scale:3
					baseDot = 74 * 3;
					baseHP = 200 * 1.7;	//ステージ補正+70%
				}

				dotCnt = Global.reportGamen.getDotCnt();
				dotScale = Global.reportGamen.getDotScale();
				dotCnt = dotCnt * dotScale;
				for (i = 0; i < monster.length; i++ )
				{
					if ((0 < monster[i].hp) && (monster[i].isEnemy))
					{
						if (_stageType == 0)
						{
							//単体
							//monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
							//monster[i].hp = (baseHP * 0.50) + (baseHP * 0.50) * (Math.pow((dotCnt / baseDot), 1 / 2));
							monster[i].hp = (baseHP * 0.40) + (baseHP * 0.60) * (Math.pow((dotCnt / baseDot), 1 / 2));
						}
						else
						{
							//複数体
							monster[i].hp = baseHP * Math.pow((dotCnt / baseDot), 1 / 4);
							
							//U-Rayの当たり判定が小さ過ぎる対策
							if (dotCnt < 100)
							{
								monster[i].hp = 50;
							}
						}
						
						if (Connect.isLocalSite())
						{
							stageTitle.text = "HP:" + monster[i].hp;
						}
						
					}

					if (monster[i].isMissile)
					{
						monster[i].missileHP = 8;
					}
				}
			}
			else if (scenario.no == Scenario.REPORT_LV8)
			{
				for (i = 0; i < monster.length; i++ )
				{
					if ((0 < monster[i].hp) && (monster[i].isEnemy))
					{
						//--------デフォルトHP
						if (_stageType == 0)
						{
							//単体
							monster[i].hp = 10000;
						}
						else if (_stageType == 1)
						{
							//複数：地面
							monster[i].hp = 400;
						}
						else if (_stageType == 2)
						{
							//複数：上空
							monster[i].hp = 300;
						}
						//--------
						
						//tableにHPデータが別で用意されていれば代入
						_hp = int(Global.reportTbl.getData(Global.reportGamen.pageNo, "HP"));
						if (0 < _hp)
						{
							monster[i].hp = _hp;
						}
						
						if (Connect.isLocalSite())
						{
							stageTitle.text = "HP:" + monster[i].hp;
						}
					}

					if (monster[i].isMissile)
					{
						monster[i].missileHP = 8;
					}
				}
			}
			else if (scenario.no == Scenario.REPORT_LV9)
			{
				for (i = 0; i < monster.length; i++ )
				{
					if ((0 < monster[i].hp) && (monster[i].isEnemy))
					{
						//--------デフォルトHP
						if (_stageType == 0)
						{
							//単体
							monster[i].hp = 11000;
						}
						else if (_stageType == 1)
						{
							//複数：地面
							monster[i].hp = 440;
						}
						else if (_stageType == 2)
						{
							//複数：上空
							monster[i].hp = 330;
						}
						//--------
						
						//tableにHPデータが別で用意されていれば代入
						_hp = int(Global.reportTbl.getData(Global.reportGamen.pageNo, "HP"));
						if (0 < _hp)
						{
							monster[i].hp = _hp;
						}
						
						if (Connect.isLocalSite())
						{
							stageTitle.text = "HP:" + monster[i].hp;
						}
					}

					if (monster[i].isMissile)
					{
						monster[i].missileHP = 8;
					}
				}
			}
			else if (scenario.no == Scenario.REPORT_LV10)
			{
				setReportMonsterLv10(_stageType);
			}
			else if (scenario.no == Scenario.REPORT_LV11)
			{
				setReportMonsterLv11(_stageType);
			}
			else if (scenario.no == Scenario.REPORT_LV12)
			{
				setReportMonsterLv12(_stageType);
			}
		}
		
		//----------------
		// setReportMonsterLv10
		//----------------
		private function setReportMonsterLv10(_stageType:int):void
		{
			var i:int;
			var _hp:int = 0;

			for (i = 0; i < monster.length; i++ )
			{
				if ((0 < monster[i].hp) && (monster[i].isEnemy))
				{
					//--------デフォルトHP
					if (_stageType == 0)
					{
						//単体
						monster[i].hp = 13000;
					}
					else if (_stageType == 1)
					{
						//複数：地面
						monster[i].hp = 480;
					}
					else if (_stageType == 2)
					{
						//複数：上空
						monster[i].hp = 360;
					}
					else if (_stageType == 3)
					{
						//単体：上空
						monster[i].hp = 10000;
					}
					//--------
					
					//tableにHPデータが別で用意されていれば代入
					_hp = int(Global.reportTbl.getData(Global.reportGamen.pageNo, "HP"));
					if (0 < _hp)
					{
						monster[i].hp = _hp;
					}
					
					if (Connect.isLocalSite())
					{
						stageTitle.text = "HP:" + monster[i].hp;
					}
				}

				if (monster[i].isMissile)
				{
					monster[i].missileHP = 8;
				}
			}
		}

		//----------------
		// setReportMonsterLv11
		//----------------
		private function setReportMonsterLv11(_stageType:int):void
		{
			var i:int;
			var _hp:int = 0;

			for (i = 0; i < monster.length; i++ )
			{
				if ((0 < monster[i].hp) && (monster[i].isEnemy))
				{
					//--------デフォルトHP
					if (_stageType == 0)
					{
						//単体
						monster[i].hp = 18000;
					}
					else if (_stageType == 1)
					{
						//複数：地面
						monster[i].hp = 800;
					}
					else if (_stageType == 2)
					{
						//複数：上空
						monster[i].hp = 600;
					}
					else if (_stageType == 3)
					{
						//単体：上空
						monster[i].hp = 14000;
					}
					//--------
					
					//tableにHPデータが別で用意されていれば代入
					_hp = int(Global.reportTbl.getData(Global.reportGamen.pageNo, "HP"));
					if (0 < _hp)
					{
						monster[i].hp = _hp;
					}
					
					if (Connect.isLocalSite())
					{
						stageTitle.text = "HP:" + monster[i].hp;
					}
				}

				if (monster[i].isMissile)
				{
					monster[i].missileHP = 8;
				}
			}
		}

		//----------------
		// setReportMonsterLv12
		//----------------
		private function setReportMonsterLv12(_stageType:int):void
		{
			var i:int;
			var _hp:int = 0;

			for (i = 0; i < monster.length; i++ )
			{
				if ((0 < monster[i].hp) && (monster[i].isEnemy))
				{
					//--------デフォルトHP
					if (_stageType == 0)
					{
						//単体
						monster[i].hp = 20000;
					}
					else if (_stageType == 1)
					{
						//複数：地面
						monster[i].hp = 1200;
					}
					else if (_stageType == 2)
					{
						//複数：上空
						monster[i].hp = 660;
					}
					else if (_stageType == 3)
					{
						//単体：上空
						monster[i].hp = 16000;
					}
					//--------
					
					//tableにHPデータが別で用意されていれば代入
					_hp = int(Global.reportTbl.getData(Global.reportGamen.pageNo, "HP"));
					if (0 < _hp)
					{
						monster[i].hp = _hp;
					}
					
					if (Connect.isLocalSite())
					{
						stageTitle.text = "HP:" + monster[i].hp;
					}
				}

				if (monster[i].isMissile)
				{
					monster[i].missileHP = 8;
				}
			}
		}

		//----------------
		// setAttackPattern0
		// 報告書用攻撃パターン：打上
		//----------------
		private function setAttackPattern0(tekiCnt:int):void 
		{
			//++++++++
			//setLogInfo("setAttackPattern0");
			//++++++++

			var i:int;
			var k:int;
			var idx:int, idx2:int, idx3:int;
			
			//敵弾は深度４から変わる
			if (scenario.isReidan10bai())
			{
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
			}
			else
			{
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
			}

			//偵察or深度７から弾もユーザ登録式
			if ((Scenario.REPORT_LV7 <= scenario.no) || (isTeisatsu == true))
			{
				idx  = 237;
				idx2 = 238;
				idx3 = 149;
				monsterImage[monsterImgNo[idx]].pivotX = monsterImage[monsterImgNo[idx2]].pivotX = 8;
				monsterImage[monsterImgNo[idx]].pivotY = monsterImage[monsterImgNo[idx2]].pivotY = 8;
				
				//通常弾使用
				if (isOnibi1Normal)
				{
					idx = 236;
				}
				if (isOnibi2Normal)
				{
					idx2 = 236;
				}
			}
			
			//--------
			if (tekiCnt == 1)
			{
				//単体
				for (k = 0; k < 8; k++)
				{
					i = k + 1;
					/*
					idx  = 134;
					idx2 = 135;
					idx3 = 149;
					*/
					//monster[i].x = 480;
					//monster[i].y = 480 - 32;
					//monster[i].hp = 0;	//弾非表示はhp0
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx3];
					//monster[i].movePattern = Monster.MOVE_NORMAL;
					//monster[i].moveInterval = Global.halfFPS;
					monster[i].moveValX = 3;//3;
					monster[i].moveValY = (k % 8) * 0.05 + 0.3;
					monster[i].minX = -64;
					monster[i].maxX = 640;
					monster[i].minY = 0;
					monster[i].maxY = 480;
					monster[i].hitRange = 9;// 8;
					monster[i].isEnemy = false;
					
					monster[i].isMissile = true;
					monster[i].missilePlusX = makeGamen.report.onibiX * monsterImage[monsterImgNo[233]].scaleX;// + k * 3;
					monster[i].missilePlusY = makeGamen.report.onibiY * monsterImage[monsterImgNo[233]].scaleY - i;// + i * 12;
					monster[i].missileHP = 5;
					monster[i].startShootFrameCnt = Global.FPS * 15;
					monster[i].shootInterval = Global.FPS * 15;
					monster[i].isDieFall = true;
					
					monster[i].movePattern = Monster.MOVE_FALL_AUTO;
					//monster[i].missilePower = -8;
					monster[i].missilePower = -8 - (k * 0.2);
					monster[i].moveValX = 3;
					monster[i].fallValue = 0.2;
					monster[i].power = monster[i].missilePower;
					
					monster[i].shooterIdx = 0;
				}
			}
			else
			{
				//複数体
				for (k = 0; k < tekiCnt; k++)
				{
					i = k + tekiCnt;
					/*
					idx  = 134;
					idx2 = 135;
					idx3 = 149;
					*/
					//monster[i].x = 480;
					//monster[i].y = 480 - 32;
					//monster[i].hp = 0;	//弾非表示はhp0
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx3];
					//monster[i].movePattern = Monster.MOVE_NORMAL;
					//monster[i].moveInterval = Global.halfFPS;
					monster[i].moveValX = 3;//3;
					monster[i].moveValY = (k % 8) * 0.05 + 0.3;
					monster[i].minX = -64;
					monster[i].maxX = 640;
					monster[i].minY = 0;
					monster[i].maxY = 480;
					monster[i].hitRange = 9;// 8;
					monster[i].isEnemy = false;
					
					monster[i].isMissile = true;
					monster[i].missilePlusX = makeGamen.report.onibiX * monsterImage[monsterImgNo[233]].scaleX;// + k * 3;
					monster[i].missilePlusY = makeGamen.report.onibiY * monsterImage[monsterImgNo[233]].scaleY - i;// + i * 12;
					monster[i].missileHP = 5;
					monster[i].startShootFrameCnt = Global.FPS * 15;
					monster[i].shootInterval = Global.FPS * 15;
					monster[i].isDieFall = true;

					monster[i].movePattern = Monster.MOVE_FALL_AUTO;
					//monster[i].missilePower = -8;
					monster[i].missilePower = -8 - (k * 0.2);
					monster[i].moveValX = 3;
					monster[i].fallValue = 0.2;
					monster[i].power = monster[i].missilePower;
					
					monster[i].shooterIdx = k;
				}
			}
		}

		//----------------
		// setAttackPattern1
		// 報告書用攻撃パターン：転石
		//----------------
		private function setAttackPattern1(tekiCnt:int):void 
		{
			//++++++++
			//setLogInfo("setAttackPattern1");
			//++++++++

			var i:int = 0;
			var k:int = 0;
			var idx:int, idx2:int, idx3:int;

			if (scenario.isReidan10bai())
			{
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
			}
			else
			{
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
			}

			//偵察or深度７から弾もユーザ登録式
			if ((Scenario.REPORT_LV7 <= scenario.no) || (isTeisatsu == true))
			{
				idx  = 237;
				idx2 = 238;
				idx3 = 149;
				monsterImage[monsterImgNo[idx]].pivotX = monsterImage[monsterImgNo[idx2]].pivotX = 8;
				monsterImage[monsterImgNo[idx]].pivotY = monsterImage[monsterImgNo[idx2]].pivotY = 8;

				//通常弾使用
				if (isOnibi1Normal)
				{
					idx = 236;
				}
				if (isOnibi2Normal)
				{
					idx2 = 236;
				}
			}

			//--------
			if (tekiCnt == 1)
			{
				//単体
				for (k = 0; k < 8; k++)
				{
					i = k + tekiCnt;
					/*
					idx  = 134;
					idx2 = 135;
					idx3 = 149;
					*/
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx3];
					//monster[i].movePattern = Monster.MOVE_NORMAL;
					//monster[i].moveValX = 2;//3;
					//monster[i].moveValY = (k % 8) * 0.1 + 0.3;//(k % 8) * 0.05 + 0.3;
					monster[i].minX = -64;
					monster[i].maxX = 640;
					monster[i].minY = 0;
					monster[i].maxY = 480 - 32 - 16;
					monster[i].hitRange = 8;
					monster[i].isEnemy = false;
					
					monster[i].isMissile = true;
					//monster[i].missilePlusX = monster[i].x;
					//monster[i].missilePlusY = monster[i].y;
					monster[i].missilePlusX = makeGamen.report.onibiX * monsterImage[monsterImgNo[233]].scaleX;
					monster[i].missilePlusY = makeGamen.report.onibiY * monsterImage[monsterImgNo[233]].scaleY;
					monster[i].missileHP = 5;
					//monster[i].startShootFrameCnt = Global.FPS * 15;
					monster[i].startShootFrameCnt = Global.FPS * 15 + k * 6;
					monster[i].shootInterval = Global.FPS * 15;
					monster[i].isDieFall = true;
					
					monster[i].movePattern = Monster.MOVE_FALL2B;//Monster.MOVE_FALL2;
					//nster[i].missilePower = -8;
					monster[i].missilePower = -8 - (k * 0.2);
					monster[i].moveValX = 3;
					monster[i].fallValue = 0.2;
					monster[i].power = monster[i].missilePower;
					
					monster[i].shooterIdx = 0;
				}
			}
			else
			{
				//複数体
				for (k = 0; k < tekiCnt; k++)
				{
					i = k + tekiCnt;
					/*
					idx  = 134;
					idx2 = 135;
					idx3 = 149;
					*/
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx3];
					monster[i].movePattern = Monster.MOVE_NORMAL;
					monster[i].moveValX = 2;//3;
					monster[i].moveValY = (k % 8) * 0.1 + 0.3;//(k % 8) * 0.05 + 0.3;
					monster[i].minX = -64;
					monster[i].maxX = 640;
					monster[i].minY = 0;
					monster[i].maxY = 480 - 32 - 16;
					monster[i].hitRange = 8;
					monster[i].isEnemy = false;
					
					monster[i].isMissile = true;
					//monster[i].missilePlusX = monster[i].x;
					//monster[i].missilePlusY = monster[i].y;
					monster[i].missilePlusX = makeGamen.report.onibiX * monsterImage[monsterImgNo[233]].scaleX;
					monster[i].missilePlusY = makeGamen.report.onibiY * monsterImage[monsterImgNo[233]].scaleY;
					monster[i].missileHP = 5;
					monster[i].startShootFrameCnt = Global.FPS * 15;
					monster[i].shootInterval = Global.FPS * 15;
					monster[i].isDieFall = true;
					
					monster[i].movePattern = Monster.MOVE_FALL2B;//Monster.MOVE_FALL2;
					monster[i].missilePower = -8;
					monster[i].moveValX = 3;
					monster[i].fallValue = 0.2;
					monster[i].power = monster[i].missilePower;
					
					monster[i].shooterIdx = k;
				}
			}
		}

		//----------------
		// setAttackPattern2
		// 報告書用攻撃パターン：直線
		//----------------
		private function setAttackPattern2(tekiCnt:int):void 
		{
			//++++++++
			//setLogInfo("setAttackPattern2");
			//++++++++

			var i:int;
			var k:int;
			var idx:int, idx2:int, idx3:int;

			if (scenario.isReidan10bai())
			{
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
			}
			else
			{
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
			}

			//偵察or深度７から弾もユーザ登録式
			if ((Scenario.REPORT_LV7 <= scenario.no) || (isTeisatsu == true))
			{
				idx  = 237;
				idx2 = 238;
				idx3 = 149;
				monsterImage[monsterImgNo[idx]].pivotX = monsterImage[monsterImgNo[idx2]].pivotX = 8;
				monsterImage[monsterImgNo[idx]].pivotY = monsterImage[monsterImgNo[idx2]].pivotY = 8;

				//通常弾使用
				if (isOnibi1Normal)
				{
					idx = 236;
				}
				if (isOnibi2Normal)
				{
					idx2 = 236;
				}
			}

			//--------
			if (tekiCnt == 1)
			{
				//単体
				for (k = 0; k < 8; k++)
				{
					i = k + tekiCnt;
					/*
					idx  = 134;
					idx2 = 135;
					idx3 = 149;
					*/
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx3];
					monster[i].movePattern = Monster.MOVE_TAN2;
					monster[i].moveVal = 3;
					monster[i].hitRange = 8;
					monster[i].isEnemy = false;
					
					monster[i].isMissile = true;
					monster[i].missilePlusX = makeGamen.report.onibiX * monsterImage[monsterImgNo[233]].scaleX;
					monster[i].missilePlusY = makeGamen.report.onibiY * monsterImage[monsterImgNo[233]].scaleY;
					monster[i].missileHP = 5;
					//monster[i].startShootFrameCnt = Global.FPS * 15;
					monster[i].startShootFrameCnt = Global.FPS * 15 + k * 6;
					monster[i].shootInterval = Global.FPS * 15;
					monster[i].isDieFall = true;
					
					monster[i].shooterIdx = 0;
				}
			}
			else
			{
				//複数体
				for (k = 0; k < tekiCnt; k++)
				{
					i = k + tekiCnt;
					/*
					idx  = 134;
					idx2 = 135;
					idx3 = 149;
					*/
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx3];
					monster[i].movePattern = Monster.MOVE_TAN2;
					monster[i].moveVal = 3;
					monster[i].hitRange = 8;
					monster[i].isEnemy = false;
					
					monster[i].isMissile = true;
					monster[i].missilePlusX = makeGamen.report.onibiX * monsterImage[monsterImgNo[233]].scaleX;
					monster[i].missilePlusY = makeGamen.report.onibiY * monsterImage[monsterImgNo[233]].scaleY;
					monster[i].missileHP = 5;
					monster[i].startShootFrameCnt = Global.FPS * 15;
					monster[i].shootInterval = Global.FPS * 15;
					monster[i].isDieFall = true;
					
					monster[i].shooterIdx = k;
				}
			}
		}
		
		//----------------
		// setAttackPattern3
		// 報告書用攻撃パターン：直線
		//----------------
		private function setAttackPattern3(tekiCnt:int):void 
		{
			//++++++++
			//setLogInfo("setAttackPattern3");
			//++++++++

			var i:int;
			var k:int;
			var idx:int, idx2:int, idx3:int;

			if (scenario.isReidan10bai())
			{
				idx  = 236;
				idx2 = 236;
				idx3 = 149;
			}
			else
			{
				idx  = 134;
				idx2 = 135;
				idx3 = 149;
			}

			//偵察or深度７から弾もユーザ登録式
			if ((Scenario.REPORT_LV7 <= scenario.no) || (isTeisatsu == true))
			{
				idx  = 237;
				idx2 = 238;
				idx3 = 149;
				monsterImage[monsterImgNo[idx]].pivotX = monsterImage[monsterImgNo[idx2]].pivotX = 8;
				monsterImage[monsterImgNo[idx]].pivotY = monsterImage[monsterImgNo[idx2]].pivotY = 8;

				//通常弾使用
				if (isOnibi1Normal)
				{
					idx = 236;
				}
				if (isOnibi2Normal)
				{
					idx2 = 236;
				}
			}

			//--------
			if (tekiCnt == 1)
			{
				//単体
				for (k = 0; k < 8; k++)
				{
					i = k + tekiCnt;
					/*
					idx  = 134;
					idx2 = 135;
					idx3 = 149;
					*/
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx3];
					monster[i].movePattern = Monster.MOVE_TAN2WAVE;
					monster[i].moveVal = 3;
					monster[i].hitRange = 8;
					monster[i].isEnemy = false;
					
					monster[i].isMissile = true;
					monster[i].missilePlusX = makeGamen.report.onibiX * monsterImage[monsterImgNo[233]].scaleX;
					monster[i].missilePlusY = makeGamen.report.onibiY * monsterImage[monsterImgNo[233]].scaleY;
					monster[i].missileHP = 5;
					//monster[i].startShootFrameCnt = Global.FPS * 15;
					monster[i].startShootFrameCnt = Global.FPS * 15 + k * 6;
					monster[i].shootInterval = Global.FPS * 15;
					monster[i].isDieFall = true;
					
					monster[i].shooterIdx = 0;
				}
			}
			else
			{
				//複数体
				for (k = 0; k < tekiCnt; k++)
				{
					i = k + tekiCnt;
					/*
					idx  = 134;
					idx2 = 135;
					idx3 = 149;
					*/
					monster[i].imgNoWalkLeft1 = monsterImgNo[idx];
					monster[i].imgNoWalkLeft2 = monsterImgNo[idx2];
					monster[i].imgNoDeadLeft = monsterImgNo[idx3];
					monster[i].movePattern = Monster.MOVE_TAN2WAVE;
					monster[i].moveVal = 3;
					monster[i].hitRange = 8;
					monster[i].isEnemy = false;
					
					monster[i].isMissile = true;
					monster[i].missilePlusX = makeGamen.report.onibiX * monsterImage[monsterImgNo[233]].scaleX;
					monster[i].missilePlusY = makeGamen.report.onibiY * monsterImage[monsterImgNo[233]].scaleY;
					monster[i].missileHP = 5;
					monster[i].startShootFrameCnt = Global.FPS * 15;
					monster[i].shootInterval = Global.FPS * 15;
					monster[i].isDieFall = true;
					
					monster[i].shooterIdx = k;
				}
			}
		}
		
		// ----------------
		// makeHitBmp
		// ----------------
		private function makeHitBmp(bmpIdx:int):void
		{
			//++++++++
			//setLogInfo("makeHitBmp");
			//++++++++

			var i:int;

			//Game.mStarling.showStats = false;

			//当たり判定用bmp作成
			skyQuad.visible = false;
			jimenQuad.visible = false;
			meterQuad.visible = false;
			meterQuad2.visible = false;
			wazaBreakQuad.visible = false;
			stageTitle.visible = false;
			
			for (i = 0; i < monster.length; i++)
			{
				monsterHP[i].visible = false;
				monsterHPBG[i].visible = false;
			}
			
			renderTexture.clear();
			renderTextureFixed.clear();
			renderTextureJimen.clear();
			renderTextureYagura.clear();
			arrowQuadBatch.reset();
			mainQuadBatch.reset();

			/* Starling v1.6導入でコメントアウト　20141204
			//--------
			//drawToBitmapDataで
			//「#3692: 描画の前にフレームごとにすべてのバッファーをクリアする必要があります。」
			//が出ることがある対策
			//20140924 まだ発生するようなので対策としてリトライする
			//20140927 リトライしてもダメなのでとりあえずエラー画面を出して終了してもらう
			var mStage3D:Stage3D = flashStage.stage3Ds[0];
			mStage3D.context3D.clear();
			//--------
			*/

			var idx:int = monsterImgNo[bmpIdx];
			monsterImage[idx].x = 0;
			monsterImage[idx].y = 0;
			renderTexture.draw(monsterImage[idx]);

			//当たり判定用の画像がタイミングによって見えてしまうので隠す
			kakushiBmp.visible = true;

			stage.drawToBitmapData(bmpForHit.bitmapData, false);

			//--------
			//軽量対策。直接から持ってくるのをやめて当たり判定用配列にしとく
			bmpHitData = bmpForHit.bitmapData.getVector(bmpForHit.bitmapData.rect);
			//--------
			
			//--------
			//drawToBitmapData失敗で例外とならない？対策。
			for (i = 0; i < bmpHitData.length; i++ )
			{
				if (bmpHitData[i] == 0xff000000)
				{
					contains;
				}
				break;
			}
			if (i == bmpHitData.length)
			{
				//全て黒→当たり判定なし　になってる
				new TextLogConnect().connect("■全て黒→当たり判定なし");
				sorryPleaseReLogin("n0");
				return;
			}
			//--------
			
			skyQuad.visible = true;
			jimenQuad.visible = true;
			meterQuad.visible = true;
			meterQuad2.visible = true;
			wazaBreakQuad.visible = true;
			stageTitle.visible = true;

			renderTexture.clear();
			renderTextureFixed.clear();
			renderTextureJimen.clear();
			renderTextureYagura.clear();
			arrowQuadBatch.reset();
			mainQuadBatch.reset();

			//Game.mStarling.showStats = true;
		}

		// ----------------
		// pleaseReLogin
		// ----------------
		private function sorryPleaseReLogin(errorID:String):void
		{
			var tf:flash.text.TextField = new flash.text.TextField();
			tf.textColor = 0xffffff;
			tf.background = true;
			tf.backgroundColor = 0x512D6B;//
			tf.text = "エラーが発生しました。お手数ですが画面を更新して再ログインしてください。[" + errorID + "]";
			tf.width = 640;
			tf.height = 480;
			flashStage.addChild(tf);
		}
		
		// ----------------
		// drawBackground
		// ----------------
		private function drawBackground(_jimenData:Vector.<int> = null, _haikeiData:Vector.<int> = null, _haikeiData2:Vector.<int> = null, _haikeiData3:Vector.<int> = null):void
		{
			//++++++++
			//setLogInfo("drawBackground");
			//++++++++

			var i:int;
			var idx:int;

			if (_haikeiData3 != null)
			{
				for (i = 0; i < _haikeiData3.length; i++)
				{
					idx = _haikeiData3[i];
					if (idx < 0)
					{
						continue;
					}
					image[idx].x = i * 16;
					image[idx].y = 480/2 - 16 - image[idx].height;
					renderTextureFixed.draw(image[idx]);
				}
			}
			if (_haikeiData2 != null)
			{
				for (i = 0; i < _haikeiData2.length; i++)
				{
					idx = _haikeiData2[i];
					if (idx < 0)
					{
						continue;
					}
					image[idx].x = i * 16;
					image[idx].y = 480/2 - 16 - image[idx].height;
					renderTextureFixed.draw(image[idx]);
				}
			}
			if (_haikeiData != null)
			{
				for (i = 0; i < _haikeiData.length; i++)
				{
					idx = _haikeiData[i];
					if (idx < 0)
					{
						continue;
					}
					image[idx].x = i * 16;
					image[idx].y = 480/2 - 16 - image[idx].height;
					renderTextureFixed.draw(image[idx]);
				}
			}
			if (_jimenData != null)
			{
				for (i = 0; i < _jimenData.length; i++)
				{
					idx = _jimenData[i];
					if (idx < 0)
					{
						continue;
					}
					image[idx].x = i * 16;
					renderTextureJimen.draw(image[idx]);
				}
			}
		}

		// ----------------
		// drawSky 鍛錬
		// ----------------
		private function drawSky():void
		{
			skyQuad.color = 0xff88bbff;
			skyQuad.setVertexColor(0, 0x007fff);
			skyQuad.setVertexColor(1, 0x007fff);
		}
		// ----------------
		// drawDarkSky 潜行演習
		// ----------------
		private function drawDarkSky():void
		{
			skyQuad.color = 0xffbbbbbb;
			skyQuad.setVertexColor(0, 0xff888888);
			skyQuad.setVertexColor(1, 0xff888888);
		}
		// ----------------
		// drawPurpleSky 実戦
		// ----------------
		private function drawPurpleSky():void
		{
			skyQuad.color = 0xffbb88ff;
			skyQuad.setVertexColor(0, 0x7f00ff);
			skyQuad.setVertexColor(1, 0x7f00ff);
		}

		private function setEndTextTanren():void
		{
			clearMC.clear_txt.text = " お見事！";
			clearMC.failed_txt.text = "失敗";
		}
		private function setEndTextEnshu():void
		{
			clearMC.clear_txt.text = " 演習成功！";
			clearMC.failed_txt.text = "演習失敗";
		}
		private function setEndTextJissen():void
		{
			clearMC.clear_txt.text = " 退治成功！";
			clearMC.failed_txt.text = "退治失敗";
			
			if (isTeisatsu)
			{
				clearMC.failed_txt.text = "偵察完了";
			}
		}

		// ----------------
		// getMagatamaNeedDamage
		// ----------------
		private function getMagatamaNeedDamage():int
		{
			//++++++++
			//setLogInfo("getMagatamaNeedDamage");
			//++++++++

			//一人担当分のダメージの80%クリアしていればＯＫとする。ミサイルは含まれていない
			//サボり防止だが、高レベル帯の独占となるので、ノルマダメージ80%->50%とする
			//return (stageTotalHp / personcnt * 0.8);
			return (stageTotalHp / personcnt * 0.5);
		}
		
		// ----------------
		// enterFrameEvent
		// ----------------
		//private var frameCnt:int = 0;
		private var frameCntValue:Value = new Value();
		private function get frameCnt():int { return frameCntValue.value; }
		private function set frameCnt(val:int):void { frameCntValue.value = val; }
		
		private var frameRate:int = Starling.current.nativeStage.frameRate;
		private var isPlayGa:Boolean = false;
		private var isPlayTodome:Boolean = false;
		private var isPlayNoDamage:Boolean = false;
		private var startArrowIdx:int = 0;
		private var isClear:Boolean = false;
		private var isGameOver:Boolean = false;
		//private var bmpForHit:Bitmap = new Bitmap(new BitmapData(640, 480));
		private var bmpForHit:Bitmap = new Bitmap(new BitmapData(640, 480, false, 0x00000000));
		private var bmpHitData:Vector.<uint> = new Vector.<uint>;

		private var shootCnt:int = 0;
		
		//private var remainTime:int = 0;
		private var _remainTime:Value = new Value();
		private function get remainTime():int { return _remainTime.value; };
		private function set remainTime(val:int):void { _remainTime.value = val; };
		
		private var gameoverFrameCnt:int = 0;
		//private var memberCnt:int = 0;
		private var memberSelfIdx:int = 0;
		private var allPower:Number = 0.0;
		private var baratsuki:Number = 0.0;
		private const NEED_MIN_POWER:Number = 0.4;
		private var lastYaguraHP:int = 0;
		private var lastYaguraHPForDraw:int = 0;
		private var wazaKind:int = -1;
		private var wazaKyokaKind:int = -1;
		private var maxShootArrowCnt:int = 0;
		private var beforeLevel:int = 0;
		private var isFullTame2:Boolean = false;
		//private var lastTime:int = 0;
		//private var lastFrameCnt:int = 0;
		//private var skipDrawCnt:int = 0;
		
		//private var lastFrameTime:Number = 0;
		//private var nowFrameTime:Number = 0;
		//private var drawArrowCnt:int = Arrow.MAX_CNT;
		
		//モンスターは実時間に合わせて動かす（協力同期のため）
		private var stageStartTime:Number = 0.0;
		private var monsterFrameCnt:int = 0;
		private var lastMonsterFrameCnt:int = 0;
		private var stageTimeSec:int = 0;

		private var arrowRouteCnt:int = 0;

		private var monsterHitRect:Rectangle = new Rectangle();
		private var intersectionRect:Rectangle;
		
		private var arrowsLength:int;
		private var monsterLength:int;
		private var isWazaTameHatsudo:Boolean = false;
		
		public function enterFrameMain(e:EnterFrameEvent):void
		{
			//++++++++
			////setLogInfo("enterFrameMain");
			//++++++++

			/*
			var i:int;
			var k:int;
			var m:int;
			var a:int;
			var ii:int;
			var cnt:int = 0;
			//var arrowsLength:int = arrows.length;
			*/
			var i:int, k:int, m:int, a:int, ii:int,	cnt:int = 0;

			//--------
			if (0 < usvr.memberNo.length)
			{
				if (personcnt < usvr.memberNo.length)
				{
					personcnt = usvr.memberNo.length;
				}
			}
			//--------

			//--------
			//if (Global.FPS * 7 <= frameCnt)
			if (0 < stageTitleShowCnt)
			{
				stageTitleShowCnt--;
			}
			else
			{
				stageTitle.visible = false;
			}
			//--------
			
			//--------
			//チートチェック
			if ((Hamayumi.isCheat == true) || (shootArrowCnt.isCheat == true))
			{
				shootArrowCnt.value = Math.random() * 20 + 1;
			}
			//加速チートチェック(TEST_20140820)
			if (isSpeedCheat)
			{
				//================
				//if (Global.username == "スナイパー")
				if (2 <= personcnt)
				{
					shootArrowCnt.value = Math.random() * 20 + 1;
					addPowerValue = 0.0001;
				}
				//================
			}
			else
			{
				//if (frameCnt % (Global.FPS * 5) == 0)
				if (frameCnt - (Global.FPSx5) * ((frameCnt / (Global.FPSx5)) >> 0) == 0)
				{
					checkSpeedCheat(frameCnt, ((new Date()).time - stageStartTime), 5);
				}
			}
			//--------

			//
			if (isMouseDown)
			{
				//--------弓を引く
				if (power == 0)
				{
					Global.playGigigi();
				}

				allPower += addPowerValue;
				
				/*
				//--------技タメ
				if (Hamayumi.isWazaTame)
				{
					wazaTameGauge.value++;
				}
				//--------
				//--------自動射出(1/2)
				if (Hamayumi.isAuto)
				{
					if (maxPower < allPower)
					{
						allPower = maxPower;
						isMouseDown = false;
					}
				}
				//--------
				//--------自動射出+1(1/2)
				if (Hamayumi.isAuto1)
				{
					if ((scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI) && (0 <= wazaKind))
					{
						//技あり
						if (wazaMaxPower < allPower)
						{
							allPower = wazaMaxPower;
							isMouseDown = false;
						}
					}
					else
					{
						if (maxPower < allPower)
						{
							allPower = maxPower;
							isMouseDown = false;
						}
					}
				}
				//--------
				*/
				
				if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
				{
					//--------技タメ
					if (Hamayumi.isWazaTame)
					{
						wazaTameGauge.value++;
					}
					//--------
					//--------自動射出(1/2)
					if (Hamayumi.isAuto)
					{
						if (maxPower < allPower)
						{
							allPower = maxPower;
							isMouseDown = false;
						}
					}
					//--------
					//--------自動射出+1(1/2)
					if (Hamayumi.isAuto1)
					{
						if (0 <= wazaKind)
						{
							//技あり
							if (wazaMaxPower < allPower)
							{
								allPower = wazaMaxPower;
								isMouseDown = false;
							}
						}
						else
						{
							if (maxPower < allPower)
							{
								allPower = maxPower;
								isMouseDown = false;
							}
						}
					}
					//--------
				}
				
				if ((scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI) && (0 <= wazaKind))
				{
					//破魔弓（技あり）
					//if (2 * maxPower < allPower)
					if (wazaMaxPower < allPower)
					{
						//allPower = 2 * maxPower;
						allPower = wazaMaxPower;
						if (isFullTame2 == false)
						{
							Global.playTame2();
						}
						isFullTame2 = true;
					}
					if (maxPower < allPower)
					{
						//タメ２
						power = maxPower;
					}
					else
					{
						//タメ１
						power = allPower;
					}
				}
				else
				{
					//弓（技なし）
					if (maxPower < allPower)
					{
						allPower = maxPower;
						trace("タメ" + frameCnt)
					}
					power = allPower;
				}
			}
			else
			{
				/*
				//--------自動射出(2/2)
				if (Hamayumi.isAuto)
				{
					isMouseDown = true;
				}
				//--------
				//--------自動射出+1(2/2)
				if (Hamayumi.isAuto1)
				{
					isMouseDown = true;
				}
				//--------
				*/
				
				if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
				{
					//--------自動射出(2/2)
					if (Hamayumi.isAuto)
					{
						isMouseDown = true;
					}
					//--------
					//--------自動射出+1(2/2)
					if (Hamayumi.isAuto1)
					{
						isMouseDown = true;
					}
					//--------
				}

				//--------射出
				if (maxPower * NEED_MIN_POWER <= allPower)
				{
					var baseR:Number = -1 * Math.atan2(flashStage.mouseY - myArcher.shootY, flashStage.mouseX - myArcher.shootX);
					var v0:Number = 0.0;
					var r:Number = 0.0;

					baratsuki = 1.0;	//ばらつき最大:1.0 ばらつきなしは0.0
					maxShootArrowCnt = shootArrowCnt.value;

					//技（一点射撃）
					//if (allPower == 2 * maxPower)
					if (allPower == wazaMaxPower)
					{
						if (wazaKind == Item.KIND_IDX_WAZA_ITTEN)
						{
							//タメ２
							baratsuki = 0.2;//1.0 - (allPower - maxPower) / maxPower * 0.75;
						}
						else if (wazaKind == Item.KIND_IDX_WAZA_HANABI)
						{
							baratsuki = 0;
						}
						
						isFullTame2 = false;
						
						//--------
						//TEST
						isWazaTameHatsudo = false;
						if (Hamayumi.isWazaTame)
						{
							if (maxWazaTameCnt <= wazaTameGauge.value)
							{
								wazaTameGauge.value = 0;
								isWazaTameHatsudo = true;
							}
						}
						//--------
					}
					
					//勾玉効果(密集、散乱)
					if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
					{
						baratsuki -= shuchu;
						baratsuki += sanran;
						if (baratsuki < 0)
						{
							baratsuki = 0.0;
						}
					}

					//--------
					//for (ii = startArrowIdx; ii < arrows.length * 2; ii++)
					for (ii = startArrowIdx; ii < arrowsLength * 2; ii++)
					{
						//%計算は重い
						//i = ii % arrows.length;
						i = ii - arrowsLength * ((ii / arrowsLength) >> 0);

						if ((arrows[i].status == Arrow.STATUS_STOP) || (arrows[i].isSelf == false))
						{
							//--------射出--------
							v0 = Arrow.getV0Power(power, cnt, frameCnt, baratsuki);
							r = Arrow.getV0Radian(baseR, cnt, frameCnt, baratsuki);
							
							arrows[i].v0 = v0;
							arrows[i].baseR = baseR;
							arrows[i].baratsuki = baratsuki;

							arrows[i].wazaKind = 0;
							
							arrows[i].damage = Hamayumi.damage;

							arrows[i].x = myArcher.shootX;
							arrows[i].y = myArcher.shootY;
							arrows[i].moveCount = 0;
							for (a = 0; a < Arrow.routeCnt; a++ )
							{
								arrows[i].routeX[a] = -32;
								arrows[i].routeY[a] = -32;
							}
							arrows[i].hitIdx = -1;
							arrows[i].penetrateCnt = 0;
							arrows[i].penetrateHitIdx = -1;
							arrows[i].isWazaTame = false;

							//--------
							//技（バババッ）
							//if (allPower == 2 * maxPower)
							if (allPower == wazaMaxPower)
							{
								arrows[i].wazaKind = wazaKind;
								arrows[i].wazaKyokaKind = wazaKyokaKind;

								if (wazaKind == Item.KIND_IDX_WAZA_BABABA)
								{
									maxShootArrowCnt = 2 * shootArrowCnt.value;
									r = baseR - Math.PI / 2 + Math.PI * 2 / 6 + (Math.PI * 1 / 3) / maxShootArrowCnt * cnt;
									arrows[i].damage = Hamayumi.bababaDamage;
								}
								else if (wazaKind == Item.KIND_IDX_WAZA_HANABI)
								{
									if (wazaKyokaKind == Item.KIND_IDX_KYOKA_HANABI)
									{
										//花火強化
										maxShootArrowCnt = 1;
										arrows[i].hanabiNo = 0;
									}
									else if (wazaKyokaKind == Item.KIND_IDX_KYOKA_HANABI2)
									{
										//花火強化→火矢
										maxShootArrowCnt = 1;
										arrows[i].hanabiNo = 0;
									}
									else
									{
										//通常花火
										maxShootArrowCnt = 2 * shootArrowCnt.value;
										arrows[i].hanabiNo = cnt;
										arrows[i].hanabiMaxNo = maxShootArrowCnt;
									}
									arrows[i].damage = Hamayumi.hanabiDamage;
								}
								else if (wazaKind == Item.KIND_IDX_WAZA_ITTEN)
								{
									arrows[i].damage = Hamayumi.ittenDamage;
								}
								else if (wazaKind == Item.KIND_IDX_WAZA_REN)
								{
									arrows[i].damage = Hamayumi.renDamage;
								}
								else if (wazaKind == Item.KIND_IDX_WAZA_SOU)
								{
									//送
									arrows[i].x = 640 - 32;
									arrows[i].y = 32;
									v0 = -1 * v0;
									
									arrows[i].damage = Hamayumi.souDamage;
								}
								
								//--------
								//技タメ
								if (isWazaTameHatsudo)
								{
									arrows[i].isWazaTame = true;
									arrows[i].damage *= 8;// 15;//8
								}
								//--------
							}
							//--------
							if ((scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI) && (cnt < penetrateMaxCnt))
							{
								//arrows[i].penetrateCnt = 1;
								if (Hamayumi.is2danHit)
								{
									arrows[i].penetrateCnt = 2;
								}
								else if (Hamayumi.is3danHit)
								{
									arrows[i].penetrateCnt = 3;
								}
								else
								{
									arrows[i].penetrateCnt = 1;
								}
							}
							if ((cnt == 0) && (scenario.no == Scenario.TAMETOMO))
							{
								arrows[i].penetrateCnt = 1;
							}
							arrows[i].isSelf = true;
							
							arrows[i].vx = v0 * Math.cos(r);
							arrows[i].vy = -1 * v0 * Math.sin(r);
							arrows[i].r = Math.atan2(arrows[i].vy, arrows[i].vx) + Math.PI / 2;
							//後ろから出てるので１フレーム進める
							arrows[i].x += arrows[i].vx;
							arrows[i].y += arrows[i].vy;
							arrows[i].status = Arrow.STATUS_MOVE;
							arrows[i].shootWait = cnt % 4;

							//--------
							//技：連
							//if (allPower == 2 * maxPower)
							if (allPower == wazaMaxPower)
							{
								if (wazaKind == Item.KIND_IDX_WAZA_REN)
								{
									maxShootArrowCnt = 2 * shootArrowCnt.value;
									arrows[i].shootWait = cnt * 0.5;
								}
							}
							//--------

							cnt++;
						}

						//if (shootArrowCnt <= cnt)
						if (maxShootArrowCnt <= cnt)
						{
							startArrowIdx = i + 1;
							trace("startArrowIdx:" + startArrowIdx);
							break;
						}
					}

					//撃った矢数
					//shotCount += shootArrowCnt;
					//shotCount += shootArrowCnt.value;
					shotCount += maxShootArrowCnt;
					
					//--------
					if (0 < usvr.memberNo.length)
					{
						//usvr.sendShootMessage(arrows[i].x, arrows[i].y, baseR, power, cnt, frameCnt, baratsuki);
						var sendData:String = "";
						sendData += myArcher.shootX + ",";
						sendData += myArcher.shootY + ",";
						sendData += baseR + ",";
						sendData += power + ",";
						sendData += cnt + ",";
						sendData += frameCnt + ",";
						sendData += baratsuki + ",";
						sendData += allPower + ",";
						sendData += penetrateMaxCnt + ",";
						sendData += wazaKind + ",";
						sendData += maxPower + ",";
						sendData += wazaKyokaKind;
						usvr.sendMessage("SHOOT", sendData);
					}
					//--------
					
					shootCnt += cnt;
					Global.playShu();
				}

				if (0.0 < power)
				{
					power = 0.0;
				}
				if (0.0 < allPower)
				{
					allPower = 0.0;
				}
			}

			//メーター(power)
			if (maxPower * NEED_MIN_POWER <= allPower)
			{
				meterQuad.color = 0xf8d32f;
			}
			else
			{
				meterQuad.color = 0xe06a3b;
			}

			//if (allPower == 2 * maxPower)
			if (allPower == wazaMaxPower)
			{
				//meterQuad2.color = 0x4b75b9;
				meterQuad2.color = 0x0041ff;
			}
			else
			{
				meterQuad2.color = 0x3eba2b;
				//meterQuad2.color = 0x35a16b;
			}

			meterQuad.width = 640 / maxPower * power;
			//メーター(ばらつき)
			//meterQuad2.width = 640 / maxPower * (allPower - maxPower);
			if (maxPower < allPower)
			{
				meterQuad2.width = 640 / (wazaMaxPower - maxPower) * (allPower - maxPower);
			}
			else
			{
				meterQuad2.width = 0;
			}
			
			//--------
			//TEST
			if (Hamayumi.isWazaTame)
			{
				if (maxWazaTameCnt <= wazaTameGauge.value)
				{
					wazaBreakQuad.color = 0xffffff;
				}
				else if (0 < wazaTameGauge.value)
				{
					wazaBreakQuad.color = 0xc7b2de;// 0x9a0079;
				}

				if (0 <= wazaKind)
				{
					//wazaTameGauge.value++;
					wazaBreakQuad.width = wazaTameGauge.value / maxWazaTameCnt * 640;
				}
				else
				{
					wazaBreakQuad.width = 0;
				}
			}
			//--------

			if (power < 0)
			{
				meterQuad.color = 0xC7243A;
				meterQuad.width = 640 / maxPower * (-1 * power);
			}

			// -------- 矢の移動 --------
			cnt = 0;
			//for (i = 0; i < arrows.length; i++)
			for (i = 0; i < arrowsLength; i++)
			{
				if ((arrows[i].status == Arrow.STATUS_MOVE) || (arrows[i].status == Arrow.STATUS_REFLECT))
				{
					//発射待ち制御
					if (0 < arrows[i].shootWait)
					{
						arrows[i].shootWait--;

						//--------
						if ((arrows[i].shootWait == 0) && (arrows[i].wazaKind == Item.KIND_IDX_WAZA_REN))
						{
							if (arrows[i].isSelf)
							{
								arrows[i].baseR = -1 * Math.atan2(flashStage.mouseY - myArcher.shootY, flashStage.mouseX - myArcher.shootX);
								r = Arrow.getV0Radian(arrows[i].baseR, cnt, frameCnt, arrows[i].baratsuki);
								arrows[i].vx = arrows[i].v0 * Math.cos(r);
								arrows[i].vy = -1 * arrows[i].v0 * Math.sin(r);
							}
							else
							{
								for (a = 0; a < usvr.memberNo.length; a++)
								{
									if (arrows[i].clientID == usvr.memberNo[a])
									{
										trace("########" + archer[a].baseR);
										arrows[i].baseR = archer[a].baseR;
										r = Arrow.getV0Radian(arrows[i].baseR, cnt, frameCnt, arrows[i].baratsuki);
										arrows[i].vx = arrows[i].v0 * Math.cos(r);
										arrows[i].vy = -1 * arrows[i].v0 * Math.sin(r);
										break;
									}
								}
							}
						}
						//--------

						continue;
					}

					//飛び越し対策座標				
					//--------
					//画面外の上空OR自分の矢ではない、では簡易当たり判定 20141004
					if ((arrows[i].y < 0) || (arrows[i].isSelf == false))
					{
						arrowRouteCnt = 1;
					}
					else
					{
						arrowRouteCnt = Arrow.routeCnt;
					}
					//--------
					
					//for (a = 0; a < Arrow.routeCnt; a++ )
					for (a = 0; a < arrowRouteCnt; a++ )
					{
						arrows[i].routeX[a] = arrows[i].x + arrows[i].vx * (a / Arrow.routeCnt);
						arrows[i].routeY[a] = arrows[i].y + arrows[i].vy * (a / Arrow.routeCnt);
					}

					//--------
					if (arrows[i].wazaKind == Item.KIND_IDX_WAZA_MAI)
					{
						//if ((Global.FPS * 0.5 < arrows[i].moveCount) && (arrows[i].moveCount < Global.FPS * 5))
						if ((Global.halfFPS < arrows[i].moveCount) && (arrows[i].moveCount < Global.FPSx5))
						{
							r = Arrow.getV0Radian(arrows[i].baseR + arrows[i].moveCount * 0.25, 0, frameCnt, baratsuki);
							arrows[i].vx =  8 * Math.cos(r);
							arrows[i].vy = -8 * Math.sin(r);
						}
					}
					//--------

					arrows[i].x += arrows[i].vx;
					arrows[i].y += arrows[i].vy;

					//arrows[i].r = Math.atan2(arrows[i].vy, arrows[i].vx) + Math.PI / 2;
					arrows[i].r = Math.atan2(arrows[i].vy, arrows[i].vx) + Global.halfPI;

					if (arrows[i].wazaKind == Item.KIND_IDX_WAZA_BABABA)
					{
						arrows[i].vy += fallSpeed * 0.5;
					}
					else
					{
						arrows[i].vy += fallSpeed;
					}
					
					//--------
					arrows[i].moveCount++;

					//技（花火）
					if (arrows[i].wazaKind == Item.KIND_IDX_WAZA_HANABI)
					{
						if (arrows[i].moveCount == Arrow.hanabiExplosionFPSCnt)
						{
							if (arrows[i].wazaKyokaKind == Item.KIND_IDX_KYOKA_HANABI)
							{
								//強化花火
								arrows[i].hanabiNo = -1;
								arrows[i].wazaKind = -1;
								arrows[i].moveCount = Global.FPS * 10;	//消す

								kyokaHanabi.push(new KyokaHanabi(arrows[i].x, arrows[i].y, Global.FPS * 0, arrows[i].isSelf));
								kyokaHanabi.push(new KyokaHanabi(arrows[i].x, arrows[i].y, Global.FPS * 1, arrows[i].isSelf));
								kyokaHanabi.push(new KyokaHanabi(arrows[i].x, arrows[i].y, Global.FPS * 2, arrows[i].isSelf));
							}
							else if (arrows[i].wazaKyokaKind == Item.KIND_IDX_KYOKA_HANABI2)
							{
								//強化花火→火矢
								//nop
							}
							else
							{
								//通常花火
								r = (2 * Math.PI) / arrows[i].hanabiMaxNo * cnt;
								arrows[i].vx = maxPower * Math.cos(r) *  0.1;
								arrows[i].vy = maxPower * Math.sin(r) * -0.1;
								arrows[i].r = Math.atan2(arrows[i].vy, arrows[i].vx) + Math.PI / 2;
								arrows[i].hanabiNo = -1;
								arrows[i].wazaKind = -1;
							}
						}
					}
					//--------

					//if (480 - 32 < arrows[i].y)
					if (448 < arrows[i].y)
					{
						if (arrows[i].wazaKind == Item.KIND_IDX_WAZA_HANABI)
						{
							if (arrows[i].wazaKyokaKind == Item.KIND_IDX_KYOKA_HANABI2)
							{
								//強化花火→火矢
								//地面着弾で炎発生
								Global.playFire();
								for (k = 0; k < 3; k++ )
								{
									hiya.push(new Hiya(arrows[i].x - (32*1) + k * 32, arrows[i].y - 32, shootArrowCnt.value * 0.4, arrows[i].isSelf));
									if (9 < hiya.length)
									{
										//最大数を超えてたら古いのを消す
										hiya[hiya.length - 9].showCount = Global.FPS * 99;
									}
								}
							}
						}

						arrows[i].status = Arrow.STATUS_STOP;
					}

					//if (scenario.isReportStage())
					if (isReportStage)
					{
						//報告書：複数体。画面外に当たり判定があった場合の修正x640->960
						//if (960 + 32 < arrows[i].x)
						if (992 < arrows[i].x)
						{
							arrows[i].status = Arrow.STATUS_STOP;
							arrows[i].x = -32;
							arrows[i].y = 640;
						}
					}
					else
					{
						//if (640 + 32 < arrows[i].x)
						if (672 < arrows[i].x)
						{
							arrows[i].status = Arrow.STATUS_STOP;
							arrows[i].x = -32;
							arrows[i].y = 640;
						}
					}
						
					//7秒以上飛んでる矢は終了
					//if (Global.FPS * 7 < arrows[i].moveCount)
					if (Global.FPSx7 < arrows[i].moveCount)
					{
						arrows[i].status = Arrow.STATUS_STOP;
						arrows[i].x = -32;
						arrows[i].y = 640;
					}

					//--------
					if (arrows[i].wazaKind == Item.KIND_IDX_WAZA_BABABA)
					{
						if (arrows[i].wazaKyokaKind == Item.KIND_IDX_KYOKA_BABABA)
						{
							//if (Global.FPS * 0.5 < arrows[i].moveCount)
							if (Global.halfFPS < arrows[i].moveCount)
							{
								//氷矢
								Global.playKoori();
								if (cnt % 10 == 0)
								{
									kooriya.push(new Kooriya(arrows[i].x, arrows[i].y, shootArrowCnt.value * 0.2, arrows[i].isSelf));
									if (12 < kooriya.length)
									{
										//最大数を超えてたら古いのを消す
										kooriya[kooriya.length - 12].showCount = Global.FPS * 99;
									}
								}
								
								arrows[i].status = Arrow.STATUS_STOP;
								arrows[i].x = -32;
								arrows[i].y = 640;
							}
						}
					}
					//--------

					cnt++;
				}
			}

			//--------
			//強化花火
			for (k = 0; k < kyokaHanabi.length; k++ )
			{
				kyokaHanabi[k].count--;
				if (kyokaHanabi[k].count <= 0)
				{
					kyoukaHanabiShoot(kyokaHanabi[k].x, kyokaHanabi[k].y, kyokaHanabi[k].isSelf);
					kyokaHanabi.splice(k, 1);
					k--;
				}
			}
			//--------

			//弓の角度
			myArcher.yumiR = Math.atan2(flashStage.mouseY - myArcher.shootY, flashStage.mouseX - myArcher.shootX);

			//--------敵弾発射開始
			if (isClear == false)
			{
				var isPlayedTekiShoot:Boolean = false;

				for (i = 0; i < monsterLength; i++)
				{
					if (monster[i].isMissile == false)
					{
						continue;
					}

					//if (monster[i].startShootFrameCnt == frameCnt)
					//if (monster[i].startShootFrameCnt <= frameCnt)
					if (monster[i].startShootFrameCnt <= monsterFrameCnt)
					{
						//発射元が死んでいたら発射しない
						if (0 <= monster[i].shooterIdx)
						{
							if (monster[monster[i].shooterIdx].hp <= 0)
							{
								continue;
							}
						}

						//発射
						monster[i].resetMissile(monster);
						monster[i].isNowMove = true;

						if ((monster[i].isShootSound) && (isPlayedTekiShoot == false))
						{
							////再生は1フレームに1回
							//isPlayedTekiShoot = true;
							//Global.playTekiShoot();
							if (monster[i].isNoDamage == false)
							{
								//再生は1フレームに1回
								isPlayedTekiShoot = true;
								Global.playTekiShoot();
							}
						}
						
						//再発射設定
						if (0 < monster[i].shootInterval)
						{
							//monster[i].startShootFrameCnt = frameCnt + monster[i].shootInterval;
							monster[i].startShootFrameCnt = monsterFrameCnt + monster[i].shootInterval;
						}

						//刺さっている矢クリア
						for (k = 0; k < arrowsLength; k++)
						{
							if (i == arrows[k].hitIdx)
							{
								arrows[k].hitIdx = -1;
								arrows[k].x = -32;
								arrows[k].y = 640;
							}
						}
					}

//これは土蜘蛛しか使わないから別にしてもよくね？
					//敵弾同士がぶつかると停止
					if ((monster[i].isHitEachOther == true) && (monster[i].isNowMove == true))
					{
						for (k = 0; k < monsterLength; k++)
						{
							if (monster[k].isHitEachOther == false)
							{
								continue;
							}
							if (monster[k].hp <= 0)
							{
								continue;
							}
							if (i == k)
							{
								continue;
							}
				
							d = (monster[i].x - monster[k].x) * (monster[i].x - monster[k].x) + (monster[i].y - monster[k].y) * (monster[i].y - monster[k].y);
							//if (d <= 32*32)
							////if (d <= monster[i].eachOtherDistance * monster[i].eachOtherDistance)
							if (d <= 1024)
							{
								monster[i].isNowMove = false;
								break;
							}
						}
					}
					
					monster[i].moveCnt++;
				}
			}

			//--------モンスター移動
var c:int;
for (c = 0; c < (monsterFrameCnt - lastMonsterFrameCnt); c++ )
{
			for (i = 0; i < monsterLength; i++)
			{
				if (monster[i].hp <= 0)
				{

					//--------Vanish
					if (0 < monster[i].vanishCnt)
					{
						monster[i].vanishCnt--;

						//--------矢も消す
						if (monster[i].vanishCnt == 0)
						{
							for (k = 0; k < arrowsLength; k++)
							{
								if (i == arrows[k].hitIdx)
								{
									arrows[k].hitIdx = -1;
									arrows[k].y = 640;//480;
								}
							}
						}
						//--------
					}
					else
					{
						continue;
					}

					if (monster[i].dir == Monster.DIR_LEFT)
					{
						monster[i].imgNo = monster[i].imgNoDeadLeft;
					}
					else if (monster[i].dir == Monster.DIR_RIGHT)
					{
						monster[i].imgNo = monster[i].imgNoDeadRight;
					}

					//落下
					if (monster[i].y <= 480 - 32 - monsterImage[monster[i].imgNoDeadRight].pivotY)
					{
						if (monster[i].isDieFall)
						{
							monster[i].y += 2;
							//monster[i].x += monster[i].dieKanseiX;
						}
					}

					continue;
				}

				//移動
				if (monster[i].movePattern == Monster.MOVE_NONE)
				{
					//nop;
					//continue;
				}
				else if (monster[i].movePattern == Monster.MOVE_NORMAL)
				{
					if (monster[i].isNowMove)
					{
						if (monster[i].dir == Monster.DIR_LEFT)
						{
							if (monster[i].minX < monster[i].x)
							{
								monster[i].x -= monster[i].moveValX;
							}
						}
						else if (monster[i].dir == Monster.DIR_RIGHT)
						{
							if (monster[i].x < monster[i].maxX)
							{
								monster[i].x += monster[i].moveValX;
							}
						}

						if (monster[i].vdir == Monster.VDIR_TOP)
						{
							if (monster[i].minY < monster[i].y)
							{
								monster[i].y -= monster[i].moveValY;
							}
						}
						else if (monster[i].vdir == Monster.VDIR_DOWN)
						{
							if (monster[i].y < monster[i].maxY)
							{
								monster[i].y += monster[i].moveValY;
							}
						}
					}
					
					//左右向き反転
					mt.init_genrand(frameCnt * (i + 1) + i);
					//m = Math.random() * monster[i].turnRate;
					m = mt.getRandInt(monster[i].turnRate);
					if (m == 0)
					{
						//移動開始or移動停止
						if (monster[i].isNowMove)
						{
							monster[i].isNowMove = false;
						}
						else
						{
							monster[i].isNowMove = true;
						}
					}
					else if (m == 1)
					{
						//向き変更
						//if ((int)(Math.random() * 2) == 0)
						if (mt.getRandInt(2) == 0)
						{
							monster[i].dir = Monster.DIR_LEFT;
						}
						else
						{
							monster[i].dir = Monster.DIR_RIGHT;
						}
					}
					else if (m == 2)
					{
						//向き変更
						//if ((int)(Math.random() * 2) == 0)
						if (mt.getRandInt(2) == 0)
						{
							monster[i].vdir = Monster.VDIR_TOP;
						}
						else
						{
							monster[i].vdir = Monster.VDIR_DOWN;
						}
					}
				}
				/*
				else if (monster[i].movePattern == Monster.MOVE_UPDOWN)
				{
					if (frameCnt % monster[i].moveInterval == 0)
					{
						if (monster[i].y < monster[i].maxY)
						{
							monster[i].y += monster[i].moveValY;
						}
						else if (monster[i].minY < monster[i].y)
						{
							monster[i].y -= monster[i].moveValY;
						}
					}
				}
				*/
				else if (monster[i].movePattern == Monster.MOVE_FALL)
				{
					if (monster[i].isNowMove)
					{
						if ((monster[i].minX < monster[i].x) && (monster[i].y < monster[i].maxY))
						{
							monster[i].x -= monster[i].moveValX;
							monster[i].y += monster[i].power;
							monster[i].power += monster[i].fallValue;
						}
					}					
				}
				else if (monster[i].movePattern == Monster.MOVE_FALL2)
				{
					if (monster[i].isNowMove)
					{
						if (monster[i].minX < monster[i].x)
						{
							monster[i].x -= monster[i].moveValX;
						}
						if (monster[i].y < monster[i].maxY)
						{
							monster[i].y += monster[i].power;
							monster[i].power += monster[i].fallValue;
						}
					}
				}
				else
				{
					monster[i].move();
				}

				//表示画像設定
				
				//k = int(frameCnt / monster[i].imgChangeInterval) % 2;
				k = int(frameCnt / monster[i].imgChangeInterval);
				k = k - 2 * ((k / 2) >> 0);
				
				if (monster[i].dir == Monster.DIR_LEFT)
				{
					if (k == 0)
					{
						monster[i].imgNo = monster[i].imgNoWalkLeft1;
					}
					else
					{
						monster[i].imgNo = monster[i].imgNoWalkLeft2;
					}
				}
				else if (monster[i].dir == Monster.DIR_RIGHT)
				{
					if (k == 0)
					{
						monster[i].imgNo = monster[i].imgNoWalkRight1;
					}
					else
					{
						monster[i].imgNo = monster[i].imgNoWalkRight2;
					}
				}
			}
}
lastMonsterFrameCnt = monsterFrameCnt;
monsterFrameCnt = ((new Date()).time - stageStartTime) * 0.001 * Global.FPS;
//--------

			//--------刺さった矢の移動
			//for (i = 0; i < arrows.length; i++)
			for (i = 0; i < arrowsLength; i++)
			{
				if (arrows[i].status == Arrow.STATUS_STOP)
				{
					if (0 <= arrows[i].hitIdx)
					{
						arrows[i].x = arrows[i].hitX + monster[arrows[i].hitIdx].x;
						arrows[i].y = arrows[i].hitY + monster[arrows[i].hitIdx].y;

						if ((monster[arrows[i].hitIdx].hp <= 0) && (monster[arrows[i].hitIdx].vanishCnt <= 0))
						{
							arrows[i].hitIdx = -1;
							arrows[i].x = -32;
							arrows[i].y = 640;
						}
						//--------
						else if (monster[arrows[i].hitIdx].commandArrowHide)
						{
							arrows[i].hitIdx = -1;
							arrows[i].x = -32;
							arrows[i].y = 640;
						}
						//--------
					}
				}
			}
			
			//--------当たり判定
			/*
			var d:int = 0;
			var isHit:Boolean = false;
			var isNoDamage:Boolean = false;
			var td:int = 0;
			var bmpHitX:int = 0;
			var bmpHitY:int = 0;
			*/
			var d:int = 0, isHit:Boolean = false, isNoDamage:Boolean = false, td:int = 0, bmpHitX:int = 0, bmpHitY:int = 0, hitColor:uint = 0;
			
			for (k = 0; k < monsterLength; k++)
			{
				if (monster[k].hp <= 0)
				{
					continue;
				}

				//--------
				//処理軽量化20141024
				//画面外は当たり判定しない
				if (monster[k].y < -320)
				{
					continue;
				}
				if (992 < monster[k].x)
				{
					continue;
				}
				//--------

				if (0 < monster[k].hitRect.width)
				{
					//当たり判定：四角
					monsterHitRect.x = monster[k].x + monster[k].hitRect.x;
					monsterHitRect.y = monster[k].y + monster[k].hitRect.y;
					monsterHitRect.width = monster[k].hitRect.width;
					monsterHitRect.height = monster[k].hitRect.height;
				}

				//********
				//for (i = 0; i < arrows.length; i++)
				for (i = 0; i < arrowsLength; i++)
				{
					if (arrows[i].penetrateHitIdx == k)
					{
						//貫通済み
						continue;
					}

					//--------
					if (arrows[i].wazaKind == Item.KIND_IDX_WAZA_HANABI)
					{
						if (0 < arrows[i].hanabiNo)
						{
							//花火爆発前 index:0は除く
							continue;
						}
					}
					//--------

					if (arrows[i].status == Arrow.STATUS_MOVE)
					{
						
						//--------
						//処理軽減対策2014/10/20
						//右方向の矢なら敵のXより右になったら当たり判定する
						if ((0 < arrows[i].vx) && (arrows[i].x < monster[k].x - monster[k].hitRange))
						{
							continue;
						}
						/*
						//左方向の矢なら敵のXより左になったら当たり判定する
						if ((arrows[i].vx < 0) && (monster[k].x + monster[k].hitRange < arrows[i].x))
						{
							continue;
						}
						//左方向は幅がわからないとうまくいかない
						*/
						//--------
						
						
						//--------
						//画面外の上空OR自分の矢ではない、では簡易当たり判定 20141004
						if ((arrows[i].y < 0) || (arrows[i].isSelf == false))
						{
							arrowRouteCnt = 1;
						}
						else
						{
							arrowRouteCnt = Arrow.routeCnt;
						}
						//--------
						
						//******** 当たり判定：四角 ********
						if (0 < monster[k].hitRect.width)
						{
							//--------
							//for (a = 0; a < Arrow.routeCnt; a++ )
							for (a = 0; a < arrowRouteCnt; a++ )
							{
								if (monsterHitRect.contains(arrows[i].routeX[a], arrows[i].routeY[a]))
								{
									//--------
									//刺さる見た目位置修正のため座標を変える20140726.貫通中は止めない
									if (arrows[i].penetrateCnt <= 0)
									{
										arrows[i].x = arrows[i].routeX[a] + arrows[i].vx * 0.1;
										arrows[i].y = arrows[i].routeY[a] + arrows[i].vy * 0.1;
									}
									//--------
									isHit = true;
									break;
								}
							}
							//--------
							
							//--------
							if ((isHit == true) && (monster[k].isReflect == true))
							{
								if (0 < arrows[i].penetrateCnt)
								{
									//貫通は反射貫通
									isPlayNoDamage = true;
									isNoDamage = true;
								}
								else if (arrows[i].status == Arrow.STATUS_MOVE)
								{
									arrows[i].status = Arrow.STATUS_REFLECT;
									arrows[i].vx = -0.5 * arrows[i].vx;
									arrows[i].vy = 0.5 * arrows[i].vy;
									//中まで刺さってから反射しているので2フレーム進める
									arrows[i].x += 2*arrows[i].vx;
									arrows[i].y += 2*arrows[i].vy;
									isPlayNoDamage = true;
									isHit = false;
									
									//花火爆発前なら他の花火矢も消す
									if (arrows[i].hanabiNo == 0)
									{
										for (m = 0; m < arrowsLength; m++)
										{
											if ((0 < arrows[m].hanabiNo) && (arrows[i].isSelf == arrows[m].isSelf))
											{
												arrows[m].hanabiNo = -1;
												arrows[m].status = Arrow.STATUS_STOP;
												arrows[m].x = -32;
												arrows[m].y = 640;
											}
										}
									}

								}
							}
							//--------
						}
						//******** 当たり判定、点と点の距離 ********
						else if (0 < monster[k].hitRange)
						{
							td = monster[k].hitRange * monster[k].hitRange;
							d = (arrows[i].x - monster[k].x) * (arrows[i].x - monster[k].x) + (arrows[i].y - monster[k].y) * (arrows[i].y - monster[k].y);
							if (d <= td)
							{
								trace("HIT");
								isHit = true;
							}
							else if (d <= maxPower * maxPower)
							{
								//--------
								//for (a = 0; a < Arrow.routeCnt; a++ )
								for (a = 0; a < arrowRouteCnt; a++ )
								{
									d = (arrows[i].routeX[a] - monster[k].x) * (arrows[i].routeX[a] - monster[k].x) + (arrows[i].routeY[a] - monster[k].y) * (arrows[i].routeY[a] - monster[k].y);
									if (d <= td)
									{
										trace("中間座標HIT" + a);
										//--------刺さる見た目位置修正のため座標を変える.貫通中は止めない
										if (arrows[i].penetrateCnt <= 0)
										{
											arrows[i].x = arrows[i].routeX[a] + arrows[i].vx * 0.1;
											arrows[i].y = arrows[i].routeY[a] + arrows[i].vy * 0.1;
										}
										//--------
										
										isHit = true;
										break;
									}
								}
								//--------
							}

							//--------
							if ((isHit == true) && (monster[k].isReflect == true))
							{
								if (0 < arrows[i].penetrateCnt)
								{
									//貫通は反射貫通
									isPlayNoDamage = true;
									isNoDamage = true;
								}
								else if (arrows[i].status == Arrow.STATUS_MOVE)
								{
									arrows[i].status = Arrow.STATUS_REFLECT;
									arrows[i].vx = -0.5 * arrows[i].vx;
									arrows[i].vy = 0.5 * arrows[i].vy;
									//中まで刺さってから反射しているので2フレーム進める
									arrows[i].x += 4*arrows[i].vx;
									arrows[i].y += 4*arrows[i].vy;
									isPlayNoDamage = true;
									isHit = false;
									
									//花火爆発前なら他の花火矢も消す
									if (arrows[i].hanabiNo == 0)
									{
										for (m = 0; m < arrowsLength; m++)
										{
											if ((0 < arrows[m].hanabiNo) && (arrows[i].isSelf == arrows[m].isSelf))
											{
												arrows[m].hanabiNo = -1;
												arrows[m].status = Arrow.STATUS_STOP;
												arrows[m].x = -32;
												arrows[m].y = 640;
											}
										}
									}
								}
							}
							//--------
						}
						//******** bmpによる当たり判定 ********
						else if (monster[k].isBmpHit)
						{
							//for (a = 0; a < Arrow.routeCnt; a++)
							for (a = 0; a < arrowRouteCnt; a++ )
							{
								//★★★ 20141004
								//明示的な(int)(n)キャストが重い原因。というかキャストの書き方がそもそも間違っているのかも。int(n)と書くのが正解。
								//
								//参考：http://wonderfl.net/c/5TdP
								//[ n >> 0 で整数化 ] --> 2 ms
								//[ n | 0 で整数化 ] --> 2 ms
								//[ int(n) で整数化 ] --> 6 ms
								//
								//★★★
								//bx = (int)(arrows[i].routeX[a] - monster[k].x);
								//by = (int)(arrows[i].routeY[a] - monster[k].y);
								//bx = int(arrows[i].routeX[a] - monster[k].x);
								//by = int(arrows[i].routeY[a] - monster[k].y);
								bmpHitX = (arrows[i].routeX[a] - monster[k].x) >> 0;
								bmpHitY = (arrows[i].routeY[a] - monster[k].y) >> 0;

								//if ((0 <= bx) && (0 <= by))
								if ((0 <= bmpHitX) && (0 <= bmpHitY) && (bmpHitX < 640) && (bmpHitY < 480))
								{
									//if (bmpForHit.bitmapData.getPixel(bx, by) != 0x000000)
									//if (bmpHitData[bmpHitY * 640 + bmpHitX] != 0xff000000)
									hitColor = bmpHitData[bmpHitY * 640 + bmpHitX];
									if (hitColor != 0xff000000)
									{
										//反射フラグON、または偵察、または報告書Lv11かつ赤なら、反射
										//if (monster[k].isReflect)
										if ((monster[k].isReflect)
										|| ((Scenario.REPORT_LV11 <= scenario.no) && (hitColor == 0xffff0000))
										|| ((isTeisatsu) && (hitColor == 0xffff0000)))
										{
											if (0 < arrows[i].penetrateCnt)
											{
												//貫通は反射貫通
												isPlayNoDamage = true;
												isNoDamage = true;
											}
											else if (arrows[i].status == Arrow.STATUS_MOVE)
											{
												arrows[i].status = Arrow.STATUS_REFLECT;
												arrows[i].vx = -0.5 * arrows[i].vx;
												arrows[i].vy = 0.5 * arrows[i].vy;
												//中まで刺さってから反射しているので2フレーム進める
												arrows[i].x += 2*arrows[i].vx;
												arrows[i].y += 2*arrows[i].vy;

												isPlayNoDamage = true;
												//--------
												//花火爆発前なら他の花火矢も消す
												if (arrows[i].hanabiNo == 0)
												{
													for (m = 0; m < arrowsLength; m++)
													{
														if ((0 < arrows[m].hanabiNo) && (arrows[i].isSelf == arrows[m].isSelf))
														{
															arrows[m].hanabiNo = -1;
															arrows[m].status = Arrow.STATUS_STOP;
															arrows[m].x = -32;
															arrows[m].y = 640;
														}
													}
												}
												//--------
											}
										}
										else
										{
											isHit = true;
											if (monster[k].isEnemy)
											{
												isNoDamage = false;
											}
											else
											{
												isNoDamage = true;
											}
											
											//--------刺さる見た目位置修正のため座標を変える20140726.貫通中は止めない
											if (arrows[i].penetrateCnt <= 0)
											{
												arrows[i].x = arrows[i].routeX[a] + arrows[i].vx * 0.1;
												arrows[i].y = arrows[i].routeY[a] + arrows[i].vy * 0.1;
											}
											//--------

											//--------
											if ((monster[k].isEnemy == false) && (monster[k].enableBreak == true))
											{
												//monster[k].hp--;
												//monster[k].hp -= Hamayumi.damage;
												monster[k].hp -= arrows[i].damage;
												
												//花火爆発前なら他の花火矢も消す
												if (arrows[i].hanabiNo == 0)
												{
													//for (m = 0; m < arrows.length; m++)
													for (m = 0; m < arrowsLength; m++)
													{
														if ((0 < arrows[m].hanabiNo) && (arrows[i].isSelf == arrows[m].isSelf))
														{
															arrows[m].hanabiNo = -1;
															arrows[m].status = Arrow.STATUS_STOP;
															arrows[m].x = -32;
															arrows[m].y = 640;
														}
													}
												}
											}
											//--------
											break;	//a-for
										}
									}
								}
							}
						}
						//******** 当たり判定、点と点の距離2 ********
						else if (0 < monster[k].hitRange2)
						{
							d = (arrows[i].x - (monster[k].x + monster[k].hitRange2X)) * (arrows[i].x - (monster[k].x + monster[k].hitRange2X)) + (arrows[i].y - (monster[k].y + monster[k].hitRange2Y)) * (arrows[i].y - (monster[k].y + monster[k].hitRange2Y));
							if (d <= monster[k].hitRange2)	//hitRange2は計算済みにしておく(2乗)
							{
								trace("HIT");
								isHit = true;
							}
						}
						//****************

						if (isHit)
						{
							//自分の矢
							if ((arrows[i].isSelf == true) && (isNoDamage == false))
							{
								if (monster[k].isNoCount == false)
								{
									//hitCount.value++;
									//--------
									//10倍霊弾用
									if ((monster[k].isMissile == true) && (scenario.isReidan10bai() == true))
									{
										hitCountReidan10bai.value++;
										damageCount.value += arrows[i].damage * 10;
									}
									else
									{
										hitCount.value++;
										damageCount.value += arrows[i].damage;
									}
									//--------
								}
								//monster[k].hp--;
								//monster[k].hp -= Hamayumi.damage;
								monster[k].hp -= arrows[i].damage;

								//========
								//送信用ダメージデータ
								//damageData[k]++;
								damageData[k] += arrows[i].damage;
								//========
							}

							//--------
							//花火爆発前なら他の花火矢も消す
							if (arrows[i].hanabiNo == 0)
							{
								//for (m = 0; m < arrows.length; m++)
								for (m = 0; m < arrowsLength; m++)
								{
									if ((0 < arrows[m].hanabiNo) && (arrows[i].isSelf == arrows[m].isSelf))
									{
										arrows[m].hanabiNo = -1;
										arrows[m].status = Arrow.STATUS_STOP;
										arrows[m].x = -32;
										arrows[m].y = 640;
									}
								}
							}
							//--------

							isPlayGa = true;
							if (monster[k].hp <= 0)
							{
								//HP0判定
								monsterHP0(k);
							}

							//貫通制御
							if (0 < arrows[i].penetrateCnt)
							{
								if ((Hamayumi.is2danHit) || (Hamayumi.is3danHit))
								{
									arrows[i].penetrateCnt--;
									arrows[i].penetrateHitIdx = -1;	//多段ヒットさせる
								}
								else
								{
									arrows[i].penetrateCnt = 0;
									arrows[i].penetrateHitIdx = k;
								}
							}
							else
							{
								arrows[i].status = Arrow.STATUS_STOP;
								arrows[i].hitIdx = k;
								arrows[i].hitX = arrows[i].x - monster[k].x;
								arrows[i].hitY = arrows[i].y - monster[k].y;
							}
							
							isPlayGa = true;
						}
						isHit = false;
					}
				}
			}
			
			//--------
			//炎との当たり判定
			var isHitFire:Boolean = false;
			var fx:int = 0;
			var fy:int = 0;
			for (i = 0; i < hiya.length; i++ )
			{
				//for (k = 0; k < monster.length; k++)
				for (k = 0; k < monsterLength; k++)
				{
					if (monster[k].hp <= 0)
					{
						continue;
					}
					if (monster[k].isReflect)
					{
						continue;
					}
					
					//炎は座標1点なので当たり判定範囲を広げてhitTest
					if (0 < monster[k].hitRange)
					{
						//var d:int = (hiya[i].x - monster[k].x) * (hiya[i].x - monster[k].x) + (hiya[i].y - monster[k].y) * (hiya[i].y - monster[k].y);
						d = (hiya[i].x - monster[k].x) * (hiya[i].x - monster[k].x) + (hiya[i].y - monster[k].y) * (hiya[i].y - monster[k].y);
						isHitFire = (d <= monster[k].hitRange * monster[k].hitRange + 24*24);
					}
					else if (0 < monster[k].hitRect.width)
					{
						monsterHitRect.x = monster[k].x + monster[k].hitRect.x - 12;
						monsterHitRect.y = monster[k].y + monster[k].hitRect.y - 12;
						monsterHitRect.width = monster[k].hitRect.width + 24;
						monsterHitRect.height = monster[k].hitRect.height + 24;
						isHitFire = (monsterHitRect.contains(hiya[i].x, hiya[i].y));
					}
					else if (monster[k].isBmpHit)
					{
						fx = int(hiya[i].x - monster[k].x);
						fy = int(hiya[i].y - monster[k].y);
						isHitFire = (bmpForHit.bitmapData.getPixel(fx, fy) != 0x000000);
					}
					
					if (isHitFire)
					{
						isPlayGa = true;
						if (hiya[i].isSelf)
						{
							//monster[k].hp--;
							monster[k].hp -= Hamayumi.damage;
							if (monster[k].hp <= 0)
							{
								monsterHP0(k);
							}
							//========
							//送信用ダメージデータ
							//damageData[k]++;
							damageData[k] += Hamayumi.damage;
							//========

							if (monster[k].isNoCount == false)
							{
								hitCount.value++;
								damageCount.value += Hamayumi.damage;
							}
						}
						hiya[i].hp--;
					}
				}

				//炎消滅
				if (Global.FPS * 15 < hiya[i].showCount)
				{
					hiya[i].hp = 0;
				}
				hiya[i].showCount++;

				if (hiya[i].hp <= 0)
				{
					hiya.splice(i, 1);
					i--;
					break;
				}
			}
			//--------

			//--------
			//氷との当たり判定
			var isHitKoori:Boolean = false;
			for (i = 0; i < kooriya.length; i++ )
			{
				//for (k = 0; k < monster.length; k++)
				for (k = 0; k < monsterLength; k++)
				{
					if (monster[k].hp <= 0)
					{
						continue;
					}
					if (monster[k].isReflect)
					{
						continue;
					}
					
					//座標1点なので当たり判定範囲を広げてhitTest
					if (0 < monster[k].hitRange)
					{
						d = (kooriya[i].x - monster[k].x) * (kooriya[i].x - monster[k].x) + (kooriya[i].y - monster[k].y) * (kooriya[i].y - monster[k].y);
						isHitKoori = (d <= monster[k].hitRange * monster[k].hitRange + 32*32);
					}
					else if (0 < monster[k].hitRect.width)
					{
						monsterHitRect.x = monster[k].x + monster[k].hitRect.x - 16;
						monsterHitRect.y = monster[k].y + monster[k].hitRect.y - 16;
						monsterHitRect.width = monster[k].hitRect.width + 32;
						monsterHitRect.height = monster[k].hitRect.height + 32;
						isHitKoori = (monsterHitRect.contains(kooriya[i].x, kooriya[i].y));
					}
					else if (monster[k].isBmpHit)
					{
						fx = int(kooriya[i].x - monster[k].x);
						fy = int(kooriya[i].y - monster[k].y);
						isHitKoori = (bmpForHit.bitmapData.getPixel(fx, fy) != 0x000000);
					}
					
					if (isHitKoori)
					{
						isPlayGa = true;
						if (kooriya[i].isSelf)
						{
							//monster[k].hp--;
							monster[k].hp -= Hamayumi.damage;
							if (monster[k].hp <= 0)
							{
								monsterHP0(k);
							}
							//========
							//送信用ダメージデータ
							//damageData[k]++;
							damageData[k] += Hamayumi.damage;
							//========

							if (monster[k].isNoCount == false)
							{
								hitCount.value++;
								damageCount.value += Hamayumi.damage;
							}
						}
						kooriya[i].hp--;
					}
				}

				//氷消滅
				if (Global.FPS * 15 < kooriya[i].showCount)
				{
					kooriya[i].hp = 0;
				}
				kooriya[i].showCount++;

				if (kooriya[i].hp <= 0)
				{
					kooriya.splice(i, 1);
					i--;
					break;
				}
			}
			//--------

			if (isPlayGa)
			{
				Global.playGa();
				isPlayGa = false;
			}
			if (isPlayTodome)
			{
				Global.playTodome();
				isPlayTodome = false;
			}
			if (isPlayNoDamage)
			{
				Global.playNoDamage();
				isPlayNoDamage = false;
			}

			//--------矢倉と敵の攻撃ヒット判定
			if (yagura.enable)
			{
				//for (i = 0; i < monster.length; i++)
				for (i = 0; i < monsterLength; i++)
				{
					if (monster[i].isMissile == false)
					{
						continue;
					}
					if (monster[i].hp <= 0)
					{
						continue;
					}

					if (yagura.contains(monster[i].x, monster[i].y))
					{
						//--------
						if (monster[i].isNoDamage)
						{
							monster[i].hp = 0;
							continue;
						}
						//--------
						
						//Global.playDamage();
						if (0 < yagura.hp)
						{
							Global.playDamage();
						}
						
						//yagura.hp--;
						//monster[i].hp = 0;
						if (monster[i].isUnbreakableMissile == false)
						{
							monster[i].hp = 0;
						}
						if (0 < usvr.memberNo.length)
						{
							//================
							//オンラインでは矢倉HPはホスト管理
							if (usvr.isHost())
							{
								yagura.hp--;
							}
							//================
						}
						else
						{
							yagura.hp--;
						}
					}
				}

			}

			//--------馬移動
			//if (umaXY.y != int.MIN_VALUE)
			if (myArcher.isUseUma)
			{
				//baseShoot.x++;
				myArcher.x++;
				if (int(frameCnt / Global.halfFPS) % 3 == 0)
				{
					//baseShoot.y = umaXY.y + 2;
					myArcher.y = myArcher.getUmaDownY;
				}
				else
				{
					//baseShoot.y = umaXY.y;
					myArcher.y = myArcher.getUmaUpY;
				}
			}

//これは１回でOKのはず
//TEST
			//================ 霊体 射撃位置調整
			for (i = 0; i < usvr.memberNo.length; i++)
			{
				if (usvr.memberNo[i] == usvr.reactor.self().getClientID())
				{
					myArcher = archer[i];
					break;
				}
			}
			//================

			//矢倉ＨＰ変化チェック
			var isYaguraChange:Boolean = false;
			if (yagura.enable)
			{
				if (lastYaguraHPForDraw != yagura.hp)
				{
					isYaguraChange = true;
					renderTextureYagura.clear();
				}
			}
			//--------描画
			renderTextureYagura.drawBundled(function():void
			{
				if (isYaguraChange)
				{
					if (0 < yagura.hp)
					{
						var idx:int = yaguraImgIdx[yagura.hp];
						canvasYagura.y = 480 - 32 - image[idx].height;
						renderTextureYagura.draw(image[idx]);
						lastYaguraHPForDraw = yagura.hp;
					}
				}
			});


			//--------矢描画myQuadBatch
			//QuadBatchのほうが若干速いもよう(10%くらい)
			//矢
			arrowQuadBatch.reset();
			var ridx:int;
			//var lightShowFrameCnt:int = frameCnt % 3;
			var lightNoSelfShow:int = frameCnt - 3 * ((frameCnt / 3) >> 0);	//これで余り出したほうが速い(%:828ms -> 172ms)
			var lightNoNotSelfShow:int = frameCnt - 6 * ((frameCnt / 6) >> 0);
			//for (i = 0; i < arrows.length; i++)
			for (i = 0; i < arrowsLength; i++)
			{
				//--------
				if ((arrows[i].x < 0) || (672 < arrows[i].x))
				{
					//画面外。描画しない
					continue;
				}
				if (arrows[i].y < -32)
				{
					//画面外。描画しない
					continue;
				}
				//--------

				//--------
				//軽量化処理
				if (Hamayumi.isLight)
				{
					/*
					if (arrows[i].lightNoSelf != lightShowFrameCnt)
					{
						continue;
					}
					*/
					if (arrows[i].isSelf)
					{
						if (arrows[i].lightNoSelf != lightNoSelfShow)
						{
							continue;
						}
					}
					else
					{
						if (arrows[i].lightNoNotSelf != lightNoNotSelfShow)
						{
							continue;
						}
					}
					if (arrows[i].status == Arrow.STATUS_STOP)
					{
						if (0 < arrows[i].x)
						{
							arrows[i].lightVanishCnt++;
							if (5 < arrows[i].lightVanishCnt)
							{
								arrows[i].lightVanishCnt = 0;
								arrows[i].x = -32;
								arrows[i].y = 640;
								arrows[i].hitIdx = -1;
							}
						}
					}
				}
				//--------

				if (arrows[i].wazaKind == Item.KIND_IDX_WAZA_HANABI)
				{
					if (0 < arrows[i].hanabiNo)
					{
						//花火爆発前 index:0は除く
						continue;
					}
				}
			
				if (0 < arrows[i].shootWait)
				{
					continue;
				}
			
				//--------
				//ridx = (rad2deg(arrows[i].r) + 360) % 360;
				ridx = (rad2deg(arrows[i].r) + 360);
				ridx = ridx - 360 * ((ridx / 360) >> 0);
				//--------
			
				if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
				{
					if (arrows[i].isSelf)
					{
						//arrowImage = BitmapManager.hamayumiArrowImage;
						//--------
						if (arrows[i].isWazaTame)
						{
							arrowImage = BitmapManager.hamayumiArrowImageTame;
						}
						else
						{
							arrowImage = BitmapManager.hamayumiArrowImage;
						}
						//--------
					}
					else
					{
						arrowImage = BitmapManager.hamayumiArrowImageCoop;
					}
				}
				else
				{
					arrowImage = BitmapManager.normalArrowImage;
				}

				//--------
				arrowImage[ridx].x = arrows[i].x;
				arrowImage[ridx].y = arrows[i].y;
				arrowQuadBatch.addImage(arrowImage[ridx]);
				//--------
			}

			mainQuadBatch.reset();

			//炎
			for (k = 0; k < hiya.length; k++)
			{
				ridx = 215 + int((frameCnt + k) / Global.halfFPS) % 2;
				image[ridx].x = hiya[k].x;
				image[ridx].y = hiya[k].y;
				mainQuadBatch.addImage(image[ridx]);
			}

			//氷
			for (k = 0; k < kooriya.length; k++)
			{
				ridx = 223;
				image[ridx].x = kooriya[k].x;
				image[ridx].y = kooriya[k].y;
				mainQuadBatch.addImage(image[ridx]);
			}

			//--------描画
			renderTexture.clear();
			renderTexture.drawBundled(function():void
			{
				var i:int;
				var idx:int;

//毎回描画要らない奴は別renderにすべき

				//角度設定
				image[myArcher.udeIdx].rotation = myArcher.yumiR;
				image[myArcher.yumiIdx].rotation = myArcher.yumiR;
				image[myArcher.hikiYumiIdx].rotation = myArcher.yumiR;

				//矢倉
				if (yagura.enable)
				{
					//if ((isGameOver) && (yagura.hp <= 0))
					if (yagura.hp <= 0)
					{
						//for (i = 0; i < 9; i++)
						for (i = 9-1; i >= 0; i--)
						{
							image[89 + i].x = (i % 3) * 32;
							image[89 + i].y = int(i / 3) * 32 + (480 - 32 - 96) + gameoverFrameCnt;
							if (image[89 + i].y < 480 - 48)
							{
								//image[89 + i].x += Math.random() * 3 - 1;
								image[89 + i].x += mt.getRandInt(3) - 1;
							}
							else
							{
								image[89 + i].y = 480 - 48;
							}
							renderTexture.draw(image[89 + i]);
						}
					
						for (i = 0; i < usvr.memberNo.length; i++)
						//for (i = 0; i < memberCnt; i++)
						{
							//archer[i].addInitXY(Math.random() * 3 - 1, gameoverFrameCnt);
							archer[i].addInitXY(mt.getRandInt(3) - 1, gameoverFrameCnt);
						}
						//myArcher.addInitXY(Math.random() * 3 - 1, gameoverFrameCnt);
						myArcher.addInitXY(mt.getRandInt(3) - 1, gameoverFrameCnt);
						gameoverFrameCnt++;
					}
				}

				//敵
				//for (i = 0; i < monster.length; i++)
				for (i = 0; i < monsterLength; i++)
				{
					if ((monster[i].hp <= 0) && (monster[i].vanishCnt <= 0) && (monster[i].isVanish))
					{
						continue;
					}
					
					//カメレオンで使用
					if (monster[i].isShow == false)
					{
						continue;
					}

					idx = monster[i].imgNo;
					monsterImage[idx].x = monster[i].x;
					monsterImage[idx].y = monster[i].y;
					
					//落下ぐらぐら
					if ((monster[i].isDieFall) && (monster[i].hp <= 0))
					{
						//小さいものはぐらぐらさせない
						if (32 < monsterImage[idx].width)
						{
							monsterImage[idx].x = monster[i].x + mt.getRandInt(3) - 1;
						}
					}
					//renderTexture.draw(monsterImage[idx]);
					//myQuadBatch.addImage(monsterImage[idx]);
					
					//if (scenario.isReportStage())
					if (isReportStage)
					{
						//報告は動的作成画像なので、QuadBatchを使うとATFが出なくなる。(元画像データが別だと正常表示されない)
						renderTexture.draw(monsterImage[idx]);
					}
					else
					{
						mainQuadBatch.addImage(monsterImage[idx]);
					}
				}
				
				//敵HP表示
				if (Hamayumi.isShowHP)
				{
					//for (i = 0; i < monster.length; i++)
					for (i = 0; i < monsterLength; i++)
					{
						if ((0 < monster[i].hp) && (monster[i].isMissile == false) && (monster[i].isEnemy == true))
						{
							//カメレオンで使用
							if (monster[i].isShow == false)
							{
								monsterHP[i].visible = false;
								monsterHPBG[i].visible = false;
								continue;
							}

							monsterHP[i].visible = true;
							monsterHPBG[i].visible = true;
							//monsterHP[i].x = monster[i].x;
							//monsterHP[i].y = monster[i].y - 4;
							monsterHP[i].width = monsterHPBG[i].width * (monster[i].hp / monster[i].maxHP);
							//monsterHPBG[i].x = monster[i].x;
							//monsterHPBG[i].y = monster[i].y - 4;
							
							if (0 < monster[i].hitRect.width)
							{
								monsterHP[i].x = monsterHPBG[i].x = monster[i].x - monster[i].hitRect.width;
								monsterHP[i].y = monsterHPBG[i].y = monster[i].y - monster[i].hitRect.height;
								
								//--------
								if (monsterImage[monster[i].imgNoWalkLeft1].pivotX == 0)
								{
									monsterHP[i].x = monsterHPBG[i].x = monster[i].x;
								}
								if (monsterImage[monster[i].imgNoWalkLeft1].pivotY == 0)
								{
									monsterHP[i].y = monsterHPBG[i].y = monster[i].y - 4;
								}
							}
							else if (0 < monster[i].hitRange)
							{
								monsterHP[i].x = monsterHPBG[i].x = monster[i].x - monster[i].hitRange;
								monsterHP[i].y = monsterHPBG[i].y = monster[i].y - monster[i].hitRange - 4;
							}
							else
							{
								monsterHP[i].x = monsterHPBG[i].x = monster[i].x;
								monsterHP[i].y = monsterHPBG[i].y = monster[i].y - 4;
							}
							
							if (monster[i].y == 0)
							{
								monsterHP[i].y = monsterHPBG[i].y = 0;
							}
						}
						else
						{
							monsterHP[i].visible = false;
							monsterHPBG[i].visible = false;
						}
					}
				}

				//馬
				if (myArcher.isUseUma)
				{
					idx = 56 + int(frameCnt / Global.halfFPS) % 3;
					image[idx].x = myArcher.umaX;
					image[idx].y = myArcher.umaY;
					renderTexture.draw(image[idx]);
				}

				//腕
				image[myArcher.udeIdx].x = myArcher.udeX;
				image[myArcher.udeIdx].y = myArcher.udeY;

				//人
				image[myArcher.archerIdx].x = myArcher.x;
				image[myArcher.archerIdx].y = myArcher.y;

				//弓
				myArcher.yumiIdx = myArcher.kamaeYumiIdx;
				if (isMouseDown)
				{
					myArcher.yumiIdx = myArcher.hikiYumiIdx;
				}
				image[myArcher.yumiIdx].x = myArcher.yumiX;
				image[myArcher.yumiIdx].y = myArcher.yumiY;

				//向き
				if (myArcher.archerIdx == 1)
				{
					//右向き
					renderTexture.draw(image[myArcher.udeIdx]);
					renderTexture.draw(image[myArcher.archerIdx]);
					renderTexture.draw(image[myArcher.yumiIdx]);
				}
				else
				{
					image[myArcher.udeIdx].x = myArcher.udeX - 2;
					image[myArcher.yumiIdx].x = myArcher.udeX - 2;
					//左向き
					renderTexture.draw(image[myArcher.yumiIdx]);
					renderTexture.draw(image[myArcher.archerIdx]);
					renderTexture.draw(image[myArcher.udeIdx]);
				}

				//================ online
				////ゲームオーバーまたはクリアで切断してキャラが消えるのでその対策
				if (isClear == false)
				{
					//memberCnt = usvr.memberNo.length;
					//for (i = 0; i < memberCnt; i++)
					for (i = 0; i < usvr.memberNo.length; i++)
					{				
						if (usvr.reactor.self().getClientID() == usvr.memberNo[i])
						{
							//自分
							memberSelfIdx = i;
							break;
						}
					}
				}
				//drawMember(memberCnt, memberSelfIdx);
				drawMember(usvr.memberNo.length, memberSelfIdx);
			});

//}


//if (remainTime % Global.FPS == 0)
//if (frameCnt % Global.halfFPS == 0)
if ((isClear == false) && (frameCnt % Global.halfFPS == 0))
{

			renderTextureHeader.clear();
			renderTextureHeader.drawBundled(function():void
			{
				//タイム表示
				//var sec:int = (remainTime / Global.FPS);
var sec:int = stageTimeSec - ((new Date()).time - stageStartTime) * 0.001;
if (sec < 0)
{
	sec = 0;
}
				var tmp000:int = 71 + int(sec / 100);
				var tmp00:int  = 71 + int((sec % 100) / 10);
				var tmp0:int   = 71 + int(sec % 10);
				image[ tmp000 ].x = 320 - 4 - 7*3;
				//image[ tmp000 ].y = 2;
				renderTextureHeader.draw(image[ tmp000 ]);
				image[ tmp00 ].x = 320 - 4 - 7*2;
				//image[ tmp00 ].y = 2;
				renderTextureHeader.draw(image[ tmp00 ]);
				image[ tmp0 ].x = 320 - 4 - 7*1;
				//image[ tmp0 ].y = 2;
				renderTextureHeader.draw(image[ tmp0 ]);
				image[ 136 ].x = 320 - 2 - 8*7;
				//image[ 136 ].y = 1;
				renderTextureHeader.draw(image[ 136 ]);
			});
			
}

			//--------
			//当たり判定用画像を隠すBMPを消す
			if (kakushiBmp.visible)
			{
				kakushiBmp.visible = false;
			}
			//--------

			//--------
			frameCnt++;
			//--------

			//================
			//ダメージ定期送信
			sendDamageData();
			//================

			//--------クリア判定
			if (isClear)
			{
				waitClearCnt--;
				isMouseDown = false;

				if (waitClearCnt == 0)
				{
					//clearMC.msg_txt.text = "【クリックして終了】";

					//勾玉変換選択画面
					// 酒呑童子討伐済み
					// 破魔弓ステージ
					// アイテム一杯ではない
					// ゲームオーバーではない
					if (0 < Global.userTbl.getCount())
					{
						if ((Global.dailyQuestNo == 4) && (isGameOver == false))
						{
							//勾玉ゲットクエスト
							save(true);
						}
						//--------
						else if (hitCount.value == 0)
						{
							clearMC.msg_txt.text = "【クリックして終了】";
						}
						//--------
						//if (enableMessageSelectGamen())
						else if (enableMessageSelectGamen())
						{
							clearMC.msg_txt.text = "";	//選択後に出すのでここでは消す
							messageSelectGamen.visible = true;
							messageSelectGamen.mc.msg_txt.text = "獲得した霊力を勾玉に変換しますか？\n変換すると霊力は取得できません。";
							
							//--------
							//勾玉変換技+1以降がある
							for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
							{
								if (0 <= Global.useryumiTbl.getData(i, "ID").indexOf("EXP"))
								{
									messageSelectGamen.mc.msg_txt.text = "獲得した霊力を勾玉に変換しますか？";
									break;
								}
							}
							//--------
						}
						//@@@@@@@@
						else
						{
							save(false);
						}
						//@@@@@@@@
					}
					else
					{
						//ユーザ登録orログインしてない
						clearMC.msg_txt.text = "【クリックして終了】";
					}

				}

				if (isGameOver)
				{
					clearMC.visible = true;
					clearMC.clear_txt.visible = false;
					clearMC.failed_txt.visible = true;
				}
				else
				{
					clearMC.visible = true;
					clearMC.clear_txt.visible = true;
					clearMC.failed_txt.visible = false;
				}
				
				//return;
				if (isGameOver)
				{
					checkClear();
				}
				
				//--------
				//10/20 連打で終了すると、退治結果が残るバグの応急処置
				if (Global.selectGamen.visible)
				{
					clearMC.visible = false;
				}
				//--------
				
				return;
			}
			checkClear();
			
			//ゲームオーバー判定
			if (frameCnt % Global.halfFPS == 0)
			{
				checkGameOver();
				if (isGameOver)
				{
					isClear = true;
					clearFrameCnt = frameCnt;
					clearTime = ((new Date()).time - stageStartTime);

					setClickTxt();

					waitClearCnt = WAIT_CLEAR_CNT;
					isMouseDown = false;
					
					return;
				}
			}

			//時間終了
			//if (remainTime <= 0)
			if (stageTimeSec - ((new Date()).time - stageStartTime) * 0.001 <= 0)
			{
				isGameOver = true;
				waitClearCnt = WAIT_CLEAR_CNT;
			}
			else
			{
				remainTime--;
			}

/*
//TEST
if (frameCnt == 1)
{
	addChild(aaaaa);
}
aaaaa.width = monster[0].hitRect.width;
aaaaa.height = monster[0].hitRect.height;
aaaaa.x = monster[0].x + monster[0].hitRect.x;
aaaaa.y = monster[0].y + monster[0].hitRect.y;
*/

		}

//var aaaaa:Quad = new Quad(10, 10, 0xfff0000);


		// ----------------
		// enableMessageSelectGamen
		// ----------------
		//private var isShowedMagatamaSelect:Boolean = false;
		private function enableMessageSelectGamen():Boolean
		{
			if (Global.userTbl.getCount() <= 0)
			{
				return false;
			}
			
			var nowIndex:int = int(Global.userTbl.getData(0, "SCENARIO"));
			if ((scenario.getStageIdx(Scenario.SHUTENDOUJI) <= nowIndex)
			&& (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
			&& (Global.itemTbl.getCount() < Item.MAX_COUNT)
			&& (isGameOver == false))
			{
				return true;
			}
			return false;
		}

		// ----------------
		// monsterHP0
		// ----------------
		private function monsterHP0(k:int):void
		{
			//++++++++
			//setLogInfo("monsterHP0");
			//++++++++

			var m:int;

			//■(※)HP0時の処理はCOOP用の処理が別で書いてあるのでそっちの修正も必要

			monster[k].vanishCnt = Global.FPS * 3;
			if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
			{
				isPlayTodome = true;
				isPlayGa = false;
			}

			//本体がやられたので子もHP0にする
			//for (m = 0; m < monster.length; m++)
			//var monsterLength:int = monster.length;
			for (m = 0; m < monsterLength; m++)
			{
				if (k == monster[m].bodyIdx)
				{
					//monster[m].hp = 0;
					//monster[m].vanishCnt = Global.FPS * 3;
					if (0 < monster[m].hp)
					{
						monster[m].hp = 0;
						monster[m].vanishCnt = Global.FPS * 3;
					}
				}
			}

			//本体破壊による変化
			//for (m = 0; m < monster.length; m++)
			for (m = 0; m < monsterLength; m++)
			{
				if (k == monster[m].hontaiIdx)
				{
					monster[m].isReflect = false;
				}
			}
		}


		//--------
		// ----------------
		// kyoukaHanabiShoot
		// ----------------
		private function kyoukaHanabiShoot(_baseX:int, _baseY:int, _isSelf:Boolean):void
		{
			//++++++++
			//setLogInfo("kyoukaHanabiShoot");
			//++++++++

			var i:int, ii:int, a:int;
			var v0:Number;
			var r:Number;
			var cnt:int = 0;
			var baseR:Number = 0.0;
			maxShootArrowCnt = shootArrowCnt.value * 0.5;//2 * shootArrowCnt;
			//baratsuki = 0.0;

			//--------
			for (ii = startArrowIdx; ii < arrowsLength * 2; ii++)
			{
				//%計算は重い
				//i = ii % arrows.length;
				i = ii - arrowsLength * ((ii / arrowsLength) >> 0);

				if ((arrows[i].status == Arrow.STATUS_STOP) || (arrows[i].isSelf == false))
				{
					baseR = cnt * 2*Math.PI * (1 / maxShootArrowCnt);
					//--------射出--------
					v0 = Arrow.getV0Power(maxPower * 0.1, cnt, frameCnt, 0.0);
					r = Arrow.getV0Radian(baseR, cnt, frameCnt, 0.0);
					
					arrows[i].v0 = v0;
					arrows[i].baseR = baseR;
					arrows[i].baratsuki = baratsuki;

					arrows[i].wazaKind = 0;

					arrows[i].x = _baseX;
					arrows[i].y = _baseY;
					arrows[i].moveCount = 0;

					for (a = 0; a < Arrow.routeCnt; a++ )
					{
						arrows[i].routeX[a] = -32;
						arrows[i].routeY[a] = -32;
					}

					arrows[i].hitIdx = -1;
					arrows[i].penetrateCnt = 0;
					arrows[i].penetrateHitIdx = -1;
					if ((scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI) && (cnt < penetrateMaxCnt))
					{
						arrows[i].penetrateCnt = 1;
					}
					arrows[i].damage = Hamayumi.hanabiDamage;
					arrows[i].isSelf = _isSelf;
					arrows[i].vx = v0 * Math.cos(r);
					arrows[i].vy = -1 * v0 * Math.sin(r);
					arrows[i].r = Math.atan2(arrows[i].vy, arrows[i].vx) + Math.PI / 2;
					//後ろから出てるので5フレーム進める
					arrows[i].x += arrows[i].vx * 5;
					arrows[i].y += arrows[i].vy * 5;
					arrows[i].status = Arrow.STATUS_MOVE;
					//arrows[i].shootWait = cnt % 4;

					cnt++;
				}

				if (maxShootArrowCnt <= cnt)
				{
					startArrowIdx = i + 1;
					break;
				}
			}

		}
		//--------

		// ================
		// sendDamageData
		// ================
		private var sendDamagaInterval:int = 0;
		//private function sendDamageData():void
		[Inline]
		final private function sendDamageData():void
		{
			//++++++++
			////setLogInfo("sendDamageData");
			//++++++++

			//ダメージ定期送信
			if (0 < usvr.memberNo.length)
			{
				if (sendDamagaInterval % Global.halfFPS == 0)
				{
					var i:int;
					var damageAll:int = 0;
					for (i = 0; i < damageData.length; i++)
					{
						damageAll += damageData[i];
					}
					if ((0 < damageAll) || (lastYaguraHP != yagura.hp))
					{
						lastYaguraHP = yagura.hp;
			
						var mdata:String = "";
						mdata += frameCnt + ",";
						mdata += remainTime + ",";
						mdata += yagura.hp + ",";
						mdata += int(flashStage.mouseX) + ",";
						mdata += int(flashStage.mouseY) + ",";
						for (i = 0; i < damageData.length; i++)
						{
							mdata += damageData[i] + ",";
							damageData[i] = 0;
						}
						usvr.sendMessage("COOP", mdata);
					}
				}
			}
			sendDamagaInterval++;
		}

		// ----------------
		// keydownListener
		// ----------------
		private var keyCodeNum:Vector.<int> = Vector.<int>
		([
			 Keyboard.NUMBER_1
			,Keyboard.NUMBER_2
			,Keyboard.NUMBER_3
			,Keyboard.NUMBER_4
			,Keyboard.NUMBER_5
			,Keyboard.NUMBER_6
			,Keyboard.NUMBER_7
			,Keyboard.NUMBER_8
			,Keyboard.NUMBER_9
			,Keyboard.NUMBER_0
		]);
		private function keydownListener(e:KeyboardEvent):void
		{
			//++++++++
			//setLogInfo("keydownListener");
			//++++++++

			var i:int;

			if (e.keyCode == Keyboard.Z)
			{
				if (isClear == false)
				{
					isMouseDown = true;
				}
				return;
			}

			//呪いの勾玉を装備している場合は勾玉切替無効
			//破魔弓[呪]のときはOK
			if (Global.isEquipNoroi(true))
			{
				showStageTitle("[呪]装備中は変更出来ません。");
				return;
			}
/*
			//霊力同調中
			if ((2 <= personcnt) && (Global.yumiSettingGamen.isDocho()))
			{
				showStageTitle("霊力同調中は変更出来ません。");
				return;
			}
*/
			if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
			{
				for (i = 0; i < keyCodeNum.length; i++)
				{
					if (e.keyCode == keyCodeNum[i])
					{
						itemGamen.setFavEquip(i);
						trace("keydownListener:" + i);
						showStageTitle(ItemGamen.getSumKindValue());
						
						power = -maxPower;
						allPower = -maxPower;
						isFullTame2 = false;
				
						setHamayumi();
						
						break;
					}
				}
			}
		}
		private var withdrawCount:int = 0;
		private function keyupListener(e:KeyboardEvent):void
		{
			//++++++++
			//setLogInfo("keyupListener");
			//++++++++

			if (e.keyCode == Keyboard.Z)
			{
				if (isClear == false)
				{
					isMouseDown = false;
				}
			}
			
			//--------
			//ソロなら撤退できる
			if (e.keyCode == Keyboard.W)
			{
				if (personcnt <= 1)
				{
					withdrawCount++;
					if (3 <= withdrawCount)
					{
						remainTime = 0;
						stageStartTime = 0;
						//clearMC.failed_txt.text = "撤退";
					}
				}
			}
			//--------
		}

		// ----------------
		// showStageTitle
		// ----------------
		private function showStageTitle(msg:String):void
		{
			//++++++++
			//setLogInfo("showStageTitle");
			//++++++++

			stageTitle.visible = true;
			stageTitle.text = msg;
			stageTitleShowCnt = 3 * Global.FPS;
		}
		
		// ----------------
		// checkClear
		// ----------------
		//private function checkClear():void
		[Inline]
		final private function checkClear():void
		{
			//++++++++
			////setLogInfo("checkClear");
			//++++++++

			var i:int;
			var cnt:int;
	
			cnt = 0;
			for (i = 0; i < monsterLength; i++)
			{
				if (monster[i].hp <= 0)
				{
					cnt++;
				}
				else if (monster[i].isEnemy == false)
				{
					cnt++;
				}
			}
			if (cnt == monsterLength)
			{
				//isEnemy=falseも落下させるため
				for (i = 0; i < monsterLength; i++)
				{
					if (0 < monster[i].hp)
					{
						monster[i].hp = 0;
						if (monster[i].isMissile == false)
						{
							monster[i].vanishCnt = Global.FPS * 3;
						}
					}
				}

				isClear = true;
				clearFrameCnt = frameCnt;
				clearTime = ((new Date()).time - stageStartTime);
				
				isGameOver = false;
				waitClearCnt = WAIT_CLEAR_CNT;

				setClickTxt();

				Global.stopBGM();
				Global.playClear();

				//--------
				if (0 < Global.userTbl.getCount())
				{
					var nowIndex:int = int(Global.userTbl.getData(0, "SCENARIO"));
					if (scenario.getStageIdx(Scenario.SHUTENDOUJI) <= nowIndex)
					{
						//酒呑童子クリア済みなら、勾玉選択後に判定
						waitClearCnt = WAIT_CLEAR_CNT_FAST;
					}
				}

				//================
				if (usvr.isJoinSuccess)
				{
					//online
					//if (usvr.isHost())
					if (usvr.isRoomMakeHost)
					{
						scenario.clearStage();
					}
				}
				//================
				else
				{
					//offline
					scenario.clearStage();
				}
			}
		}

		// ----------------
		// setClickTxt
		// ----------------
		private var magatamaQuality:int = 0;
		//private var addExp:int = 0;
		public var addExp:Value = new Value();

		private function setClickTxt():void
		{
			//++++++++
			//setLogInfo("setClickTxt");
			//++++++++

			var str:String = "";
			var hitRate:Number;
			//var addExp:int;
			addExp.value = 0;

//			clearMC.click_txt.visible = true;

			if (shotCount <= 0)
			{
				hitRate = 0.0;
				addExp.value = 0;
			}
			else
			{
				hitRate = hitCount.value / shotCount;
				if (scenario.bowKind[scenario.no] == Scenario.YUMI_NORMAL)
				{
					addExp.value = int(100 * hitRate);
				}
				else
				{
					//addExp.value = hitCount.value;
					//addExp.value += hitCountReidan10bai.value * 10;
					//trace("1017 EXP TEST:" + (hitCount.value + hitCountReidan10bai.value * 10) + "=" + damageCount.value);
					addExp.value = damageCount.value;
				}
			}
			
			if (isGameOver)
			{
				addExp.value = addExp.value * 0.5;
			}

			if (scenario.bowKind[scenario.no] == Scenario.YUMI_NORMAL)
			{
				str += "矢数:" + shotCount;
				str += " 命中数:" + hitCount.value;
				str += " 命中率:" + int(hitRate * 100) + "%";
			}
			else if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
			{
				str += "矢数:" + shotCount;
				str += " 命中数:" + hitCount.value;
				if (0 < hitCountReidan10bai.value)
				{
					str += " 鬼火弾命中数:" + hitCountReidan10bai.value;
				}
				str += " 取得霊力:" + addExp.value;
				
				//magatamaQuality = hitCount.value / getMagatamaNeedDamage() * 100;
				magatamaQuality = damageCount.value / getMagatamaNeedDamage() * 100;
				//================
				if (1 < personcnt)
				{
					if (100 <= magatamaQuality)
					{
						//str += "(高)";
						str += ""; //今までどおりの通常勾玉なので表記なし
					}
					else if (66 <= magatamaQuality)
					{
						//str += "(中)";
						str += "(低)";
					}
					else if (33 <= magatamaQuality)
					{
						str += "(低)";
					}
					else
					{
						str += "(低)";
					}
					//str += hitCount.value + " " + stageTotalHp + " " + magatamaQuality;
				}
				//================
			}

			//レベル上限に達しているのならaddExp=0
			if (Hamayumi.MAX_LEVEL <= Hamayumi.level)
			{
				addExp.value = 0;
			}

			//20140921 経験値の加算はサーバーで行うので不要
			//Hamayumi.exp += addExp.value;
			//→ユーザ登録してないとサーバーに行かないので鍛錬と演習で加算されない
			//勾玉変換できないのなら決定しているので加算してレベルアップチェックも行う↓

			//--------
			if (enableMessageSelectGamen() == false)
			{
				//勾玉変換選択が出来ない場合、取得経験値が決まっているのでレベルアップチェックする。
				Hamayumi.exp += addExp.value;
				if (scenario.bowKind[scenario.no] == Scenario.YUMI_HAMAYUMI)
				{
					if (beforeLevel < Hamayumi.level)
					{
						str += "\nレベルアップ！破魔弓レベルが" + Hamayumi.level + "になった！";
					}
				}
			}
			//--------

			clearMC.click_txt.text = str;

			if (clearMC.click_txt.visible)
			{
				return;
			}
			clearMC.click_txt.visible = true;
		}

		// ----------------
		// drawMember
		// ----------------
		private function drawMember(memberCnt:int, seifIdx:int):void
		{
			//++++++++
			//setLogInfo("drawMember" + memberCnt + " " + seifIdx);
			//++++++++

			var i:int;
			var idx:int;

			for (i = 0; i < memberCnt; i++)
			{
				if (i == seifIdx)
				{
					//自分
					continue;
				}
				
				//腕
				idx = 2;//45;
				image[idx].x = archer[i].udeX;//archer[i].x + 18 + baseShoot.x;
				image[idx].y = archer[i].udeY;//archer[i].y + 20 + baseShoot.y;
				image[idx].rotation = archer[i].yumiR;
				renderTexture.draw(image[idx]);
				//体
				idx = 81 + i;//44;
				image[idx].x = archer[i].x;//archer[i].x + baseShoot.x;
				image[idx].y = archer[i].y;//archer[i].y + baseShoot.y;
				renderTexture.draw(image[idx]);
				//弓
				archer[i].yumiIdx = archer[i].kamaeYumiIdx;
				image[archer[i].yumiIdx].x = archer[i].yumiX;//archer[i].x + 18 + baseShoot.x;
				image[archer[i].yumiIdx].y = archer[i].yumiY;//archer[i].y + 19 + baseShoot.y;
				image[archer[i].yumiIdx].rotation = archer[i].yumiR;
				renderTexture.draw(image[archer[i].yumiIdx]);
			}
		}

		// ----------------
		// checkGameOver
		// ----------------
		//private function checkGameOver():void
		[Inline]
		final private function checkGameOver():void
		{
			//++++++++
			////setLogInfo("checkGameOver");
			//++++++++

			var i:int;

			//キャラクターが右画面外
			//if (640 < baseShoot.x)
			if (640 < myArcher.x)
			{
				isGameOver = true;
			}

			for (i = 0; i < monsterLength; i++)
			{
				if (monster[i].isMissile)
				{
					continue;
				}
				if (monster[i].x < 0)
				{
					//モンスターが左画面外
					isGameOver = true;
					break;
				}
				else if ((monster[i].isNGHit) && (monster[i].hp <= 0))
				{
					//当ててはいけない
					isGameOver = true;
					break;
				}
			}

			//矢倉破壊
			if ((yagura.enable) && (yagura.hp <= 0))
			{
				//yagura.enable = false;
				isGameOver = true;
				//背景再描画（矢倉消す）
//				redrawBackgroundYaguraBreak();
				Global.playKuzureru();
				Global.stopBGM();
			}
		}

		// ================
		// recieveCoopMsg : COOP
		// ================
		private function recieveCoopMsg(clientID:String, rcvData:Array):void
		{
			//++++++++
			//setLogInfo("recieveCoopMsg");
			//++++++++

			var i:int, m:int;
			var yaguraHP:int;
			var _mouseX:int;
			var _mouseY:int;
			
			//同期方式を変更2014/07/07 frameCnt,remainTimeは同期しない。実時間にする。
			//frameCnt = (int)(rcvData.shift());
			//remainTime = (int)(rcvData.shift());
			int(rcvData.shift());
			int(rcvData.shift());
			
			yaguraHP = int(rcvData.shift());
			_mouseX = int(rcvData.shift());
			_mouseY = int(rcvData.shift());
			if (usvr.isHost() == false)
			{
				yagura.hp = yaguraHP;
			}
			for (i = 0; i < monsterLength; i++)
			{
				if (0 < monster[i].hp)
				{
					monster[i].hp -= int(rcvData[i]);
					if (monster[i].hp <= 0)
					{
						monster[i].vanishCnt = Global.FPS * 3;
						Global.playTodome();
						
						//本体がやられたので子もHP0にする
						for (m = 0; m < monsterLength; m++)
						{
							if (i == monster[m].bodyIdx)
							{
								monster[m].hp = 0;
								monster[m].vanishCnt = Global.FPS * 3;
							}
						}

						//本体破壊による変化
						for (m = 0; m < monsterLength; m++)
						{
							if (i == monster[m].hontaiIdx)
							{
								monster[m].isReflect = false;
							}
						}

					}
				}
			}

			for (i = 0; i < usvr.memberNo.length; i++)
			{
				if (usvr.memberNo[i] == clientID)
				{
					archer[i].baseR = -1 * Math.atan2(_mouseY - archer[i].shootY, _mouseX - archer[i].shootX);
trace("@@@@@@@@" + archer[i].baseR);
					break;
				}
			}

		}

		// ================
		// memberShoot
		// ================
		private function memberShoot
		(
		 	clientID:String,
			yumiX:int,
			yumiY:int,
			baseR:Number,
			nakamaPower:Number,
			maxCnt:int,
			seed:int,
			baratsuki:Number,
			nakamaAllPower:Number,
			penetrateCnt:int,
			_wakaKind:int,
			_maxPower:Number,
			_wazaKyokaKind:int
		):void
		{
			//++++++++
			//setLogInfo("memberShoot");
			//++++++++
			
			//--------
			if (waitGamen.visible)
			{
				//置いて行かれた？
				if (frameCnt % Global.FPS == 0)
				{
					new TextLogConnect().connect("@" + Global.username + ":" + usvr.isRoomFull() + "_" + usvr.isClose());
					//部屋情報更新してみる
					usvr.updateRoomAttributes(usvr.room.getRoomID());
				}
			}
			//--------

			trace("$$$memberShoot");

			/*
			var i:int;
			var ii:int;
			var a:int;
			var cnt:int = 0;
			var v0:Number = 0.0;
			var r:Number = 0.0;
			*/
			var i:int, ii:int, a:int, cnt:int = 0, v0:Number = 0.0, r:Number = 0.0;
			//var _maxShootArrowCnt:int = maxCnt;
			//var arrowsLength:int = arrows.length;

			for (i = 0; i < usvr.memberNo.length; i++)
			{
				if (usvr.memberNo[i] == clientID)
				{
					archer[i].yumiR = Math.PI - baseR + Math.PI;
				}
			}

			//for (ii = startArrowIdx; ii < arrows.length * 2; ii++)
			for (ii = startArrowIdx; ii < arrowsLength * 2; ii++)
			{
				//%計算は重い
				//i = ii % arrows.length;
				i = ii - arrowsLength * ((ii / arrowsLength) >> 0);

				if (arrows[i].status == Arrow.STATUS_STOP)
				{
					//--------射出--------
					v0 = Arrow.getV0Power(nakamaPower, cnt, seed, baratsuki);
					r = Arrow.getV0Radian(baseR, cnt, seed, baratsuki);

					arrows[i].v0 = v0;
					arrows[i].baseR = baseR;
					arrows[i].baratsuki = baratsuki;

					arrows[i].wazaKind = 0;

					arrows[i].damage = 0;
					
					arrows[i].x = yumiX;
					arrows[i].y = yumiY;
					for (a = 0; a < Arrow.routeCnt; a++ )
					{
						arrows[i].routeX[a] = -32;
						arrows[i].routeY[a] = -32;
					}

					arrows[i].hitIdx = -1;
					arrows[i].penetrateCnt = 0;
					arrows[i].penetrateHitIdx = -1;
					if (cnt < penetrateCnt)
					{
						arrows[i].penetrateCnt = 1;
					}
					arrows[i].isWazaTame = false;
					
					//--------
					//技（バババッ）
					if (nakamaAllPower == 2 * _maxPower)
					{
						if (_wakaKind == Item.KIND_IDX_WAZA_BABABA)
						{
							arrows[i].wazaKind = _wakaKind;
							arrows[i].wazaKyokaKind = _wazaKyokaKind;
							//_maxShootArrowCnt = 2 * maxCnt;	//矢数は送信データにあるので2倍しない
							r = baseR - Math.PI / 2 + Math.PI * 2 / 6 + (Math.PI * 1 / 3) / maxCnt * cnt;
							trace("バババッ");
						}
						else if (_wakaKind == Item.KIND_IDX_WAZA_HANABI)
						{
							arrows[i].wazaKind = _wakaKind;
							arrows[i].wazaKyokaKind = _wazaKyokaKind;
							if (_wazaKyokaKind == Item.KIND_IDX_KYOKA_HANABI)
							{
								//花火強化
								maxCnt = 1;
								arrows[i].hanabiNo = 0;
							}
							else if (wazaKyokaKind == Item.KIND_IDX_KYOKA_HANABI2)
							{
								//花火強化→火矢
								maxCnt = 1;
								arrows[i].hanabiNo = 0;
							}
							else
							{
								//通常花火
								//arrows[i].wazaKind = _wakaKind;
								arrows[i].hanabiNo = cnt;
								arrows[i].hanabiMaxNo = maxCnt;
							}
						}
						else if (_wakaKind == Item.KIND_IDX_WAZA_SOU)
						{
							//送
							arrows[i].x = 640 - 32;
							arrows[i].y = 32;
							v0 = -1 * v0;
						}
					}
					//--------

					/*
					arrows[i].x = yumiX;
					arrows[i].y = yumiY;
					for (a = 0; a < Arrow.routeCnt; a++ )
					{
						arrows[i].routeX[a] = -32;
						arrows[i].routeY[a] = -32;
					}

					arrows[i].hitIdx = -1;
					arrows[i].penetrateCnt = 0;
					arrows[i].penetrateHitIdx = -1;
					if (cnt < penetrateCnt)
					{
						arrows[i].penetrateCnt = 1;
					}
					*/
					
					arrows[i].vx = v0 * Math.cos(r);
					arrows[i].vy = -1 * v0 * Math.sin(r);
					arrows[i].r = Math.atan2(arrows[i].vy, arrows[i].vx) + Math.PI / 2;
					//後ろから出てるので１フレーム進める
					arrows[i].x += arrows[i].vx;
					arrows[i].y += arrows[i].vy;
					arrows[i].moveCount = 0;
					arrows[i].isSelf = false;
					arrows[i].status = Arrow.STATUS_MOVE;
					arrows[i].shootWait = cnt % 4;

					//--------
					//技：連
					if (nakamaAllPower == 2 * _maxPower)
					{
						if (_wakaKind == Item.KIND_IDX_WAZA_REN)
						{
							arrows[i].wazaKind = _wakaKind;
							arrows[i].shootWait = cnt * 0.5;
							arrows[i].clientID = clientID;
						}
					}
					//--------

					cnt++;
				}
				
				if (maxCnt <= cnt)
				{
					startArrowIdx = i + 1;
					break;
				}
			}

			Global.playShu();
		}
		//----------------

		//----------------
		// setErrorInfo
		// エラーログ用
		//----------------
		private static var logInfo:Vector.<String> = new Vector.<String>(32);
		private static var nowLogInfoIdx:int = 0;
		private static var logInfoCnt:int = 0;
		/*
		public static function setLogInfo(inf:String):void
		{
			try
			{
				logInfo[nowLogInfoIdx] = "[" + logInfoCnt + "]" + inf;
				nowLogInfoIdx = (nowLogInfoIdx + 1) % logInfo.length;
			}
			catch (e:Error)
			{
				logInfo[nowLogInfoIdx] = "setErrorInfoでエラー\n";
			}
			logInfoCnt++;
		}
		*/
		private static var isWriteLog:Boolean = false;
		public static function writeLog(errorStr:String):void
		{
			var i:int;
			var log:String = "\n" + Global.username + "\n" + errorStr + "\n";
			
			if (isWriteLog)
			{
				//ログ書くのは１回きり
				return;
			}
			isWriteLog = true;
			
			for (i = 0; i < logInfo.length; i++ )
			{
				log += logInfo[i] + "\n";
			}
			new TextLogConnect().connect(log);
		}
	}
}