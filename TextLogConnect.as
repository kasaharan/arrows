package
{
	
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	/**
	 * ...
	 * @author kasaharan
	 */
	public class TextLogConnect extends Connect
	{
		public function connect(msg:String):void
		{
			var vars:URLVariables = new URLVariables();

			vars.msg = msg;

			vars.sendtime = Global.getLocalTime();

			send(vars, "ar_textlog2.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				//nop
			}
			catch (e:Error)
			{
				trace("TextLogConnect:catch exception:" + e.toString());
			}

		}
	}
	
}