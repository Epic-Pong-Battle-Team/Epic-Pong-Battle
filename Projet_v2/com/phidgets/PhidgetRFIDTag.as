package com.phidgets
{
	/*
		Class: PhidgetRFIDTag
		Represents an RFID Tag, as recieved via the RFID Tag events
	*/
	public class PhidgetRFIDTag
	{
		private var protocol:int;
		private var tagString:String;
		
		public function PhidgetRFIDTag(tag:String, protocol:int)
		{
			this.tagString = tag;
			this.protocol = protocol;
		}
		
		/*
			Property: Protocol
			Gets the Tag Protocol
		*/
		public function get Protocol():int{
			return protocol;
		}
		/*
			Property: Tag
			Gets the Tag string
		*/
		public function get Tag():String{
			return tagString;
		}
		
		public function toString():String{
			return tagString;
		}
	}
}