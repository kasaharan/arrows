package
{
	public class Random
	{
		private var seed:Number;

		public function Random( val:Number ):void
		{
			setSeed( val );
		}
		public function setSeed( val:Number ):void
		{
			var i:int;

			seed = (val * 0x5DEECE66D + 0xB) % 0xFFFFFFFFFFFF;
			
			//init
			/*
			for (i = 0; i < 1000; i++)
			{
				getRand();
			}
			*/
		}
		public function getRand():Number
		{
			seed = (seed * 0x5DEECE66D + 0xB) % 0xFFFFFFFFFFFF;
			
			var lower32:uint = seed & 0xFFFFFFFF;				//下位32bit
			var upper20:uint = seed / 0x100000000 & 0xFFFFF;	//上位20bit
			var c:Number = lower32 + upper20 * 0x100000000;
			return c / 0x1000000000000;		//0.0～0.1未満にする
		}
		
		//0~val-1
		public function getInt( val:int ):int
		{
			return Math.floor(getRand() * val);
		}
	}
}
