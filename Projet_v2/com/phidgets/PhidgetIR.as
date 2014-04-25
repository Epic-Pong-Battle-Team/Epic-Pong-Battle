package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	import flash.accessibility.Accessibility;

	
	/*
		Class: PhidgetIR
		A class for controlling a PhidgetIR.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetIR. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.CODE		- code
		PhidgetDataEvent.RAW_DATA	- raw data
		PhidgetDataEvent.LEARN		- learned code
	*/
	public class PhidgetIR extends Phidget
	{
		internal static const IR_DATA_ARRAY_SIZE:int = 2048;
		internal static const IR_DATA_ARRAY_MASK:int = 0x7ff;
		
		public static const RAWDATA_LONGSPACE:int = 0xfffff; //1048575;
	
		private var rawData:Array;
		private var dataWritePtr:int;
		private var userReadPtr:int;

		private var lastCode:PhidgetIRCode;
		private var lastLearnedCode:PhidgetIRLearnedCode;
		
		private var flip:int;
		
		public function PhidgetIR(){
			super("PhidgetIR");
		}
		
		override protected function initVars():void{
			rawData = new Array(IR_DATA_ARRAY_SIZE);
			dataWritePtr = 0;
			userReadPtr = 0;
			lastCode = null;
			lastLearnedCode = null;
			flip=0;
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "Code":
					var data:Array = value.split(',');
					var code:PhidgetIRCode = new PhidgetIRCode(data[0], data[1], data[2]=="0"?false:true);
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CODE,this,code));
					lastCode = code;
					break;
				case "Learn":
					var learnedCode:PhidgetIRLearnedCode = PhidgetIRLearnedCode.stringToPhidgetIRLearnedCode(value);
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.LEARN,this,learnedCode));
					lastLearnedCode = learnedCode;
					break;
				case "RawData":
					var dataString:String = value.split(',')[0];
					var rawDataSendCnt:int = new int(value.split(',')[1]);
					var dataLength:int = dataString.length / 5;
					var rdata:Array = new Array(dataLength);
					
					for(var i:int=0;i<dataLength;i++)
						rdata[i] = int("0x0"+dataString.substr(i*5,5));
	
					//ACK this raw data packet
					_phidgetSocket.setKey(makeIndexedKey("RawDataAck", index, 100), rawDataSendCnt.toString(), true);
					
					//add to buffer for readRaw
					for(var j:int=0;j<dataLength;j++)
					{
						rawData[dataWritePtr] = rdata[j];
		
						dataWritePtr++;
						dataWritePtr &= IR_DATA_ARRAY_MASK;
						//if we run into data that hasn't been read... too bad, we overwrite it and adjust the read pointer
						if(dataWritePtr == userReadPtr)
						{
							userReadPtr++;
							userReadPtr &= IR_DATA_ARRAY_MASK;
						}
					}
					
					//send event
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.RAW_DATA,this,rdata));
					
					break;
			}
		}
		
		//Getters
		/*
			Property: LastCode
			Gets the last code received.
		*/
		public function get LastCode():PhidgetIRCode{
			if(lastCode == null)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return lastCode;
		}
		/*
			Property: LastLearnedCode
			Gets the last code received.
		*/
		public function get LastLearnedCode():PhidgetIRLearnedCode{
			if(lastLearnedCode == null)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return lastLearnedCode;
		}
		
		//Functions
		/*
			Function: readRaw
			Read raw IR data. Read data always starts with a space and ends with a pulse.
			
			parameters:
				buffer - an array to read data into
				offset - offset in array to start writing data. Defaults to 0 (start of array);
				count - maximum ammount of data to read. Defaults to size of array.
				
			Returns:
				The ammount of data actually read.
		*/
		public function readRaw(buffer:Array, offset:int=0, count:int=-1):int
		{
			var i:int = 0;
				
			if(offset<0 || offset >= buffer.length)
				return 0;
				
			//make sure count isn't too high
			if(count+offset > buffer.length || count==-1)
				count=buffer.length - offset;
				
			//make sure length is even so we only send out data with starting space and ending pulse
			if((count % 2) == 1)
				count--;
		
			for(i=0;i<count;i++)
			{
				if(userReadPtr == dataWritePtr)
					break;
		
				buffer[i+offset] = rawData[userReadPtr];
				userReadPtr = (userReadPtr + 1) & IR_DATA_ARRAY_MASK;
			}
		
			//make sure i is even so that we don't end with a pulse
			if((i % 2) == 1)
			{
				//negate the pulse if we added it
				i--;
				userReadPtr = (userReadPtr - 1) & IR_DATA_ARRAY_MASK;
				buffer[i+offset] = null;
			}
	
			return i;
		}
		
		/*
			Function: transmit
			Transmit an IR code.
			
			parameters:
				code - the code to transmit. Right-justified hex string (same format as codes coming in).
				codeInfo - code information.
		*/
		public function transmit(code:String, codeInfo:PhidgetIRCodeInfo):void
		{
			_phidgetSocket.setKey(makeKey("Transmit"), codeInfo.toString() + code, true);
		}
		/*
			Function: transmitRepeat
			Transmit a repeat code. Call after calling transmit. Make sure to pause at least 20ms between calls to this function
		*/
		public function transmitRepeat():void
		{
			flip ^= 1;
			_phidgetSocket.setKey(makeKey("Repeat"), flip.toString(), true);
		}
		
		//pad to 20-bit
		private function pad(str:String):String{
			if(str.length>5)
				str="fffff";
			while(str.length < 5)
				str = "0"+str;
			return str;
		}
		/*
			Function: transmitRaw
			Transmit raw data. Use this for codes that cannot be specified using a PhidgetIRCodeInfo object.
			
			parameters:
				data - the raw data to transmit. Data is in microseconds, and must start and end with a pulse.
				carrierFrequency - carrier frequency to use. Optional, defaults to 38000kHz.
				dutyCycle - duty cycle to use. Optional, defaults to 33%.
				gap - gap length to maintain after data is transmitted. Optional, default is 0.
		*/
		public function transmitRaw(data:Array, carrierFrequency:int=0, dutyCycle:int=0, gap:int=0):void
		{
			var dataStr:String = "";
			for(var i:int=0;i<data.length;i++)
			{
				dataStr = dataStr + pad(data[i].toString(16));
			}
			dataStr = dataStr + "," + carrierFrequency.toString() + "," + dutyCycle.toString() + "," + gap.toString();
			_phidgetSocket.setKey(makeKey("TransmitRaw"), dataStr, true);
		}
	}
}