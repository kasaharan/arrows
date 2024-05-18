package
{
	import flash.net.*;
	import flash.events.*;

	public class Connect
	{
		//接続先
		public static const localSite:String     = "http://127.0.0.1/game/arrows/";
		public static const kasaharanSite:String = "http://kasaharan.com/game/arrows/";
		//public static const kasaharanSite = "http://153.122.35.249/game/arrows/";
		public var server:String = "./";

		protected var dummy:int;
		//public var loadedFunc:Function = function(){trace("null function")};
		protected var loadedFunc:Function = function():void{trace("null function")};
		public var message:String = "";
		
		//ページURL
		// flashのトップで以下のコードを忘れずに！！！
		// Connect.swfUrl = loaderInfo.url;
		//
		public static var swfUrl:String = "";
		public static function isLocalSite():Boolean
		{
			if (swfUrl.length == 0)
			{
				trace("Connect.swfUrlに代入してないよ！！");
				return true;
			}
			return ((swfUrl.substr(0, 16) == localSite.substr(0, 16)) || (swfUrl.substr(0, 4) == "file"));
		}
		

		public function Connect()
		{
			server = kasaharanSite;
			//DEBUG
			if (isLocalSite())
			{
				server = localSite;
			}
		}
		
		public static function getUrl():String
		{
			if (isLocalSite())
			{
				return localSite;
			}
			return kasaharanSite;
		}

		public function send(vars:URLVariables, phpname:String):void
		{
			var request:URLRequest = new URLRequest(server + phpname);
			request.method = URLRequestMethod.POST;
			request.data = vars;

			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			try
			{
				loader.load(request);
			}
			catch (error:SecurityError)
			{
				trace("A SecurityError has occurred.");
			}

			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
		}
		
		protected function loaderCompleteHandler(event:Event):void
		{
			;
		}

		protected function errorHandler(e:IOErrorEvent):void
		{
			trace("errorHandler");
			message = "通信エラー";
			loadedFunc(false);
		}
	}
}
