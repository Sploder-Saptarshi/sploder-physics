package com.sploder.builder.model
{
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.data.DataManifest;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.describeType;
   
   public class ModifierProperties extends EventDispatcher
   {
      protected var _type:String;
      
      protected var _parent:ModelObject;
      
      protected var _child:ModelObject;
      
      protected var _parentOffset:Point;
      
      protected var _childOffset:Point;
      
      protected var _amount:Number = 0;
      
      protected var _amount2:Number = 0;
      
      protected var _amount3:Number = 0;
      
      protected var _optionA:Boolean = false;
      
      protected var _optionB:Boolean = false;
      
      protected var _optionC:Boolean = false;
      
      public function ModifierProperties()
      {
         super();
         this._parentOffset = new Point();
         this._childOffset = new Point();
      }
      
      protected function onModelChange(param1:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get parent() : ModelObject
      {
         return this._parent;
      }
      
      public function set parent(param1:ModelObject) : void
      {
         var _loc2_:int = 0;
         if(this._parent)
         {
            this._parent.removeEventListener(Event.CHANGE,this.onModelChange);
            this._parent.removeEventListener(Event.CLEAR,this.onModelChange);
            if(this._type == CreatorUIStates.MODIFIER_FACTORY && Boolean(this._parent.group))
            {
               _loc2_ = int(this._parent.group.length);
               while(_loc2_--)
               {
                  this._parent.group.objects[_loc2_].removeEventListener(Event.CHANGE,this.onModelChange);
                  this._parent.group.objects[_loc2_].removeEventListener(Event.CLEAR,this.onModelChange);
               }
            }
         }
         this._parent = param1;
         if(this._parent)
         {
            this._parent.addEventListener(Event.CHANGE,this.onModelChange);
            this._parent.addEventListener(Event.CLEAR,this.onModelChange);
         }
         if(this._type == CreatorUIStates.MODIFIER_FACTORY && this._parent && Boolean(this._parent.group))
         {
            _loc2_ = int(this._parent.group.length);
            while(_loc2_--)
            {
               this._parent.group.objects[_loc2_].addEventListener(Event.CHANGE,this.onModelChange);
               this._parent.group.objects[_loc2_].addEventListener(Event.CLEAR,this.onModelChange);
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get child() : ModelObject
      {
         return this._child;
      }
      
      public function set child(param1:ModelObject) : void
      {
         if(this._child)
         {
            this._child.removeEventListener(Event.CHANGE,this.onModelChange);
            this._child.removeEventListener(Event.CLEAR,this.onModelChange);
         }
         this._child = param1;
         if(this._child)
         {
            this._child.addEventListener(Event.CHANGE,this.onModelChange);
            this._child.addEventListener(Event.CLEAR,this.onModelChange);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get parentOffset() : Point
      {
         return this._parentOffset;
      }
      
      public function setParentOffset(param1:int, param2:int) : void
      {
         this._parentOffset.x = param1;
         this._parentOffset.y = param2;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get childOffset() : Point
      {
         return this._childOffset;
      }
      
      public function get amount() : Number
      {
         return this._amount;
      }
      
      public function set amount(param1:Number) : void
      {
         this._amount = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get amount2() : Number
      {
         return this._amount2;
      }
      
      public function set amount2(param1:Number) : void
      {
         this._amount2 = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get amount3() : Number
      {
         return this._amount3;
      }
      
      public function set amount3(param1:Number) : void
      {
         this._amount3 = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get optionA() : Boolean
      {
         return this._optionA;
      }
      
      public function set optionA(param1:Boolean) : void
      {
         this._optionA = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get optionB() : Boolean
      {
         return this._optionB;
      }
      
      public function set optionB(param1:Boolean) : void
      {
         this._optionB = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get optionC() : Boolean
      {
         return this._optionC;
      }
      
      public function set optionC(param1:Boolean) : void
      {
         this._optionC = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function setChildOffset(param1:int, param2:int) : void
      {
         this._childOffset.x = param1;
         this._childOffset.y = param2;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function clone() : ModifierProperties
      {
         var _loc2_:String = null;
         var _loc4_:XML = null;
         var _loc1_:ModifierProperties = new ModifierProperties();
         var _loc3_:XMLList = describeType(_loc1_)..accessor;
         for each(_loc4_ in _loc3_)
         {
            _loc2_ = _loc4_.@name;
            if(_loc4_.@access == "readwrite" && _loc2_ != "size")
            {
               _loc1_[_loc2_] = this[_loc2_];
            }
         }
         _loc1_.setParentOffset(this._parentOffset.x,this._parentOffset.y);
         _loc1_.setChildOffset(this._childOffset.x,this._childOffset.y);
         return _loc1_;
      }
      
      override public function toString() : String
      {
         var _loc1_:Array = [DataManifest.stringMap.indexOf(this._type),!!this._parent ? this._parent.id : 0,DataManifest.pointToString(this._parentOffset),!!this._child ? this._child.id : 0,DataManifest.pointToString(this._childOffset),this._amount,this._amount2,this._amount3,this._optionA ? "1" : "0",this._optionB ? "1" : "0",this._optionC ? "1" : "0"];
         return _loc1_.join(";");
      }
      
      public function fromString(param1:String) : void
      {
         var _loc2_:Array = param1.split(";");
         this._type = DataManifest.stringMap[parseInt(_loc2_[0])];
         if(_loc2_[1])
         {
            this.parent = Model.mainInstance.getObjectByPasteID(parseInt(_loc2_[1]));
         }
         else
         {
            this.parent = null;
         }
         DataManifest.stringToPoint(_loc2_[2],this._parentOffset);
         if(_loc2_[3])
         {
            this.child = Model.mainInstance.getObjectByPasteID(parseInt(_loc2_[3]));
         }
         else
         {
            this.child = null;
         }
         DataManifest.stringToPoint(_loc2_[4],this._childOffset);
         this._amount = parseFloat(_loc2_[5]);
         this._amount2 = parseFloat(_loc2_[6]);
         this._amount3 = parseFloat(_loc2_[7]);
         this._optionA = _loc2_[8] == "1";
         this._optionB = _loc2_[9] == "1";
         this._optionC = _loc2_.length > 10 && _loc2_[10] == "1";
      }
   }
}

