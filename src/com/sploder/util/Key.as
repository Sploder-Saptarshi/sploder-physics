package com.sploder.util
{
   import flash.display.Stage;
   import flash.events.*;
   import flash.ui.Keyboard;
   
   public class Key extends EventDispatcher
   {
      public static var stage:Stage;
      
      public static const KEY_DOWN:String = KeyboardEvent.KEY_DOWN;
      
      public static const KEY_UP:String = KeyboardEvent.KEY_UP;
      
      private static var initialized:Boolean = false;
      
      private static var keysDown:Object = {};
      
      private static var _shiftDown:Boolean = false;
      
      private static var _ctrlDown:Boolean = false;
      
      public function Key()
      {
         super();
      }
      
      public static function get TAB() : uint
      {
         return Keyboard.TAB;
      }
      
      public static function get SPACE() : uint
      {
         return Keyboard.SPACE;
      }
      
      public static function get DELETE() : uint
      {
         return Keyboard.DELETE;
      }
      
      public static function initialize(param1:Stage) : void
      {
         stage = param1;
         if(!initialized)
         {
            stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed,false,0,true);
            stage.addEventListener(KeyboardEvent.KEY_UP,keyReleased,false,0,true);
            stage.addEventListener(Event.DEACTIVATE,clearKeys,false,0,true);
            initialized = true;
         }
      }
      
      public static function isDown(param1:uint, param2:Boolean = false) : Boolean
      {
         if(!initialized)
         {
            throw new Error("Key class has yet been initialized.");
         }
         if(!param2)
         {
            if(param1 >= 97 && param1 <= 122)
            {
               param1 -= 32;
            }
         }
         return Boolean(param1 in keysDown);
      }
      
      public static function charIsDown(param1:String) : Boolean
      {
         if(!initialized)
         {
            throw new Error("Key class has yet been initialized.");
         }
         return Boolean(param1.toUpperCase().charCodeAt(0) in keysDown);
      }
      
      public static function char(param1:String) : uint
      {
         return param1.toUpperCase().charCodeAt(0);
      }
      
      public static function match(param1:int, param2:String, param3:Boolean = false) : Boolean
      {
         var _loc4_:int = 0;
         if(param3)
         {
            return param1 == param2.charCodeAt[0];
         }
         _loc4_ = param1 >= 97 && param1 <= 122 ? param1 - 32 : param1;
         return _loc4_ == param2.toUpperCase().charCodeAt(0);
      }
      
      private static function keyPressed(param1:KeyboardEvent) : void
      {
         if(param1.shiftKey)
         {
            _shiftDown = true;
         }
         if(param1.ctrlKey)
         {
            _ctrlDown = true;
         }
         keysDown[param1.keyCode] = true;
      }
      
      private static function keyReleased(param1:KeyboardEvent) : void
      {
         if(param1.keyCode in keysDown)
         {
            delete keysDown[param1.keyCode];
         }
         if(param1.keyCode == Keyboard.SHIFT)
         {
            _shiftDown = false;
         }
         else if(param1.keyCode == Keyboard.CONTROL)
         {
            _ctrlDown = false;
         }
      }
      
      private static function clearKeys(param1:Event) : void
      {
         keysDown = {};
      }
      
      public static function get shiftKey() : Boolean
      {
         return _shiftDown;
      }
      
      public static function get ctrlKey() : Boolean
      {
         return _ctrlDown;
      }
      
      public static function reset() : void
      {
         keysDown = {};
      }
   }
}

