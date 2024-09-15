package com.sploder.builder
{
   import com.sploder.util.PM_PRNG;
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.JointStyle;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class Shapes
   {
      public static var origin:Point;
      
      public function Shapes()
      {
         super();
      }
      
      public static function drawShape(param1:Graphics, param2:Vector.<Point>, param3:Point = null, param4:uint = 0, param5:Number = 1, param6:Number = NaN, param7:uint = 0, param8:Number = 0, param9:Boolean = true, param10:Boolean = false) : void
      {
         var _loc11_:Point = null;
         var _loc12_:int = 0;
         if(param3 == null)
         {
            if(origin == null)
            {
               origin = new Point();
            }
            param3 = origin;
         }
         if(param1 && param2 && param2.length > 0)
         {
            if(param9)
            {
               param1.clear();
            }
            param1.beginFill(param4,param5);
            if(param10)
            {
               param1.lineStyle(param6,param7,param8,true,"normal",CapsStyle.SQUARE,JointStyle.MITER);
            }
            else
            {
               param1.lineStyle(param6,param7,param8);
            }
            _loc12_ = 0;
            _loc11_ = param2[_loc12_];
            param1.moveTo(_loc11_.x + param3.x,_loc11_.y + param3.y);
            _loc12_ = 1;
            while(_loc12_ < param2.length)
            {
               _loc11_ = param2[_loc12_];
               param1.lineTo(_loc11_.x + param3.x,_loc11_.y + param3.y);
               _loc12_++;
            }
            param1.endFill();
         }
      }
      
      public static function drawTexture(param1:Graphics, param2:Vector.<Point>, param3:BitmapData, param4:Matrix, param5:Point = null, param6:Boolean = false) : void
      {
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         if(param5 == null)
         {
            if(origin == null)
            {
               origin = new Point();
            }
            param5 = origin;
         }
         if(param1 && param2 && param2.length > 0)
         {
            param1.beginBitmapFill(param3,param4,true,param6);
            _loc8_ = 0;
            _loc7_ = param2[_loc8_];
            param1.moveTo(_loc7_.x + param5.x,_loc7_.y + param5.y);
            _loc8_ = 1;
            while(_loc8_ < param2.length)
            {
               _loc7_ = param2[_loc8_];
               param1.lineTo(_loc7_.x + param5.x,_loc7_.y + param5.y);
               _loc8_++;
            }
            param1.endFill();
         }
      }
      
      public static function drawCircle(param1:Graphics, param2:Number, param3:Point = null, param4:uint = 0, param5:Number = 1, param6:Number = NaN, param7:uint = 0, param8:Number = 0, param9:Boolean = true) : void
      {
         if(param3 == null)
         {
            if(origin == null)
            {
               origin = new Point();
            }
            param3 = origin;
         }
         if(param9)
         {
            param1.clear();
         }
         param1.beginFill(param4,param5);
         param1.lineStyle(param6,param7,param8);
         param1.drawCircle(param3.x,param3.y,param2);
         param1.endFill();
      }
      
      public static function getVertices(param1:String, param2:Number, param3:Number, param4:Number = 0, param5:Number = 0, param6:uint = 1) : Vector.<Point>
      {
         var _loc12_:uint = 0;
         var _loc7_:Vector.<Point> = new Vector.<Point>();
         var _loc8_:int = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = Math.max(param2,param3) / 2;
         var _loc11_:Number = 0;
         switch(param1)
         {
            case CreatorUIStates.SHAPE_SQUARE:
            case CreatorUIStates.SHAPE_BOX:
               _loc7_.push(new Point(0 - param2 / 2,0 - param3 / 2));
               _loc7_.push(new Point(param2 / 2,0 - param3 / 2));
               _loc7_.push(new Point(param2 / 2,param3 / 2));
               _loc7_.push(new Point(0 - param2 / 2,param3 / 2));
               break;
            case CreatorUIStates.SHAPE_RAMP:
               _loc7_.push(new Point(param2 / 2,0 - param3 / 2));
               _loc7_.push(new Point(param2 / 2,param3 / 2));
               _loc7_.push(new Point(0 - param2 / 2,param3 / 2));
               break;
            case CreatorUIStates.SHAPE_CIRCLE:
               if(_loc10_ > 80)
               {
                  _loc8_ = 36;
               }
               else if(_loc10_ > 40)
               {
                  _loc8_ = 24;
               }
               else if(_loc10_ > 20)
               {
                  _loc8_ = 18;
               }
               else
               {
                  _loc8_ = 12;
               }
            case CreatorUIStates.SHAPE_HEX:
               if(_loc8_ == 0)
               {
                  _loc8_ = 6;
               }
            case CreatorUIStates.SHAPE_PENT:
               if(_loc8_ == 0)
               {
                  _loc8_ = 5;
               }
               _loc9_ = 0;
               _loc11_ = Math.PI * 2 / _loc8_;
               _loc12_ = 0;
               while(_loc12_ <= _loc8_)
               {
                  _loc7_.push(new Point(_loc10_ * Math.cos(_loc9_ + _loc11_ * _loc12_),_loc10_ * Math.sin(_loc9_ + _loc11_ * _loc12_)));
                  _loc12_++;
               }
         }
         if(param4 > 0 || param5 > 0)
         {
            _loc7_ = tesselate(_loc7_,param4,param5,param6);
            if(param1 == CreatorUIStates.SHAPE_CIRCLE)
            {
               _loc7_.pop();
            }
         }
         return _loc7_;
      }
      
      public static function tesselate(param1:Vector.<Point>, param2:Number = 0, param3:Number = 0, param4:uint = 1) : Vector.<Point>
      {
         var _loc5_:Vector.<Point> = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc13_:Point = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:PM_PRNG = null;
         _loc5_ = param1.concat();
         var _loc12_:Number = param2 * param2;
         if(_loc5_.length > 2 && param2 > 0)
         {
            _loc6_ = int(_loc5_.length);
            _loc7_ = _loc5_[0].x;
            _loc8_ = _loc5_[0].y;
            while(_loc6_--)
            {
               _loc9_ = _loc7_ - _loc5_[_loc6_].x;
               _loc10_ = _loc8_ - _loc5_[_loc6_].y;
               _loc11_ = _loc9_ * _loc9_ + _loc10_ * _loc10_;
               while(_loc11_ > _loc12_)
               {
                  _loc13_ = new Point(_loc5_[_loc6_].x + _loc9_ * 0.5,_loc5_[_loc6_].y + _loc10_ * 0.5);
                  _loc5_.splice(_loc6_ + 1,0,_loc13_);
                  _loc6_ += 1;
                  _loc9_ *= 0.5;
                  _loc10_ *= 0.5;
                  _loc11_ = _loc9_ * _loc9_ + _loc10_ * _loc10_;
               }
               _loc7_ = _loc5_[_loc6_].x;
               _loc8_ = _loc5_[_loc6_].y;
            }
         }
         if(param3 > 0)
         {
            _loc6_ = int(_loc5_.length);
            _loc14_ = 10000;
            _loc15_ = -10000;
            _loc16_ = 10000;
            _loc17_ = -10000;
            while(_loc6_--)
            {
               _loc14_ = Math.min(_loc14_,_loc5_[_loc6_].x);
               _loc15_ = Math.max(_loc15_,_loc5_[_loc6_].x);
               _loc16_ = Math.min(_loc16_,_loc5_[_loc6_].y);
               _loc17_ = Math.max(_loc17_,_loc5_[_loc6_].y);
            }
            _loc18_ = _loc15_ - _loc14_;
            _loc19_ = _loc17_ - _loc16_;
            _loc20_ = Math.min(_loc18_,_loc19_);
            if(_loc20_ < param3 * 20)
            {
               param3 /= _loc20_ / 20;
            }
            _loc6_ = int(_loc5_.length);
            (_loc21_ = new PM_PRNG()).seed = param4;
            while(_loc6_--)
            {
               _loc5_[_loc6_].x += _loc21_.nextDouble() * param3 - param3 * 0.5;
               _loc5_[_loc6_].y += _loc21_.nextDouble() * param3 - param3 * 0.5;
            }
         }
         return _loc5_;
      }
   }
}

