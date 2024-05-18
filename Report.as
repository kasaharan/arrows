package  
{
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author kasaharan
	 */
	public class Report 
	{
		public var width:int = 0;
		public var height:int = 0;
		public var tokasyokuNo:int = 0x000000;
		public var onibiX:int = 0;
		public var onibiY:int = 0;
		public var scale:int = 1;
		public var stageType:int = 0;
		public var attackType:int = 0;
		
		public var status:int = 0;

		public var image:Vector.<Image> = new Vector.<Image>;
		
		public function Report() 
		{
			var i:int;
			for (i = 0; i < 3; i++ )
			{
				image[i] = new Image(Texture.fromBitmapData(new BitmapData(1, 1, false, 0x00000000)));
			}
		}
		
	}

}