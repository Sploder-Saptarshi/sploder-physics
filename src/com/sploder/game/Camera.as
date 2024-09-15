package com.sploder.game
{
   import flash.geom.Point;
   import flash.utils.getTimer;
   import nape.phys.Body;
   
   public class Camera
   {
      protected var _target:Point;
      
      protected var _pixelSnap:Boolean = false;
      
      protected var _watching:Boolean = false;
      
      protected var _chasing:Boolean = false;
      
      protected var _alignToTarget:Boolean = false;
      
      protected var _x:Number = 0;
      
      protected var _y:Number = 0;
      
      protected var _lastTime:Number = 0;
      
      protected var _duration:Number;
      
      protected var _delta:Number = 1;
      
      private var _watchObject:Body;
      
      private var _watchOffsetPoint:Point;
      
      private var _watchElasticity:Number;
      
      private var _shakeTime:Number = -3000;
      
      public function Camera(param1:Number = 0, param2:Number = 0, param3:Point = null)
      {
         super();
         if(param3 != null)
         {
            this._target = new Point(param3.x,param3.y);
         }
         else
         {
            this._target = new Point(0,0);
         }
      }
      
      public function get target() : Point
      {
         return this._target;
      }
      
      public function get pixelSnap() : Boolean
      {
         return this._pixelSnap;
      }
      
      public function set pixelSnap(param1:Boolean) : void
      {
         this._pixelSnap = param1;
      }
      
      public function get watching() : Boolean
      {
         return this._watching;
      }
      
      public function get chasing() : Boolean
      {
         return this._chasing;
      }
      
      public function get alignToTarget() : Boolean
      {
         return this._alignToTarget;
      }
      
      public function set alignToTarget(param1:Boolean) : void
      {
         this._alignToTarget = param1;
      }
      
      public function get watchObject() : Body
      {
         return this._watchObject;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function get y() : Number
      {
         if(getTimer() - this._shakeTime < 500)
         {
            return this._y + Math.sin((getTimer() - this._shakeTime - 100) / 15) * 20 * (500 - (getTimer() - this._shakeTime)) / 500;
         }
         return this._y;
      }
      
      public function update() : void
      {
         this.doActions();
      }
      
      private function doActions() : void
      {
         this._duration = getTimer() - this._lastTime;
         this._delta = Math.min(1,this._duration / 33);
         this._lastTime = getTimer();
         if(this._watching)
         {
            this.watch();
         }
      }
      
      public function startWatching(param1:Body, param2:Number = 1, param3:Point = null, param4:Boolean = false) : void
      {
         this._watchObject = param1;
         this._watchElasticity = Math.max(1,param2);
         this._alignToTarget = param4;
         if(param3 == null)
         {
            this._watchOffsetPoint = new Point(0,0);
         }
         else
         {
            this._watchOffsetPoint = param3.clone();
         }
         this._watching = true;
      }
      
      public function stopWatching(param1:Point = null) : void
      {
         this._watching = false;
         if(param1 != null)
         {
            this._target = param1.clone();
         }
      }
      
      private function watch() : void
      {
         if(this.target == null)
         {
            this.stopWatching();
            return;
         }
         if(Boolean(this.watchObject) && !this.watchObject.added_to_space)
         {
            this.stopWatching();
            return;
         }
         var _loc1_:Number = this._watchElasticity / this._delta;
         var _loc2_:Number = (this._watchObject.px - this._target.x) / _loc1_;
         var _loc3_:Number = (this._watchObject.py - this._target.y) / _loc1_;
         if(this._pixelSnap)
         {
            _loc2_ = Math.round(_loc2_);
            _loc3_ = Math.round(_loc3_);
         }
         this._target.x += _loc2_;
         this._target.y += _loc3_;
         this._x = this._target.x;
         this._y = this._target.y;
      }
      
      public function alignTo(param1:Body, param2:Boolean = true) : void
      {
         this._x = this._target.x = param1.px;
         this._y = this._target.y = param1.py;
      }
      
      public function shake() : void
      {
         this._shakeTime = getTimer();
      }
   }
}

