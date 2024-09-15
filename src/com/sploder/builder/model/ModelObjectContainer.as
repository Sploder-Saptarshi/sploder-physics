package com.sploder.builder.model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class ModelObjectContainer extends EventDispatcher
   {
      protected static var _nextID:int = 1;
      
      protected var _id:int = 0;
      
      protected var _objects:Vector.<ModelObject>;
      
      protected var _pasteIDs:Dictionary;
      
      public function ModelObjectContainer()
      {
         super();
         this.init();
      }
      
      public static function resetNextID() : void
      {
         _nextID = 1;
      }
      
      public function get objects() : Vector.<ModelObject>
      {
         return this._objects;
      }
      
      public function get length() : uint
      {
         return this._objects.length;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      protected function init(param1:Event = null) : void
      {
         this._id = _nextID;
         ++_nextID;
         this._objects = new Vector.<ModelObject>();
         this._pasteIDs = new Dictionary();
      }
      
      public function addObject(param1:ModelObject) : Boolean
      {
         if(this._objects.indexOf(param1) == -1)
         {
            this._objects.push(param1);
            dispatchEvent(new Event(Event.CHANGE));
            param1.addEventListener(Event.CLEAR,this.onObjectDestroy);
            return true;
         }
         return false;
      }
      
      public function addObjects(param1:Vector.<ModelObject>) : void
      {
         var _loc2_:int = int(param1.length);
         while(_loc2_--)
         {
            this.addObject(param1[_loc2_]);
         }
      }
      
      public function removeObject(param1:ModelObject) : Boolean
      {
         if(this._objects.indexOf(param1) != -1)
         {
            this._objects.splice(this._objects.indexOf(param1),1);
            param1.removeEventListener(Event.CLEAR,this.onObjectDestroy);
            dispatchEvent(new Event(Event.CHANGE));
            return true;
         }
         return false;
      }
      
      public function removeObjects(param1:Vector.<ModelObject>) : void
      {
         var _loc2_:int = int(param1.length);
         while(_loc2_--)
         {
            this.removeObject(param1[_loc2_]);
         }
      }
      
      protected function onObjectDestroy(param1:Event) : void
      {
         this.removeObject(param1.target as ModelObject);
      }
      
      public function destroyObjects() : void
      {
         var _loc1_:Vector.<ModelObject> = this._objects.concat();
         var _loc2_:int = int(_loc1_.length);
         while(_loc2_--)
         {
            this.removeObject(_loc1_[_loc2_]);
            _loc1_[_loc2_].destroy();
         }
      }
      
      public function contains(param1:ModelObject) : Boolean
      {
         return this._objects.indexOf(param1) != -1;
      }
      
      public function getObjectByPasteID(param1:int) : ModelObject
      {
         if(Boolean(this._pasteIDs) && Boolean(this._pasteIDs[param1]))
         {
            return this.getObjectByID(this._pasteIDs[param1]);
         }
         return null;
      }
      
      public function getObjectByID(param1:int) : ModelObject
      {
         var _loc2_:int = int(this._objects.length);
         while(_loc2_--)
         {
            if(this._objects[_loc2_].id == param1)
            {
               return this._objects[_loc2_];
            }
         }
         return null;
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
         return param1.join("|");
      }
      
      override public function toString() : String
      {
         return this._objects.join("|");
      }
      
      public function fromString(param1:String) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:ModelObject = null;
         var _loc5_:Modifier = null;
         var _loc6_:ModelObjectContainer = null;
         var _loc7_:int = 0;
         var _loc2_:Array = [];
         this._pasteIDs = new Dictionary();
         var _loc8_:Array = param1.split("$");
         var _loc9_:Array = String(_loc8_[0]).split("|");
         var _loc10_:Dictionary = new Dictionary();
         _loc3_ = 0;
         while(_loc3_ < _loc9_.length)
         {
            if(Boolean(_loc9_[_loc3_]) && Boolean(String(_loc9_[_loc3_]).length))
            {
               _loc4_ = new ModelObject();
               _loc7_ = _loc4_.fromString(_loc9_[_loc3_]);
               this.addObject(_loc4_);
               this._pasteIDs[_loc7_] = _loc4_.id;
               if(_loc4_.groupID > 0)
               {
                  if(_loc10_[_loc4_.groupID] == null)
                  {
                     _loc10_[_loc4_.groupID] = new ModelObjectContainer();
                  }
                  _loc6_ = _loc10_[_loc4_.groupID];
                  _loc6_.addObject(_loc4_);
                  _loc4_.group = _loc6_;
               }
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

