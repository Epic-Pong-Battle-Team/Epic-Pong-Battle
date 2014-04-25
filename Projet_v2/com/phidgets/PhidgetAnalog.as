package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;

	/*
		Class: PhidgetAnalog
		A class for controlling a PhidgetAnalog.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
	public class PhidgetAnalog extends Phidget
	{
		private var numOutputs:int;
		private var voltageMin:Number;
		private var voltageMax:Number;
		private var voltage:Array;
		private var enabled:Array;
		
		public function PhidgetAnalog(){
			super("PhidgetAnalog");
		}
		
		override protected function initVars():void{
			numOutputs = com.phidgets.Constants.PUNK_INT;
			voltageMin = com.phidgets.Constants.PUNI_NUM;
			voltageMax = com.phidgets.Constants.PUNI_NUM;
			voltage = new Array(64);
			enabled = new Array(64);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfOutputs":
					numOutputs = int(value);
					keyCount++;
					break;
				case "VoltageMin":
					if(voltageMin == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					voltageMin = Number(value);
					break;
				case "VoltageMax":
					if(voltageMax == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					voltageMax = Number(value);
					break;
				case "Voltage":
					if(voltage[index] == undefined)
						keyCount++;
					voltage[index] = value;
					break;
				case "Enabled":
					if(enabled[index] == undefined)
						keyCount++;
					enabled[index] = value;
					break;
			}
		}
		
		//Getters
		/*
			Property: OutputCount
			Gets the number of outputs supported by this PhidgetAnalog
		*/
		public function get OutputCount():int{
			if(numOutputs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numOutputs;
		}
		/*
			Function: getVoltageMin
			Gets the minimum settable voltage for an output.
			
			Parameters:
				index - output index
		*/
		public function getVoltageMin(index:int):Number{
			if(voltageMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return voltageMin;
		}
		/*
			Function: getVoltageMax
			Gets the maximum settable voltage for an output.
			
			Parameters:
				index - output index
		*/
		public function getVoltageMax(index:int):Number{
			if(voltageMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return voltageMax;
		}
		/*
			Function: getEnabled
			Gets the enabled state of an output.
			
			Parameters:
				index - output index
		*/
		public function getEnabled(index:int):Boolean{
			return intToBool(int(indexArray(enabled, index, numOutputs, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getVoltage
			Gets the voltage of an output.
			
			Parameters:
				index - output index
		*/
		public function getVoltage(index:int):Number{
			return Number(indexArray(voltage, index, numOutputs, com.phidgets.Constants.PUNK_NUM));
		}
		
		//Setters
		/*
			Function: setVoltage
			Sets the voltage for an output.
			
			Parameters:
				index - output index
				val - voltage
		*/
		public function setVoltage(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Voltage", index, numOutputs), val.toString(), true);
		}
		/*
			Function: setEnabled
			Enables/Disables an output.
			
			Parameters:
				index - otuput index
				val - state
		*/
		public function setEnabled(index:int, val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Enabled", index, numOutputs), boolToInt(val).toString(), true);
		}
	}
}