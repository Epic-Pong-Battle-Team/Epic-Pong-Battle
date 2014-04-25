package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetFrequencyCounter
		A class for controlling a PhidgetFrequencyCounter.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetFrequencyCounter. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.COUNT	- counts (Array:[timeChange, countChange]). Happens when input counts are recieved, or when the timeout occurs.
	*/
	public class PhidgetFrequencyCounter extends Phidget
	{
		private var numInputs:int;
		
		private var frequency:Array;
		private var timeout:Array;
		private var filter:Array;
		private var enabled:Array;
		private var totalCount:Array;
		private var totalTime:Array;
		private var countsGood:Array;
		
		private var flip:int;
		
		/*
			Constants: FrequencyCounter filter types
			These are the filter types supported by PhidgetFrequencyCounter. These constants are used with <getFilter> and <setFilter>.
			
			PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_ZERO_CROSSING - zero crossing filter.
			PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_LOGIC_LEVEL - logic level filter.
		*/
		public static const PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_ZERO_CROSSING:int = 1;
		public static const PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_LOGIC_LEVEL:int = 2;
		private static const PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_UNKNOWN:int = 3;
		
		public function PhidgetFrequencyCounter(){
			super("PhidgetFrequencyCounter");
		}
		
		override protected function initVars():void{
			numInputs = com.phidgets.Constants.PUNK_INT;
			frequency = new Array(2);
			timeout = new Array(2);
			filter = new Array(2);
			enabled = new Array(2);
			totalCount = new Array(2);
			totalTime = new Array(2);
			countsGood = new Array(2);
			
			flip = 0;
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfInputs":
					numInputs = int(value);
					keyCount++;
					break;
				case "Enabled":
					if(enabled[index] == undefined)
						keyCount++;
					enabled[index] = int(value);
					break;
				case "Timeout":
					if(timeout[index] == undefined)
						keyCount++;
					timeout[index] = int(value);
					break;
				case "Filter":
					if(filter[index] == undefined)
						keyCount++;
					filter[index] = int(value);
					break;
				case "Count":
				case "CountReset":
					var data:Array = value.split("/");
					var totTime:Number = data[0];
					var totCount:Number = data[1];
					var freq:Number = data[2];
		
					if(frequency[index] == undefined)
						keyCount++;
		
					frequency[index] = freq;
		
					//no event on first time or reset
					if(countsGood[index] == true && setThing == "Count")
					{
						var timeChange:int = int(totTime - totalTime[index]);
						var cntChange:int = int(totCount - totalCount[index]);
						
						totalTime[index] = totTime;
						totalCount[index] = totCount;
						
						var eventData:Array;
						eventData = [timeChange, cntChange];
						
						if(isAttached)
							dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.COUNT,this,eventData,index));
					}
					else
					{
						totalTime[index] = totTime;
						totalCount[index] = totCount;
					}
					countsGood[index] = true;
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
		}
		
		//Getters
		/*
			Property: FrequencyInputCount
			Gets the number of inputs on this frequencycounter.
		*/
		public function get FrequencyInputCount():int{
			if(numInputs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numInputs;
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
			Function: getFrequency
			Gets the frequency, in Hz.
			
			Parameters:
				index - input index
		*/
		public function getFrequency(index:int):Number{
			return Number(indexArray(frequency, index, numInputs, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getFilter
			Gets the filter type for an input.
			
			Parameters:
				index - input index.
		*/
		public function getFilter(index:int):int{
			return int(indexArray(filter, index, numInputs, PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_UNKNOWN));
		}
		/*
			Function: getTimeout
			Gets the timeout for an input, in microseconds
			
			Parameters:
				index - input index.
		*/
		public function getTimeout(index:int):int{
			return int(indexArray(timeout, index, numInputs, com.phidgets.Constants.PUNK_INT));
		}
		/*
			Function: getTotalCount
			Gets the total count of input pulses.
			
			Parameters:
				index - input index.
		*/
		public function getTotalCount(index:int):Number{
			return Number(indexArray(totalCount, index, numInputs, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getTotalTime
			Gets the total time of input pulses.
			
			Parameters:
				index - input index.
		*/
		public function getTotalTime(index:int):Number{
			return Number(indexArray(totalTime, index, numInputs, com.phidgets.Constants.PUNK_NUM));
		}
		
		//Setters
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
			Function: setFilter
			Sets the filter type for an input. Set to one of the defined filter types -
			 <PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_ZERO_CROSSING> - <PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_LOGIC_LEVEL>.
			
			Parameters:
				index - input index
				val - state
		*/
		public function setFilter(index:int, val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Filter", index, numInputs), val.toString(), true);
		}
		/*
			Function: setTimeout
			Sets the timout for an input, in microseconds.
			
			Parameters:
				index - input index
				val - state
		*/
		public function setTimeout(index:int, val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Timeout", index, numInputs), val.toString(), true);
		}
		/*
			Function: reset
			Resets the totalCount and totalTime for an input.
		*/
		public function reset(val:int):void{ 
			flip ^= 1;
			_phidgetSocket.setKey(makeKey("Reset"), flip.toString(), true);
		}
	}
}