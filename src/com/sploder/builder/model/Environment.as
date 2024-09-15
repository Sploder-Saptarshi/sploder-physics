package com.sploder.builder.model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.describeType;
   
   public class Environment extends EventDispatcher
   {
      public static const SIZE_NORMAL:uint = 0;
      
      public static const SIZE_DOUBLE:uint = 1;
      
      public static const SIZE_FOLLOW:uint = 2;
      
      public static const EXTENTS_ENCLOSED:uint = 0;
      
      public static const EXTENTS_GROUND:uint = 1;
      
      public static const EXTENTS_OPEN:uint = 2;
      
      public static const EFFECT_NONE:String = "None";
      
      public static const EFFECT_SNOW:String = "Snow";
      
      public static const EFFECT_RAIN:String = "Rain";
      
      public static const EFFECT_CLOUDS:String = "Clouds";
      
      public static const EFFECT_STARS:String = "Stars";
      
      public static const EFFECT_SILK:String = "Silk";
      
      public static const EFFECT_LEAFY:String = "Leafy";
      
      public static const EFFECT_SMOKE:String = "Smoke";
      
      public static const EFFECT_GRID:String = "Grid";
      
      protected var _size:uint = 0;
      
      protected var _gravity:uint = 1;
      
      protected var _resistance:uint = 0;
      
      protected var _extents:uint = 0;
      
      protected var _wrap:uint = 0;
      
      protected var _total_lives:uint = 3;
      
      protected var _total_penalties:uint = 3;
      
      protected var _total_score:uint = 10;
      
      protected var _total_time:uint = 0;
      
      protected var _vInstructions:String = "";
      
      protected var _vMusic:String = "";
      
      protected var _bgColorTop:uint = 3342489;
      
      protected var _bgColorBottom:uint = 0;
      
      protected var _bgEffect:String = "None";
      
      public function Environment()
      {
         super();
      }
      
      public function setDefaults() : void
      {
         this._size = 0;
         this._gravity = 1;
         this._resistance = 0;
         this._extents = 0;
         this._bgColorTop = 3342489;
         this._bgColorBottom = 0;
         this._bgEffect = EFFECT_NONE;
         this._total_lives = 3;
         this._total_penalties = 3;
         this._total_score = 10;
         this._total_time = 0;
         this._vInstructions = "";
         this._vMusic = "";
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get size() : uint
      {
         return this._size;
      }
      
      public function set size(param1:uint) : void
      {
         this._size = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get gravity() : uint
      {
         return this._gravity;
      }
      
      public function set gravity(param1:uint) : void
      {
         this._gravity = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get resistance() : uint
      {
         return this._resistance;
      }
      
      public function set resistance(param1:uint) : void
      {
         this._resistance = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get extents() : uint
      {
         return this._extents;
      }
      
      public function set extents(param1:uint) : void
      {
         this._extents = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get bgColorTop() : uint
      {
         return this._bgColorTop;
      }
      
      public function set bgColorTop(param1:uint) : void
      {
         this._bgColorTop = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get bgColorBottom() : uint
      {
         return this._bgColorBottom;
      }
      
      public function set bgColorBottom(param1:uint) : void
      {
         this._bgColorBottom = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get bgEffect() : String
      {
         return this._bgEffect;
      }
      
      public function set bgEffect(param1:String) : void
      {
         this._bgEffect = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get wrap() : uint
      {
         return this._wrap;
      }
      
      public function set wrap(param1:uint) : void
      {
         this._wrap = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get total_lives() : uint
      {
         return this._total_lives;
      }
      
      public function set total_lives(param1:uint) : void
      {
         this._total_lives = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get total_penalties() : uint
      {
         return this._total_penalties;
      }
      
      public function set total_penalties(param1:uint) : void
      {
         this._total_penalties = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get total_score() : uint
      {
         return this._total_score;
      }
      
      public function set total_score(param1:uint) : void
      {
         this._total_score = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get total_time() : uint
      {
         return this._total_time;
      }
      
      public function set total_time(param1:uint) : void
      {
         this._total_time = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get vInstructions() : String
      {
         return unescape(unescape(this._vInstructions));
      }
      
      public function set vInstructions(param1:String) : void
      {
         this._vInstructions = escape(unescape(param1));
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get vMusic() : String
      {
         return this._vMusic;
      }
      
      public function set vMusic(param1:String) : void
      {
         this._vMusic = param1;
      }
      
      override public function toString() : String
      {
         var n:String = null;
         var param:XML = null;
         var f:Function = null;
         var params:XMLList = describeType(this)..accessor;
         var p:Array = [];
         for each(param in params)
         {
            n = param.@name;
            if(param.@access == "readwrite" && this["_" + n] != undefined)
            {
               p.push({
                  "name":n,
                  "value":this[n]
               });
            }
         }
         f = function callback(param1:*, param2:int, param3:Array):void
         {
            param3[param2] = param1["value"];
         };
         p.sortOn("name");
         p.forEach(f);
         return p.join(";");
      }
      
      public function fromString(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:XML = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         if(param1 == null || param1.length == 0)
         {
            this.setDefaults();
            return;
         }
         var _loc2_:XMLList = describeType(this)..accessor;
         var _loc3_:Array = [];
         for each(_loc5_ in _loc2_)
         {
            _loc4_ = _loc5_.@name;
            if(_loc5_.@access == "readwrite" && this["_" + _loc4_] != undefined)
            {
               _loc3_.push(_loc4_);
            }
         }
         _loc3_.sort();
         _loc6_ = param1.split(";");
         _loc7_ = int(_loc3_.length);
         while(_loc7_--)
         {
            if(this[_loc3_[_loc7_]] is String)
            {
               this[_loc3_[_loc7_]] = _loc6_[_loc7_];
            }
            else if(this[_loc3_[_loc7_]] is Boolean)
            {
               this[_loc3_[_loc7_]] = _loc6_[_loc7_] == "true";
            }
            else
            {
               this[_loc3_[_loc7_]] = parseFloat(_loc6_[_loc7_]);
            }
         }
         if(this._vInstructions == "0")
         {
            this._vInstructions = "";
         }
         if(this._vMusic == "0")
         {
            this._vMusic = "";
         }
      }
      
      public function getGameInfo() : String
      {
         var _loc1_:* = "";
         if(this._total_time == 0)
         {
            _loc1_ += "Score " + this._total_score + " points to win. ";
         }
         else if(this._total_score == 0)
         {
            _loc1_ += "SURVIVAL MODE: Stay alive for " + this._total_time + " seconds. ";
         }
         else
         {
            _loc1_ += "TIMED MODE: Score " + this._total_score + " points in " + this._total_time + " seconds. ";
         }
         if(this._total_lives > 0)
         {
            _loc1_ += "You start with " + this._total_lives + " lives. ";
         }
         if(this._total_penalties > 0)
         {
            if(this._total_penalties > 1)
            {
               _loc1_ += "Lose a life for every " + this._total_penalties + " penalties.";
            }
            else
            {
               _loc1_ += "Lose a life for every penalty.";
            }
         }
         if(_loc1_.length)
         {
            return _loc1_;
         }
         return "There seems to be no objective for this game. Play around and have fun!";
      }
   }
}

