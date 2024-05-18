package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class LoginConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			loadedFunc = retFunc;

			var vars:URLVariables = new URLVariables();

			vars.name = obj.name;
			//vars.pwd = Hash.getCryptogram( 131, obj.pwd ).substr(0, 8);
			vars.pwd = Hash.getCryptogram( 131, obj.pwd ).substr(0, 16);
			vars.sendtime = Global.getLocalTime();
			//vars.fpver = Global.flashPlayerVersion;
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.pwd);

vars.ls = LocalStorage.getItem(LocalStorage.key);

			send(vars, "ar_login16.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response === "OK")
				{
					Global.userTbl = new Table(Global.USER_TABLE, vars.udata, false);
					Global.itemTbl = new Table(Global.ITEM_TABLE, vars.idata, true);
					Global.equipTbl = new Table(Global.EQUIP_TABLE, vars.edata, false);
					Global.silhouetteTbl = new Table(Global.SILHOUETTE_TABLE, vars.silhouette, false);
					Global.tobatsuTbl = new Table(Global.TOBATSU_TABLE, vars.tobatsu, false);
					Global.useryumiTbl = new Table(Global.USERYUMI_TABLE, vars.useryumi, false);
					Global.friendNewsTbl = new Table(Global.FRIEND_NEWS_TABLE, vars.news, false);
					Global.noroi2ClearTbl = new Table(Global.NOROI2CLEAR_TABLE, vars.n2clr, false);

					Global.scenario.lastClearIndex = int(Global.userTbl.getData(0, "SCENARIO"));
					Hamayumi.exp = int(Global.userTbl.getData(0, "EXP"));
					Global.username = Global.userTbl.getData(0, "NAME");
					Global.initEquipIdx();
					Global.favoriteData = Global.myUncompress(vars.fdata);
					ItemGamen.itemSortData = Global.myUncompress(vars.sdata);
					Global.loginInfo = vars.linfo;
					Item.MAX_COUNT = int(Global.userTbl.getData(0, "ITEMCNT"));

					Global.selectGamen.initSettingNearLevel();
					
					loadedFunc(true);
					return;
				}
				else if (vars.response === "USED")
				{
					message = "その名前はすでに使われています。";
				}
				else if (vars.response === "REGISTNG")
				{
					message = "短時間での複数ユーザ登録はできません。";
				}
				else if (vars.response === "NG")
				{
					message = "失敗";
				}
				else
				{
					message = "通信エラー？";
				}
			}
			catch (e:Error)
			{
				trace("Login:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
