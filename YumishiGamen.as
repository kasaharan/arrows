package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author kasaharan
	 */
	public class YumishiGamen extends Sprite
	{
		private var yumishiGamenMC:MovieClip;
		private var itemGamenMC:MovieClip;
		private var abilityTf:Vector.<TextField>;
		private var itemTf:Vector.<TextField>;
		private var kyokaConfirm:ConfirmGamen = new ConfirmGamen(new ConfirmMC(), clickYes);
		private var explain:Dictionary = new Dictionary();
		
		public function YumishiGamen()
		/*
		(
			_mc:MovieClip,
			_itemGamenMC:MovieClip,
		)
		*/
		{
			var i:int, k:int;

			//yumishiGamenMC = _mc;
			//itemGamenMC = _itemGamenMC;
			yumishiGamenMC = new YumishiGamenMC();
			itemGamenMC = new MixGamenMC();
			
			addChild(yumishiGamenMC);
			addChild(itemGamenMC);
			itemGamenMC.visible = false;

			abilityTf = Vector.<TextField>
			([
				 yumishiGamenMC.item01_txt
				,yumishiGamenMC.item02_txt
				,yumishiGamenMC.item03_txt
				,yumishiGamenMC.item04_txt
				,yumishiGamenMC.item05_txt
				,yumishiGamenMC.item06_txt
				,yumishiGamenMC.item07_txt
				,yumishiGamenMC.item08_txt
				,yumishiGamenMC.item09_txt
				,yumishiGamenMC.item10_txt
				,yumishiGamenMC.item11_txt
				,yumishiGamenMC.item12_txt
				,yumishiGamenMC.item13_txt
				,yumishiGamenMC.item14_txt
				,yumishiGamenMC.item15_txt
				,yumishiGamenMC.item16_txt
				,yumishiGamenMC.item17_txt
				,yumishiGamenMC.item18_txt
				,yumishiGamenMC.item19_txt
				,yumishiGamenMC.item20_txt
				,yumishiGamenMC.item21_txt
				,yumishiGamenMC.item22_txt
				,yumishiGamenMC.item23_txt
				,yumishiGamenMC.item24_txt
				/*
				,mc.item21_txt
				,mc.item22_txt
				,mc.item23_txt
				,mc.item24_txt
				,mc.item25_txt
				,mc.item26_txt
				,mc.item27_txt
				,mc.item28_txt
				,mc.item29_txt
				,mc.item30_txt
				*/
			]);
			for (i = 0; i < abilityTf.length; i++)
			{
				addSpriteBtn(yumishiGamenMC, abilityTf[i], clickKyokaItem);
				abilityTf[i].border = false;
				abilityTf[i].borderColor = 0xffffff;
			}

			addSpriteBtn(yumishiGamenMC, yumishiGamenMC.close_txt, function():void { close(); } );
			addSpriteBtn(yumishiGamenMC, yumishiGamenMC.decide_txt, clickDecideKyoka);
			
			addChild(kyokaConfirm);
			kyokaConfirm.visible = false;
			kyokaConfirm.setMessage("破魔弓を強化して\n選択した能力を付加します。\nよろしいですか？");
			
			//--------
			explain["EXP5"] = "妖魔討伐時の霊力を勾玉に変換する力を効率化します。\n勾玉に変換しても５％の霊力を得ることができます。";
			explain["EXP10"] = "妖魔討伐時の霊力を勾玉に変換する力を効率化します。\n勾玉に変換しても１０％の霊力を得ることができます。";
			explain["EXP15"] = "妖魔討伐時の霊力を勾玉に変換する力を効率化します。\n勾玉に変換しても１５％の霊力を得ることができます。";
			explain["EXP20"] = "妖魔討伐時の霊力を勾玉に変換する力を効率化します。\n勾玉に変換しても２０％の霊力を得ることができます。";
			explain["EXP25"] = "妖魔討伐時の霊力を勾玉に変換する力を効率化します。\n勾玉に変換しても２５％の霊力を得ることができます。";
			explain["HP"] = "戦闘中に妖魔の体力が確認できるようになります。\n破魔弓画面で有効／無効の切替ができます。";
			//explain["DOCHO"] = "協力戦の参加者(一番低いレベル)と同じ勾玉、同レベルに同調し霊力の乱れを無くします。同調効果で装備中の勾玉のレベルアップが可能となります。";
			//explain["DOCHO"] = "協力戦で戦闘参加に必要な最小レベルにまで下げることで霊力の乱れをより小さくします。抑制効果で装備中の勾玉のレベルアップが可能となります。";
			//explain["DOCHO"] = "協力戦参加者の一番低いレベルに自レベルを同調し霊力の乱れを無くします。同調効果で装備中の勾玉のレベルアップが可能となります。(有効/無効の切替可)";
			explain["DOCHO"] = "協力戦で矢数を抑制します。抑制効果で装備中の勾玉のレベルアップが可能となります。妖魔によって矢数は変わります。(有効/無効の切替可)";
			//explain["DOCHO"] = "一番低いレベルの協力戦参加者とのレベル差に応じて矢数を抑制します。抑制効果で装備中の勾玉のレベルアップが可能となります。(有効/無効の切替可)";
			
			explain["NOROI"] = "[呪]の勾玉の力を破魔弓に埋め込み、[呪]の効果を破魔弓に付加します。\n破魔弓画面で有効／無効の切替ができます。";
			
			explain["TADAN2"] = "破魔弓を強化して貫通矢の霊力を上げ、貫通する間に２度ヒットさせます。\n破魔弓画面で有効／無効の切替ができます。";
			explain["TADAN3"] = "破魔弓を強化して貫通矢の霊力を上げ、貫通する間に３度ヒットさせます。\n破魔弓画面で有効／無効の切替ができます。";
			
			explain["SELECT"] = "破魔弓を強化して霊力の識別能力を上げ、協力戦を選べるようにします。\n破魔弓画面で有効／無効の切替ができます。";
			
			explain["YUMI2"] = "弓を引くのに二人分の霊力が必要とされる破魔弓に強化します。(矢の威力４倍、矢数半減、飛と速と密の勾玉効果半減)(有効/無効の切替可)";
			explain["YUMI3"] = "弓を引くのに三人分の霊力が必要とされる破魔弓に強化します。(矢の威力８倍、矢数３分の１、飛と速と密の勾玉効果３分の１)(有効/無効の切替可)";

			explain["LIGHT"] = "破魔矢の波長を微妙に変化させ続け、光の屈折率を変えます。\n（描画処理の軽減）(有効/無効の切替可)";
			
			explain["ITTEN"] = "破魔弓を強化して、技[一点射撃]の霊力を上げ、威力を倍にします。\n破魔弓画面で有効／無効の切替ができます。";
			explain["BABABA"] = "破魔弓を強化して、技[バババッ]の霊力を上げ、威力を倍にします。\n破魔弓画面で有効／無効の切替ができます。";
			explain["HANABI"] = "破魔弓を強化して、技[花火]の霊力を上げ、威力を倍にします。\n破魔弓画面で有効／無効の切替ができます。";
			explain["REN"] = "破魔弓を強化して、技[連]の霊力を上げ、威力を倍にします。\n破魔弓画面で有効／無効の切替ができます。";
			explain["SOU"] = "破魔弓を強化して、技[送]の霊力を上げ、威力を倍にします。\n破魔弓画面で有効／無効の切替ができます。";

			explain["WAZATAME"] = "霊力を溜め、技の威力を大幅に上げます。紫のゲージが白になったときに技を放つと発動します。技によって溜める時間が異なります。(有効/無効の切替可)";

			explain["AUTO"] = "日々の鍛錬で体に覚えこませた技術を破魔弓に伝えやすくします。黄色のゲージがいっぱいになると自動的に矢を放ちます。(有効/無効の切替可)";
			explain["AUTO1"] = "日々の鍛錬で体に覚えこませた技術を破魔弓に伝えやすくします。ゲージ最大まで弓を引き、いっぱいになると自動的に矢を放ちます。(有効/無効の切替可)";
			
			explain["NOROI2"] = "より厳しい実戦を求める者向けに、呪に呪を掛け合わせ、妖魔の霊力を異常上昇させます。破魔弓画面で有効／無効の切替ができます。\n[呪×呪]装備では再び妖魔を討伐しないと先へ進めません。";
			//--------
			initItemGamen();
		}

		// ----------------
		// addSpriteBtn
		// ----------------
		private function addSpriteBtn(mc:MovieClip, tf:TextField, f:Function):void
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
		// show
		// ----------------
		private var isNowLoading:Boolean = false;
		public function show():void 
		{
			var i:int;
			var k:int;
			
			this.visible = true;

			//init
			for (i = 0; i < abilityTf.length; i++ )
			{
				abilityTf[i].text = "";
			}
			
			//--------
			//貫通強化+2があるなら+1も済にする。
			var hasTadan3:Boolean = Global.yumiSettingGamen.has3danHit();
			//--------
			
			for (i = 0; i < Global.yumishiTbl.getCount(); i++ )
			{
				//--------
				//呪２はガルダを倒したら表示
				if (Global.yumishiTbl.getData(i, "ID") == "NOROI2")
				{
					if (Global.scenario.lastClearIndex < Global.scenario.getStageIdx(Scenario.GARUDA))
					{
						continue;
					}
				}
				//--------
				//--------
				//三人張りはガルダを倒したら表示
				if (Global.yumishiTbl.getData(i, "ID") == "YUMI3")
				{
					if (Global.scenario.lastClearIndex < Global.scenario.getStageIdx(Scenario.GARUDA))
					{
						continue;
					}
				}
				//--------
				var needLevel:int = int(Global.yumishiTbl.getData(i, "LEVEL"));
				if (needLevel <= Hamayumi.level)
				{
					for (k = 0; k < Global.useryumiTbl.getCount(); k++ )
					{
						if (Global.yumishiTbl.getData(i, "ID") == Global.useryumiTbl.getData(k, "ID"))
						{
							abilityTf[i].text = Global.leftStr("[済]" + Global.yumishiTbl.getData(i, "NAME"), 20) + Global.rightStr(Global.yumishiTbl.getData(i, "PRICE"), 6) + "文";
							break;
						}

						//--------
						//貫通強化+2があるなら+1も済にする。
						if ((Global.yumishiTbl.getData(i, "ID") == "TADAN2") && (hasTadan3 == true))
						{
							abilityTf[i].text = Global.leftStr("[済]" + Global.yumishiTbl.getData(i, "NAME"), 20) + Global.rightStr(Global.yumishiTbl.getData(i, "PRICE"), 6) + "文";
							break;
						}
						//--------
					}
					if (k == Global.useryumiTbl.getCount())
					{
						abilityTf[i].text = Global.leftStr(Global.yumishiTbl.getData(i, "NAME"), 20) + Global.rightStr(Global.yumishiTbl.getData(i, "PRICE"), 6) + "文";
					}
				}
				else
				{
					abilityTf[i].text = "？ (強化にはレベル" + needLevel + "必要)";
				}
			}
			
			//visible制御
			for (i = 0; i < abilityTf.length; i++ )
			{
				abilityTf[i].visible = true;
				if (abilityTf[i].text == "")
				{
					abilityTf[i].visible = false;
				}
			}
			
			//mc.msg_txt.text = "破魔弓に付加する能力を選択して強化ボタンを押してください。\n付加した能力は破魔弓画面で有効か無効の切替ができます。";
			yumishiGamenMC.msg_txt.text = "破魔弓の強化を行います。\n破魔弓に付加する能力を選択して強化ボタンを押してください。";
			yumishiGamenMC.money_txt.text = "霊銭 " + Global.userTbl.getData(0, "RELEASE") + "文";
			
			//--------
			if ((Global.yumishiTbl.getCount() <= 0) && (isNowLoading == false))
			{
				isNowLoading = true;

				yumishiGamenMC.msg_txt.text = "読込中…";
				
				var obj:Object = new Object();
				obj.type = 'data'
				obj.name = Global.username;
				obj.id = '';
				obj.magatamaid = '';
				yumishiConnect.connect(obj, reShow);
			}
		}

		// ----------------
		// reShow
		// ----------------
		private function reShow(bool:Boolean):void
		{
			if ((bool == true) && (0 < Global.yumishiTbl.getCount()))
			{
				show();
			}
			else
			{
				yumishiGamenMC.msg_txt.text = "読込失敗";
			}
			isNowLoading = false;
		}

		// ----------------
		// close
		// ----------------
		public function close():void 
		{
			this.visible = false;
			Global.selectGamen.showStatus();
		}

		// ----------------
		// clickKyokaItem
		// ----------------
		private var selectKyokaItemIdx:int = -1;
		public function clickKyokaItem(e:MouseEvent):void
		{
			var i:int;
			for (i = 0; i < abilityTf.length; i++)
			{
				if (e.target == abilityTf[i].parent)
				{
					selectKyokaItemIdx = i;
					break;
				}
			}
			
			//--------
			for (i = 0; i < abilityTf.length; i++)
			{
				abilityTf[i].border = false;
				abilityTf[i].borderColor = 0xffffff;
			}
			if (0 <= selectKyokaItemIdx)
			{
				abilityTf[selectKyokaItemIdx].border = true;
				if (abilityTf[selectKyokaItemIdx].text.indexOf("？") < 0)
				{
					yumishiGamenMC.msg_txt.text = explain[Global.yumishiTbl.getData(selectKyokaItemIdx, "ID")];
				}
			}
		}

		// ----------------
		// clickDecideKyoka
		// ----------------
		private function clickDecideKyoka(e:MouseEvent):void
		{
			var i:int;

			//--------
			if (selectKyokaItemIdx < 0)
			{
				yumishiGamenMC.msg_txt.text = "付加する能力を選択してください。";
				return;
			}
			/*
			//--------
			if (int(Global.userTbl.getData(0, "RELEASE")) < int(Global.yumishiTbl.getData(selectKyokaItemIdx, "PRICE")))
			{
				yumishiGamenMC.msg_txt.text = "霊銭が足りません。";
				return;
			}
			*/
			//--------
			var needLevel:int = int(Global.yumishiTbl.getData(selectKyokaItemIdx, "LEVEL"));
			if (Hamayumi.level < needLevel)
			{
				yumishiGamenMC.msg_txt.text = "強化するには破魔弓レベルが足りません。";
				return;
			}

			//--------
			if (int(Global.userTbl.getData(0, "RELEASE")) < int(Global.yumishiTbl.getData(selectKyokaItemIdx, "PRICE")))
			{
				yumishiGamenMC.msg_txt.text = "霊銭が足りません。";
				return;
			}
			
			//--------
			var needID:Dictionary = new Dictionary();
			//needID["EXP10"] = "EXP5";
			//needID["EXP15"] = "EXP10";
			//needID["EXP20"] = "EXP15";
			//needID["EXP25"] = "EXP20";
			for (i = 0; i < Global.yumishiTbl.getCount(); i++ )
			{
				//if (0 <= Global.yumishiTbl.getData(i, "NEEDID").indexOf("EXP"))
				if (0 < Global.yumishiTbl.getData(i, "NEEDID").length)
				{
					needID[Global.yumishiTbl.getData(i, "ID")] = Global.yumishiTbl.getData(i, "NEEDID");
				}
			}
			
			for (var key:String in needID)
			{
				if (Global.yumishiTbl.getData(selectKyokaItemIdx, "ID") == key)
				{
					for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
					{
						if (Global.useryumiTbl.getData(i, "ID") == needID[key])
						{
							//ok
							break;
						}
					}
					if (i == Global.useryumiTbl.getCount())
					{
						for (i = 0; i < Global.yumishiTbl.getCount(); i++ )
						{
							if (needID[key] == Global.yumishiTbl.getData(i, "ID"))
							{
								yumishiGamenMC.msg_txt.text = "強化するには" + Global.yumishiTbl.getData(i, "NAME") + "が必要です。";
								break;
							}
						}
						return;
					}
				}
			}

			//--------
			//貫通強化+2があるなら+1も済にする。
			var hasTadan3:Boolean = Global.yumiSettingGamen.has3danHit();
			//--------

			//--------
			for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
			{
				if (Global.yumishiTbl.getData(selectKyokaItemIdx, "ID") == Global.useryumiTbl.getData(i, "ID"))
				{
					yumishiGamenMC.msg_txt.text = "強化済みです。";
					return;
				}
				
				//--------
				if ((Global.yumishiTbl.getData(selectKyokaItemIdx, "ID") == "TADAN2") && (hasTadan3 == true))
				{
					yumishiGamenMC.msg_txt.text = "強化済みです。";
					return;
				}
				//--------
			}

			//--------呪い
			if (Global.yumishiTbl.getData(selectKyokaItemIdx, "ID") == "NOROI")
			{
				itemGamenMC.msg_txt.text = "強化に使用する[呪]の勾玉を選択して、決定を押してください。";
				showItemGamen();
				return;
			}

			kyokaConfirm.visible = true;
		}

		// ----------------
		// clickYes
		// ----------------
		private var yumishiConnect:YumishiConnect = new YumishiConnect();
		private function clickYes(e:MouseEvent):void
		{
			var obj:Object = new Object();
			
			obj.type = "buy";
			obj.name = Global.username;
			obj.id = Global.yumishiTbl.getData(selectKyokaItemIdx, "ID");
			obj.magatamaid = selectedMagatamaId;
			
			yumishiConnect.connect(obj, StrengthenOK);
		}
		private function StrengthenOK(bool:Boolean):void 
		{
			if (bool)
			{
				//再表示
				show();
				yumishiGamenMC.msg_txt.text = "破魔弓を強化しました。";
			}
			else
			{
				yumishiGamenMC.msg_txt.text = yumishiConnect.message;
			}
			kyokaConfirm.visible = false;
		}

		//****************
		// ----------------
		// initItemGamen
		// ----------------
		private function initItemGamen():void
		{
			var i:int;

			itemTf = Vector.<TextField>
			([
				 itemGamenMC.item01_txt
				,itemGamenMC.item02_txt
				,itemGamenMC.item03_txt
				,itemGamenMC.item04_txt
				,itemGamenMC.item05_txt
				,itemGamenMC.item06_txt
				,itemGamenMC.item07_txt
				,itemGamenMC.item08_txt
				,itemGamenMC.item09_txt
				,itemGamenMC.item10_txt
				,itemGamenMC.item11_txt
				,itemGamenMC.item12_txt
				,itemGamenMC.item13_txt
				,itemGamenMC.item14_txt
				,itemGamenMC.item15_txt
				,itemGamenMC.item16_txt
				,itemGamenMC.item17_txt
				,itemGamenMC.item18_txt
				,itemGamenMC.item19_txt
				,itemGamenMC.item20_txt
				
				,itemGamenMC.item21_txt
				,itemGamenMC.item22_txt
				,itemGamenMC.item23_txt
				,itemGamenMC.item24_txt
				,itemGamenMC.item25_txt
				,itemGamenMC.item26_txt
				,itemGamenMC.item27_txt
				,itemGamenMC.item28_txt
				,itemGamenMC.item29_txt
				,itemGamenMC.item30_txt
			]);
			for (i = 0; i < itemTf.length; i++)
			{
				addSpriteBtn(itemGamenMC, itemTf[i], clickItem);
				itemTf[i].border = false;
				itemTf[i].borderColor = 0xffffff;
			}

			addSpriteBtn(itemGamenMC, itemGamenMC.close_txt, function(e:MouseEvent):void { itemGamenMC.visible = false; } );
			itemGamenMC.mix_txt.text = "決定";
			addSpriteBtn(itemGamenMC, itemGamenMC.mix_txt, clickDecide);
			
			itemGamenMC.money_txt.text = "";
		}

		// ----------------
		// showItemGamen
		// ----------------
		private function showItemGamen():void
		{
			var i:int;
			
			itemGamenMC.visible = true;

			//--------
			//アイテム画面の処理を裏で呼んでソート済みにする
			Global.itemGamen.show(true);
			Global.itemGamen.close();
			
			//--------
			for (i = 0; i < itemTf.length; i++ )
			{
				var baseTf:TextField = Global.itemGamen.itemTf[i];
				itemTf[i].text = baseTf.text;
				itemTf[i].textColor = baseTf.textColor;
				itemTf[i].x = baseTf.x;
				itemTf[i].y = baseTf.y;
				if (Item.MAX_COUNT == 30)
				{
					itemTf[i].width = 160;// baseTf.width;
				}
			}

			for (i = 0; i < itemTf.length; i++ )
			{
				var fmt:TextFormat = Global.itemGamen.itemTf[i].getTextFormat();
				itemTf[i].setTextFormat(fmt);
			}
			
			refreshItemSelect();
		}

		// ----------------
		// showItemGamen
		// ----------------
		private var selectedIdx:int = 0;
		public function clickItem(e:MouseEvent):void
		{
			var i:int;
			for (i = 0; i < itemTf.length; i++)
			{
				if (e.target == itemTf[i].parent)
				{
					selectedIdx = i;
					break;
				}
			}
			
			refreshItemSelect();
		}
		
		// ----------------
		// refreshItemSelect
		// ----------------
		private function refreshItemSelect():void
		{
			var i:int;
			
			for (i = 0; i < itemTf.length; i++ )
			{
				itemTf[i].border = false;
			}
			
			if (0 <= selectedIdx)
			{
				itemTf[selectedIdx].border = true;
			}
		}

		// ----------------
		// clickDecide
		// ----------------
		private var selectedMagatamaId:String = "";
		private function clickDecide(e:MouseEvent):void
		{
			selectedMagatamaId = "";

			if (selectedIdx < 0)
			{
				itemGamenMC.msg_txt.text = "勾玉を選択してください。";
				return;
			}
			
			//--------呪い
			if (Global.yumishiTbl.getData(selectKyokaItemIdx, "ID") == "NOROI")
			{
				if (Global.isNoroiMagatama(selectedIdx))
				{
					selectedMagatamaId = Global.itemTbl.getData(selectedIdx, "ID");
					kyokaConfirm.visible = true;
					itemGamenMC.visible = false;
					return;
				}
				else
				{
					itemGamenMC.msg_txt.text = "[呪]の勾玉を選択してください。";
					return;
				}
			}
			
		}
		//****************
	}
	
}