package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetMotorControl
		A class for controlling a PhidgetMotorControl.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetMotorControl.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.INPUT_CHANGE		- digital input change
		PhidgetDataEvent.VELOCITY_CHANGE	- velocity change
		PhidgetDataEvent.CURRENT_CHANGE		- current change
		PhidgetDataEvent.CURRENT_UPDATE		- current updates (fixed rate)
		PhidgetDataEvent.POSITION_CHANGE	- encoder position change (Array:[timeChange, posnChange])
		PhidgetDataEvent.POSITION_UPDATE	- encoder position updates (fixed rate)
		PhidgetDataEvent.BACKEMF_UPDATE		- backemf updates (fixed rate)
		PhidgetDataEvent.SENSOR_UPDATE		- analog sensor updates (fixed rate)
	*/
	public class PhidgetMotorControl extends Phidget
	{
		private var numMotors:int;
		private var numInputs:int;
		private var numEncoders:int;
		private var numSensors:int;
		private var accelerationMin:Number;
		private var accelerationMax:Number;
		private var ratiometric:int;
		private var supplyvoltage:Number;
		
		private var velocities:Array;;
		private var accelerations:Array;
		private var currents:Array;
		private var inputs:Array;
		private var sensors:Array;
		private var rawsensors:Array;
		private var brakings:Array;
		private var backemfs:Array;
		private var backemfstates:Array;
		private var encoderpositiondeltas:Array;
		private var encoderpositions:Array;
		private var encoderpositionupdates:Array;
		private var encodertimestamps:Array;
		
		public function PhidgetMotorControl(){
			super("PhidgetMotorControl");
		}
		
		override protected function initVars():void{
			numMotors = com.phidgets.Constants.PUNK_INT;
			numInputs = com.phidgets.Constants.PUNK_INT;
			accelerationMin = com.phidgets.Constants.PUNK_NUM;
			accelerationMax = com.phidgets.Constants.PUNK_NUM;
			ratiometric = com.phidgets.Constants.PUNI_BOOL;
			supplyvoltage = com.phidgets.Constants.PUNI_NUM;
			inputs = new Array(4);
			velocities = new Array(2);
			accelerations = new Array(2);
			currents = new Array(2);
			sensors = new Array(2);
			rawsensors = new Array(2);
			brakings = new Array(2);
			backemfs = new Array(2);
			backemfstates = new Array(2);
			encoderpositiondeltas = [0];
			encoderpositions = [0];
			encoderpositionupdates = [0];
			encodertimestamps = [0];
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfMotors":
					numMotors = int(value);
					keyCount++;
					break;
				case "NumberOfInputs":
					numInputs = int(value);
					keyCount++;
					break;
				case "NumberOfEncoders":
					numEncoders = int(value);
					keyCount++;
					break;
				case "NumberOfSensors":
					numSensors = int(value);
					keyCount++;
					break;
				case "AccelerationMin":
					accelerationMin = Number(value);
					keyCount++;
					break;
				case "AccelerationMax":
					accelerationMax = Number(value);
					keyCount++;
					break;
				case "Input":
					if(inputs[index] == undefined)
						keyCount++;
					inputs[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE,this,intToBool(inputs[index]),index));
					break;
				case "Velocity":
					if(velocities[index] == undefined)
						keyCount++;
					velocities[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE,this,Number(velocities[index]),index));
					break;
				case "Acceleration":
					if(accelerations[index] == undefined)
						keyCount++;
					accelerations[index] = value;
					break;
				case "Current":
					if(currents[index] == undefined)
						keyCount++;
					currents[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE,this,Number(currents[index]),index));
					break;
				case "CurrentUpdate":
					currents[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_UPDATE,this,Number(currents[index]),index));
					break;
				case "Sensor":
					if(sensors[index] == undefined)
						keyCount++;
					sensors[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.SENSOR_UPDATE,this,Number(sensors[index]),index));
					break;
				case "RawSensor":
					if(rawsensors[index] == undefined)
						keyCount++;
					rawsensors[index] = value;
					break;
				case "Ratiometric":
					if(ratiometric == com.phidgets.Constants.PUNI_BOOL)
						keyCount++;
					ratiometric = int(value);
					break;
				case "Braking":
					if(brakings[index] == undefined)
						keyCount++;
					brakings[index] = value;
					break;
				case "BackEMF":
					if(backemfs[index] == undefined)
						keyCount++;
					backemfs[index] = value;
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.BACKEMF_UPDATE,this,Number(backemfs[index]),index));
					break;
				case "BackEMFState":
					if(backemfstates[index] == undefined)
						keyCount++;
					backemfstates[index] = value;
					break;
				case "SupplyVoltage":
					if(supplyvoltage == com.phidgets.Constants.PUNI_NUM)
						keyCount++;
					supplyvoltage = Number(value);
					break;
				case "ResetEncoderPosition":
					encoderpositiondeltas[index] = int(value);
					break;
				case "EncoderPosition":
					var posnArray:Array = value.split("/");
					var time:int = posnArray[0];
					var posn:int = posnArray[1];
					var posnChange:int = posn - encoderpositions[index];
					var encoderTimeChange:int = time - encodertimestamps[index];
		
					//timeout is 20 seconds
					if (encoderTimeChange > 60000)
						encoderTimeChange = com.phidgets.Constants.PUNK_INT;
						
					encoderpositions[index] = posn;
					encodertimestamps[index] = time;
						
					var eventArray:Array = new Array(2);
					eventArray[0] = encoderTimeChange;
					eventArray[1] = posnChange;
					
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,eventArray,index));
					break;
				case "EncoderPositionUpdate":
					var posnChange2:int = int(value) - encoderpositionupdates[index];
					encoderpositionupdates[index] = int(value);
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_UPDATE,this,posnChange2,index));
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			var i:int = 0
			for(i = 0; i<numInputs; i++)
			{
				if(isKnown(inputs, i, com.phidgets.Constants.PUNK_BOOL))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE,this,intToBool(inputs[i]),i));
			}
			for(i = 0; i<numMotors; i++)
			{
				if(isKnown(velocities, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE,this,Number(velocities[i]),i));
				if(isKnown(currents, i, com.phidgets.Constants.PUNK_NUM))
					dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE,this,Number(currents[i]),i));
			}
		}
		
		//Getters
		/*
			Property: InputCount
			Gets the number of digital inputs supported by this controller.
		*/
		public function get InputCount():int{
			if(numInputs == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numInputs;
		}
		/*
			Property: MotorCount
			Gets the number of motors supported by this controller.
		*/
		public function get MotorCount():int{
			if(numMotors == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numMotors;
		}
		/*
			Property: EncoderCount
			Gets the number of encoders supported by this controller.
		*/
		public function get EncoderCount():int{
			if(numEncoders == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numEncoders;
		}
		/*
			Property: SensorCount
			Gets the number of sensors supported by this controller.
		*/
		public function get SensorCount():int{
			if(numSensors == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numSensors;
		}
		/*
			Property: Ratiometric
			Gets the ratiometric state for the board.
		*/
		public function get Ratiometric():Boolean{
			if(ratiometric == com.phidgets.Constants.PUNK_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return intToBool(ratiometric);
		}
		/*
			Property: SupplyVoltage
			Gets the supply voltage for the board.
		*/
		public function get SupplyVoltage():Number{
			if(supplyvoltage == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return supplyvoltage;
		}
		/*
			Function: getAccelerationMin
			Gets the minimum acceleration that a motor can be set to.
			
			Parameters:
				index - motor index
		*/
		public function getAccelerationMin(index:int):Number{
			if(accelerationMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return accelerationMin;
		}
		/*
			Function: getAccelerationMax
			Gets the maximum acceleration that a motor can be set to.
			
			Parameters:
				index - motor index
		*/
		public function getAccelerationMax(index:int):Number{
			if(accelerationMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return accelerationMax;
		}
		/*
			Function: getInputState
			Gets the state of a digital input.
			
			Parameters:
				index - digital input index
		*/
		public function getInputState(index:int):Boolean{
			return intToBool(int(indexArray(inputs, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getAcceleration
			Gets the last acceleration that a motor was set at.
			
			Parameters:
				index - motor index
		*/
		public function getAcceleration(index:int):Number{
			return Number(indexArray(accelerations, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getVelocity
			Gets the current velocity of a motor.
			
			Parameters:
				index - motor index
		*/
		public function getVelocity(index:int):Number{
			return Number(indexArray(velocities, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getCurrent
			Gets the current current draw of a motor.
			Note that not all motor controllers support current sense.
			
			Parameters:
				index - motor index
		*/
		public function getCurrent(index:int):Number{
			return Number(indexArray(currents, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getEncoderPosition
			Gets the current current draw of a motor.
			Note that not all motor controllers support current sense.
			
			Parameters:
				index - motor index
		*/
		public function getEncoderPosition(index:int):Number{
			var posn:int = int(indexArray(encoderpositions, index, numEncoders, com.phidgets.Constants.PUNK_INT));
			var posnDelta:int = int(indexArray(encoderpositiondeltas, index, numEncoders, com.phidgets.Constants.PUNK_INT));
			return (posn - posnDelta);
		}
		/*
			Function: getBackEMFSensingState
			Gets the state of BackEMF sensing on a motor.
			
			Parameters:
				index - motor index
		*/
		public function getBackEMFSensingState(index:int):Boolean{
			return intToBool(int(indexArray(backemfstates, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Function: getBackEMF
			Gets the current BacKEMF value for a motor.
			
			Parameters:
				index - motor index
		*/
		public function getBackEMF(index:int):Number{
			return Number(indexArray(backemfs, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getBraking
			Gets the current braking value for a motor.
			
			Parameters:
				index - motor index
		*/
		public function getBraking(index:int):Number{
			return Number(indexArray(brakings, index, numMotors, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getSensorValue
			Gets the value of a sensor (0-1000).
			
			Parameters:
				index - sensor index
		*/
		public function getSensorValue(index:int):int{
			return int(indexArray(sensors, index, numSensors, com.phidgets.Constants.PUNK_INT));
		}
		/*
			Function: getSensorRawValue
			Gets the raw 12-bit value of a sensor (0-4095).
			
			Parameters:
				index - sensor index
		*/
		public function getSensorRawValue(index:int):int{
			return int(indexArray(rawsensors, index, numSensors, com.phidgets.Constants.PUNK_INT));
		}
		
		//Setters
		/*
			Function: setAcceleration
			Sets the acceleration for a motor.
			
			Parameters:
				index - motor index
				val - acceleraion
		*/
		public function setAcceleration(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Acceleration", index, numMotors), val.toString(), true);
		}
		/*
			Function: setVelocity
			Sets the velocity for a motor.
			
			Parameters:
				index - motor index
				val - velocity
		*/
		public function setVelocity(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Velocity", index, numMotors), val.toString(), true);
		}
		/*
			Function: setBackEMFSensingState
			Enables/Disables BackEMF sensing on a motor.
			
			Parameters:
				index - motor index
				val - state
		*/
		public function setBackEMFSensingState(index:int, val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("BackEMFState", index, numMotors), boolToInt(val).toString(), true);
		}
		/*
			Function: setBraking
			Sets the braking for a motor - enabled at velocity 0.
			
			Parameters:
				index - motor index
				val - braking ammount (0-100%)
		*/
		public function setBraking(index:int, val:Number):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Braking", index, numMotors), val.toString(), true);
		}
		//Setters
		/*
			Function: setEncoderPosition
			Sets/Resets the position of an encoder.
			
			Parameters:
				index - encoder index
				val - position
		*/
		public function setEncoderPosition(index:int, val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("ResetEncoderPosition", index, numEncoders), val.toString(), true);
		}
		/*
			Property: Ratiometric
			Sets the ratiometric state for a board.
			
			Parameters:
				val - ratiometric state
		*/
		public function set Ratiometric(val:Boolean):void{ 
			_phidgetSocket.setKey(makeKey("Ratiometric"), boolToInt(val).toString(), true);
		}
	}
}