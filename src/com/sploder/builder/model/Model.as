package com.sploder.builder.model
{
   import com.sploder.game.effect.BackgroundEffect;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Model extends ModelObjectContainer
   {
      public static var mainInstance:Model;
      
      private var _width:int = 640;
      
      private var _height:int = 480;
      
      private var _modifiers:ModifierContainer;
      
      private var _container:Sprite;
      
      private var _background:Shape;
      
      private var _backgroundEffect:BackgroundEffect;
      
      private var _touchArea:Sprite;
      
      private var _objectsContainer:Sprite;
      
      private var _modifiersContainer:Sprite;
      
      private var _newObjectContainer:Sprite;
      
      private var _selectionWindow:Sprite;
      
      private var _sprites:Vector.<ModelObjectSprite>;
      
      private var _viewMode:uint;
      
      private var _layerViewStates:Array;
      
      protected var _populating:Boolean = false;
      
      public function Model(param1:Sprite, param2:int, param3:int)
      {
         this._viewMode = ModelObjectSprite.VIEW_CONSTRUCT;
         this._container = param1;
         this._width = param2;
         this._height = param3;
         this._layerViewStates = [true,true,true,true,true];
         mainInstance = this;
         super();
         _id = 0;
         if(this._container.stage)
         {
            this.init();
         }
      }
      
      public function get modifiers() : ModifierContainer
      {
         return this._modifiers;
      }
      
      public function get container() : Sprite
      {
         return this._container;
      }
      
      public function get touchArea() : Sprite
      {
         return this._touchArea;
      }
      
      public function get objectsContainer() : Sprite
      {
         return this._objectsContainer;
      }
      
      public function get modifiersContainer() : Sprite
      {
         return this._modifiersContainer;
      }
      
      public function get newObjectContainer() : Sprite
      {
         return this._newObjectContainer;
      }
      
      public function get selectionWindow() : Sprite
      {
         return this._selectionWindow;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function get background() : Shape
      {
         return this._background;
      }
      
      public function get backgroundEffect() : BackgroundEffect
      {
         return this._backgroundEffect;
      }
      
      public function get populating() : Boolean
      {
         return this._populating;
      }
      
      override protected function init(param1:Event = null) : void
      {
         super.init(param1);
         this._background = new Shape();
         this._container.addChild(this._background);
         this._backgroundEffect = new BackgroundEffect(this._width,this._height);
         this._backgroundEffect.animate = false;
         this._container.addChild(this._backgroundEffect);
         this._touchArea = new Sprite();
         this._container.addChild(this._touchArea);
         var _loc2_:Graphics = this._touchArea.graphics;
         _loc2_.beginFill(0,0);
         _loc2_.drawRect(0,0,this._width,this._height);
         this._objectsContainer = new Sprite();
         this._container.addChild(this._objectsContainer);
         this._objectsContainer.scrollRect = new Rectangle(0,0,this._width,this._height);
         this._modifiersContainer = new Sprite();
         this._container.addChild(this._modifiersContainer);
         this._modifiersContainer.mouseEnabled = false;
         this._modifiersContainer.mouseChildren = true;
         this._modifiersContainer.scrollRect = new Rectangle(0,0,this._width,this._height);
         this._newObjectContainer = new Sprite();
         this._container.addChild(this._newObjectContainer);
         this._newObjectContainer.scrollRect = new Rectangle(0,0,this._width,this._height);
         this._selectionWindow = new Sprite();
         this._container.addChild(this._selectionWindow);
         this._sprites = new Vector.<ModelObjectSprite>();
         this._modifiers = new ModifierContainer(this,this._modifiersContainer);
      }
      
      public function resize(param1:int, param2:int) : void
      {
         this._width = Math.max(640,param1);
         this._height = Math.max(480,param2);
         this._objectsContainer.scrollRect = new Rectangle(0,0,this._width,this._height);
         this._modifiersContainer.scrollRect = new Rectangle(0,0,this._width,this._height);
         this._newObjectContainer.scrollRect = new Rectangle(0,0,this._width,this._height);
         var _loc3_:Graphics = this._touchArea.graphics;
         _loc3_.clear();
         _loc3_.beginFill(0,0);
         _loc3_.drawRect(0,0,this._width,this._height);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function setViewMode(param1:uint) : void
      {
         var _loc2_:int = 0;
         if(this._viewMode != param1)
         {
            _loc2_ = int(_objects.length);
            while(_loc2_--)
            {
               _objects[_loc2_].clip.mode = param1;
            }
            this._viewMode = param1;
            if(this._viewMode == ModelObjectSprite.VIEW_DECORATE)
            {
               this.zSort();
            }
         }
      }
      
      public function getLayerView(param1:int) : Boolean
      {
         return this._layerViewStates[param1] == true;
      }
      
      public function setLayerView(param1:int, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ModelObject = null;
         var _loc5_:Modifier = null;
         this._layerViewStates[param1] = param2;
         _loc3_ = int(_objects.length);
         while(_loc3_--)
         {
            _loc4_ = _objects[_loc3_];
            _loc4_.clip.visible = this._layerViewStates[_loc4_.props.zlayer - 1];
         }
         _loc3_ = int(this._modifiers.length);
         while(_loc3_--)
         {
            _loc5_ = this._modifiers.objects[_loc3_];
            if(_loc5_ != null && _loc5_.props != null && _loc5_.props.parent != null)
            {
               _loc5_.clip.visible = this._layerViewStates[_loc5_.props.parent.props.zlayer - 1];
            }
         }
      }
      
      override public function addObject(param1:ModelObject) : Boolean
      {
         if(super.addObject(param1))
         {
            this._objectsContainer.addChild(param1.clip);
            if(param1 && param1.clip && this._sprites.indexOf(param1.clip) == -1)
            {
               this._sprites.push(param1.clip);
               param1.clip.mode = this._viewMode;
            }
            return true;
         }
         return false;
      }
      
      override public function removeObject(param1:ModelObject) : Boolean
      {
         if(super.removeObject(param1))
         {
            if(this._modifiers)
            {
               this._modifiers.removeModifiersOnObject(param1);
            }
            if(param1 && param1.clip && this._sprites.indexOf(param1.clip) != -1)
            {
               this._sprites.splice(this._sprites.indexOf(param1.clip),1);
            }
            if(param1 && param1.clip && param1.clip.parent == this._objectsContainer)
            {
               param1.clip.parent.removeChild(param1.clip);
            }
            return true;
         }
         return false;
      }
      
      protected function compare(param1:ModelObjectSprite, param2:ModelObjectSprite) : Number
      {
         if(param1.zlayer == param2.zlayer)
         {
            if(param1.id < param2.id)
            {
               return -1;
            }
            if(param1.id > param2.id)
            {
               return 1;
            }
         }
         else
         {
            if(param1.zlayer > param2.zlayer)
            {
               return -1;
            }
            if(param1.zlayer < param2.zlayer)
            {
               return 1;
            }
         }
         return 0;
      }
      
      public function zSort() : void
      {
         this._sprites.sort(this.compare);
         var _loc1_:int = int(this._sprites.length);
         while(_loc1_--)
         {
            this._objectsContainer.setChildIndex(this._sprites[_loc1_],_loc1_);
         }
      }
      
      public function objectAtPoint(param1:Point, param2:ModelObject = null) : ModelObject
      {
         var _loc4_:ModelObjectSprite = null;
         var _loc3_:int = int(_objects.length);
         while(_loc3_--)
         {
            _loc4_ = _objects[_loc3_].clip;
            if((_loc4_) && _loc4_.visible && _loc4_.hitTestPoint(param1.x,param1.y,true))
            {
               if(param2 == null || param2 != _objects[_loc3_])
               {
                  return _objects[_loc3_];
               }
            }
         }
         return null;
      }
      
      override public function clear() : void
      {
         super.clear();
         this._modifiers.clear();
         this._layerViewStates = [true,true,true,true,true];
      }
      
      override public function selectionToString(param1:Vector.<ModelObject>) : String
      {
         return super.selectionToString(param1) + "$" + this._modifiers.selectionToString(param1);
      }
      
      override public function toString() : String
      {
         return super.toString() + "$" + this._modifiers.toString();
      }
      
      override public function fromString(param1:String) : Array
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Array = [];
         this._populating = true;
         var _loc3_:Array = param1.split("$");
         _loc2_.push(super.fromString(_loc3_[0]));
         if(_loc3_.length > 1)
         {
            _loc2_.push(this._modifiers.fromString(_loc3_[1]));
         }
         if(this._viewMode == ModelObjectSprite.VIEW_DECORATE)
         {
            this.zSort();
         }
         this._populating = false;
         return _loc2_;
      }
      
      public function end() : void
      {
         if(_objects)
         {
            removeObjects(_objects);
         }
         if(this._modifiers)
         {
            this._modifiers.end();
            this._modifiers = null;
         }
      }
   }
}

