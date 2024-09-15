package com.sploder.util
{
   import flash.geom.Point;
   
   public class Geom2d
   {
      public static const PI:Number = Math.PI;
      
      public static const TWOPI:Number = Math.PI * 2;
      
      public static const HALFPI:Number = Math.PI * 0.5;
      
      public static const QUARTERPI:Number = Math.PI * 0.25;
      
      private static var _dtr:Number = Math.PI / 180;
      
      private static var _rtd:Number = 180 / Math.PI;
      
      public function Geom2d()
      {
         super();
      }
      
      public static function angleBetween(param1:Point, param2:Point) : Number
      {
         var _loc3_:Number = Math.atan2(param2.y - param1.y,param2.x - param1.x);
         if(_loc3_ < 0.0001 && _loc3_ > -0.0001)
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public static function distanceBetween(param1:Point, param2:Point) : Number
      {
         return Math.sqrt((param2.x - param1.x) * (param2.x - param1.x) + (param2.y - param1.y) * (param2.y - param1.y));
      }
      
      public static function squaredDistanceBetween(param1:Point, param2:Point) : Number
      {
         return (param2.x - param1.x) * (param2.x - param1.x) + (param2.y - param1.y) * (param2.y - param1.y);
      }
      
      public static function percentAlongLine(param1:Point, param2:Point, param3:Point) : Number
      {
         param1 = Closest.pointClosestTo(param1,param2,param3);
         var _loc4_:Number = distanceBetween(param2,param3);
         var _loc5_:Number = distanceBetween(param2,param1);
         return _loc5_ / _loc4_;
      }
      
      public static function get dtr() : Number
      {
         return _dtr;
      }
      
      public static function get rtd() : Number
      {
         return _rtd;
      }
      
      public static function rotate(param1:Point, param2:Number) : void
      {
         var _loc3_:Number = param1.x;
         var _loc4_:Number = param1.y;
         var _loc5_:Number = Math.sin(param2);
         var _loc6_:Number = Math.cos(param2);
         param1.x = _loc6_ * _loc3_ - _loc5_ * _loc4_;
         param1.y = _loc5_ * _loc3_ + _loc6_ * _loc4_;
      }
      
      public static function rotatePointComputedAngle(param1:Point, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         _loc4_ = param1.x;
         var _loc5_:Number = param1.y;
         param1.x = param3 * _loc4_ - param2 * _loc5_;
         param1.y = param2 * _loc4_ + param3 * _loc5_;
      }
      
      public static function isConvex(param1:Array) : Boolean
      {
         return getArea(param1) > 0 ? true : false;
      }
      
      public static function getArea(param1:Array) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1.length > 2)
         {
            _loc2_ = 0;
            _loc3_ = int(param1.length);
            _loc4_ = 1;
            while(_loc4_ <= _loc3_ - 2)
            {
               _loc2_ += param1[_loc4_].x * (param1[_loc4_ + 1].y - param1[_loc4_ - 1].y);
               _loc4_++;
            }
            _loc2_ += param1[param1.length - 1].x * (param1[0].y - param1[param1.length - 2].y);
            return _loc2_ + param1[0].x * (param1[1].y - param1[param1.length - 1].y);
         }
         return 0;
      }
      
      public static function lerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 + (param2 - param1) * param3;
      }
      
      public static function intersectCircleLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Point
      {
         var _loc8_:String = null;
         var _loc13_:Point = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc9_:Number = (param6 - param4) * (param6 - param4) + (param7 - param5) * (param7 - param5);
         var _loc10_:Number = 2 * ((param6 - param4) * (param4 - param1) + (param7 - param5) * (param5 - param2));
         var _loc11_:Number = param1 * param1 + param2 * param2 + param4 * param4 + param5 * param5 - 2 * (param1 * param4 + param2 * param5) - param3 * param3;
         var _loc12_:Number = _loc10_ * _loc10_ - 4 * _loc9_ * _loc11_;
         if(_loc12_ < 0)
         {
            _loc8_ = "Outside";
         }
         else
         {
            if(_loc12_ != 0)
            {
               _loc14_ = Math.sqrt(_loc12_);
               _loc15_ = (-_loc10_ + _loc14_) / (2 * _loc9_);
               _loc16_ = (-_loc10_ - _loc14_) / (2 * _loc9_);
               if((_loc15_ < 0 || _loc15_ > 1) && (_loc16_ < 0 || _loc16_ > 1))
               {
                  if(_loc15_ < 0 && _loc16_ < 0 || _loc15_ > 1 && _loc16_ > 1)
                  {
                     return null;
                  }
                  return null;
               }
               (_loc13_ = new Point()).x = 0;
               _loc13_.y = 0;
               if(0 <= _loc16_ && _loc16_ <= 1)
               {
                  _loc13_.x = lerp(param4,param6,_loc16_);
                  _loc13_.y = lerp(param5,param7,_loc16_);
                  return _loc13_;
               }
               if(0 <= _loc15_ && _loc15_ <= 1)
               {
                  _loc13_.x = lerp(param4,param6,_loc15_);
                  _loc13_.y = lerp(param5,param7,_loc15_);
                  return _loc13_;
               }
               return null;
            }
            _loc8_ = "Tangent";
         }
         return _loc13_;
      }
      
      public static function intersectLineLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Point
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc9_:Number = (param7 - param5) * (param2 - param6) - (param8 - param6) * (param1 - param5);
         var _loc10_:Number = (param3 - param1) * (param2 - param6) - (param4 - param2) * (param1 - param5);
         var _loc11_:Number = (param8 - param6) * (param3 - param1) - (param7 - param5) * (param4 - param2);
         if(_loc11_ != 0)
         {
            _loc12_ = _loc9_ / _loc11_;
            _loc13_ = _loc10_ / _loc11_;
            if(0 <= _loc12_ && _loc12_ <= 1 && 0 <= _loc13_ && _loc13_ <= 1)
            {
               return new Point(param1 + _loc12_ * (param3 - param1),param2 + _loc12_ * (param4 - param2));
            }
            return null;
         }
         return null;
      }
      
      public static function constrainLineByLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Object
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc9_:Number = (param7 - param5) * (param2 - param6) - (param8 - param6) * (param1 - param5);
         var _loc10_:Number = (param3 - param1) * (param2 - param6) - (param4 - param2) * (param1 - param5);
         var _loc11_:Number = (param8 - param6) * (param3 - param1) - (param7 - param5) * (param4 - param2);
         if(_loc11_ != 0)
         {
            _loc12_ = _loc9_ / _loc11_;
            _loc13_ = _loc10_ / _loc11_;
            if(0 <= _loc12_ && _loc12_ <= 1 && 0 <= _loc13_ && _loc13_ <= 1)
            {
               return {
                  "x":param1 + _loc12_ * (param3 - param1),
                  "y":param2 + _loc12_ * (param4 - param2)
               };
            }
            return {
               "x":param1,
               "y":param2
            };
         }
         return {
            "x":param1,
            "y":param2
         };
      }
      
      public static function normalizeAngle(param1:Number) : Number
      {
         if(param1 > PI)
         {
            param1 -= TWOPI;
         }
         else if(param1 < 0 - PI)
         {
            param1 += TWOPI;
         }
         else if(param1 < 0.0001 && param1 > -0.0001)
         {
            return 0;
         }
         return param1;
      }
      
      public static function constrainAngle(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = NaN;
         param1 = normalizeAngle(param1);
         if(param3 < param2)
         {
            _loc4_ = param3;
            param3 = param2;
            param2 = _loc4_;
         }
         if(param1 > param3)
         {
            param1 = param3;
         }
         else if(param1 < param2)
         {
            param1 = param2;
         }
         return param1;
      }
      
      public static function lineWithinBounds(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         if(param5 > param1 && param5 < param3 && param7 > param1 && param7 < param3 && param6 > param2 && param6 < param4 && param8 > param2 && param8 < param4)
         {
            return true;
         }
         return false;
      }
      
      public static function gridPointsThatIntersectLine(param1:Point, param2:Point, param3:Number = 1, param4:Boolean = false) : Array
      {
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         param1 = param1.clone();
         var _loc5_:Number = 1 / param3;
         param1.x *= _loc5_;
         param1.y *= _loc5_;
         param2 = param2.clone();
         param2.x *= _loc5_;
         param2.y *= _loc5_;
         var _loc6_:Array = [];
         var _loc7_:Number = param2.x - param1.x;
         var _loc8_:Number = param2.y - param1.y;
         var _loc14_:int = NaN;
         var _loc15_:Boolean = false;
         if(Math.abs(_loc7_) > Math.abs(_loc8_))
         {
            if(_loc8_ == 0)
            {
               _loc10_ = new Point(1,0);
            }
            else
            {
               _loc10_ = new Point(1,_loc8_ / _loc7_);
            }
            if(param1.x <= param2.x)
            {
               _loc16_ = int(param1.x);
               _loc17_ = int(param2.x);
               _loc9_ = new Point(param1.x,param1.y);
               _loc12_ = param1.x - Math.ceil(param1.x);
               _loc18_ = int(param1.y);
               _loc19_ = int(param2.y);
            }
            else
            {
               _loc16_ = int(param2.x);
               _loc17_ = int(param1.x);
               _loc9_ = new Point(param2.x,param2.y);
               _loc12_ = param2.x - Math.ceil(param2.x);
               _loc18_ = int(param2.y);
               _loc19_ = int(param1.y);
               _loc15_ = true;
            }
            _loc9_.x = _loc16_;
            _loc12_ *= _loc10_.y;
            _loc9_.y -= _loc12_;
            _loc9_.y -= _loc10_.y;
            _loc11_ = _loc16_;
            while(_loc11_ <= _loc17_)
            {
               _loc9_.x += 1;
               _loc9_.y += _loc10_.y;
               _loc13_ = int(_loc9_.y);
               if(_loc11_ > _loc16_ && _loc14_ != _loc13_ && _loc11_ < _loc17_)
               {
                  if(_loc14_ < _loc13_)
                  {
                     _loc6_.push(new Point(_loc9_.x - 1,_loc13_ - 1));
                  }
                  else
                  {
                     _loc6_.push(new Point(_loc9_.x - 1,_loc13_ + 1));
                  }
               }
               else if(_loc11_ == _loc16_ && _loc18_ != _loc13_)
               {
                  if(_loc18_ < _loc13_)
                  {
                     _loc6_.push(new Point(_loc9_.x - 1,_loc13_ - 1));
                  }
                  else
                  {
                     _loc6_.push(new Point(_loc9_.x - 1,_loc13_ + 1));
                  }
               }
               else if(_loc11_ == _loc17_ && _loc14_ != _loc19_)
               {
                  _loc6_.push(new Point(_loc9_.x - 1,_loc14_));
               }
               if(_loc11_ != _loc17_)
               {
                  _loc6_.push(new Point(_loc9_.x - 1,_loc13_));
               }
               else
               {
                  _loc6_.push(new Point(_loc9_.x - 1,_loc19_));
               }
               _loc14_ = _loc13_;
               _loc11_++;
            }
         }
         else
         {
            if(_loc8_ == 0)
            {
               _loc10_ = new Point(0,1);
            }
            else
            {
               _loc10_ = new Point(_loc7_ / _loc8_,1);
            }
            if(param1.y <= param2.y)
            {
               _loc20_ = int(param1.y);
               _loc21_ = int(param2.y);
               _loc9_ = new Point(param1.x,param1.y);
               _loc12_ = param1.y - Math.ceil(param1.y);
               _loc22_ = int(param1.x);
               _loc23_ = int(param2.x);
            }
            else
            {
               _loc20_ = int(param2.y);
               _loc21_ = int(param1.y);
               _loc9_ = new Point(param2.x,param2.y);
               _loc12_ = param2.y - Math.ceil(param2.y);
               _loc22_ = int(param2.x);
               _loc23_ = int(param1.x);
               _loc15_ = true;
            }
            _loc9_.y = _loc20_;
            _loc12_ *= _loc10_.x;
            _loc9_.x -= _loc12_;
            _loc9_.x -= _loc10_.x;
            _loc11_ = _loc20_;
            while(_loc11_ <= _loc21_)
            {
               _loc9_.x += _loc10_.x;
               _loc9_.y += 1;
               _loc13_ = int(_loc9_.x);
               if(_loc11_ > _loc20_ && _loc14_ != _loc13_ && _loc11_ < _loc21_)
               {
                  if(_loc14_ < _loc13_)
                  {
                     _loc6_.push(new Point(_loc13_ - 1,_loc9_.y - 1));
                  }
                  else
                  {
                     _loc6_.push(new Point(_loc13_ + 1,_loc9_.y - 1));
                  }
               }
               else if(_loc11_ == _loc20_ && _loc22_ != _loc13_)
               {
                  if(_loc22_ < _loc13_)
                  {
                     _loc6_.push(new Point(_loc13_ - 1,_loc9_.y - 1));
                  }
                  else
                  {
                     _loc6_.push(new Point(_loc13_ + 1,_loc9_.y - 1));
                  }
               }
               else if(_loc11_ == _loc21_ && _loc14_ != _loc23_)
               {
                  _loc6_.push(new Point(_loc23_,_loc9_.y - 1));
               }
               if(_loc11_ != _loc21_)
               {
                  _loc6_.push(new Point(_loc13_,_loc9_.y - 1));
               }
               else
               {
                  _loc6_.push(new Point(_loc23_,_loc9_.y - 1));
               }
               _loc14_ = _loc13_;
               _loc11_++;
            }
         }
         if(param4)
         {
            _loc6_.shift();
            _loc6_.pop();
         }
         if(_loc15_)
         {
            _loc6_.reverse();
         }
         return _loc6_;
      }
   }
}

