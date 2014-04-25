package com.phidgets
{
	import com.phidgets.events.PhidgetDataEvent;
	
	/*
		Class: PhidgetTextLCD
		A class for controlling a PhidgetTextLCD.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
	public class PhidgetTextLCD extends Phidget
	{
		private var numScreens:int;
		private var numRows:Array;
		private var numColumns:Array;
		private var backlight:Array;
		private var cursorOn:Array;
		private var cursorBlink:Array;
		private var contrast:Array;
		private var brightness:Array;
		private var init:Array;
		private var screenSize:Array;
		
		private var currentScreen:int;
		
		/*
			Constants: Screen Sizes
			These are the Screen sizes supported by the various PhidgetTextLCDs. These constants are used with <getScreenSize> and <setScreenSize>.
			
			PHIDGET_TEXTLCD_SCREEN_NONE - no screen attached
			PHIDGET_TEXTLCD_SCREEN_1x8 - 1 row, 8 column screen
			PHIDGET_TEXTLCD_SCREEN_2x8 - 2 row, 8 column screen
			PHIDGET_TEXTLCD_SCREEN_1x16 - 1 row, 16 column screen
			PHIDGET_TEXTLCD_SCREEN_2x16 - 2 row, 16 column screen
			PHIDGET_TEXTLCD_SCREEN_4x16 - 4 row, 16 column screen
			PHIDGET_TEXTLCD_SCREEN_2x20 - 2 row, 20 column screen
			PHIDGET_TEXTLCD_SCREEN_4x20 - 4 row, 20 column screen
			PHIDGET_TEXTLCD_SCREEN_2x24 - 2 row, 24 column screen
			PHIDGET_TEXTLCD_SCREEN_1x40 - 1 row, 40 column screen
			PHIDGET_TEXTLCD_SCREEN_2x40 - 2 row, 40 column screen
			PHIDGET_TEXTLCD_SCREEN_4x40 - 4 row, 40 column screen (special case, requires both screen connections)
			PHIDGET_TEXTLCD_SCREEN_UNKNOWN - Screen size is unknown
		*/
		public static const PHIDGET_TEXTLCD_SCREEN_NONE:int = 1;
		public static const PHIDGET_TEXTLCD_SCREEN_1x8:int = 2;
		public static const PHIDGET_TEXTLCD_SCREEN_2x8:int = 3;
		public static const PHIDGET_TEXTLCD_SCREEN_1x16:int = 4;
		public static const PHIDGET_TEXTLCD_SCREEN_2x16:int = 5;
		public static const PHIDGET_TEXTLCD_SCREEN_4x16:int = 6;
		public static const PHIDGET_TEXTLCD_SCREEN_2x20:int = 7;
		public static const PHIDGET_TEXTLCD_SCREEN_4x20:int = 8;
		public static const PHIDGET_TEXTLCD_SCREEN_2x24:int = 9;
		public static const PHIDGET_TEXTLCD_SCREEN_1x40:int = 10;
		public static const PHIDGET_TEXTLCD_SCREEN_2x40:int = 11;
		public static const PHIDGET_TEXTLCD_SCREEN_4x40:int = 12;
		public static const PHIDGET_TEXTLCD_SCREEN_UNKNOWN:int = 13;
		
		public function PhidgetTextLCD(){
			super("PhidgetTextLCD");
		}
		
		override protected function initVars():void{
			currentScreen = 0;
			
			numScreens = com.phidgets.Constants.PUNK_INT;
			numColumns = new Array(2);
			numRows = new Array(2);
			backlight = new Array(2);
			cursorOn = new Array(2);
			cursorBlink = new Array(2);
			contrast = new Array(2);
			brightness = new Array(2);
			init = new Array(2);
			init[0]=0; init[1]=0;
			screenSize = new Array(2);
		}
		
		override protected function onSpecificPhidgetData(setThing:String, index:int, value:String):void{
			switch(setThing)
			{
				case "NumberOfScreens":
					numScreens = int(value);
					keyCount++;
					break;
				case "NumberOfRows":
					if(numRows[index] == undefined)
						keyCount++;
					numRows[index] = int(value);
					break;
				case "NumberOfColumns":
					if(numColumns[index] == undefined)
						keyCount++;
					numColumns[index] = int(value);
					break;
				case "Backlight":
					if(backlight[index] == undefined)
						keyCount++;
					backlight[index] = int(value);
					break;
				case "CursorOn":
					cursorOn[index] = int(value);
					break;
				case "CursorBlink":
					cursorBlink[index] = int(value);
					break;
				case "Contrast":
					if(contrast[index] == undefined)
						keyCount++;
					contrast[index] = int(value);
					break;
				case "Brightness":
					if(brightness[index] == undefined)
						keyCount++;
					brightness[index] = int(value);
					break;
				case "ScreenSize":
					if(screenSize[index] == undefined)
						keyCount++;
					screenSize[index] = int(value);
					break;
			}
		}
		
		//Getters
		/*
			Property: ScreenCount
			Gets the number of screens available on the LCD.
		*/
		public function get ScreenCount():int{
			if(numScreens == com.phidgets.Constants.PUNK_INT)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
			return numScreens;
		}
		/*
			Property: RowCount
			Gets the number of rows available on the LCD.
		*/
		public function get RowCount():int{
			return int(indexArray(numRows, currentScreen, numScreens, com.phidgets.Constants.PUNK_INT));
		}
		/*
			Property: ColumnCount
			Gets the number of columns available per row on the LCD.
		*/
		public function get ColumnCount():int{
			return int(indexArray(numColumns, currentScreen, numScreens, com.phidgets.Constants.PUNK_INT));
		}
		/*
			Property: Backlight
			Gets tha state of the backlight.
		*/
		public function get Backlight():Boolean{
			return intToBool(int(indexArray(backlight, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Property: Cursor
			Gets the visible state of the cursor.
		*/
		public function get Cursor():Boolean{
			return intToBool(int(indexArray(cursorOn, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Property: CursorBlink
			Gets the blinking state of the cursor.
		*/
		public function get CursorBlink():Boolean{
			return intToBool(int(indexArray(cursorBlink, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL)));
		}
		/*
			Property: Contrast
			Gets the last set contrast value.
		*/
		public function get Contrast():int{
			return int(indexArray(contrast, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL));
		}
		/*
			Property: Brightness
			Gets the last set brightness value.
		*/
		public function get Brightness():int{
			return int(indexArray(brightness, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL));
		}
		/*
			Property: ScreenSize
			Gets the screen size.
		*/
		public function get ScreenSize():int{
			return int(indexArray(screenSize, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL));
		}
		/*
			Property: Screen
			Gets the active screen. This is the screen that will respond to all commands.
		*/
		public function get Screen():int{
			return currentScreen;
		}
		
		//Setters
		/*
			Property: Backlight
			Sets the backlight state.
			
			Parameters:
				val - backlight state
		*/
		public function set Backlight(val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Backlight", currentScreen, numScreens), boolToInt(val).toString(), true);
		}
		/*
			Property: Cursor
			Sets the cursor (visible) state.
			
			Parameters:
				val - cursor state
		*/
		public function set Cursor(val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("CursorOn", currentScreen, numScreens), boolToInt(val).toString(), true);
		}
		/*
			Property: CursorBlink
			Sets the cursor blink state.
			
			Parameters:
				val - cursor blink state
		*/
		public function set CursorBlink(val:Boolean):void{ 
			_phidgetSocket.setKey(makeIndexedKey("CursorBlink", currentScreen, numScreens), boolToInt(val).toString(), true);
		}
		/*
			Property: Contrast
			Sets the contrast (0-255).
			
			Parameters:
				val - contrast
		*/
		public function set Contrast(val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Contrast", currentScreen, numScreens), val.toString(), true);
		}
		/*
			Property: Brightness
			Sets the brightness of the backlight (0-255).
			
			Parameters:
				val - brightness
		*/
		public function set Brightness(val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("Brightness", currentScreen, numScreens), val.toString(), true);
		}
		/*
			Property: ScreenSize
			Sets the screen size. Choose from one of the defined screen size constants.
			Note that not all PhidgetTextLCDs support setting screen size.
			
			Parameters:
				val - screen size
		*/
		public function set ScreenSize(val:int):void{ 
			_phidgetSocket.setKey(makeIndexedKey("ScreenSize", currentScreen, numScreens), val.toString(), true);
		}
		/*
			Property: Screen
			Sets the active screen. This is the screen that subsequent commands will target.
			
			Parameters:
				val - screen
		*/
		public function set Screen(val:int):void{ 
			if(val >= numScreens || val < 0)
				throw new PhidgetError(com.phidgets.Constants.EPHIDGET_OUTOFBOUNDS);
			currentScreen = val;
		}
		/*
			Function: setDisplayString
			Sets the display string for a row.
			
			Parameters:
				index - row
				val - display string
		*/
		public function setDisplayString(index:int, val:String):void{ 
			var ind:int = (index << 8) + currentScreen;
			_phidgetSocket.setKey(makeIndexedKey("DisplayString", ind, 0xffff), val, true);
		}
		/*
			Function: setDisplayCharacter
			Sets the character at a row and column. Send a one character string.
			
			Parameters:
				row - row
				column - column
				val - character
		*/
		public function setDisplayCharacter(row:int, column:int, val:String):void{ 
			var index:int = (column << 16) + (row << 8) + currentScreen;
			_phidgetSocket.setKey(makeIndexedKey("DisplayCharacter", index, 0xffffff), val, true);
		}
		/*
			Function: setCustomCharacter
			Creates a custom character. See the product manual for more information.
			
			Parameters:
				index - character index (8-15)
				val1 - character data 1
				val2 - character data 2
		*/
		public function setCustomCharacter(index:int, val1:int, val2:int):void {
			var ind:int = (index << 8) + currentScreen;
			var key:String = makeIndexedKey("CustomCharacter", ind, 0xffff);
			if(index < 8) throw new PhidgetError(com.phidgets.Constants.EPHIDGET_OUTOFBOUNDS);
			var val:String = val1+","+val2;
			_phidgetSocket.setKey(key, val, true);
		}
		/*
			Function: initialize
			Initializes a screen. This should be called after setting the screen size.
		*/
		public function initialize():void{ 
			init[currentScreen] ^= 1;
			_phidgetSocket.setKey(makeIndexedKey("Init", currentScreen, numScreens), init[currentScreen].toString(), true);
		}
	}
}