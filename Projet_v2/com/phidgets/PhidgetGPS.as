package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetGPS
		A class for interfacing with a PhidgetGPS.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetGPS. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.FIX_CHANGE	- position fix status change
		PhidgetDataEvent.POSITION_CHANGE	- position change (Array:[latitude,longitude,altitude])
	*/
	public class PhidgetGPS extends Phidget
	{
		private var date:Date;
		private var altitude:Number;
		private var heading:Number;
		private var velocity:Number;
		private var latitude:Number;
		private var longitude:Number;
		private var fix:int;
		private var havedate:Boolean;
		
		public function PhidgetGPS(){
			super("PhidgetGPS");
		}
		
		override protected function initVars():void{
			havedate = false;
			altitude = com.phidgets.Constants.PUNK_NUM;
			heading = com.phidgets.Constants.PUNK_NUM;
			velocity = com.phidgets.Constants.PUNK_NUM;
			latitude = com.phidgets.Constants.PUNK_NUM;
			longitude = com.phidgets.Constants.PUNK_NUM;
			fix = com.phidgets.Constants.PUNI_INT;
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "PositionFix":
					if(fix == com.phidgets.Constants.PUNI_INT)
						keyCount++;
					fix = int(value);
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.FIX_CHANGE,this,intToBool(fix)));
					break;
				case "Velocity":
					velocity = Number(value);
					break;
				case "Heading":
					heading = Number(value);
					break;
				case "DateTime":
					var data:Array = value.split("/");
					date = new Date();
					date.setUTCFullYear(int(data[0]), int(data[1]), int(data[2]));
					date.setUTCHours(int(data[3]), int(data[4]), int(data[5]), int(data[6]));
					havedate = true;
					break;
				case "Position":
					var data2:Array = value.split("/");
					latitude = Number(data2[0]);
					longitude = Number(data2[1]);
					altitude = Number(data2[2]);
					var eventData:Array = [latitude,longitude,altitude];
					if(isAttached)
						dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,eventData));
					break;
			}
		}
		override protected function eventsAfterOpen():void
		{
			if(fix != com.phidgets.Constants.PUNK_INT)
				dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.FIX_CHANGE,this,intToBool(fix)));
			if(intToBool(fix) == true && latitude != com.phidgets.Constants.PUNK_NUM)
			{
				var eventData:Array = [latitude,longitude,altitude];
				dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE,this,eventData));
			}
		}
		
		//Getters
		/*
			Property: PositionFixStatus
			Gets the position fix status of this gps.
		*/
		public function get PositionFixStatus():Boolean{
			if(fix == com.phidgets.Constants.PUNK_BOOL)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return intToBool(fix);
		}
		/*
			Property: Latitude
			Gets the last recieved latitude.
		*/
		public function get Latitude():Number{
			if(latitude == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return latitude;
		}
		/*
			Property: Longitude
			Gets the last recieved longitude.
		*/
		public function get Longitude():Number{
			if(longitude == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return longitude;
		}
		/*
			Property: Altitude
			Gets the last recieved altitude.
		*/
		public function get Altitude():Number{
			if(altitude == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return altitude;
		}
		/*
			Property: Heading
			Gets the last recieved heading.
		*/
		public function get Heading():Number{
			if(heading == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return heading;
		}
		/*
			Property: Velocity
			Gets the last recieved velocity.
		*/
		public function get Velocity():Number{
			if(velocity == com.phidgets.Constants.PUNK_NUM)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return velocity;
		}
		/*
			Property: DateTime
			Gets the last recieved date and time in UTC.
		*/
		public function get DateTime():Date{
			if(!havedate)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return date;
		}
		
		//Setters
	}
}