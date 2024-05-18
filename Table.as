package
{
	import flash.utils.escapeMultiByte;


	public class Table
	{
		private var record:Array;
		private var cnm:Object;
		private var isHashCheck:Boolean = false;	//チート対策

		public function Table(header:String, rowdata:String, _isHashCheck:Boolean):void
		{
			var i:int = 0;
			var tmp:Array = header.split(",");

			cnm = new Array();
			for (i = 0; i < tmp.length; i++)
			{
				cnm[tmp[i]] = i;
			}

			var csv:MyCSV = new MyCSV();
			record = csv.convert(rowdata);
			//trace(record);
			
			//--------
			isHashCheck = _isHashCheck;
			if (isHashCheck)
			{
				makeHash();
			}
		}

		public function getData(idx:int, clName:String):String
		{
			return record[idx][cnm[clName]];
		}

		public function setData(idx:int, clName:String, val:String):void
		{
			record[idx][cnm[clName]] = val;
			
			//--------
			if (isHashCheck)
			{
				makeHash();
			}
		}
		
		public function addData(rowdata:String):void
		{
			var i:int = 0;
			var csv:MyCSV = new MyCSV();
			var tmp:Array = csv.convert(rowdata);
			for (i = 0; i < tmp.length; i++)
			{
				trace(tmp[i]);
				record.push(tmp[i]);
			}
			
			//--------
			if (isHashCheck)
			{
				makeHash();
			}
		}
		
		//********
		public function hashOff():void
		{
			isHashCheck = false;
		}
		public function hashOn():void
		{
			isHashCheck = true;
			makeHash();
		}
		//********

		public function getCount():int
		{
			return record.length;
		}
		
		//----------------
		//チート対策
		private var hash:String = "";
		private function makeHash():void
		{
			hash = escapeMultiByte( JSON.stringify(record) );
			trace("★" + hash);
		}
		public function isHashOK():Boolean
		{
			var tmp:String = escapeMultiByte( JSON.stringify(record) );
			return (tmp == hash);
		}
		//----------------
	}
}
class MyCSV
{
	public function convert(str:String):Array
	{
		var i:int = 0;
		var j:int = 0;
		var row:int = 0;
		var col:int = 0;
		var pos:int = -1;
		var data:Array = new Array();
		var len:int = str.length;

		if (str.length == 0)
		{
			return new Array();
		}
		if (str.substr(len-1, 1) == '\|')
		{
			str = str.substr(0, len-1);
			//trace("■"+str);
		}

		data[row] = new Array();

		for (i = 0; i < len; i++)
		{
			if (str.substr(i, 1) == '\\')
			{
				i++;
			}
			else if (str.substr(i, 1) == ',')
			{
				data[row][col] = str.substring(pos+1, i);
				//trace(i + "/" + len + ":" + data[row][col]);
				pos = i;
				col++;
			}
			else if (str.substr(i, 1) == '\|')
			{
				data[row][col] = str.substring(pos+1, i);
				//trace(i + "/" + len + ":" + data[row][col]);
				pos = i;
				row++;
				col = 0;
				data[row] = new Array();
			}
		}

		if (pos != len)
		{
			data[row][col] = str.substring(pos+1, len);
		}

		//unescape \| \,
		for (i = 0; i < data.length; i++)
		{
			for (j = 0; j < data[i].length; j++)
			{
				data[i][j] = data[i][j].replace(/\\\|/g, "|");
				data[i][j] = data[i][j].replace(/\\,/g, ",");
				data[i][j] = data[i][j].replace(/\\\\/g, '\\');
				//trace("***" + data[i][j]);
			}
		}

		return data;
	}

}

