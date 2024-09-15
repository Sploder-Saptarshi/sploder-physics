package com.sploder.game
{
   import com.sploder.builder.model.Environment;
   import com.sploder.builder.model.Model;
   import com.sploder.builder.model.ModelObject;
   import com.sploder.builder.model.Modifier;
   import com.sploder.game.sound.Sounds;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import nape.callbacks.Callback;
   import nape.phys.PhysObj;
   
   public class EventHandler extends EventDispatcher
   {
      public static var _nextID:int = 0;
      
      public static var levelNum:int = 0;
      
      public static var totalLevels:int = 0;
      
      public static var totalTime:int = 0;
      
      public static var totalScore:int = 0;
      
      protected var _sim:Simulation;
      
      protected var _model:Model;
      
      protected var _environment:Environment;
      
      protected var _id:int = 0;
      
      protected var _actions:Dictionary;
      
      protected var _events:Dictionary;
      
      protected var _sense_pairs:Dictionary;
      
      protected var _sense_links:Dictionary;
      
      protected var _lives:int = 0;
      
      protected var _penalty:int = 0;
      
      protected var _score:int = 0;
      
      protected var _timeElapsed:int = 0;
      
      protected var _timeInterval:int;
      
      protected var _ended:Boolean = false;
      
      protected var _won:Boolean = false;
      
      protected var _loseIfNotWon:Boolean = false;
      
      protected var _loseNextFrame:Boolean = false;
      
      protected var _lastEventPos:Point;
      
      public function EventHandler(param1:Simulation, param2:Model, param3:Environment)
      {
         super();
         this._sim = param1;
         this._model = param2;
         this._environment = param3;
         ++_nextID;
         this._id = _nextID;
         this._actions = new Dictionary();
         this._events = new Dictionary();
         this._sense_pairs = new Dictionary();
         this._sense_links = new Dictionary();
         this._lives = this._environment.total_lives;
         this._lastEventPos = new Point();
         this._timeInterval = setInterval(this.updateElapsedTime,250);
      }
      
      public function get lives() : int
      {
         return this._lives;
      }
      
      public function get penalty() : int
      {
         return this._penalty;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function get timeElapsed() : int
      {
         return this._timeElapsed;
      }
      
      public function get lastEventPos() : Point
      {
         return this._lastEventPos;
      }
      
      public function get ended() : Boolean
      {
         return this._ended;
      }
      
      public function get won() : Boolean
      {
         return this._won;
      }
      
      protected function endGame(param1:Boolean = false) : void
      {
         if(this._ended)
         {
            return;
         }
         this._won = param1;
         this._ended = true;
         this.stopTimer();
         totalTime += this._timeElapsed;
         totalScore += this._score;
         if(this._won)
         {
            this._sim.playSound(null,Sounds.WINLEVEL,1,false);
         }
         else
         {
            this._sim.playSound(null,Sounds.LOSEGAME,1,false);
         }
         dispatchEvent(new Event(States.ACTION_ENDGAME));
      }
      
      public function checkEndGameStatus() : void
      {
         if(this._ended)
         {
            return;
         }
         if(this._loseNextFrame && !this._won)
         {
            this._score = 0;
            this.endGame();
         }
         else if(this._loseIfNotWon && !this._won)
         {
            this._loseNextFrame = true;
         }
      }
      
      protected function updateElapsedTime() : void
      {
         this._timeElapsed = this._sim.frame / 42;
         if(this._environment.total_time > 0)
         {
            if(this._timeElapsed >= this._environment.total_time)
            {
               if(this._environment.total_score > 0 && this._score < this._environment.total_score)
               {
                  this._loseIfNotWon = true;
               }
               else
               {
                  this.endGame(true);
               }
            }
         }
      }
      
      protected function stopTimer() : void
      {
         if(this._timeInterval)
         {
            clearInterval(this._timeInterval);
         }
         this._timeInterval = 0;
      }
      
      public function registerActions(param1:ModelObject) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = param1.props.actions;
         var _loc5_:String = _loc4_.toString(16);
         while(_loc5_.length < States.ACTIONS.length)
         {
            _loc5_ = "0" + _loc5_;
         }
         var _loc6_:String = "";
         _loc2_ = 0;
         while(_loc2_ < States.ACTIONS.length)
         {
            _loc6_ = parseInt(_loc5_.charAt(_loc2_),16).toString(2);
            while(_loc6_.length < States.EVENTS.length)
            {
               _loc6_ = "0" + _loc6_;
            }
            _loc3_ = 0;
            while(_loc3_ < States.EVENTS.length)
            {
               this._actions[this.getActionKey(param1,_loc3_,_loc2_)] = _loc6_.charAt(_loc3_) == "1";
               this._events[this.getEventKey(param1,_loc3_)] = this._events[this.getEventKey(param1,_loc3_)] || _loc6_.charAt(_loc3_) == "1";
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function hasActionForEvent(param1:ModelObject, param2:int) : Boolean
      {
         return this._events[this.getEventKey(param1,param2)] === true;
      }
      
      protected function processActions(param1:PhysObj, param2:int, param3:Boolean = false) : void
      {
         var _loc5_:Point = null;
         if(this._ended)
         {
            return;
         }
         var _loc4_:ModelObject = param1.data as ModelObject;
         if(_loc4_)
         {
            this._lastEventPos.x = param1.px;
            this._lastEventPos.y = param1.py;
            if(!param3)
            {
               if(this._actions[this.getActionKey(_loc4_,param2,0)])
               {
                  ++this._score;
                  dispatchEvent(new Event(States.ACTION_SCORE));
                  this._sim.playSound(param1,Sounds.SCORE,1,false);
                  if(this._environment.total_score > 0 && this._score >= this._environment.total_score)
                  {
                     this.endGame(true);
                  }
               }
               if(this._actions[this.getActionKey(_loc4_,param2,1)])
               {
                  ++this._penalty;
                  this._sim.playSound(param1,Sounds.PENALTY,1,false);
                  if(this._environment.total_penalties > 0 && this._penalty >= this._environment.total_penalties)
                  {
                     --this._lives;
                     this._penalty = 0;
                     dispatchEvent(new Event(States.ACTION_LOSELIFE));
                  }
                  dispatchEvent(new Event(States.ACTION_PENALTY));
               }
               if(this._actions[this.getActionKey(_loc4_,param2,2)])
               {
                  --this._lives;
                  dispatchEvent(new Event(States.ACTION_LOSELIFE));
                  this._sim.playSound(param1,Sounds.LOSELIFE,1,false);
               }
               if(this._actions[this.getActionKey(_loc4_,param2,3)])
               {
                  ++this._lives;
                  dispatchEvent(new Event(States.ACTION_ADDLIFE));
                  this._sim.playSound(param1,Sounds.ADDLIFE,1,false);
               }
            }
            if(this._actions[this.getActionKey(_loc4_,param2,4)])
            {
               this._sim.unlockObject(param1);
               this._sim.playSound(param1,Sounds.UNLOCK);
            }
            if(this._actions[this.getActionKey(_loc4_,param2,5)])
            {
               this._sim.removeObject(param1,View.EFFECT_BLOOM);
            }
            if(this._actions[this.getActionKey(_loc4_,param2,6)])
            {
               this._sim.explodeObject(param1);
            }
            if(!this._won && (this._environment.total_lives > 0 && this._lives == 0 || this._actions[this.getActionKey(_loc4_,param2,7)]))
            {
               while(this._lives > 0)
               {
                  --this._lives;
                  _loc5_ = this._lastEventPos.clone();
                  this._lastEventPos.x = _loc5_.x + Math.random() * 80 - 40;
                  this._lastEventPos.y = _loc5_.y + Math.random() * 80 - 40;
                  dispatchEvent(new Event(States.ACTION_LOSELIFE));
               }
               this._loseIfNotWon = true;
               return;
            }
         }
      }
      
      protected function getEventKey(param1:ModelObject, param2:int) : String
      {
         return param1.id + "_" + param2;
      }
      
      protected function getActionKey(param1:ModelObject, param2:int, param3:int) : String
      {
         return param1.id + "_" + param2 + "_" + param3;
      }
      
      protected function getSensePairKey(param1:PhysObj, param2:PhysObj) : String
      {
         return param1.id < param2.id ? param1.id + "_" + param2.id : param2.id + "_" + param1.id;
      }
      
      protected function checkSensorLinks(param1:PhysObj, param2:PhysObj) : Boolean
      {
         var _loc4_:Modifier = null;
         var _loc5_:PhysObj = null;
         var _loc6_:PhysObj = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc3_:Vector.<Modifier> = null;
         if(Boolean(param1) && this._sense_links[param1] is Vector.<Modifier>)
         {
            _loc3_ = this._sense_links[param1];
            this._sense_links[param1] = null;
            delete this._sense_links[param1];
            _loc6_ = param2;
         }
         else if(Boolean(param2) && this._sense_links[param2] is Vector.<Modifier>)
         {
            _loc3_ = this._sense_links[param2];
            this._sense_links[param2] = null;
            delete this._sense_links[param2];
            _loc6_ = param1;
         }
         if(Boolean(_loc3_) && Boolean(_loc6_))
         {
            _loc8_ = int(_loc3_.length);
            while(_loc8_--)
            {
               _loc4_ = _loc3_.pop();
               if((_loc4_) && _loc4_.props && _loc4_.props.child && this._sim.bodies[_loc4_.props.child] is PhysObj)
               {
                  _loc5_ = this._sim.bodies[_loc4_.props.child];
                  _loc7_ = this.getSensePairKey(_loc5_,_loc6_);
                  if(this._sense_pairs[_loc7_] == null)
                  {
                     this.processActions(this._sim.bodies[_loc4_.props.child],0,true);
                  }
                  this._sense_pairs[_loc7_] = true;
               }
            }
            return true;
         }
         return false;
      }
      
      public function handleSensorEvent(param1:Callback) : void
      {
         var _loc2_:PhysObj = null;
         var _loc3_:PhysObj = null;
         var _loc4_:String = null;
         var _loc5_:ModelObject = null;
         var _loc6_:ModelObject = null;
         if(this._ended)
         {
            return;
         }
         if(param1.obj_arb && param1.obj_arb.p1 && Boolean(param1.obj_arb.p2))
         {
            _loc2_ = param1.obj_arb.p1;
            _loc3_ = param1.obj_arb.p2;
            if(_loc2_ && _loc2_.added_to_space && _loc3_ && _loc3_.added_to_space)
            {
               _loc4_ = this.getSensePairKey(_loc2_,_loc3_);
               this.checkSensorLinks(_loc2_,_loc3_);
               if(this._sense_pairs[_loc4_])
               {
                  return;
               }
               this._sense_pairs[_loc4_] = true;
               _loc5_ = _loc2_.data as ModelObject;
               _loc6_ = _loc3_.data as ModelObject;
               if(Boolean(_loc5_) && this.hasActionForEvent(_loc5_,0))
               {
                  this.processActions(_loc2_,0);
                  this._sim.playSound(_loc2_,Sounds.SENSOR,0.5);
                  if(_loc2_.graphic is ViewSprite)
                  {
                     ViewSprite(_loc2_.graphic).bling();
                  }
               }
               if(Boolean(_loc6_) && this.hasActionForEvent(_loc6_,0))
               {
                  this.processActions(_loc3_,0);
                  this._sim.playSound(_loc3_,Sounds.SENSOR,0.5);
                  if(_loc3_.graphic is ViewSprite)
                  {
                     ViewSprite(_loc3_.graphic).bling();
                  }
               }
            }
         }
      }
      
      public function handleClickSensorEvent(param1:PhysObj) : void
      {
         var _loc2_:ModelObject = null;
         if(this._ended)
         {
            return;
         }
         if(Boolean(param1) && param1.added_to_space)
         {
            _loc2_ = param1.data as ModelObject;
            this.checkEventLinks(param1,0);
            if(Boolean(_loc2_) && this.hasActionForEvent(_loc2_,0))
            {
               this.processActions(param1,0);
               this._sim.playSound(param1,Sounds.SENSOR,0.5);
               if(param1.graphic is ViewSprite)
               {
                  ViewSprite(param1.graphic).bling();
               }
            }
         }
      }
      
      public function handleCrushEvent(param1:PhysObj) : void
      {
         var _loc2_:ModelObject = null;
         if(this._ended)
         {
            return;
         }
         if(Boolean(param1) && param1.added_to_space)
         {
            _loc2_ = param1.data as ModelObject;
            this.checkEventLinks(param1,1);
            if(Boolean(_loc2_) && this.hasActionForEvent(_loc2_,1))
            {
               this.processActions(param1,1);
            }
         }
      }
      
      protected function checkEventLinks(param1:PhysObj, param2:int) : Boolean
      {
         var _loc4_:Modifier = null;
         var _loc5_:PhysObj = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc3_:Vector.<Modifier> = null;
         if(Boolean(param1) && this._sense_links[param1] is Vector.<Modifier>)
         {
            _loc3_ = this._sense_links[param1];
            this._sense_links[param1] = null;
            delete this._sense_links[param1];
         }
         if(Boolean(_loc3_) && Boolean(param1))
         {
            _loc7_ = int(_loc3_.length);
            while(_loc7_--)
            {
               _loc4_ = _loc3_.pop();
               if((_loc4_) && _loc4_.props && _loc4_.props.child && this._sim.bodies[_loc4_.props.child] is PhysObj)
               {
                  _loc5_ = this._sim.bodies[_loc4_.props.child];
                  if(_loc5_)
                  {
                     this.processActions(_loc5_,param2,true);
                  }
               }
            }
            return true;
         }
         return false;
      }
      
      public function handleEmptyEvent(param1:PhysObj, param2:Modifier = null) : void
      {
         var _loc3_:ModelObject = null;
         if(this._ended)
         {
            return;
         }
         if(Boolean(param1) && param1.added_to_space)
         {
            _loc3_ = param1.data as ModelObject;
            if(Boolean(param2) && this._sim.bodies[param2.props.parent] is PhysObj)
            {
               this.checkEventLinks(this._sim.bodies[param2.props.parent],2);
            }
            if(Boolean(_loc3_) && this.hasActionForEvent(_loc3_,2))
            {
               this.processActions(param1,2);
            }
         }
      }
      
      public function handleOutOfBoundsEvent(param1:PhysObj) : void
      {
         var _loc2_:ModelObject = null;
         if(this._ended)
         {
            return;
         }
         if(param1)
         {
            _loc2_ = param1.data as ModelObject;
            this.checkEventLinks(param1,3);
            if(Boolean(_loc2_) && this.hasActionForEvent(_loc2_,3))
            {
               this.processActions(param1,3);
               this._sim.removeObject(param1);
            }
         }
      }
      
      public function addSensorLink(param1:PhysObj, param2:Modifier) : void
      {
         if(this._sense_links[param1] == undefined)
         {
            this._sense_links[param1] = new Vector.<Modifier>();
         }
         this._sense_links[param1].push(param2);
      }
      
      public function end() : void
      {
         this.stopTimer();
      }
   }
}

