package com.sploder.game.effect
{
   import flash.display.*;
   
   public class ReduceColors
   {
      public static var dither:Boolean = false;
      
      public function ReduceColors()
      {
         super();
      }
      
      public static function reduceColors(param1:BitmapData, param2:int = 16, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 255;
         param2 -= 2;
         if(param2 <= 0)
         {
            param2 = 1;
         }
         if(param2 >= 255)
         {
            param2 = 254;
         }
         var _loc9_:Number = _loc8_ / param2;
         var _loc10_:Number = (_loc8_ - _loc8_ / (param2 + 1)) / _loc8_;
         var _loc11_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _loc8_)
         {
            if(_loc5_ >= _loc6_ * _loc9_ * _loc10_)
            {
               _loc6_++;
            }
            _loc11_.push(Math.floor(Math.ceil(_loc6_ * _loc9_) - _loc9_));
            _loc5_++;
         }
         var _loc17_:int = param1.width;
         var _loc18_:int = param1.height;
         param1.lock();
         if(param4)
         {
            if(param3)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc17_)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc18_)
                  {
                     _loc7_ = int(param1.getPixel32(_loc5_,_loc6_));
                     _loc12_ = int(_loc11_[(_loc7_ >>> 24) - 1]);
                     _loc13_ = int(_loc11_[(_loc7_ >>> 16 & 0xFF) - 1]);
                     _loc14_ = int(_loc11_[(_loc7_ >>> 8 & 0xFF) - 1]);
                     _loc15_ = int(_loc11_[(_loc7_ & 0xFF) - 1]);
                     _loc16_ = Math.ceil((_loc13_ + _loc14_ + _loc15_) / 3);
                     param1.setPixel32(_loc5_,_loc6_,_loc12_ << 24 | _loc16_ << 16 | _loc16_ << 8 | _loc16_);
                     _loc6_++;
                  }
                  _loc5_++;
               }
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < _loc17_)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc18_)
                  {
                     _loc7_ = int(param1.getPixel32(_loc5_,_loc6_));
                     _loc12_ = int(_loc11_[(_loc7_ >>> 24) - 1]);
                     _loc13_ = int(_loc11_[(_loc7_ >>> 16 & 0xFF) - 1]);
                     _loc14_ = int(_loc11_[(_loc7_ >>> 8 & 0xFF) - 1]);
                     _loc15_ = int(_loc11_[(_loc7_ & 0xFF) - 1]);
                     param1.setPixel32(_loc5_,_loc6_,_loc12_ << 24 | _loc13_ << 16 | _loc14_ << 8 | _loc15_);
                     _loc6_++;
                  }
                  _loc5_++;
               }
            }
         }
         else if(param3)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc17_)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc18_)
               {
                  _loc7_ = int(param1.getPixel32(_loc5_,_loc6_));
                  _loc13_ = int(_loc11_[(_loc7_ >>> 16 & 0xFF) - 1]);
                  _loc14_ = int(_loc11_[(_loc7_ >>> 8 & 0xFF) - 1]);
                  _loc15_ = int(_loc11_[(_loc7_ & 0xFF) - 1]);
                  _loc16_ = Math.ceil((_loc13_ + _loc14_ + _loc15_) / 3);
                  param1.setPixel32(_loc5_,_loc6_,_loc7_ >>> 24 << 24 | _loc16_ << 16 | _loc16_ << 8 | _loc16_);
                  _loc6_++;
               }
               _loc5_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc17_)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc18_)
               {
                  _loc7_ = int(param1.getPixel32(_loc5_,_loc6_));
                  _loc13_ = int(_loc11_[(_loc7_ >>> 16 & 0xFF) - 1]);
                  _loc14_ = int(_loc11_[(_loc7_ >>> 8 & 0xFF) - 1]);
                  _loc15_ = int(_loc11_[(_loc7_ & 0xFF) - 1]);
                  if(dither)
                  {
                     if(_loc13_ < 238)
                     {
                        _loc13_ += (_loc5_ + _loc6_) % 2 == 0 ? 18 : 0;
                     }
                     else
                     {
                        _loc13_ -= (_loc5_ + _loc6_) % 2 == 0 ? 18 : 0;
                     }
                     if(_loc14_ < 238)
                     {
                        _loc14_ += (_loc5_ + _loc6_) % 2 == 0 ? 18 : 0;
                     }
                     else
                     {
                        _loc14_ -= (_loc5_ + _loc6_) % 2 == 0 ? 18 : 0;
                     }
                     if(_loc15_ < 238)
                     {
                        _loc15_ += (_loc5_ + _loc6_) % 2 == 0 ? 18 : 0;
                     }
                     else
                     {
                        _loc15_ -= (_loc5_ + _loc6_) % 2 == 0 ? 18 : 0;
                     }
                  }
                  param1.setPixel32(_loc5_,_loc6_,_loc7_ >>> 24 << 24 | _loc13_ << 16 | _loc14_ << 8 | _loc15_);
                  _loc6_++;
               }
               _loc5_++;
            }
         }
         param1.unlock();
      }
      
      public static function toCGA(param1:BitmapData, param2:Boolean = false, param3:Boolean = false) : void
      {
         reduceColors(param1,0,param2,param3);
      }
      
      public static function toEGA(param1:BitmapData, param2:Boolean = false, param3:Boolean = false) : void
      {
         reduceColors(param1,4,param2,param3);
      }
      
      public static function toHAM(param1:BitmapData, param2:Boolean = false, param3:Boolean = false) : void
      {
         reduceColors(param1,6,param2,param3);
      }
      
      public static function toVGA(param1:BitmapData, param2:Boolean = false, param3:Boolean = false) : void
      {
         reduceColors(param1,8,param2,param3);
      }
      
      public static function toSVGA(param1:BitmapData, param2:Boolean = false, param3:Boolean = false) : void
      {
         reduceColors(param1,16,param2,param3);
      }
   }
}

