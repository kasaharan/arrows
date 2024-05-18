package  
{
	/**
	 * ...
	 * @author kasaharan
	 */
	public class Docho 
	{
		public var level:int = int.MAX_VALUE;
		public var yakazu:int = 0;
		public var maxPower:Number = 0;
		public var addPowerValue:Number = 0;
		public var penetrateMaxCnt:int = 0;
		public var shuchu:Number = 0;
		public var sanran:Number = 0;
		public var waza:int = 0;
		public var wazaKyoka:int = 0;
			
		public function Docho() 
		{

		}

		public function setData
		(
			_level:int,
			_yakazu:int,
			_maxPower:Number,
			_addPowerValue:Number,
			_penetrateMaxCnt:int,
			_shuchu:Number,
			_sanran:Number,
			_waza:int,
			_wazaKyoka:int
		):void
		{
			level = _level;
			yakazu = _yakazu;
			maxPower = _maxPower;
			addPowerValue = _addPowerValue;
			penetrateMaxCnt = _penetrateMaxCnt;
			shuchu = _shuchu;
			sanran = _sanran;
			waza = _waza;
			wazaKyoka = _wazaKyoka;
		}
		
		public function clear():void
		{
			level = int.MAX_VALUE;
		}

	}

}