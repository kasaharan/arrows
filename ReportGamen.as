package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author kasaharan
	 */
	public class ReportGamen extends Sprite
	{
		public var mc:MovieClip;
		//private var selectTf:Vector.<TextField>;

		private var clickMakeFunction:Function;
		//private var clickNextFunction:Function;
		
		private var yomaBmp:Bitmap = new Bitmap(new BitmapData(80, 80, true, 0x00000000));
		public var pageNo:int = 0;
		//public var isDecide:Boolean = false;
		public var isDecide:Dictionary = new Dictionary();
		private var questionTf:TextField = new TextField();
		
		public function ReportGamen(_mc:MovieClip, _clickMakeFunction:Function, clickDecide:Function, clickClose:Function) 
		{
			mc = _mc;
			addChild(mc);

			//yomaBmp.x = 10;
			//yomaBmp.y = 40;
			addChild(yomaBmp);
			
			var fmt:TextFormat = new TextFormat();
			fmt.bold = true;
			fmt.size = 50;
			questionTf.defaultTextFormat = fmt;
			questionTf.visible = false;
			questionTf.textColor = 0xffffff;
			questionTf.autoSize = TextFieldAutoSize.LEFT;
			questionTf.text = "？";
			addChild(questionTf);
			
			/*
			selectTf = Vector.<TextField>
			([
				 mc.quest00_txt
				,mc.quest01_txt
				,mc.quest02_txt
				,mc.quest03_txt
				,mc.quest04_txt
				,mc.quest05_txt
				,mc.quest06_txt
				,mc.quest07_txt
			]);
			*/
			
			//clickBackFunction = _clickBack;
			//clickNextFunction = _clickNext;

			addSpriteBtn( mc.back_txt, clickBack );
			addSpriteBtn( mc.next_txt, clickNext );
			addSpriteBtn( mc.shindo_txt, clickShindo );
			
			//addSpriteBtn( mc.make_txt, function(e:MouseEvent) { clickMake(e); } );
			clickMakeFunction = _clickMakeFunction;
			addSpriteBtn( mc.make_txt, clickMake );
			//addSpriteBtn( mc.make_txt, function(e:MouseEvent) { mc.msg_txt.text = "報告書作成機能はただいま準備中です。" } );

			//addSpriteBtn( mc.decide_txt, clickDecide );
			addSpriteBtn( mc.decide_txt,
				function(e:MouseEvent):void
				{
					//isDecide = true;

					//Scenario.scenarioName[Scenario.REPORT_LV1] = Global.reportTbl.getData(pageNo, "TITLE");
					
					var ngno:int = int(Global.reportTbl.getData(pageNo, "NG"));
					if (ngno != 0)
					{
						mc.msg_txt.text = "討伐できません。";
						return;
					}

					var reportLv:int = int(Global.reportTbl.getData(pageNo, "STAGE"));
					if (nowStageLevel < reportLv)
					{
						mc.msg_txt.text = "この深度の妖魔はまだ討伐できません。";
						return;
					}
					
					/*
					if (reportLv == 0)
					{
						Global.scenario.no = Scenario.REPORT_LV1;
					}
					else if (reportLv == 1)
					{
						Global.scenario.no = Scenario.REPORT_LV2;
					}
					else if (reportLv == 2)
					{
						Global.scenario.no = Scenario.REPORT_LV3;
					}
					*/
					var tmpNo:Vector.<int> = Vector.<int>
					([
						Scenario.REPORT_LV1,
						Scenario.REPORT_LV2,
						Scenario.REPORT_LV3,
						Scenario.REPORT_LV4,
						Scenario.REPORT_LV5,
						Scenario.REPORT_LV6,
						Scenario.REPORT_LV7,
						Scenario.REPORT_LV8,
						Scenario.REPORT_LV9,
						Scenario.REPORT_LV10,
						Scenario.REPORT_LV11,
						Scenario.REPORT_LV12
					]);
					Global.scenario.no = tmpNo[reportLv];
					
					Global.selectGamen.lastSelectedScenerioNo = Global.scenario.no;	//報告書の選択状態クリアのために使う
					
					//clearScenerioName();
					Scenario.clearScenerioName();
					Scenario.scenarioName[Global.scenario.no] = Global.reportTbl.getData(pageNo, "TITLE");
					isDecide[Global.scenario.no] = true;
					
					clickDecide(e);
				}
			);
			addSpriteBtn( mc.close_txt,
				function (e:MouseEvent):void
				{
					//isDecide = false;
					clearDecideFlag();
					/*
					Scenario.scenarioName[Scenario.REPORT_LV1] = "--未選択--";
					Scenario.scenarioName[Scenario.REPORT_LV2] = "--未選択--";
					Scenario.scenarioName[Scenario.REPORT_LV3] = "--未選択--";
					*/
					//clearScenerioName();
					Scenario.clearScenerioName();
					clickClose(e);
				}
			);
			
			//--------
			//init
			clearDecideFlag();
			//--------
			
			//######## 管理者用機能、報告書閲覧 ########
			mc.username_txt.visible = false;
			mc.browse_txt.visible = false;
			addSpriteBtn(mc.browse_txt, clickBrowse);
			//########
		}
		
		/*
		private function clearScenerioName():void
		{
			Scenario.scenarioName[Scenario.REPORT_LV1] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV2] = "--未選択--";
			Scenario.scenarioName[Scenario.REPORT_LV3] = "--未選択--";
		}
		*/

		private function addSpriteBtn(tf:TextField, f:Function):void
		{
			tf.mouseEnabled = false;

			var btn:Sprite = new Sprite();
			btn.buttonMode = true;
			btn.addChild(tf);
			mc.addChild(btn);

			tf.borderColor = 0x9977bb;
			tf.textColor = 0xffffff;
			tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;//0x664477;
			tf.mouseEnabled = false;

			btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_SELECT_COLOR;showExplain(tf);});
			btn.addEventListener(MouseEvent.MOUSE_OUT,  function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;});
			btn.addEventListener(MouseEvent.CLICK, f);
		}

		// ----------------
		// clearDecideFlag
		// ----------------
		//private function clearDecideFlag():void
		public function clearDecideFlag():void
		{
			isDecide[Scenario.REPORT_LV1] = false;
			isDecide[Scenario.REPORT_LV2] = false;
			isDecide[Scenario.REPORT_LV3] = false;
			isDecide[Scenario.REPORT_LV4] = false;
			isDecide[Scenario.REPORT_LV5] = false;
			isDecide[Scenario.REPORT_LV6] = false;
			isDecide[Scenario.REPORT_LV7] = false;
			isDecide[Scenario.REPORT_LV8] = false;
			isDecide[Scenario.REPORT_LV9] = false;
			isDecide[Scenario.REPORT_LV10] = false;
			isDecide[Scenario.REPORT_LV11] = false;
			isDecide[Scenario.REPORT_LV12] = false;
		}
		
		// ----------------
		// showExplain
		// ----------------
		private function showExplain(tf:TextField):void
		{
			if (tf == mc.decide_txt)
			{
				mc.msg_txt.text = "この報告書の妖魔を退治します。";
			}
			else if (tf == mc.shindo_txt)
			{
				mc.msg_txt.text = "妖魔界深度ごとにページを切り替えます。";
			}
			else
			{
				mc.msg_txt.text = "";
			}
		}

		// ----------------
		// clickBack
		// ----------------
		private function clickBack(e:MouseEvent):void 
		{
			pageNo--;
			//var maxPageNo:int = Global.reportTbl.getCount() - 1;
			if (pageNo < 0)
			{
				pageNo = maxPageNo;
			}

			drawBmp();
		}

		// ----------------
		// clickNext
		// ----------------
		private function clickNext(e:MouseEvent):void 
		{
			pageNo++;
			//var maxPageNo:int = Global.reportTbl.getCount() - 1;
			if (maxPageNo < pageNo)
			{
				pageNo = 0;
			}
			
			drawBmp();
		}

		// ----------------
		// getMaxPage
		// ----------------
		private function getMaxPage():int
		{
			var i:int;
			var ret:int = 0;
			
			var tmpLv:Vector.<int> = Vector.<int>([
			/*
				Scenario.REPORT_LV1,
				Scenario.REPORT_LV2,
				Scenario.REPORT_LV3,
				Scenario.REPORT_LV4,
				Scenario.REPORT_LV5,
				Scenario.REPORT_LV6,
				Scenario.REPORT_LV7,
				Scenario.REPORT_LV8,
				Scenario.REPORT_LV9,
				Scenario.REPORT_LV10,
				Scenario.REPORT_LV11,
				Scenario.REPORT_LV12
			*/
				Scenario.REPORT_LV1,
				Scenario.REPORT_LV2,
				Scenario.REPORT_LV3,
				Scenario.REPORT_LV4,
				Scenario.REPORT_LV5,
				Scenario.REPORT_LV6,
				Scenario.REPORT_LV7,
				Scenario.ROSE,			//ローズクリアで深度９ページ表示
				Scenario.CHAMAELEON,	//カメレオンクリアで深度10ページ表示
				Scenario.TENGU,			//天狗で深度11ページ表示
				Scenario.REPORT_LV11,
				Scenario.REPORT_LV12	//１３がなければこれはいらない
			]);
			for (i = 0; i < tmpLv.length; i++ )
			{
				if (Scenario.isClear(tmpLv[i]))
				{
					nowStageLevel = i + 1;	//報告書Lv.(i+1)まで表示OK
				}
			}
			
			//--------
			//呪2の場合の最大ページ取得
			if (Global.yumiSettingGamen.isNoroi2())
			{
				nowStageLevel = 0;
				for (i = 0; i < tmpLv.length; i++ )
				{
					trace("*" + i.toString() + ":" + Global.scenario.getStageIdx(tmpLv[i]) + ":" + Global.getMaxNoroi2StageIdx());
					if (Global.scenario.getStageIdx(tmpLv[i]) < Global.getMaxNoroi2StageIdx())
					{
						nowStageLevel = i + 1;
					}
				}
			}
			//--------
			
			for (i = 0; i < Global.reportTbl.getCount(); i++ )
			{
				if (int(Global.reportTbl.getData(i, "STAGE")) <= nowStageLevel)
				{
					ret = i;
				}
			}
			
			return ret;
		}
		
		// ----------------
		// clickShindo
		// ----------------
		private function clickShindo(e:MouseEvent):void 
		{
			var i:int;
			var _pageNo:int;
			var shindo:int = int(Global.reportTbl.getData(pageNo, "STAGE"));

			//深度切替
			for (i = 0; i < Global.reportTbl.getCount(); i++ )
			{
				if (shindo == int(Global.reportTbl.getData(i, "STAGE")))
				{
					//今の深度
					_pageNo = i;
					shindo = int(Global.reportTbl.getData(i, "STAGE"));
					break;
				}
			}

			for (i = _pageNo; i < Global.reportTbl.getCount(); i++ )
			{
				
				if (maxPageNo < i)
				{
					pageNo = 0;
					break;
				}
				
				//深度切替位置検索
				if (shindo != int(Global.reportTbl.getData(i, "STAGE")))
				{
					shindo = int(Global.reportTbl.getData(i, "STAGE"));
					pageNo = i;
					break;
				}
			}
			if (i == Global.reportTbl.getCount())
			{
				//切替位置見つからないので１ページへ
				pageNo = 0;
			}

			drawBmp();
		}
		
		// ----------------
		// drawBmp
		// ----------------
		private var nowStageLevel:int = 0;
		private var maxPageNo:int = 0;
		private function drawBmp():void
		{
			var i:int;
			var k:int;
			var x:int;
			var y:int;
			var tmp:Array;
			var str:String = "";
			var reportLv:int = 0;
			var report:Report = new Report();
			
			//var maxPageNo:int = int(Global.reportTbl.getCount());
			maxPageNo = getMaxPage();
			
			//mc.name_txt.text = (pageNo + 1) + "/" + maxPageNo + "　妖魔名：" + Global.reportTbl.getData(pageNo, "TITLE") + "　報告者：" + Global.reportTbl.getData(pageNo, "NAME");
			reportLv = int(Global.reportTbl.getData(pageNo, "STAGE"));
			//str += (pageNo + 1) + "/" + maxPageNo;
			var len:int = maxPageNo.toString().length;
			str += Global.rightStr("" + (pageNo + 1), len) + "/" + Global.rightStr("" + (maxPageNo + 1), len);
			str += " 妖魔界深度:" + (reportLv + 1);
			str += "　妖魔名：" + Global.reportTbl.getData(pageNo, "TITLE");
			str += "　報告者：" + Global.reportTbl.getData(pageNo, "NAME");
			mc.name_txt.text = str;

			//--------
			//著作権侵害などが発覚して後からＮＧ処理
			var ngno:int = int(Global.reportTbl.getData(pageNo, "NG"));
			if (ngno != 0)
			{
				if (ngno == 1)
				{
					mc.name_txt.text = (pageNo + 1) + "/" + maxPageNo + " この報告書の魔物は妖魔ではないことが判明しました。（著作権侵害）";
				}
				if (ngno == 2)
				{
					mc.name_txt.text = (pageNo + 1) + "/" + maxPageNo + " この報告書の魔物は現在調査中です。（審議中）";
				}
				yomaBmp.scaleX = 1;
				yomaBmp.scaleY = 1;
				yomaBmp.bitmapData.fillRect(yomaBmp.bitmapData.rect, 0x7fCCB3DD);
				return;
			}
			//--------

			tmp = Global.reportTbl.getData(pageNo, "MANAGE").split(":");
			report.width = tmp[0];
			report.height = tmp[1];
			report.tokasyokuNo = tmp[2];
			report.onibiX = tmp[3];
			report.onibiY = tmp[4];
			report.scale = tmp[5];

			tmp = Global.reportTbl.getData(pageNo, "IMG1").split(":");
			var _palette:Vector.<int> = new Vector.<int>;
			for (i = 0; i < 16; i++ )
			{
				_palette[i] = parseInt(tmp[i], 16);
			}

			var imgStr:String = Global.myUncompress(tmp[16]);
			//var bmpdata:BitmapData = new BitmapData(report.width, report.height, true, 0x00000000);

			//clear
			yomaBmp.bitmapData.fillRect(yomaBmp.bitmapData.rect, 0x00000000);
			yomaBmp.x = 10 + (320 - report.width * report.scale) * 0.5;
			yomaBmp.y = 10 + (320 - report.height * report.scale) * 0.5;
			
			//シルエット表示をするか？
			var isSilhouette:Boolean = true;
			if (5 <= (reportLv + 1))
			{
				for (i = 0; i < Global.silhouetteTbl.getCount(); i++ )
				{
					if (pageNo == int(Global.silhouetteTbl.getData(i, "PAGENO")))
					{
						isSilhouette = false;
						break;
					}
				}
			}
			else
			{
				isSilhouette = false;
			}

			if (isSilhouette)
			{
				questionTf.x = 10 + (320 - questionTf.width) * 0.5;
				questionTf.y = 10 + (320 - questionTf.height) * 0.5;
				questionTf.visible = true;
			}
			else
			{
				questionTf.visible = false;
			}
			
			//var x:int, y:int;
			for (y = 0; y < report.height; y++ )
			{
				for (x = 0; x < report.width; x++ )
				{
					i = y * report.width + x;
					//var colorNo:int = int(imgStr.substr(i, 1));
					var colorNo:int = parseInt(imgStr.substr(i, 1), 16);
					if (colorNo == report.tokasyokuNo)
					{
						//yomaBmp.bitmapData.setPixel32(x, y, 0x00000000);
						yomaBmp.bitmapData.setPixel32(x, y, 0x7fCCB3DD);
					}
					else
					{
						//yomaBmp.bitmapData.setPixel32(x, y, 0xff000000 | _palette[colorNo]);
						if (isSilhouette)
						{
							yomaBmp.bitmapData.setPixel32(x, y, 0xff000000);
						}
						else
						{
							yomaBmp.bitmapData.setPixel32(x, y, 0xff000000 | _palette[colorNo]);
						}
					}
				}
			}

			yomaBmp.scaleX = report.scale;
			yomaBmp.scaleY = report.scale;

		}
		
		/*
		// ----------------
		// isClearShindo
		// ----------------
		public static function isClearShindo(reportLv:int):Boolean
		{
			//報告書Lv6からは全て退治で次表示
			//(報告書Lv5 = 深度5 = stage4)
			var i:int;
			var k:int;
			var lv5AllCnt:int = 0;
			var clearCnt:int = 0;
			for (i = 0; i < Global.reportTbl.getCount(); i++ )
			{
				if ((reportLv - 1) == Global.reportTbl.getData(i, "STAGE"))
				{
					lv5AllCnt++;
					for (k = 0; k < Global.silhouetteTbl.getCount(); k++ )
					{
						if (i == Global.silhouetteTbl.getData(k, "PAGENO"))
						{
							clearCnt++;
						}
					}
				}
			}
			return (lv5AllCnt == clearCnt);
		}
		*/
		
		// ----------------
		// getDotCnt
		// 当たり判定ドット数からHPを計算するための値を取得する
		// ----------------
		public function getDotCnt():int
		{
			var i:int;
			var report:Report = new Report();
			var dotCnt:int = 0;
			
			tmp = Global.reportTbl.getData(pageNo, "MANAGE").split(":");
			report.width = tmp[0];
			report.height = tmp[1];
			report.tokasyokuNo = tmp[2];
			report.onibiX = tmp[3];
			report.onibiY = tmp[4];
			report.scale = tmp[5];
			
			var tmp:Array = Global.reportTbl.getData(pageNo, "IMG3").split(":");
			var _palette:Vector.<int> = new Vector.<int>;
			for (i = 0; i < 16; i++ )
			{
				_palette[i] = parseInt(tmp[i], 16);
			}

			var imgStr:String = Global.myUncompress(tmp[16]);
			for (i = 0; i < imgStr.length; i++ )
			{
				var colorNo:int = parseInt(imgStr.substr(i, 1), 16);
				if (colorNo != report.tokasyokuNo)
				{
					dotCnt++;
				}
			}
			
			return dotCnt;
		}

		// ----------------
		// getDotHeight
		// 当たり判定ドット数の高さからHPを計算するための値を取得する
		// ----------------
		public function getDotHeight():int
		{
			var i:int;
			var x:int;
			var y:int;
			var report:Report = new Report();
			//var dotCnt:int = 0;
			
			tmp = Global.reportTbl.getData(pageNo, "MANAGE").split(":");
			report.width = tmp[0];
			report.height = tmp[1];
			report.tokasyokuNo = tmp[2];
			report.onibiX = tmp[3];
			report.onibiY = tmp[4];
			report.scale = tmp[5];
			
			var tmp:Array = Global.reportTbl.getData(pageNo, "IMG3").split(":");
			var _palette:Vector.<int> = new Vector.<int>;
			for (i = 0; i < 16; i++ )
			{
				_palette[i] = parseInt(tmp[i], 16);
			}

			var imgStr:String = Global.myUncompress(tmp[16]);
			/*
			for (i = 0; i < imgStr.length; i++ )
			{
				var colorNo:int = parseInt(imgStr.substr(i, 1), 16);
				if (colorNo != report.tokasyokuNo)
				{
					dotCnt++;
				}
			}
			*/
			var minY:int = 80;
			var maxY:int = 0;
			for (y = 0; y < report.height; y++ )
			{
				for (x = 0; x < report.width; x++ )
				{
					i = y * report.width + x;
					var colorNo:int = parseInt(imgStr.substr(i, 1), 16);
					if (colorNo != report.tokasyokuNo)
					{
						if (y < minY)
						{
							minY = y;
						}
						if (maxY < y)
						{
							maxY = y;
						}
					}
				}
			}
			
			return (maxY - minY);
		}

		// ----------------
		// getScale
		// ----------------
		public function getDotScale():int
		{
			var i:int;
			var tmp:Array;
			var report:Report = new Report();
			
			tmp = Global.reportTbl.getData(pageNo, "MANAGE").split(":");
			report.width = tmp[0];
			report.height = tmp[1];
			report.tokasyokuNo = tmp[2];
			report.onibiX = tmp[3];
			report.onibiY = tmp[4];
			report.scale = tmp[5];
			
			return report.scale;
		}
		
		// ----------------
		// show
		// ----------------
		public function show():void 
		{
			if (0 < Global.reportTbl.getCount())
			{
				this.visible = true;
				//isDecide = false;
				clearDecideFlag();
				drawBmp();
			}


			//######## 管理者用機能、報告書閲覧 ########
			if (0 < Global.userTbl.getCount())
			{
				if (Global.userTbl.getData(0, "NAME") == "カサハランテスト")
				{
					mc.username_txt.visible = true;
					mc.browse_txt.visible = true;
				}
			}
			//################
		}
		
		// ----------------
		// clickMake
		// ----------------
		private function clickMake(e:MouseEvent):void
		{
			var myReportConnect:MyReportConnect = new MyReportConnect();
			var obj:Object = new Object();
			obj.name = Global.userTbl.getData(0, "NAME");
			
			if (0 < Global.myReportTbl.getCount())
			{
				//読込済
				obj.loadtype = "0";
			}
			else
			{
				obj.loadtype = "1";
			}
			
			myReportConnect.connect(obj, myReportOK);
			function myReportOK(bool:Boolean):void
			{
				if (bool)
				{
					clickMakeFunction(e);
				}
			}

		}

		// ################
		// clickBrowse
		// ################
		private function clickBrowse(e:MouseEvent):void
		{
			var myReportConnect:MyReportConnect = new MyReportConnect();
			var obj:Object = new Object();

			obj.name = mc.username_txt.text;
			obj.loadtype = "1";
			
			myReportConnect.connect(obj, myReportOK);
			function myReportOK(bool:Boolean):void
			{
				if (bool)
				{
					clickMakeFunction(e);
				}
			}

		}

		//----------------
		// hoseiHPByTobatsu
		// 討伐数によりHPを補正する
		//----------------
		public function getTobatsuHosei(scenarioNo:int):Number
		{
			var i:int;
			var rate:Number = 1.0;
			var targetCnt:int = 0;
			var sumCnt:int = 0;
			var allCnt:int = 0;

			//ORDER BY scenario_no, cnt DESC
			
			//平均討伐数より1回多いとHp1%増
			for (i = 0; i < Global.tobatsuTbl.getCount(); i++ )
			{
				//if (scenarioNo == int(Global.tobatsuTbl.getData(i, "SCENARIO")))
				//バグがあるためページNoで見る。
				//バグデータで件数が増えて平均値計算がおかしくなる
				var pageNo:int = int(Global.tobatsuTbl.getData(i, "PAGENO"));
				if ((96 <= pageNo) && (pageNo <= 111))
				{
					var c:int = int(Global.tobatsuTbl.getData(i, "CNT"));
					if (Global.reportGamen.pageNo == int(Global.tobatsuTbl.getData(i, "PAGENO")))
					{
						targetCnt = c
					}
					
					sumCnt += c;
					allCnt++;
				}
			}

			if (0 < allCnt)
			{
				var avgCnt:int = sumCnt / allCnt;
				/*
				rate = 1.0 + ((targetCnt - avgCnt) * 0.01);
				//最大300%
				if (3.0 < rate)
				{
					rate = 3.0;
				}
				*/
				
				//最大150% (1回の差で0.5% 100回で50%)
				rate = 1.0 + ((targetCnt - avgCnt) * 0.005);
				if (1.5 < rate)
				{
					rate = 1.5;
				}
				//最低80% → 20140917 これではデフォルトがHP80%となってしまうので次回からは変更する
				if (rate < 0.80)
				{
					rate = 0.80
				}
			}
			
			//(new TextLogConnect()).connect(Global.username, "targetCnt:" + targetCnt + " avgCnt:" + avgCnt + " rate:" + rate);
			
			return rate;
		}
	}

}