package com.sploder.asui
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   
   public class ColorTools
   {
      public function ColorTools()
      {
         super();
      }
      
      public static function getRedComponent(param1:Number) : Number
      {
         return param1 >> 16;
      }
      
      public static function getGreenComponent(param1:Number) : Number
      {
         return param1 >> 8 & 0xFF;
      }
      
      public static function getBlueComponent(param1:Number) : Number
      {
         return param1 & 0xFF;
      }
      
      public static function getRedOffset(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = getRedComponent(param1);
         return _loc3_ * param2;
      }
      
      public static function getGreenOffset(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = getGreenComponent(param1);
         return _loc3_ * param2;
      }
      
      public static function getBlueOffset(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = getBlueComponent(param1);
         return _loc3_ * param2;
      }
      
      public static function getTintedColor(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = getRedComponent(param1);
         var _loc5_:Number = getGreenComponent(param1);
         var _loc6_:Number = getBlueComponent(param1);
         var _loc7_:Number = getRedComponent(param2);
         var _loc8_:Number = getGreenComponent(param2);
         var _loc9_:Number = getBlueComponent(param2);
         return _loc4_ + (_loc7_ - _loc4_) * param3 << 16 | _loc5_ + (_loc8_ - _loc5_) * param3 << 8 | _loc6_ + (_loc9_ - _loc6_) * param3;
      }
      
      public static function getInverseColor(param1:Number) : Number
      {
         var _loc2_:Number = getRedComponent(param1);
         var _loc3_:Number = getGreenComponent(param1);
         var _loc4_:Number = getBlueComponent(param1);
         return 255 - _loc2_ << 16 | 255 - _loc3_ << 8 | 255 - _loc4_;
      }
      
      public static function getBrightness(param1:Number) : Number
      {
         var _loc2_:Number = getRedComponent(param1);
         var _loc3_:Number = getGreenComponent(param1);
         var _loc4_:Number = getBlueComponent(param1);
         return Math.floor((_loc2_ + _loc3_ + _loc4_) / 3);
      }
      
      public static function getSaturatedColor(param1:Number, param2:Number) : Number
      {
         param2 /= 100;
         var _loc3_:Number = getRedComponent(param1) / 255;
         var _loc4_:Number = getGreenComponent(param1) / 255;
         var _loc5_:Number = getBlueComponent(param1) / 255;
         var _loc6_:Number = interpolate(0.5,_loc3_,param2) * 255;
         var _loc7_:Number = interpolate(0.5,_loc4_,param2) * 255;
         var _loc8_:Number = interpolate(0.5,_loc5_,param2) * 255;
         return _loc6_ << 16 | _loc7_ << 8 | _loc8_;
      }
      
      public static function getDesaturatedColor(param1:Number) : Number
      {
         var _loc2_:Number = getRedComponent(param1) / 255;
         var _loc3_:Number = getGreenComponent(param1) / 255;
         var _loc4_:Number = getBlueComponent(param1) / 255;
         var _loc5_:Number = (_loc2_ + _loc3_ + _loc4_ / 3) * 255;
         return _loc5_ << 16 | _loc5_ << 8 | _loc5_;
      }
      
      private static function interpolate(param1:Number, param2:Number, param3:Number) : Number
      {
         return Math.min(1,Math.max(0,param1 + (param2 - param1) * param3));
      }
      
      public static function numberToHTMLColor(param1:Number) : String
      {
         var _loc2_:String = param1.toString(16);
         while(_loc2_.length < 6)
         {
            _loc2_ = "0" + _loc2_;
         }
         return "#" + _loc2_;
      }
      
      public static function HTMLColorToNumber(param1:String) : Number
      {
         return parseInt("0x" + param1.split("#").join("").split("0x").join(""),16);
      }
      
      public static function rgb2hex(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 << 16 | param2 << 8 | param3;
      }
      
      public static function hex2rgb(param1:Number) : Object
      {
         var _loc2_:* = param1 >> 16;
         var _loc3_:int = param1 - (_loc2_ << 16);
         var _loc4_:* = _loc3_ >> 8;
         var _loc5_:int = _loc3_ - (_loc4_ << 8);
         return {
            "r":_loc2_,
            "g":_loc4_,
            "b":_loc5_
         };
      }
      
      public static function hex2hsv(param1:Number) : Object
      {
         var _loc2_:Object = hex2rgb(param1);
         return rgb2hsv(_loc2_.r,_loc2_.g,_loc2_.b);
      }
      
      public static function hsv2hex(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Object = hsv2rgb(param1,param2,param3);
         return rgb2hex(_loc4_.r,_loc4_.g,_loc4_.b);
      }
      
      public static function hsv2rgb(param1:Number, param2:Number, param3:Number) : Object
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         param1 %= 360;
         if(param3 == 0)
         {
            return {
               "r":0,
               "g":0,
               "b":0
            };
         }
         param2 /= 100;
         param3 /= 100;
         param1 /= 60;
         _loc7_ = Math.floor(param1);
         _loc8_ = param1 - _loc7_;
         _loc9_ = param3 * (1 - param2);
         _loc10_ = param3 * (1 - param2 * _loc8_);
         _loc11_ = param3 * (1 - param2 * (1 - _loc8_));
         if(_loc7_ == 0)
         {
            _loc4_ = param3;
            _loc5_ = _loc11_;
            _loc6_ = _loc9_;
         }
         else if(_loc7_ == 1)
         {
            _loc4_ = _loc10_;
            _loc5_ = param3;
            _loc6_ = _loc9_;
         }
         else if(_loc7_ == 2)
         {
            _loc4_ = _loc9_;
            _loc5_ = param3;
            _loc6_ = _loc11_;
         }
         else if(_loc7_ == 3)
         {
            _loc4_ = _loc9_;
            _loc5_ = _loc10_;
            _loc6_ = param3;
         }
         else if(_loc7_ == 4)
         {
            _loc4_ = _loc11_;
            _loc5_ = _loc9_;
            _loc6_ = param3;
         }
         else if(_loc7_ == 5)
         {
            _loc4_ = param3;
            _loc5_ = _loc9_;
            _loc6_ = _loc10_;
         }
         _loc4_ = Math.floor(_loc4_ * 255);
         _loc5_ = Math.floor(_loc5_ * 255);
         _loc6_ = Math.floor(_loc6_ * 255);
         return {
            "r":_loc4_,
            "g":_loc5_,
            "b":_loc6_
         };
      }
      
      public static function rgb2hsv(param1:Number, param2:Number, param3:Number) : Object
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         param1 /= 255;
         param2 /= 255;
         param3 /= 255;
         _loc4_ = Math.min(Math.min(param1,param2),param3);
         _loc9_ = Math.max(Math.max(param1,param2),param3);
         if(_loc4_ == _loc9_)
         {
            return {
               "h":0,
               "s":0,
               "v":_loc9_ * 100
            };
         }
         _loc5_ = param1 == _loc4_ ? param2 - param3 : (param2 == _loc4_ ? param3 - param1 : param1 - param2);
         _loc6_ = param1 == _loc4_ ? 3 : (param2 == _loc4_ ? 5 : 1);
         _loc7_ = Math.floor((_loc6_ - _loc5_ / (_loc9_ - _loc4_)) * 60) % 360;
         _loc8_ = Math.floor((_loc9_ - _loc4_) / _loc9_ * 100);
         _loc9_ = Math.floor(_loc9_ * 100);
         return {
            "h":_loc7_,
            "s":_loc8_,
            "v":_loc9_
         };
      }
      
      public static function setColorValue(param1:Number, param2:int = 50) : Number
      {
         var _loc3_:Number = getRedComponent(param1);
         var _loc4_:Number = getGreenComponent(param1);
         var _loc5_:Number = getBlueComponent(param1);
         var _loc6_:Object = rgb2hsv(_loc3_,_loc4_,_loc5_);
         var _loc7_:Object = hsv2rgb(_loc6_.h,_loc6_.s,param2);
         return _loc7_.r << 16 | _loc7_.g << 8 | _loc7_.b;
      }
      
      public static function getHue(param1:Number) : Number
      {
         var _loc2_:Number = getRedComponent(param1);
         var _loc3_:Number = getGreenComponent(param1);
         var _loc4_:Number = getBlueComponent(param1);
         return rgb2hsv(_loc2_,_loc3_,_loc4_).h;
      }
      
      public static function getSaturation(param1:Number) : Number
      {
         var _loc2_:Number = getRedComponent(param1);
         var _loc3_:Number = getGreenComponent(param1);
         var _loc4_:Number = getBlueComponent(param1);
         return rgb2hsv(_loc2_,_loc3_,_loc4_).s;
      }
      
      public static function getValue(param1:Number) : Number
      {
         var _loc2_:Number = getRedComponent(param1);
         var _loc3_:Number = getGreenComponent(param1);
         var _loc4_:Number = getBlueComponent(param1);
         return rgb2hsv(_loc2_,_loc3_,_loc4_).v;
      }
      
      public static function applyColor(param1:DisplayObject, param2:Number) : void
      {
         var _loc3_:ColorTransform = null;
         if(param1 != null)
         {
            _loc3_ = new ColorTransform();
            _loc3_.color = param2;
            param1.transform.colorTransform = _loc3_;
         }
      }
   }
}

