package com.phidgets
{
	import com.phidgets.Constants;
	import com.phidgets.events.PhidgetEvent;
	import flash.events.EventDispatcher;
	/*
		Class: PhidgetIRCodeInfo
		A class for storing Code parameters, used for transmitting codes.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
	public class PhidgetIRCodeInfo
	{
		/*
			Constants: IR Encodings
			These are the supported encoding types for the PhidgetIR. These constants are used with <Encoding>.
			
			ENCODING_UNKNOWN - Unknown Encoding.
			ENCODING_SPACE - Space Encoding.
			ENCODING_PULSE - Pulse Encoding.
			ENCODING_BIPHASE - BiPhase Encoding.
			ENCODING_RC5 - RC5 Encoding.
			ENCODING_RC6 - RC6 Encoding.
		*/
		public static const ENCODING_UNKNOWN:int = 1;
		public static const ENCODING_SPACE:int = 2;
		public static const ENCODING_PULSE:int = 3;
		public static const ENCODING_BIPHASE:int = 4;
		public static const ENCODING_RC5:int = 5;
		public static const ENCODING_RC6:int = 6;
		
		/*
			Constants: IR Code length styles
			These are the supported code length styles for the PhidgetIR. These constants are used with <Length>.
			
			CODE_LENGTH_UNKNOWN - Unknown length.
			CODE_LENGTH_CONSTANT - Constant - the bitstream + gap length is constant.
			CODE_LENGTH_VARIABLE - Variable - the bitstream has a variable length with a constant gap.
		*/
		public static const CODE_LENGTH_UNKNOWN:int = 1;
		public static const CODE_LENGTH_CONSTANT:int = 2;
		public static const CODE_LENGTH_VARIABLE:int = 3;
		
		/*
			Variable: Encoding
			IR Code encoding.
		*/
		public var Encoding:int = ENCODING_UNKNOWN;
		/*
			Variable: Length
			IR Code length style.
		*/
		public var Length:int = CODE_LENGTH_UNKNOWN;
		/*
			Variable: BitCount
			IR Code bit count.
		*/
		public var BitCount:int = 32;
		/*
			Variable: Gap
			IR Code gap in microseconds.
		*/
		public var Gap:int = 0;
		/*
			Variable: Trail
			IR Code trailing pulse in microseconds.
		*/
		public var Trail:int = 0;
		/*
			Variable: Header
			IR Code header. Can be null, or a two-element array (pulse and space in microseconds).
		*/
		public var Header:Array = [0,0];
		/*
			Variable: One
			IR Code one - pulse and space in microseconds representing a '1'.
		*/
		public var One:Array = [0,0];
		/*
			Variable: Zero
			IR Code zero - pulse and space in microseconds representing a '0'.
		*/
		public var Zero:Array = [0,0];
		/*
			Variable: MinRepeat
			Number of times to repeat the code on transmit.
		*/
		public var MinRepeat:int = 0;
		/*
			Variable: ToggleMask
			Mask of bits to toggle on each repeat.
		*/
		public var ToggleMask:String;
		/*
			Variable: Repeat
			Repeat code. Must begin and end with a pulse.
		*/
		public var Repeat:Array;
		/*
			Variable: CarrierFrequency
			Carrier Frequency. Defaults to 38000kHz.
		*/
		public var CarrierFrequency:int = 38000;
		/*
			Variable: DutyCycle
			IR LED duty cycle. Defaults to 33%.
		*/
		public var DutyCycle:int = 33;
		
		/*
			Constructor: PhidgetIRCodeInfo
			Creates a new PhidgetIRCodeInfo object. All arguments are optional - defaults will be filled in for any arguments left out.
		*/
		public function PhidgetIRCodeInfo
		(
			bitCount:int=32, 
			encoding:int=ENCODING_UNKNOWN, 
			header:Array=null, 
			zero:Array=null, 
			one:Array=null, 
			trail:int=0, 
			gap:int=0, 
			repeat:Array=null, 
			minRepeat:int=0, 
			toggleMask:String=null, 
			Length:int=CODE_LENGTH_UNKNOWN, 
			carrierFrequency:int=38000, 
			dutyCycle:int=33
		)
		{
			BitCount = bitCount;
			Encoding = encoding;
			if(header != null)
			{
                if (header.Length != 2)
                	throw new PhidgetError(com.phidgets.Constants.EPHIDGET_INVALIDARG);
                Header = new Array(header[0], header[1]);
			}
			if(zero!=null)
			{
                if (zero.Length != 2)
                	throw new PhidgetError(com.phidgets.Constants.EPHIDGET_INVALIDARG);
                Zero = new Array(zero[0], zero[1]);
			}
			if(one!=null)
			{
                if (one.Length != 2)
                	throw new PhidgetError(com.phidgets.Constants.EPHIDGET_INVALIDARG);
                One = new Array(one[0], one[1]);
			}
			Trail = trail;
			Gap = gap;
			if(repeat != null)
			{
                Repeat = new Array(repeat.Length);
                for (var i:int = 0; i < repeat.Length; i++)
                    Repeat[i] = repeat[i];
			}
			MinRepeat = minRepeat;
			ToggleMask = toggleMask;
			Length = length;
			CarrierFrequency = carrierFrequency;
			DutyCycle = dutyCycle;
		}
		
		//flips from MSB to LSB after padding to 32-bit
		private function flipString(str:String):String{
			var outStr:String = "";
			while(str.length < 8)
				str = "0"+str;
			for(var i:int=str.length-2;i>=0;i-=2)
				outStr = outStr + str.substring(i,i+2);
			return outStr;
		}
		
		private const IR_MAX_CODE_BIT_COUNT:int = 128							/**< Maximum bit count for sent / received data */
		private const IR_MAX_CODE_DATA_LENGTH:int = (IR_MAX_CODE_BIT_COUNT / 8)	/**< Maximum array size needed to hold the longest code */
		private const IR_MAX_REPEAT_LENGTH:int = 26								/**< Maximum array size for a repeat code */
		public function toString():String{
			var codeString:String = "";
			codeString = codeString + flipString(BitCount.toString(16));
			codeString = codeString + flipString(Encoding.toString(16));
			codeString = codeString + flipString(Length.toString(16));
			codeString = codeString + flipString(Gap.toString(16));
			codeString = codeString + flipString(Trail.toString(16));
			codeString = codeString + flipString(Header[0].toString(16));
			codeString = codeString + flipString(Header[1].toString(16));
			codeString = codeString + flipString(One[0].toString(16));
			codeString = codeString + flipString(One[1].toString(16));
			codeString = codeString + flipString(Zero[0].toString(16));
			codeString = codeString + flipString(Zero[1].toString(16));
			for(var i:int=0;i<IR_MAX_REPEAT_LENGTH;i++)
			{
				if(Repeat.length > i)
					codeString = codeString + flipString(Repeat[i].toString(16));
				else
					codeString = codeString + "00000000";
			}
			codeString = codeString + flipString(MinRepeat.toString(16));
			i = IR_MAX_CODE_DATA_LENGTH*2;
			while(ToggleMask.length < i--)
			{
				codeString = codeString + "0";
			}
			codeString = codeString + ToggleMask;
			codeString = codeString + flipString(CarrierFrequency.toString(16));
			codeString = codeString + flipString(DutyCycle.toString(16));
			return codeString;
		}
	}
}