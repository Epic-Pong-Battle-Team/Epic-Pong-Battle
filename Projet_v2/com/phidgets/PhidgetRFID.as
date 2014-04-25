package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetRFID
		A class for controlling a PhidgetRFID.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetRFID. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.OUTPUT_CHANGE	- digital output change
		PhidgetDataEvent.TAG			- rfid tag detected
		PhidgetDataEvent.TAG_LOST		- rfid tag removed
		
	*/
	public class PhidgetRFID extends Phidget
	{
		private var numOutputs:int;
		
		private var lastTag:String;
		private var lastTagProtocol:int;
		private var tagState:int;
		private var lastTagValid:int;
		private var antennaState:int;
		private var ledState:int;
		private var outputs:Array;
		
		/*
			Constants: RFID Protocols
			These are the protocols supported by the PhidgetRFID. These constants are used with <write> and <getLastTagProtocol>.
			
			PHIDGET_RFID_PROTOCOL_EM4100 - EM4100 (EM4102) 40-bit.
			PHIDGET_RFID_PROTOCOL_ISO11785_FDX_B - ISO11785 FDX-B encoding (Animal ID).
			PHIDGET_RFID_PROTOCOL_PHIDGETS - PhidgetsTAG Protocol 24 character ASCII.
		*/
		public static const PHIDGET_RFID_PROTOCOL_EM4100:int = 1;
		public static const PHIDGET_RFID_PROTOCOL_ISO11785_FDX_B:int = 2;
		public static const PHIDGET_RFID_PROTOCOL_PHIDGETS:int = 3;
		
		public function PhidgetRFID(){
			super("PhidgetRFID");
		}
		
		override protected function initVars():void{
			numOutputs = com.phidgets.Constants.PUNK_INT;
			lastTag = null;
			lastTagProtocol = 0;
			outputs = new Array(2);
			lastTagValid = com.phidgets.Constants.PUNI_BOOL;
			tagState = com.phidgets.Constants.PUNI_BOOL;
			antennaState = com.phidgets.Constants.PUNI_BOOL;
			ledState = com.phidgets.Constants.PUNI_BOOL;
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfOutputs":
					numOutputs = int(value);
					keyCount++;
					break;
				case "LastTag":
					lastTagProtocol = int(value.split("/")[0]);
					lastTag = value.substring(value.indexOf("/")+1);
					if(lastTagValid == com.phidgets.Constants.PUNI_BOOL)
						keyCount++;
					lastTagValid = com.phidgets.Constants.PTRUE;
					break;
				case "Tag2":
					if(tagState == com.phidgets.Constants.PUNI_BOOL)
						keyCount++;
					tagState = com.phidgets.Constants.PTRUE;
					var tagString:String = value.substring(value.indexOf("/")+1);
					var tagProto:int = int(value.split("/")[0]);
					if(isAttached)
						dispatchEvent(
						new PhidgetDataEvent(
							PhidgetDataEvent.TAG,this,
							new PhidgetRFIDTag(
								tagString,
								tagProto
							)
						));
					lastTag = tagString;
					lastTagProtocol = tagProto;
					break;
				case "TagLoss2":
					if(tagState == com.phidgets.Constants.PUNI_BOOL)
						keyCount++;
					tagState = com.phidgets.Constants.PFALSE;
					if(isAttached)
						dispatchEvent(
						new PhidgetDataEvent(
							PhidgetDataEvent.TAG_LOST,this,
							new PhidgetRFIDTag(
								value.substring(value.indexOf("/")+1),
								int(value.split("/")[0])
							)
						));
					break;
				case "TagState":
					if(tagState == com.phidgets.Constants.PUNI_BOOL)
						keyCount++;
					tagState = int(value);
					break;
				case "AntennaOn":
					if(antennaState == com.phidgets.Constants.PUNI_BOOL)
						keyCount++;
					antennaState = int(value);
					break;
				case "LEDOn":
					if(ledState == com.phidgets.Constants.PUNI_BOOL)
						keyCount++;
					ledState = int(value);
					break;
				case "Output":
					if(outputs[index] == undefined)
						keyCount++;
					outputs[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.OUTPUT_CHANGE,this,intToBool(outputs[index]),index));
					break;
			}
		}
		
		override protected function eventsAfterOpen():void
		{
			for(var i:int = 0; i<numOutputs; i++)
			{
				if(isKnown(outputs, i, com.phidgets.Constants.PUNK_BOOL))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.OUTPUT_CHANGE,this,intToBool(outputs[i]),i));
			}
			if(tagState == com.phidgets.Constants.PTRUE)
				dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.TAG,this,new PhidgetRFIDTag(lastTag, lastTagProtocol)));
		}
		
		
		//Getters
		/*
			Property: OutputCount
			Gets the number of digital outputs supported by this board.
		*/
		public function get OutputCount():int{
			if(numOutputs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numOutputs;
		}
		/*
			Property: Antenna
			Gets the antenna state.
		*/
		public function get Antenna():Boolean{
			if(antennaState == com.phidgets.Constants.PUNK_BOOL || antennaState == com.phidgets.Constants.PUNI_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return intToBool(antennaState);
		}
		/*
			Property: LED
			Gets the onboard LED state.
		*/
		public function get LED():Boolean{
			if(ledState == com.phidgets.Constants.PUNK_BOOL || ledState == com.phidgets.Constants.PUNI_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return intToBool(ledState);
		}
		/*
			Property: TagPresent
			Gets whether a tag is currently being detected by the reader.
		*/
		public function get TagPresent():Boolean{
			if(tagState == com.phidgets.Constants.PUNK_BOOL || tagState == com.phidgets.Constants.PUNI_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return intToBool(tagState);
		}
		/*
			Property: Antenna
			Sets the antenna state.
			Note that the antenna is initially disabled and must be enabled before any tags will be read.
			
			Parameters:
				val - antenna state
		*/
		public function set Antenna(val:Boolean):void{ 
			_phidgetSocket.setKey(makeKey("AntennaOn"), boolToInt(val).toString(), true);
		}
		/*
			Property: LED
			Sets the onboard LED state.
			
			Parameters:
				val - led state
		*/
		public function set LED(val:Boolean):void{ 
			_phidgetSocket.setKey(makeKey("LEDOn"), boolToInt(val).toString(), true);
		}
		
		/*
			Function: getLastTag
			Gets the last tag read. This tag may or may not still be on the reader.
		*/
		public function getLastTag():PhidgetRFIDTag{
			if(lastTag == null)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return new PhidgetRFIDTag(lastTag, lastTagProtocol);
		}
		/*
			Function: getOutputState
			Gets the state of a digital output.
			
			Parameters:
				index - digital output index
		*/
		public function getOutputState(index:int):Boolean{
			return intToBool(int(indexArray(outputs, index, numOutputs, com.phidgets.Constants.PUNK_BOOL)));
		}
		
		//Setters
		/*
			Function: setOutputState
			Sets the state of a digital output.
			
			Parameters:
				index - digital output index
				val - output state
		*/
		public function setOutputState(index:int, val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Output", index, numOutputs), boolToInt(val).toString(), true);
		}
		
		/*
			Function: write
			Write a tag.
			
			Parameters:
				tag - tag string and protocol.
				lock - lock the tag from being written again. Defaults to FALSE.
		*/
		public function write(tag:PhidgetRFIDTag, lock:Boolean = false):void {
			_phidgetSocket.setKey(makeKey("WriteTag"), tag.Protocol + "/" + boolToInt(lock) + "/" + tag.Tag, true);
		}
	}
}