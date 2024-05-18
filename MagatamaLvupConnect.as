package  
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	/**
	 * ...
	 * @author kasaharan
	 */
	public class MagatamaLvupConnect extends Connect
	{
		
		public function connect(obj:Object, retFunc:Function):void
		{
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.name = obj.name;
			vars.id = obj.id;

			for (i = 0; i < Item.EQUIP_MAX_CNT; i++)
			{
				vars["equip" + (i + 1)] = obj["equip" + (i + 1)];
			}

			vars.sendtime = Global.getLocalTime();

			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.id);

			send(vars, "ar_magatama_lvup2.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response === "OK")
				{
					Global.itemTbl = new Table(Global.ITEM_TABLE, vars.idata, true);
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