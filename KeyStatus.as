package 
{

	public class KeyStatus
	{
		public var up:Boolean = false;
		public var down:Boolean = false;
		public var left:Boolean = false;
		public var right:Boolean = false;
		
		//--------
		public var yes:Boolean = false;
		public var no:Boolean = false;

		public function KeyStatus()
		{
			// constructor code
		}

		public function clear():void 
		{
			up = false;
			down = false;
			left = false;
			right = false;
			yes = false;
			no = false;
		}
		
	}

}