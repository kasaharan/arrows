package 
{

	public class Hamayumi
	{
		//public static var shootArrowCnt:int = 1;
		//public static var maxPower:Number = Arrow.MAX_POWER;
		
		//private static var _exp:int = 0;
		//private static var _level:int = 1;
		
		public static var isShowHP:Boolean = false;
		
		private static var _exp:Value = new Value();
		
		public static var is2ninbari:Boolean = false;
		public static var is3ninbari:Boolean = false;
		//--------
		private static var _damage:Value = new Value();
		public static function get damage():int { return _damage.value }
		public static function set damage(val:int):void { _damage.value = val; }
		//--------

		public static var hanabiDamage:int = 0;
		public static var bababaDamage:int = 0;
		public static var ittenDamage:int = 0;
		public static var renDamage:int = 0;
		public static var souDamage:int = 0;
		
		public static var is2danHit:Boolean = false;
		public static var is3danHit:Boolean = false;

		public static var isLight:Boolean = false;
		
		public static var isWazaTame:Boolean = false;
		public static var isAuto:Boolean = false;
		public static var isAuto1:Boolean = false;
		
		public static function get isCheat():Boolean { return _exp.isCheat;	}

		public function Hamayumi()
		{
			// constructor code
		}

		//public static const MAX_LEVEL:int = 55;
		private static var _MAX_LEVEL:Value = new Value();
		public static function get MAX_LEVEL():int { return _MAX_LEVEL.value; };
		
		//static init
		{
			//上限レベル
			_MAX_LEVEL.value = 99;
		}
		

		public static function get exp():int
		{
			return _exp.value;
		}
		public static function set exp(val:int):void
		{
			if (MAX_LEVEL <= level)
			{
				return;
			}
			_exp.value = val;
		}

		public static function get needExp():String
		{
			var l:int;
			var need:int = 0;

			for (l = 1; l <= level; l++)
			{
				//need += l*l*5;
				if (45 <= l)
				{
					need += l*l*l;
				}
				else if (30 <= l)
				{
					need += (l*l*5) * (l * 0.1 - 1);
				}
				else
				{
					need += l*l*5;
				}
			}

			return need.toString();
		}
		
		public static function get level():int
		{
			var l:int;
			var need:int = 0;

			for (l = 1; l < MAX_LEVEL; l++)
			{
				//need += l*l*5;
				if (45 <= l)
				{
					need += l*l*l;
				}
				else if (30 <= l)
				{
					need += (l*l*5) * (l * 0.1 - 1);
				}
				else
				{
					need += l*l*5;
				}
				
				if (_exp.value < need)
				{
					break;
				}
			}

			return l;
		}

		/*
		public static function isLevelUp(addExp:int):Boolean
		{
			if (int(needExp) <= exp + addExp)
			{
				return true;
			}
			return false;
		}
		*/
		
		// ----------------
		// shootArrowCnt
		// ----------------
		public static function getShootArrowCnt(isCoop:Boolean, no:int = -1):int
		{
			var ret:int = Global.getKindValue()[Item.KIND_IDX_YAKAZU] + level;
			trace("isCoop" + isCoop);
			if (isCoop)
			{
				if (Scenario.getSyncLevel(no) < level)
				{
					//レベルシンク用
					ret = Global.getKindValue()[Item.KIND_IDX_YAKAZU] + Scenario.getSyncLevel(no);
				}
			}
			
			return ret;
		}

		// ----------------
		// maxPower
		// ----------------
		public static function get maxPower():Number
		{
			return (Global.getKindValue()[Item.KIND_IDX_HIKYORI] * 0.4) + Arrow.MAX_POWER;
		}
		public static function get maxPowerFor2ninbari():Number
		{
			//二人張り用
			return (Global.getKindValue()[Item.KIND_IDX_HIKYORI] * 0.2) + Arrow.MAX_POWER;
		}
		public static function get maxPowerFor3ninbari():Number
		{
			//三人張り用
			return (Global.getKindValue()[Item.KIND_IDX_HIKYORI] * 0.4 * (1/3)) + Arrow.MAX_POWER;
		}

		/*
		// ----------------
		// fallSpeed
		// ----------------
		public static function get fallSpeed():Number
		{
			//Arrow.FALL_SPEED:0.5
			return Arrow.FALL_SPEED - (Global.getKindValue()[Item.KIND_IDX_HIKYORI] * 0.01);
		}
		*/

		// ----------------
		// addPowerValue
		// ----------------
		public static function get addPowerValue():Number
		{
			var sokusha:Number = Global.getKindValue()[Item.KIND_IDX_SOKUSHA] * 0.4;
			var chisha:Number  = Global.getKindValue()[Item.KIND_IDX_CHISHA] * 0.4;
			
			//trace("addPowerValue:" + (sokusha +  Arrow.MAX_POWER) / Global.FPS);
			//return (sokusha - chisha + Arrow.MAX_POWER) / Global.FPS;
			//return (sokusha - chisha + maxPower) / Global.FPS;
			
			//飛距離で速射、遅射の効果率が変わってしまうので、
			//本来の速射、遅射の割合を出してから、計算する。
			var speedUpRate:Number = 1.0 + (sokusha - chisha) / Arrow.MAX_POWER;
			return (maxPower * speedUpRate) / Global.FPS;
		}
		public static function get addPowerValueFor2ninbari():Number
		{
			//二人張り用
			var sokusha:Number = Global.getKindValue()[Item.KIND_IDX_SOKUSHA] * 0.2;
			var chisha:Number  = Global.getKindValue()[Item.KIND_IDX_CHISHA] * 0.2;
			
			//飛距離で速射、遅射の効果率が変わってしまうので、
			//本来の速射、遅射の割合を出してから、計算する。
			var speedUpRate:Number = 1.0 + (sokusha - chisha) / Arrow.MAX_POWER;
			return (maxPowerFor2ninbari * speedUpRate) / Global.FPS;
		}
		public static function get addPowerValueFor3ninbari():Number
		{
			//三人張り用
			var sokusha:Number = Global.getKindValue()[Item.KIND_IDX_SOKUSHA] * 0.4 * (1/3);
			var chisha:Number  = Global.getKindValue()[Item.KIND_IDX_CHISHA] * 0.4 * (1/3);
			
			//飛距離で速射、遅射の効果率が変わってしまうので、
			//本来の速射、遅射の割合を出してから、計算する。
			var speedUpRate:Number = 1.0 + (sokusha - chisha) / Arrow.MAX_POWER;
			return (maxPowerFor3ninbari * speedUpRate) / Global.FPS;
		}

		// ----------------
		// yakazu
		// ----------------
		public static function get yakazu():int
		{
			return Global.getKindValue()[Item.KIND_IDX_YAKAZU];
		}
		// ----------------
		// hikyori
		// ----------------
		public static function get hikyori():int
		{
			return Global.getKindValue()[Item.KIND_IDX_HIKYORI];
		}

		// ----------------
		// penetrateMaxCnt
		// ----------------
		public static function get penetrateMaxCnt():Number
		{
			return Global.getKindValue()[Item.KIND_IDX_KANTSUU] + 0;
		}

		// ----------------
		// shuchu
		// ----------------
		public static function get shuchu():Number
		{
			return (Global.getKindValue()[Item.KIND_IDX_SHUUCHUU] + 0) * 0.05;
		}
		
		// ----------------
		// sanran
		// ----------------
		public static function get sanran():Number
		{
			return (Global.getKindValue()[Item.KIND_IDX_SANRAN] + 0) * 0.1;
		}

		// ----------------
		// wazaKind
		// ----------------
		public static function get wazaKind():int
		{
			return Global.getWazaKind();
		}

	}

}