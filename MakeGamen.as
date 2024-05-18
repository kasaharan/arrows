package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import mx.utils.StringUtil;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class MakeGamen extends Sprite
	{
		public var mc:MovieClip;
		//private var yomaBmp:Bitmap = new Bitmap(new BitmapData(1, 1, true, 0x00000000));
		private var yomaBmpForZoom:Bitmap = new Bitmap();
		private var yomaBmp:Vector.<Bitmap> = new Vector.<Bitmap>;
		//private var yomaRect:Rectangle = new Rectangle();
		private var patternNo:int = 0;
		//private var yomaScale:int = 1;
		private var closeFunc:Function;
		private var clickTeisatsuFunc:Function;
		private var bmpVectorOrg:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>;
		private var palleteData:Vector.<Dictionary> = new Vector.<Dictionary>;
		
		private var onibiCircle:Sprite = new Sprite();
		
		private var textMngData:String = "";
		private var textImgData:Vector.<String> = new Vector.<String>;
		
		private var confirmGamen:ConfirmGamen;
		
		public var report:Report = new Report();
		
		public function MakeGamen(_mc:MovieClip, _clickTeisatsuFunc:Function, _closeFunc:Function)
		{
			var i:int;
			
			mc = _mc;
			addChild(mc);
			
			addSpriteBtn(mc.torikomi1_txt, clickTorikomi);
			addSpriteBtn(mc.torikomi2_txt, clickTorikomi);
			addSpriteBtn(mc.torikomi3_txt, clickTorikomi);
			//addSpriteBtn(mc.toukasyoku_txt, clickTokasyoku);
			addSpriteBtn(mc.decide_txt, clickDecide);
			addSpriteBtn(mc.zoom_txt, clickZoom);
			addSpriteBtn(mc.back_txt, clickBack);
			addSpriteBtn(mc.next_txt, clickNext);
			//addSpriteBtn(mc.help_txt, function(e:MouseEvent) { openNewWin("http://kasaharan.com/game/arrows/report_help.html") } );
			addSpriteBtn(mc.help_txt, function(e:MouseEvent):void
				{
					openHelp();
				});
			
			addSpriteBtn(mc.back_attack_txt, clickBackAttack);
			addSpriteBtn(mc.next_attack_txt, clickNextAttack);
			
			addSpriteBtn(mc.normal_txt, clickOnibiNormal);
			addSpriteBtn(mc.onibidan1_txt, clickTorikomi);
			addSpriteBtn(mc.onibidan2_txt, clickTorikomi);
			
			clickTeisatsuFunc = _clickTeisatsuFunc;
			addSpriteBtn(mc.teisatsu_txt, clickTeisatsu);
			
			closeFunc = _closeFunc;
			addSpriteBtn(mc.close_txt, clickClose);
			
			//--------
			/*
			   bmpVectorOrg[0] = new Vector.<uint>;
			   bmpVectorOrg[1] = new Vector.<uint>;
			   bmpVectorOrg[2] = new Vector.<uint>;
			
			   yomaBmp[0] = new Bitmap(new BitmapData(1, 1, true, 0x00000000));
			   yomaBmp[1] = new Bitmap(new BitmapData(1, 1, true, 0x00000000));
			   yomaBmp[2] = new Bitmap(new BitmapData(1, 1, true, 0x00000000));
			   mc.addChild(yomaBmp[0]);
			   mc.addChild(yomaBmp[1]);
			   mc.addChild(yomaBmp[2]);
			 */
			
			for (i = 0; i < 5; i++)
			{
				textImgData[i] = "";
				bmpVectorOrg[i] = new Vector.<uint>;
				yomaBmp[i] = new Bitmap(new BitmapData(1, 1, true, 0x00000000));
				palleteData[i] = new Dictionary();
				mc.addChild(yomaBmp[i]);
			}
			
			yomaBmp[0].x = mc.img1_mc.x + 1;
			yomaBmp[0].y = 0 + 1;
			
			yomaBmp[1].x = mc.img2_mc.x + 1;
			yomaBmp[1].y = 0 + 1;
			
			yomaBmp[2].x = mc.img3_mc.x + 1;
			yomaBmp[2].y = 0 + 1;
			
			//--------
			//鬼火弾
			yomaBmp[3].x = mc.img4_mc.x + 5;
			yomaBmp[3].y = mc.img4_mc.y + 5;
			yomaBmp[3].scaleX = yomaBmp[3].scaleY = 2;
			
			yomaBmp[4].x = mc.img5_mc.x + 5;
			yomaBmp[4].y = mc.img5_mc.y + 5;
			yomaBmp[4].scaleX = yomaBmp[4].scaleY = 2;
			//--------
			
			yomaBmpForZoom.x = mc.zoom_mc.x + 1;
			yomaBmpForZoom.y = mc.zoom_mc.y + 1;
			
			mc.addChild(yomaBmpForZoom);
			
			//--------
			//onibiCircle.graphics.beginFill(0x007fff);
			onibiCircle.graphics.lineStyle(2, 0x7fffffff);
			onibiCircle.graphics.drawCircle(0, 0, 8);
			mc.addChild(onibiCircle);
			onibiCircle.visible = false;
			//--------
			
			//yomaBmp[0].visible = true;
			//yomaBmp[1].visible = false;
			//yomaBmp[0].x = 0;
			//yomaBmp[1].x = 320;
			//yomaBmpForShow = yomaBmp[0];
			//mc.addChild(yomaBmpForShow);
			mc.addEventListener(MouseEvent.CLICK, clickBmp);
			
			//--------
			mc.title_txt.maxChars = 16;
			//mc.aikotoba_txt.restrict = "a-zA-Z0-9";
			mc.title_txt.borderColor = 0x9977bb;
			mc.title_txt.backgroundColor = Global.BUTTON_NORMAL_COLOR;
			mc.title_txt.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void
				{
					mc.msg_txt.text = "妖魔の名称を入力してください。";
				});
			
			//--------
			
			mc.stagetype_txt.border = true;
			mc.stagetype_txt.borderColor = 0x9977bb;
			mc.attacktype_txt.border = true;
			mc.attacktype_txt.borderColor = 0x9977bb;
			
			//確認ウインドウ
			confirmGamen = new ConfirmGamen(new ConfirmMC(), clickYes);
			addChild(confirmGamen);
			confirmGamen.visible = false;
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
					showExplain(tf);
				});
			btn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void
				{
					tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;
				});
			btn.addEventListener(MouseEvent.CLICK, f);
		}
		
		// ----------------
		// showExplain
		// ----------------
		private function showExplain(tf:TextField):void
		{
			var str:String = "";
			
			if (tf == mc.torikomi1_txt)
			{
				mc.msg_txt.text = "妖魔の画像[甲]を貼り付けます。画像サイズは縦横16x16～80x80ピクセル、画像に使用できる色は16色までです。画像[甲]をクリックすると背景色を決定できます。"
					//mc.msg_txt.text = "妖魔の画像[甲]を貼り付けます。画像の色数は１６色までです。\n画像を貼り付けたら画像をクリックして背景色を決定してください。";
			}
			else if (tf == mc.torikomi2_txt)
			{
				mc.msg_txt.text = "妖魔の画像[乙]を貼り付けます。画像のサイズはすべて同じサイズにしてください。";
			}
			else if (tf == mc.torikomi3_txt)
			{
				mc.msg_txt.text = "矢が当たる場所を分析した画像を貼り付けてください。赤色(#ff0000)は矢を反射する場所になります。";
			}
			else if (tf == mc.zoom_txt)
			{
				mc.msg_txt.text = "妖魔の大きさを決めてください。\n画像をクリックして鬼火発射位置を決定してください。";
			}
			else if (tf == mc.back_txt)
			{
				mc.msg_txt.text = "妖魔の出現パターンを選択してください。";
			}
			else if (tf == mc.next_txt)
			{
				mc.msg_txt.text = "妖魔の出現パターンを選択してください。";
			}
			else if (tf == mc.teisatsu_txt)
			{
				//mc.msg_txt.text = "報告書の妖魔の偵察に向かいます。１８秒の戦闘を行い退却します。";
				mc.msg_txt.text = "報告書の妖魔の偵察に向かいます。20秒の戦闘を行い退却します。";
			}
			else if (tf == mc.close_txt)
			{
				if (0 < Global.myReportTbl.getCount())
				{
					mc.msg_txt.text = "修正せずに閉じると変更内容が破棄されます。";
				}
				else
				{
					mc.msg_txt.text = "提出せずに閉じると作成内容が破棄されます。";
				}
			}
			else if (tf == mc.decide_txt)
			{
				//保留
				//mc.msg_txt.text = "報告書を提出します。提出後、３０分間は修正可能です。３０分を経過すると報告書が審査中となり修正が出来なくなります。";
				
				if (Global.isMake)
				{
					str = "報告書を提出します。";
					if (0 < Global.myReportTbl.getCount())
					{
						str = "報告書を修正します。";
					}
					mc.msg_txt.text = str + "ゲームやアニメに登場するキャラクターは著作権侵害に当たるので無効となります。また不適切な画像や品質の低いものも無効となります。";
				}
				else
				{
					mc.msg_txt.text = "報告書の受付は現在停止しています。";
				}
			}
			else if (tf == mc.help_txt)
			{
				mc.msg_txt.text = "報告書の書き方の説明ページを別ウインドウで開きます。";
			}
			else if (tf == mc.normal_txt)
			{
				//mc.msg_txt.text = "通常の鬼火弾を使用したい場合はこのボタンをクリックしてください。\n透過色の設定後にボタンを押すと背景が透過色になります。";
				mc.msg_txt.text = "通常の鬼火弾を使用したい場合はこのボタンをクリックしてください。";
			}
			else if (tf == mc.onibidan1_txt)
			{
				mc.msg_txt.text = "鬼火弾の画像[甲]を貼り付けます。画像サイズは縦横16x16ピクセルです。";
			}
			else if (tf == mc.onibidan2_txt)
			{
				mc.msg_txt.text = "鬼火弾の画像[乙]を貼り付けます。画像サイズは縦横16x16ピクセルです。";
			}
		
		}
		
		//----------------
		// show
		//----------------
		public function show(isReset:Boolean = true):void
		{
			var i:int;
			
			this.visible = true;
			
			showStageType(false);
			showAttackType(false);
			
			//mc.status_txt.text = "";
			
			if (isReset)
			{
				//--------
				//init
				for (i = 0; i < yomaBmp.length; i++)
				{
					if (yomaBmp[i].bitmapData.rect.width < 16)
					{
						yomaBmp[i].bitmapData.fillRect(yomaBmp[i].bitmapData.rect, 0x00000000);
					}
					else
					{
						yomaBmp[i].bitmapData = new BitmapData(1, 1, true, 0x00000000);
					}
					bmpVectorOrg[i] = yomaBmp[i].bitmapData.getVector(yomaBmp[i].bitmapData.rect);
				}
				yomaBmpForZoom.bitmapData = yomaBmp[0].bitmapData.clone();
				//--------
				
				//提出データ設定
				if (0 < Global.myReportTbl.getCount())
				{
					mc.title_txt.text = Global.myReportTbl.getData(0, "TITLE");
					textMngData = Global.myReportTbl.getData(0, "MANAGE");
					textImgData[0] = Global.myReportTbl.getData(0, "IMG1");
					textImgData[1] = Global.myReportTbl.getData(0, "IMG2");
					textImgData[2] = Global.myReportTbl.getData(0, "IMG3");
					textImgData[3] = Global.myReportTbl.getData(0, "IMG4");
					textImgData[4] = Global.myReportTbl.getData(0, "IMG5");
					//report.status = int(Global.myReportTbl.getData(0, "STATUS"));
					
					showReport();
					
						//保留
						//showStatus();				
				}
			}
			
			if (Global.isMake)
			{
				//mc.status_txt.text = "報告書の提出：受付中";
				//mc.decide_txt.visible = true;
				
				mc.decide_txt.text = "提出";
				if (0 < Global.myReportTbl.getCount())
				{
					mc.decide_txt.text = "修正";
				}
				mc.msg_txt.text = "";
			}
			else
			{
				//mc.status_txt.text = "報告書の提出：停止中";
				//mc.decide_txt.visible = false;
				
				mc.decide_txt.text = "---";
				mc.msg_txt.text = "報告書の受付は現在停止しています。";
			}
			
			//--------
			if (0 < Global.myReportTbl.getCount())
			{
				if (yomaBmpForZoom.bitmapData != null)
				{
					if (16 <= yomaBmpForZoom.bitmapData.width)
					{
						if (this.hasEventListener(Event.ENTER_FRAME) == false)
						{
							remainCnt = Global.FPS * 5;
							onibiCircle.x = yomaBmpForZoom.x + report.onibiX * report.scale;
							onibiCircle.y = yomaBmpForZoom.y + report.onibiY * report.scale;
							this.addEventListener(Event.ENTER_FRAME, enterFrame);
						}
					}
				}
			}
		
		}

		// ----------------
		// test
		// ----------------
		private function showReport():void
		{
			var no:int;
			var i:int;
			var tmp:Array;
			
			tmp = textMngData.split(":");
			report.width = tmp[0];
			report.height = tmp[1];
			report.tokasyokuNo = tmp[2];
			report.onibiX = tmp[3];
			report.onibiY = tmp[4];
			report.scale = tmp[5];
			
			report.stageType = int(Global.myReportTbl.getData(0, "TYPE"));
			//--------攻撃パターン追加したので設定値がない場合はデフォルトにする
			report.attackType = int(Global.myReportTbl.getData(0, "ATTACK"));
			if (report.attackType == -1)
			{
				report.attackType = report.stageType;
			}
			//--------
			
			for (no = 0; no < textImgData.length; no++)
			{
				tmp = textImgData[no].split(":");
				var _palette:Vector.<int> = new Vector.<int>;
				
				//--------
				//鬼火弾
				if ((no == 3) || (no == 4))
				{
					report.width = 16;
					report.height = 16;
					
					if (tmp.length < 17)
					{
						//通常鬼火弾描画
						_clickOnibiNormal(no);
						continue;
					}
				}
				//--------
				
				for (i = 0; i < 16; i++)
				{
					_palette[i] = parseInt(tmp[i], 16);
				}
				
				var imgStr:String = Global.myUncompress(tmp[16]);
				yomaBmp[no].bitmapData = new BitmapData(report.width, report.height, true, 0x00000000);
				
				var x:int, y:int;
				for (y = 0; y < report.height; y++)
				{
					for (x = 0; x < report.width; x++)
					{
						i = y * report.width + x;
						//var colorNo:int = int(imgStr.substr(i, 1));
						var colorNo:int = parseInt(imgStr.substr(i, 1), 16);
						yomaBmp[no].bitmapData.setPixel32(x, y, 0xff000000 | _palette[colorNo]);
						
						//透過色は画像甲で決める
						if (no == 0)
						{
							if (colorNo == report.tokasyokuNo)
							{
								toukasyoku = 0xff000000 | _palette[colorNo];
							}
						}
					}
				}
				
				bmpVectorOrg[no] = yomaBmp[no].bitmapData.getVector(yomaBmp[no].bitmapData.rect);
				makePalleteData(no);
			}
			
			yomaBmpForZoom.scaleX = report.scale;
			yomaBmpForZoom.scaleY = report.scale;
			
			redrawBmp();
			showStageType(false);
			showAttackType(false)
		}
		
		//----------------
		// clickClose
		//----------------
		private function clickTeisatsu(e:MouseEvent):void
		{
			//必須チェック
			var retStr:String = checkReport();
			if (0 < retStr.length)
			{
				mc.msg_txt.text = retStr;
				return;
			}
			
			//--------
			convertBmp2Text();
			convertText2Bmp();
			clickTeisatsuFunc(e);
		}
		
		//----------------
		// clickClose
		//----------------
		private function clickClose(e:MouseEvent):void
		{
			this.visible = false;
			
			closeFunc(e);
		}
		
		//----------------
		// clickZoom
		//----------------
		private function clickZoom(e:MouseEvent):void
		{
			report.scale++;
			if (4 < report.scale)
			{
				report.scale = 1;
			}
			
			yomaBmpForZoom.scaleX = report.scale;
			yomaBmpForZoom.scaleY = report.scale;
		}
		
		//----------------
		// clickBack
		//----------------
		private function clickBack(e:MouseEvent):void
		{
			//report.stageType = (report.stageType - 1 + 3) % 3;
			var cnt:int = stageTypeName.length;
			report.stageType = (report.stageType - 1 + cnt) % cnt;
			showStageType();
		}
		
		//----------------
		// clickNext
		//----------------
		private function clickNext(e:MouseEvent):void
		{
			//report.stageType = (report.stageType + 1) % 3;
			var cnt:int = stageTypeName.length;
			report.stageType = (report.stageType + 1) % cnt;
			showStageType();
		}
		
		//----------------
		// clickBackAttack
		//----------------
		private function clickBackAttack(e:MouseEvent):void
		{
			//report.attackType = (report.attackType - 1 + 3) % 3;
			var cnt:int = attackTypeName.length;
			report.attackType = (report.attackType - 1 + cnt) % cnt;
			showAttackType();
		}
		
		//----------------
		// clickNextAttack
		//----------------
		private function clickNextAttack(e:MouseEvent):void
		{
			//report.attackType = (report.attackType + 1) % 3;
			var cnt:int = attackTypeName.length;
			report.attackType = (report.attackType + 1) % cnt;
			showAttackType();
		}
		
		//----------------
		// showStageType
		//----------------
		//private var stageTypeName:Vector.<String> = Vector.<String>(["単体", "複数（地面）", "複数（上空）"]);
		private var stageTypeName:Vector.<String> = Vector.<String>(["単体", "複数（地面）", "複数（上空）", "単体（上空）"]);
		private var stageTypeExplain:Vector.<String> = Vector.<String>(["単体で現れる妖魔です。", "複数で地面から現れる妖魔です。", "複数で上空から現れる妖魔です。", "単体で上空から現れる妖魔です。", ""]);
		
		private function showStageType(isShowExplain:Boolean = true):void
		{
			mc.stagetype_txt.text = stageTypeName[report.stageType];
			if (isShowExplain)
			{
				mc.msg_txt.text = stageTypeExplain[report.stageType];
			}
		}
		
		//----------------
		// showAttackType
		//----------------
		//private var attackTypeName:Vector.<String> = Vector.<String>(["打上", "転石", "直線"]);
		private var attackTypeName:Vector.<String> = Vector.<String>(["打上", "転石", "直線", "波"]);
		private var attackTypeExplain:Vector.<String> = Vector.<String>(["", "", "", ""]);
		
		private function showAttackType(isShowExplain:Boolean = true):void
		{
			mc.attacktype_txt.text = attackTypeName[report.attackType];
			if (isShowExplain)
			{
				mc.msg_txt.text = attackTypeExplain[report.attackType];
			}
		}
		
		//----------------
		// clickBmp
		//----------------
		private var toukasyoku:uint = 0x00000000;
		
		//private var onibiX:int = 0;
		//private var onibiY:int = 0;
		private function clickBmp(e:MouseEvent):void
		{
			var cx:int, cy:int;
			
			//透過色指定
			if (yomaBmp[0].bitmapData != null)
			{
				cx = Game.flashStage.mouseX - yomaBmp[0].x;
				cy = Game.flashStage.mouseY - yomaBmp[0].y;
				if (yomaBmp[0].bitmapData.rect.contains(cx, cy))
				{
					toukasyoku = yomaBmp[0].bitmapData.getPixel32(cx, cy);
					//mc.msg_txt.text = toukasyoku.toString(16);
					mc.msg_txt.text = "背景色（透過色）を指定しました。";
				}
			}
			
			//鬼火弾発射位置設定
			if (yomaBmpForZoom.bitmapData != null)
			{
				cx = (Game.flashStage.mouseX - yomaBmpForZoom.x) / report.scale;
				cy = (Game.flashStage.mouseY - yomaBmpForZoom.y) / report.scale;
				if (yomaBmpForZoom.bitmapData.rect.contains(cx, cy))
				{
					report.onibiX = cx;
					report.onibiY = cy;
					mc.msg_txt.text = "x:" + report.onibiX + " y:" + report.onibiY + " この位置から鬼火を発射します。";
					
					//--------
					if (this.hasEventListener(Event.ENTER_FRAME) == false)
					{
						this.addEventListener(Event.ENTER_FRAME, enterFrame);
					}
					//else
					{
						remainCnt = Global.FPS * 5;
						onibiCircle.x = yomaBmpForZoom.x + report.onibiX * report.scale;
						onibiCircle.y = yomaBmpForZoom.y + report.onibiY * report.scale;
						//this.addEventListener(Event.ENTER_FRAME, enterFrame);
					}
				}
			}
			
			redrawBmp();
		}
		
		//----------------
		// clickNormal
		// 鬼火弾を通常に戻す
		//----------------
		private function clickOnibiNormal(e:MouseEvent):void
		{
			var no:int;
			for (no = 3; no <= 4; no++)
			{
				_clickOnibiNormal(no);
			}
		}
		
		private function _clickOnibiNormal(no:int):void
		{
			var i:int;
			var w:int = 16;
			var h:int = 16;
			//var no:int = 3;
			
			/*
			//--------
			var tmp:Array = textMngData.split(":");
			report.width = tmp[0];
			report.height = tmp[1];
			report.tokasyokuNo = tmp[2];
			report.onibiX = tmp[3];
			report.onibiY = tmp[4];
			report.scale = tmp[5];
			//--------
			*/
			
			//for (no = 3; no <= 4; no++ )
			{
				/*
				   textImgData[no] = "" + int(toukasyoku & 0x00ffffff).toString(16) + ":ff:80ff:ffffff:0:0:0:0:0:0:0:0:0:0:0:0:78da3330c0020cc10095071701318c80002600e1414420d24646c640005601913636860990c347350fdd3e0cf7a0bb17c33f280000a4f23115";
				
				   var tmp:Array = textImgData[no].split(":");
				
				   var _palette:Vector.<int> = new Vector.<int>;
				   for (i = 0; i < 16; i++ )
				   {
				   _palette[i] = parseInt(tmp[i], 16);
				   }
				
				   var imgStr:String = Global.myUncompress(tmp[16]);
				 */
				
				var _palette:Vector.<int> = new Vector.<int>;
				for (i = 0; i < 16; i++)
				{
					_palette[i] = 0;
				}
				_palette[1] = 0x0000ff;
				_palette[2] = 0x0080ff;
				_palette[3] = 0xffffff;
				
				var imgStr:String = "*********************111111********1111111111*****111122221111****112222222211***11122333322111**11223333332211**11223333332211**11223333332211**11223333332211**11122333322111***112222222211****111122221111*****1111111111********111111*********************";
				
				yomaBmp[no].bitmapData = new BitmapData(w, h, true, 0x00000000);
				
				var x:int, y:int;
				for (y = 0; y < h; y++)
				{
					for (x = 0; x < w; x++)
					{
						i = y * w + x;
						
						if (imgStr.substr(i, 1) == "*")
						{
							//強制透過色
							continue;
						}
						
						var colorNo:int = parseInt(imgStr.substr(i, 1), 16);
						//if (colorNo != 0)
						{
							yomaBmp[no].bitmapData.setPixel32(x, y, 0xff000000 | _palette[colorNo]);
						}
					}
				}
				/*
				   bmpVectorOrg[no] = yomaBmp[no].bitmapData.getVector(yomaBmp[no].bitmapData.rect);
				   makePalleteData(no);
				 */
				//データなしを通常弾とする
				bmpVectorOrg[no] = new Vector.<uint>;
				textImgData[no] = "";
			}
		
			//redrawBmp();
		}
		
		//----------------
		// enterFrame
		//----------------
		private var remainCnt:int = 0;
		
		private function enterFrame(e:Event):void
		{
			//鬼火射出位置
			onibiCircle.visible = true;
			
			var i:int = remainCnt / Global.halfFPS;
			if (i % 2 == 0)
			{
				onibiCircle.graphics.lineStyle(2, 0x7fffffff);
			}
			else
			{
				onibiCircle.graphics.lineStyle(2, 0x7faaaaaa);
			}
			onibiCircle.graphics.drawCircle(0, 0, 8);
			
			if (remainCnt <= 0)
			{
				onibiCircle.visible = false;
				if (this.hasEventListener(Event.ENTER_FRAME))
				{
					this.removeEventListener(Event.ENTER_FRAME, enterFrame);
				}
			}
			
			//--------
			if (this.visible == false)
			{
				if (this.hasEventListener(Event.ENTER_FRAME))
				{
					this.removeEventListener(Event.ENTER_FRAME, enterFrame);
				}
			}
			//--------
			
			remainCnt--;
		}
		
		//----------------
		// redrawBmp
		//----------------
		private function redrawBmp():void
		{
			var i:int, p:int;
			for (p = 0; p < bmpVectorOrg.length; p++)
			{
				if (bmpVectorOrg[p].length == 0)
				{
					continue;
				}
				var bmpVector:Vector.<uint> = new Vector.<uint>;
				for (i = 0; i < bmpVectorOrg[p].length; i++)
				{
					if (bmpVectorOrg[p][i] == toukasyoku)
					{
						bmpVector[i] = 0x00000000;
					}
					else
					{
						bmpVector[i] = bmpVectorOrg[p][i];
					}
				}
				
				yomaBmp[p].bitmapData.setVector(yomaBmp[p].bitmapData.rect, bmpVector);
			}
			
			//拡大表示用に複製
			//if (patternNo == 0)
			{
				yomaBmpForZoom.bitmapData = yomaBmp[0].bitmapData.clone();
			}
		}
		
		//----------------
		// clickTorikomi
		//----------------
		private var fr:FileReference = new FileReference();
		
		private function clickTorikomi(e:MouseEvent):void
		{
			if (e.target == mc.torikomi1_txt.parent)
			{
				patternNo = 0;
			}
			else if (e.target == mc.torikomi2_txt.parent)
			{
				patternNo = 1;
			}
			else if (e.target == mc.torikomi3_txt.parent)
			{
				patternNo = 2;
			}
			else if (e.target == mc.onibidan1_txt.parent)
			{
				patternNo = 3;
			}
			else if (e.target == mc.onibidan2_txt.parent)
			{
				patternNo = 4;
			}
			
			//
			fr.addEventListener(Event.SELECT, onFileReference_Select);
			fr.addEventListener(Event.COMPLETE, onFileReference_Complete);
			//必要なら...
			//fr.addEventListener(ProgressEvent.PROGRESS, onFileReference_Progress);
			//fr.addEventListener(Event.CANCEL, onFileReference_Cancel);
			//fr.addEventListener(IOErrorEvent.IO_ERROR, onFileReference_IOError);
			//fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileReference_SecurityError);
			
			//フィルタ拡張子を指定
			var ff:FileFilter = new FileFilter("Images(PNG, GIF)", "*.png;*.gif;");
			
			//ファイル選択ダイアログ起動
			fr.browse([ff]);
		}
		
		//FileReference　選択が終わった後の処理
		private function onFileReference_Select(e:Event):void
		{
			fr.load(); //ロード開始
		}
		
		//FileReference　ロード成功時の処理
		private function onFileReference_Complete(e:Event):void
		{
			//画像のバイナリファイルをloadeｒクラスで読み込みます。(デコードしてくれます)
			var loader:Loader = new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoader_Complete);
			//loader.contentLoaderInfo.(IOErrorEvent.IO_ERROR, onIOError);    //必要なら...
			
			loader.loadBytes(fr.data);
		}
		
		//Loader ロード成功時の処理
		private function onLoader_Complete(e:Event):void
		{
			var i:int;
			var loader:Loader = e.currentTarget.loader;
			
			//--------check
			if ((loader.width < 16) || (loader.height < 16))
			{
				mc.msg_txt.text = "画像サイズは縦横16x16～80x80ピクセル、画像に使用できる色は16色までです。";
				loader.unload();
				return;
			}
			if ((80 < loader.width) || (80 < loader.height))
			{
				mc.msg_txt.text = "画像サイズは縦横16x16～80x80ピクセル、画像に使用できる色は16色までです。";
				loader.unload();
				return;
			}
			if ((patternNo == 3) || (patternNo == 4))
			{
				if ((loader.width != 16) || (loader.height != 16))
				{
					mc.msg_txt.text = "鬼火弾画像サイズは縦横16x16ピクセル、画像に使用できる色は16色までです。";
					loader.unload();
					return;
				}
			}
			//--------
			
			//Loaderに読み込んだ画像でBitmapDataを作成。
			var bmd:BitmapData = new BitmapData(loader.width, loader.height, true, 0x000000);
			bmd.draw(loader);
			
			loader.unload();
			
			//
			yomaBmp[patternNo].bitmapData = bmd;
			bmpVectorOrg[patternNo] = bmd.getVector(bmd.rect);
			
			//--------
			//0x000000が矢が当たらない色なので0x000000は0x000001に変換する
			//if (patternNo == 2)
			{
				for (i = 0; i < bmpVectorOrg[patternNo].length; i++)
				{
					if ((0x00ffffff & bmpVectorOrg[patternNo][i]) == 0x000000)
					{
						bmpVectorOrg[patternNo][i] = 0xff000001;
					}
				}
			}
			//--------
			
			//使用色数チェック
			makePalleteData(patternNo);
			
			//--------
			var tmpStr:String = checkPallete(patternNo);
			if (0 < tmpStr.length)
			{
				//16色オーバー
				yomaBmp[patternNo].bitmapData = new BitmapData(1, 1, true, 0x00000000);
				bmpVectorOrg[patternNo] = yomaBmp[patternNo].bitmapData.getVector(yomaBmp[patternNo].bitmapData.rect);
				mc.msg_txt.text = tmpStr;
				return;
			}
			//--------
			
			//拡大表示用に複製
			if (patternNo == 0)
			{
				yomaBmpForZoom.bitmapData = yomaBmp[patternNo].bitmapData.clone();
			}
			
			//透過色反映
			redrawBmp();
		
			//
			//mc.msg_txt.text = bmd.rect.width + ":" + bmd.rect.height;// + " " + colorNo;
		}
		
		//----------------
		// makePalleteData
		//----------------
		private function makePalleteData(pno:int):void
		{
			var i:int;
			var colorNo:int = 0;
			palleteData[pno] = new Dictionary;
			for (i = 0; i < bmpVectorOrg[pno].length; i++)
			{
				if (palleteData[pno][bmpVectorOrg[pno][i]] == null)
				{
					palleteData[pno][bmpVectorOrg[pno][i]] = colorNo;
					colorNo++;
				}
			}
		}
		
		//----------------
		// convertBmp2Text
		//----------------
		private function convertBmp2Text():void
		{
			var p:int;
			for (p = 0; p < textImgData.length; p++)
			{
				var i:int;
				var d:uint = 0;
				var txtData:String = "";
				var palleteTxtData:Vector.<int> = new Vector.<int>;
				
				for (i = 0; i < 16; i++)
				{
					palleteTxtData[i] = 0;
				}
				for (i = 0; i < bmpVectorOrg[p].length; i++)
				{
					//画像txtデータ作成
					//txtData += palleteData[p][bmpVectorOrg[p][i]];
					txtData += int(palleteData[p][bmpVectorOrg[p][i]]).toString(16);
					//パレットtxtデータ作成
					var idx:int = int(palleteData[p][bmpVectorOrg[p][i]]);
					palleteTxtData[idx] = 0x00ffffff & bmpVectorOrg[p][i];
				}
				
				//
				var palleteStr:String = "";
				
				var toukasyokuNo:int = 0;
				for (i = 0; i < 16; i++)
				{
					palleteStr += palleteTxtData[i].toString(16) + ":";
					
					if ((0x00ffffff & toukasyoku) == (0x00ffffff & palleteTxtData[i]))
					{
						toukasyokuNo = i;
					}
				}
				var w:int = yomaBmp[p].bitmapData.width;
				var h:int = yomaBmp[p].bitmapData.height;
				
				if (p == 0)
				{
					//--------
					//textMngData = "";
					textMngData = w + ":" + h + ":" + toukasyokuNo + ":" + report.onibiX + ":" + report.onibiY + ":" + report.scale;
				}
				
				//textImgData[p] = "";
				//textImgData[p] += str;
				//textImgData[p] += toukasyokuNo + "," + w + "," + h + ",";
				//textImgData[p] += yomaScale + "," + onibiX + "," + onibiY + "," + Global.myCompress(txtData);
				textImgData[p] = palleteStr + Global.myCompress(txtData)
				
				//通常鬼火弾はとデータなしとする
				if (bmpVectorOrg[p].length == 0)
				{
					textImgData[p] = "";
				}
				
					//mc.msg_txt.text = textImgData[p];
			}
		}
		
		//----------------
		// convertText2Image
		//----------------
		//private function convertText2Image():void
		public function convertText2Bmp():void
		{
			var p:int;
			
			//textMngData = w + "," + h + "," + toukasyokuNo + "," + onibiX + "," + onibiY + "," + yomaScale
			var tmp:Array = textMngData.split(":");
			report.width = tmp[0];
			report.height = tmp[1];
			report.tokasyokuNo = tmp[2];
			report.onibiX = tmp[3];
			report.onibiY = tmp[4];
			report.scale = tmp[5];
			
			for (p = 0; p < textImgData.length; p++)
			{
				//--------
				//鬼火弾
				if ((p == 3) || (p == 4))
				{
					report.width = 16;
					report.height = 16;
					
					//Lv6までは鬼火弾データが無いのでスキップ
					//（もともとの画像を使用するので）
					if (textImgData[p].length == 0)
					{
						continue;
					}
				}
				//--------
				
				var i:int;
				tmp = textImgData[p].split(":");
				var _palette:Vector.<int> = new Vector.<int>;
				for (i = 0; i < 16; i++)
				{
					_palette[i] = parseInt(tmp[i], 16);
				}
				
				var imgStr:String = Global.myUncompress(tmp[16]);
				var bmpdata:BitmapData = new BitmapData(report.width, report.height, true, 0x00000000);
				
				var x:int, y:int;
				for (y = 0; y < report.height; y++)
				{
					for (x = 0; x < report.width; x++)
					{
						i = y * report.width + x;
						//var colorNo:int = int(imgStr.substr(i, 1));
						var colorNo:int = parseInt(imgStr.substr(i, 1), 16);
						if (colorNo == report.tokasyokuNo)
						{
							bmpdata.setPixel32(x, y, 0x00000000);
						}
						else
						{
							bmpdata.setPixel32(x, y, 0xff000000 | _palette[colorNo]);
						}
					}
				}
				
				//makeBitmapData(report.width, report.height, report.tokasyokuNo, imgStr);
				
				var img:Image = new Image(Texture.fromBitmapData(bmpdata));
				img.scaleX = report.scale;
				img.scaleY = report.scale;
				img.smoothing = TextureSmoothing.NONE;
				
				//--------
				//鬼火弾はscale2倍
				if ((p == 3) || (p == 4))
				{
					img.scaleX = img.scaleY = 2;
				}
				//--------
				
				//BitmapManager._monsterImage[BitmapManager._monsterImgNo[233 + p]] = img;
				var imgno:Vector.<int> = Vector.<int>([233, 234, 235, 237, 238]);
				BitmapManager._monsterImage[BitmapManager._monsterImgNo[imgno[p]]] = img;
			}
		}
		
		//----------------
		// setTextData
		// テキストデータをセット
		//----------------
		public function setTextData(_textMngData:String, _textImgData:Vector.<String>):void
		{
			var i:int;
			
			textMngData = _textMngData;
			
			for (i = 0; i < _textImgData.length; i++)
			{
				textImgData[i] = _textImgData[i];
			}
		}
		
		//----------------
		// clickDecide
		//----------------
		private function clickDecide(e:MouseEvent):void
		{
			if (Global.isMake == false)
			{
				mc.msg_txt.text = "報告書の受付は現在停止しています。";
				return;
			}
			
			/* 保留
			   //ステータスチェック
			   if (report.status != 0)
			   {
			   mc.msg_txt.text = "報告書の審査が開始されています。修正できません。";
			   return;
			   }
			 */
			
			//必須チェック
			var retStr:String = checkReport();
			if (0 < retStr.length)
			{
				mc.msg_txt.text = retStr;
				return;
			}
			
			//--------
			//画像、当たり判定小さすぎるチェック		
			var baseDotCnt:int = 0;
			baseDotCnt += getDotCnt(yomaBmp[0].bitmapData.getVector(yomaBmp[0].bitmapData.rect), false);
			baseDotCnt += getDotCnt(yomaBmp[1].bitmapData.getVector(yomaBmp[1].bitmapData.rect), false);
			baseDotCnt = baseDotCnt / 2;
			/*
			var needDotSize:int = (yomaBmp[0].bitmapData.rect.width * yomaBmp[0].bitmapData.height) * 0.30;
			if (baseDotCnt < needDotSize)
			{
			   mc.msg_txt.text = "妖魔が小さすぎます。" + needDotSize + "ピクセル以上の妖魔にしてください。";
			   return;
			}
			*/
			
			var hitDotCnt:int = getDotCnt(yomaBmp[2].bitmapData.getVector(yomaBmp[2].bitmapData.rect), true);
			var needDotCnt:int = baseDotCnt * 0.25;
			if (hitDotCnt <= needDotCnt)
			{
			   mc.msg_txt.text = "矢の刺さる部分が小さすぎます。" + (needDotCnt + 1) + "ピクセル以上にしてください。";
			   return;
			}
			//--------
			
			//--------
			if (0 < Global.myReportTbl.getCount())
			{
				confirmGamen.setMessage("報告書を修正します。\nよろしいですか？\n");
			}
			else
			{
				confirmGamen.setMessage("報告書を提出します。\nよろしいですか？\n");
			}
			confirmGamen.visible = true;
		}
		//private function getDotCnt(_vec:Vector.<uint>):int
		private function getDotCnt(_vec:Vector.<uint>, isReflectCount:Boolean = true):int
		{
			var i:int;
			var dotCnt:int = 0;
			for (i = 0; i < _vec.length; i++ )
			{
				if (_vec[i] != 0x00000000)
				{
					dotCnt++;
				}
				if (isReflectCount)
				{
					if (_vec[i] == 0xffff0000)
					{
						//反射色
						dotCnt--;
					}
				}
			}
			
			return dotCnt;
		}
		
		//----------------
		// checkReportOK
		//----------------
		private function checkReport():String
		{
			var i:int;
			
			for (i = 0; i < yomaBmp.length; i++)
			{
				if ((yomaBmp[i].bitmapData.width < 16) || (yomaBmp[i].bitmapData.height < 16))
				{
					//return "妖魔画像[甲]、妖魔画像[乙]、攻撃場所画像をすべて設定してください。";
					return "妖魔画像[甲][乙]、攻撃場所画像、鬼火弾画像[甲][乙]をすべて設定してください。";
				}
			}
			
			if ((yomaBmp[0].bitmapData.width != yomaBmp[1].bitmapData.width) || (yomaBmp[1].bitmapData.width != yomaBmp[2].bitmapData.width) || (yomaBmp[2].bitmapData.width != yomaBmp[0].bitmapData.width))
			{
				return "画像サイズが違います。妖魔画像[甲]、妖魔画像[乙]、攻撃場所画像はすべて同じサイズの画像にしてください。";
			}
			
			if ((yomaBmp[0].bitmapData.height != yomaBmp[1].bitmapData.height) || (yomaBmp[1].bitmapData.height != yomaBmp[2].bitmapData.height) || (yomaBmp[2].bitmapData.height != yomaBmp[0].bitmapData.height))
			{
				return "画像サイズが違います。妖魔画像[甲]、妖魔画像[乙]、攻撃場所画像はすべて同じサイズの画像にしてください。";
			}
			
			if ((yomaBmp[3].bitmapData.width != 16) || (yomaBmp[3].bitmapData.height != 16) || (yomaBmp[4].bitmapData.width != 16) || (yomaBmp[4].bitmapData.height != 16))
			{
				return "鬼火弾画像[甲][乙]のサイズは16x16ピクセルにしてください。";
			}
			
			for (i = 0; i < yomaBmp.length; i++)
			{
				var tmpStr:String = checkPallete(i);
				if (0 < tmpStr.length)
				{
					return tmpStr;
				}
			}
			
			var str:String = StringUtil.trim(mc.title_txt.text);
			if (str.length <= 0)
			{
				return "妖魔名を入力してください。";
			}
			
			return "";
		}
		
		private function checkPallete(pno:int):String
		{
			var imgName:Vector.<String> = Vector.<String>(["妖魔画像[甲]", "妖魔画像[乙]", "攻撃場所画像", "鬼火弾画像[甲]", "鬼火弾画像[乙]"]);
			
			var cnt:int = 0;
			for (var tmp:Object in palleteData[pno])
			{
				cnt++;
			}
			if (16 < cnt)
			{
				return imgName[pno] + "の色数が16色を超えています。";
			}
			
			return "";
		}
		
		//----------------
		// clickDecide
		//----------------
		private function clickYes(e:MouseEvent):void
		{
			confirmGamen.visible = false;
			mc.msg_txt.text = "送信中…";
			
			sendData();
		}
		
		//----------------
		// sendData
		//----------------
		private function sendData():void
		{
			//--------
			convertBmp2Text();
			convertText2Bmp();
			
			//--------
			var mkc:MakeConnect = new MakeConnect();
			var obj:Object = new Object();
			obj.name = Global.userTbl.getData(0, "NAME");
			obj.pwd = Global.pwd;
			obj.type = report.stageType;
			obj.attack = report.attackType;
			obj.title = mc.title_txt.text;
			obj.mngdata = textMngData;
			obj.img1 = textImgData[0];
			obj.img2 = textImgData[1];
			obj.img3 = textImgData[2];
			obj.img4 = textImgData[3];
			obj.img5 = textImgData[4];
			
			mkc.connect(obj, makeOK);
			function makeOK(bool:Boolean):void
			{
				if (bool)
				{
					show();
				}
				mc.msg_txt.text = mkc.message;
			}
		}
		
		//----------------
		// openNewWin
		//----------------
		/*
		   import flash.external.ExternalInterface;
		   import flash.net.URLRequest;
		   import flash.net.navigateToURL;
		   private function openNewWin(url:String):void
		   {
		   var jsCheckFunc:String = "function(){ return !/KHTML/.test(navigator.userAgent) }";
		   var isOpenInJS:Boolean = ExternalInterface.available && ExternalInterface.call(jsCheckFunc);
		   if (isOpenInJS)
		   {
		   ExternalInterface.call("window.open", url, "_blank");
		   }
		   else
		   {
		   navigateToURL(new URLRequest(url), '_blank');
		   }
		   }
		 */
		private function openHelp():void
		{
			import flash.net.URLRequest;
			import flash.utils.escapeMultiByte;
			import flash.net.navigateToURL;
			navigateToURL(new URLRequest("http://kasaharan.com/game/arrows/report_help.html"), "_blank");
		}
	
	}

}