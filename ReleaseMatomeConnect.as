package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class ReleaseMatomeConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.name = obj.name;
			vars.pwd = Hash.getCryptogram( 131, obj.pwd ).substr(0, 16);
			vars.id = obj.id;
			vars.matomeid = obj.matomeid;

			for (i = 0; i < Item.EQUIP_MAX_CNT; i++)
			{
				vars["equip" + (i + 1)] = obj["equip" + (i + 1)];
			}

			vars.sendtime = Global.getLocalTime();

			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.pwd);

			send(vars, "ar_release_matome4.php");
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
					Global.initEquipIdx();
					
					Global.itemGamen.reisenCnt = vars.reisen;

					loadedFunc(true);
					return;
				}
				else
				{
					message = "通信エラー？";
				}
			}
			catch (e:Error)
			{
				trace("ReleaseConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
