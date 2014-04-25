package com.phidgets
{
	/*
		Class: Constants
	*/
	public class Constants
	{
		
		/*
			Constants: Error Codes
			Error codes that can show up in <PhidgetError> exceptions.
			
			EPHIDGET_UNEXPECTED	- unknown error occured
			EPHIDGET_INVALIDARG	- invalid argument passed to function
			EPHIDGET_UNKNOWNVAL	- state not yet recieved from device
			EPHIDGET_UNSUPPORTED	- function not supported for this device, or not yet implemented
			EPHIDGET_OUTOFBOUNDS	- tried to index past the end of an array
			
		*/
		public static const EPHIDGET_UNEXPECTED:int = 				3
		public static const EPHIDGET_INVALIDARG:int = 				4
		public static const EPHIDGET_UNKNOWNVAL:int = 				9
		public static const EPHIDGET_UNSUPPORTED:int = 				11
		public static const EPHIDGET_OUTOFBOUNDS:int = 				14
		
		/*
			Constants: Error Event Codes
			Error event codes that can show up in <PhidgetErrorEvent.ERROR> events.
			
			Networks related errors:
			
			EPHIDGET_NETWORK	- network error
			EPHIDGET_BADPASSWORD	- wrong password specified
			EPHIDGET_NETWORK_NOTCONNECTED	- not connected error
			EPHIDGET_BADVERSION	- webservice and client version mismatch
			
			Phidget related errors:
			
			EEPHIDGET_OK	- An error state has ended - see description for details.
			EEPHIDGET_OVERRUN	- A sampling overrun happend in firmware.
			EEPHIDGET_PACKETLOST	- One or more packets were lost.
			EEPHIDGET_WRAP	- A variable has wrapped around.
			EEPHIDGET_OVERTEMP	- Overtemperature condition detected.
			EEPHIDGET_OVERCURRENT	- Overcurrent condition detected.
			EEPHIDGET_OUTOFRANGE	- Out of range condition detected.
			EEPHIDGET_BADPOWER	- Power supply problem detected.
		*/
		public static const EPHIDGET_NETWORK:int = 					8
		public static const EPHIDGET_BADPASSWORD:int = 				10
		public static const EPHIDGET_NETWORK_NOTCONNECTED:int = 	16
		public static const EPHIDGET_BADVERSION:int = 				19
		
		public static const EEPHIDGET_OK:int = 						0x9000
		public static const EEPHIDGET_OVERRUN:int = 				0x9002
		public static const EEPHIDGET_PACKETLOST:int = 				0x9003
		public static const EEPHIDGET_WRAP:int = 					0x9004
		public static const EEPHIDGET_OVERTEMP:int = 				0x9005
		public static const EEPHIDGET_OVERCURRENT:int = 			0x9006
		public static const EEPHIDGET_OUTOFRANGE:int = 				0x9007
		public static const EEPHIDGET_BADPOWER:int = 				0x9008
		
		public static const PFALSE:int = 								0x00
		public static const PTRUE:int = 								0x01
		
		public static const PUNK_BOOL:int = 							0x02
		public static const PUNK_INT:int = 								0x7FFFFFFF
		public static const PUNK_NUM:Number = 							1e+300
		
		public static const PUNI_BOOL:int = 							0x03
		public static const PUNI_INT:int = 								0x7FFFFFFE
		public static const PUNI_NUM:Number = 							1e+250
		
		public static const Phid_ErrorDescriptions:Array = [,,,
		"Unexpected Error.  Contact Phidgets Inc. for support.",
		"Invalid argument passed to function.",,,,
		"Network Error.",
		"Value is Unknown (State not yet received from device).",
		"Authorization Failed.",
		"Not Supported",,,
		"Index out of Bounds",,
		"A connection to the server does not exist.",,,
		"Webservice and Client protocol versions don't match. Update both to newest release."];
		
		/* This needs to match the CPhidget_DeviceID enum in phidget21 C library */
		public static const Phid_DeviceSpecificName:Object = {
		/* These are all current devices */
		126:	"Phidget Accelerometer 3-axis",
		130:	"Phidget Advanced Servo Controller 1-motor",
		58:		"Phidget Advanced Servo Controller 8-motor",
		55:		"Phidget Analog 4-output",
		123:	"Phidget Bipolar Stepper Controller 1-motor",
		59:		"Phidget Bridge 4-input",
		75:		"Phidget Encoder 1-encoder 1-input",
		128:	"Phidget High Speed Encoder 1-encoder",
		79:		"Phidget High Speed Encoder 4-input",
		53:		"Phidget Frequency Counter 2-input",
		121:	"Phidget GPS",
		64:		"Phidget InterfaceKit 0/0/4",
		129:	"Phidget InterfaceKit 0/0/8",
		68:		"Phidget InterfaceKit 0/16/16",
		54:		"Phidget InterfaceKit 2/2/2",
		69:		"Phidget InterfaceKit 8/8/8",
		125:	"Phidget InterfaceKit 8/8/8",
		77:		"Phidget IR Receiver Transmitter",
		76:		"Phidget LED 64 Advanced",
		118:	"Phidget Touch Slider",
		62:		"Phidget Motor Controller 1-motor",
		89:		"Phidget High Current Motor Controller 2-motor",
		49:		"Phidget RFID 2-output",
		52:		"Phidget RFID Read-Write",
		119:	"Phidget Touch Rotation",
		127:	"Phidget Spatial 0/0/3",
		51:		"Phidget Spatial 3/3/3",
		112:	"Phidget Temperature Sensor",
		50:		"Phidget Temperature Sensor 4-input",
		60:		"Phidget Temperature Sensor IR",
		381:	"Phidget TextLCD",
		61:		"Phidget TextLCD Adapter",
		122:	"Phidget Unipolar Stepper Controller 4-motor",
		
		/* These are all past devices (no longer sold) */
		113:	"Phidget Accelerometer 2-axis",
		83:		"Phidget InterfaceKit 0/8/8",
		4:		"Phidget InterfaceKit 4/8/8",
		74:		"Phidget LED 64",
		88:		"Phidget Low Voltage Motor Controller 2-motor 4-input",
		116:	"Phidget PH Sensor",
		48:		"Phidget RFID",
		2:		"Phidget Servo Controller 1-motor",
		56:		"Phidget Servo Controller 4-motor",
		57:		"Phidget Servo Controller 1-motor",
		3:		"Phidget Servo Controller 4-motor",
		82:		"Phidget TextLCD",
		339:	"Phidget TextLCD",
		72:		"Phidget TextLED 4x8",
		73:		"Phidget TextLED 1x8",
		114:	"Phidget Weight Sensor",
		
		/* Nothing device */
		1:		"Uninitialized Phidget Handle",
		
		/* never released to general public */
		81:		"Phidget InterfaceKit 0/5/7",
		337:	"Phidget TextLCD Custom",
		5:		"Phidget InterfaceKit 2/8/8",
		
		/* These are unreleased or prototype devices */
		
		/* This is for internal prototyping */
		153:	"Phidget Generic Device" };
		
		//Socket Server Constants
		//Commands
		public static const NULL_CMD:String = "need nulls";
		public static const LISTEN_CMD:String = "listen";
		public static const IGNORE_CMD:String = "ignore";
		public static const REPORT_CMD:String = "report";
		public static const WAIT_CMD:String = "wait";
		public static const FLUSH_CMD:String = "flush";
		public static const WALK_CMD:String = "walk";
		public static const QUIT_CMD:String = "quit";
		public static const GET_CMD:String = "get";
		public static const SET_CMD:String = "set";
		//responses
		public static const SUCCESS_200_RESP:String = "2";
		public static const FAILURE_300_RESP:String = "3";
		public static const FAILURE_400_RESP:String = "4";
		public static const FAILURE_500_RESP:String = "5";
		public static const AUTHENTICATE_900_RESP:String = "9";
		
		public static const OK_PENDING_RESP:String = "200-";
		public static const OK_RESP:String  = "200 ";
		
		//Listen key change reasons
		public static const VALUE_CHANGED:int = 1;
		public static const ENTRY_ADDED:int = 2;
		public static const ENTRY_REMOVING:int = 3;
		public static const CURRENT_VALUE:int = 4;
		
		//open types
		public static const PHIDGETOPEN_ANY:int = 0;
		public static const PHIDGETOPEN_SERIAL:int = 1;
		public static const PHIDGETOPEN_ANY_ATTACHED:int = 2;
		public static const PHIDGETOPEN_LABEL:int = 4;
	}
}