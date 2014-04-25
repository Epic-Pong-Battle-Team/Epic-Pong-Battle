package com.phidgets
{

	/*
		Class: PhidgetIRLearnedCode
		A class for storing a learned IR code.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
	public class PhidgetIRLearnedCode
	{
		private var code:String;
		private var codeInfo:PhidgetIRCodeInfo;
		
		public function PhidgetIRLearnedCode(code:String, codeInfo:PhidgetIRCodeInfo)
		{
			this.code = code;
			this.codeInfo = codeInfo;
		}
		
		/*
			Property: Code
			Gets the IR code.
		*/
		public function get Code():String{
			return code;
		}
		/*
			Property: CodeInfo
			Gets the IR code properties.
		*/
		public function get CodeInfo():PhidgetIRCodeInfo{
			return codeInfo;
		}
		
		public function toString():String{
			return code;
		}
		
		//This all depends on the CPhidgetIR_CodeInfo structure in the C code not changing!
		private static const IR_MAX_CODE_BIT_COUNT:int = 128							/**< Maximum bit count for sent / received data */
		private static const IR_MAX_CODE_DATA_LENGTH:int = (IR_MAX_CODE_BIT_COUNT / 8)	/**< Maximum array size needed to hold the longest code */
		private static const IR_MAX_REPEAT_LENGTH:int = 26								/**< Maximum array size for a repeat code */
		
		private static function bitCountToByteCount(bits:int):int{
			var bytes:int = bits / 8;
			if(bits%8)
				bytes++;
			return bytes;
		}
		
		//flips from MSB to LSB
		private static function flipString(str:String):String{
			var outStr:String = "";
			for(var i:int=str.length-2;i>=0;i-=2)
				outStr = outStr + str.substring(i,i+2);
			return outStr;
		}
		
		internal static function stringToPhidgetIRLearnedCode(str:String):PhidgetIRLearnedCode
		{
			var codeInfo:PhidgetIRCodeInfo = new PhidgetIRCodeInfo();
			var ptr:int = 0;
			var i:int=0;
			var byteCount:int;
			
			codeInfo.Repeat = new Array(IR_MAX_REPEAT_LENGTH);
			
			codeInfo.BitCount = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			byteCount = bitCountToByteCount(codeInfo.BitCount);
			codeInfo.Encoding = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.Length = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.Gap = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.Trail = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.Header[0] = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.Header[1] = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.One[0] = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.One[1] = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.Zero[0] = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.Zero[1] = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			for(i=0;i<IR_MAX_REPEAT_LENGTH;i++)
			{
				codeInfo.Repeat[i] = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			}
			codeInfo.MinRepeat = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.ToggleMask = "";
			for(i=(IR_MAX_CODE_DATA_LENGTH*2)-2;i>=0;i-=2)
			{
				if(((IR_MAX_CODE_DATA_LENGTH*2)-i)<=(byteCount*2))
					codeInfo.ToggleMask = codeInfo.ToggleMask + str.substring(ptr,ptr+2);
				ptr+=2;
			}
			codeInfo.CarrierFrequency = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			codeInfo.DutyCycle = int("0x"+flipString(str.substring(ptr,ptr+8))); ptr+=8;
			
			var code:String = str.substring(ptr,ptr+byteCount*2);
			var learnedCode:PhidgetIRLearnedCode = new PhidgetIRLearnedCode(code, codeInfo);
			
			return learnedCode;
		}
	}
}