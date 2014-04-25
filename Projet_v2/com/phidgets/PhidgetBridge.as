package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetBridge
		A class for controlling a PhidgetBridge.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetBridge. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.BRIDGE_DATA	- bridge data. Comes in a dataRate intervals.
	*/
	public class PhidgetBridge extends Phidget
	{
		private var numInputs:int;
		private var dataRateMin:int;
		private var dataRateMax:int;
		private var dataRate:int;
		
		private var enabled:Array;
		private var gain:Array;
		private var bridgeValue:Array;
		private var bridgeMin:Array;
		private var bridgeMax:Array;
		
		/*
			Constants: Bridge Gains
			These are the Gains supported by PhidgetBridge. These constants are used with <getGain> and <setGain>.
			
			PHIDGET_BRIDGE_GAIN_1 - Gain of 1.
			PHIDGET_BRIDGE_GAIN_8 - Gain of 8.
			PHIDGET_BRIDGE_GAIN_16 - Gain of 16.
			PHIDGET_BRIDGE_GAIN_32 - Gain of 32.
			PHIDGET_BRIDGE_GAIN_64 - Gain of 64.
			PHIDGET_BRIDGE_GAIN_128 - Gain of 128.
		*/
		public static const PHIDGET_BRIDGE_GAIN_1:int = 1;
		public static const PHIDGET_BRIDGE_GAIN_8:int = 2;
		public static const PHIDGET_BRIDGE_GAIN_16:int = 3;
		public static const PHIDGET_BRIDGE_GAIN_32:int = 4;
		public static const PHIDGET_BRIDGE_GAIN_64:int = 5;
		public static const PHIDGET_BRIDGE_GAIN_128:int = 6;
		private static const PHIDGET_BRIDGE_GAIN_UNKNOWN:int = 7;
		
		public function PhidgetBridge(){
			super("PhidgetBridge");
		}
		
		override protected function initVars():void{
			numInputs = com.phidgets.Constants.PUNK_INT;
			dataRateMin = com.phidgets.Constants.PUNI_INT;
			dataRateMax = com.phidgets.Constants.PUNI_INT;
			dataRate = com.phidgets.Constants.PUNI_INT;
			enabled = new Array(4);
			gain = new Array(4);
			bridgeValue = new Array(4);
			bridgeMin = new Array(4);
			bridgeMax = new Array(4);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfInputs":
					numInputs = int(value);
					keyCount++;
					break;
				case "DataRate":
					if(dataRate == com.phidgets.Constants.PUNI_INT) keyCount++;
					dataRate = int(value);
					break;
				case "DataRateMin":
					if(dataRateMin == com.phidgets.Constants.PUNI_INT) keyCount++;
					dataRateMin = int(value);
					break;
				case "DataRateMax":
					if(dataRateMax == com.phidgets.Constants.PUNI_INT) keyCount++;
					dataRateMax = int(value);
					break;
				case "Enabled":
					if(enabled[index] == undefined)
						keyCount++;
					enabled[index] = int(value);
					break;
				case "BridgeMax":
					if(bridgeMax[index] == undefined)
						keyCount++;
					bridgeMax[index] = Number(value);
					break;
				case "BridgeMin":
					if(bridgeMin[index] == undefined)
						keyCount++;
					bridgeMin[index] = Number(value);
					break;
				case "Gain":
					if(gain[index] == undefined)
						keyCount++;
					gain[index] = int(value);
					break;
				case "BridgeValue":
					if(bridgeValue[index] == undefined)
						keyCount++;
					bridgeValue[index] = Number(value);
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.BRIDGE_DATA,this,Number(bridgeValue[index]),index));
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			for(var i:int = 0; i<numInputs; i++)
			{
				if(isKnown(bridgeValue, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.BRIDGE_DATA,this,Number(bridgeValue[i]),i));
			}
		}
		
		//Getters
		/*
			Property: InputCount
			Gets the number of inputs on this bridge.
		*/
		public function get InputCount():int{
			if(numInputs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numInputs;
		}
		/*
			Property: DataRate
			Gets the number of inputs on this bridge.
		*/
		public function get DataRate():int{
			if(dataRate == com.phidgets.Constants.PUNK_INT || dataRate == com.phidgets.Constants.PUNI_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return dataRate;
		}
		/*
			Property: DataRateMin
			Gets the number of inputs on this bridge.
		*/
		public function get DataRateMin():int{
			if(dataRateMin == com.phidgets.Constants.PUNK_INT || dataRate == com.phidgets.Constants.PUNI_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return dataRateMin;
		}
		/*
			Property: DataRateMax
			Gets the number of inputs on this bridge.
		*/
		public function get DataRateMax():int{
			if(dataRateMax == com.phidgets.Constants.PUNK_INT || dataRate == com.phidgets.Constants.PUNI_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return dataRateMax;
		}
		/*
			Function: getEnabled
			Gets the enabled state of an input.
			
			Parameters:
				index - input index
		*/
		public function getEnabled(index:int):Boolean{
			return intToBool(int(indexArray(enabled, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getBridgeValue
			Gets the value of an input, in mV/V
			
			Parameters:
				index - input index
		*/
		public function getBridgeValue(index:int):Number{
			return Number(indexArray(bridgeValue, index, numInputs, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getBridgeMin
			Gets minimum bridge value, in mV/V
			
			Parameters:
				index - input index
		*/
		public function getBridgeMin(index:int):Number{
			return Number(indexArray(bridgeMin, index, numInputs, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getBridgeMax
			Gets maximum bridge value, in mV/V
			
			Parameters:
				index - input index
		*/
		public function getBridgeMax(index:int):Number{
			return Number(indexArray(bridgeMax, index, numInputs, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getGain
			Gets the gain for an input.
			
			Parameters:
				index - input index.
		*/
		public function getGain(index:int):int{
			return int(indexArray(gain, index, numInputs, PHIDGET_BRIDGE_GAIN_UNKNOWN));
		}
		
		//Setters
		/*
			Property: DataRate
			Sets the data rate of the board, in ms. Must by a multiple of 8.
			
			Parameters:
				val - data rate.
		*/
		public function set DataRate(val:int):void{ 
			_phidgetSocket.setKey(makeKey("DataRate"), val.toString(), true);
		}
		/*
			Function: setEnabled
			Enables/Disables an input.
			
			Parameters:
				index - input index
				val - state
		*/
		public function setEnabled(index:int, val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Enabled", index, numInputs), boolToInt(val).toString(), true);
		}
		/*
			Function: setGain
			Sets the gain for an input. Set to one of the defined gains - <PHIDGET_BRIDGE_GAIN_1> - <PHIDGET_BRIDGE_GAIN_128>.
			
			Parameters:
				index - input index
				val - state
		*/
		public function setGain(index:int, val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Gain", index, numInputs), val.toString(), true);
		}
	}
}