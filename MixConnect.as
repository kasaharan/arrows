package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class MixConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.name = obj.name;

			vars.magatama1 = obj.magatama1;
			vars.magatama2 = obj.magatama2;
			
			vars.sendtime = Global.getLocalTime();

			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.magatama1 + vars.magatama2);

			send(vars, "ar_mix4.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response == "OK")
				{
					Global.userTbl = new Table(Global.USER_TABLE, vars.udata, false);
					Global.itemTbl = new Table(Global.ITEM_TABLE, vars.idata, true);
					Global.magatamaID = vars.giid;
					Global.initEquipIdx();

					loadedFunc(true);
					return;
				}
				else if (vars.response == "MIXED")
				{
					message = "合成済の勾玉は合成できません。";
				}
				else if (vars.response == "NGTWO")
				{
					message = "勾玉を２つ選択してください。";
				}
				else if (vars.response == "NOMONEY")
				{
					message = "霊銭が足りません。";
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
