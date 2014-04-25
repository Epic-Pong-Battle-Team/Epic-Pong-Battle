package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;

	/*
		Class: PhidgetLED
		A class for controlling a PhidgetLED.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
	public class PhidgetLED extends Phidget
	{
		private var numLEDs:int;
		private var leds:Array;
		private var voltage:int;
		private var currentLimit:int;
		private var currentLimits:Array;
		
		/*
			Constants: Current Limits
			These are the supported current limits for the Phidget LED 64 Advanced. These constants are used with <CurrentLimit>.
			
			PHIDGET_LED_CURRENT_LIMIT_20mA - 20mA.
			PHIDGET_LED_CURRENT_LIMIT_40mA - 40mA.
			PHIDGET_LED_CURRENT_LIMIT_60mA - 60mA.
			PHIDGET_LED_CURRENT_LIMIT_80mA - 80mA.
		*/
		public static const PHIDGET_LED_CURRENT_LIMIT_20mA:int = 1;
		public static const PHIDGET_LED_CURRENT_LIMIT_40mA:int = 2;
		public static const PHIDGET_LED_CURRENT_LIMIT_60mA:int = 3;
		public static const PHIDGET_LED_CURRENT_LIMIT_80mA:int = 4;
		
		/*
			Constants: Voltages
			These are the supported output voltages for the Phidget LED 64 Advanced. These constants are used with <Voltage>.
			
			PHIDGET_LED_VOLTAGE_1_7V  - 1.7V.
			PHIDGET_LED_VOLTAGE_2_75V - 2.75V.
			PHIDGET_LED_VOLTAGE_3_9V  - 3.9V.
			PHIDGET_LED_VOLTAGE_5_0V  - 5.0V.
		*/
		public static const PHIDGET_LED_VOLTAGE_1_7V:int = 1;
		public static const PHIDGET_LED_VOLTAGE_2_75V:int = 2;
		public static const PHIDGET_LED_VOLTAGE_3_9V:int = 3;
		public static const PHIDGET_LED_VOLTAGE_5_0V:int = 4;
		
		public function PhidgetLED(){
			super("PhidgetLED");
		}
		
		override protected function initVars():void{
			numLEDs = com.phidgets.Constants.PUNK_INT;
			leds = new Array(64);
			voltage = com.phidgets.Constants.PUNI_INT;
			currentLimit = com.phidgets.Constants.PUNI_INT;
			currentLimits = new Array(64);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfLEDs":
					numLEDs = int(value);
					keyCount++;
					break;
				case "Voltage":
					if(voltage == com.phidgets.Constants.PUNI_INT)
						keyCount++;
					voltage = int(value);
					break;
				case "CurrentLimit":
					if(currentLimit == com.phidgets.Constants.PUNI_INT)
						keyCount++;
					currentLimit = int(value);
					break;
				case "Brightness":
					if(leds[index] == undefined) keyCount++;
					leds[index] = value;
					break;
				case "CurrentLimitIndexed":
					if(currentLimits[index] == undefined) keyCount++;
					currentLimits[index] = value;
					break;
			}
		}
		
		//Getters
		/*
			Property: LEDCount
			Gets the number of LEDs supported by this PhidgetLED
		*/
		public function get LEDCount():int{
			if(numLEDs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numLEDs;
		}
		/*
			Property: Voltage
			Gets the voltage output for all LEDs. This is not supported by all PhidgetLEDs.
		*/
		public function get Voltage():int{
			if(voltage == com.phidgets.Constants.PUNI_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
			if(voltage == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return voltage;
		}
		/*
			Property: CurrentLimit
			Gets the current limit for all LEDs.  This is not supported by all PhidgetLEDs.
		*/
		public function get CurrentLimit():int{
			if(currentLimit == com.phidgets.Constants.PUNI_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
			if(currentLimit == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return currentLimit;
		}
		/*
			Function: getDiscreteLED
			Gets the brightness of an LED.
			Deprecated: use getBrightness
			
			Parameters:
				index - LED index
		*/
		public function getDiscreteLED(index:int):int{
			return int(indexArray(leds, index, numLEDs, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getBrightness
			Gets the brightness of an LED.
			
			Parameters:
				index - LED index
		*/
		public function getBrightness(index:int):Number{
			return Number(indexArray(leds, index, numLEDs, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getCurrentLimit
			Gets the current limit of an LED.
			
			Parameters:
				index - LED index
		*/
		public function getCurrentLimit(index:int):Number{
			return Number(indexArray(currentLimits, index, numLEDs, com.phidgets.Constants.PUNK_NUM));
		}
		
		//Setters
		/*
			Function: setDiscreteLED
			Sets the brightness of an LED (0-100).
			Deprecated: use setBrightness
			
			Parameters:
				index - LED index
				val - brightness
		*/
		public function setDiscreteLED(index:int, val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Brightness", index, numLEDs), val.toString(), true);
		}
		/*
			Function: setBrightness
			Sets the brightness of an LED (0-100).
			
			Parameters:
				index - LED index
				val - brightness
		*/
		public function setBrightness(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Brightness", index, numLEDs), val.toString(), true);
		}
		/*
			Function: setCurrentLimit
			Sets the current limit of an LED (0-80 mA).
			
			Parameters:
				index - LED index
				val - current limit
		*/
		public function setCurrentLimit(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("CurrentLimitIndexed", index, numLEDs), val.toString(), true);
		}
		/*
			Property: Voltage
			Sets the voltage for all LED outputs.  This is not supported by all PhidgetLEDs.
			
			Parameters:
				val - one of the predefined output voltages.
		*/
		public function set Voltage(val:int):void{ 
			if(voltage == com.phidgets.Constants.PUNI_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
			_phidgetSocket.setKey(makeKey("Voltage"), val.toString(), true);
		}
		/*
			Property: CurrentLimit
			Sets the current limit for all LED outputs.  This is not supported by all PhidgetLEDs.
			
			Parameters:
				val - one of the predefined current limits.
		*/
		public function set CurrentLimit(val:int):void{ 
			if(currentLimit == com.phidgets.Constants.PUNI_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
			_phidgetSocket.setKey(makeKey("CurrentLimit"), val.toString(), true);
		}
	}
}