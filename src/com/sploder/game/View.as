package com.sploder.game
{
   import com.sploder.builder.Shapes;
   import com.sploder.builder.model.Environment;
   import com.sploder.builder.model.Model;
   import com.sploder.builder.model.ModelObject;
   import com.sploder.game.effect.BackgroundEffect;
   import com.sploder.game.morph.Bloom;
   import com.sploder.game.morph.Shatter;
   import com.sploder.util.Geom2d;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import nape.phys.Body;
   
   public class View extends EventDispatcher
   {
      public static const EFFECT_NONE:int = 0;
      
      public static const EFFECT_BLOOM:int = 1;
      
      public static const EFFECT_SHATTER:int = 2;
      
      public static const EFFECT_EXPLODE:int = 3;
      
      public static var _nextID:int = 0;
      
      public static var stickToOrigin:Boolean = true;
      
      protected var _id:int = 0;
      
      protected var _model:Model;
      
      protected var _project:Environment;
      
      protected var _container:Sprite;
      
      protected var _scaleAnchor:Sprite;
      
      protected var _anchor:Sprite;
      
      protected var _background:Bitmap;
      
      protected var _effect:BackgroundEffect;
      
      protected var _constraints:Shape;
      
      protected var _effects:Sprite;
      
      protected var _viewport:Sprite;
      
      protected var _ui:Sprite;
      
      protected var _m:Matrix;
      
      protected var _width:uint = 640;
      
      protected var _height:uint = 480;
      
      protected var _scale:Number = 1;
      
      protected var _mouseDown:Boolean = false;
      
      protected var _sprites:Vector.<ViewSprite>;
      
      protected var _animations:ViewAnimationManager;
      
      protected var _turbo:Boolean = false;
      
      protected var _camera:Camera;
      
      protected var _cameraX:int;
      
      protected var _cameraY:int;
      
      public function View(param1:Sprite, param2:Model, param3:Environment, param4:Boolean = false)
      {
         super();
         this.init(param1,param2,param3,param4);
      }
      
      public function get model() : Model
      {
         return this._model;
      }
      
      public function set model(param1:Model) : void
      {
         this._model = param1;
      }
      
      public function get project() : Environment
      {
         return this._project;
      }
      
      public function set project(param1:Environment) : void
      {
         if(this._project)
         {
            this._project.removeEventListener(Event.CHANGE,this.onProjectChange);
         }
         this._project = param1;
         this._project.addEventListener(Event.CHANGE,this.onProjectChange,false,0,true);
      }
      
      public function get camera() : Camera
      {
         return this._camera;
      }
      
      public function get container() : Sprite
      {
         return this._container;
      }
      
      public function get anchor() : Sprite
      {
         return this._anchor;
      }
      
      public function get viewport() : Sprite
      {
         return this._viewport;
      }
      
      public function get constraints() : Shape
      {
         return this._constraints;
      }
      
      public function get mouseDown() : Boolean
      {
         return this._mouseDown;
      }
      
      public function get x() : int
      {
         return this._scaleAnchor.x;
      }
      
      public function get y() : int
      {
         return this._scaleAnchor.y;
      }
      
      public function get width() : uint
      {
         return 640 * this._scaleAnchor.scaleX;
      }
      
      public function get height() : uint
      {
         return 480 * this._scaleAnchor.scaleY;
      }
      
      public function get ui() : Sprite
      {
         return this._ui;
      }
      
      public function get animations() : ViewAnimationManager
      {
         return this._animations;
      }
      
      protected function init(param1:Sprite, param2:Model, param3:Environment, param4:Boolean = false) : void
      {
         this._container = param1;
         this._model = param2;
         this._project = param3;
         this._turbo = param4;
         this._animations = new ViewAnimationManager(this);
         ++_nextID;
         this._id = _nextID;
         this._m = new Matrix();
         if(this._project.size != Environment.SIZE_NORMAL)
         {
            this._width = 1280;
            this._height = 960;
            if(this._project.size == Environment.SIZE_DOUBLE)
            {
               this._scale = 0.5;
            }
         }
         var _loc5_:Sprite = new Sprite();
         this._container.addChild(_loc5_);
         this._container = _loc5_;
         this._scaleAnchor = new Sprite();
         this._container.addChild(this._scaleAnchor);
         this._background = new Bitmap();
         this._scaleAnchor.addChild(this._background);
         BackgroundEffect.skip = this._turbo ? 4 : 2;
         this._effect = new BackgroundEffect(this._model.width,this._model.height);
         this._effect.type = this._project.bgEffect;
         if(this._effect.type != Environment.EFFECT_NONE)
         {
            this._scaleAnchor.addChild(this._effect);
         }
         this._anchor = new Sprite();
         this._scaleAnchor.addChild(this._anchor);
         this._anchor.scrollRect = new Rectangle(0,0,640,480);
         this._constraints = new Shape();
         this._anchor.addChild(this._constraints);
         this._viewport = new Sprite();
         this._anchor.addChild(this._viewport);
         this._effects = new Sprite();
         this._anchor.addChild(this._effects);
         this._ui = new Sprite();
         this._ui.mouseEnabled = false;
         this._ui.mouseChildren = true;
         this._container.addChild(this._ui);
         this._effect.scaleX = this._effect.scaleY = this._constraints.scaleX = this._constraints.scaleY = this._viewport.scaleX = this._viewport.scaleY = this._effects.scaleX = this._effects.scaleY = this._scale;
         if(this._project.size == Environment.SIZE_FOLLOW)
         {
            this._camera = new Camera();
            this._camera.pixelSnap = true;
         }
         this._container.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         this._container.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
         this._container.stage.addEventListener(Event.RESIZE,this.onResize,false,0,true);
         this.onResize();
         this._sprites = new Vector.<ViewSprite>();
         this.onProjectChange();
      }
      
      protected function onResize(param1:Event = null) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Stage = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this._container.stage)
         {
            _loc2_ = this._scaleAnchor;
            _loc3_ = this._container.stage;
            _loc2_.scaleX = _loc2_.scaleY = 1;
            if(_loc3_.stageWidth > 0 && _loc3_.stageHeight > 0)
            {
               _loc4_ = _loc3_.stageWidth / _loc3_.stageHeight;
               _loc5_ = 640 / 480;
               if(_loc4_ > _loc5_)
               {
                  _loc2_.scaleX = _loc2_.scaleY = Math.min(1,_loc3_.stageHeight / 480);
                  if(!stickToOrigin)
                  {
                     _loc2_.x = (_loc3_.stageWidth - 640 * _loc2_.scaleX) * 0.5;
                     _loc2_.y = (_loc3_.stageHeight - 480 * _loc2_.scaleY) * 0.5;
                  }
               }
               else
               {
                  _loc2_.scaleX = _loc2_.scaleY = Math.min(1,_loc3_.stageHeight / 480);
                  if(!stickToOrigin)
                  {
                     _loc2_.x = (_loc3_.stageWidth - 640 * _loc2_.scaleX) * 0.5;
                     _loc2_.y = (_loc3_.stageHeight - 480 * _loc2_.scaleY) * 0.5;
                  }
               }
            }
            dispatchEvent(new Event(Event.RESIZE));
         }
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Rectangle = null;
         this._animations.update();
         if(Boolean(this._camera) && this._camera.watching)
         {
            this._camera.update();
            _loc1_ = Math.round(Math.min(640,Math.max(0,this._camera.x * this._scale - 320)));
            _loc2_ = Math.round(Math.min(480,Math.max(0,this._camera.y * this._scale - 240)));
            if(_loc1_ != this._cameraX || _loc2_ != this._cameraY)
            {
               _loc3_ = this._anchor.scrollRect;
               this._cameraX = _loc3_.x = _loc1_;
               this._cameraY = _loc3_.y = _loc2_;
               this._anchor.scrollRect = _loc3_;
               if(this._effect.type != Environment.EFFECT_NONE)
               {
                  if(this._project.gravity == 0)
                  {
                     this._effect.cameraX = _loc1_ * 0.5;
                     this._effect.cameraY = _loc2_ * 0.5;
                  }
                  else
                  {
                     this._effect.cameraX = _loc1_ * 0.35;
                     this._effect.cameraY = _loc2_ * 0.35;
                  }
                  if(this._effect.isStatic)
                  {
                     this._effect.update();
                  }
               }
            }
         }
      }
      
      protected function drawBackground() : void
      {
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.clear();
         _loc2_.beginGradientFill(GradientType.LINEAR,[this._project.bgColorTop,this._project.bgColorBottom],[1,1],[0,255],this._m);
         _loc2_.drawRect(0,0,320,240);
         _loc2_.endFill();
         var _loc3_:BitmapData = new BitmapData(320,240,false,0);
         _loc3_.draw(_loc1_);
         if(this._background.bitmapData)
         {
            this._background.bitmapData.dispose();
         }
         this._background.bitmapData = _loc3_;
         this._background.scaleX = this._background.scaleY = 2;
      }
      
      protected function onProjectChange(param1:Event = null) : void
      {
         switch(this._project.size)
         {
            case Environment.SIZE_NORMAL:
               this._width = 640;
               this._height = 480;
               this._effect.setSize(320,240);
               this._effect.scaleX = this._effect.scaleY = 2;
               this._m.createGradientBox(640,480,Geom2d.dtr * 90);
               break;
            case Environment.SIZE_DOUBLE:
               this._width = 640;
               this._height = 480;
               this._effect.setSize(640,480);
               this._effect.scaleX = this._effect.scaleY = 1;
               this._m.createGradientBox(640,480,Geom2d.dtr * 90);
               break;
            case Environment.SIZE_FOLLOW:
               this._width = 1280;
               this._height = 960;
               this._effect.setSize(320,240);
               this._effect.scaleX = this._effect.scaleY = 2;
               this._m.createGradientBox(640,480,Geom2d.dtr * 90);
         }
         this.drawBackground();
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         this._mouseDown = true;
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         this._mouseDown = false;
      }
      
      public function register(param1:ModelObject, param2:Point, param3:Body) : ViewSprite
      {
         var _loc4_:ViewSprite = null;
         if(this._turbo)
         {
            _loc4_ = new ViewSpriteTurbo();
         }
         else
         {
            _loc4_ = new ViewSprite();
         }
         _loc4_.offset = param2;
         _loc4_.modelObject = param1;
         _loc4_.mouseEnabled = _loc4_.mouseChildren = false;
         this._viewport.addChild(_loc4_);
         if(this._sprites.indexOf(_loc4_) == -1)
         {
            this._sprites.push(_loc4_);
         }
         if(param1.props.graphic > 0 && (param1.props.animation >= 1 || param1.props.graphic_flip > 0))
         {
            if(param1.props.animation == 1 || param1.props.animation == 3 && _loc4_.totalFrames > 0)
            {
               _loc4_.doCycle = true;
            }
            this._animations.register(_loc4_,param3);
         }
         return _loc4_;
      }
      
      public function unregister(param1:ViewSprite, param2:int = 0) : void
      {
         if(param1.parent == this._viewport)
         {
            switch(param2)
            {
               case EFFECT_BLOOM:
                  this.effectBloom(param1);
                  break;
               case EFFECT_SHATTER:
                  this.effectShatter(param1);
                  break;
               case EFFECT_EXPLODE:
                  this.effectExplode(param1);
            }
            if(param1.parent == this._viewport)
            {
               this._viewport.removeChild(param1);
            }
            if(this._sprites.indexOf(param1) != -1)
            {
               this._sprites.splice(this._sprites.indexOf(param1),1);
            }
            if(Boolean(param1.modelObject) && param1.modelObject.props.animation >= 1)
            {
               this._animations.unregister(param1);
            }
         }
      }
      
      protected function effectBloom(param1:ViewSprite) : void
      {
         var _loc2_:ModelObject = param1.modelObject;
         if(_loc2_)
         {
            this._effects.addChild(new Bloom(param1,250,true));
         }
      }
      
      protected function effectShatter(param1:ViewSprite) : void
      {
         var _loc3_:Vector.<Point> = null;
         var _loc2_:ModelObject = param1.modelObject;
         if(_loc2_)
         {
            _loc3_ = _loc2_.props.vertices;
            if(_loc3_ == null)
            {
               _loc3_ = Shapes.getVertices(_loc2_.props.shape,_loc2_.props.width,_loc2_.props.height,40);
            }
            this._effects.addChild(new Shatter(param1,_loc3_,40,true,1,null,null,_loc2_.props.color,this._turbo));
         }
      }
      
      protected function effectExplode(param1:ViewSprite) : void
      {
         var _loc3_:Vector.<Point> = null;
         var _loc2_:ModelObject = param1.modelObject;
         if(_loc2_)
         {
            _loc3_ = _loc2_.props.vertices;
            if(_loc3_ == null)
            {
               _loc3_ = Shapes.getVertices(_loc2_.props.shape,_loc2_.props.width,_loc2_.props.height,40);
            }
            this._effects.addChild(new Bloom(param1,250,true,true));
            this._effects.addChild(new Shatter(param1,_loc3_,40,true,3,null,null,0));
         }
      }
      
      protected function compare(param1:ViewSprite, param2:ViewSprite) : Number
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
         var _loc1_:int = int(this._sprites.length);
         if(this._sprites.length > this._viewport.numChildren)
         {
            while(_loc1_--)
            {
               if(this._sprites[_loc1_].parent != this._viewport)
               {
                  this._sprites.splice(_loc1_,1);
               }
            }
         }
         this._sprites.sort(this.compare);
         _loc1_ = int(this._sprites.length);
         while(_loc1_--)
         {
            if(this._sprites[_loc1_].parent == this._viewport)
            {
               this._viewport.setChildIndex(this._sprites[_loc1_],_loc1_);
            }
            else
            {
               this._sprites.splice(_loc1_,1);
            }
         }
      }
      
      public function end() : void
      {
         var _loc1_:int = 0;
         if(this._sprites)
         {
            _loc1_ = int(this._sprites.length);
            while(_loc1_--)
            {
               this.unregister(this._sprites[_loc1_],EFFECT_NONE);
            }
            this._sprites = null;
         }
         if(this._camera)
         {
            this._camera.stopWatching();
            this._camera = null;
         }
         if(this._background)
         {
            if(this._background.bitmapData)
            {
               this._background.bitmapData.dispose();
            }
            if(this._background.parent)
            {
               this._background.parent.removeChild(this._background);
            }
            this._background = null;
         }
         if(this._effect)
         {
            this._effect.end();
            this._effect = null;
         }
         if(this._viewport)
         {
            if(this._viewport.parent)
            {
               this._viewport.parent.removeChild(this._viewport);
            }
            this._viewport = null;
         }
         if(this._effects)
         {
            if(this._effects.parent)
            {
               this._effects.parent.removeChild(this._effects);
            }
            this._effects = null;
         }
         if(this._constraints)
         {
            if(this._constraints.parent)
            {
               this._constraints.parent.removeChild(this._constraints);
            }
            this._constraints = null;
         }
         if(this._anchor)
         {
            if(this._anchor.parent)
            {
               this._anchor.parent.removeChild(this._anchor);
            }
            this._anchor = null;
         }
         if(this._ui)
         {
            if(this._ui.parent)
            {
               this._ui.parent.removeChild(this._ui);
            }
            this._ui = null;
         }
         if(this._scaleAnchor)
         {
            if(this._scaleAnchor.parent)
            {
               this._scaleAnchor.parent.removeChild(this._scaleAnchor);
            }
            this._scaleAnchor = null;
         }
         if(this._container)
         {
            if(this._container.stage)
            {
               this._container.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               this._container.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
               this._container.stage.removeEventListener(Event.RESIZE,this.onResize);
            }
            if(this._container.parent)
            {
               this._container.parent.removeChild(this._container);
            }
            this._container = null;
         }
         if(this._project)
         {
            this._project.removeEventListener(Event.CHANGE,this.onProjectChange);
            this._project = null;
         }
      }
   }
}

