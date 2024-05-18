package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author kasaharan
	 */
	public class MixGamen extends Sprite
	{
		private var mc:MovieClip;
		private var itemTf:Vector.<TextField>;
		private var mixConfirm:ConfirmGamen = new ConfirmGamen(new ConfirmMC(), clickYes);
		
		public function MixGamen
		(
			_mc:MovieClip
		)
		{
			var i:int, k:int;

			mc = _mc;
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
			]);
			for (i = 0; i < itemTf.length; i++)
			{
				addSpriteBtn(itemTf[i], clickItem);
				itemTf[i].border = false;
				//itemTf[i].borderColor = 0xffffff;
				itemTf[i].borderColor = 0xEDAD0B;
			}

			addSpriteBtn(mc.close_txt, function():void { close(); } );
			addSpriteBtn(mc.mix_txt, clickMix);
			
			addChild(mixConfirm);
			mixConfirm.visible = false;
			mixConfirm.setMessage("選択した２つの勾玉を合成して１つの勾玉にします。（能力が消える場合もあります）\nよろしいですか？");
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
		// show
		// ----------------
		private var mouseDownNo:int = -1;
		private var mouseUpNo:int = -1;
		public function show():void 
		{
			var i:int;
			
			this.visible = true;
			
			selectItemIdx01 = -1;
			selectItemIdx02 = -1;
			refreshSelect();
			
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
			//if (Item.MAX_COUNT == 30)
			{
				for (i = 0; i < itemTf.length; i++ )
				{
					//itemTf[i].setTextFormat(Global.itemGamen.fmtMagatama30);
					var fmt:TextFormat = Global.itemGamen.itemTf[i].getTextFormat();
					itemTf[i].setTextFormat(fmt);
				}
			}

			mc.msg_txt.text = "勾玉を合成するには勾玉を２つ選択して合成ボタンをクリックしてください。\n合成には霊銭が5文必要です。合成済の勾玉は合成できません。";
			
			mc.money_txt.text = "霊銭 " + Global.userTbl.getData(0, "RELEASE") + "文";
		}

		// ----------------
		// close
		// ----------------
		public function close():void 
		{
			this.visible = false;
		}

		// ----------------
		// clickItem
		// ----------------
		private var selectItemIdx01:int = -1;
		private var selectItemIdx02:int = -1;
		private var nowSelectPhase:int = 0;
		public function clickItem(e:MouseEvent):void
		{
			var i:int;
			for (i = 0; i < itemTf.length; i++)
			{
				if (e.target == itemTf[i].parent)
				{
					if (nowSelectPhase == 0)
					{
						if (selectItemIdx02 != i)
						{
							selectItemIdx01 = i;
							nowSelectPhase = 1;
							refreshSelect();
							mc.msg_txt.text = Global.getItemNameDetail(i);
							mc.msg_txt.appendText(getMagatamaLvStr(i));
						}
					}
					else
					{
						if (selectItemIdx01 != i)
						{
							selectItemIdx02 = i;
							nowSelectPhase = 0;
							refreshSelect();
							mc.msg_txt.text = Global.getItemNameDetail(i);
							mc.msg_txt.appendText(getMagatamaLvStr(i))
						}
					}
					break;
				}
			}
		}
		
		// ----------------
		// getMagatamaLvStr
		// ----------------
		private function getMagatamaLvStr(idx:int):String
		{
			var str:String = "";
			var exp:int = int(Global.itemTbl.getData(idx, "EXP"));
			var level:int = int(Global.itemTbl.getData(idx, "LEVEL"));
			if (0 < exp)
			{			
				//var needExp:Vector.<int> = Vector.<int>([0, 20, 50, 100]);
				if (ItemGamen.getMagatamaMaxLv(idx) < level)
				{
					str = " [勾玉レベル:" + level + " 蓄積霊力:*/*]";
				}
				else
				{
					str = " [勾玉レベル:" + level + " 蓄積霊力:" + exp + "/" + ItemGamen.magatamaNeedExp[level] + "]";
				}
			}
			return str;
		}

		// ----------------
		// refreshSelect
		// ----------------
		private function refreshSelect():void
		{
			var i:int;
			
			for (i = 0; i < itemTf.length; i++ )
			{
				itemTf[i].border = false;
			}
			
			if (0 <= selectItemIdx01)
			{
				itemTf[selectItemIdx01].border = true;
			}
			if (0 <= selectItemIdx02)
			{
				itemTf[selectItemIdx02].border = true;
			}

		}

		// ----------------
		// clickMix
		// ----------------
		private function clickMix(e:MouseEvent):void
		{
			if ((selectItemIdx01 < 0) || (selectItemIdx02 < 0))
			{
				mc.msg_txt.text = "勾玉を２つ選択してください。";
				return;
			}
			if (Global.itemTbl.getCount() <= selectItemIdx01)
			{
				mc.msg_txt.text = "勾玉を２つ選択してください。";
				return;
			}
			if (Global.itemTbl.getCount() <= selectItemIdx02)
			{
				mc.msg_txt.text = "勾玉を２つ選択してください。";
				return;
			}
			if (int(Global.itemTbl.getData(selectItemIdx01, "MIX")) == 1)
			{
				mc.msg_txt.text = "合成済の勾玉は合成できません。";
				return;
			}
			if (int(Global.itemTbl.getData(selectItemIdx02, "MIX")) == 1)
			{
				mc.msg_txt.text = "合成済の勾玉は合成できません。";
				return;
			}
			if (Global.itemTbl.getData(selectItemIdx01, "ID") == Global.itemTbl.getData(selectItemIdx02, "ID"))
			{
				//画面操作上できないが一応チェック入れとく
				mc.msg_txt.text = "勾玉を２つ選択してください。";
				return;
			}
			if (int(Global.userTbl.getData(0, "RELEASE")) < 5)
			{
				mc.msg_txt.text = "霊銭が足りません。合成には霊銭が5文必要です。";
				return;
			}
			
			mixConfirm.visible = true;
			var exp01:int = int(Global.itemTbl.getData(selectItemIdx01, "EXP"));
			var exp02:int = int(Global.itemTbl.getData(selectItemIdx02, "EXP"));
			if ((0 < exp01) || (0 < exp02))
			{
				mixConfirm.setMessage("選択した２つの勾玉を合成して１つの勾玉にします。\n（能力が消える場合もあります）\n蓄積霊力は失われます。\nよろしいですか？");
			}
			else
			{
				mixConfirm.setMessage("選択した２つの勾玉を合成して１つの勾玉にします。\n（能力が消える場合もあります）\nよろしいですか？");
			}
		}

		// ----------------
		// clickYes
		// ----------------
		private var mixConnect:MixConnect = new MixConnect();
		private function clickYes(e:MouseEvent):void
		{
			var obj:Object = new Object();
			
			obj.name = Global.username;
			obj.magatama1 = Global.itemTbl.getData(selectItemIdx01, "ID");
			obj.magatama2 = Global.itemTbl.getData(selectItemIdx02, "ID");
			
			mixConnect.connect(obj, mixOK);
		}
		private function mixOK(bool:Boolean):void 
		{
			if (bool)
			{
				//再表示
				show();
				mc.msg_txt.text = Global.getItemNameByID(Global.magatamaID) + "を手に入れた。";
			}
			else
			{
				mc.msg_txt.text = mixConnect.message;
			}
			mixConfirm.visible = false;
		}

	}
	
}