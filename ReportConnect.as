package  
{
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.utils.escapeMultiByte;
	import flash.utils.unescapeMultiByte;

	/**
	 * ...
	 * @author kasaharan
	 */
	public class ReportConnect extends Connect
	{
		
		public function connect(retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;
		
			vars.sendtime = Global.getLocalTime();
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime);

			send(vars, "ar_report14.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response === "OK")
				{
					Global.reportTbl = new Table(Global.REPORT_TABLE, vars.imgdata, false);
					
					message = ".";

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
				trace("ReportConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

		
	}

}