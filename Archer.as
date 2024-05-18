package 
{
	import flash.geom.Point;

	public class Archer
	{
		//--------
		public static const COOP_XY:Vector.<Point> = Vector.<Point>
		([
			 new Point(40, 480 - 96 - 12)
			,new Point( 8, 480 - 96 - 12)
			,new Point(40, 480 - 64 - 4)
			,new Point( 8, 480 - 64 - 4)
//,new Point(24, 480 - 128 - 32)	//20140521すでに4人入っているところに入ったとの報告があったので応急処置
		]);
		private static const SOLO_XY:Point = new Point(0, 480 - 64);
		private static const ARCHER_IDX:int = 1;
		private static const UDE_IDX:int = 2;
		private static const KAMAE_YUMI_IDX:int = 3;
		private static const HIKI_YUMI_IDX:int = 4;
		
		private static const ARCHER_IDX_RIGHT:int = 51;
		private static const UDE_IDX_RIGHT:int = 52;
		private static const KAMAE_YUMI_IDX_RIGHT:int = 53;
		private static const HIKI_YUMI_IDX_RIGHT:int = 54;
		
		//--------
		//public var clientID:String = "";
		public var x:int;
		public var y:int;
		public var baseR:Number;
		public var yumiR:Number;
		public var archerIdx:int;
		public var udeIdx:int;
		public var yumiIdx:int;
		public var kamaeYumiIdx:int;
		public var hikiYumiIdx:int;
		//public var isUseUma:Boolean;
		private var umaUpDownBaseY:int;
		private var baseX:int;
		private var baseY:int;

		public function get shootX():int{return x + 20;}
		public function get shootY():int{return y + 16;}
		public function get yumiX():int{return x + 18;}
		public function get yumiY():int{return y + 19;}
		public function get umaX():int {return x - 16;}
		public function get umaY():int {return y + 16;}
		//public function get udeX():int { return x + 18; }
		public function get udeX():int { return x + 18 + ((this.udeIdx == UDE_IDX_RIGHT)?-4:0); }
		public function get udeY():int {return y + 20;}

		public function get isUseUma():Boolean {return (umaUpDownBaseY != int.MIN_VALUE);}
		public function get getUmaUpY():int {return umaUpDownBaseY;}
		public function get getUmaDownY():int {return umaUpDownBaseY + 2;}

		//強化花火用
		public var kyoukaHanabiX:int = 0;
		public var kyoukaHanabiY:int = 0;
		public var kyoukaHanabiCnt:int = 0;

		public function Archer()
		{
			// constructor code
		}

		//----------------
		// 初期化（ソロ）
		//----------------
		public function initSolo():void
		{
			this.x = Archer.SOLO_XY.x;
			this.y = Archer.SOLO_XY.y;
			this.yumiR = 0;
			this.archerIdx = ARCHER_IDX;
			this.udeIdx = UDE_IDX;
			this.kamaeYumiIdx = KAMAE_YUMI_IDX;
			this.hikiYumiIdx = HIKI_YUMI_IDX;
			this.yumiIdx = this.kamaeYumiIdx;
			//this.isUseUma = false;
			//umaUpDownBaseY = int.MIN_VALUE;
			enabledUma(false);
			
			this.baseX = Archer.SOLO_XY.x;
			this.baseY = Archer.SOLO_XY.y;
			
			this.kyoukaHanabiX = 0;
			this.kyoukaHanabiY = 0;
			this.kyoukaHanabiCnt = 0;
		}
		
		//----------------
		// 初期化（協力）
		//----------------
		public function initCoop(i:int):void
		{
			this.x = Archer.COOP_XY[i].x;
			this.y = Archer.COOP_XY[i].y;
			this.yumiR = 0;
			this.archerIdx = ARCHER_IDX;
			this.udeIdx = UDE_IDX;
			this.kamaeYumiIdx = 141;//KAMAE_YUMI_IDX;
			this.hikiYumiIdx = 142;//HIKI_YUMI_IDX;
			this.yumiIdx = this.kamaeYumiIdx;
			//this.isUseUma = false;
			//umaUpDownBaseY = int.MIN_VALUE;
			enabledUma(false);
			
			this.baseX = Archer.COOP_XY[i].x;
			this.baseY = Archer.COOP_XY[i].y;

			this.kyoukaHanabiX = 0;
			this.kyoukaHanabiY = 0;
			this.kyoukaHanabiCnt = 0;
		}

		//----------------
		// 初期化（ソロ）通し矢用右位置
		//----------------
		public function initSoloRight():void
		{
			this.x = Archer.SOLO_XY.x;
			this.y = Archer.SOLO_XY.y;
			this.yumiR = 0;
			this.archerIdx = ARCHER_IDX_RIGHT;
			this.udeIdx = UDE_IDX_RIGHT;
			this.kamaeYumiIdx = KAMAE_YUMI_IDX_RIGHT;
			this.hikiYumiIdx = HIKI_YUMI_IDX_RIGHT;
			this.yumiIdx = this.kamaeYumiIdx;
			//this.isUseUma = false;
			//umaUpDownBaseY = int.MIN_VALUE;
			enabledUma(false);
			
			this.baseX = Archer.SOLO_XY.x;
			this.baseY = Archer.SOLO_XY.y;

			this.kyoukaHanabiX = 0;
			this.kyoukaHanabiY = 0;
			this.kyoukaHanabiCnt = 0;
		}

		//----------------
		// addInitXY(solo)
		//----------------
		public function addInitXY(addX:int, addY:int):void
		{
			//this.x = Archer.SOLO_XY.x + addX;
			//this.y = Archer.SOLO_XY.y + addY;
			this.x = this.baseX + addX;
			this.y = this.baseY + addY;
		}

		//----------------
		// enabledUma
		//----------------
		public function enabledUma(bool:Boolean):void
		{
			if (bool)
			{
				umaUpDownBaseY = y;
			}
			else
			{
				umaUpDownBaseY = int.MIN_VALUE;
			}
		}
/*
		//----------------
		// setHamayumi
		//----------------
		private function setHamayumi()
		{
			this.kamaeYumiIdx = 141;
			this.hikiYumiIdx = 142;
			this.yumiIdx = this.kamaeYumiIdx;
		}
*/
	}

}