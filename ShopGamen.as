package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;

	public class ShopGamen extends Sprite
	{
		private var mc:MovieClip;
		private var itemTf:Vector.<TextField>;

		public function ShopGamen(
			  _mc:MovieClip
			 ,clickClose:Function
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
			]);
			for (i = 0; i < itemTf.length; i++)
			{
				addSpriteBtn(itemTf[i], clickItem);
				itemTf[i].border = false;
				itemTf[i].borderColor = 0xffffff;
				itemTf[i].text = "";
			}
			
			addSpriteBtn(mc.buy_txt, clickBuy);
			addSpriteBtn(mc.close_txt, clickClose);
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
		// show
		// ----------------
		public function show():void
		{
			var i:int;

			this.visible = true;
			
			//init
			for (i = 0; i < itemTf.length; i++)
			{
				itemTf[i].visible = false;
			}
			
			//----------------
			//大晦日仕様
			try
			{
				var _date:Date = new Date();
				_date.setTime(Global.usvr.reactor.getServer().getServerTime());
				var _mmdd:String = "" + (_date.getMonth() + 1) + _date.getDate();
				if (_mmdd == "1231")
				{
					Global.shopTbl = Global.shop1231Tbl;
				}
				else
				{
					Global.shopTbl = Global.shopNormalTbl;
				}
			}
			catch (err:Error)
			{
				Global.shopTbl = Global.shopNormalTbl;
			}
			//----------------
			
			for (i = 0; i < Global.shopTbl.getCount(); i++)
			{
				itemTf[i].visible = true;
				//itemTf[i].text = Global.shopTbl.getData(i, "NAME") + "  " +  Global.shopTbl.getData(i, "PRICE") + "文";
				
				var itemNo:int = int(Global.shopTbl.getData(i, "ITEMNO"));
				if ((10 <= itemNo) && (itemNo <= 13) && (isPurchased(itemNo) == true))
				{
					itemTf[i].text = Global.leftStr("[済]" + Global.shopTbl.getData(i, "NAME"), 20) + Global.rightStr(Global.shopTbl.getData(i, "PRICE"), 6) + "文";
				}
				else
				{
					itemTf[i].text = Global.leftStr(Global.shopTbl.getData(i, "NAME"), 20) + Global.rightStr(Global.shopTbl.getData(i, "PRICE"), 6) + "文";
				}
				
				//勾玉を持ってないと勾玉関連のアイテムを表示しない
				if (10 <= i)
				{
					if (0 < Global.itemTbl.getCount() <= 0)
					{
						itemTf[i].visible = false;
					}
				}
			}
			
			mc.money_txt.text = "霊銭 " + Global.userTbl.getData(0, "RELEASE") + "文";
			
			setSelecttedColor();
		}
		
		// ----------------
		// isPurchased
		// ----------------
		private function isPurchased(itemNo:int):Boolean
		{
			//--------
			//勾玉整頓術
			if (itemNo == 10)
			{
				if (Item.MAX_COUNT == 30)
				{
					return true;
				}
			}
			//--------
			//勾玉解放術
			if (itemNo == 11)
			{
				if (int(Global.userTbl.getData(0, "RELEASE_LV")) == 1)
				{
					return true;
				}
			}
			//--------
			//合成+1
			if (itemNo == 12)
			{
				if (1 <= int(Global.userTbl.getData(0, "MIX_LV")))
				{
					return true;
				}
			}
			//--------
			//合成+2
			if (itemNo == 13)
			{
				if (2 <= int(Global.userTbl.getData(0, "MIX_LV")))
				{
					return true;
				}
			}
			
			return false;
		}

		// ----------------
		// clickItem
		// ----------------
		private var selectedItemIdx:int = -1;
		public function clickItem(e:MouseEvent):void
		{
			var i:int;

			for (i = 0; i < itemTf.length; i++)
			{
				if (e.target == itemTf[i].parent)
				{
					selectedItemIdx = i;	
				}
			}
			
			setSelecttedColor();
			
			//--------
			if (int(Global.shopTbl.getData(selectedItemIdx, "ITEMNO")) == 10)
			{
				mc.msg_txt.text = "勾玉所持数を最大３０にする整頓術です。";
			}
			else if (int(Global.shopTbl.getData(selectedItemIdx, "ITEMNO")) == 11)
			{
				mc.msg_txt.text = "勾玉を解放したときに勾玉の能力に応じて取得できる霊銭を増やす術です。";
			}
			else if (int(Global.shopTbl.getData(selectedItemIdx, "ITEMNO")) == 12)
			{
				mc.msg_txt.text = "勾玉合成職人の道具の品質を上げます。合成後の勾玉の品質が上がりやすくなります。";
			}
			else if (int(Global.shopTbl.getData(selectedItemIdx, "ITEMNO")) == 13)
			{
				mc.msg_txt.text = "勾玉合成職人の道具の品質を上げます。合成後の勾玉の品質が上がりやすくなります。勾玉合成道具+1の購入で購入可能となります。";
			}
			//--------
			else if (int(Global.shopTbl.getData(selectedItemIdx, "ITEMNO")) == 15)
			{
				mc.msg_txt.text = "服装を変更します。戦闘には反映されません。妖魔の気持ちが分かるかもしれない着ぐるみ。";
			}
			else if (int(Global.shopTbl.getData(selectedItemIdx, "ITEMNO")) == 16)
			{
				mc.msg_txt.text = "服装を変更します。戦闘には反映されません。人間でも妖魔でもない。客観的な視点で物事を考えられるかもしれない着ぐるみ。";
			}
			else if (int(Global.shopTbl.getData(selectedItemIdx, "ITEMNO")) == 17)
			{
				mc.msg_txt.text = "服装を変更します。戦闘には反映されません。\n温故知新。";
			}
			//--------
			else
			{
				mc.msg_txt.text = "服装を変更します。戦闘には反映されません。";
			}
		}
		// ----------------
		// setSelecttedColor
		// ----------------
		private function setSelecttedColor():void
		{
			var i:int, idx:int;

			for (i = 0; i < itemTf.length; i++)
			{
				if (i == selectedItemIdx)
				{
					itemTf[i].borderColor = 0xffffff;
					itemTf[i].border = true;
				}
				else
				{
					itemTf[i].borderColor = 0x9977bb;
					itemTf[i].border = false;
				}
			}
		}

		// ----------------
		// clickBuy
		// ----------------
		private var isNowBuy:Boolean = false;
		private var bc:BuyConnect = new BuyConnect();
		public function clickBuy(e:MouseEvent):void
		{
			if (selectedItemIdx == -1)
			{
				return;
			}
			if (isNowBuy)
			{
				//購入中
				mc.msg_txt.text = "購入中‥";
				return;
			}
			
			/*
			//--------
			//勾玉整頓術
			if (Global.shopTbl.getData(selectedItemIdx, "ITEMNO") == 10)
			{
				//Item.MAX_COUNT = Global.userTbl.getData(0, "ITEMCNT");
				if (Item.MAX_COUNT == 30)
				{
					mc.msg_txt.text = "購入済みです。";
					return;
				}
			}
			//--------
			//勾玉解放術
			if (Global.shopTbl.getData(selectedItemIdx, "ITEMNO") == 11)
			{
				if (Global.userTbl.getData(0, "RELEASE_LV") == 1)
				{
					mc.msg_txt.text = "購入済みです。";
					return;
				}
			}
			//--------
			//合成+1
			if (Global.shopTbl.getData(selectedItemIdx, "ITEMNO") == 12)
			{
				if (1 <= Global.userTbl.getData(0, "MIX_LV"))
				{
					mc.msg_txt.text = "購入済みです。";
					return;
				}
			}
			*/
			var itemNo:int = int(Global.shopTbl.getData(selectedItemIdx, "ITEMNO"));
			if ((10 <= itemNo) && (itemNo <= 12))
			{
				if (isPurchased(itemNo))
				{
					mc.msg_txt.text = "購入済みです。";
					return;
				}
			}

			//--------
			//合成+2
			if (int(Global.shopTbl.getData(selectedItemIdx, "ITEMNO")) == 13)
			{
				if (2 <= int(Global.userTbl.getData(0, "MIX_LV")))
				{
					mc.msg_txt.text = "購入済みです。";
					return;
				}
				if (int(Global.userTbl.getData(0, "MIX_LV")) <= 0)
				{
					mc.msg_txt.text = "勾玉合成道具+1を購入しないと購入できません。";
					return;
				}
			}
			
			var money:int = int(Global.userTbl.getData(0, "RELEASE"));
			var price:int = int(Global.shopTbl.getData(selectedItemIdx, "PRICE"));
			if (money < price)
			{
				mc.msg_txt.text = "霊銭が足りません。";
				return;
			}
			mc.msg_txt.text = "購入中…";
			
			isNowBuy = true;
			
			var obj:Object = new Object();
			obj.name = Global.username;
			obj.pwd = Global.pwd;
			obj.itemno = Global.shopTbl.getData(selectedItemIdx, "ITEMNO");
			bc.connect(obj, buyOK);
		}
		private function buyOK(bool:Boolean):void
		{
			if (bool)
			{

			}
			
			show();
			
			mc.msg_txt.text = bc.message;
			
			isNowBuy = false;
		}

	}

}