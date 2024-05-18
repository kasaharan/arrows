package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import net.user1.reactor.snapshot.RoomListSnapshot;
	import net.user1.reactor.snapshot.SnapshotEvent;

	public class SelectGamen extends Sprite
	{
		public var mc:MovieClip;
		private var scenario:Scenario;
		private var selectTf:Vector.<TextField>;
		private var boshuListTf:Vector.<TextField>;
		private var boshuListStartIdx:int = 0;
		//private var selectPageNo:int = 0;
		public var selectPageNo:int = 0;
		
		private var yumiSettingGamen:YumiSettingGamen = new YumiSettingGamen();

		private var boshuMC:BoshuMC = new BoshuMC();
		public var boshuSettingMC:BoshuSettingMC = new BoshuSettingMC();
		
		private var friendListTf:Vector.<TextField>;
		public var friendMC:FriendMC = new FriendMC();
		private var friendConfirmMC:ConfirmMC = new ConfirmMC();
		
		public function SelectGamen
		(
			 _mc:MovieClip
			,_scenario:Scenario
			,clickStart:Function
			,clickRegist:Function
			,clickCoop:Function
			,clickItem:Function
			,clickChat:Function
			,clickReport:Function
		)
		{
			var i:int;

			mc = _mc;
			addChild(mc);

			scenario = _scenario;
			
			Global.yumiSettingGamen = yumiSettingGamen;
			
			mc.name_txt.text = "";
			mc.coopCheck_txt.text = "";
			
			//MACフォント収まらない対策
			var fmt:TextFormat = mc.status_txt.getTextFormat();
			mc.status_txt.autoSize = TextFieldAutoSize.LEFT;
			
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

			for (i = 0; i < selectTf.length; i++)
			{
				addSpriteBtn(selectTf[i], clickScenario);
				selectTf[i].border = false;
			}

			addSpriteBtn(mc.back_txt, clickBackPage);
			addSpriteBtn(mc.next_txt, clickNextPage);
			addSpriteBtn(mc.start_txt, clickStart);
			addSpriteBtn(mc.regist_txt, clickRegist);
			
			//addSpriteBtn(mc.coop_txt, clickCoop);
			clickCoopFunc = clickCoop;
			addSpriteBtn(mc.coop_txt, _clickCoop);
			addSpriteBtn(mc.coopCheck_txt, clickCoopCheck);
			addSpriteBtn(mc.item_txt, clickItem);
			
			addSpriteBtn(mc.bgm_txt, clickBGM);
			addSpriteBtn(mc.chat_txt, clickChat);
			
			addSpriteBtn(mc.report_txt, clickReport);
			addSpriteBtn(mc.friend_txt, clickFriend);

			addSpriteBtn(mc.yakazuPlus_txt, clickYakazuPlus, true);
			addSpriteBtn(mc.yakazuMinus_txt, clickYakazuMinus, true);

			
			mc.yakazu_txt.addEventListener(Event.CHANGE, function(e:Event):void 
			{
				try
				{
					Arrow.maxArrowCnt = mc.yakazu_txt.text;
					//mc.yakazu_txt.text = Arrow.maxArrowCnt;
				}
				catch(err:Error){}
			});
			
			mc.status_txt.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { showExplain(mc.status_txt); } );

			//--------
			mc.aikotoba_txt.maxChars = 8;
			mc.aikotoba_txt.restrict = "a-zA-Z0-9";
			mc.aikotoba_txt.borderColor = 0x9977bb;
			mc.aikotoba_txt.backgroundColor = Global.BUTTON_NORMAL_COLOR;
			mc.aikotoba_txt.addEventListener(MouseEvent.MOUSE_OVER, mouseOverAikotoba);
			function mouseOverAikotoba(e:MouseEvent):void
			{
				mc.msg_txt.text = "合言葉(半角英数字)を入力しておくことで、同じ合言葉の人と協力戦を行えます。";
			}
			/*
			mc.aikotoba_txt.addEventListener(MouseEvent.CLICK, clickAikotoba); 
			function clickAikotoba(e:MouseEvent):void
			{
				mc.msg_txt.text = "合言葉の1文字目に @ を付けて協力戦で開始すると合言葉が公開されます。";
				
				showBoshuList();
			}
			*/
			
			//--------
			boshuListTf = Vector.<TextField>
			([
				 boshuMC.tf01_txt
				,boshuMC.tf02_txt
				,boshuMC.tf03_txt
				,boshuMC.tf04_txt
				,boshuMC.tf05_txt
				,boshuMC.tf06_txt
				,boshuMC.tf07_txt
				,boshuMC.tf08_txt
				//,boshuMC.up_txt
				//,boshuMC.down_txt
			]);
			for (i = 0; i < boshuListTf.length; i++ )
			{
				addSpriteBtn(boshuListTf[i], clickBoshuList, false, boshuMC);
			}

			addSpriteBtn(boshuMC.up_txt, clickBoshuList, false, boshuMC);
			addSpriteBtn(boshuMC.down_txt, clickBoshuList, false, boshuMC);
			addSpriteBtn(boshuMC.close_txt, function(e:MouseEvent):void { boshuMC.visible = false; }, false, boshuMC);
			addSpriteBtn(boshuMC.update_txt, updateBoshuList, false, boshuMC);

			function clickBoshuList(e:MouseEvent):void
			{
				var i:int;
				for (i = 0; i < boshuListTf.length; i++ )
				{
					if (e.target == boshuMC.up_txt.parent)
					{
						boshuListStartIdx--;
						showBoshuList();
						break;
					}
					else if (e.target == boshuMC.down_txt.parent)
					{
						boshuListStartIdx++;
						showBoshuList();
						break;
					}
					else if (e.target == boshuListTf[i].parent)
					{
						if (boshuListStartIdx + i < Global.usvr.coopName.length)
						{
							boshuMC.visible = false;
							Global.selectedCoopName = Global.usvr.coopName[boshuListStartIdx + i];
							clickCoopFunc(e);
							Global.waitGamen.mc.msg_txt.text = "選択した協力戦に参加処理中です。\nしばらくしても参加できない場合は\n取り消されたか、協力戦が開始されています。";
						}
						break;
					}
				}
			}
			//--------
			
			//--------フレンド機能画面
			/*
			friendListTf = Vector.<TextField>
			([
				 friendMC.list01_txt
				,friendMC.list02_txt
				,friendMC.list03_txt
				,friendMC.list04_txt
				,friendMC.list05_txt
				,friendMC.list06_txt
				,friendMC.list07_txt
				,friendMC.list08_txt
				,friendMC.list09_txt
				,friendMC.list10_txt
			]);
			for (i = 0; i < friendListTf.length; i++ )
			{
				addSpriteBtn(friendListTf[i], clickFriendList, false, friendMC);
				friendListTf[i].text = "";
			}
			addSpriteBtn(friendMC.tab01_txt, clickFriendTab01, false, friendMC);
			addSpriteBtn(friendMC.tab02_txt, clickFriendTab02, false, friendMC);
			addSpriteBtn(friendMC.close_txt, clickFriendClose, false, friendMC);
			//addSpriteBtn(friendMC.make_txt, clickFriendMake, false, friendMC);
			addSpriteBtn(friendMC.add_txt, clickFriendAdd, false, friendMC);
			addSpriteBtn(friendMC.ok_txt, clickFriendOk, false, friendMC);
			addSpriteBtn(friendMC.delete_txt, clickFriendDelete, false, friendMC);
			addSpriteBtn(friendMC.send_txt, clickFriendSend, false, friendMC);
			addSpriteBtn(friendConfirmMC.yes_txt, clickFriendYes, false, friendConfirmMC);
			addSpriteBtn(friendConfirmMC.no_txt, clickFriendNo, false, friendConfirmMC);
			friendMC.friend_txt.backgroundColor = 0xCCB3DD;// Global.BUTTON_NORMAL_COLOR;
			//friendMC.friend_txt.textColor = 0xffffff;
			friendMC.sndmsg_txt.backgroundColor = 0xCCB3DD;// Global.BUTTON_SELECT_COLOR;
			friendMC.rcvmsg_txt.backgroundColor = 0xCCB3DD;// Global.BUTTON_SELECT_COLOR;
			friendMC.friend_txt.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { showExplain(friendMC.friend_txt); } );
			
			friendMC.sndmsg_txt.text = "";
			friendMC.rcvmsg_txt.text = "";
			clickFriendTab01();
			addChild(friendMC);
			addChild(friendConfirmMC);
			friendMC.visible = false;
			friendConfirmMC.visible = false;
			*/
			initFriendMC();
			//--------
			
			//--------募集設定画面
			boshuSettingMC.minLv_txt.text = "1";
			boshuSettingMC.maxLv_txt.text = "" + Hamayumi.MAX_LEVEL;
			
			boshuSettingMC.minLv_txt.maxChars = 3;
			boshuSettingMC.minLv_txt.restrict = "0-9";
			boshuSettingMC.minLv_txt.borderColor = 0x9977bb;
			boshuSettingMC.minLv_txt.backgroundColor = Global.BUTTON_NORMAL_COLOR;
			
			boshuSettingMC.maxLv_txt.maxChars = 3;
			boshuSettingMC.maxLv_txt.restrict = "0-9";
			boshuSettingMC.maxLv_txt.borderColor = 0x9977bb;
			boshuSettingMC.maxLv_txt.backgroundColor = Global.BUTTON_NORMAL_COLOR;
			
			boshuSettingMC.msg_txt.text = "";
			
			addSpriteBtn(boshuSettingMC.all_txt, clickAllLevel, false, boshuSettingMC);
			addSpriteBtn(boshuSettingMC.near_txt, clickNearLevel, false, boshuSettingMC);
			addSpriteBtn(boshuSettingMC.update_txt, decideBoshuSetting, false, boshuSettingMC);
			addSpriteBtn(boshuSettingMC.close_txt, function(e:MouseEvent):void { boshuSettingMC.visible = false; }, false, boshuSettingMC);
			
			boshuSettingMC.all_txt.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { showExplain(boshuSettingMC.all_txt); } );
			boshuSettingMC.near_txt.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { showExplain(boshuSettingMC.near_txt); } );
			//--------
			
			//--------
			mc.yakazu_txt.maxChars = 4;
			mc.yakazu_txt.restrict = "0-9";
			mc.yakazu_txt.borderColor = 0x9977bb;
			mc.yakazu_txt.backgroundColor = Global.BUTTON_NORMAL_COLOR;
			mc.yakazu_txt.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { mc.msg_txt.text = "画面に表示できる矢の同時表示数を設定します。(100～3000)"; } );
			mc.yakazu_txt.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void{refreshPage();});

			//--------
			mc.yumi_txt.visible = false;
			addSpriteBtn(mc.yumi_txt, clickHamayumi);
			//--------
			yumiSettingGamen.visible = false;
			addChild(yumiSettingGamen);
			
			//--------
			addChild(boshuMC);
			addChild(boshuSettingMC);
			boshuMC.visible = false;
			boshuSettingMC.visible = false;
			//--------
			
			//--------
			Global.soundSettingGamen = new SoundSettingGamen();
			addChild(Global.soundSettingGamen);
			Global.soundSettingGamen.visible = false;
			//--------
			
			refreshPage();
			setSelecttedColor();
		}

		//private function addSpriteBtn(tf:TextField, f:Function, enablePress:Boolean = false):void
		private function addSpriteBtn(tf:TextField, f:Function, enablePress:Boolean = false, parentMC:MovieClip = null):void
		{
			tf.mouseEnabled = false;

			var btn:Sprite = new Sprite();
			btn.buttonMode = true;
			btn.addChild(tf);
			if (parentMC == null)
			{
				mc.addChild(btn);
			}
			else
			{
				parentMC.addChild(btn);
			}

			tf.borderColor = 0x9977bb;
			tf.textColor = 0xffffff;
			tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;//0x664477;
			tf.mouseEnabled = false;

			btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_SELECT_COLOR;showExplain(tf);});
			btn.addEventListener(MouseEvent.MOUSE_OUT,  function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;});
			btn.addEventListener(MouseEvent.CLICK, f);
			
			if (enablePress)
			{
				btn.addEventListener(MouseEvent.MOUSE_DOWN, f);
				btn.addEventListener(MouseEvent.MOUSE_UP, f);
			}
		}

		// ----------------
		// _clickCoop
		// ----------------
		private var clickCoopFunc:Function;
		private function _clickCoop(e:MouseEvent):void
		{
			//init
			Global.selectedCoopName = "";

			if (Global.yumiSettingGamen.isSelectCoop())
			{
				//協力戦選択
				showBoshuList();
			}
			else
			{
				clickCoopFunc(e);
			}
		}

		// ----------------
		// updateBoshuList
		// ----------------
		private function updateBoshuList(e:MouseEvent):void
		{
			showBoshuList();
		}
		
		// ----------------
		// showBoshuList
		// ----------------
		private var roomNoneCount:int = 0;
		private function showBoshuList():void
		{
			var i:int;
			var k:int = 0;
			var idx:int = 0;

			boshuMC.visible = true;
			
			var roomList:Vector.<String> = Global.usvr.getBoshuRooms(mc.aikotoba_txt.text);
			
			for (i = 0; i < boshuListTf.length; i++ )
			{
				boshuListTf[i].text = "";
			}
			//boshuMC.up_txt.text = "▲";
			//boshuMC.down_txt.text = "▼";
			
			for (i = 0; i < roomList.length; i++ )
			{
				if (boshuListStartIdx < 0)
				{
					boshuListStartIdx = 0;
				}
				if (roomList.length <= boshuListStartIdx)
				{
					boshuListStartIdx = roomList.length - 1;
				}
				idx = boshuListStartIdx + i;
				if (roomList.length <= idx)
				{
					break;
				}
				boshuListTf[k].text = " " + roomList[idx];
				k++;
			}
			
			//--------
			if (roomList.length == 0)
			{
				roomNoneCount++;
				if ((3 <= roomNoneCount) && (Global.usvr.isReady))
				{
					//部屋が見えないことがあるので3回更新ボタン押下で再接続
					roomNoneCount = 0;

/*
// サーバー上の全ルームを含むroomIDのスナップショットを生成
var snapshot:RoomListSnapshot = new RoomListSnapshot(UnionServer2.QUALIFIER, true);
// リスナー関数を登録します
snapshot.addEventListener(SnapshotEvent.LOAD, loadListener);
function loadListener (e:SnapshotEvent):void 
{
	var snapshot:RoomListSnapshot = RoomListSnapshot(e.target);
	trace("Here are the rooms on the server: " + snapshot.getRoomList());
	snapshot.removeEventListener(SnapshotEvent.LOAD, loadListener);
}
Global.usvr.reactor.updateSnapshot(snapshot);
*/
Global.usvr.reactor.getRoomManager().stopWatchingForRooms(UnionServer2.QUALIFIER);
Global.usvr.reactor.getRoomManager().watchForRooms(UnionServer2.QUALIFIER);
				}
			}
			//--------
		}

		// ----------------
		// showExplain
		// ----------------
		private function showExplain(tf:TextField):void
		{
			if (tf == mc.regist_txt)
			{
				mc.msg_txt.text = "ユーザ登録をするとセーブできるようになります。";
			}
			else if (tf == mc.start_txt)
			{
				mc.msg_txt.text = scenario.getBattleTypeName(scenario.no) + "を開始します。";
				if (isCoop)
				{
					mc.msg_txt.appendText("（協力戦）");
				}
			}
			else if (tf == mc.bgm_txt)
			{
				//mc.msg_txt.text = "ＢＧＭと効果音のＯＮ／ＯＦＦの切替をします。";
				mc.msg_txt.text = "ＢＧＭと効果音の設定をします。";
			}
			else if (tf == mc.item_txt)
			{
				mc.msg_txt.text = "破魔弓に勾玉を装備します。";
			}
			else if (tf == mc.yumi_txt)
			{
				mc.msg_txt.text = "破魔弓の能力を設定します。";
			}
			else if (tf == mc.coop_txt)
			{
				mc.msg_txt.text = "協力者を募集している妖魔退治に参加します。";
			}
			else if (tf == mc.coopCheck_txt)
			{
				mc.msg_txt.text = "○にして開始すると協力者を募集して妖魔退治をします。";
			}
			else if (tf == mc.chat_txt)
			{
				//mc.msg_txt.text = "神社でおみくじ、着替え、チャットができます。矢印キーで移動します。";
				mc.msg_txt.text = "神社でおみくじ、チャットができます。矢印キーで移動します。";
				if (0 < Global.itemTbl.getCount())
				{
					mc.msg_txt.text = "神社でおみくじ、チャット、着替え等ができます。矢印キーで移動します。";
				}
			}
			else if (tf == mc.report_txt)
			{
				mc.msg_txt.text = "妖魔界での妖魔の報告書を閲覧、提出します。";
			}
			else if (tf == mc.yakazuPlus_txt)
			{
				mc.msg_txt.text = "画面に表示できる矢の同時表示数を増やします。";
			}
			else if (tf == mc.yakazuMinus_txt)
			{
				mc.msg_txt.text = "画面に表示できる矢の同時表示数を減らします。";
			}
			else if (tf == mc.friend_txt)
			{
				mc.msg_txt.text = "";
			}
			
			if (tf == mc.status_txt)
			{
				var kind:int = scenario.bowKind[scenario.no];
				if (kind == Scenario.YUMI_HAMAYUMI)
				{
					mc.msg_txt.text = "破魔弓のレベルが一度に射る矢数になります。";
				}
			}
			
			//--------
			if (tf == boshuSettingMC.all_txt)
			{
				boshuSettingMC.msg_txt.text = "全レベルの協力者を対象にします。";
			}
			else if (tf == boshuSettingMC.near_txt)
			{
				boshuSettingMC.msg_txt.text = "レベルの近い協力者を対象にします。";
			}
			
			//--------
			showExplainFriend(tf);
			
			//--------
			showPlayerCnt();
		}

		// ----------------
		// clickScenario
		// ----------------
		public var lastSelectedScenerioNo:int = Scenario.KYUDO;		//報告書の選択状態クリアのために使う
		private function clickScenario(e:MouseEvent):void
		{
			var i:int, idx:int;

			for (i = 0; i < selectTf.length; i++)
			{
				if (e.target == selectTf[i].parent)
				{
					//--------
					Global.dailyQuestNo = 0;	//日刊クエストクリア
					//--------
					idx = selectPageNo * selectTf.length + i;
					scenario.no = scenario.getNo(idx);
					lastSelectedScenerioNo = scenario.no;
					mc.explain_txt.text = scenario.getExplain(idx);
					break;
				}
			}
			
			setSelecttedColor();
			
			showStatus();
		}
		private function setSelecttedColor():void
		{
			var i:int, idx:int;

			for (i = 0; i < selectTf.length; i++)
			{
				idx = selectPageNo * selectTf.length + i;
				if (scenario.no == scenario.getNo(idx))
				{
					selectTf[i].borderColor = 0xffffff;
					//selectTf[i].background = true;
					selectTf[i].border = true;
				}
				else
				{
					selectTf[i].borderColor = 0x9977bb;
					//selectTf[i].background = false;
					selectTf[i].border = false;
				}
			}
		}

		//アイテム画面を閉じたときに説明文更新用
		public function setScenarioExplain():void
		{
			var i:int, idx:int;
		
			for (i = 0; i < selectTf.length; i++)
			{
				idx = selectPageNo * selectTf.length + i;
				if (scenario.no == scenario.getNo(idx))
				{
					mc.explain_txt.text = scenario.getExplain(idx);
					break;
				}
			}
		}

		// ----------------
		// clickBackPage
		// ----------------
		private function clickBackPage(e:MouseEvent):void
		{
			selectPageNo--;
			if (selectPageNo < 0)
			{
				selectPageNo = 0;
			}
			refreshPage();
			setSelecttedColor();
		}

		// ----------------
		// clickNextPage
		// ----------------
		private function clickNextPage(e:MouseEvent):void
		{
			var maxPage:int = scenario.scenarioNo.length / 8;
			selectPageNo++;
			if (maxPage < selectPageNo)
			{
				selectPageNo = maxPage;
			}
			refreshPage();
			setSelecttedColor();
		}
		
		// ----------------
		// showNowPage
		// ----------------
		public function showNowPage():void
		{
			var i:int;
			for (i = 0; i < scenario.scenarioNo.length; i++)
			{
				if (scenario.no == scenario.scenarioNo[i])
				{
					selectPageNo = i / 8;
				}
			}
			
			showStatus();
			refreshPage();
			setSelecttedColor();
		}

		// ----------------
		// refreshPage
		// ----------------
		public function refreshPage():void
		{
			var i:int;
			var idx:int;
			var lineCnt:int = selectTf.length;

			//init
			for (i = 0; i < selectTf.length; i++)
			{
				selectTf[i].text = "";
				selectTf[i].visible = false;
			}
			
			mc.back_txt.visible = false;
			if (0 < selectPageNo)
			{
				mc.back_txt.visible = true;
			}
			
			mc.next_txt.visible = false;
			
			//--------
			//呪２の場合、選択できないステージを選択中になっていたら最終ステージにフォーカスを戻す
			if (Global.yumiSettingGamen.isNoroi2())
			{
				for (i = 0; i < lineCnt; i++)
				{
					idx = selectPageNo * lineCnt + i;
					if (scenario.no == scenario.getNo(idx))
					{
						break;
					}
				}
				if (Global.getMaxNoroi2StageIdx() < idx)
				{
					selectPageNo = Global.getMaxNoroi2StageIdx() / lineCnt;
					scenario.no = Global.scenario.scenarioNo[Global.getMaxNoroi2StageIdx()];
					setSelecttedColor();
				}
			}
			//--------
			
			if ((selectPageNo + 1) * lineCnt <= scenario.lastClearIndex + 1)
			{
				if ((selectPageNo + 1) * lineCnt <= scenario.scenarioNo.length - 1)
				{
					mc.next_txt.visible = true;
					
					//--------
					var sidx:int = (selectPageNo + 1) * lineCnt - 1;
					if (Scenario.isClear(scenario.getNo(sidx)) == false)
					{
						//報告書：全ての？がクリアされていない
						mc.next_txt.visible = false;
					}
					//--------
				}
			}
			//--------
			//呪２の場合の次ページ制御
			if (Global.yumiSettingGamen.isNoroi2())
			{
				if ((selectPageNo + 1) * lineCnt <= Global.getMaxNoroi2StageIdx())
				{
					//OK
				}
				else
				{
					mc.next_txt.visible = false;
				}
			}
			//--------
			
			//--------
			idx = 0;
			for (i = selectPageNo * lineCnt; i < scenario.getCount(); i++)
			{
				selectTf[idx].visible = false;
				if ((selectPageNo == 0) && (i == 0))
				{
					//最初のステージ（弓道）は表示
					selectTf[0].visible = true;
					selectTf[0].text = scenario.getName(0);
				}
				//else if (scenario.isClear(i - 1))
				else if (i <= scenario.lastClearIndex + 1)
				{
					//クリアした次のステージまで表示
					/*
					selectTf[idx].visible = true;
					selectTf[idx].text = scenario.getName(i);
					*/
					if (Scenario.isClear(scenario.getNo(i - 1)))
					{
						selectTf[idx].visible = true;
						selectTf[idx].text = scenario.getName(i);
					}
				}

				idx++;
				if (selectTf.length <= idx)
				{
					break;
				}
			}

			//--------
			for (i = 0; i < scenario.scenarioNo.length; i++)
			{
				if (scenario.no == scenario.scenarioNo[i])
				{
					mc.explain_txt.text = scenario.getExplain(i);
					break;
				}
			}
			
			//--------
			//メテオクリアで報告書表示
			mc.report_txt.visible = false;
			if (scenario.getStageIdx(Scenario.METEORITE) <= scenario.lastClearIndex)
			{
				mc.report_txt.visible = true;
			}
			//--------
			//呪2の場合の報告書クリア表示制御
			if (Global.yumiSettingGamen.isNoroi2())
			{
				mc.report_txt.visible = false;
				if (scenario.getStageIdx(Scenario.METEORITE) < Global.getMaxNoroi2StageIdx())
				{
					mc.report_txt.visible = true;
				}
			}
			//--------
			
			//--------
			//ゾンビまでいったら矢数設定表示
			if (scenario.getStageIdx(Scenario.ZOMBIE) <= scenario.lastClearIndex)
			{
				mc.yakazuPlus_txt.visible = true;
				mc.yakazuMinus_txt.visible = true;
				mc.yakazu_txt.visible = true;
			}
			else
			{
				mc.yakazuPlus_txt.visible = false;
				mc.yakazuMinus_txt.visible = false;
				mc.yakazu_txt.visible = false;
			}
			
			//--------
			mc.yakazu_txt.text = Arrow.maxArrowCnt;
			
			//--------
			//呪２はそのステージ以前を全てクリアしていないと非表示とする
			if (Global.yumiSettingGamen.isNoroi2())
			{
				/*
				var okMaxIdx:int = 8;	//鬼火Idx:8から開始。連続してどこまでクリアしているかチェック
				for (i = 0; i < Global.noroi2ClearTbl.getCount(); i++ )
				{
					if (idx == int(Global.noroi2ClearTbl.getData(i, "IDX")))
					{
						okMaxIdx++;
					}
					else
					{
						break;
					}
				}
				//ここでokMaxIdxのステージまで戦闘可能が決まる
				*/
				var okMaxIdx:int = Global.getMaxNoroi2StageIdx();
				
				idx = 0;
				for (i = selectPageNo * lineCnt; i < scenario.getCount(); i++)
				{
					if (i <= okMaxIdx)
					{
						selectTf[idx].visible = true;
						selectTf[idx].text = scenario.getName(i);
					}
					else
					{
						selectTf[idx].visible = false;
					}
					
					idx++;
					if (selectTf.length <= idx)
					{
						break;
					}
				}
			}
			//--------
		}
/*
		// ----------------
		// checkConnect
		// ----------------
		private function checkConnect()
		{
			try
			{
				if (Global.usvr.reactor.isReady())
				{
					//
				}
				else
				{
					mc.coopCheck_txt.visible = false;
					mc.coopText_txt.visible = false;
					mc.coop_txt.visible = false;
					mc.aikotoba_txt.visible = false;
					mc.chat_txt.visible = false;
				}
			}
			catch(e:Error){}
		}
*/
/*
		// ----------------
		// clickLevelUp
		// ----------------
		private function clickLevelUp(e:MouseEvent)
		{
//TEST
showStatus();
Hamayumi.exp++;
		}
*/
		// ----------------
		// showStatus
		// ----------------
		//private var isRcvNews:Boolean = false;	//更新前保存用
		//private var isMsgNews:Boolean = false;	//更新前保存用
		public function showStatus():void
		{
			var str:String = "";
			var kind:int = scenario.bowKind[scenario.no];
			var isLogin:Boolean = (0 < Global.userTbl.getCount());

			if (kind == Scenario.YUMI_NORMAL)
			{
				mc.coopCheck_txt.visible = false;
				mc.coopText_txt.visible = false;
				isCoop = false;
			}
			else if (kind == Scenario.YUMI_HAMAYUMI)
			{				
				if (isLogin)
				{
					mc.coopCheck_txt.visible = true;
					mc.coopText_txt.visible = true;
				}
			}
			
			//ウイリアム・テルをクリアしたなら常にレベル表示する
			if (scenario.getStageIdx(Scenario.TELL) <= scenario.lastClearIndex)
			{
				str += "破魔弓レベル：" + Hamayumi.level;
				if (Hamayumi.MAX_LEVEL <= Hamayumi.level)
				{
					str += "\n霊力：*****/*****";
				}
				else
				{
					str += "\n霊力：" + Hamayumi.exp;
					str += "/" + Hamayumi.needExp;
				}
				//--------
				if (isLogin)
				{
					if (0 < int(Global.userTbl.getData(0, "RELEASE")))
					{
						str += "\n霊銭：" + Global.userTbl.getData(0, "RELEASE") + "文";
					}
				}
				//--------
			}
			
			trace("##showStatus##" + scenario.getStageIdx(Scenario.TELL) + ":" + scenario.lastClearIndex)
			if ((isLogin) && (scenario.getStageIdx(Scenario.TELL) <= scenario.lastClearIndex))
			{
				mc.coop_txt.visible = true;
				mc.aikotoba_txt.visible = true;
				mc.friend_txt.visible = true;
			}
			else
			{
				mc.coop_txt.visible = false;
				mc.aikotoba_txt.visible = false;
				mc.friend_txt.visible = false;
			}
			
			//--------
			//新着チェック
			//isRcvNews = (Global.friendNewsTbl.getData(0, "RCV") == "1");
			//isMsgNews = (Global.friendNewsTbl.getData(0, "MSG") == "1");
			if (0 < Global.friendNewsTbl.getCount())
			{
				if ((Global.friendNewsTbl.getData(0, "MSG") == "1")
				||  (Global.friendNewsTbl.getData(0, "RCV") == "1"))
				{
					mc.friend_txt.textColor = Global.SELECTED_BORDER_COLOR;
					//mc.friend_txt.borderColor = Global.SELECTED_BORDER_COLOR;
				}
				else
				{
					mc.friend_txt.textColor = 0xffffff;
					//c.friend_txt.borderColor = 0x9977bb;
				}
			}
			//--------
			
			mc.status_txt.text = str;

			//--------
			mc.item_txt.visible = false;
			if ((isLogin) && (scenario.getStageIdx(Scenario.SHUTENDOUJI) <= scenario.lastClearIndex))
			{
				mc.item_txt.visible = true;
			}

			//--------
			mc.msg_txt.text = "";
			//Item.MAX_COUNT = Global.userTbl.getData(0, "ITEMCNT");
			trace("道具数:" + Global.itemTbl.getCount());
			if (Item.MAX_COUNT <= Global.itemTbl.getCount())
			{
				mc.msg_txt.text = "道具が一杯です。これ以上勾玉を取得できません。";
			}

			//--------
			setCoopCheck();
			
			//--------
			showPlayerCnt();
			
			//--------
			if (isLogin)
			{
				mc.chat_txt.visible = true;
			}
			else
			{
				mc.chat_txt.visible = false;
			}
			
			//--------
			//接続チェック
			//checkConnect();
			
			//--------
			mc.yumi_txt.visible = yumiSettingGamen.isShowHamayumiBtn();
		}

		// ----------------
		// showPlayerCnt
		// ----------------
		private function showPlayerCnt():void
		{
			mc.player_txt.text = "";
			try
			{
				var cnt:int = Global.usvr.getPlayerCnt();
				if (0 < cnt)
				{
					mc.player_txt.text = "プレイ中" + cnt + "人";
				}
			}
			catch(e:Error){}
		}

		// ----------------
		// setName
		// ----------------
		public function setName(str:String):void
		{
			mc.regist_txt.visible = false;
			mc.name_txt.text = str;
		}

		// ----------------
		// clickCoopCheck
		// ----------------
		public var isCoop:Boolean = false;
		private function clickCoopCheck(e:MouseEvent):void
		{
			isCoop = !isCoop;
			setCoopCheck();
			
			//協力戦がやりにくくなる、人がいないので不要かな。適正レベルでやりたければ合言葉か霊力抑制を改良しよう。
			/*
			if (isCoop)
			{
				boshuSettingMC.visible = true;
			}
			*/
		}
		private function setCoopCheck():void
		{
			if (isCoop)
			{
				mc.coopCheck_txt.text = "○";
			}
			else
			{
				mc.coopCheck_txt.text = "";
			}
		}

		// ----------------
		// clickBGM
		// ----------------
		private function clickBGM(e:MouseEvent):void
		{
			/*
			if (0.0 < Global.volume)
			{
				//mc.bgm_txt.text = "♪";
				Global.volume = 0.0;
				Global.stopBGM();
			}
			else
			{
				//mc.bgm_txt.text = "♪";
				Global.volume = 1.0;
				Global.playBGM();
			}
			*/
			Global.soundSettingGamen.visible = true;
		}

		// ----------------
		// setMsg
		// ----------------
		public function setMsg(msg:String):void
		{
			mc.msg_txt.text = msg;
		}

		// ----------------
		// clickYakazuPlus
		// ----------------
		private var isPressPlus:Boolean = false;
		private var isPressMinus:Boolean = false;
		private var pressCount:int = 0;
		public function clickYakazuPlus(e:MouseEvent):void
		{
			if (e.type == MouseEvent.CLICK)
			{
				Arrow.maxArrowCnt++;
			}
			else if (e.type == MouseEvent.MOUSE_DOWN)
			{
				isPressPlus = true;
				
				//イベント有効にする
				if (this.hasEventListener(Event.ENTER_FRAME) == false)
				{
					this.addEventListener(Event.ENTER_FRAME, enterFrame);
				}
			}
			else if (e.type == MouseEvent.MOUSE_UP)
			{
				isPressPlus = false;
				pressCount = 0;
				
				//イベント無効にする
				if (this.hasEventListener(Event.ENTER_FRAME))
				{
					this.removeEventListener(Event.ENTER_FRAME, enterFrame);
				}
			}
			
			mc.yakazu_txt.text = Arrow.maxArrowCnt;
		}
		// ----------------
		// clickYakazuMinus
		// ----------------
		public function clickYakazuMinus(e:MouseEvent):void
		{
			if (e.type == MouseEvent.CLICK)
			{
				Arrow.maxArrowCnt--;
			}
			else if (e.type == MouseEvent.MOUSE_DOWN)
			{
				isPressMinus = true;

				//イベント有効にする
				if (this.hasEventListener(Event.ENTER_FRAME) == false)
				{
					this.addEventListener(Event.ENTER_FRAME, enterFrame);
				}
			}
			else if (e.type == MouseEvent.MOUSE_UP)
			{
				isPressMinus = false;
				pressCount = 0;

				//イベント無効にする
				if (this.hasEventListener(Event.ENTER_FRAME))
				{
					this.removeEventListener(Event.ENTER_FRAME, enterFrame);
				}
			}
			
			mc.yakazu_txt.text = Arrow.maxArrowCnt;
		}

		// ----------------
		// enterFrame
		// ----------------
		private function enterFrame(e:Event):void
		{
trace("selectGamen:enterFrame");
			if (this.visible)
			{
				if (Global.halfFPS < pressCount)
				{
					if (isPressPlus)
					{
						Arrow.maxArrowCnt++;
						mc.yakazu_txt.text = Arrow.maxArrowCnt;
					}
					if (isPressMinus)
					{
						Arrow.maxArrowCnt--;
						mc.yakazu_txt.text = Arrow.maxArrowCnt;
					}
				}
				
				//mc.yakazu_txt.text = Arrow.maxArrowCnt;	//ここでは毎回TEXT更新で遅い？
				pressCount++;
			}
			else
			{
				if (this.hasEventListener(Event.ENTER_FRAME))
				{
					this.removeEventListener(Event.ENTER_FRAME, enterFrame);
				}
			}
		}

		// ----------------
		// clickHamayumi
		// ----------------
		private function clickHamayumi(e:MouseEvent):void
		{
			yumiSettingGamen.show();
		}
		
		// ----------------
		// decideBoshuSetting
		// ----------------
		public var boshuMinLv:int = 1;
		public var boshuMaxLv:int = Hamayumi.MAX_LEVEL;
		private function decideBoshuSetting(e:MouseEvent):void
		{
			//TEST
			boshuMinLv = int(boshuSettingMC.minLv_txt.text);
			boshuMaxLv = int(boshuSettingMC.maxLv_txt.text);
			
			//check
			if (boshuMaxLv < boshuMinLv)
			{
				boshuSettingMC.minLv_txt.text = "1";
				boshuSettingMC.maxLv_txt.text = "" + Hamayumi.MAX_LEVEL;
				return;
			}
			
			boshuSettingMC.visible = false;
		}

		// ----------------
		// clickAllLevel
		// ----------------
		private function clickAllLevel(e:MouseEvent):void
		{
			boshuSettingMC.minLv_txt.text = "1";
			boshuSettingMC.maxLv_txt.text = "" + Hamayumi.MAX_LEVEL;
		}
		
		// ----------------
		// clickNearLevel
		// ----------------
		private function clickNearLevel(e:MouseEvent = null):void
		{
			var _minLv:int = Hamayumi.level - 10;
			var _maxLv:int = Hamayumi.level + 10;
			
			if (_minLv < 1)
			{
				_minLv = 1;
			}
			if (Hamayumi.MAX_LEVEL < _maxLv)
			{
				_maxLv = Hamayumi.MAX_LEVEL;
			}
			
			boshuSettingMC.minLv_txt.text = String(_minLv);
			boshuSettingMC.maxLv_txt.text = String(_maxLv);
		}
		public function initSettingNearLevel():void
		{
			//20141118 デフォルトは全レベルに変更、でレベル設定はいらないかな
			//clickNearLevel();
		}
		
		//****************
		private var selectedFriendIdx:int = -1;
		private var selectedFriend:String = "";
		private var friendMode:String = "";
		private var friendMsg:String = "";
		// ----------------
		// initFriendMC
		// ----------------
		private function initFriendMC():void
		{
			var i:int; 
			
			friendListTf = Vector.<TextField>
			([
				 friendMC.list01_txt
				,friendMC.list02_txt
				,friendMC.list03_txt
				,friendMC.list04_txt
				,friendMC.list05_txt
				,friendMC.list06_txt
				,friendMC.list07_txt
				,friendMC.list08_txt
				,friendMC.list09_txt
				,friendMC.list10_txt
			]);
			for (i = 0; i < friendListTf.length; i++ )
			{
				addSpriteBtn(friendListTf[i], clickFriendList, false, friendMC);
				friendListTf[i].text = "";
			}
			addSpriteBtn(friendMC.tab01_txt, clickFriendTab01, false, friendMC);
			addSpriteBtn(friendMC.tab02_txt, clickFriendTab02, false, friendMC);
			addSpriteBtn(friendMC.tab03_txt, clickFriendTab03, false, friendMC);
			addSpriteBtn(friendMC.close_txt, clickFriendClose, false, friendMC);
			//addSpriteBtn(friendMC.make_txt, clickFriendMake, false, friendMC);
			addSpriteBtn(friendMC.add_txt, clickFriendAdd, false, friendMC);
			addSpriteBtn(friendMC.ok_txt, clickFriendOk, false, friendMC);
			addSpriteBtn(friendMC.delete_txt, clickFriendDelete, false, friendMC);
			addSpriteBtn(friendMC.send_txt, clickFriendSend, false, friendMC);
			addSpriteBtn(friendConfirmMC.yes_txt, clickFriendYes, false, friendConfirmMC);
			addSpriteBtn(friendConfirmMC.no_txt, clickFriendNo, false, friendConfirmMC);
			friendMC.friend_txt.backgroundColor = 0xCCB3DD;// Global.BUTTON_NORMAL_COLOR;
			//friendMC.friend_txt.textColor = 0xffffff;
			friendMC.sndmsg_txt.backgroundColor = 0xCCB3DD;// Global.BUTTON_SELECT_COLOR;
			friendMC.rcvmsg_txt.backgroundColor = 0xCCB3DD;// Global.BUTTON_SELECT_COLOR;
			friendMC.friend_txt.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { showExplain(friendMC.friend_txt); } );
			
			addSpriteBtn(friendMC.back_txt, clickFriendBack, false, friendMC);
			addSpriteBtn(friendMC.next_txt, clickFriendNext, false, friendMC);
			
			friendMC.sndmsg_txt.text = "";
			friendMC.rcvmsg_txt.text = "";
			clickFriendTab01();
			addChild(friendMC);
			addChild(friendConfirmMC);
			friendMC.visible = false;
			friendConfirmMC.visible = false;
		}
		// ----------------
		// clickFriend
		// ----------------
		private var onlinePlayer:Vector.<String>;
		private function clickFriend(e:MouseEvent):void
		{
			showFriendMC();
			loadFriend();
			
			//--------
			onlinePlayer = Global.usvr.getOnlinePlayerName();
			//--------
		}
		private var fc:FriendConnect = new FriendConnect();
		//private function loadFriend():void
		private function loadFriend(isNewsUpdate:Boolean = false):void
		{
			var obj:Object = new Object();
			obj.name = Global.username;
			obj.friend = "";
			obj.msg = "";
			obj.type = "r";
			
			obj.check = "0";
			/*
			if (0 < Global.friendNewsTbl.getCount())
			{
				if ((Global.friendNewsTbl.getData(0, "MSG") == "1")
				||  (Global.friendNewsTbl.getData(0, "RCV") == "1"))
				{
					obj.check = "1";
				}
			}
			*/

			if (isNewsUpdate)
			{
				obj.check = "1";
			}
			
			fc.connect(obj, friendOK);
		}
		// ----------------
		// friendOK
		// ----------------
		private function friendOK(bool:Boolean):void
		{
			if (bool)
			{
				showFriendList();
				
				if (friendMode == "s")
				{
					friendMC.sndmsg_txt.text = "";
					friendMC.msg_txt.text = "送信しました。";
				}
				else if (friendMode == "a")
				{
					friendMC.sndmsg_txt.text = "";
					friendMC.msg_txt.text = "申請しました。";
				}
				friendMode = "";	//init
				
				friendMC.ok_txt.visible = false;
				friendMC.delete_txt.visible = false;
				//selectedFriendIdx = -1;
				
				/*
				if (isTab02Click)
				{
					isTab02Click = false;
					//showRcvMsg();
					tab02ClickTime = (new Date()).getTime();
					showNewsTabColor();
				}
				*/
				showNewsTabColor();
				showRcvMsg();
			}
			else
			{
				friendMC.msg_txt.text = fc.message;
			}
		}
		// ----------------
		// showFriendList
		// ----------------
		private var friendNowPage:int = 0;
		private var friendTblIdxList:Vector.<int> = new Vector.<int>
		private function showFriendList():void
		{
			var i:int, m:int;
			var idx:int;
			var len:int;
			var str:String = "";
			var lineCnt:int = friendListTf.length;
			
			showFriendListPage();
			
			//init
			len = friendListTf.length;
			for (i = 0; i < len; i++ )
			{
				friendListTf[i].text = "";
				friendListTf[i].borderColor = Global.BUTTON_SELECT_COLOR;
				
				friendListTf[i].textColor = 0xffffff;
			}
			len = int(Global.friendTbl.getCount() / lineCnt + 1) * lineCnt;
			for (i = 0; i < len; i++ )
			{
				friendTblIdxList[i] = -1;
			}

			//--------
			var friendList:Vector.<String> = new Vector.<String>;
			if ((friendMC.tab01_txt.borderColor == Global.SELECTED_BORDER_COLOR)
			||  (friendMC.tab02_txt.borderColor == Global.SELECTED_BORDER_COLOR))
			{
				len = Global.friendTbl.getCount();
				for (i = 0; i < len; i++ )
				{
					if (Global.friendTbl.getData(i, "FLAG") == "0")
					{
						friendTblIdxList[friendList.length] = i;
						friendList.push(Global.friendTbl.getData(i, "FRIEND"));
					}
				}
			}
			else if (friendMC.tab03_txt.borderColor == Global.SELECTED_BORDER_COLOR)
			{
				len = Global.friendTbl.getCount();
				for (i = 0; i < len; i++ )
				{
					if (Global.friendTbl.getData(i, "FLAG") == "0")
					{
						friendTblIdxList[friendList.length] = i;
						friendList.push(Global.friendTbl.getData(i, "FRIEND"));
					}
					else if (Global.friendTbl.getData(i, "FLAG") == "1")
					{
						friendTblIdxList[friendList.length] = i;
						friendList.push("[申請受信]" + Global.friendTbl.getData(i, "FRIEND"));
					}
					else if (Global.friendTbl.getData(i, "FLAG") == "2")
					{
						friendTblIdxList[friendList.length] = i;
						friendList.push("[申請送信]" + Global.friendTbl.getData(i, "FRIEND"));
					}
				}
			}
			
			for (i = 0; i < friendListTf.length; i++ )
			{
				if (friendList.length <= (friendNowPage * lineCnt) + i)
				{
					break;
				}
				friendListTf[i].text = "" + friendList[(friendNowPage * lineCnt) + i];
			}
			
			if (0 <= selectedFriendIdx)
			{
				//friendListTf[selectedFriendIdx].borderColor = Global.SELECTED_BORDER_COLOR;
				friendListTf[selectedFriendIdx % lineCnt].borderColor = Global.SELECTED_BORDER_COLOR;
			}
			//--------
			
			//--------
			//オンラインプレイヤーチェック
			if (Global.usvr)
			{
				//var onlinePlayer:Vector.<String> = Global.usvr.getOnlinePlayerName();
				for (i = 0; i < friendListTf.length; i++ )
				{
					for (m = 0; m < onlinePlayer.length; m++ )
					{
						if (friendListTf[i].text == onlinePlayer[m])
						{
							friendListTf[i].textColor = Global.SELECTED_BORDER_COLOR;
						}
					}
				}
			}
			//--------
			
			/*
			//room list
			idx = 0;
			len = Global.friendTbl.getCount();
			for (i = 0; i < len; i++ )
			{
				if (friendListTf.length <= i)
				{
					break;
				}
				//friendListTf[i].text = Global.friendTbl.getData(i, "FRIEND");
				if (Global.friendTbl.getData(i, "FLAG") == "0")
				{
					friendListTf[idx].text = "" + Global.friendTbl.getData(i, "FRIEND");
					friendTblIdxList[idx] = i;
					idx++;
				}
				else if (Global.friendTbl.getData(i, "FLAG") == "1")
				{
					if (friendMC.tab03_txt.borderColor == Global.SELECTED_BORDER_COLOR)
					{
						friendListTf[idx].text = "[申請受信]" + Global.friendTbl.getData(i, "FRIEND");
						friendTblIdxList[idx] = i;
						idx++;
					}
				}
				else if (Global.friendTbl.getData(i, "FLAG") == "2")
				{
					if (friendMC.tab03_txt.borderColor == Global.SELECTED_BORDER_COLOR)
					{
						friendListTf[idx].text = "[申請送信]" + Global.friendTbl.getData(i, "FRIEND");
						friendTblIdxList[idx] = i;
						idx++;
					}
				}
			}

			if (0 <= selectedFriendIdx)
			{
				friendListTf[selectedFriendIdx].borderColor = Global.SELECTED_BORDER_COLOR;
			}
			*/
			
			/*
			//room msg
			len = Global.friendMsgTbl.getCount();
			str = "";
			for (i = 0; i < len; i++ )
			{
				idx = len - i - 1;
				if (selectedFriend == Global.friendMsgTbl.getData(idx, "NAME"))
				{
					str += Global.friendMsgTbl.getData(idx, "DATE") + " ";
					str += Global.friendMsgTbl.getData(idx, "FRIEND") + "\n";
					str += Global.friendMsgTbl.getData(idx, "MSG") + "\n\n";
				}
			}
			friendMC.sndmsg_txt.text = str;
			*/
			//friendMC.sndmsg_txt.text = "";
			
			//friendMC.txt_scroll.update();
			//friendMC.txt_scroll.scrollPosition = friendMC.txt_scroll.maxScrollPosition;
		}
		
		private function showRcvMsg():void
		{
			var i:int;
			var len:int;
			var str:String = "";
			
			friendMC.rcvmsg_txt.text = "";
			
			len = Global.friendMsgTbl.getCount();
			for (i = 0; i < len; i++ )
			{
				if (selectedFriend == Global.friendMsgTbl.getData(i, "NAME"))
				{
					str += Global.friendMsgTbl.getData(i, "DATE") + " ";
					str += Global.friendMsgTbl.getData(i, "NAME") + "\n";
					str += Global.friendMsgTbl.getData(i, "MSG") + "\n\n";
				}
			}
			
			friendMC.rcvmsg_txt.text = str;
			
			friendMC.txt_scroll.update();
			friendMC.txt_scroll.scrollPosition = friendMC.txt_scroll.maxScrollPosition;
		}
		//----------------
		//showFriendMC
		//----------------
		private function showFriendMC():void
		{
			friendMC.visible = true;
			mc.visible = false;
			friendMC.msg_txt.text = "";
			
			//tab02ClickTime = (new Date()).getTime();
			
			//--------
			//新着チェック
			/*
			if (Global.friendNewsTbl.getData(0, "RCV") == "1")
			{
				friendMC.tab03_txt.textColor = Global.SELECTED_BORDER_COLOR;
				//friendMC.tab03_txt.borderColor = Global.SELECTED_BORDER_COLOR;
			}
			else
			{
				friendMC.tab03_txt.textColor = 0xffffff;
				//friendMC.tab03_txt.borderColor = 0x9977bb;
			}
			if (Global.friendNewsTbl.getData(0, "MSG") == "1")
			{
				friendMC.tab02_txt.textColor = Global.SELECTED_BORDER_COLOR;
				//friendMC.tab02_txt.borderColor = Global.SELECTED_BORDER_COLOR;
			}
			else
			{
				friendMC.tab02_txt.textColor = 0xffffff;
				//friendMC.tab02_txt.borderColor = 0x9977bb;
			}
			*/
			showNewsTabColor();
			//--------
		}
		private function showNewsTabColor():void
		{
			//新着チェック
			if (0 < Global.friendNewsTbl.getCount())
			{
				if (Global.friendNewsTbl.getData(0, "RCV") == "1")
				{
					friendMC.tab03_txt.textColor = Global.SELECTED_BORDER_COLOR;
				}
				else
				{
					friendMC.tab03_txt.textColor = 0xffffff;
				}

				if (Global.friendNewsTbl.getData(0, "MSG") == "1")
				{
					friendMC.tab02_txt.textColor = Global.SELECTED_BORDER_COLOR;
				}
				else
				{
					friendMC.tab02_txt.textColor = 0xffffff;
				}
			}
		}
		private function clickFriendClose(e:MouseEvent):void
		{
			/*
			//clear　フレンド画面表示中にメッセージ受け取ると新着フラグが立つので閉じるときに消す。→そもそもメッセージを表示したかのフラグのほうがよい
			Global.friendNewsTbl = new Table(Global.FRIEND_NEWS_TABLE, "0,0|", false);
			*/
			//→制御が複雑なのでフレンド画面表示中の更新はなしとする
			
			friendMC.visible = false;
			mc.visible = true;
			showStatus();
			
			loadFriend(true);	//新着強制OFF更新
			mc.friend_txt.textColor = 0xffffff;	//非同期なので無効色に強制的にしとく
		}
		//----------------
		//clickFriendList
		//----------------
		private function clickFriendList(e:MouseEvent):void
		{
			var i:int;
			var idx:int;
			var lineCnt:int = friendListTf.length;

			for (i = 0; i < friendListTf.length; i++ )
			{
				if (e.target == friendListTf[i].parent)
				{
					if (Global.friendTbl.getCount() <= i)
					{
						break;
					}
					//selectedFriendIdx = i;
					selectedFriendIdx = (friendNowPage * lineCnt) + i;
					idx = friendTblIdxList[selectedFriendIdx];
					if (idx < 0)
					{
						continue;
					}
					selectedFriend = Global.friendTbl.getData(idx, "FRIEND");
					showFriendList();
					showRcvMsg();
					
					//--------
					if (friendMC.tab01_txt.borderColor == Global.SELECTED_BORDER_COLOR)
					{
						friendMC.msg_txt.text = selectedFriend + " 最終ログイン日時 " + Global.friendTbl.getData(idx, "LOGIN");
						if (friendListTf[i].textColor == Global.SELECTED_BORDER_COLOR)
						{
							friendMC.msg_txt.appendText(" オンライン");
						}
					}
					//--------
					
					if (friendMC.tab03_txt.borderColor == Global.SELECTED_BORDER_COLOR)
					{
						if (Global.friendTbl.getData(idx, "FLAG") == "0")
						{
							friendMC.msg_txt.text = "";
							friendMC.ok_txt.visible = false;
							friendMC.delete_txt.visible = true;
						}
						else if (Global.friendTbl.getData(idx, "FLAG") == "1")
						{
							friendMC.msg_txt.text = "フレンド申請を受信しています。承認するとフレンド登録されます。";
							friendMC.ok_txt.visible = true;
							friendMC.delete_txt.visible = false;
						}
						else if (Global.friendTbl.getData(idx, "FLAG") == "2")
						{
							friendMC.msg_txt.text = "フレンド申請を送信しています。相手が承認するとフレンド登録されます。";
							friendMC.ok_txt.visible = false;
							friendMC.delete_txt.visible = true;
						}
					}
					
					break;
				}
			}
		}
		//----------------
		//clickFriendSend
		//----------------
		private function clickFriendSend(e:MouseEvent):void
		{
			if (selectedFriendIdx < 0)
			{
				friendMC.msg_txt.text = "フレンド一覧から送信相手を選択してください。";
				return;
			}
			if (friendMC.sndmsg_txt.length <= 0)
			{
				friendMC.msg_txt.text = "送信するメッセージを入力してください。";
				return;
			}
			if (Global.friendTbl.getData(selectedFriendIdx, "STATUS") == "1")
			{
				friendMC.msg_txt.text = "フレンド承認していない相手には送れません。";
				return;
			}
			if (Global.friendTbl.getData(selectedFriendIdx, "STATUS") == "2")
			{
				friendMC.msg_txt.text = "フレンド申請中の相手には送れません。";
				return;
			}

			friendConfirmMC.visible = true;
			friendConfirmMC.msg_txt.text = selectedFriend + "\nにメッセージを送ります。\nよろしいですか？"
			
			//selectedFriend = friendMC.friend_txt.text;
			friendMsg = friendMC.sndmsg_txt.text;
			friendMode = "s";
		}
		//----------------
		//clickFriendAdd
		//----------------
		private function clickFriendAdd(e:MouseEvent):void
		{
			if (friendMC.friend_txt.text.length <= 0)
			{
				friendMC.msg_txt.text = "フレンド申請したいユーザ名を入力してください。";
				return;
			}
			if (Global.username == friendMC.friend_txt.text)
			{
				friendMC.msg_txt.text = "自分にはフレンド申請できません。";
				return;
			}
			
			friendConfirmMC.visible = true;
			friendConfirmMC.msg_txt.text = friendMC.friend_txt.text + "\nにフレンド申請します。\nよろしいですか？"
			
			selectedFriend = friendMC.friend_txt.text;
			friendMsg = "";
			friendMode = "a";
		}
		//----------------
		//clickFriendOk
		//----------------
		private function clickFriendOk(e:MouseEvent):void
		{
			if (selectedFriendIdx < 0)
			{
				friendMC.msg_txt.text = "";
				return;
			}
			if (Global.friendTbl.getData(selectedFriendIdx, "FLAG") == "0")
			{
				friendMC.msg_txt.text = "フレンド承認済みです。";
				return;
			}
			if (Global.friendTbl.getData(selectedFriendIdx, "FLAG") == "2")
			{
				friendMC.msg_txt.text = "フレンド申請中です。相手が承認するまでお待ちください。";
				return;
			}

			friendConfirmMC.visible = true;
			friendConfirmMC.msg_txt.text = selectedFriend + "\nのフレンド申請を承認します。\nよろしいですか？"
			
			//selectedFriend = friendMC.friend_txt.text;
			friendMsg = "";
			friendMode = "a";
		}
		//----------------
		//clickFriendYes
		//----------------
		private function clickFriendYes(e:MouseEvent):void
		{
			friendConfirmMC.visible = false;
			
			var obj:Object = new Object();
			obj.name = Global.username;
			obj.friend = selectedFriend;
			obj.msg = friendMsg;
			obj.type = friendMode;// "a";
			
			//--------
			//送信でフレンド設定新着フラグが立ってしまうので1で更新する
			if (friendMode == "s")
			{
				obj.check = "1";
			}
			//--------
			
			fc.connect(obj, friendOK);
		}
		//----------------
		//clickFriendNo
		//----------------
		private function clickFriendNo(e:MouseEvent):void
		{
			friendConfirmMC.visible = false;
		}
		//----------------
		//clickFriendDelete
		//----------------
		private function clickFriendDelete(e:MouseEvent):void
		{
			if (selectedFriendIdx < 0)
			{
				friendMC.msg_txt.text = "";
				return;
			}
			
			friendConfirmMC.visible = true;
			friendConfirmMC.msg_txt.text = selectedFriend + "\nのフレンド登録を削除します。\nよろしいですか？"
			
			//selectedFriend = friendMC.friend_txt.text;
			friendMsg = "";
			friendMode = "d";
		}
		//----------------
		//clickFriendTab01
		//----------------
		private function clickFriendTab01(e:MouseEvent = null):void
		{
			friendMC.title2_txt.visible = false;
			friendMC.friend_txt.visible = false;
			friendMC.add_txt.visible = false;
			friendMC.ok_txt.visible = false;
			friendMC.delete_txt.visible = false;
			friendMC.sndmsg_txt.visible = true;
			friendMC.rcvmsg_txt.visible = false;
			friendMC.txt_scroll.visible = false;
			friendMC.send_txt.visible = true;
			friendMC.sndmsg_txt.y = 80;
			friendMC.send_txt.y = 185;
			
			friendNowPage = 0;
			
			//selectedFriendIdx = -1;
			if (friendMC.tab01_txt.borderColor == Global.SELECTED_BORDER_COLOR)
			{
				//同じタブならそのまま
			}
			else
			{
				friendMC.tab01_txt.borderColor = Global.SELECTED_BORDER_COLOR;
				friendMC.tab02_txt.borderColor = 0x9977bb;
				friendMC.tab03_txt.borderColor = 0x9977bb;
			
				//デフォルトで一番上を選択
				if ((0 < Global.friendTbl.getCount()) && (0 <= friendTblIdxList[0]))
				{
					selectedFriendIdx = 0;
					selectedFriend = Global.friendTbl.getData(friendTblIdxList[0], "FRIEND");
				}
				else
				{
					selectedFriendIdx = -1;
					selectedFriend = "";
					//showFriendList();
				}
				showFriendList();
			}
		}
		//----------------
		//clickFriendTab02
		//----------------
		//private var isTab02Click:Boolean = false;
		//private var tab02ClickTime:Number = 0;
		private function clickFriendTab02(e:MouseEvent):void
		{
			friendMC.title2_txt.visible = true;
			friendMC.friend_txt.visible = false;
			friendMC.add_txt.visible = false;
			friendMC.ok_txt.visible = false;
			friendMC.delete_txt.visible = false;
			friendMC.sndmsg_txt.visible = false;
			friendMC.rcvmsg_txt.visible = true;
			friendMC.txt_scroll.visible = true;
			friendMC.send_txt.visible = false;
			friendMC.rcvmsg_txt.y = 80;
			friendMC.txt_scroll.y = 80;
			
			friendNowPage = 0;

			if (friendMC.tab02_txt.borderColor == Global.SELECTED_BORDER_COLOR)
			{
				//同じタブならそのまま
			}
			else
			{
				friendMC.tab01_txt.borderColor = 0x9977bb;
				friendMC.tab02_txt.borderColor = Global.SELECTED_BORDER_COLOR;
				friendMC.tab03_txt.borderColor = 0x9977bb;

				//デフォルトで一番上を選択
				if ((0 < Global.friendTbl.getCount()) && (0 <= friendTblIdxList[0]))
				{
					selectedFriendIdx = 0;
					selectedFriend = Global.friendTbl.getData(friendTblIdxList[0], "FRIEND");
					showRcvMsg();
				}
				else
				{
					selectedFriendIdx = -1
					selectedFriend = "";
					//showFriendList();
				}
				showFriendList();
			}

			/*
			//60秒以上たったら更新(この画面内で)
			if (tab02ClickTime + 60000 < (new Date()).getTime())
			{
				isTab02Click = true;
				loadFriend(true);
			}
			*/
		}
		//----------------
		//clickFriendTab03
		//----------------
		private function clickFriendTab03(e:MouseEvent):void
		{
			friendMC.title2_txt.visible = false;
			friendMC.friend_txt.visible = true;
			friendMC.add_txt.visible = true;
			friendMC.ok_txt.visible = false;
			friendMC.delete_txt.visible = false;
			friendMC.sndmsg_txt.visible = false;
			friendMC.rcvmsg_txt.visible = false;
			friendMC.txt_scroll.visible = false;
			friendMC.send_txt.visible = false;
			friendMC.rcvmsg_txt.y = 80;
			friendMC.txt_scroll.y = 80;
			
			friendNowPage = 0;
			
			//selectedFriendIdx = -1;
			if (friendMC.tab03_txt.borderColor == Global.SELECTED_BORDER_COLOR)
			{
				//同じタブならそのまま
			}
			else
			{
				friendMC.tab01_txt.borderColor = 0x9977bb;
				friendMC.tab02_txt.borderColor = 0x9977bb;
				friendMC.tab03_txt.borderColor = Global.SELECTED_BORDER_COLOR;
			
				//デフォルトで一番上を選択
				if ((0 < Global.friendTbl.getCount()) && (0 <= friendTblIdxList[0]))
				{
					selectedFriendIdx = 0;
					selectedFriend = Global.friendTbl.getData(friendTblIdxList[0], "FRIEND");
				}
				else
				{
					selectedFriendIdx = -1;
					selectedFriend = "";
					//showFriendList();
				}
				showFriendList();
			}
		}
		//----------------
		//showExplainFriend
		//----------------
		private function showExplainFriend(tf:TextField):void
		{
			var i:int;
			
			if (tf == friendMC.tab01_txt)
			{
				friendMC.msg_txt.text = "フレンドにメッセージを送ります。フレンド申請して承認されないとメッセージは送れません。";
			}
			else if (tf == friendMC.tab02_txt)
			{
				friendMC.msg_txt.text = "受信したメッセージを確認します。";
			}
			else if (tf == friendMC.tab03_txt)
			{
				friendMC.msg_txt.text = "フレンド登録の申請、承認、解除を行います。フレンド申請を確認します。";
			}
			/*
			else if (tf == friendMC.ok_txt)
			{
				friendMC.msg_txt.text = "4";
			}
			else if (tf == friendMC.delete_txt)
			{
				friendMC.msg_txt.text = "4";
			}
			*/
			else if (tf == friendMC.friend_txt)
			{
				friendMC.msg_txt.text = "フレンド登録を申請したいユーザ名を入力して[フレンド申請]ボタンを押下してください。";
			}
			
			/*
			for (i = 0; i < friendListTf.length; i++ )
			{
				if (tf == friendListTf[i])
				{
					friendMC.msg_txt.text = "" + i;
				}
			}
			*/
		}
		
		//----------------
		//clickFriendBack
		//----------------
		private function clickFriendBack(e:MouseEvent):void
		{
			friendNowPage--;
			selectedFriendIdx = -1;
			selectedFriend = "";
			showFriendList();
		}
		//----------------
		//clickFriendNext
		//----------------
		private function clickFriendNext(e:MouseEvent):void
		{
			friendNowPage++;
			selectedFriendIdx = -1;
			selectedFriend = "";
			showFriendList();
		}
		//----------------
		//showFriendListPage
		//----------------
		private function showFriendListPage():void
		{
			var len:int = 0;
			var lineCnt:int = friendListTf.length;
			
			if (friendMC.tab01_txt.borderColor == Global.SELECTED_BORDER_COLOR)
			{
				len = getFriendCnt();
			}
			if (friendMC.tab02_txt.borderColor == Global.SELECTED_BORDER_COLOR)
			{
				len = getFriendCnt();
			}
			if (friendMC.tab03_txt.borderColor == Global.SELECTED_BORDER_COLOR)
			{
				len = Global.friendTbl.getCount();
			}
			
			var maxPage:int = int((len - 1) / lineCnt);
			
			if (friendNowPage < 0)
			{
				friendNowPage = 0;
			}
			if (maxPage < friendNowPage)
			{
				friendNowPage = maxPage;
			}

			friendMC.title1_txt.text = "フレンド一覧 " + (friendNowPage + 1) + "/" + (maxPage + 1); 
		}
		//----------------
		//getFriendCnt
		//----------------
		private function getFriendCnt():int
		{
			var i:int;
			var cnt:int = 0;
			var len:int = Global.friendTbl.getCount();
			for (i = 0; i < len; i++ )
			{
				if (Global.friendTbl.getData(i, "FLAG") == "0")
				{
					cnt++;
				}
			}
			
			return cnt;
		}
		//****************
	}

}