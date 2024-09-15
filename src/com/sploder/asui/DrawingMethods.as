package com.sploder.asui
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class DrawingMethods
   {
      public function DrawingMethods()
      {
         super();
      }
      
      public static function roundedRect(param1:Sprite, param2:Boolean = true, param3:Number = 0, param4:Number = 0, param5:Number = 100, param6:Number = 100, param7:String = "0", param8:Array = null, param9:Array = null, param10:Array = null, param11:Matrix = null, param12:Number = 0, param13:Number = 0, param14:Number = 1) : void
      {
         var _loc21_:Number = NaN;
         var _loc15_:Graphics = param1.graphics;
         var _loc16_:Array = new Array();
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         var _loc20_:Number = 0;
         if(param2 != false)
         {
            _loc15_.clear();
         }
         if(param8.length < 1)
         {
            param8 = [0];
         }
         if(param9 == null)
         {
            param9 = [];
         }
         if(param9.length != param8.length)
         {
            param9 = [];
            _loc21_ = 0;
            while(_loc21_ < param8.length)
            {
               param9.push(1);
               _loc21_++;
            }
         }
         if(param10 == null)
         {
            param10 = [];
         }
         if(param10.length != param8.length)
         {
            param10 = [];
            _loc21_ = 0;
            while(_loc21_ < param8.length)
            {
               param10.push(_loc21_ / (param8.length - 1) * 255);
               _loc21_++;
            }
         }
         if(param7 == null || param7 == "")
         {
            param7 = "0";
         }
         _loc16_ = param7.split(" ");
         _loc17_ = parseInt(_loc16_[0]);
         _loc18_ = _loc16_[1] == undefined ? _loc17_ : parseInt(_loc16_[1]);
         _loc19_ = _loc16_[2] == undefined ? _loc17_ : parseInt(_loc16_[2]);
         _loc20_ = _loc16_[3] == undefined ? _loc18_ : parseInt(_loc16_[3]);
         param3 = !isNaN(param3) ? param3 : 0;
         param4 = !isNaN(param4) ? param4 : 0;
         if(isNaN(param5))
         {
            param5 = param1.width;
         }
         if(isNaN(param6))
         {
            param6 = param1.height;
         }
         if(!isNaN(param12) && param12 > 0)
         {
            if(isNaN(param13) || param13 == 0)
            {
               param13 = 0;
            }
            if(isNaN(param14) || param14 == 0)
            {
               param14 = 1;
            }
            _loc15_.lineStyle(param12,param13,param14);
         }
         if(param8.length == 1)
         {
            _loc15_.beginFill(param8[0],param9[0]);
         }
         else
         {
            if(param11 == null)
            {
               param11 = new Matrix();
               param11.createGradientBox(param5,param6,90 * (Math.PI / 180),param3,param4);
            }
            _loc15_.beginGradientFill("linear",param8,param9,param10,param11);
         }
         if(_loc17_ > 0)
         {
            _loc15_.moveTo(param3 + _loc17_,param4);
         }
         else
         {
            _loc15_.moveTo(param3,param4);
         }
         if(_loc18_ > 0)
         {
            _loc15_.lineTo(param3 + param5 - _loc18_,param4);
            _loc15_.curveTo(param3 + param5,param4,param3 + param5,param4 + _loc18_);
            _loc15_.lineTo(param3 + param5,param4 + _loc18_);
         }
         else
         {
            _loc15_.lineTo(param3 + param5,param4);
         }
         if(_loc19_ > 0)
         {
            _loc15_.lineTo(param3 + param5,param4 + param6 - _loc19_);
            _loc15_.curveTo(param3 + param5,param4 + param6,param3 + param5 - _loc19_,param4 + param6);
            _loc15_.lineTo(param3 + param5 - _loc19_,param4 + param6);
         }
         else
         {
            _loc15_.lineTo(param3 + param5,param4 + param6);
         }
         if(_loc20_ > 0)
         {
            _loc15_.lineTo(param3 + _loc20_,param4 + param6);
            _loc15_.curveTo(param3,param4 + param6,param3,param4 + param6 - _loc20_);
            _loc15_.lineTo(param3,param4 + param6 - _loc20_);
         }
         else
         {
            _loc15_.lineTo(param3,param4 + param6);
         }
         if(_loc17_ > 0)
         {
            _loc15_.lineTo(param3,param4 + _loc17_);
            _loc15_.curveTo(param3,param4,param3 + _loc17_,param4);
            _loc15_.lineTo(param3 + _loc17_,param4);
         }
         else
         {
            _loc15_.lineTo(param3,param4);
         }
         _loc15_.endFill();
      }
      
      public static function emptyRect(param1:Sprite, param2:Boolean = true, param3:Number = 0, param4:Number = 0, param5:Number = 100, param6:Number = 100, param7:Number = 0, param8:Number = 0, param9:Number = 1) : void
      {
         var _loc10_:Graphics = param1.graphics;
         if(param2 != false)
         {
            _loc10_.clear();
         }
         param3 = !isNaN(param3) ? param3 : 0;
         param4 = !isNaN(param4) ? param4 : 0;
         if(isNaN(param5))
         {
            param5 = param1.width;
         }
         if(isNaN(param6))
         {
            param6 = param1.height;
         }
         if(isNaN(param8))
         {
            param8 = 0;
         }
         if(isNaN(param9))
         {
            param9 = 1;
         }
         if(isNaN(param7))
         {
            param7 = 1;
         }
         _loc10_.beginFill(param8,param9);
         _loc10_.moveTo(param3,param4);
         _loc10_.lineTo(param3 + param5,param4);
         _loc10_.lineTo(param3 + param5,param4 + param6);
         _loc10_.lineTo(param3,param4 + param6);
         _loc10_.lineTo(param3,param4);
         _loc10_.lineTo(param3 + param7,param4 + param7);
         _loc10_.lineTo(param3 + param5 - param7,param4 + param7);
         _loc10_.lineTo(param3 + param5 - param7,param4 + param6 - param7);
         _loc10_.lineTo(param3 + param7,param4 + param6 - param7);
         _loc10_.lineTo(param3 + param7,param4 + param7);
         _loc10_.endFill();
      }
      
      public static function rect(param1:Sprite, param2:Boolean = true, param3:Number = 0, param4:Number = 0, param5:Number = 100, param6:Number = 100, param7:Number = 0, param8:Number = 1) : void
      {
         var _loc9_:Graphics = param1.graphics;
         if(param2 != false)
         {
            _loc9_.clear();
         }
         param3 = !isNaN(param3) ? param3 : 0;
         param4 = !isNaN(param4) ? param4 : 0;
         if(isNaN(param5))
         {
            param5 = param1.width;
         }
         if(isNaN(param6))
         {
            param6 = param1.height;
         }
         if(isNaN(param7))
         {
            param7 = 0;
         }
         if(isNaN(param8))
         {
            param8 = 100;
         }
         _loc9_.beginFill(param7,param8);
         _loc9_.moveTo(param3,param4);
         _loc9_.lineTo(param3 + param5,param4);
         _loc9_.lineTo(param3 + param5,param4 + param6);
         _loc9_.lineTo(param3,param4 + param6);
         _loc9_.lineTo(param3,param4);
         _loc9_.endFill();
      }
      
      public static function circle(param1:Sprite, param2:Boolean = true, param3:Number = 0, param4:Number = 0, param5:Number = 10, param6:Number = 1, param7:Number = 0, param8:Number = 1, param9:Number = 0, param10:Number = 0, param11:Number = 1) : void
      {
         var _loc12_:Graphics = param1.graphics;
         if(param2 != false)
         {
            _loc12_.clear();
         }
         if(param5 == 0 || isNaN(param5))
         {
            return;
         }
         if(isNaN(param7))
         {
            param7 = 0;
         }
         if(isNaN(param8))
         {
            param8 = 100;
         }
         if(isNaN(param10))
         {
            param10 = 0;
         }
         if(isNaN(param9))
         {
            param9 = 0;
         }
         if(param9 > 0)
         {
            _loc12_.lineStyle(param9,param10,100);
         }
         else
         {
            _loc12_.lineStyle();
         }
         _loc12_.beginFill(param7,param8);
         _loc12_.drawCircle(param3,param4,param5);
         _loc12_.endFill();
      }
   }
}

