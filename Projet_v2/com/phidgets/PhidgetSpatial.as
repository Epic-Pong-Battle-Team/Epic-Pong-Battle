package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	import flash.accessibility.Accessibility;

	/*
		Class: PhidgetSpatial
		A class for controlling a PhidgetSpatial.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetSpatial. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.SPATIAL_DATA	- spatial data
	*/
	public class PhidgetSpatial extends Phidget
	{
		private var numAccelAxes:int;
		private var numGyroAxes:int;
		private var numCompassAxes:int;
		private var accelerationMin:Number;
		private var accelerationMax:Number;
		private var angularRateMin:Number;
		private var angularRateMax:Number;
		private var magneticFieldMin:Number;
		private var magneticFieldMax:Number;
		private var dataRateMin:int;
		private var dataRateMax:int;
		private var dataRate:int;
		private var interruptRate:int;
		private var spatialDataNetwork:int;
		private var flip:int;
		
		private var acceleration:Array;
		private var angularRate:Array;
		private var magneticField:Array;
		
		public function PhidgetSpatial(){
			super("PhidgetSpatial");
		}
		
		override protected function initVars():void{
			numAccelAxes = com.phidgets.Constants.PUNK_INT;
			numGyroAxes = com.phidgets.Constants.PUNK_INT;
			numCompassAxes = com.phidgets.Constants.PUNK_INT;
			accelerationMin = com.phidgets.Constants.PUNK_NUM;
			accelerationMax = com.phidgets.Constants.PUNK_NUM;
			angularRateMin = com.phidgets.Constants.PUNK_NUM;
			angularRateMax = com.phidgets.Constants.PUNK_NUM;
			magneticFieldMin = com.phidgets.Constants.PUNK_NUM;
			magneticFieldMax = com.phidgets.Constants.PUNK_NUM;
			dataRateMin = com.phidgets.Constants.PUNK_INT;
			dataRateMax = com.phidgets.Constants.PUNK_INT;
			dataRate = com.phidgets.Constants.PUNI_INT;
			interruptRate = com.phidgets.Constants.PUNK_INT;
			spatialDataNetwork = com.phidgets.Constants.PUNI_BOOL;
			flip = 0;
			acceleration = new Array(3);
			angularRate = new Array(3);
			magneticField = new Array(3);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "AccelerationAxisCount":
					numAccelAxes = int(value);
					keyCount++;
					break;
				case "GyroAxisCount":
					numGyroAxes = int(value);
					keyCount++;
					break;
				case "CompassAxisCount":
					numCompassAxes = int(value);
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
				case "AngularRateMin":
					angularRateMin = Number(value);
					keyCount++;
					break;
				case "AngularRateMax":
					angularRateMax = Number(value);
					keyCount++;
					break;
				case "MagneticFieldMin":
					magneticFieldMin = Number(value);
					keyCount++;
					break;
				case "MagneticFieldMax":
					magneticFieldMax = Number(value);
					keyCount++;
					break;
				case "DataRateMin":
					dataRateMin = int(value);
					keyCount++;
					break;
				case "DataRateMax":
					dataRateMin = int(value);
					keyCount++;
					break;
				case "DataRate":
					if(dataRate == com.phidgets.Constants.PUNI_INT)
						keyCount++;
					dataRate = int(value);
					break;
				case "InterruptRate":
					interruptRate = int(value);
					keyCount++;
					break;
				case "SpatialData":
					if(spatialDataNetwork == com.phidgets.Constants.PUNI_BOOL)
						keyCount++;
					spatialDataNetwork = 1;
					
					var data:Array = value.split(',');
					var i:int;
					
					for(i=0;i<3;i++)
					{
						acceleration[i] = data[i];
					}
					for(i=0;i<3;i++)
					{
						angularRate[i] = data[i+3];
					}
					for(i=0;i<3;i++)
					{
						magneticField[i] = data[i+6];
					}
						
					if(isAttached)
					{
						var accel:Array = new Array(numAccelAxes);
						for(i=0;i<numAccelAxes;i++)
						{
							accel[i] = acceleration[i];
						}
						var gyro:Array = new Array(numGyroAxes);
						for(i=0;i<numGyroAxes;i++)
						{
							gyro[i] = angularRate[i];
						}
						var comp:Array;
						if(numCompassAxes > 0 && magneticField[0] <= magneticFieldMax && magneticField[0] >= magneticFieldMin)
						{
							comp = new Array(numCompassAxes);
							for(i=0;i<numCompassAxes;i++)
							{
								comp[i] = magneticField[i];
							}
						}
						else
							comp = new Array(0);
						var sData:PhidgetSpatialEventData = new PhidgetSpatialEventData(accel, gyro, comp, data[9], data[10]);
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.SPATIAL_DATA,this,sData));
					}
					
					break;
			}
		}
		
		//don't need to worry about eventsAfterOpen, because the interrupts come at a set rate
		
		//Getters
		/*
			Property: AccelerationAxisCount
			Gets the number of acceleration axes.
		*/
		public function get AccelerationAxisCount():int{
			if(numAccelAxes == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numAccelAxes;
		}
		/*
			Function: getAcceleration
			Gets the acceleration of a axis.
			
			Parameters:
				index - acceleration axis
		*/
		public function getAcceleration(index:int):Number{
			return Number(indexArray(acceleration, index, numAccelAxes, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getAccelerationMin
			Gets the minimum acceleration that an axis will return.
			
			Parameters:
				index - acceleration axis
		*/
		public function getAccelerationMin(index:int):Number{
			if(accelerationMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return accelerationMin;
		}
		/*
			Function: getAccelerationMax
			Gets the maximum acceleration that an axis will return.
			
			Parameters:
				index - acceleration index
		*/
		public function getAccelerationMax(index:int):Number{
			if(accelerationMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return accelerationMax;
		}
		/*
			Property: GyroAxisCount
			Gets the number of gyroscope axes.
		*/
		public function get GyroAxisCount():int{
			if(numGyroAxes == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numGyroAxes;
		}
		/*
			Function: getAngularRate
			Gets the angularRate of a axis.
			
			Parameters:
				index - angularRate axis
		*/
		public function getAngularRate(index:int):Number{
			return Number(indexArray(angularRate, index, numGyroAxes, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getAngularRateMin
			Gets the minimum angularRate that an axis will return.
			
			Parameters:
				index - angularRate axis
		*/
		public function getAngularRateMin(index:int):Number{
			if(angularRateMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return angularRateMin;
		}
		/*
			Function: getAngularRateMax
			Gets the maximum angularRate that an axis will return.
			
			Parameters:
				index - angularRate index
		*/
		public function getAngularRateMax(index:int):Number{
			if(angularRateMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return angularRateMax;
		}
		/*
			Property: CompassAxisCount
			Gets the number of compass axes.
		*/
		public function get CompassAxisCount():int{
			if(numCompassAxes == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numCompassAxes;
		}
		/*
			Function: getMagneticField
			Gets the magneticField of a axis.
			
			Parameters:
				index - magneticField axis
		*/
		public function getMagneticField(index:int):Number{
			return Number(indexArray(magneticField, index, numCompassAxes, com.phidgets.Constants.PUNK_NUM));
		}
		/*
			Function: getMagneticFieldMin
			Gets the minimum magneticField that an axis will return.
			
			Parameters:
				index - magneticField axis
		*/
		public function getMagneticFieldMin(index:int):Number{
			if(magneticFieldMin == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return magneticFieldMin;
		}
		/*
			Function: getMagneticFieldMax
			Gets the maximum magneticField that an axis will return.
			
			Parameters:
				index - magneticField index
		*/
		public function getMagneticFieldMax(index:int):Number{
			if(magneticFieldMax == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return magneticFieldMax;
		}
		/*
			Property: DataRate
			Gets the data rate, in milliseconds.
		*/
		public function get DataRate():int{
			if(dataRate == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return dataRate;
		}
		/*
			Property: DataRateMin
			Gets the minimum data rate, in milliseconds.
		*/
		public function get DataRateMin():int{
			if(dataRateMin == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return dataRateMin;
		}
		/*
			Property: DataRateMax
			Gets the maximum data rate, in milliseconds.
		*/
		public function get DataRateMax():int{
			if(dataRateMax == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return dataRateMax;
		}
		
		//Setters
		/*
			Property: setDataRate
			Sets the data rate for a sensor, in milliseconds.
			
			Parameters:
				val - data rate
		*/
		public function set DataRate(val:int):void{ 
			_phidgetSocket.setKey(makeKey("DataRate"), val.toString(), true);
		}
		/*
			Function: zeroGyro
			Re-Zeroes the gyro. This should only be called when stationary.
		*/
		public function zeroGyro(val:int):void{ 
			flip ^= 1;
			_phidgetSocket.setKey(makeKey("ZeroGyro"), flip.toString(), true);
		}
		/*
			Function: setCompassCorrectionParameters
			Sets the compass correction factors. This can be used to correcting any sensor errors, including hard and soft iron offsets and sensor error factors.
			
			Parameters:
				magField - Local magnetic field strength.
				offset0 - Axis 0 offset correction.
				offset1 - Axis 1 offset correction.
				offset2 - Axis 2 offset correction.
				gain0 - Axis 0 gain correction.
				gain1 - Axis 1 gain correction.
				gain2 - Axis 2 gain correction.
				T0 - Non-orthogonality correction factor 0.
				T1 - Non-orthogonality correction factor 1.
				T2 - Non-orthogonality correction factor 2.
				T3 - Non-orthogonality correction factor 3.
				T4 - Non-orthogonality correction factor 4.
				T5 - Non-orthogonality correction factor 5.
		*/
		public function setCompassCorrectionParameters(magField:Number, offset0:Number, offset1:Number, offset2:Number, gain0:Number, gain1:Number, gain2:Number, T0:Number, T1:Number, T2:Number, T3:Number, T4:Number, T5:Number):void{ 
			var val:String = magField+","+offset0+","+offset1+","+offset2+","+gain0+","+gain1+","+gain2+","+T0+","+T1+","+T2+","+T3+","+T4+","+T5;
			_phidgetSocket.setKey(makeKey("CompassCorrectionParams"), val.toString(), true);
		}
		/*
			Function: setCompassCorrectionParameters
			Sets the compass correction factors. This can be used to correcting any sensor errors, including hard and soft iron offsets and sensor error factors.
			
			Parameters:
				magField - Local magnetic field strength.
				offset0 - Axis 0 offset correction.
				offset1 - Axis 1 offset correction.
				offset2 - Axis 2 offset correction.
				gain0 - Axis 0 gain correction.
				gain1 - Axis 1 gain correction.
				gain2 - Axis 2 gain correction.
				T0 - Non-orthogonality correction factor 0.
				T1 - Non-orthogonality correction factor 1.
				T2 - Non-orthogonality correction factor 2.
				T3 - Non-orthogonality correction factor 3.
				T4 - Non-orthogonality correction factor 4.
				T5 - Non-orthogonality correction factor 5.
		*/
		public function resetCompassCorrectionParameters():void{ 
			var val:String ="1,0,0,0,1,1,1,0,0,0,0,0,0";
			_phidgetSocket.setKey(makeKey("CompassCorrectionParams"), val.toString(), true);
		}
	}
}