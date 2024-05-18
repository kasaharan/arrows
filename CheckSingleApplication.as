package
{
	import flash.net.LocalConnection;

	public class CheckSingleApplication extends LocalConnection
	{
		public var isExistOther:Boolean = false;
		public function CheckSingleApplication(connectionName:String)
		{		
			try
			{
				this.connect(connectionName);
				this.client = this;
				//他のインスタンスなし
			}
			catch(e:ArgumentError)
			{
				try
				{
					//他のインスタンスが有効だと例外が出ないらしい=２重起動
					send(connectionName, "callbackFunction");
					//１つのローカル環境で１つしかconnectできない
					isExistOther = true;
				}
				catch(e:*)
				{
					//接続は残っていても起動アプリなし、らしい
				}
			}
		}
		
		public function callbackFunction():void
		{
			trace("callbackFunction");
		}

	}

}
