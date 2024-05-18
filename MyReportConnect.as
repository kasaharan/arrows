package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class MyReportConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.name = obj.name;
			vars.loadtype = obj.loadtype;
			
			vars.sendtime = Global.getLocalTime();
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name));

			send(vars, "ar_myreport3.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response === "OK")
				{
					if (vars.rdata != null)
					{
						Global.myReportTbl = new Table(Global.MYREPORT_TABLE, vars.rdata, false);
					}

					Global.isMake = (vars.ismake == "1");
					
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
				trace("MyReportConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
