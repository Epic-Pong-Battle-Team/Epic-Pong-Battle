package com.phidgets
{

	/*
		Class: PhidgetSpatialEventData
		Represents a set of spatial data, as recieved via the Spatial Data event
	*/
	public class PhidgetSpatialEventData
	{
		private var acceleration:Array;
		private var angularRate:Array;
		private var magneticField:Array;
		private var timeSeconds:int;
		private var timeMicroSeconds:int;
		
		public function PhidgetSpatialEventData(acceleration:Array, angularRate:Array, magneticField:Array, timeSeconds:int, timeMicroSeconds:int)
		{
			var i:int;
			this.acceleration = new Array(acceleration.length);
			for(i=0;i<acceleration.length;i++)
				this.acceleration[i] = acceleration[i];
			this.angularRate = new Array(angularRate.length);
			for(i=0;i<angularRate.length;i++)
				this.angularRate[i] = angularRate[i];
			this.magneticField = new Array(magneticField.length);
			for(i=0;i<magneticField.length;i++)
				this.magneticField[i] = magneticField[i];
			this.timeSeconds = timeSeconds;
			this.timeMicroSeconds = timeMicroSeconds;
		}
		
		/*
			Property: Acceleration
			Gets the acceleration array
		*/
		public function get Acceleration():Array{
			return acceleration;
		}
		/*
			Property: AngularRate
			Gets the angular rate array (gyro data)
		*/
		public function get AngularRate():Array{
			return angularRate;
		}
		/*
			Property: MagneticField
			Gets the magnetic field array (compass data)
		*/
		public function get MagneticField():Array{
			return magneticField;
		}
		/*
			Property: TimeSeconds
			Gets the number of whole seconds since attach.
		*/
		public function get TimeSeconds():int{
			return timeSeconds;
		}
		/*
			Property: TimeMicroSeconds
			Gets the number of microseconds since the last second (0-999999).
		*/
		public function get TimeMicroSeconds():int{
			return timeMicroSeconds;
		}
		/*
			Property: Time
			Gets the number of seconds since attach.
		*/
		public function get Time():Number{
			return (timeMicroSeconds/1000000.0 + timeSeconds);
		}
		
		public function toString():String{
			var out:String="";
			var i:int;
			var time:Number = timeSeconds + timeMicroSeconds/1000000.0;
			out = out + "Timestamp: "+time;
			if(acceleration.length>0)
			{
				out = out+"\n Acceleration: ";
				for(i=0;i<acceleration.length;i++)
					out = out + acceleration[i] + ((i==acceleration.length-1)?"":",");
			}
			if(angularRate.length>0)
			{
				out = out+"\n Angular Rate: ";
				for(i=0;i<angularRate.length;i++)
					out = out + angularRate[i] + ((i==angularRate.length-1)?"":",");
			}
			if(magneticField.length>0)
			{
				out = out+"\n Magnetic Field: ";
				for(i=0;i<magneticField.length;i++)
					out = out + magneticField[i] + ((i==magneticField.length-1)?"":",");
			}
			return out;
		}
	}
}