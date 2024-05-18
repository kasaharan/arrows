package 
{
	import flash.geom.Rectangle;

	public class Yagura extends Rectangle
	{

		public var enable:Boolean;
		public var hp:int;

		public function Yagura()
		{
			// constructor code
			this.width = 88;//96;
			this.height = 96;
			this.x = 0;
			this.y = 480 - 32 - this.height;
		}
		/*
		public function setEnabled(bool:Boolean)
		{
			enable = bool;
			if (bool)
			{
				hp = 1;//10;
			}
			else
			{
				hp = 0;
			}
		}
		*/
		public function init(_enable:Boolean, _hp:int):void
		{
			this.enable = _enable;
			this.hp = _hp;
		}

	}

}