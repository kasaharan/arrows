package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author kasaharan
	 */
	public class QuestGamen extends Sprite
	{
		public var mc:MovieClip;
		private var questListTf:Vector.<TextField>;
		private var mt:RandomMT = new RandomMT();
		private var questScenarioNo:Vector.<int> = new Vector.<int>;
		private var _scenario:Scenario = new Scenario();

		public function QuestGamen(_mc:MovieClip) 
		{
			var i:int;

			mc = _mc;
			addChild(mc);

			//--------
			questListTf = Vector.<TextField>
			([
				 mc.tf01_txt
				,mc.tf02_txt
				,mc.tf03_txt
				,mc.tf04_txt
				,mc.tf05_txt
				,mc.tf06_txt
				,mc.tf07_txt
				,mc.tf08_txt
			]);
			for (i = 0; i < questListTf.length; i++ )
			{
				addSpriteBtn(questListTf[i], clickQuestList);
				questListTf[i].visible = false;
			}
			
			addSpriteBtn(mc.close_txt, clickClose);
		}

		// ----------------
		// addSpriteBtn
		// ----------------
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
		// clickClose
		// ----------------
		private function clickClose(e:MouseEvent):void 
		{
			this.visible = false;
		}
		
		// ----------------
		// show
		// ----------------
		private var questConnect:QuestConnect = new QuestConnect();
		public function show():void 
		{
			this.visible = true;
			
			mc.msg_txt.text = "";
			mc.money_txt.text = "霊銭 " + Global.userTbl.getData(0, "RELEASE") + "文";
			
			if (Global.questTbl.getCount() == 0)
			{
				var obj:Object = new Object();
				obj.name = Global.username;
				questConnect.connect(obj, questOK)
			}
			else
			{
				showQuestList();
			}
		}
		private function questOK(bool:Boolean):void
		{
			if (bool)
			{
				showQuestList();
			}
		}
		private var questList1:Vector.<int> = Vector.<int>([
			Scenario.ONI,
			Scenario.DAIJA,
			Scenario.MUKADE,
			Scenario.TUCHIGUMO,
			Scenario.ONI3,
			Scenario.OROCHI,
			Scenario.SHUTENDOUJI
		]);
		private var questList2:Vector.<int> = Vector.<int>([
			Scenario.ZOMBIE,
			Scenario.SKELETON,
			Scenario.SLIME,
			Scenario.ARMOR_DEMON,
			Scenario.TREE,
			Scenario.HARPY,
			Scenario.WISP,
			Scenario.LONGWITTON
		]);
		private var questList3:Vector.<int> = Vector.<int>([
			Scenario.TANK,
			Scenario.FIGHTER,
			Scenario.BATTLE_SHIP,
			Scenario.STEALTH,
			Scenario.UFO,
			Scenario.TREX,
			Scenario.PTERANODON,
			Scenario.METEORITE
		]);
		private var questList4:Vector.<int> = Vector.<int>([
			Scenario.ROSE,
			Scenario.CHAMAELEON,
			Scenario.TENGU
		]);
		private var rewardList:Vector.<int> = Vector.<int>([50, 100, 200, -1]);
		
		private function showQuestList():void
		{
			var i:int;
			
			//init
			for (i = 0; i < questListTf.length; i++ )
			{
				questScenarioNo[i] = -1;
				questListTf[i].visible = false;
			}
			
			//--------
			for (i = 0; i < questListTf.length; i++ )
			{
				if (Global.questTbl.getCount() <= i)
				{
					break;
				}
				
				//--------
				var seed:int = int(Global.questTbl.getData(i, "SEED"));
				var questNo:int = int(Global.questTbl.getData(i, "NO"));
				var cleared:int = int(Global.questTbl.getData(i, "CLEAR"));
				mt.init_genrand(seed + questNo);
				
				if (questNo == 1)
				{
					//クエスト表示条件
					if (Global.scenario.lastClearIndex < Global.scenario.getStageIdx(Scenario.SHUTENDOUJI))
					{
						break;
					}
					_scenario.no = questList1[mt.getRandInt(questList1.length)];
				}
				else if (questNo == 2)
				{
					//クエスト表示条件
					if (Global.scenario.lastClearIndex < Global.scenario.getStageIdx(Scenario.LONGWITTON))
					{
						break;
					}
					_scenario.no = questList2[mt.getRandInt(questList2.length)];
				}
				else if (questNo == 3)
				{
					//クエスト表示条件
					if (Global.scenario.lastClearIndex < Global.scenario.getStageIdx(Scenario.METEORITE))
					{
						break;
					}
					_scenario.no = questList3[mt.getRandInt(questList3.length)];
				}
				else if (questNo == 4)
				{
					//クエスト表示条件
					if (Global.scenario.lastClearIndex < Global.scenario.getStageIdx(Scenario.TENGU))
					{
						break;
					}
					_scenario.no = questList4[mt.getRandInt(questList4.length)];
				}
				
				var str:String = " ";
				if (cleared == 0)
				{
					str += "    ";
				}
				else
				{
					str += "[済]";
				}
				var sidx:int = _scenario.getStageIdx(_scenario.no);
				str += Global.leftStr(_scenario.getName(sidx), 24);
				//str += "報酬 霊銭" + Global.rightStr("" + rewardList[i], 3) + "文";
				if (rewardList[i] == -1)
				{
					str += "報酬 勾玉";
				}
				else
				{
					str += "報酬 霊銭" + Global.rightStr("" + rewardList[i], 3) + "文";
				}
				questListTf[i].text = str;
				questListTf[i].visible = true;

				questScenarioNo[i] = _scenario.no;
			}
		}
		
		// ----------------
		// clickQuestList
		// ----------------
		private function clickQuestList(e:MouseEvent):void
		{
			//--------
			if (Global.yumiSettingGamen.isNoroi2())
			{
				mc.msg_txt.text = "稲荷依頼を受けるには[呪×呪]をはずしてください。";
				return;
			}
			//--------
			
			var i:int;
			for (i = 0; i < questListTf.length; i++ )
			{
				if (Global.questTbl.getCount() <= i)
				{
					break;
				}
				
				if (questScenarioNo[i] == -1)
				{
					break;
				}
				
				if (e.target == questListTf[i].parent)
				{
					if (int(Global.questTbl.getData(i, "CLEAR")) == 1)
					{
						//クリア済み
						mc.msg_txt.text = "退治済みです。";
						break;
					}
					
					if (i + 1 == 4)
					{
						//報酬勾玉クエスト
						if (Item.MAX_COUNT <= Global.itemTbl.getCount())
						{
							mc.msg_txt.text = "道具が一杯です。これ以上勾玉を取得できません。";
							break;
						}
					}
					
					Global.scenario.no = questScenarioNo[i];
					this.visible = false;
					Global.selectGamen.visible = true;
					Global.selectGamen.lastSelectedScenerioNo = Global.scenario.no;
					Global.dailyQuestNo = (i + 1);
					Global.selectGamen.refreshPage();
					Global.selectGamen.showNowPage();
					break;
				}
			}

		}

	}

}