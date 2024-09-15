package com.sploder.asui
{
   import com.robertpenner.easing.*;
   
   public class Tween
   {
      public static var EASE_IN:uint = 0;
      
      public static var EASE_OUT:uint = 1;
      
      public static var EASE_INOUT:uint = 2;
      
      public static var STYLE_LINEAR:uint = 0;
      
      public static var STYLE_CUBIC:uint = 1;
      
      public static var STYLE_QUAD:uint = 2;
      
      public static var STYLE_QUART:uint = 3;
      
      public static var STYLE_QUINT:uint = 4;
      
      public static var STYLE_SINE:uint = 5;
      
      public static var STYLE_EXPO:uint = 6;
      
      public static var STYLE_CIRC:uint = 7;
      
      public static var STYLE_ELASTIC:uint = 8;
      
      public static var STYLE_BACK:uint = 9;
      
      public static var STYLE_BOUNCE:uint = 10;
      
      public var priority:int = 1;
      
      private var _id:int;
      
      private var _groupID:int;
      
      private var _parentClass:TweenManager;
      
      private var tweenClassRef:Object;
      
      private var easeMethod:String = "easeIn";
      
      private var _tweenObject:Object;
      
      private var _attribute:String;
      
      private var _startVal:Number;
      
      private var _endVal:Number;
      
      private var _delta:Number;
      
      private var _duration:Number;
      
      private var _easeType:uint = 0;
      
      private var _easeStyle:uint = 0;
      
      private var _startTime:Number;
      
      private var _delay:Number;
      
      private var _time:Number;
      
      private var _loop:Boolean = false;
      
      private var _yoyo:Boolean = false;
      
      private var _loops:int = 0;
      
      private var _loopsCompleted:int = 0;
      
      private var _started:Boolean = false;
      
      private var _done:Boolean = false;
      
      private var _startHandler:Function;
      
      private var _doneHandler:Function;
      
      public function Tween(param1:TweenManager, param2:Object, param3:String, param4:Number = NaN, param5:Number = NaN, param6:Number = 1, param7:Boolean = false, param8:Boolean = false, param9:int = 0, param10:Number = 0, param11:uint = 0, param12:uint = 0, param13:Function = null, param14:Function = null)
      {
         super();
         this.init(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
      }
      
      public static function getTweenClass(param1:int) : Class
      {
         switch(param1)
         {
            case Tween.STYLE_LINEAR:
               return Linear;
            case Tween.STYLE_CUBIC:
               return Cubic;
            case Tween.STYLE_QUAD:
               return Quad;
            case Tween.STYLE_QUART:
               return Quart;
            case Tween.STYLE_QUINT:
               return Quint;
            case Tween.STYLE_SINE:
               return Sine;
            case Tween.STYLE_EXPO:
               return Expo;
            case Tween.STYLE_CIRC:
               return Circ;
            case Tween.STYLE_ELASTIC:
               return Elastic;
            case Tween.STYLE_BACK:
               return Back;
            case Tween.STYLE_BOUNCE:
               return Bounce;
            default:
               return Linear;
         }
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get groupID() : int
      {
         return this._groupID;
      }
      
      public function get tweenObject() : Object
      {
         return this._tweenObject;
      }
      
      public function get attribute() : String
      {
         return this._attribute;
      }
      
      private function init(param1:TweenManager, param2:Object, param3:String, param4:Number = NaN, param5:Number = NaN, param6:Number = 1, param7:Boolean = false, param8:Boolean = false, param9:int = 0, param10:Number = 0, param11:uint = 0, param12:uint = 0, param13:Function = null, param14:Function = null) : void
      {
         this._parentClass = param1;
         this._id = this._parentClass.newTweenID;
         this._groupID = this._parentClass.currentGroupID;
         this._tweenObject = param2;
         this._attribute = param3;
         this._startVal = !isNaN(param4) ? param4 : Number(param2[param3]);
         if(isNaN(this._startVal))
         {
            this._parentClass.removeTween(this);
            return;
         }
         this._endVal = param5;
         this._delta = this._endVal - this._startVal;
         this._duration = param6;
         this._loop = param7;
         this._yoyo = param8;
         this._loops = param9;
         this._delay = param10;
         if(this._duration < 100)
         {
            this._duration *= 1000;
         }
         if(this._delay < 100)
         {
            this._delay *= 1000;
         }
         this._easeType = param11;
         this._easeStyle = param12;
         this._startHandler = param13;
         this._doneHandler = param14;
         this.tweenClassRef = getTweenClass(this._easeStyle);
         this.getEaseMethod();
      }
      
      private function getEaseMethod() : void
      {
         switch(this._easeType)
         {
            case Tween.EASE_IN:
               this.easeMethod = "easeIn";
               break;
            case Tween.EASE_OUT:
               this.easeMethod = "easeOut";
               break;
            case Tween.EASE_INOUT:
               this.easeMethod = "easeInOut";
         }
      }
      
      public function ease() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         if(isNaN(this._startTime))
         {
            this._startTime = this._parentClass.time + this._delay;
         }
         this._time = this._parentClass.time - this._startTime;
         if(this._time < 0)
         {
            return;
         }
         if(!this._started)
         {
            this.onStart();
         }
         this._started = true;
         var _loc2_:Number = 0;
         if(this._done || this._tweenObject == null)
         {
            this.clear();
            return;
         }
         if(this._time <= this._duration)
         {
            _loc2_ = this._time;
         }
         else
         {
            _loc2_ = this._duration;
            this._done = true;
         }
         if(this.tweenClassRef == null)
         {
            return;
         }
         _loc1_ = Number(this.tweenClassRef[this.easeMethod](_loc2_,this._startVal,this._delta,this._duration));
         if(this._tweenObject != null)
         {
            this._tweenObject[this.attribute] = _loc1_;
         }
         if(this._done)
         {
            if(this._loop)
            {
               ++this._loopsCompleted;
               if(this._loops == 0 || this._loopsCompleted < this._loops)
               {
                  this._done = false;
                  this._startTime = this._parentClass.time;
                  if(this._yoyo)
                  {
                     _loc3_ = this._endVal;
                     this._endVal = this._startVal;
                     this._startVal = _loc3_;
                     this._delta = this._endVal - this._startVal;
                     if(this._easeType == EASE_IN)
                     {
                        this._easeType = EASE_OUT;
                     }
                     else if(this._easeType == EASE_OUT)
                     {
                        this._easeType = EASE_IN;
                     }
                  }
               }
            }
         }
         if(this._done)
         {
            this.onDone();
         }
      }
      
      private function onStart() : void
      {
         if(this._startHandler != null)
         {
            this._startHandler(this);
         }
      }
      
      private function onDone() : void
      {
         if(this._doneHandler != null)
         {
            this._doneHandler(this);
         }
         this.clear();
      }
      
      public function clear() : void
      {
         this._parentClass.removeTween(this);
      }
   }
}

