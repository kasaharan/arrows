package
{
	
	public class Value
	{
		private var _sa:int = 13579;
		private var _value:int = _sa;
		
		private var _lastValue:Vector.<Value2> = new Vector.<Value2>();
		private const LEN:int = 16;
		public var isCheat:Boolean = false;
		
		public function Value()
		{
			_sa = Math.random() * int.MAX_VALUE;
			_value = _sa;
			
			for (var i:int = 0; i < LEN; i++)
			{
				_lastValue[i] = new Value2();
				_lastValue[i].value = _value;
			}
		}
		
		public function get value():int
		{
			for (var i:int = 0; i < LEN; i++)
			{
				if (_lastValue[i].value != _value)
				{
					isCheat = true;
				}
				_lastValue[i].value = _value;
			}
			
			return _value - _sa;
		}
		
		public function set value(val:int):void
		{
			var i:int;
			for (i = 0; i < LEN; i++)
			{
				if (_lastValue[i].value != _value)
				{
					isCheat = true;
				}
			}
			
			_value = val + _sa;
			
			for (i = 0; i < LEN; i++)
			{
				_lastValue[i].value = _value;
			}
		}
	
	/*
	   public function test()
	   {
	   _value += _sa;
	   }
	 */
	}
}

class Value2
{
	private var _sa:int = int.MAX_VALUE;
	private var _value:int = _sa;
	
	public function Value2()
	{
		_sa = Math.random() * int.MAX_VALUE;
		_value = _sa;
	}
	
	public function get value():int
	{
		return _value - _sa;
	}
	
	public function set value(val:int):void
	{
		_value = val + _sa;
	}
}

