package com.sploder.builder.model
{
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.data.DataManifest;
   import com.sploder.util.Closest;
   import com.sploder.util.Geom2d;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class ModelObject extends EventDispatcher
   {
      public static const STATE_NEW:int = 0;
      
      public static const STATE_IDLE:int = 1;
      
      public static const STATE_SELECTED:int = 2;
      
      public static const STATE_DRAGGING:int = 3;
      
      protected static var _nextID:int = 1;
      
      protected var _id:int = 0;
      
      protected var _props:ModelObjectProperties;
      
      protected var _deleted:Boolean = false;
      
      protected var _group:ModelObjectContainer;
      
      protected var _groupID:int = 0;
      
      protected var _clip:ModelObjectSprite;
      
      protected var _origin:Point;
      
      protected var _pin:Point;
      
      protected var _offset:Point;
      
      protected var _rotation:int = 0;
      
      protected var _state:int = 0;
      
      protected var _focused:Boolean = false;
      
      public function ModelObject(param1:ModelObject = null)
      {
         super();
         this.init(param1);
      }
      
      public static function resetNextID() : void
      {
         _nextID = 1;
      }
      
      public function get props() : ModelObjectProperties
      {
         return this._props;
      }
      
      public function get deleted() : Boolean
      {
         return this._deleted;
      }
      
      public function get clip() : ModelObjectSprite
      {
         return this._clip;
      }
      
      public function get origin() : Point
      {
         return this._origin;
      }
      
      public function get pin() : Point
      {
         return this._pin;
      }
      
      public function get offset() : Point
      {
         return this._offset;
      }
      
      public function get x() : Number
      {
         return this._origin.x + this._offset.x;
      }
      
      public function get y() : Number
      {
         return this._origin.y + this._offset.y;
      }
      
      public function get rotation() : int
      {
         return this._rotation;
      }
      
      public function set rotation(param1:int) : void
      {
         this._rotation = param1;
         this.update();
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(param1:int) : void
      {
         this._state = param1;
         this.update();
      }
      
      public function get group() : ModelObjectContainer
      {
         return this._group;
      }
      
      public function set group(param1:ModelObjectContainer) : void
      {
         if(this._group == null || param1 == null)
         {
            this._group = param1;
         }
         this._groupID = this._group == null ? 0 : this._group.id;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get groupID() : int
      {
         return this._groupID;
      }
      
      public function get focused() : Boolean
      {
         return this._focused;
      }
      
      public function set focused(param1:Boolean) : void
      {
         this._focused = param1;
         this.update();
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      protected function init(param1:ModelObject = null) : void
      {
         this._id = _nextID;
         ++_nextID;
         if(param1)
         {
            this._origin = param1.origin.clone();
            this._pin = param1.pin.clone();
            this._rotation = param1.rotation;
            this._props = param1.props.clone();
         }
         else
         {
            this._origin = new Point();
            this._pin = new Point();
            this._props = new ModelObjectProperties();
         }
         this._offset = new Point();
         this._clip = new ModelObjectSprite(this);
         this._props.addEventListener(Event.CHANGE,this.onChangeProps);
         this._clip.buttonMode = true;
      }
      
      public function update() : void
      {
         if(this._clip)
         {
            this._clip.draw();
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function updateFromVector(param1:Point, param2:Point, param3:String = "origin", param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Point = param1;
         var _loc11_:Point = param2;
         switch(param3)
         {
            case CreatorUIStates.TOP_LEFT:
            case CreatorUIStates.TOP_RIGHT:
            case CreatorUIStates.BOTTOM_LEFT:
            case CreatorUIStates.BOTTOM_RIGHT:
               if(this._rotation != 0)
               {
                  _loc10_ = _loc10_.clone();
                  Geom2d.rotate(_loc10_,0 - this._rotation * Geom2d.dtr);
                  _loc11_ = _loc11_.subtract(this._origin);
                  Geom2d.rotate(_loc11_,0 - this._rotation * Geom2d.dtr);
                  _loc11_ = _loc11_.add(this._origin);
                  param4 = false;
               }
               _loc6_ = _loc11_.y;
               _loc7_ = _loc11_.x;
               if(this._props.shape != CreatorUIStates.SHAPE_RAMP)
               {
                  _loc8_ = Math.abs(_loc10_.x);
                  _loc9_ = Math.abs(_loc10_.y);
               }
               else
               {
                  _loc8_ = _loc10_.x;
                  _loc9_ = _loc10_.y;
                  switch(param3)
                  {
                     case CreatorUIStates.TOP_RIGHT:
                        _loc9_ = 0 - _loc9_;
                        _loc6_ -= _loc9_;
                        break;
                     case CreatorUIStates.BOTTOM_LEFT:
                        _loc8_ = 0 - _loc8_;
                        _loc7_ -= _loc8_;
                  }
               }
               if(param4)
               {
                  _loc6_ = Math.round(_loc6_ / 10) * 10;
                  _loc7_ = Math.round(_loc7_ / 10) * 10;
                  _loc8_ = Math.round(_loc8_ / 10) * 10;
                  _loc9_ = Math.round(_loc9_ / 10) * 10;
               }
               if(this._props.shape != CreatorUIStates.SHAPE_RAMP)
               {
                  switch(param3)
                  {
                     case CreatorUIStates.TOP_LEFT:
                        _loc7_ -= _loc10_.x < 0 ? _loc8_ : 0 - _loc8_;
                        _loc6_ -= _loc10_.y < 0 ? _loc9_ : 0 - _loc9_;
                        if(_loc10_.x > 0)
                        {
                           _loc7_ -= _loc8_;
                        }
                        if(_loc10_.y > 0)
                        {
                           _loc6_ -= _loc9_;
                        }
                        break;
                     case CreatorUIStates.TOP_RIGHT:
                        _loc6_ -= _loc10_.y < 0 ? _loc9_ : 0 - _loc9_;
                        if(_loc10_.x < 0)
                        {
                           _loc7_ -= _loc8_;
                        }
                        if(_loc10_.y > 0)
                        {
                           _loc6_ -= _loc9_;
                        }
                        break;
                     case CreatorUIStates.BOTTOM_LEFT:
                        _loc7_ -= _loc10_.x < 0 ? _loc8_ : 0 - _loc8_;
                        if(_loc10_.x > 0)
                        {
                           _loc7_ -= _loc8_;
                        }
                        if(_loc10_.y < 0)
                        {
                           _loc6_ -= _loc9_;
                        }
                        break;
                     case CreatorUIStates.BOTTOM_RIGHT:
                        if(_loc10_.x < 0)
                        {
                           _loc7_ -= _loc8_;
                        }
                        if(_loc10_.y < 0)
                        {
                           _loc6_ -= _loc9_;
                        }
                  }
               }
               if(this._rotation == 0)
               {
                  this._origin.x = _loc7_;
                  this._origin.y = _loc6_;
                  this._origin.x += _loc8_ / 2;
                  this._origin.y += _loc9_ / 2;
               }
               else
               {
                  this._origin.x = param2.x + param1.x / 2;
                  this._origin.y = param2.y + param1.y / 2;
               }
               this._props.width = _loc8_;
               this._props.height = _loc9_;
               break;
            case CreatorUIStates.ORIGIN:
               if(this._props.shape != CreatorUIStates.SHAPE_BOX && this._props.shape != CreatorUIStates.SHAPE_POLY && this._props.shape != CreatorUIStates.SHAPE_RAMP)
               {
                  this._props.size = param4 ? int(Math.round(_loc10_.length / 10) * 10) : int(_loc10_.length);
               }
               this._rotation = Math.atan2(_loc10_.y,_loc10_.x) * 180 / Math.PI + 90;
               if(this._state == STATE_NEW && (this._props.shape == CreatorUIStates.SHAPE_SQUARE || this._props.shape == CreatorUIStates.SHAPE_CIRCLE))
               {
                  this._rotation = 0;
               }
               if(param5)
               {
                  this._rotation = Math.round(this._rotation / 45) * 45;
               }
               else if(param4)
               {
                  this._rotation = Math.round(this._rotation / 10) * 10;
               }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function onChangeProps(param1:Event) : void
      {
         this.update();
      }
      
      public function setPinPosition(param1:Point) : void
      {
         this._pin.x = param1.x;
         this._pin.y = param1.y;
         this.update();
      }
      
      public function localToGlobal(param1:Point) : Point
      {
         param1 = param1.clone();
         if(this.rotation != 0)
         {
            Geom2d.rotate(param1,this.rotation * Geom2d.dtr);
         }
         param1.x += this._origin.x;
         param1.y += this._origin.y;
         return param1;
      }
      
      public function centerVertices() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         if(this._rotation == 0 && this._props && Boolean(this._props.vertices))
         {
            _loc1_ = 10000;
            _loc2_ = -10000;
            _loc3_ = 10000;
            _loc4_ = -10000;
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = int(this._props.vertices.length);
            while(_loc9_--)
            {
               _loc1_ = Math.min(_loc1_,this._props.vertices[_loc9_].x);
               _loc2_ = Math.max(_loc2_,this._props.vertices[_loc9_].x);
               _loc3_ = Math.min(_loc3_,this._props.vertices[_loc9_].y);
               _loc4_ = Math.max(_loc4_,this._props.vertices[_loc9_].y);
            }
            _loc5_ = _loc2_ - _loc1_;
            _loc6_ = _loc4_ - _loc3_;
            _loc7_ = _loc1_ + _loc5_ / 2;
            _loc8_ = _loc3_ + _loc6_ / 2;
            _loc7_ += 0 - (_loc7_ + this._origin.x) % 5;
            _loc8_ += 0 - (_loc8_ + this._origin.y) % 5;
            _loc9_ = int(this._props.vertices.length);
            while(_loc9_--)
            {
               this._props.vertices[_loc9_].x -= _loc7_;
               this._props.vertices[_loc9_].y -= _loc8_;
            }
            this._origin.x += _loc7_;
            this._origin.y += _loc8_;
            this._props.width = Math.abs(_loc5_);
            this._props.height = Math.abs(_loc6_);
            this.update();
         }
      }
      
      public function setVertexPosition(param1:int, param2:Point) : void
      {
         if(this._props && this._props.vertices && this._props.vertices.length > param1)
         {
            if(this._rotation != 0)
            {
               param2 = param2.clone();
               Geom2d.rotate(param2,0 - this._rotation * Geom2d.dtr);
            }
            this._props.vertices[param1].x = Math.floor((param2.x - this.origin.x) / 10) * 10 + this.origin.x;
            this._props.vertices[param1].y = Math.floor((param2.y - this.origin.y) / 10) * 10 + this.origin.y;
            this.update();
         }
      }
      
      public function deleteVertex(param1:int) : void
      {
         if(this._props && this._props.vertices && this._props.vertices.length > param1)
         {
            this._props.vertices.splice(param1,1);
            this._clip.removeVertexHandle(param1);
            this.update();
         }
      }
      
      public function addVertex() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._props && this._props.vertices && this._props.vertices.length > 1)
         {
            _loc1_ = new Point(this._clip.mouseX,this._clip.mouseY);
            _loc2_ = [];
            _loc3_ = 0;
            while(_loc3_ < this._props.vertices.length)
            {
               _loc2_.push({
                  "index":_loc3_,
                  "dist":Closest.distanceFromLine(_loc1_,this._props.vertices[_loc3_],_loc3_ + 1 < this._props.vertices.length ? this._props.vertices[_loc3_ + 1] : this._props.vertices[0])
               });
               _loc3_++;
            }
            _loc2_.sortOn("dist",Array.NUMERIC);
            if(_loc2_.length > 1)
            {
               _loc4_ = _loc2_[0].index + 1;
               this._props.vertices.splice(_loc4_,0,_loc1_);
               this._clip.addVertexHandle();
               this.update();
            }
         }
      }
      
      public function isValid() : Boolean
      {
         if(Boolean(this._props) && this._props.shape == CreatorUIStates.SHAPE_POLY)
         {
            if(this._props.vertices)
            {
               return true;
            }
         }
         return !this._deleted && (this._props.width != 0 && this._props.height != 0);
      }
      
      public function clone() : ModelObject
      {
         return new ModelObject(this);
      }
      
      override public function toString() : String
      {
         if(this._deleted)
         {
            return "";
         }
         var _loc1_:Array = [this._id,DataManifest.pointToString(this._origin),DataManifest.pointToString(this._pin),this._rotation,this._groupID,this._props.toString()];
         return _loc1_.join("#");
      }
      
      public function fromString(param1:String) : int
      {
         var _loc2_:Array = param1.split("#");
         this._clip.suspend();
         var _loc3_:int = parseInt(_loc2_[0]);
         DataManifest.stringToPoint(_loc2_[1],this._origin);
         DataManifest.stringToPoint(_loc2_[2],this._pin);
         this._rotation = parseInt(_loc2_[3]);
         this._groupID = parseInt(_loc2_[4]);
         this._props.fromString(_loc2_[5]);
         this._state = STATE_IDLE;
         this._clip.release();
         this.update();
         return _loc3_;
      }
      
      public function destroy() : void
      {
         if(!this._deleted)
         {
            if(this._group)
            {
               this._group.removeObject(this);
            }
            this._deleted = true;
            if(this._props)
            {
               this._props.removeEventListener(Event.CHANGE,this.onChangeProps);
            }
            if(Boolean(this._clip) && Boolean(this._clip.parent))
            {
               this._clip.parent.removeChild(this._clip);
            }
            this._props = null;
            this._clip = null;
            dispatchEvent(new Event(Event.CLEAR));
         }
      }
   }
}

