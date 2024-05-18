package 
{
	import flash.geom.Rectangle;
	import starling.core.Starling;

	public class Arrow
	{
		//letsnote 1024本でfps60設定で25~35frame → (int)重いがあったので当時の参考値
		//public static const MAX_CNT:int = 384;
		//public static const MAX_DRAW_CNT:int = 192;
		//public static const MAX_CNT:int = 192;//192;//256;	//200
		private static var _maxArrowCnt:Value = new Value();
		public static function set maxArrowCnt(val:int):void
		{
			if (3000 < val)
			{
				val = 3000;
			}
			if (val < 100)
			{
				val = 100
			}
			_maxArrowCnt.value = val;
		}
		public static function get maxArrowCnt():int { return _maxArrowCnt.value }
		//static init
		{
			_maxArrowCnt.value = 192;
		}
		
		public static const MAX_POWER:Number = 20;//20;//15;
		public static const ADD_POWER_VALUE:Number = MAX_POWER / Starling.current.nativeStage.frameRate;//0.5;
		public static const FALL_SPEED:Number = 0.5;

		public static var STATUS_MOVE:int = 0;
		public static var STATUS_STOP:int = 1;
		public static var STATUS_REFLECT:int = 2;
		//public static var STATUS_READY:int = 2;
		
		
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		public var r:Number = 0.0;
		public var vx:Number = 0.0;
		public var vy:Number = 0.0;
		public var status:int = STATUS_STOP;
		public var hitX:Number = 0.0;
		public var hitY:Number = 0.0;
		public var hitIdx:int = -1;

		public var wazaKind:int = 0;
		public var wazaKyokaKind:int = 0;
		public var moveCount:int = 0;
		
		public var damage:int = 0;
		
		//public var penetrateMaxCnt:int = 0;
		public var penetrateCnt:int = 0;
		public var penetrateHitIdx:int = -1;	//同じモンスターに2度当たらないためのidx

		//public var fallSpeed:Number = FALL_SPEED;

		//的を飛び越す対策。中間座標
		//public var middleX:Number = 0.0;
		//public var middleY:Number = 0.0;
		/*
		public var routeX1:Number = 0.0;
		public var routeY1:Number = 0.0;
		public var routeX2:Number = 0.0;
		public var routeY2:Number = 0.0;
		*/
		//bmp飛び越えるので再修正
		//矢の長さは32ドットなので32の中間座標が必要。
		//scale4倍なら中間座標8個でよいはず。テストでも貫通しないのを確認。
		public static var routeCnt:int = 8;
		public var routeX:Vector.<Number> = new Vector.<Number>;
		public var routeY:Vector.<Number> = new Vector.<Number>;
		
		////的を飛び越す対策(2014/07/26)。前回座標と現座標で当たり判定をする
		//public var previous:Rectangle = new Rectangle(0, 0, 1, 1);
		
		//軽量化用番号（mod(%)計算が重い）
		public var lightNoSelf:int = 0;
		public var lightNoNotSelf:int = 0;
		public var lightVanishCnt:int = 0;

		//自分の矢か
		public var isSelf:Boolean;
		
		//タメ用の矢
		public var isWazaTame:Boolean = false;

		//発射待ち制御
		public var shootWait:int = 0;
		
		//花火矢番号
		public var hanabiNo:int = -1;
		public var hanabiMaxNo:int = -1;
		
		//技：舞 連 制御用
		public var v0:Number = 0.0;
		public var baseR:Number = 0.0;
		public var baratsuki:Number = 0.0;
		
		//
		public var clientID:String = "";

		//--------
		private static var rnd:Random = new Random(0);

		public function Arrow()
		{
			// constructor code
			
			var i:int;
			for (i = 0; i < routeCnt; i++ )
			{
				routeX[i] = 0;
				routeY[i] = 0;
			}
		}

		public static function getV0Power(power:Number, cnt:int = 0, seed:int = 0, baratsuki:Number = 1.0):Number
		{
			//一発目はブレ無し
			if (cnt == 0)
			{
				rnd.setSeed(seed);
				return power;
			}
			else
			{
				//return power - Math.random() * (power / 3);
				//return power - rnd.getRand() * (power / 3);
				return power - rnd.getRand() * (power / 3) * baratsuki;
			}
		}
		public static function getV0Radian(baseR:Number, cnt:int = 0, seed:int = 0, baratsuki:Number = 1.0):Number
		{
			//一発目はブレ無し
			if (cnt == 0)
			{
				rnd.setSeed(seed);
				return baseR;
			}
			else
			{
				//return baseR + Math.random() * (Math.PI / 10);
				return baseR + rnd.getRand() * (Math.PI / 10) * baratsuki;
			}
		}
		
		public static function get hanabiExplosionFPSCnt():int
		{
			//return (int)(Global.FPS * 0.8);
			return int(Global.FPS * 1.0);
		}
/*
		// ----------------
		// enableArrow
		// ----------------
		public function enableArrow():Boolean
		{
			if (this.wazaKind == Item.KIND_IDX_WAZA_HANABI)
			{
				if (this.hanabiNo == 0)
				{
					return true;
				}
				if (hanabiExplosionFPSCnt <= this.moveCount)
				{
					return true;
				}
			}
			else
			{
				return true;
			}
			return false;
		}
*/
/*
def dist_line_point( x0, y0, x1, y1, px, py)
  dx = x1 - x0
  dy = y1 - y0
  a = dx * dx + dy * dy
  return Math.sqrt( (x0-px)*(x0-px) + (y0-py)*(y0-py)) if a == 0.0 
  b = dx * (x0-px) + dy * (y0-py)
  t =  - (b / a)
  t = 0.0 if t < 0.0
  t = 1.0 if t > 1.0
  x = t * dx + x0
  y = t * dy + y0
  return Math.sqrt( (x-px)*(x-px) + (y-py)*(y-py)) 
end
*/
		//点と線の距離
		public static function getDistanceLineToPoint(x0:Number, y0:Number, x1:Number, y1:Number, px:Number, py:Number):Number
		{
			var dx:Number = x1 - x0;
			var dy:Number = y1 - y0;
			var a:Number = dx * dx + dy * dy;
			
			if (a == 0)
			{
				return Math.sqrt((x0 - px) * (x0 - px) + (y0 - py) * (y0 - py));
			}

			var b:Number = dx * (x0 - px) + dy * (y0 - py);
			var t:Number = - (b / a);
			if (t < 0.0)
			{
				t = 0.0;
			}
			if (1.0 < t)
			{
				t = 1.0
			}
			var x:Number = t * dx + x0;
			var y:Number = t * dy + y0;
			return Math.sqrt( (x - px) * (x - px) + (y - py) * (y - py));

		}
	}

}