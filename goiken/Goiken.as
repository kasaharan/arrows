package goiken
{
	import flash.net.SharedObject;

	/**
	 * ...
	 * @author ...
	 */
	public class Goiken
	{
		static public var my_so:SharedObject;
		static public var message:String = "";

		public static function init()
		{
			//SOロード
			try
			{
				my_so = SharedObject.getLocal("arrows", "http://kasaharan.com/game/arrows/");
			}
			catch(e:Error){}
		}

		public static function getLocalTime()
		{
			var my_date = new Date();
			var str = my_date.getFullYear() + ("00" + (my_date.getMonth() + 1)).substr(-2, 2) + ("00" + my_date.getDate()).substr(-2, 2);
			str += ("00" + my_date.getHours()).substr(-2, 2) + ("00" + my_date.getMinutes()).substr(-2, 2) + ("00" + my_date.getSeconds()).substr(-2, 2);
			return str;
		}
	}
}