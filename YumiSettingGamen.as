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
	public class YumiSettingGamen extends Sprite
	{
		private var mc:YumiMC = new YumiMC();
		private var itemTf:Vector.<TextField>;
		private var onoffTf:Vector.<TextField>;
		private var explain:Dictionary = new Dictionary();
		
		public function YumiSettingGamen()
		{
			var i:int, k:int;

			addChild(mc);

			itemTf = Vector.<TextField>
			([
				 mc.item01_txt
				,mc.item02_txt
				,mc.item03_txt
				,mc.item04_txt
				,mc.item05_txt
				,mc.item06_txt
				,mc.item07_txt
				,mc.item08_txt
				,mc.item09_txt
				,mc.item10_txt
				,mc.item11_txt
				,mc.item12_txt
				,mc.item13_txt
				,mc.item14_txt
				,mc.item15_txt
				,mc.item16_txt
				,mc.item17_txt
				,mc.item18_txt
				,mc.item19_txt
				,mc.item20_txt
				
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
			for (i = 0; i < itemTf.length; i++)
			{
				itemTf[i].border = true;
				itemTf[i].borderColor = 0x9977bb;
			}

			onoffTf = Vector.<TextField>
			([
				 mc.onoff01_txt
				,mc.onoff02_txt
				,mc.onoff03_txt
				,mc.onoff04_txt
				,mc.onoff05_txt
				,mc.onoff06_txt
				,mc.onoff07_txt
				,mc.onoff08_txt
				,mc.onoff09_txt
				,mc.onoff10_txt
				,mc.onoff11_txt
				,mc.onoff12_txt
				,mc.onoff13_txt
				,mc.onoff14_txt
				,mc.onoff15_txt
				,mc.onoff16_txt
				,mc.onoff17_txt
				,mc.onoff18_txt
				,mc.onoff19_txt
				,mc.onoff20_txt
			]);
			for (i = 0; i < onoffTf.length; i++)
			{
				addSpriteBtn(onoffTf[i], clickOnOff);
			}

			addSpriteBtn(mc.close_txt, function():void { close(); } );
			
			//--------
			explain["HP"] = "戦闘中に妖魔の体力が確認できるようになります。";
			explain["DOCHO"] = "協力戦で矢数を抑制します。抑制効果で装備中の勾玉のレベルアップが可能となります。妖魔によって矢数は変わります。";

			explain["NOROI"] = "呪いにより妖魔の霊力を増幅します。勾玉変換時の勾玉の能力にも影響します。";
			
			explain["TADAN2"] = "破魔弓を強化して貫通矢の霊力を上げ、貫通する間に２度ヒットさせます。";
			explain["TADAN3"] = "破魔弓を強化して貫通矢の霊力を上げ、貫通する間に３度ヒットさせます。";
			
			explain["SELECT"] = "破魔弓を強化して霊力の識別能力を上げ、協力戦を選べるようにします。";
			
			explain["YUMI2"] = "弓を引くのに二人分の霊力が必要とされる破魔弓に強化します。（矢の威力４倍、矢数半減、飛と速と密の勾玉効果半減）";
			explain["YUMI3"] = "弓を引くのに三人分の霊力が必要とされる破魔弓に強化します。（矢の威力８倍、矢数３分の１、飛と速と密の勾玉効果３分の１）";

			explain["LIGHT"] = "破魔矢の波長を微妙に変化させ続け、光の屈折率を変えます。";
			
			explain["ITTEN"] = "破魔弓を強化して、技[一点射撃]の霊力を上げ、威力を倍にします。";
			explain["BABABA"] = "破魔弓を強化して、技[バババッ]の霊力を上げ、威力を倍にします。";
			explain["HANABI"] = "破魔弓を強化して、技[花火]の霊力を上げ、威力を倍にします。";
			explain["REN"] = "破魔弓を強化して、技[連]の霊力を上げ、威力を倍にします。";
			explain["SOU"] = "破魔弓を強化して、技[送]の霊力を上げ、威力を倍にします。";

			explain["WAZATAME"] = "霊力を溜め、技の威力を大幅に上げます。紫のゲージが白になったときに技を放つと発動します。技によって溜める時間が異なります。";

			explain["AUTO"] = "日々の鍛錬で体に覚えこませた技術を破魔弓に伝えやすくします。黄色のゲージがいっぱいになると自動的に矢を放ちます。";
			explain["AUTO1"] = "日々の鍛錬で体に覚えこませた技術を破魔弓に伝えやすくします。ゲージ最大まで弓を引き、いっぱいになると自動的に矢を放ちます。";
			
			explain["NOROI2"] = "より厳しい実戦を求める者向けに、呪に呪を掛け合わせ、妖魔の霊力を異常上昇させます。\n[呪×呪]装備では再び妖魔を討伐しないと先へ進めません。";
			//--------
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

			//btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_SELECT_COLOR;});
			btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { tf.backgroundColor = Global.BUTTON_SELECT_COLOR; showExplain(e); } );
			btn.addEventListener(MouseEvent.MOUSE_OUT,  function(e:MouseEvent):void { tf.backgroundColor = Global.BUTTON_NORMAL_COLOR; } );
			btn.addEventListener(MouseEvent.CLICK, f);
		}
		
		// ----------------
		// showExplain
		// ----------------
		private function showExplain(e:MouseEvent):void
		{
			var i:int;
			var cnt:int = 0;
			var mouseoverIdx:int = -1;
			for (i = 0; i < onoffTf.length; i++)
			{
				if (e.target == onoffTf[i].parent)
				{
					mouseoverIdx = i;
					break;
				}
			}
			for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
			{
				if (Global.useryumiTbl.getData(i, "ONOFF") == "1")
				{
					if (mouseoverIdx == cnt)
					{
						mc.msg_txt.text = explain[Global.useryumiTbl.getData(i, "ID")];
						break;
					}
					cnt++;
				}
			}
			if (mouseoverIdx == -1)
			{
				mc.msg_txt.text = "破魔弓に付加する能力を決定します。\n紫のボタンをクリックすることで[○]有効、[　]無効を切替できます。";
			}
		}

		// ----------------
		// show
		// ----------------
		public function show():void 
		{
			var i:int;
			var k:int;
			
			this.visible = true;

			//init
			for (i = 0; i < itemTf.length; i++ )
			{
				itemTf[i].text = onoffTf[i].text = "";
				itemTf[i].visible = onoffTf[i].visible = false;
			}

			for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
			{
				if (Global.useryumiTbl.getData(i, "ONOFF") == "1")
				{
					itemTf[k].text = Global.useryumiTbl.getData(i, "NAME");
					itemTf[k].visible = onoffTf[k].visible = true;
					
					if (Global.useryumiTbl.getData(i, "ENABLE") == "1")
					{
						onoffTf[k].text = "○";
					}
					
					k++;
				}
			}
			
			mc.msg_txt.text = "破魔弓に付加する能力を決定します。\n紫のボタンをクリックすることで[○]有効、[　]無効を切替できます。";

			//--------
			oldYuko = makeYukoStr();
		}

		// ----------------
		// close
		// ----------------
		private var oldYuko:String = "";
		public function close():void 
		{
			//this.visible = false;
			
			var nowYuko:String = makeYukoStr();

			if (nowYuko == oldYuko)
			{
				//変化なしなのでそのまま閉じる
				this.visible = false;
			}
			else
			{
				var yumisetting:YumiSettingConnect = new YumiSettingConnect();
				var obj:Object = new Object();
				obj.name = Global.username;
				obj.yuko = nowYuko;
				yumisetting.connect(obj, settingOk);
			}
		}

		// ----------------
		// settingOk
		// ----------------
		private function settingOk(bool:Boolean):void
		{
			if (bool == false)
			{
				mc.msg_txt.text = "有効／無効設定に失敗しました。";
			}
			this.visible = false;
			
			Global.selectGamen.showNowPage();

			//--------
			if (Global.yumiSettingGamen.isNoroi2())
			{
				Global.dailyQuestNo = 0;	//日刊クエストクリア
				Global.selectGamen.showNowPage();
				Global.selectGamen.setMsg("[呪×呪]装備では再び妖魔を討伐しないと先へ進めません。");
			}
			//--------
		}

		// ----------------
		// makeYukoStr
		// ----------------
		private function makeYukoStr():String
		{
			var i:int;
			var k:int = 0;
			var yuko:String = "";

			for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
			{
				if (Global.useryumiTbl.getData(i, "ONOFF") == "1")
				{
					if (onoffTf[k].text == "○")
					{
						yuko += Global.useryumiTbl.getData(i, "ID") + ",";
					}
					k++;
				}
			}
			
			//最後のカンマを除く
			if (0 < yuko.length)
			{
				yuko = yuko.substr(0, yuko.length - 1);
			}
			
			return yuko;
		}

		// ----------------
		// clickOnOff
		// ----------------
		public function clickOnOff(e:MouseEvent):void
		{
			//--------
			var _beforeAuto:Boolean = isMaru("AUTO");
			var _beforeAuto1:Boolean = isMaru("AUTO1");
			var _beforeNoroi:Boolean = isMaru("NOROI");
			var _beforeNoroi2:Boolean = isMaru("NOROI2");
			var _beforeYumi2:Boolean = isMaru("YUMI2");
			var _beforeYumi3:Boolean = isMaru("YUMI3");
			//--------
			
			var i:int;
			for (i = 0; i < onoffTf.length; i++)
			{
				if (e.target == onoffTf[i].parent)
				{
					if (onoffTf[i].text == "")
					{
						onoffTf[i].text = "○";
					}
					else if (onoffTf[i].text == "○")
					{
						onoffTf[i].text = "";
					}
					break;
				}
			}
			
			//--------自動射出はどちらか一方のみ
			var _afterAuto:Boolean = isMaru("AUTO");
			var _afterAuto1:Boolean = isMaru("AUTO1");
			if ((_afterAuto) && (_afterAuto1))
			{
				if (_beforeAuto == false)
				{
					setMaruOff("AUTO");
					mc.msg_txt.text = "[自動射出]と[自動射出+1]は両方有効にはできません。";
				}
				if (_beforeAuto1 == false)
				{
					setMaruOff("AUTO1");
					mc.msg_txt.text = "[自動射出]と[自動射出+1]は両方有効にはできません。";
				}
			}
			//--------
			//--------呪はどちらか一方のみ
			var _afterNoroi:Boolean = isMaru("NOROI");
			var _afterNoroi2:Boolean = isMaru("NOROI2");
			if ((_afterNoroi) && (_afterNoroi2))
			{
				if (_beforeNoroi == false)
				{
					setMaruOff("NOROI");
					mc.msg_txt.text = "[呪]と[呪×呪]は両方有効にはできません。";
				}
				if (_beforeNoroi2 == false)
				{
					setMaruOff("NOROI2");
					mc.msg_txt.text = "[呪]と[呪×呪]は両方有効にはできません。";
				}
			}
			//--------
			//--------二人張り、三人張りはどちらか一方のみ
			var _afterYumi2:Boolean = isMaru("YUMI2");
			var _afterYumi3:Boolean = isMaru("YUMI3");
			if ((_afterYumi2) && (_afterYumi3))
			{
				if (_beforeYumi2 == false)
				{
					setMaruOff("YUMI2");
					mc.msg_txt.text = "二人張りと三人張りは両方有効にはできません。";
				}
				if (_beforeYumi3 == false)
				{
					setMaruOff("YUMI3");
					mc.msg_txt.text = "二人張りと三人張りは両方有効にはできません。";
				}
			}
			//--------
		}
		
		// ----------------
		// isMaru
		// ----------------
		private function isMaru(_id:String):Boolean
		{
			var i:int;
			var k:int = 0;
			for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
			{
				if (Global.useryumiTbl.getData(i, "ONOFF") == "1")
				{
					if (onoffTf[k].text == "○")
					{
						if (Global.useryumiTbl.getData(i, "ID") == _id)
						{
							return true;
						}
					}
					k++;
				}
			}
			return false;
		}

		// ----------------
		// setMaruOff
		// ----------------
		private function setMaruOff(_id:String):void 
		{
			var i:int;
			var k:int = 0;
			for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
			{
				if (Global.useryumiTbl.getData(i, "ONOFF") == "1")
				{
					if (onoffTf[k].text == "○")
					{
						if (Global.useryumiTbl.getData(i, "ID") == _id)
						{
							onoffTf[k].text = "";
							break;
						}
					}
					k++;
				}
			}
		}
		
		// ----------------
		// isShowHamayumiBtn
		// ----------------
		public function isShowHamayumiBtn():Boolean 
		{
			var i:int;
			for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
			{
				if (Global.useryumiTbl.getData(i, "ONOFF") == "1")
				{
					return true;
				}
			}
			return false;
		}

		// ----------------
		// isSkillON
		// ----------------
		private function isSkillON(id:String):Boolean
		{
			var i:int;

			for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
			{
				if ((Global.useryumiTbl.getData(i, "ID") == id) && (Global.useryumiTbl.getData(i, "ENABLE") == "1"))
				{
					return true;
				}
			}
			
			return false;
		}
		// ----------------
		// hasSkill
		// ----------------
		private function hasSkill(id:String):Boolean
		{
			var i:int;

			for (i = 0; i < Global.useryumiTbl.getCount(); i++ )
			{
				if (Global.useryumiTbl.getData(i, "ID") == id)
				{
					return true;
				}
			}
			
			return false;
		}

		// ----------------
		// isShowHP
		// ----------------
		public function isShowHP():Boolean
		{
			return isSkillON("HP");
		}

		// ----------------
		// isDocho
		// ----------------
		public function isDocho():Boolean
		{
			return isSkillON("DOCHO");
		}

		// ----------------
		// is2ninbari
		// ----------------
		public function is2ninbari():Boolean
		{
			return isSkillON("YUMI2");
		}
		// ----------------
		// is3ninbari
		// ----------------
		public function is3ninbari():Boolean
		{
			return isSkillON("YUMI3");
		}

		// ----------------
		// is2danHit
		// ----------------
		public function is2danHit():Boolean
		{
			return isSkillON("TADAN2");
		}

		// ----------------
		// is3danHit
		// ----------------
		public function is3danHit():Boolean
		{
			return isSkillON("TADAN3");
		}
		// ----------------
		// has3danHit
		// ----------------
		public function has3danHit():Boolean
		{
			return hasSkill("TADAN3");
		}

		// ----------------
		// isSelectCoop
		// ----------------
		public function isSelectCoop():Boolean
		{
			return isSkillON("SELECT");
		}

		// ----------------
		// isLight
		// ----------------
		public function isLight():Boolean
		{
			return isSkillON("LIGHT");
		}

		// ----------------
		// isKyokaHanabi
		// ----------------
		public function isKyokaHanabi():Boolean
		{
			return isSkillON("HANABI");
		}
		// ----------------
		// isKyokaBababa
		// ----------------
		public function isKyokaBababa():Boolean
		{
			return isSkillON("BABABA");
		}
		// ----------------
		// isKyokaItten
		// ----------------
		public function isKyokaItten():Boolean
		{
			return isSkillON("ITTEN");
		}
		// ----------------
		// isKyokaRen
		// ----------------
		public function isKyokaRen():Boolean
		{
			return isSkillON("REN");
		}
		// ----------------
		// isKyokaSou
		// ----------------
		public function isKyokaSou():Boolean
		{
			return isSkillON("SOU");
		}
		// ----------------
		// isWazaTame
		// ----------------
		public function isWazaTame():Boolean
		{
			return isSkillON("WAZATAME");
		}
		// ----------------
		// isAuto
		// ----------------
		public function isAuto():Boolean
		{
			return isSkillON("AUTO");
		}
		// ----------------
		// isAuto1
		// ----------------
		public function isAuto1():Boolean
		{
			return isSkillON("AUTO1");
		}
		// ----------------
		// isNoroi2
		// ----------------
		public function isNoroi2():Boolean
		{
			return isSkillON("NOROI2");
		}
		// ----------------
		// hasNoroi2
		// ----------------
		public function hasNoroi2():Boolean
		{
			return hasSkill("NOROI2");
		}
	}
	
}