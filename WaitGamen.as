package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.ui.Keyboard;

	public class WaitGamen extends Sprite
	{
		public var mc:MovieClip;

		public function WaitGamen(_mc:MovieClip, clickOK:Function, clickCancel:Function)
		{
			mc = _mc;
			addChild(mc);

			addSpriteBtn(mc.ok_txt, clickOK);
			addSpriteBtn(mc.cancel_txt, clickCancel);

			this.focusRect = false;
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
			tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;//0x664477;
			tf.mouseEnabled = false;

			btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_SELECT_COLOR;});
			btn.addEventListener(MouseEvent.MOUSE_OUT,  function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;});
			btn.addEventListener(MouseEvent.CLICK, f);
		}

		// ----------------
		//
		// ----------------
		//public function setMemberText(str:String)
		public function setMemberText(str:String):Boolean
		{
			mc.test_txt.text = str;

			//--------
			mc.sync_txt.text = "";
			try
			{
				if (Global.usvr.isJoinSuccess == false)
				{
					mc.title_txt.text = "";
					mc.sync_txt.text = "";
					return false;
				}

				mc.msg_txt.text = "";
				
				var str:String = "";
				
				var minLevel:int = int(Global.usvr.room.getAttribute("minLevel"));
				str += "参加に必要な破魔弓レベル" + minLevel + "\n\n";
				
				var no:int = int(Global.usvr.room.getAttribute("scenarioNo"));
				//mc.title_txt.text = Scenario.scenarioName[no];
				
				//--------
				//報告書設定
				//if (Global.scenario.no == Scenario.REPORT)
				//if (no == Scenario.REPORT_LV1)
				if (Global.scenario.isReportStageFromNo(no))
				{
					Global.reportGamen.pageNo = int(Global.usvr.room.getAttribute("reportNo"));
					//Scenario.scenarioName[Scenario.REPORT_LV1] = Global.reportTbl.getData(Global.reportGamen.pageNo, "TITLE");
					Scenario.scenarioName[no] = Global.reportTbl.getData(Global.reportGamen.pageNo, "TITLE");
				}
				//--------
				
				Global.stageNoroiValue = Global.usvr.room.getAttribute("noroi");
				/*
				if (Global.stageNoroiValue == "0")
				{
					mc.title_txt.text = Scenario.scenarioName[no];
				}
				else
				{
					mc.title_txt.text = Scenario.scenarioName[no] + "[呪]";
				}
				*/
				if (Global.stageNoroiValue == "0")
				{
					mc.title_txt.text = Scenario.scenarioName[no];
				}
				else if (Global.stageNoroiValue == "1")
				{
					mc.title_txt.text = Scenario.scenarioName[no] + "[呪]";
				}
				else if (Global.stageNoroiValue == "2")
				{
					mc.title_txt.text = Scenario.scenarioName[no] + "[呪×呪]";
				}
				else
				{
					mc.title_txt.text = "?";
					return false;
				}
				
				/*
				var slv:int = Scenario.getSyncLevel(no);
				if (slv < Hamayumi.level)
				{
					str += "協力者の破魔弓の霊力の乱れを抑えるため、\n破魔弓のレベルを" + slv + "に抑えます。";
				}
				*/
				//--------
				if (Global.yumiSettingGamen.isDocho() && (2 <= Global.usvr.memberNo.length))
				{
					if (Scenario.getSyncYakazu(no) < Hamayumi.yakazu + Hamayumi.level)
					{
						var _yakazu:int = Scenario.getSyncYakazu(no);
						if (Global.yumiSettingGamen.is2ninbari())
						{
							_yakazu = _yakazu * 0.5;
						}
						str += "霊力抑制効果により、\n矢数を" + _yakazu + "に抑えます。";
					}
				}
				else
				{
					var slv:int = Scenario.getSyncLevel(no);
					if (slv < Hamayumi.level)
					{
						str += "協力者の破魔弓の霊力の乱れを抑えるため、\n破魔弓のレベルを" + slv + "に抑えます。";
					}
				}
				//--------

				mc.sync_txt.text = str;
			}
			catch(e:Error)
			{
				mc.title_txt.text = "";
				mc.sync_txt.text = "";
				return false;
			}
			
			return true;
		}
		
		public function initGamen(isHost:Boolean = false):void
		{
			if (isHost)
			{
				mc.ok_txt.visible = true;
			}
			else
			{
				mc.ok_txt.visible = false;
			}

			//--------
			mc.aikotoba_txt.text = "";
			if (0 < Global.selectGamen.mc.aikotoba_txt.text.length)
			{
				mc.aikotoba_txt.text = "合言葉[" + Global.selectGamen.mc.aikotoba_txt.text + "]";
			}
		}

	}

}