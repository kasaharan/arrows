package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import net.user1.reactor.Client;
	import flash.utils.Dictionary;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import net.user1.reactor.IClient;
	import net.user1.reactor.filters.AttributeComparison;
	import net.user1.reactor.filters.AttributeFilter;
	import net.user1.reactor.filters.CompareType;
	import flash.filters.DropShadowFilter;
	
	public class ChatGamen extends Sprite
	{
		private var imgChar:BitmapData = new ImageChar();
		private var imgTorii:BitmapData = new ImageTorii();
		private var imgJinjya:BitmapData = new ImageJinjya();
		private var imgOmikuji:BitmapData = new ImageOmikuji();
		private var imgOmikujiKyo:BitmapData = new ImageOmikujiKyo();
		private var bmp00:Bitmap = new Bitmap(new BitmapData(320, 240)); //
		//private var bmp01:Bitmap = new Bitmap(new BitmapData(80, 64)); //鳥居
		private var bmpTxt:Bitmap = new Bitmap(new BitmapData(640, 480));
		private var bmp02:Bitmap = new Bitmap(new BitmapData(320, 240)); //背景
		private var rect:Rectangle = new Rectangle(16, 0, 16, 16);
		private var point:Point = new Point(0, 0);
		private var mc:MovieClip;
		
		private var key:KeyStatus = new KeyStatus();
		//private var nameTf:Vector.<TextField> = new Vector.<TextField>;
		public var selfClientID:String = "";
		//private var char:Point = new Point(0,0);
		//private var nameTf:Dictionary = new Dictionary();
		private var nameTfBmp:Dictionary = new Dictionary();
		private var charXY:Dictionary = new Dictionary();
		private var charDir:Dictionary = new Dictionary();
		private var charNo:Dictionary = new Dictionary();
		private var charOmikuji:Dictionary = new Dictionary();
		//private var isChange:Boolean = false;
		private var isChange:Boolean = true;
		private var isSend:Boolean = false;
		
		private var chatRect:Vector.<Rectangle> = new Vector.<Rectangle>;
		private var chatColor:Vector.<int> = Vector.<int>([0xffdddd, 0xddffdd, 0xddddff, 0xffffdd]);
		private var charText:Vector.<String> = Vector.<String>(["", ""]);
		
		private var omikujiRect:Rectangle = new Rectangle(48, 16, 32, 16);
		private var mixRect:Rectangle = new Rectangle(0, 0, 20, 16);
		private var yumishiRect:Rectangle = new Rectangle(0, 0, 32, 16);
		private var inariRect:Rectangle = new Rectangle(16, 16, 16, 16);
		private var inariQRect:Rectangle = new Rectangle(288, 160, 16, 16);
		
		private var omikujiConfirm:ConfirmGamen;
		
		private var frameCnt:int = 0;
		
		private var mt:RandomMT = new RandomMT();
		
		private var comparison:Vector.<AttributeComparison> = Vector.<AttributeComparison>([new AttributeComparison("arrows.team", "0", CompareType.EQUAL), new AttributeComparison("arrows.team", "1", CompareType.EQUAL)
			//,new AttributeComparison("arrows.team", "2", CompareType.EQUAL)
			//,new AttributeComparison("arrows.team", "3", CompareType.EQUAL)
			]);
		private var filter:Vector.<AttributeFilter> = Vector.<AttributeFilter>([new AttributeFilter(), new AttributeFilter()
			//,new AttributeFilter()
			//,new AttributeFilter()
			]);
		private var chatRoomNo:int = 0;
		
		private var mapData:Vector.<int> = Vector.<int>([3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3,]);
		
		private var shopGamen:ShopGamen;
		private var mixGamen:MixGamen;
		private var yumishiGamen:YumishiGamen;
		private var resetPwdGamen:ResetPwdGamen;
		private var questGamen:QuestGamen;
		
		private var chatOutTxtRect:Rectangle = new Rectangle();
		private var chatInTxtRect:Rectangle = new Rectangle();
		
		public function ChatGamen(_mc:MovieClip, clickClose:Function)
		{
			var i:int;
			var x:int, y:int;
			
			//--------
			chatRect[0] = new Rectangle(20, 88, 80, 32);
			chatRect[1] = new Rectangle(220,88, 80, 32);
			
			for (i = 0; i < filter.length; i++)
			{
				filter[i].addComparison(comparison[i]);
			}
			
			//背景描画--------
			addChild(bmp02);
			bmp02.scaleX = 2.0;
			bmp02.scaleY = 2.0;
			
			bmp02.bitmapData.fillRect(bmp02.bitmapData.rect, 0xff999999);
			
			for (y = 0; y < 15; y++)
			{
				for (x = 0; x < 20; x++)
				{
					i = y * 20 + x;
					rect.x = 4 * 16;
					rect.y = mapData[i] * 16;
					point.x = x * 16;
					point.y = y * 16;
					bmp02.bitmapData.copyPixels(imgChar, rect, point);
				}
			}
			
			var areaColor:Vector.<int> = Vector.<int>([0xffff7f7f, 0xff7fff7f, 0xff7f7fff, 0xffffff7f]);
			
			for (i = 0; i < chatRect.length; i++)
			{
				rect.x = chatRect[i].x;
				rect.y = chatRect[i].y;
				rect.width = 1;
				rect.height = chatRect[i].height;
				bmp02.bitmapData.fillRect(rect, areaColor[i]);
				rect.x += chatRect[i].width;
				bmp02.bitmapData.fillRect(rect, areaColor[i]);
				rect.x = chatRect[i].x;
				rect.height = 1;
				rect.width = chatRect[i].width;
				bmp02.bitmapData.fillRect(rect, areaColor[i]);
				rect.y += chatRect[i].height - 1;
				bmp02.bitmapData.fillRect(rect, areaColor[i]);
			}
			
			addChild(bmp00);
			bmp00.scaleX = 2.0;
			bmp00.scaleY = 2.0;
			bmp00.bitmapData.fillRect(bmp00.bitmapData.rect, 0xff000000);
			//bmp00.alpha = 0.5;

			addChild(bmpTxt);
			bmpTxt.bitmapData.fillRect(bmpTxt.bitmapData.rect, 0x00000000);
			
			mc = _mc;
			addChild(mc);
			
			addSpriteBtn(mc.close_txt, clickClose);
			
			//--------			
			mc.out_txt.visible = false;
			mc.in_txt.visible = false;
			mc.txt_scroll.visible = false;
			
			mc.out_txt.text = "";
			
			mc.close_txt.visible = false;
			
			//--------おみくじを引く
			omikujiConfirm = new ConfirmGamen(new ConfirmMC(), clickYesOmikuji);
			addChild(omikujiConfirm);
			omikujiConfirm.visible = false;
			omikujiConfirm.setYesText("[Y]はい");
			omikujiConfirm.setNoText("[N]いいえ");
			omikujiConfirm.setMessage("\nおみくじを引きますか？");
			
			//--------購入画面
			shopGamen = new ShopGamen(new ShopMC(), clickCloseShop);
			addChild(shopGamen);
			shopGamen.visible = false;
			function clickCloseShop():void
			{
				shopGamen.visible = false;
			}
			
			//--------
			//勾玉合成画面
			mixGamen = new MixGamen(new MixGamenMC());
			mixGamen.visible = false;
			//flashStage.addChild(mixGamen);
			addChild(mixGamen);
			Global.mixGamen = mixGamen;

			//--------
			//弓師画面
			//yumishiGamen = new YumishiGamen(new YumishiGamenMC(), new MixGamenMC());
			yumishiGamen = new YumishiGamen();
			yumishiGamen.visible = false;
			//flashStage.addChild(mixGamen);
			addChild(yumishiGamen);
			Global.yumishiGamen = yumishiGamen;

			//--------
			resetPwdGamen = new ResetPwdGamen(new ResetPwdMC());
			resetPwdGamen.visible = false;
			addChild(resetPwdGamen);
			
			//--------
			questGamen = new QuestGamen(new QuestMC());
			questGamen.visible = false;
			addChild(questGamen);
			
			//--------
			chatOutTxtRect.x = mc.out_txt.x * 0.5;
			chatOutTxtRect.y = mc.out_txt.y * 0.5;
			chatOutTxtRect.width = mc.out_txt.width * 0.5;
			chatOutTxtRect.height = mc.out_txt.height * 0.5;
			
			chatInTxtRect.x = mc.in_txt.x * 0.5;
			chatInTxtRect.y = mc.in_txt.y * 0.5;
			chatInTxtRect.width = mc.in_txt.width * 0.5;
			chatInTxtRect.height = mc.in_txt.height * 0.5;
		}
		
		private function addSpriteBtn(tf:TextField, f:Function):void
		{
			tf.mouseEnabled = false;
			
			var btn:Sprite = new Sprite();
			btn.buttonMode = true;
			btn.addChild(tf);
			mc.addChild(btn);
			
			tf.borderColor = 0x9977bb;
			tf.textColor = 0xffffff;
			tf.backgroundColor = Global.BUTTON_NORMAL_COLOR; //0x664477;
			tf.mouseEnabled = false;
			
			btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void
				{
					tf.backgroundColor = Global.BUTTON_SELECT_COLOR;
				});
			btn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void
				{
					tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;
				});
			btn.addEventListener(MouseEvent.CLICK, f);
		}
		
		// ----------------
		// clickYesOmikuji
		// おみくじを引く
		// ----------------
		private function clickYesOmikuji(e:MouseEvent):void
		{
			var i:int;
			var d:Date = new Date();
			var tmp:Number = d.fullYear * 10000 + (d.month + 1) * 100 + d.date;
			for (i = 0; i < Global.username.length; i++)
			{
				tmp += Global.username.charCodeAt(i) + i;
			}
			mt.init_genrand(tmp);
			
			i = mt.getRandInt(5);
			
			if (i == 4)
			{
				//凶なら結ぶ
				Global.usvr.kyoMusubi();
			}
			
			Global.usvr.reactor.self().setAttribute("omikuji", "" + i);
			
			omikujiConfirm.visible = false;
		}
		
		private function toTopChatWin():void
		{
			this.setChildIndex(mc, this.numChildren - 1);
			mc.out_txt.visible = false;
			mc.in_txt.visible = false;
			mc.txt_scroll.visible = false;
		}
		
		// ----------------
		// init
		// ----------------
		public function init():void
		{
			this.addEventListener(Event.ENTER_FRAME, enterFrameListener);
			this.visible = true;
		}
		
		// ----------------
		// startChat
		// ----------------
		public function startChat():void
		{
			Game.flashStage.addEventListener(KeyboardEvent.KEY_DOWN, keydownListener);
			Game.flashStage.addEventListener(KeyboardEvent.KEY_UP, keyupListener);
			
			mc.in_txt.addEventListener(KeyboardEvent.KEY_DOWN, chatKeydownListener);
			
			Game.flashStage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			Game.flashStage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			frameCnt = 0;
			
			//--------
			//勾玉合成師は勾玉取得後
			if (0 < Global.itemTbl.getCount())
			{
				//画面内
				//mixRect.setTo(320 - 48, 16, 20, 16);
				mixRect.setTo(320 - 36, 16, 20, 16);
			}
			else
			{
				//画面外
				mixRect.setTo(1024, 16, 20, 16);
			}
			//--------
			
			//--------
			//弓師は勾玉取得後
			if (0 < Global.itemTbl.getCount())
			{
				//画面内
				//yumishiRect.setTo(320 - 112, 16, 32, 16);
				yumishiRect.setTo(320 - 96, 16, 32, 16);
			}
			else
			{
				//画面外
				yumishiRect.setTo(1024, 16, 32, 16);
			}
			//--------

			//--------
			//日刊クエストも勾玉取得後
			if (0 < Global.itemTbl.getCount())
			{
				//画面内
				inariQRect.setTo(288, 160, 16, 16);
			}
			else
			{
				//画面外
				inariQRect.setTo(1024, 16, 32, 16);
			}
			//--------

			this.visible = true;
		}
		
		// ----------------
		// stopChat
		// ----------------
		public function stopChat():void
		{
			Game.flashStage.removeEventListener(KeyboardEvent.KEY_DOWN, keydownListener);
			Game.flashStage.removeEventListener(KeyboardEvent.KEY_UP, keyupListener);
			
			mc.in_txt.removeEventListener(KeyboardEvent.KEY_DOWN, chatKeydownListener);
			
			Game.flashStage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			Game.flashStage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			bmp00.bitmapData.fillRect(bmp00.bitmapData.rect, 0x00000000);
			bmpTxt.bitmapData.fillRect(bmpTxt.bitmapData.rect, 0x00000000);
			
			shopGamen.visible = false;
		}
		
		// ----------------
		// finalize
		// ----------------
		public function finalize():void
		{
			stopChat();
			
			this.removeEventListener(Event.ENTER_FRAME, enterFrameListener);
			
			//Global.usvr.topRoom.removeMessageListener("TOPROOM", playerMessageListener);
			
			selfClientID = "";
			
			this.visible = false;
		}
		
		public function addMsgListener():void
		{
			Global.usvr.topRoom.addMessageListener("TOPROOM", playerMessageListener);
		}
		
		public function removeMsgListener():void
		{
			if (Global.usvr.isChatReady)
			{
				Global.usvr.topRoom.removeMessageListener("TOPROOM", playerMessageListener);
				selfClientID = "";
			}
		}
		
		// ----------------
		// playerMessageListener
		// ----------------
		private function playerMessageListener(fromClient:IClient, messageText:String):void
		{
			try
			{
				var cid:String = fromClient.getClientID();
				var rcvData:Array = messageText.split(",");
				var msgID:String = rcvData.shift();
				var username:String = Global.usvr.reactor.getClientManager().getClient(cid).getAttribute("username");
				trace(cid);
				if (msgID == "POS")
				{
					charXY[cid].x = rcvData.shift();
					charXY[cid].y = rcvData.shift();
					charDir[cid] = rcvData.shift();
				}
				else if (msgID == "MSG")
				{
					/*
					mc.out_txt.appendText(username + " > " + rcvData.shift() + "\n");
					mc.txt_scroll.update();
					mc.txt_scroll.scrollPosition = mc.txt_scroll.maxScrollPosition;
					*/
					var roomNo:int = rcvData.shift();
					charText[roomNo] += username + " > " + rcvData.shift() + "\n";
					mc.out_txt.text = charText[roomNo];
					mc.txt_scroll.update();
					mc.txt_scroll.scrollPosition = mc.txt_scroll.maxScrollPosition;
					
				}
			}
			catch (e:Error)
			{
			}
		}
		// ----------------
		// enterFrameListener
		// ----------------
		private var preXY:Point = new Point();
		private var moveVal:int = 2;// 3;// 2;
		private function enterFrameListener(e:Event):void
		{
/*
//fps24->16
if (frameCnt % 3 == 1)
{
	frameCnt++;
	return;
}
*/
			//if (Global.usvr.isReady)
			if (Global.usvr.isChatReady)
			{
				if (selfClientID == "")
				{
			//		Global.usvr.topRoom.addMessageListener("TOPROOM", playerMessageListener);
					
					selfClientID = Global.usvr.reactor.self().getClientID();
					//charXY[selfClientID] = new Point(Math.random() * (320-16), Math.random() * (240-16));
					//charXY[selfClientID] = new Point(Math.random() * (320-16), Math.random() * (40-16) + 200);
					charXY[selfClientID] = new Point(Math.random() * (320 - 16), 240 - 16);
					charDir[selfClientID] = 0;
					charNo[selfClientID] = 0; // int(Math.random() * 2);
					charOmikuji[selfClientID] = -1;
					
					Global.usvr.reactor.self().setAttribute("charNo", charNo[selfClientID]);
					Global.usvr.reactor.self().setAttribute("omikuji", charOmikuji[selfClientID]);
				}
			}
			else
			{
				mc.close_txt.visible = false;
				return;
			}
			
			//--------
			//閉じるボタン制御
			if (omikujiConfirm.visible
			|| shopGamen.visible
			|| mixGamen.visible
			|| resetPwdGamen.visible
			|| yumishiGamen.visible
			|| Global.selectGamen.visible
			|| questGamen.visible)
			{
				mc.close_txt.visible = false;
			}
			else
			{
				mc.close_txt.visible = true;
			}
			//--------
			
			preXY.setTo(charXY[selfClientID].x, charXY[selfClientID].y);
			
			//--------
			//ウインドウ表示中はマウス移動しない
			if (omikujiConfirm.visible
			|| shopGamen.visible
			|| mixGamen.visible
			|| resetPwdGamen.visible
			|| yumishiGamen.visible
			|| Global.selectGamen.visible
			|| questGamen.visible
			|| mc.close_txt.backgroundColor == Global.BUTTON_SELECT_COLOR)
			{
				//nop
			}
			else
			{
				//--------
				//チャットウインドウ上クリックは移動しない
				if ((mc.in_txt.visible) && (chatInTxtRect.containsPoint(mousePoint)))
				{
					isMouseDown = false;
				}
				if ((mc.out_txt.visible) && (chatOutTxtRect.containsPoint(mousePoint)))
				{
					isMouseDown = false;
				}
				//--------
				
				if (isMouseDown)
				{
					key.clear();
					
					if (12 < mousePoint.x - charXY[selfClientID].x)
					{
						charXY[selfClientID].x += moveVal;
						charDir[selfClientID] = 3;
						isChange = true;
					}
					else if (mousePoint.x - charXY[selfClientID].x <= 0)
					{
						charXY[selfClientID].x -= moveVal;
						charDir[selfClientID] = 2;
						isChange = true;
					}
					if (12 < mousePoint.y - charXY[selfClientID].y)
					{
						charXY[selfClientID].y += moveVal;
						charDir[selfClientID] = 1;
						isChange = true;
					}
					else if (mousePoint.y - charXY[selfClientID].y <= 0)
					{
						charXY[selfClientID].y -= moveVal;
						charDir[selfClientID] = 0;
						isChange = true;
					}
				}
			}
			//--------
			
			var i:int;
			
			if (Global.selectGamen.visible == false)
			{
				//preXY.setTo(charXY[selfClientID].x, charXY[selfClientID].y);
				
				if (key.up)
				{
					charXY[selfClientID].y -= moveVal;
					charDir[selfClientID] = 0;
					isChange = true;
				}
				if (key.down)
				{
					charXY[selfClientID].y += moveVal;
					charDir[selfClientID] = 1;
					isChange = true;
				}
				if (key.left)
				{
					charXY[selfClientID].x -= moveVal;
					charDir[selfClientID] = 2;
					isChange = true;
				}
				if (key.right)
				{
					charXY[selfClientID].x += moveVal;
					charDir[selfClientID] = 3;
					isChange = true;
				}
			}
			
			if ((charXY[selfClientID].x < 0) || (320 - 16 < charXY[selfClientID].x) || (charXY[selfClientID].y < 0) || (240 - 16 < charXY[selfClientID].y))
			{
				charXY[selfClientID].x = preXY.x;
				charXY[selfClientID].y = preXY.y;
				isChange = false;
			}
			
			if (charNo[selfClientID] != Global.userTbl.getData(0, "ITEMNO"))
			{
				charNo[selfClientID] = Global.userTbl.getData(0, "ITEMNO");
				Global.usvr.reactor.self().setAttribute("charNo", charNo[selfClientID]);
			}
			
			//チャットエリア切替判定
			for (i = 0; i < chatRect.length; i++)
			{
				//if (chatRect[i].containsPoint(charXY[selfClientID]))
				if (chatRect[i].contains(charXY[selfClientID].x + 8, charXY[selfClientID].y + 16))
				{
					chatRoomNo = i;
					break;
				}
			}
			if (i == chatRect.length)
			{
				mc.out_txt.visible = false;
				mc.in_txt.visible = false;
				mc.txt_scroll.visible = false;
				mc.out_txt.backgroundColor = 0xffffff;
				
				if (chatRoomNo != -1)
				{
					chatRoomNo = -1;
					Global.usvr.reactor.self().setAttribute("team", "-1", "arrows");
				}
			}
			else
			{
				if (mc.out_txt.backgroundColor != chatColor[chatRoomNo])
				{
					if (mc.out_txt.visible == false)
					{
						Global.usvr.reactor.self().setAttribute("team", "" + chatRoomNo, "arrows"); //この程度ならarrowsはいらないのかな
					}
					mc.out_txt.visible = true;
					mc.out_txt.text = charText[chatRoomNo];
					mc.in_txt.visible = true;
					mc.txt_scroll.visible = true;
					mc.out_txt.backgroundColor = chatColor[chatRoomNo];
					Game.flashStage.focus = mc.in_txt;
				}
			}
			
			//おみくじ当たり判定
			if (isChange)
			{
				//if (omikujiRect.contains(charXY[selfClientID].x, charXY[selfClientID].y))
				if (omikujiRect.contains(charXY[selfClientID].x + 4, charXY[selfClientID].y + 8))
				{
					if (charOmikuji[selfClientID] == -1)
					{
						omikujiConfirm.visible = true;
					}
					charXY[selfClientID].x = preXY.x;
					charXY[selfClientID].y = preXY.y;
					isChange = false;
				}
				else
				{
					omikujiConfirm.visible = false;
				}
			}
			if (omikujiConfirm.visible)
			{
				//IME.enabled = false;	//念のためCapabilities.hasIMEを通す
				Global.enabledIME(false);
				if (key.yes)
				{
					clickYesOmikuji(new MouseEvent(""));
					omikujiConfirm.visible = false;
					key.yes = false;
					key.no = false;
					//IME.enabled = true;
					Global.enabledIME(true);
				}
				else if (key.no)
				{
					omikujiConfirm.visible = false;
					key.yes = false;
					key.no = false;
					//IME.enabled = true;
					Global.enabledIME(true);
				}
			}
			
			//神社当たり判定
			if (isChange)
			{
				//rect.setTo((320 - 128) * 0.5, 0, 128, 64);
				rect.setTo((320 - 128) * 0.5 + 8, 8, 128 - 24, 52);
				if (rect.contains(charXY[selfClientID].x, charXY[selfClientID].y))
				{
					//酒呑童子クリア済でなければ表示しない
					if (Global.scenario.getStageIdx(Scenario.SHUTENDOUJI) <= Global.scenario.lastClearIndex)
					{
						if (shopGamen.visible == false)
						{
							shopGamen.show();
							isSend = true; //位置データ送信
						}
						this.setChildIndex(shopGamen, this.numChildren - 1);
					}
					charXY[selfClientID].x = preXY.x;
					charXY[selfClientID].y = preXY.y;
					isChange = false;
				}
				else
				{
					shopGamen.visible = false;
				}
			}
			//if (shopGamen.visible)
			//{
				/*
				mc.out_txt.visible = false;
				mc.in_txt.visible = false;
				mc.txt_scroll.visible = false;
				mc.out_txt.backgroundColor = 0xffffff;
				*/
				//this.setChildIndex(shopGamen, this.numChildren - 1);
			//}
			
			//勾玉合成師当たり判定
			if (isChange)
			{
				//if (mixRect.contains(charXY[selfClientID].x, charXY[selfClientID].y))
				if (mixRect.contains(charXY[selfClientID].x + 8, charXY[selfClientID].y + 8))
				{
					if (mixGamen.visible == false)
					{
						mixGamen.show();
						isSend = true; //位置データ送信
					}
					charXY[selfClientID].x = preXY.x;
					charXY[selfClientID].y = preXY.y;
					isChange = false;
					this.setChildIndex(mixGamen, this.numChildren - 1);
				}
				else
				{
					mixGamen.close();
				}
			}
			
			//弓師当たり判定
			if (isChange)
			{
				//if (yumishiRect.contains(charXY[selfClientID].x, charXY[selfClientID].y))
				if (yumishiRect.contains(charXY[selfClientID].x + 8, charXY[selfClientID].y + 8))
				{
					if ((yumishiGamen.visible == false) && (shopGamen.visible == false))
					{
						yumishiGamen.show();
						isSend = true; //位置データ送信
					}
					charXY[selfClientID].x = preXY.x;
					charXY[selfClientID].y = preXY.y;
					isChange = false;
					this.setChildIndex(yumishiGamen, this.numChildren - 1);
				}
				else
				{
					if (yumishiGamen.visible)
					{
						yumishiGamen.close();
					}
				}
			}
			
			//稲荷当たり判定
			if (isChange)
			{
				//if (inariRect.contains(charXY[selfClientID].x, charXY[selfClientID].y))
				if (inariRect.contains(charXY[selfClientID].x + 8, charXY[selfClientID].y + 8))
				{
					if (resetPwdGamen.visible == false)
					{
						resetPwdGamen.visible = true;
						isSend = true; //位置データ送信
					}

					//resetPwdGamen.visible = true;
					
					this.setChildIndex(resetPwdGamen, this.numChildren - 1);
					
					charXY[selfClientID].x = preXY.x;
					charXY[selfClientID].y = preXY.y;
					isChange = false;
				}
				else
				{
					resetPwdGamen.visible = false;
				}
			}
			
			//稲荷クエスト当たり判定
			if (isChange)
			{
				if (inariQRect.contains(charXY[selfClientID].x + 8, charXY[selfClientID].y + 8))
				{
					if (questGamen.visible == false)
					{
						questGamen.show();
						isSend = true; //位置データ送信
					}
					
					this.setChildIndex(questGamen, this.numChildren - 1);
					
					charXY[selfClientID].x = preXY.x;
					charXY[selfClientID].y = preXY.y;
					isChange = false;
				}
				else
				{
					questGamen.visible = false;
				}
			}

			//draw();
			//--------
			//ウィンドウ表示中は描画制限
			if (omikujiConfirm.visible
			|| shopGamen.visible
			|| mixGamen.visible
			|| resetPwdGamen.visible
			|| yumishiGamen.visible
			|| Global.selectGamen.visible
			|| Global.itemGamen.visible
			|| Global.yumiSettingGamen.visible
			|| Global.reportGamen.visible
			|| Global.makeGamen.visible
			|| questGamen.visible)
			{
				if ((frameCnt % (Global.FPS / 2)) == 0)
				{
					draw();
				}
			}
			else
			{
				draw();
			}
			//--------
			
			var sec:int = 2;// 1;
			//人数で送信周期を変える
			if ((frameCnt % Global.FPS) == 0)
			{
				try
				{
					var cnt:int = Global.usvr.getPlayerCnt();
					sec = Math.sqrt(cnt);
					sec = sec * 2;
				}
				catch (e:Error) { }
				
				//念のため
				if (sec <= 0)
				{
					sec = 10;
				}
			}
			
			if ((isChange) && (frameCnt % (Global.FPS * sec) == 0))
			{
				isChange = false;
				sendPosition();
			}

			if (isSend)
			{
				isSend = false;
				sendPosition();
			}
			
			//--------
			//チャット制御
			this.setChildIndex(mc, this.numChildren - 1);
			if (0 < msgWait)
			{
				msgWait--;
				mc.in_txt.backgroundColor = 0xcccccc;
			}
			else
			{
				if (mc.in_txt.visible)
				{
					mc.in_txt.backgroundColor = 0xffffff;
				}
			}
			//--------
			
			frameCnt++;
		}

		// ----------------
		// sendPosition
		// ----------------
		private function sendPosition():void
		{
			try
			{
				var sendData:String = "POS," + int(charXY[selfClientID].x) + "," + int(charXY[selfClientID].y) + "," + charDir[selfClientID];
				Global.usvr.topRoom.sendMessage("TOPROOM", false, null, sendData);
				isChange = false;
			}
			catch (e:Error)
			{
				//nop
			}
		}
		
		// ----------------
		// draw
		// ----------------
		private var testObj:Object = new Object();
		private var testArr:Array = new Array();
		private var clients:Array = new Array();
		private function draw():void
		{
			try
			{
				var i:int, k:int;
				var obj:Object
				var client:Client;
				//var clients:Array = Global.usvr.topRoom.getOccupants();
				if (frameCnt % Global.FPS == 0)
				{
					clients = Global.usvr.topRoom.getOccupants();
				}
				
				testArr = new Array();
				
				/*
				for (var obj:Object in nameTf)
				{
					nameTf[obj].visible = false;
				}
				*/
				/*
				for (obj in nameTfBmp)
				{
					nameTfBmp[obj].visible = false;
				}
				*/
				
				bmp00.bitmapData.lock();
				bmp00.bitmapData.fillRect(bmp00.bitmapData.rect, 0x00000000);
				bmpTxt.bitmapData.lock();
				bmpTxt.bitmapData.fillRect(bmpTxt.bitmapData.rect, 0x00000000);

				rect.width = 16;
				rect.height = 16;
				
				for (i = 0; i < clients.length; i++)
				{
					client = clients[i];
					
					var cid:String = client.getClientID();
					
					/*
					if (nameTf[key] == undefined)
					{
						nameTf[key] = new TextField();
						nameTf[key].text = client.getAttribute("username");
						nameTf[key].cacheAsBitmap = true;
						TextField(nameTf[key]).autoSize = TextFieldAutoSize.LEFT;
						TextField(nameTf[key]).textColor = 0x000000;
						
						TextField(nameTf[key]).filters = [new DropShadowFilter(1, 45, 0xffffff, 1.0, 0, 0, 10.0), new DropShadowFilter(1, 225, 0xffffff, 1.0, 0, 0, 10.0)];
						
						addChild(nameTf[key]);
					*/
					//if (nameTfBmp[key] == undefined)
					if (nameTfBmp.hasOwnProperty(cid) == false)
					{
						var tf:TextField = new TextField();
						tf.text = client.getAttribute("username");
						tf.autoSize = TextFieldAutoSize.LEFT;
						tf.textColor = 0x000000;
						tf.filters = [new DropShadowFilter(1, 45, 0xffffff, 1.0, 0, 0, 10.0), new DropShadowFilter(1, 225, 0xffffff, 1.0, 0, 0, 10.0)];
						tf.visible = false;

						//--------
						nameTfBmp[cid] = new Bitmap(new BitmapData(tf.width, tf.height, true, 0x00000000));
						Bitmap(nameTfBmp[cid]).bitmapData.draw(tf);
						//addChild(nameTfBmp[key]);
						//--------
						
						charDir[cid] = 0;
						charNo[cid] = client.getAttribute("charNo");
						charOmikuji[cid] = -1; //client.getAttribute("omikuji");
						
						if (cid == selfClientID)
						{
							//nop
						}
						else
						{
							charXY[cid] = new Point(Math.random() * (320 - 16), 240 - 16);
						}
					}
					/*
					nameTf[key].x = charXY[key].x * bmp00.scaleX - ((TextField)(nameTf[key]).width - 32) * 0.5;
					nameTf[key].y = charXY[key].y * bmp00.scaleY - 17;
					nameTf[key].visible = true;
					*/
					Bitmap(nameTfBmp[cid]).x = charXY[cid].x * bmp00.scaleX - (Bitmap(nameTfBmp[cid]).width - 32) * 0.5;
					Bitmap(nameTfBmp[cid]).y = charXY[cid].y * bmp00.scaleY - 17;
					//Bitmap(nameTfBmp[key]).visible = true;
					
					charNo[cid] = client.getAttribute("charNo");
					if (client.getAttribute("omikuji") != null)
					{
						charOmikuji[cid] = client.getAttribute("omikuji");
					}
					else
					{
						charOmikuji[cid] = -1;
					}
					
					setObjY(cid, charXY[cid].y + (16)); //(高さ) y座標下のラインでzソートする;
				}
				
				//--------
				/*
				for (obj in nameTfBmp)
				{
					if (nameTfBmp[obj].visible == false)
					{
						Bitmap(nameTfBmp[obj]).bitmapData.dispose();
						delete nameTfBmp[obj];
					}
				}
				*/
				//--------
				
				//鳥居
				setObjY("torii", (240 - 48 - 32) + (64)); //(高さ) y座標下のラインでzソートする;
				
				//神社
				setObjY("jinjya", 0 + (64)); //(高さ) y座標下のラインでzソートする;
				
				//おみくじ
				setObjY("omikuji", 16 + (16)); //(高さ) y座標下のラインでzソートする;
				
				//勾玉合成師
				setObjY("mix", 16 + (16)); //(高さ) y座標下のラインでzソートする;

				//弓師
				setObjY("yumishi", 16 + (16)); //(高さ) y座標下のラインでzソートする;
				
				//お稲荷さま
				setObjY("inari", 16 + (16)); //(高さ) y座標下のラインでzソートする;

				//お稲荷さまクエスト
				setObjY("inariQ", inariQRect.y + (16)); //(高さ) y座標下のラインでzソートする;
				
				testArr.sortOn("y", Array.NUMERIC);
				
				for (i = 0; i < testArr.length; i++)
				{
					cid = testArr[i].key;
	
					//鳥居
					if (cid == "torii")
					{
						point.x = (320 - 80) * 0.5;
						point.y = (240 - 48 - 32);
						rect.setTo(0, 0, 80, 64);
						
						bmp00.bitmapData.copyPixels(imgTorii, rect, point, null, null, true);
					}
					else if (cid == "jinjya")
					{
						point.x = (320 - 128) * 0.5;
						point.y = 0;
						rect.setTo(0, 0, 128, 64);
						
						bmp00.bitmapData.copyPixels(imgJinjya, rect, point, null, null, true);
					}
					else if (cid == "omikuji")
					{
						point.x = 48; //(320 - 128) * 0.5;
						point.y = 16;
						rect.setTo(0, 0, 32, 16);
						
						bmp00.bitmapData.copyPixels(imgOmikuji, rect, point, null, null, true);
						
						//--------おみくじ結び
						var kyoCount:int = Global.usvr.getKyoCount();
						for (k = 1; k <= 5; k++)
						{
							if (k * 5 <= kyoCount)
							{
								point.y = 16 + 3 * (k - 1);
								rect.setTo(0, 3 * 5, 16, 3);
								bmp00.bitmapData.copyPixels(imgOmikujiKyo, rect, point, null, null, true);
							}
							else
							{
								point.y = 16 + 3 * (k - 1);
								rect.setTo(0, 3 * (kyoCount % 5), 16, 3);
								bmp00.bitmapData.copyPixels(imgOmikujiKyo, rect, point, null, null, true);
								break;
							}
						}
					}
					else if (cid == "mix")
					{
						point.x = mixRect.x;// + mixRect.width * 0.5;
						point.y = mixRect.y;
						rect.setTo(80, 80, 20, 16);
						rect.x += int((frameCnt % Global.FPS) / Global.halfFPS) * 20;
						
						bmp00.bitmapData.copyPixels(imgChar, rect, point, null, null, true);
					}
					else if (cid == "yumishi")
					{
						point.x = yumishiRect.x;// + yumishiRect.width * 0.5;
						point.y = yumishiRect.y;
						rect.setTo(80, 96, 32, 16);
						rect.y += int((frameCnt % Global.FPS) / Global.halfFPS) * 16;
						
						bmp00.bitmapData.copyPixels(imgChar, rect, point, null, null, true);
					}
					else if (cid == "inari")
					{
						point.x = inariRect.x;// + inariRect.width * 0.5;
						point.y = inariRect.y;
						rect.setTo(80, 128, 16, 16);
						bmp00.bitmapData.copyPixels(imgChar, rect, point, null, null, true);
					}
					else if (cid == "inariQ")
					{
						point.x = inariQRect.x;
						point.y = inariQRect.y;
						rect.setTo(96, 128, 16, 16);
						bmp00.bitmapData.copyPixels(imgChar, rect, point, null, null, true);
					}
					else
					{
						point.x = charXY[cid].x;
						point.y = charXY[cid].y;
						
						//--------
						rect.x = 16 * charDir[cid];
						rect.y = int((frameCnt % Global.FPS) / (Global.FPS * 0.5)) * 16;
						rect.y += charNo[cid] * 32;
						rect.width = 16;
						rect.height = 16;
						
						bmp00.bitmapData.copyPixels(imgChar, rect, point, null, null, true);
						
						if (0 <= charOmikuji[cid])
						{
							rect.x = 5 * 16;
							rect.y = charOmikuji[cid] * 16;
							bmp00.bitmapData.copyPixels(imgChar, rect, point, null, null, true);
						}
						
						//--------
						point.x = Bitmap(nameTfBmp[cid]).x;
						point.y = Bitmap(nameTfBmp[cid]).y;
						bmpTxt.bitmapData.copyPixels(Bitmap(nameTfBmp[cid]).bitmapData, Bitmap(nameTfBmp[cid]).bitmapData.rect, point, null, null, true);
						
					}
				}
				
				bmp00.bitmapData.unlock();
				bmpTxt.bitmapData.unlock();
			}
			catch (e:Error)
			{
				trace(e);
			}
		}
		
		private function setObjY(key:String, y:int):void
		{
			if (testObj.hasOwnProperty(key) == false)
			{
				testObj[key] = new Object();
				testObj[key].key = key;
			}
			testObj[key].y = y;
			testArr.push(testObj[key]);
		}
		
		// ----------------
		// sendChat
		// ----------------
		private var lastMsg:String = "";
		private var msgWait:int = 0;
		
		private function sendChat():void
		{
			var msg:String = Global.trim(mc.in_txt.text);
			
			//連続入力防止
			if (0 < msgWait)
			{
				return;
			}
			
			//空メッセージは無効
			if (msg.length <= 0)
			{
				mc.in_txt.text = "";
				return;
			}
			
			//同じメッセージは無効
			if (msg == lastMsg)
			{
				mc.in_txt.text = "";
				return;
			}
			lastMsg = msg;
			
			//制御文字は無効
			if (Global.existCtrlMoji(msg))
			{
				return;
			}
			
			//ユニコード制御文字は無効
			if (Global.existArashiMoji(msg))
			{
				return;
			}
			
			//
			if (chatRoomNo < 0)
			{
				return;
			}
			
			//--------
			var str:String = "MSG," + chatRoomNo + "," + mc.in_txt.text;
			
			Global.usvr.topRoom.sendMessage("TOPROOM", true, filter[chatRoomNo], str);
			
			mc.in_txt.text = "";
			
			msgWait = Global.FPS * 3;
		}
		
		// ----------------
		// keydownListener
		// ----------------
		private function keydownListener(e:KeyboardEvent):void
		{
			//trace("keydownListener");
			if (e.keyCode == Keyboard.UP)
			{
				key.up = true;
			}
			if (e.keyCode == Keyboard.DOWN)
			{
				key.down = true;
			}
			if (e.keyCode == Keyboard.LEFT)
			{
				key.left = true;
			}
			if (e.keyCode == Keyboard.RIGHT)
			{
				key.right = true;
			}
			
			//--------
			if (e.keyCode == Keyboard.Y)
			{
				key.yes = true;
			}
			if (e.keyCode == Keyboard.N)
			{
				key.no = true;
			}
		}
		
		// ----------------
		// keyupListener
		// ----------------
		private function keyupListener(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.UP)
			{
				key.up = false;
			}
			if (e.keyCode == Keyboard.DOWN)
			{
				key.down = false;
			}
			if (e.keyCode == Keyboard.LEFT)
			{
				key.left = false;
			}
			if (e.keyCode == Keyboard.RIGHT)
			{
				key.right = false;
			}
			
			//放置カウントリセット
			Game.flashStageFrameCnt = 0;
		}
		
		// ----------------
		// chatKeydownListener
		// ----------------
		private function chatKeydownListener(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				sendChat();
			}
		}
		
		// ----------------
		// mouseDown
		// ----------------
		private var isMouseDown:Boolean = false;
		private var mousePoint:Point = new Point();
		private function mouseDown(e:MouseEvent):void 
		{
			/*
			var cid:String = Global.usvr.reactor.self().getClientID();
			var saW:int = Game.flashStage.mouseX * 0.5 - charXY[cid].x;
			var saH:int = Game.flashStage.mouseY * 0.5 - charXY[cid].y;
			
			if (16 < saW)
			{
				key.right = true;
			}
			else if (saW < -16)
			{
				key.left = true;
			}
			if (16 < saH)
			{
				key.down = true;
			}
			else if (saH < -16)
			{
				key.up = true;
			}
			*/
			isMouseDown = true;
			mousePoint.x = Game.flashStage.mouseX * 0.5;
			mousePoint.y = Game.flashStage.mouseY * 0.5;
		}
		// ----------------
		// mouseUp
		// ----------------
		private function mouseUp(e:MouseEvent):void 
		{
			isMouseDown = false;
		}

	}

}