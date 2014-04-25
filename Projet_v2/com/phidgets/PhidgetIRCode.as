package com.phidgets
{

	/*
		Class: PhidgetIRCode
		A class for storing an IR code.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
	public class PhidgetIRCode
	{
        private const hexlookup:Array = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" ];

		private var code:String;
		private var bitCount:int;
		private var repeat:Boolean;
		
		public function PhidgetIRCode(code:String, bitCount:int, repeat:Boolean=false)
		{
			this.code = code;
			this.bitCount = bitCount;
			this.repeat = repeat;
		}
		
		/*
			Property: Code
			Gets the IR code string.
		*/
		public function get Code():String{
			return code;
		}
		/*
			Property: BitCount
			Gets the bit count of the IR Code
		*/
		public function get BitCount():int{
			return bitCount;
		}
		/*
			Property: Repeat
			Gets the repeat state for this code. This is used in the CODE event when an incoming code is being repeated.
		*/
		public function get Repeat():Boolean{
			return repeat;
		}
		
		public function toString():String{
			return code;
		}
	}
}