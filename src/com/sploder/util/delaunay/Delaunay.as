package com.sploder.util.delaunay
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Point;
   
   public class Delaunay
   {
      public static var EPSILON:* = 0.000001;
      
      public function Delaunay()
      {
         super();
      }
      
      public static function CircumCircle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:XYZ) : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         if(Math.abs(param4 - param6) < EPSILON && Math.abs(param6 - param8) < EPSILON)
         {
            return false;
         }
         if(Math.abs(param6 - param4) < EPSILON)
         {
            _loc11_ = -(param7 - param5) / (param8 - param6);
            _loc13_ = (param5 + param7) / 2;
            _loc15_ = (param6 + param8) / 2;
            _loc20_ = (param5 + param3) / 2;
            _loc21_ = _loc11_ * (_loc20_ - _loc13_) + _loc15_;
         }
         else if(Math.abs(param8 - param6) < EPSILON)
         {
            _loc10_ = -(param5 - param3) / (param6 - param4);
            _loc12_ = (param3 + param5) / 2;
            _loc14_ = (param4 + param6) / 2;
            _loc20_ = (param7 + param5) / 2;
            _loc21_ = _loc10_ * (_loc20_ - _loc12_) + _loc14_;
         }
         else
         {
            _loc10_ = -(param5 - param3) / (param6 - param4);
            _loc11_ = -(param7 - param5) / (param8 - param6);
            _loc12_ = (param3 + param5) / 2;
            _loc13_ = (param5 + param7) / 2;
            _loc14_ = (param4 + param6) / 2;
            _loc15_ = (param6 + param8) / 2;
            _loc20_ = (_loc10_ * _loc12_ - _loc11_ * _loc13_ + _loc15_ - _loc14_) / (_loc10_ - _loc11_);
            _loc21_ = _loc10_ * (_loc20_ - _loc12_) + _loc14_;
         }
         _loc16_ = param5 - _loc20_;
         _loc17_ = param6 - _loc21_;
         _loc18_ = _loc16_ * _loc16_ + _loc17_ * _loc17_;
         _loc22_ = Math.sqrt(_loc18_);
         _loc16_ = param1 - _loc20_;
         _loc17_ = param2 - _loc21_;
         _loc19_ = _loc16_ * _loc16_ + _loc17_ * _loc17_;
         param9.x = _loc20_;
         param9.y = _loc21_;
         param9.z = _loc22_;
         return _loc19_ <= _loc18_ ? true : false;
      }
      
      public static function triangulate(param1:Array) : Array
      {
         var _loc7_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc33_:int = 0;
         var _loc34_:XYZ = null;
         var _loc35_:int = 0;
         var _loc36_:Array = null;
         var _loc37_:int = 0;
         var _loc38_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = int(param1.length);
         _loc33_ = 0;
         while(_loc33_ < _loc3_ * 3)
         {
            _loc2_[_loc33_] = new ITriangle();
            _loc33_++;
         }
         param1.sortOn("x",Array.NUMERIC);
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc8_:Number = 200;
         var _loc30_:int = 0;
         _loc7_ = 4 * _loc3_;
         _loc4_ = new Array();
         var _loc31_:int = 0;
         while(_loc31_ < _loc7_)
         {
            _loc4_[_loc31_] = false;
            _loc31_++;
         }
         _loc5_ = new Array();
         var _loc32_:int = 0;
         while(_loc32_ < _loc8_)
         {
            _loc5_[_loc32_] = new IEdge();
            _loc32_++;
         }
         _loc21_ = Number(param1[0].x);
         _loc23_ = Number(param1[0].y);
         _loc22_ = _loc21_;
         _loc24_ = _loc23_;
         _loc33_ = 1;
         while(_loc33_ < _loc3_)
         {
            if(param1[_loc33_].x < _loc21_)
            {
               _loc21_ = Number(param1[_loc33_].x);
            }
            if(param1[_loc33_].x > _loc22_)
            {
               _loc22_ = Number(param1[_loc33_].x);
            }
            if(param1[_loc33_].y < _loc23_)
            {
               _loc23_ = Number(param1[_loc33_].y);
            }
            if(param1[_loc33_].y > _loc24_)
            {
               _loc24_ = Number(param1[_loc33_].y);
            }
            _loc33_++;
         }
         _loc27_ = _loc22_ - _loc21_;
         _loc28_ = _loc24_ - _loc23_;
         _loc29_ = _loc27_ > _loc28_ ? _loc27_ : _loc28_;
         _loc25_ = (_loc22_ + _loc21_) / 2;
         _loc26_ = (_loc24_ + _loc23_) / 2;
         param1[_loc3_] = new XYZ();
         param1[_loc3_ + 1] = new XYZ();
         param1[_loc3_ + 2] = new XYZ();
         param1[_loc3_ + 0].x = _loc25_ - 2 * _loc29_;
         param1[_loc3_ + 0].y = _loc26_ - _loc29_;
         param1[_loc3_ + 0].z = 0;
         param1[_loc3_ + 1].x = _loc25_;
         param1[_loc3_ + 1].y = _loc26_ + 2 * _loc29_;
         param1[_loc3_ + 1].z = 0;
         param1[_loc3_ + 2].x = _loc25_ + 2 * _loc29_;
         param1[_loc3_ + 2].y = _loc26_ - _loc29_;
         param1[_loc3_ + 2].z = 0;
         _loc2_[0].p1 = _loc3_;
         _loc2_[0].p2 = _loc3_ + 1;
         _loc2_[0].p3 = _loc3_ + 2;
         _loc4_[0] = false;
         _loc30_ = 1;
         _loc33_ = 0;
         while(_loc33_ < _loc3_)
         {
            _loc10_ = Number(param1[_loc33_].x);
            _loc11_ = Number(param1[_loc33_].y);
            _loc6_ = 0;
            _loc34_ = new XYZ();
            _loc35_ = 0;
            while(_loc35_ < _loc30_)
            {
               if(!_loc4_[_loc35_])
               {
                  _loc12_ = Number(param1[_loc2_[_loc35_].p1].x);
                  _loc13_ = Number(param1[_loc2_[_loc35_].p1].y);
                  _loc14_ = Number(param1[_loc2_[_loc35_].p2].x);
                  _loc15_ = Number(param1[_loc2_[_loc35_].p2].y);
                  _loc16_ = Number(param1[_loc2_[_loc35_].p3].x);
                  _loc17_ = Number(param1[_loc2_[_loc35_].p3].y);
                  _loc9_ = CircumCircle(_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc34_);
                  _loc18_ = _loc34_.x;
                  _loc19_ = _loc34_.y;
                  _loc20_ = _loc34_.z;
                  if(_loc18_ + _loc20_ < _loc10_)
                  {
                     _loc4_[_loc35_] = true;
                  }
                  if(_loc9_)
                  {
                     if(_loc6_ + 3 >= _loc8_)
                     {
                        _loc8_ += 100;
                        _loc36_ = [];
                        _loc32_ = 0;
                        while(_loc32_ < _loc8_)
                        {
                           _loc36_[_loc32_] = new IEdge();
                           _loc32_++;
                        }
                        _loc37_ = 0;
                        while(_loc37_ < _loc5_.length)
                        {
                           _loc36_[_loc37_] = _loc5_[_loc37_];
                           _loc37_++;
                        }
                        _loc5_ = _loc36_;
                     }
                     _loc5_[_loc6_ + 0].p1 = _loc2_[_loc35_].p1;
                     _loc5_[_loc6_ + 0].p2 = _loc2_[_loc35_].p2;
                     _loc5_[_loc6_ + 1].p1 = _loc2_[_loc35_].p2;
                     _loc5_[_loc6_ + 1].p2 = _loc2_[_loc35_].p3;
                     _loc5_[_loc6_ + 2].p1 = _loc2_[_loc35_].p3;
                     _loc5_[_loc6_ + 2].p2 = _loc2_[_loc35_].p1;
                     _loc6_ += 3;
                     _loc2_[_loc35_].p1 = _loc2_[_loc30_ - 1].p1;
                     _loc2_[_loc35_].p2 = _loc2_[_loc30_ - 1].p2;
                     _loc2_[_loc35_].p3 = _loc2_[_loc30_ - 1].p3;
                     _loc4_[_loc35_] = _loc4_[_loc30_ - 1];
                     _loc30_--;
                     _loc35_--;
                  }
               }
               _loc35_++;
            }
            _loc35_ = 0;
            while(_loc35_ < _loc6_ - 1)
            {
               _loc38_ = _loc35_ + 1;
               while(_loc38_ < _loc6_)
               {
                  if(_loc5_[_loc35_].p1 == _loc5_[_loc38_].p2 && _loc5_[_loc35_].p2 == _loc5_[_loc38_].p1)
                  {
                     _loc5_[_loc35_].p1 = -1;
                     _loc5_[_loc35_].p2 = -1;
                     _loc5_[_loc38_].p1 = -1;
                     _loc5_[_loc38_].p2 = -1;
                  }
                  if(_loc5_[_loc35_].p1 == _loc5_[_loc38_].p1 && _loc5_[_loc35_].p2 == _loc5_[_loc38_].p2)
                  {
                     _loc5_[_loc35_].p1 = -1;
                     _loc5_[_loc35_].p2 = -1;
                     _loc5_[_loc38_].p1 = -1;
                     _loc5_[_loc38_].p2 = -1;
                  }
                  _loc38_++;
               }
               _loc35_++;
            }
            _loc35_ = 0;
            while(_loc35_ < _loc6_)
            {
               if(!(_loc5_[_loc35_].p1 == -1 || _loc5_[_loc35_].p2 == -1))
               {
                  if(_loc30_ >= _loc7_)
                  {
                     return null;
                  }
                  if(!_loc2_ || !_loc2_[_loc30_] || !_loc5_ || !_loc5_[_loc35_])
                  {
                     return null;
                  }
                  _loc2_[_loc30_].p1 = _loc5_[_loc35_].p1;
                  _loc2_[_loc30_].p2 = _loc5_[_loc35_].p2;
                  _loc2_[_loc30_].p3 = _loc33_;
                  _loc4_[_loc30_] = false;
                  _loc30_++;
               }
               _loc35_++;
            }
            _loc33_++;
         }
         _loc33_ = 0;
         while(_loc33_ < _loc30_)
         {
            if(_loc2_[_loc33_].p1 >= _loc3_ || _loc2_[_loc33_].p2 >= _loc3_ || _loc2_[_loc33_].p3 >= _loc3_)
            {
               _loc2_[_loc33_] = _loc2_[_loc30_ - 1];
               _loc30_--;
               _loc33_--;
            }
            _loc33_++;
         }
         _loc2_.length = _loc30_;
         param1.length -= 3;
         return _loc2_;
      }
      
      public static function drawDelaunay(param1:Array, param2:Array, param3:DisplayObjectContainer, param4:uint = 16777215, param5:Number = 1, param6:Boolean = false) : Array
      {
         var _loc7_:Shape = null;
         var _loc9_:ITriangle = null;
         var _loc10_:Point = null;
         var _loc11_:Graphics = null;
         var _loc8_:Array = [];
         for each(_loc9_ in param1)
         {
            (_loc10_ = new Point()).x = param5 * (param2[_loc9_.p1].x + param2[_loc9_.p2].x + param2[_loc9_.p3].x) / 3;
            _loc10_.y = param5 * (param2[_loc9_.p1].y + param2[_loc9_.p2].y + param2[_loc9_.p3].y) / 3;
            (_loc7_ = new Shape()).x = _loc10_.x;
            _loc7_.y = _loc10_.y;
            _loc11_ = _loc7_.graphics;
            if(param6)
            {
               _loc11_.beginFill(param4,1);
               _loc11_.drawRect(param2[_loc9_.p1].x * param5 - _loc10_.x,param2[_loc9_.p1].y * param5 - _loc10_.y,(param2[_loc9_.p3].x * param5 - param2[_loc9_.p1].x * param5) * 0.75,(param2[_loc9_.p3].y * param5 - param2[_loc9_.p1].y * param5) * 0.75);
               _loc7_.opaqueBackground = true;
            }
            else
            {
               _loc11_.beginFill(param4,1);
               _loc11_.moveTo(param2[_loc9_.p1].x * param5 - _loc10_.x,param2[_loc9_.p1].y * param5 - _loc10_.y);
               _loc11_.lineTo(param2[_loc9_.p2].x * param5 - _loc10_.x,param2[_loc9_.p2].y * param5 - _loc10_.y);
               _loc11_.lineTo(param2[_loc9_.p3].x * param5 - _loc10_.x,param2[_loc9_.p3].y * param5 - _loc10_.y);
            }
            param3.addChild(_loc7_);
            _loc8_.push(_loc7_);
         }
         return _loc8_;
      }
   }
}

