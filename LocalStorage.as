package
{
	import flash.external.ExternalInterface;

	public class LocalStorage
	{
		public static const key:String = "arrows";

		public function LocalStorage()
		{
			// constructor code
		}

		public static function getItem(key:String):String
		{
			try
			{
				//return ExternalInterface.call("localStorage.getItem", key);
				var ret:String = ExternalInterface.call("localStorage.getItem", key);
				if (ret == null)
				{
					ret = "";
				}
				return ret;
			}
			catch(e:Error){}
			
			return "";
		}

		public static function setItem(key:String, data:String):void
		{
			try
			{
				ExternalInterface.call("localStorage.setItem", key, data);
			}
			catch(e:Error){}
		}
	}

}