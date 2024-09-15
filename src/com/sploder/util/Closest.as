package com.sploder.util
{
   import flash.geom.Point;
   
   public class Closest
   {
      public static const EPSILON:Number = 0.00001;
      
      public function Closest()
      {
         super();
      }
      
      private static function mid(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 <= param2)
         {
            if(param2 <= param3)
            {
               return param2;
            }
            if(param3 <= param1)
            {
               return param1;
            }
            return param3;
         }
         if(param2 >= param3)
         {
            return param2;
         }
         if(param3 >= param1)
         {
            return param1;
         }
         return param3;
      }
      
      public static function pointClosestTo(param1:Point, param2:Point, param3:Point) : Point
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Point = null;
         var _loc4_:Number = param2.x >> 0;
         _loc5_ = param2.y >> 0;
         _loc6_ = param3.x >> 0;
         _loc7_ = param3.y >> 0;
         _loc10_ = new Point();
         if(_loc5_ == _loc7_ && _loc4_ == _loc6_)
         {
            _loc10_.x = _loc4_;
            _loc10_.y = _loc5_;
         }
         else if(_loc5_ == _loc7_)
         {
            _loc10_.y = _loc5_;
            _loc10_.x = mid(_loc4_,_loc6_,param1.x);
         }
         else if(_loc4_ == _loc6_)
         {
            _loc10_.x = _loc4_;
            _loc10_.y = mid(_loc5_,_loc7_,param1.y);
         }
         else
         {
            _loc8_ = _loc6_ - _loc4_;
            _loc9_ = _loc7_ - _loc5_;
            _loc10_.x = _loc9_ * (_loc9_ * _loc4_ - _loc8_ * (_loc5_ - param1.y)) + _loc8_ * _loc8_ * param1.x;
            _loc10_.x /= _loc8_ * _loc8_ + _loc9_ * _loc9_;
            _loc10_.y = _loc8_ * (param1.x - _loc10_.x) / _loc9_ + param1.y;
            if(_loc6_ > _loc4_)
            {
               if(_loc10_.x > _loc6_)
               {
                  _loc10_.x = _loc6_;
                  _loc10_.y = _loc7_;
               }
               else if(_loc10_.x < _loc4_)
               {
                  _loc10_.x = _loc4_;
                  _loc10_.y = _loc5_;
               }
            }
            else if(_loc10_.x < _loc6_)
            {
               _loc10_.x = _loc6_;
               _loc10_.y = _loc7_;
            }
            else if(_loc10_.x > _loc4_)
            {
               _loc10_.x = _loc4_;
               _loc10_.y = _loc5_;
            }
         }
         return _loc10_;
      }
      
      public static function distanceFromLine(param1:Point, param2:Point, param3:Point) : Number
      {
         var _loc4_:Point = pointClosestTo(param1,param2,param3);
         return Point.distance(param1,_loc4_);
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public static function closestPtSegmentSegment(param1:Point, param2:Point, param3:Point, param4:Point) : Object
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Vector2d = null;
         var _loc8_:Vector2d = null;
         var _loc9_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc10_:Vector2d = new Vector2d(param2.subtract(param1));
         var _loc11_:Vector2d = new Vector2d(param4.subtract(param3));
         var _loc12_:Vector2d = new Vector2d(param1.subtract(param3));
         var _loc13_:Number = _loc10_.getDotProduct(_loc10_);
         var _loc14_:Number = _loc11_.getDotProduct(_loc11_);
         var _loc15_:Number = _loc11_.getDotProduct(_loc12_);
         if(_loc13_ <= EPSILON && _loc14_ <= EPSILON)
         {
            _loc5_ = _loc6_ = 0;
            _loc7_ = new Vector2d(param1);
            _loc8_ = new Vector2d(param3);
            _loc9_ = _loc7_.getDifference(_loc8_).getDotProduct(_loc7_.getDifference(_loc8_));
            return {
               "c1":_loc7_,
               "c2":_loc8_,
               "dist":_loc9_,
               "s":_loc5_,
               "t":_loc6_
            };
         }
         if(_loc13_ <= EPSILON)
         {
            _loc5_ = 0;
            _loc6_ = _loc15_ / _loc14_;
            _loc6_ = clamp(_loc6_,0,1);
         }
         else
         {
            _loc18_ = _loc10_.getDotProduct(_loc12_);
            if(_loc14_ <= EPSILON)
            {
               _loc6_ = 0;
               _loc5_ = clamp(-_loc18_ / _loc13_,0,1);
            }
            else
            {
               _loc19_ = _loc10_.getDotProduct(_loc11_);
               _loc20_ = _loc13_ * _loc14_ - _loc19_ * _loc19_;
               if(_loc20_ != 0)
               {
                  _loc5_ = clamp((_loc19_ * _loc15_ - _loc18_ * _loc14_) / _loc20_,0,1);
               }
               else
               {
                  _loc5_ = 0;
               }
               _loc6_ = (_loc19_ * _loc5_ + _loc15_) / _loc14_;
               if(_loc6_ < 0)
               {
                  _loc6_ = 0;
                  _loc5_ = clamp(-_loc18_ / _loc13_,0,1);
               }
               else if(_loc6_ > 1)
               {
                  _loc6_ = 1;
                  _loc5_ = clamp((_loc19_ - _loc18_) / _loc13_,0,1);
               }
            }
         }
         var _loc16_:Vector2d = new Vector2d(param1);
         var _loc17_:Vector2d = new Vector2d(param3);
         _loc7_ = _loc16_.getSum(_loc10_.getScaled(_loc5_));
         _loc8_ = _loc17_.getSum(_loc11_.getScaled(_loc6_));
         _loc9_ = _loc7_.getDifference(_loc8_).getDotProduct(_loc7_.getDifference(_loc8_));
         return {
            "c1":_loc7_,
            "c2":_loc8_,
            "dist":_loc9_,
            "s":_loc5_,
            "t":_loc6_
         };
      }
   }
}

