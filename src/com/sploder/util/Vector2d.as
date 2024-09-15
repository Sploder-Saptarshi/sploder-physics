package com.sploder.util
{
   import flash.geom.Point;
   
   public class Vector2d extends Point
   {
      public var angular:Boolean = false;
      
      public function Vector2d(param1:Point = null, param2:Number = 0, param3:Number = 0, param4:Boolean = false)
      {
         super();
         if(param1 != null)
         {
            this.x = param1.x;
            this.y = param1.y;
         }
         else
         {
            this.x = param2;
            this.y = param3;
         }
         if(isNaN(param2) || isNaN(param3))
         {
            param2 = param3 = 0;
         }
         this.angular = param4;
      }
      
      public function get rotation() : Number
      {
         return Math.atan2(y,x);
      }
      
      public function get magnitude() : Number
      {
         return length;
      }
      
      public function get squareMagnitude() : Number
      {
         return x * x + y * y;
      }
      
      public function get negligible() : Boolean
      {
         return Math.abs(x) + Math.abs(y) < 0.01;
      }
      
      public function get strength() : Number
      {
         return Math.abs(x) + Math.abs(y);
      }
      
      public function get copy() : Vector2d
      {
         return new Vector2d(null,x,y,this.angular);
      }
      
      public function get normalizedCopy() : Vector2d
      {
         var _loc1_:Vector2d = new Vector2d(null,x,y,this.angular);
         _loc1_.normalize(1);
         return _loc1_;
      }
      
      public function identityFront() : void
      {
         x = 0;
         y = -1;
      }
      
      public function identityTop() : void
      {
         x = 0;
         y = -1;
      }
      
      public function identityRight() : void
      {
         x = 1;
         y = 0;
      }
      
      public function reset() : void
      {
         x = y = 0;
      }
      
      public function invert() : void
      {
         x = -x;
         y = -y;
      }
      
      public function getInverse() : Vector2d
      {
         return new Vector2d(null,-x,-y,this.angular);
      }
      
      public function alignTo(param1:Vector2d) : void
      {
         if(isNaN(param1.x) || isNaN(param1.y))
         {
            return;
         }
         x = param1.x;
         y = param1.y;
         this.trunc();
      }
      
      public function alignToPoint(param1:Point) : void
      {
         if(param1 == null || isNaN(param1.x) || isNaN(param1.y))
         {
            return;
         }
         x = param1.x;
         y = param1.y;
         this.trunc();
      }
      
      public function alignPoint(param1:Object) : void
      {
         param1.x = x;
         param1.y = y;
      }
      
      public function addToPoint(param1:Object, param2:Number = 1) : void
      {
         param1.x += x * param2;
         param1.y += y * param2;
      }
      
      public function isSameAs(param1:Vector2d, param2:Number = 0.1) : Boolean
      {
         if(Math.abs(x - param1.x) < param2 && Math.abs(y - param1.y) < param2)
         {
            return true;
         }
         return false;
      }
      
      public function addBy(param1:Vector2d) : void
      {
         if(isNaN(param1.x) || isNaN(param1.y))
         {
            return;
         }
         x += param1.x;
         y += param1.y;
      }
      
      public function getSum(param1:Vector2d) : Vector2d
      {
         return new Vector2d(null,x + param1.x,y + param1.y,this.angular);
      }
      
      public function addScaled(param1:Vector2d, param2:Number) : void
      {
         if(isNaN(param1.x) || isNaN(param1.y))
         {
            return;
         }
         x += param1.x * param2;
         y += param1.y * param2;
      }
      
      public function addRotated(param1:Vector2d, param2:Number) : void
      {
         param1 = param1.copy;
         param1.rotate(param2);
         this.addBy(param1);
      }
      
      public function addRotatedScaled(param1:Vector2d, param2:Number, param3:Number) : void
      {
         param1 = param1.copy;
         param1.rotate(param2);
         this.addScaled(param1,param3);
      }
      
      public function subtractBy(param1:Vector2d) : void
      {
         if(isNaN(param1.x) || isNaN(param1.y))
         {
            return;
         }
         x -= param1.x;
         y -= param1.y;
      }
      
      public function getDifference(param1:Vector2d) : Vector2d
      {
         return new Vector2d(null,x - param1.x,y - param1.y,this.angular);
      }
      
      public function multiplyBy(param1:Vector2d) : void
      {
         if(isNaN(param1.x) || isNaN(param1.y))
         {
            return;
         }
         x *= param1.x;
         y *= param1.y;
         this.trunc();
      }
      
      public function getProduct(param1:Vector2d) : Vector2d
      {
         return new Vector2d(null,x * param1.x,y * param1.y,this.angular);
      }
      
      public function scaleBy(param1:Number) : void
      {
         if(isNaN(param1))
         {
            return;
         }
         x *= param1;
         y *= param1;
         this.trunc();
      }
      
      public function getScaled(param1:Number) : Vector2d
      {
         return new Vector2d(null,x * param1,y * param1,this.angular);
      }
      
      public function clamp(param1:Number) : void
      {
         if(this.squareMagnitude > param1 * param1)
         {
            this.scaleBy(param1 * param1 / this.squareMagnitude);
         }
      }
      
      public function getDotProduct(param1:Vector2d) : Number
      {
         if(isNaN(param1.x) || isNaN(param1.y))
         {
            return 0;
         }
         return x * param1.x + y * param1.y;
      }
      
      public function getMagnitudeInDirectionOf(param1:Vector2d) : Number
      {
         if(isNaN(param1.x) || isNaN(param1.y))
         {
            return 0;
         }
         var _loc2_:Number = 1 / param1.magnitude;
         return x * (param1.x * _loc2_) + y * (param1.y * _loc2_);
      }
      
      public function rotate(param1:Number) : void
      {
         var _loc2_:Number = length;
         var _loc3_:Number = this.rotation + param1;
         var _loc4_:Point = Point.polar(_loc2_,_loc3_);
         x = _loc4_.x;
         y = _loc4_.y;
         this.trunc();
      }
      
      public function rotateBy(param1:Vector2d) : void
      {
         var _loc2_:Number = Math.atan2(param1.y,param1.x);
         if(isNaN(_loc2_))
         {
            return;
         }
         this.rotate(_loc2_);
      }
      
      protected function trunc() : void
      {
         if(x < 0.00001 && x > -0.00001)
         {
            x = 0;
         }
         if(y < 0.00001 && y > -0.00001)
         {
            y = 0;
         }
      }
   }
}

