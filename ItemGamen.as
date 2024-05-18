package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	public class ItemGamen extends Sprite
	{
		private var mc:MovieClip;
		//private var scenario:Scenario;
		//private var itemTf:Vector.<TextField>;
		public var itemTf:Vector.<TextField>;
		private var favTf:Vector.<TextField>;
		private var selectItemIdx:int = 0;
		private var selectFavIdx:int = 0;
		//private var equipIdx:Vector.<int> = new Vector.<int>;
		private var equipIdx:Vector.<int> = Global.equipIdx;
		private var callbackCloseFunc:Function;
		private var ec:EquipConnect = new EquipConnect();
		private var rc:ReleaseConnect = new ReleaseConnect();
		private var rcMatome:ReleaseMatomeConnect = new ReleaseMatomeConnect();
		private var confirmGamen:ConfirmGamen;
		private var confirmMatometeGamen:ConfirmGamen;
		private var confirmFavRegistGamen:ConfirmGamen;
		private var confirmFavEquipGamen:ConfirmGamen;
		private var favoriteSetting:Vector.<Vector.<String>> = new Vector.<Vector.<String>>;
		//private var fmtMagatama30:TextFormat = new TextFormat();
		public var fmtMagatama30:TextFormat = new TextFormat();
		private var matometeKaiho:Vector.<int> = new Vector.<int>;
		
		public var reisenCnt:int = 0;	//取得霊銭表示用

		public function ItemGamen
		(
			  _mc:MovieClip
			 ,clickItemClose:Function
		)
		{
			var i:int, k:int;

			mc = _mc;
			addChild(mc);

			for (i = 0; i < Item.EQUIP_MAX_CNT; i++)
			{
				equipIdx[i] = -1;
			}

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
				itemTf[i].borderColor = 0xffffff;
			}

			for (i = 0; i < 10; i++)
			{
				favoriteSetting[i] = new Vector.<String>;
				for (k = 0; k < 3; k++)
				{
					favoriteSetting[i][k] = "";
				}
			}
			favTf = Vector.<TextField>
			([
				 mc.fav01_txt
				,mc.fav02_txt
				,mc.fav03_txt
				,mc.fav04_txt
				,mc.fav05_txt
				,mc.fav06_txt
				,mc.fav07_txt
				,mc.fav08_txt
				,mc.fav09_txt
				,mc.fav00_txt
			]);
			for (i = 0; i < favTf.length; i++)
			{
				addSpriteBtn(favTf[i], clickFav);
				favTf[i].border = false;
				favTf[i].borderColor = 0xffffff;
			}

			addSpriteBtn(mc.fav_regist_txt, clickFavRegist);
			addSpriteBtn(mc.fav_equip_txt, clickFavEquip);

			addSpriteBtn(mc.equip_txt, clickEquip);
			addSpriteBtn(mc.release_txt, clickRelease);
			callbackCloseFunc = clickItemClose;
			addSpriteBtn(mc.close_txt, clickClose);
			
			addSpriteBtn(mc.removeall_txt, clickRemoveAll);
			
			addSpriteBtn(mc.levelup_txt, clickLevelup);
			mc.levelup_txt.visible = false;
			
			//並び替えイベント登録
			for (i = 0; i < itemTf.length; i++)
			{
				itemTf[i].parent.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownSort);
				itemTf[i].parent.addEventListener(MouseEvent.MOUSE_UP, mouseUpSort);
			}
			
			//確認ウインドウ
			confirmGamen = new ConfirmGamen(new ConfirmMC(), clickYes);
			addChild(confirmGamen);
			confirmGamen.visible = false;
			
			//確認ウインドウ(まとめて解放)
			confirmMatometeGamen = new ConfirmGamen(new ConfirmMC(), clickYesMatomete);
			addChild(confirmMatometeGamen);
			confirmMatometeGamen.visible = false;

			//確認ウインドウ（お気に入り登録）
			confirmFavRegistGamen = new ConfirmGamen(new ConfirmMC(), clickYesFavRegist);
			addChild(confirmFavRegistGamen);
			confirmFavRegistGamen.visible = false;

			//確認ウインドウ（お気に入り装備）
			confirmFavEquipGamen = new ConfirmGamen(new ConfirmMC(), clickYesFavEquip);
			addChild(confirmFavEquipGamen);
			confirmFavEquipGamen.visible = false;
			
			//--------
			//サーバにお気に入りデータがあれば優先して使う
			try
			{
				var favNo:int = 0, idx:int = 0;
				var json:Object = JSON.parse( LocalStorage.getItem("arrows_favorite") );
				for (var obj:Object in json)
				{
					idx = 0;
					for (var val:Object in json[obj])
					{
						favoriteSetting[favNo][idx] = (String)(json[obj][val]);
						idx++;
					}
					favNo++;
				}
			}
			catch (e:Error) { }
			
			//--------
			fmtMagatama30.size = 14;
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

			btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_SELECT_COLOR;showExplain(tf);});
			btn.addEventListener(MouseEvent.MOUSE_OUT,  function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;});
			btn.addEventListener(MouseEvent.CLICK, f);
		}

		// ----------------
		// showExplain
		// ----------------
		private function showExplain(tf:TextField):void
		{
			if (tf == mc.release_txt)
			{
				mc.msg_txt.text = "SHIFTキーを押しながらクリックで複数選択し、まとめて解放することもできます。";
			}
		}

		// ----------------
		// clickRemoveAll
		// ----------------
		private function clickRemoveAll(e:MouseEvent):void
		{
			var i:int;

			for (i = 0; i < equipIdx.length; i++)
			{
				equipIdx[i] = -1;
			}
			
			show();
		}

		// ----------------
		// clickClose
		// ----------------
		private function clickClose(e:MouseEvent):void
		{
			//if (Global.isChangeEquip())
			if ((Global.isChangeEquip() == true) || (isExchange == true))
			{
				var i:int;
				var obj:Object = new Object();
				obj.name = Global.username;

				for (i = 0; i < Item.EQUIP_MAX_CNT; i++)
				{
					if (0 <= equipIdx[i])
					{
						obj["equip" + (i + 1)] = Global.itemTbl.getData(equipIdx[i], "ID");
					}
					else
					{
						obj["equip" + (i + 1)] = -1;
					}
				}
				
				obj.sortdata = itemSortData;
				
				ec.connect(obj, function(bool:Boolean):void{ callbackCloseFunc(); });
			}
			else
			{
				callbackCloseFunc();
			}
			
			
			//--------
			isExchange = false;
		}

		// ----------------
		// clickLevelup
		// ----------------
		private var magatamaLvupConnect:MagatamaLvupConnect = new MagatamaLvupConnect();
		private function clickLevelup(e:MouseEvent):void
		{
			if (selectItemIdx < 0)
			{
				return;
			}

			mc.levelup_txt.visible = false;
			
			var i:int;
			var obj:Object = new Object();
			obj.name = Global.username;
			obj.id = Global.itemTbl.getData(selectItemIdx, "ID");

			for (i = 0; i < Item.EQUIP_MAX_CNT; i++)
			{
				if (0 <= equipIdx[i])
				{
					obj["equip" + (i + 1)] = Global.itemTbl.getData(equipIdx[i], "ID");
				}
				else
				{
					obj["equip" + (i + 1)] = -1;
				}
			}

			magatamaLvupConnect.connect(obj, lvupOKFunc);
		}
		private function lvupOKFunc(bool:Boolean):void
		{
			if (bool)
			{
				show();
				mc.levelup_txt.visible = false;
				mc.msg_txt.text = "勾玉レベルアップ！能力値が上がりました。";
			}
			else
			{
				mc.levelup_txt.visible = true;
			}
		}

		// ----------------
		// refresh
		// ----------------
		public function refresh():void
		{
			var i:int;
			var str:String = "";

			//--------
			for (i = 0; i < itemTf.length; i++)
			{
				itemTf[i].border = false;
				itemTf[i].borderColor = 0xffffff;
			}
			if (0 <= selectItemIdx)
			{
				itemTf[selectItemIdx].border = true;
			}
			
			//--------
			for (i = 0; i < favTf.length; i++)
			{
				favTf[i].border = false;
			}
			favTf[selectFavIdx].border = true;

			//--------
			//勾玉合計値表示
			mc.status_txt.text = getSumKindValue();

			//--------
			mc.equip_txt.text = "装備する";
			for (i = 0; i < equipIdx.length; i++)
			{
				if (selectItemIdx == equipIdx[i])
				{
					mc.equip_txt.text = "はずす";
					break;
				}
			}
			
			//--------
			Game.flashStage.focus = this;	//念のため
			for (i = 0; i < matometeKaiho.length; i++ )
			{
				itemTf[ matometeKaiho[i] ].border = true;
				//itemTf[ matometeKaiho[i] ].borderColor = 0xF6CA06;
				itemTf[ matometeKaiho[i] ].borderColor = 0xEDAD0B
			}
		}

		// ----------------
		// getSumKindValue
		// ----------------
		public static function getSumKindValue():String
		{
			var i:int;
			var str:String = "";
			var kindValue:Vector.<int> = Global.getKindValue();

			for (i = 1; i < Item.kindName.length; i++)
			{
				if (0 < kindValue[i])
				{
					if (Item.isWaza[i])
					{
						str += Item.kindName[i] + " ";
					}
					else if (Item.isWazaKyoka[i])
					{
						str += Item.kindName[i] + " ";
					}
					else if (0 <= Item.kindName[i].indexOf("呪"))
					{
						str += Item.kindName[i] + " ";
					}
					else
					{
						str += Item.kindName[i] + "+" + kindValue[i] + " ";
					}
				}
			}

			return str;
		}
		
		// ----------------
		// clickRelease
		// ----------------
		public function clickRelease(e:MouseEvent):void
		{
			var i:int;
			var m:int;

			if (0 < matometeKaiho.length)
			{
				//まとめて解放
				for (m = 0; m < matometeKaiho.length; m++)
				{
					if (Global.itemTbl.getCount() <= matometeKaiho[m])
					{
						mc.msg_txt.text = "解放できません。";
						return;
					}

					mc.msg_txt.text = "";
					for (i = 0; i < equipIdx.length; i++)
					{
						if (equipIdx[i] == matometeKaiho[m])
						{
							mc.msg_txt.text = "装備している勾玉は解放できません。";
							return;
						}
					}
				}
				confirmMatometeGamen.setMessage("\n選択した勾玉をまとめて解放します。解放すると勾玉は消滅します。\nよろしいですか？");
				confirmMatometeGamen.visible = true;
			}
			else
			{
				if (selectItemIdx < 0)
				{
					mc.msg_txt.text = "勾玉を選択してください。";
					return;
				}
				if (Global.itemTbl.getCount() <= selectItemIdx)
				{
					mc.msg_txt.text = "勾玉を選択してください。";
					return;
				}

				mc.msg_txt.text = "";
				for (i = 0; i < equipIdx.length; i++)
				{
					if (equipIdx[i] == selectItemIdx)
					{
						mc.msg_txt.text = "装備している勾玉は解放できません。";
						return;
					}
				}

				confirmGamen.setMessage("\n解放すると勾玉は消滅します。\nよろしいですか？");
				confirmGamen.visible = true;
			}
		}
		private function clickYes(e:MouseEvent):void
		{
			var i:int;
			var obj:Object = new Object();
			obj.name = Global.username;
			obj.pwd = Global.pwd;
			obj.id = Global.itemTbl.getData(selectItemIdx, "ID");

			for (i = 0; i < Item.EQUIP_MAX_CNT; i++)
			{
				if (0 <= equipIdx[i])
				{
					obj["equip" + (i + 1)] = Global.itemTbl.getData(equipIdx[i], "ID");
				}
				else
				{
					obj["equip" + (i + 1)] = -1;
				}
			}

			rc.connect(obj, function(bool:Boolean):void
				{
					show();
					confirmGamen.visible = false;
					mc.msg_txt.text = "解放しました。" + "霊銭 " + reisenCnt + " 文を手に入れました。"; 
				} );
		}
		private function clickYesMatomete(e:MouseEvent):void 
		{
			var i:int;
			var obj:Object = new Object();
			obj.name = Global.username;
			obj.pwd = Global.pwd;

			var tmpStr:String = "";
			for (i = 0; i < matometeKaiho.length; i++ )
			{
				tmpStr += Global.itemTbl.getData(matometeKaiho[i], "ID")
				if (i == matometeKaiho.length - 1)
				{
					//nop;
				}
				else
				{
					tmpStr += ",";
				}
			}
			obj.matomeid = tmpStr;
			
			for (i = 0; i < Item.EQUIP_MAX_CNT; i++)
			{
				if (0 <= equipIdx[i])
				{
					obj["equip" + (i + 1)] = Global.itemTbl.getData(equipIdx[i], "ID");
				}
				else
				{
					obj["equip" + (i + 1)] = -1;
				}
			}

			rcMatome.connect(obj, function(bool:Boolean):void
				{
					matometeKaiho = new Vector.<int>;
					show();
					confirmMatometeGamen.visible = false;
					mc.msg_txt.text = "解放しました。" + "霊銭 " + reisenCnt + " 文を手に入れました。"; 
				} );
		}

		// ----------------
		// show
		// ----------------
		//public function show()
		public function show(isFixedMagatama30:Boolean = true):void
		{
			var i:int, k:int, c:int;

			for (i = 0; i < itemTf.length; i++)
			{
				itemTf[i].text = "";
			}
			
			//init
			matometeKaiho = new Vector.<int>;

			//--------
			//ソートデータで並びなおし
			/*
			var _sortData:Array = itemSortData.split(",");
			for (i = 0; i < Global.itemTbl.getCount(); i++)
			{
				if (_sortData[i] == Global.itemTbl.getData(i, "ID"))
				{
					//OK
				}
				else
				{
					//違う
					for (k = 0; k < Global.itemTbl.getCount(); k++ )
					{
						if (_sortData[i] == Global.itemTbl.getData(k, "ID"))
						{
							//入れ替え
							mouseDownNo = i;
							mouseUpNo = k;
							exchageItem();
							mouseDownNo = mouseUpNo = -1;
							break;
						}
					}
				}
			}
			*/
			
			//********
			//遅いのでハッシュ作成をOFF
			Global.itemTbl.hashOff();
			//********
			
			var _sortData:Array = itemSortData.split(",");
			//----------------
			//存在しないIDをソートデータから削除する
			for (i = 0; i < _sortData.length; i++)
			{
				for (k = 0; k < Global.itemTbl.getCount(); k++ )
				{
					if (_sortData[i] == Global.itemTbl.getData(k, "ID"))
					{
						break;
					}
				}
				if (k == Global.itemTbl.getCount())
				{
					_sortData.splice(i, 1);
					i--;
				}
			}
			//----------------
			//for (i = 0; i < Global.itemTbl.getCount(); i++)
			for (i = 0; i < _sortData.length; i++)
			{
				if (_sortData[i] == Global.itemTbl.getData(i, "ID"))
				{
					//OK
				}
				else
				{
					//違う
					for (k = 0; k < Global.itemTbl.getCount(); k++ )
					{
						if (_sortData[i] == Global.itemTbl.getData(k, "ID"))
						{
							//入れ替え
							mouseDownNo = i;
							mouseUpNo = k;
							exchageItem(false, false);
							mouseDownNo = mouseUpNo = -1;
							break;
						}
					}
				}
			}
			
			//********
			//ハッシュ作成をON
			Global.itemTbl.hashOn();
			//********
			//--------
			
			var kind1:int;
			var kind2:int;
			var kind3:int;
			var value1:int;
			var value2:int;
			var value3:int;
			var str:String;
			
			for (i = 0; i < Global.itemTbl.getCount(); i++)
			{
				str = "[　　]";

				for (k = 0; k < equipIdx.length; k++)
				{
					if (i == equipIdx[k])
					{
						str = "[装備]";
					}
				}

				itemTf[i].text = str + Global.getItemName(i);
			}

			refresh();
			
			//--------勾玉がない場合はお気に入り出さない
			//if (Global.itemTbl.getCount() == 0)
			if (Global.itemTbl.getCount() < 3)
			{
				for (i = 0; i < favTf.length; i++)
				{
					favTf[i].visible = false;
				}
				mc.fav_regist_txt.visible = false;
				mc.fav_equip_txt.visible = false;
			}
			else
			{
				for (i = 0; i < favTf.length; i++)
				{
					favTf[i].visible = true;
				}
				mc.fav_regist_txt.visible = true;
				mc.fav_equip_txt.visible = true;
			}
			
			
			//--------
			//サーバにお気に入りデータがあれば優先して使う
			/*
			try
			{
				var favNo:int = 0, idx:int = 0;
				var json:Object= JSON.parse( Global.favoriteData );

				for (var obj:Object in json)
				{
					idx = 0;
					for (var val:Object in json[obj])
					{
						favoriteSetting[favNo][idx] = (String)(json[obj][val]);
						idx++;
					}
					favNo++;
				}
			}
			catch(e:Error){}
			*/
			setFavData();
			
			//--------勾玉３０個処理
			if (0 < Global.userTbl.getCount())
			{
				//Item.MAX_COUNT = Global.userTbl.getData(0, "ITEMCNT");
				if (isFixedMagatama30)
				{
					if (Item.MAX_COUNT == 30)
					{
						for (i = 0; i < itemTf.length; i++)
						{
							itemTf[i].width = 160;
						}
						for (i = 10; i < 20; i++)
						{
							itemTf[i].x = 220;
						}
						for (i = 20; i < 30; i++)
						{
							itemTf[i].x = 430;
						}
					}
				}
			}
			/*
			if (Item.MAX_COUNT == 30)
			{
				for (i = 0; i < itemTf.length; i++)
				{
					itemTf[i].setTextFormat(fmtMagatama30);
				}
			}
			*/
			/*
			var fontsize:int = 20;
			if (Item.MAX_COUNT == 30)
			{
				fontsize = 14;
			}
			*/
			//--------
			
			//--------お気に入りに使用している勾玉をわかるように色変える
			for (i = 0; i < Global.itemTbl.getCount(); i++)
			{
				if (isUseFav(i))
				{
					itemTf[i].textColor = 0xff7fff;
					//itemTf[i].htmlText = "<font color='#ff7fff' size='" + fontsize + "'>" + itemTf[i].text + "</font>"
				}
				else
				{
					itemTf[i].textColor = 0xffffff;
					//itemTf[i].htmlText = "<font color='#ffffff' size='" + fontsize + "'>" + itemTf[i].text + "</font>"
				}
			}
			
			/*
			//--------
			for (i = 0; i < Global.itemTbl.getCount(); i++)
			{
				if (Global.itemTbl.getData(i, "MIX") == 1)
				{
					var midx:int = Global.getItemName(i).indexOf("勾玉");
					if (0 <= midx)
					{
						itemTf[i].htmlText = itemTf[i].htmlText.replace("勾玉", "<i>勾玉</i>");
					}
				}
			}
			*/

			//--------
			if (this.hasEventListener(Event.ENTER_FRAME) == false)
			{
				addEventListener(Event.ENTER_FRAME, enterFrame);
			}
/*
			//--------勾玉３０個処理
			if (0 < Global.userTbl.getCount())
			{
				//Item.MAX_COUNT = Global.userTbl.getData(0, "ITEMCNT");
				if (isFixedMagatama30)
				{
					if (Item.MAX_COUNT == 30)
					{
						for (i = 0; i < itemTf.length; i++)
						{
							itemTf[i].width = 160;
						}
						for (i = 10; i < 20; i++)
						{
							itemTf[i].x = 220;
						}
						for (i = 20; i < 30; i++)
						{
							itemTf[i].x = 430;
						}
					}
				}
			}
			if (Item.MAX_COUNT == 30)
			{
				for (i = 0; i < itemTf.length; i++)
				{
					//itemTf[i].setTextFormat(fmtMagatama30);
					itemTf[i].htmlText = "<font color='#ffffff' size='14'>" + itemTf[i].text + "</font>"
				}
			}
			//--------
*/

			for (i = 0; i < Global.itemTbl.getCount(); i++)
			{
				if (int(Global.itemTbl.getData(i, "MIX")) == 1)
				{
					/*
					var fmt:TextFormat = itemTf[i].getTextFormat();
					fmt.underline = true;
					itemTf[i].setTextFormat(fmt);
					*/
					//itemTf[i].appendText("*");
					itemTf[i].text = itemTf[i].text.replace("]勾玉(", "]勾玉*(");
				}
			}
			
			//--------
			if (Item.MAX_COUNT == 30)
			{
				for (i = 0; i < itemTf.length; i++)
				{
					itemTf[i].setTextFormat(fmtMagatama30);
				}
			}

			//--------キーイベント登録
			Game.flashStage.focus = this;//フォーカス当てないとキーイベントが効かない
			if (this.hasEventListener(KeyboardEvent.KEY_DOWN) == false)
			{
				this.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			}
			if (this.hasEventListener(KeyboardEvent.KEY_UP) == false)
			{
				this.addEventListener(KeyboardEvent.KEY_UP, onKeyup);
			}
		}
		
		// ----------------
		// setFavData
		// ----------------
		public function setFavData():void
		{
			try
			{
				var favNo:int = 0, idx:int = 0;
				var json:Object= JSON.parse( Global.favoriteData );

				for (var obj:Object in json)
				{
					idx = 0;
					for (var val:Object in json[obj])
					{
						favoriteSetting[favNo][idx] = (String)(json[obj][val]);
						idx++;
					}
					favNo++;
				}
			}
			catch(e:Error){}
		}

		// ----------------
		// clickItem
		// ----------------
		public function clickItem(e:MouseEvent):void
		{
			var i:int;
			var k:int;
			for (i = 0; i < itemTf.length; i++)
			{
				if (e.target == itemTf[i].parent)
				{
					selectItemIdx = i;
					break;
				}
			}
			
			//--------
			if (onShiftKey)
			{
				matometeKaiho.push(selectItemIdx);
			}
			else
			{
				//clear
				matometeKaiho = new Vector.<int>;
			}
			
			refresh();

			//--------
			//mc.msg_txt.text = Global.getItemNameDetail(selectItemIdx);
			var str:String = Global.getItemNameDetail(selectItemIdx);
			
			//--------
			if (Global.itemTbl.getCount() <= selectItemIdx)
			{
				return;
			}
			
			//--------
			//勾玉の経験値
			mc.levelup_txt.visible = false;
			var exp:int = int(Global.itemTbl.getData(selectItemIdx, "EXP"));
			var level:int = int(Global.itemTbl.getData(selectItemIdx, "LEVEL"));
			if (0 < exp)
			{				
				//var needExp:Vector.<int> = Vector.<int>([0, 20, 50, 100]);
				//if (getMagatamaMaxLv(selectItemIdx) < level)
				var maxLv:int = getMagatamaMaxLv(selectItemIdx);
				if (maxLv < level)
				{
					str += " [勾玉レベル:" + level + "/" + (maxLv + 1) + " 蓄積霊力:*/*]";
				}
				else
				{
					str += " [勾玉レベル:" + level + "/" + (maxLv + 1) + " 蓄積霊力:" + exp + "/" + magatamaNeedExp[level] + "]";
					if (magatamaNeedExp[level] <= exp)
					{
						mc.levelup_txt.visible = true;
					}
				}
			}
			//--------
			
			var kyokaKind:int = Global.getMagatamaWazaKyokaKind(selectItemIdx);
			//if (0 <= str.indexOf("技"))
			if (Global.isEquipWaza(selectItemIdx))
			{
				//tr += "\n弓を引くメーターが青くなるまで引くことで技を使えます";
				str += "\n弓を引くゲージが青くなるまで引くことで技を使えます";
			}
			//else if (Global.isEquipWazaKyoka(selectItemIdx))
			else if (0 <= kyokaKind)
			{
				//str += "\n変化の勾玉と技の勾玉の適切な組み合わせは技を変化させます。";
				if (kyokaKind == Item.KIND_IDX_KYOKA_HANABI2)
				{
					str += "\n技[花火]の勾玉と組み合わせることで地面で燃え上がる火矢を放ちます";
				}
				else if (kyokaKind == Item.KIND_IDX_KYOKA_BABABA)
				{
					str += "\n技[バババッ]の勾玉と組み合わせることで空中で凍る氷矢を放ちます";
				}
			}

			if (0 <= str.indexOf("[呪]"))
			{
				str += " 呪いにより妖魔の霊力を増幅します。勾玉変換時の勾玉の能力にも影響します。戦闘中に勾玉の付替えは出来ません。";
			}
			mc.msg_txt.text = str;
		}

		// ----------------
		// getMagatamaMaxLv
		// ----------------
		public static var magatamaNeedExp:Vector.<int> = Vector.<int>([0, 20, 50, 100]);
		public static function getMagatamaMaxLv(idx:int):int
		{
			var i:int;
			var k:int;
			//勾玉最大レベル取得
			var kind1:int = int(Global.itemTbl.getData(idx, "KIND1"));
			var kind2:int = int(Global.itemTbl.getData(idx, "KIND2"));
			var kind3:int = int(Global.itemTbl.getData(idx, "KIND3"));
			
			var maxLv:int = 1;
			var ckeckKind:Vector.<int> = Vector.<int>([kind1, kind2, kind3]);
			var okKind:Vector.<int> = Vector.<int>([1, 2, 3, 4, 5, 6, 10]);
			for (i = 0; i < ckeckKind.length; i++ )
			{
				for (k = 0; k < okKind.length; k++ )
				{
					if (ckeckKind[i] == okKind[k])
					{
						//ok
						maxLv = i + 1;
						break;
					}
				}
				if (k == okKind.length)
				{
					break;
				}
			}
			
			return maxLv;
		}
		
		//================================
		// ----------------
		// clickFav
		// ----------------
		public function clickFav(e:MouseEvent):void
		{
			var i:int, k:int;
			var str:String = "";

			for (i = 0; i < favTf.length; i++)
			{
				if (e.target == favTf[i].parent)
				{
					selectFavIdx = i;
					break;
				}
			}
			refresh();

			//お気に入り装備の合計能力値を表示 --------
			var favIdx:Vector.<int> = new Vector.<int>;
			for (i = 0; i < 3; i++)
			{
				favIdx[i] = -1;
			}

			for (k = 0; k < favoriteSetting[selectFavIdx].length; k++)
			{
				for (i = 0; i < Global.itemTbl.getCount(); i++)
				{
					if (favoriteSetting[selectFavIdx][k] == Global.itemTbl.getData(i, "ID"))
					{
						favIdx[k] = i;
					}
				}
			}
			//--------
			var kindValue:Vector.<int> = Global.getKindValueFav(favIdx);

			for (i = 1; i < Item.kindName.length; i++)
			{
				if (0 < kindValue[i])
				{
					if (Item.isWaza[i])
					{
						str += Item.kindName[i] + " ";
					}
					else if (Item.isWazaKyoka[i])
					{
						str += Item.kindName[i] + " ";
					}
					else if (0 <= Item.kindName[i].indexOf("呪"))
					{
						str += Item.kindName[i] + " ";
					}
					else
					{
						str += Item.kindName[i] + "+" + kindValue[i] + " ";
					}
				}
			}
			
			if (str.length <= 0)
			{
				str = "お気に入りに登録した勾玉は文字色が紫色になります。";
			}
			
			mc.msg_txt.text = "お気に入り[" + favNoStr[selectFavIdx] + "]。戦闘中に[" + favNoStr[selectFavIdx] + "]キーで勾玉を付け替えます。\n" + str;
			
			//--------
			//お気に入りに使用している勾玉が分かるようにする。
			for (i = 0; i < itemTf.length; i++)
			{
				itemTf[i].border = false;
			}
			for (i = 0; i < favIdx.length; i++)
			{
				if (0 <= favIdx[i])
				{
					itemTf[favIdx[i]].border = true;
					itemTf[favIdx[i]].borderColor = 0xff7fff;
				}
			}
			//選択状態解除
			selectItemIdx = -1;
			matometeKaiho = new Vector.<int>;
		}

		// ----------------
		// clickFavRegist
		// ----------------
		private var favNoStr:Vector.<String> = Vector.<String>(["1","2","3","4","5","6","7","8","9","0"]);
		public function clickFavRegist(e:MouseEvent):void
		{
			confirmFavRegistGamen.setMessage("\n今の装備をお気に入り[" + favNoStr[selectFavIdx] + "]に登録します。よろしいですか？");
			confirmFavRegistGamen.visible = true;
		}
		// ----------------
		// clickYesFavRegist
		// ----------------
		public function clickYesFavRegist(e:MouseEvent):void
		{
			var i:int;
			for (i = 0; i < favoriteSetting[selectFavIdx].length; i++)
			{
				favoriteSetting[selectFavIdx][i] = "";
			}
			for (i = 0; i < equipIdx.length; i++)
			{
				if (0 <= equipIdx[i])
				{
					favoriteSetting[selectFavIdx][i] = Global.itemTbl.getData(equipIdx[i], "ID");
				}
			}
			mc.msg_txt.text = "お気に入り[" + favNoStr[selectFavIdx] + "]に登録しました。";
			
			confirmFavRegistGamen.visible = false;


			//--------
			var saveData:String = JSON.stringify(favoriteSetting);
			LocalStorage.setItem("arrows_favorite", saveData);

//--------
var f:FavoriteConnect = new FavoriteConnect();
var obj:Object = new Object();
obj.name = Global.username;
obj.fav = Global.myCompress(saveData);
f.connect(obj, function(bool:Boolean):void{});
Global.favoriteData = saveData;

show();
//--------
		}

		// ----------------
		// clickFavEquip
		// ----------------
		public function clickFavEquip(e:MouseEvent):void
		{
			confirmFavEquipGamen.setMessage("\nお気に入り[" + favNoStr[selectFavIdx] + "]装備に変更します。よろしいですか？");
			confirmFavEquipGamen.visible = true;
		}
		// ----------------
		// clickYesFavEquip
		// ----------------
		public function clickYesFavEquip(e:MouseEvent):void
		{
			var i:int, k:int;
			var str:String = "";

			for (i = 0; i < equipIdx.length; i++)
			{
				equipIdx[i] = -1;
			}

			for (k = 0; k < favoriteSetting[selectFavIdx].length; k++)
			{
				for (i = 0; i < Global.itemTbl.getCount(); i++)
				{
					if (favoriteSetting[selectFavIdx][k] == Global.itemTbl.getData(i, "ID"))
					{
						equipIdx[k] = i;
					}
				}
			}
			
			show();

			confirmFavEquipGamen.visible = false;
		}
		
		// ----------------
		// setFavEquip
		// ----------------
		public function setFavEquip(favNo:int):void
		{
			var i:int, k:int;
			//var str:String = "";

			selectFavIdx = favNo;

			//init
			for (i = 0; i < equipIdx.length; i++)
			{
				equipIdx[i] = -1;
			}

			//setting
			for (k = 0; k < favoriteSetting[selectFavIdx].length; k++)
			{
				for (i = 0; i < Global.itemTbl.getCount(); i++)
				{
					if (favoriteSetting[selectFavIdx][k] == Global.itemTbl.getData(i, "ID"))
					{
						equipIdx[k] = i;
trace("equipIdx[k]:" + i);
					}
				}
			}
		}
		
		// ----------------
		// isUseFav
		// ----------------
		//お気に入り使用中勾玉かどうかわかるように
		public function isUseFav(magatamaIdx:int):Boolean
		{
			var i:int, k:int;

			for (i = 0; i < 10; i++)
			{
				for (k = 0; k < favoriteSetting[i].length; k++)
				{
					if (favoriteSetting[i][k] == Global.itemTbl.getData(magatamaIdx, "ID"))
					{
						return true;
					}
				}
			}
			return false;
		}
		
		//================================

		// ----------------
		// clickEquip
		// ----------------
		public function clickEquip(e:MouseEvent):void
		{
			var i:int;
			var isMaxEquip:Boolean = false;

			if (selectItemIdx < 0)
			{
				mc.msg_txt.text = "勾玉を選択してください。";
				return;
			}
			if (Global.itemTbl.getCount() <= selectItemIdx)
			{
				mc.msg_txt.text = "勾玉を選択してください。";
				return;
			}

			//はずす
			for (i = 0; i < equipIdx.length; i++)
			{
				if (selectItemIdx == equipIdx[i])
				{
					equipIdx[i] = -1;
					show();
					mc.msg_txt.text = "";
					return;
				}
			}

			//装備数チェック
			isMaxEquip = true;
			for (i = 0; i < equipIdx.length; i++)
			{
				if (equipIdx[i] == -1)
				{
					isMaxEquip = false;
				}
			}
			if (isMaxEquip)
			{
				mc.msg_txt.text = "勾玉はこれ以上装備できません。";
			}
			
			//技チェック
			/*
			if (0 <= Global.getItemNameDetail(selectItemIdx).indexOf("技"))
			{
				for (i = 0; i < equipIdx.length; i++)
				{
					if (0 <= equipIdx[i])
					{
						if (0 <= Global.getItemNameDetail(equipIdx[i]).indexOf("技"))
						{
							mc.msg_txt.text = "技の勾玉は１つしか装備できません。";
							return;
						}
					}
				}
			}
			*/
			if (Global.isEquipWaza(selectItemIdx))
			{
				for (i = 0; i < equipIdx.length; i++)
				{
					if (0 <= equipIdx[i])
					{
						if (Global.isEquipWaza(equipIdx[i]))
						{
							mc.msg_txt.text = "技の勾玉は１つしか装備できません。";
							return;
						}
					}
				}
			}
			
			//装備
			for (i = 0; i < equipIdx.length; i++)
			{
				if (equipIdx[i] == -1)
				{
					equipIdx[i] = selectItemIdx;
					show();
					mc.msg_txt.text = "";
					return;
				}
			}
		}


		// ----------------
		// 並び替え
		// ----------------
		private var mouseDownNo:int = -1;
		private var mouseUpNo:int = -1;
		public static var itemSortData:String = "";
		private var isExchange:Boolean = false;
		private function clickSort(e:MouseEvent):void
		{
			//dummy
		}
		private function mouseDownSort(e:MouseEvent):void
		{
			var i:int;
			for (i = 0; i < itemTf.length; i++)
			{
				if (e.target == itemTf[i].parent)
				{
					mouseDownNo = i;
					//mc.msg_txt.text = mouseDownNo;
					break;
				}
			}
		}
		private function mouseUpSort(e:MouseEvent):void
		{
			var i:int;
			for (i = 0; i < itemTf.length; i++)
			{
				if (e.target == itemTf[i].parent)
				{
					mouseUpNo = i;
					//mc.msg_txt.text = mouseUpNo;
					break;
				}
			}
			
			exchageItem(true);
		}
		private function exchageItem(isEffect:Boolean = false, isShow:Boolean = true):void
		{
			var i:int;
			var colname:Array = Global.ITEM_TABLE.split(",");

			if ((mouseDownNo < 0) || (Global.itemTbl.getCount() <= mouseDownNo))
			{
				return;
			}
			if ((mouseUpNo < 0) || (Global.itemTbl.getCount() <= mouseUpNo))
			{
				return;
			}
			if (mouseUpNo == mouseDownNo)
			{
				return;
			}
			
			var srcData:Dictionary = new Dictionary();
			//DOWNデータ退避
			for (i = 0; i < colname.length; i++ )
			{
				srcData[colname[i]] = Global.itemTbl.getData(mouseDownNo, colname[i]);
			}
			//DOWNデータにUPをコピー
			for (i = 0; i < colname.length; i++ )
			{
				Global.itemTbl.setData(mouseDownNo, colname[i], Global.itemTbl.getData(mouseUpNo, colname[i]));
			}
			//UPにDOWNをコピー
			for (i = 0; i < colname.length; i++ )
			{
				Global.itemTbl.setData(mouseUpNo, colname[i], srcData[colname[i]]);
			}
			
			if (isEffect)
			{
				Global.playShu();
				itemTf[mouseDownNo].x -= 12;
				itemTf[mouseUpNo].x += 12;
			}
			
			//装備index再作成
			//Global.initEquipIdx();
			
			for (i = 0; i < equipIdx.length; i++)
			{
				if (equipIdx[i] == mouseDownNo)
				{
					equipIdx[i] = mouseUpNo;
				}
				else if (equipIdx[i] == mouseUpNo)
				{
					equipIdx[i] = mouseDownNo;
				}
			}
			
			
			//ソートデータ再作成
			itemSortData = "";
			for (i = 0; i < Global.itemTbl.getCount(); i++ )
			{
				itemSortData += Global.itemTbl.getData(i, "ID") + ",";
			}
			//mc.msg_txt.text = Global.myCompress(itemSortData);
			
			if (isShow)
			{
				show(false);
			}
			
			isExchange = true;
		}

		// ----------------
		// close
		// ----------------
		public function close():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame);

			//--------キーイベント解除
			if (this.hasEventListener(KeyboardEvent.KEY_DOWN))
			{
				this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			}
			if (this.hasEventListener(KeyboardEvent.KEY_UP))
			{
				this.removeEventListener(KeyboardEvent.KEY_UP, onKeyup);
			}
		}

		// ----------------
		// enterFrame
		// ----------------
		private function enterFrame(e:Event):void
		{
			var i:int;
			var x1:int = 10;
			var x2:int = 330;
			var x3:int = 650;
			
			if (0 < Global.userTbl.getCount())
			{
				//Item.MAX_COUNT = Global.userTbl.getData(0, "ITEMCNT");
				if (Item.MAX_COUNT == 30)
				{
					x2 = 220;
					x3 = 430;
				}
			}

			/*
			for (i = 0; i < itemTf.length / 2; i++)
			{
				if (itemTf[i].x < 10)
				{
					itemTf[i].x++;
				}
				if (10 < itemTf[i].x)
				{
					itemTf[i].x--;
				}
			}
			for (i = itemTf.length / 2; i < itemTf.length; i++)
			{
				if (itemTf[i].x < 330)
				{
					itemTf[i].x++;
				}
				if (330 < itemTf[i].x)
				{
					itemTf[i].x--;
				}
			}
			*/
			for (i = 0; i < 10; i++)
			{
				if (itemTf[i].x < 10)
				{
					itemTf[i].x++;
				}
				if (10 < itemTf[i].x)
				{
					itemTf[i].x--;
				}
			}
			for (i = 10; i < 20; i++)
			{
				if (itemTf[i].x < x2)	//330
				{
					itemTf[i].x++;
				}
				if (x2 < itemTf[i].x)
				{
					itemTf[i].x--;
				}
			}
			for (i = 20; i < 30; i++)
			{
				if (itemTf[i].x < x3)
				{
					itemTf[i].x++;
				}
				if (x3 < itemTf[i].x)
				{
					itemTf[i].x--;
				}
			}

		}

		// ----------------
		// onKeydown
		// ----------------
		private var onShiftKey:Boolean = false;
		private function onKeydown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SHIFT)
			{
				onShiftKey = true;
			}
		}
		// ----------------
		// onKeyup
		// ----------------
		private function onKeyup(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SHIFT)
			{
				onShiftKey = false;
			}
		}
		
	}

}