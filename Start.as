package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	
	import starling.core.Starling;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import starling.events.ResizeEvent;
	import flash.geom.Rectangle;
	
	[SWF(width="640",height="480",frameRate="24",backgroundColor="#000000")]
	
	public class Start extends Sprite
	{
		public static var mStarling:Starling;
		
		//Globalに置くとエラーなんだがなぜ？初期化が間に合ってないっぽいエラーになる
		//→starlingの設定が全て終わるまでやらないほうがよさげ。
		//終わらないうちにログ出力書いたら動かなかった。20140918
		public static var flashVars:Object;
		
		//private var csa:CheckSingleApplication = new CheckSingleApplication("arrows");
		private var csa:CheckSingleApplication;
		
		public function Start():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

stage.align = StageAlign.TOP_LEFT;
stage.scaleMode = StageScaleMode.SHOW_ALL;

			Game.flashStage = stage;
			Game.flashStage.stageFocusRect = false; //矩形表示ＯＦＦだけでなくタブキーのフォーカス移動が無効になる

			//-------- Game が new される前に必要
			Connect.swfUrl = loaderInfo.url;
			UnionServer2.swfUrl = loaderInfo.url;
			
			//20140723人多すぎ対策(32人ずつ部屋分ける)
			flashVars = loaderInfo.parameters;
			//--------
			if (Connect.isLocalSite() == false)
			{
				/*
				   //コンテキストメニューのプロパティをすべて false にする
				   var menu_cm:ContextMenu = new ContextMenu();
				   menu_cm.hideBuiltInItems();
				   this.contextMenu = menu_cm;
				 */
				//２重起動防止
				//無名関数内だと次のフレームに移動すると解放されてしまうので
				//→ローカルコネクションがなくなるため２窓が可能
				//var csa:CheckSingleApplication = new CheckSingleApplication("arrows");
				//接続が残るのでここでnewしてみる20141113
				csa = new CheckSingleApplication("arrows"); 
				if (csa.isExistOther)
				{
					var tf:TextField = new TextField();
					tf.textColor = 0xffffff;
					tf.width = 640;
					tf.height = 480;
					tf.text = "複数のウインドウでゲームを起動できません。\n他のウィンドウを閉じてください。";
					Game.flashStage.addChild(tf);
					return;
				}
			}
			//--------

			//****************
			// These settings are recommended to avoid problems with touch handling
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//Fatal Error the application lost the device context 対策？
			Starling.handleLostContext = true;
			
			// Create a Starling instance that will run the "Game" class
			//mStarling = new Starling(Game, stage);
			//TEST
			//mStarling = new Starling(Game, stage, null, null, Context3DRenderMode.SOFTWARE);
			//最初からブラウザを100%以外の表示率にしておくと拡大縮小がうまくいかない。まず強制的に100%のサイズでnewする
			mStarling = new Starling(Game, stage, new Rectangle(0, 0, 640, 480));
			mStarling.start();
			
			//mStarling.showStats = true;
			if (Connect.isLocalSite())
			{
				//mStarling.showStats = true;
			}
			Game.mStarling = mStarling;
			//****************
			
			/*
			   //--------
			   Connect.swfUrl = loaderInfo.url;
			   UnionServer2.swfUrl = loaderInfo.url;
			
			   //20140723人多すぎ対策(32人ずつ部屋分ける)
			   flashVars = loaderInfo.parameters;
			 */
			
			//--------
			// コンテキストメニューオブジェクトを作成
			var context_menu:ContextMenu = new ContextMenu();
			// ビルトインメニュー設定用オブジェクトを取得
			var builtin_items:ContextMenuBuiltInItems = context_menu.builtInItems;
			// 各アイテムの可視表示の設定
			builtin_items.forwardAndBack = false; // 先送り、戻る
			builtin_items.loop = false; // ループ再生
			builtin_items.play = false; // 再生
			builtin_items.print = false; // プリント
			builtin_items.quality = true; // 画質
			builtin_items.rewind = false; // 巻き戻し
			builtin_items.zoom = false; // 拡大
			this.contextMenu = context_menu;
			//--------
			
			//--------
			mStarling.stage.addEventListener(ResizeEvent.RESIZE, onResize);
			////初期表示から拡大縮小していた場合の処理(未確認)
			//onResize(new ResizeEvent("", stage.stageWidth, stage.stageHeight));
			Starling.current.nativeStage.focus = Starling.current.nativeStage;
			//--------
			
			/*
			   //JSON TEST--------
			   var obj:Object = JSON.parse("[[\"aaa\",\"bbb\",\"ccc\"],[\"\",\"\",\"\"],[\"\",\"\",\"\"]]");
			   for (var a:Object in obj)
			   {
			   trace(a + ":" + obj[a]);
			   for (var b:Object in obj[a])
			   {
			   trace("#" + b + ":" + obj[a][b]);
			   }
			   }
			 */
			
			//********
			// グローバルエラーのイベント登録
			if (Connect.isLocalSite() == false)
			{
				loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
			}
			// グローバルエラーハンドラー
			function onUncaughtError(e:UncaughtErrorEvent):void
			{
				//エラーメッセージが表示されないようにする
				e.preventDefault();
				
				//--------
				var errorID:int = 0;
				var type:String = "";
				var message:String = "";
				var location:String = "";
				
				if (e.error is Error)
				{ // Errorを捕捉した場合
					var error:Error = e.error as Error;
					errorID = error.errorID;
					type = error.name;
					message = error.message;
					location = error.getStackTrace();
					
					Game.writeLog("errorID:" + errorID + "\ntype:" + type + "\nmessage:" + message + "\nlocation:" + location + "\ntext:" + e.text);
				}
				else if (e.error is ErrorEvent)
				{ // ErrorEventを捕捉した場合
					var event:ErrorEvent = e.error as ErrorEvent;
					errorID = event.errorID;
					type = event.type;
					message = event.text;
					
					Game.writeLog("errorID:" + errorID + "\ntype:" + type + "\nmessage:" + message + "\ntext" + e.text);
				}
				else
				{
					Game.writeLog(e.text);
				}
				//--------
			}
			//TEST
			//throw new Error();
			//********
		}

		
		private function onResize(event:ResizeEvent):void
		{
			if (640 < event.width)
			{
				return;
			}
			
			Starling.current.viewPort = new Rectangle(0, 0, event.width, event.height);
			stage.stageWidth = event.width;
			stage.stageHeight = event.height;

			Starling.current.nativeStage.focus = Starling.current.nativeStage;
		}
		
	}

}