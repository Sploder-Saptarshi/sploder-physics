package com.sploder.builder.model
{
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.game.States;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ModifierContainer extends EventDispatcher
   {
      protected var _model:Model;
      
      protected var _container:Sprite;
      
      protected var _objects:Vector.<Modifier>;
      
      protected var _focusObject:Modifier;
      
      public function ModifierContainer(param1:Model, param2:Sprite)
      {
         super();
         this._model = param1;
         this._container = param2;
         this.init();
      }
      
      public function get objects() : Vector.<Modifier>
      {
         return this._objects;
      }
      
      public function get model() : Model
      {
         return this._model;
      }
      
      public function get length() : uint
      {
         return this._objects.length;
      }
      
      public function get focusObject() : Modifier
      {
         return this._focusObject;
      }
      
      public function set focusObject(param1:Modifier) : void
      {
         if(this._focusObject)
         {
            this._focusObject.state = Modifier.STATE_IDLE;
         }
         this._focusObject = param1;
         if(this._focusObject)
         {
            this._focusObject.state = Modifier.STATE_SELECTED;
            if(this._focusObject.clip.parent == this._container)
            {
               this._container.setChildIndex(this._focusObject.clip,this._container.numChildren - 1);
            }
         }
         dispatchEvent(new Event(Event.SELECT));
      }
      
      protected function init(param1:Event = null) : void
      {
         this._objects = new Vector.<Modifier>();
      }
      
      public function addObject(param1:Modifier) : Boolean
      {
         if(this._objects.indexOf(param1) == -1)
         {
            this._objects.push(param1);
            this._container.addChild(param1.clip);
            param1.container = this;
            param1.addEventListener(Event.CLEAR,this.onObjectDestroy);
            dispatchEvent(new Event(Event.CHANGE));
            return true;
         }
         return false;
      }
      
      public function addObjects(param1:Vector.<Modifier>) : void
      {
         var _loc2_:int = int(param1.length);
         while(_loc2_--)
         {
            this.addObject(param1[_loc2_]);
         }
      }
      
      public function removeObject(param1:Modifier) : Boolean
      {
         if(this._objects.indexOf(param1) != -1)
         {
            this._objects.splice(this._objects.indexOf(param1),1);
            param1.removeEventListener(Event.CLEAR,this.onObjectDestroy);
            if(Boolean(param1.clip) && param1.clip.parent == this._container)
            {
               this._container.removeChild(param1.clip);
            }
            dispatchEvent(new Event(Event.CHANGE));
            return true;
         }
         return false;
      }
      
      public function removeObjects(param1:Vector.<Modifier>) : void
      {
         var _loc2_:int = int(param1.length);
         while(_loc2_--)
         {
            this.removeObject(param1[_loc2_]);
         }
      }
      
      public function removeModifiersOnObject(param1:ModelObject) : void
      {
         var _loc3_:Modifier = null;
         var _loc2_:int = int(this._objects.length);
         while(_loc2_--)
         {
            _loc3_ = this._objects[_loc2_];
            if(Boolean(_loc3_) && Boolean(_loc3_.props))
            {
               if(_loc3_.props.parent == param1 || _loc3_.props.child == param1)
               {
                  this.removeObject(_loc3_);
               }
            }
         }
      }
      
      protected function onObjectDestroy(param1:Event) : void
      {
         this.removeObject(param1.target as Modifier);
         dispatchEvent(new Event(Event.CLEAR));
      }
      
      public function destroyObjects() : void
      {
         var _loc1_:Vector.<Modifier> = this._objects.concat();
         var _loc2_:int = int(_loc1_.length);
         while(_loc2_--)
         {
            this.removeObject(_loc1_[_loc2_]);
            _loc1_[_loc2_].destroy();
         }
      }
      
      public function contains(param1:Modifier) : Boolean
      {
         return this._objects.indexOf(param1) != -1;
      }
      
      public function getByType(param1:String) : Modifier
      {
         var _loc2_:int = int(this._objects.length);
         while(_loc2_--)
         {
            if(this._objects[_loc2_].props.type == param1)
            {
               return this._objects[_loc2_];
            }
         }
         return null;
      }
      
      public function getAllOfType(param1:String) : Vector.<Modifier>
      {
         var _loc2_:Vector.<Modifier> = new Vector.<Modifier>();
         var _loc3_:int = int(this._objects.length);
         while(_loc3_--)
         {
            if(this._objects[_loc3_].props.type == param1)
            {
               _loc2_.unshift(this._objects[_loc3_]);
            }
         }
         return _loc2_;
      }
      
      public function containsType(param1:String) : Boolean
      {
         var _loc2_:int = int(this._objects.length);
         while(_loc2_--)
         {
            if(this._objects[_loc2_].props.type == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function objContainsType(param1:ModelObject, param2:String) : Boolean
      {
         var _loc3_:int = int(this._objects.length);
         while(_loc3_--)
         {
            if(this._objects[_loc3_].props.type == param2 && this._objects[_loc3_].props.parent == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clear() : void
      {
         if(this._objects.length == 0)
         {
            return;
         }
         var _loc1_:int = int(this._objects.length);
         while(_loc1_--)
         {
            this.removeObject(this._objects[_loc1_]);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function selectionToString(param1:Vector.<ModelObject>) : String
      {
         var _loc3_:Modifier = null;
         var _loc2_:Array = [];
         var _loc4_:int = int(this._objects.length);
         while(_loc4_--)
         {
            _loc3_ = this._objects[_loc4_];
            if(_loc3_ && _loc3_.props && _loc3_.props.parent && param1.indexOf(_loc3_.props.parent) != -1)
            {
               _loc2_.unshift(_loc3_.toString());
            }
         }
         return _loc2_.join("|");
      }
      
      override public function toString() : String
      {
         return this._objects.join("|");
      }
      
      public function fromString(param1:String) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:Modifier = null;
         var _loc2_:Array = [];
         var _loc5_:Array = param1.split("|");
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            if(Boolean(_loc5_[_loc3_]) && Boolean(String(_loc5_[_loc3_]).length))
            {
               _loc4_ = new Modifier();
               _loc4_.fromString(_loc5_[_loc3_]);
               this.addObject(_loc4_);
               _loc4_.clip.draw();
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getControls() : Array
      {
         var _loc1_:Modifier = null;
         var _loc2_:Array = [];
         if(this.containsType(CreatorUIStates.MODIFIER_SELECTOR))
         {
            _loc2_.push(States.CONTROLS_MOUSE);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_MOVER))
         {
            _loc2_.push(States.CONTROLS_UPDOWN);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_SLIDER))
         {
            _loc2_.push(States.CONTROLS_LEFTRIGHT);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_ARCADEMOVER))
         {
            _loc2_.push(States.CONTROLS_UPDOWN);
            _loc2_.push(States.CONTROLS_LEFTRIGHT);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_ROTATOR))
         {
            _loc2_.push(States.CONTROLS_LEFTRIGHT);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_JUMPER))
         {
            _loc2_.push(States.CONTROLS_UPDOWN);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_AIMER))
         {
            _loc2_.push(States.CONTROLS_MOUSE);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_ADDER))
         {
            _loc1_ = this.getByType(CreatorUIStates.MODIFIER_AIMER);
            if(Boolean(_loc1_) && _loc1_.props.optionA)
            {
               _loc2_.push(States.CONTROLS_MOUSE);
            }
            else
            {
               _loc2_.push(States.CONTROLS_SPACEBAR);
            }
         }
         if(this.containsType(CreatorUIStates.MODIFIER_FACTORY))
         {
            _loc1_ = this.getByType(CreatorUIStates.MODIFIER_FACTORY);
            if(Boolean(_loc1_) && _loc1_.props.optionA)
            {
               _loc2_.push(States.CONTROLS_MOUSE);
            }
            else
            {
               _loc2_.push(States.CONTROLS_SPACEBAR);
            }
         }
         if(this.containsType(CreatorUIStates.MODIFIER_LAUNCHER))
         {
            _loc2_.push(States.CONTROLS_MOUSE);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_EMAGNET))
         {
            _loc2_.push(States.CONTROLS_SPACEBAR);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_DRAGGER))
         {
            _loc2_.push(States.CONTROLS_MOUSE);
         }
         if(this.containsType(CreatorUIStates.MODIFIER_CLICKER))
         {
            _loc2_.push(States.CONTROLS_MOUSE);
         }
         return _loc2_;
      }
      
      public function guessInstructions() : String
      {
         var _loc1_:Modifier = null;
         var _loc3_:Vector.<Modifier> = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc2_:Array = [];
         if(this.containsType(CreatorUIStates.MODIFIER_SELECTOR))
         {
            _loc2_.push("First, select objects to control with the mouse.");
         }
         if(this.containsType(CreatorUIStates.MODIFIER_MOVER) && this.containsType(CreatorUIStates.MODIFIER_SLIDER))
         {
            _loc2_.push("Move with the arrow keys or WASD.");
         }
         else if(this.containsType(CreatorUIStates.MODIFIER_MOVER))
         {
            _loc2_.push("Move with the UP and DOWN arrow keys or W,S.");
         }
         else if(this.containsType(CreatorUIStates.MODIFIER_SLIDER))
         {
            _loc2_.push("Move with the LEFT and RIGHT arrow keys or A,D.");
         }
         if(this.containsType(CreatorUIStates.MODIFIER_ROTATOR))
         {
            _loc2_.push("Turn with the LEFT and RIGHT arrow keys or A,D.");
         }
         if(this.containsType(CreatorUIStates.MODIFIER_JUMPER))
         {
            _loc2_.push("Jump with the UP arrow.");
         }
         if(this.containsType(CreatorUIStates.MODIFIER_THRUSTER))
         {
            _loc3_ = this.getAllOfType(CreatorUIStates.MODIFIER_THRUSTER);
            _loc4_ = int(_loc3_.length);
            if(_loc4_ == 1)
            {
               _loc2_.push("Thrust with the " + String.fromCharCode(_loc3_[0].props.amount) + " key.");
            }
            else
            {
               _loc5_ = [];
               while(_loc4_--)
               {
                  _loc5_.push(String.fromCharCode(_loc3_[_loc4_].props.amount));
               }
               _loc2_.push("Thrust with the " + _loc5_.join(",") + " keys.");
            }
         }
         if(this.containsType(CreatorUIStates.MODIFIER_AIMER))
         {
            _loc2_.push("Aim with the mouse.");
         }
         if(this.containsType(CreatorUIStates.MODIFIER_ADDER))
         {
            _loc1_ = this.getByType(CreatorUIStates.MODIFIER_AIMER);
            if(Boolean(_loc1_) && _loc1_.props.optionA)
            {
               _loc2_.push("Shoot with the mouse button.");
            }
            else
            {
               _loc2_.push("Shoot with the SPACEBAR.");
            }
         }
         if(this.containsType(CreatorUIStates.MODIFIER_FACTORY))
         {
            _loc1_ = this.getByType(CreatorUIStates.MODIFIER_FACTORY);
            if(Boolean(_loc1_) && _loc1_.props.optionA)
            {
               _loc2_.push("Add objects with the mouse button.");
            }
            else
            {
               _loc2_.push("Add objects with the SPACEBAR.");
            }
         }
         if(this.containsType(CreatorUIStates.MODIFIER_LAUNCHER))
         {
            _loc2_.push("Launch objects from the launcher with the mouse button.");
         }
         if(this.containsType(CreatorUIStates.MODIFIER_EMAGNET))
         {
            _loc2_.push("Turn the electromagnet on and off with the SPACEBAR.");
         }
         if(this.containsType(CreatorUIStates.MODIFIER_DRAGGER))
         {
            _loc2_.push("Some objects can be dragged with the mouse.");
         }
         if(this.containsType(CreatorUIStates.MODIFIER_CLICKER))
         {
            _loc2_.push("Some objects can be clicked with the mouse.");
         }
         if(_loc2_.length == 0)
         {
            return "Your guess is as good as mine! :)";
         }
         return _loc2_.join(" ");
      }
      
      public function end() : void
      {
         if(this._objects)
         {
            this.removeObjects(this._objects);
         }
         this._container = null;
      }
   }
}

