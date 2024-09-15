package com.sploder.builder.model
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ModelSelection extends ModelObjectContainer
   {
      protected var _model:Model;
      
      protected var _controller:ModelController;
      
      protected var _container:Sprite;
      
      protected var _allowMultiple:Boolean = true;
      
      protected var _rect:Rectangle;
      
      public function ModelSelection(param1:Model, param2:ModelController, param3:Sprite)
      {
         this._model = param1;
         this._controller = param2;
         this._container = param3;
         this._rect = new Rectangle();
         super();
         _id = 0;
      }
      
      public function get allowMultiple() : Boolean
      {
         return this._allowMultiple;
      }
      
      public function set allowMultiple(param1:Boolean) : void
      {
         this._allowMultiple = param1;
      }
      
      public function get rect() : Rectangle
      {
         return this._rect;
      }
      
      override public function addObject(param1:ModelObject) : Boolean
      {
         if(!this._allowMultiple)
         {
            clear();
         }
         if(super.addObject(param1))
         {
            param1.state = ModelObject.STATE_SELECTED;
            return true;
         }
         return false;
      }
      
      override public function removeObject(param1:ModelObject) : Boolean
      {
         if(super.removeObject(param1))
         {
            param1.state = ModelObject.STATE_IDLE;
            return true;
         }
         return false;
      }
      
      public function startSelection() : void
      {
         this._container.graphics.clear();
         this._rect.x = this._controller.mouseVector.x;
         this._rect.y = this._controller.mouseVector.y;
      }
      
      public function updateSelection() : void
      {
         clear();
         this._rect.width = this._controller.dragVector.x;
         this._rect.height = this._controller.dragVector.y;
         var _loc1_:Graphics = this._container.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,65535);
         _loc1_.beginFill(65535,0.25);
         _loc1_.drawRect(this._rect.x,this._rect.y,this._rect.width,this._rect.height);
         var _loc2_:Vector.<ModelObject> = this._model.objects.filter(this.objectIsWithinSelectionWindow);
         _loc2_.forEach(this.selectObject);
      }
      
      public function endSelection() : void
      {
         this._container.graphics.clear();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function sortSpatially() : void
      {
         var _loc1_:Array = [];
         var _loc2_:int = int(_objects.length);
         while(_loc2_--)
         {
            _loc1_.unshift({
               "o":_objects[_loc2_],
               "x":_objects[_loc2_].x,
               "y":_objects[_loc2_].y
            });
         }
         _loc1_.sortOn(["y","x"],[Array.NUMERIC,Array.NUMERIC]);
         _loc2_ = int(_objects.length);
         while(_loc2_--)
         {
            _objects.pop();
         }
         _loc2_ = int(_loc1_.length);
         while(_loc2_--)
         {
            _objects.unshift(_loc1_[_loc2_].o);
         }
      }
      
      public function duplicateObjects() : void
      {
         var _loc1_:Vector.<ModelObject> = new Vector.<ModelObject>();
         var _loc2_:int = int(_objects.length);
         while(_loc2_--)
         {
            _loc1_.unshift(_objects[_loc2_].clone());
         }
         clear();
         this._model.addObjects(_loc1_);
         addObjects(_loc1_);
      }
      
      override public function destroyObjects() : void
      {
         this._model.removeObjects(_objects);
         super.destroyObjects();
      }
      
      public function drag() : void
      {
         _objects.forEach(this.dragObject);
      }
      
      public function drop() : void
      {
         _objects.forEach(this.dropObject);
      }
      
      public function selectionContainsGroup() : Boolean
      {
         var _loc1_:int = int(_objects.length);
         while(_loc1_--)
         {
            if(_objects[_loc1_].group)
            {
               return true;
            }
         }
         return false;
      }
      
      public function selectionIsSingleGroup() : Boolean
      {
         return _objects.length > 1 && Boolean(_objects[0].group) && _objects[0].group.length == _objects.length;
      }
      
      protected function objectIsWithinSelectionWindow(param1:ModelObject, param2:int, param3:Vector.<ModelObject>) : Boolean
      {
         return Boolean(param1) && Boolean(param1.clip) ? param1.clip.visible && param1.clip.hitTestObject(this._container) : false;
      }
      
      protected function selectObject(param1:ModelObject, param2:int, param3:Vector.<ModelObject>) : void
      {
         if(param1.group == null)
         {
            this.addObject(param1);
         }
         else
         {
            addObjects(param1.group.objects);
         }
      }
      
      protected function dragObject(param1:ModelObject, param2:int, param3:Vector.<ModelObject>) : void
      {
         var _loc4_:Point = this._controller.dragVector;
         param1.state = ModelObject.STATE_DRAGGING;
         param1.offset.x = this._controller.snap ? Math.round(_loc4_.x / 10) * 10 : _loc4_.x;
         param1.offset.y = this._controller.snap ? Math.round(_loc4_.y / 10) * 10 : _loc4_.y;
         param1.update();
      }
      
      protected function dropObject(param1:ModelObject, param2:int, param3:Vector.<ModelObject>) : void
      {
         var _loc4_:Point = this._controller.dragVector;
         param1.offset.x = param1.offset.y = 0;
         param1.origin.x += this._controller.snap ? Math.round(_loc4_.x / 10) * 10 : _loc4_.x;
         param1.origin.y += this._controller.snap ? Math.round(_loc4_.y / 10) * 10 : _loc4_.y;
         param1.state = ModelObject.STATE_SELECTED;
      }
      
      public function moveSelection(param1:int = 0, param2:int = 0) : void
      {
         var _loc3_:int = int(_objects.length);
         while(_loc3_--)
         {
            _objects[_loc3_].origin.x += param1;
            _objects[_loc3_].origin.y += param2;
            _objects[_loc3_].update();
         }
      }
   }
}

