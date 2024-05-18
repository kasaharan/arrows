package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class EquipConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.name = obj.name;

			for (i = 0; i < Item.EQUIP_MAX_CNT; i++)
			{
				vars["equip" + (i + 1)] = obj["equip" + (i + 1)];
			}

			vars.sortdata = Global.myCompress(obj.sortdata);
			
			vars.sendtime = Global.getLocalTime();

			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.equip1);

			send(vars, "ar_equip2.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response === "OK")
				{
					/*
					Global.userTbl = new Table(Global.USER_TABLE, vars.udata);
					Global.itemTbl = new Table(Global.ITEM_TABLE, vars.idata);

					Global.scenario.lastClearIndex = Global.userTbl.getData(0, "SCENARIO");
					Hamayumi.exp = Global.userTbl.getData(0, "EXP");
					*/
					Global.equipTbl = new Table(Global.EQUIP_TABLE, vars.edata, false);
					Global.initEquipIdx();

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
				trace("Equip:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
