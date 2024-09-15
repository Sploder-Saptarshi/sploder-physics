package com.sploder.builder.model
{
   import com.sploder.asui.Prompt;
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.builder.Shapes;
   import com.sploder.builder.Textures;
   import com.sploder.game.library.EmbeddedLibrary;
   import com.sploder.util.Geom2d;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class ModelObjectSprite extends Sprite
   {
      public static var library:EmbeddedLibrary;
      
      public static var suppressDraw:Boolean = false;
      
      public static const VIEW_CONSTRUCT:uint = 0;
      
      public static const VIEW_DECORATE:uint = 1;
      
      protected var _modelObject:ModelObject;
      
      protected var _mode:uint = 0;
      
      protected var _indicatorLocked:Sprite;
      
      protected var _indicatorSlide:Sprite;
      
      protected var _indicatorStatic:Sprite;
      
      protected var _handleRotate:SimpleButton;
      
      protected var _handlePin:SimpleButton;
      
      protected var _handleTL:SimpleButton;
      
      protected var _handleTR:SimpleButton;
      
      protected var _handleBL:SimpleButton;
      
      protected var _handleBR:SimpleButton;
      
      protected var _handlesV:Vector.<SimpleButton>;
      
      protected var _handlesAdded:Boolean = false;
      
      protected var _m:Matrix;
      
      protected var _suspended:Boolean = false;
      
      public function ModelObjectSprite(param1:ModelObject)
      {
         super();
         this._modelObject = param1;
         this._m = new Matrix();
      }
      
      public static function getFillColor(param1:ModelObject) : uint
      {
         var _loc2_:String = param1.props.material;
         switch(_loc2_)
         {
            case CreatorUIStates.MATERIAL_GLASS:
               return 39423;
            case CreatorUIStates.MATERIAL_ICE:
               return 6737100;
            case CreatorUIStates.MATERIAL_RUBBER:
               return 6684825;
            case CreatorUIStates.MATERIAL_STEEL:
               return 10066329;
            case CreatorUIStates.MATERIAL_TIRE:
               return 0;
            case CreatorUIStates.MATERIAL_WOOD:
               return 10040064;
            case CreatorUIStates.MATERIAL_AIR_BALLOON:
               return 38628;
            case CreatorUIStates.MATERIAL_HELIUM_BALLOON:
               return 38628;
            case CreatorUIStates.MATERIAL_MAGNET:
               return 6710886;
            case CreatorUIStates.MATERIAL_SUPERBALL:
               return 16711935;
            default:
               return 16777215;
         }
      }
      
      public static function getFillAlpha(param1:ModelObject) : Number
      {
         if(param1.state == ModelObject.STATE_NEW || param1.state == ModelObject.STATE_DRAGGING)
         {
            return 0.5;
         }
         var _loc2_:String = param1.props.material;
         switch(_loc2_)
         {
            case CreatorUIStates.MATERIAL_GLASS:
               return 0.5;
            case CreatorUIStates.MATERIAL_ICE:
            case CreatorUIStates.MATERIAL_RUBBER:
            case CreatorUIStates.MATERIAL_STEEL:
            case CreatorUIStates.MATERIAL_TIRE:
            case CreatorUIStates.MATERIAL_WOOD:
            case CreatorUIStates.MATERIAL_AIR_BALLOON:
            case CreatorUIStates.MATERIAL_HELIUM_BALLOON:
            case CreatorUIStates.MATERIAL_MAGNET:
            case CreatorUIStates.MATERIAL_SUPERBALL:
               return 1;
            default:
               return 1;
         }
      }
      
      public static function getLineColor(param1:ModelObject) : uint
      {
         if(param1.focused)
         {
            return 16777215;
         }
         if(param1.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
         {
            return 13421772;
         }
         var _loc2_:String = param1.props.material;
         switch(_loc2_)
         {
            case CreatorUIStates.MATERIAL_GLASS:
               return 39423;
            case CreatorUIStates.MATERIAL_ICE:
               return 6750207;
            case CreatorUIStates.MATERIAL_RUBBER:
               return 13369599;
            case CreatorUIStates.MATERIAL_STEEL:
               return 13421772;
            case CreatorUIStates.MATERIAL_TIRE:
               return 6710886;
            case CreatorUIStates.MATERIAL_WOOD:
               return 13395456;
            case CreatorUIStates.MATERIAL_AIR_BALLOON:
               return 30164;
            case CreatorUIStates.MATERIAL_HELIUM_BALLOON:
               return 30164;
            case CreatorUIStates.MATERIAL_MAGNET:
               return 13421772;
            case CreatorUIStates.MATERIAL_SUPERBALL:
               return 16738047;
            default:
               return 16777215;
         }
      }
      
      public static function getLineThickness(param1:ModelObject) : int
      {
         if(param1.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
         {
            return 4;
         }
         return 2;
      }
      
      public static function getFillHatch(param1:ModelObject) : String
      {
         switch(param1.props.strength)
         {
            case CreatorUIStates.STRENGTH_STRONG:
               return CreatorUIStates.HATCH_STRONG;
            case CreatorUIStates.STRENGTH_STRONG:
               return CreatorUIStates.HATCH_STRONG;
            case CreatorUIStates.STRENGTH_MEDIUM:
               return CreatorUIStates.HATCH_MEDIUM;
            case CreatorUIStates.STRENGTH_WEAK:
               return CreatorUIStates.HATCH_WEAK;
            default:
               return "";
         }
      }
      
      public function get obj() : ModelObject
      {
         return this._modelObject;
      }
      
      public function get id() : int
      {
         if(this._modelObject)
         {
            return this._modelObject.id;
         }
         return 0;
      }
      
      public function get zlayer() : int
      {
         if(Boolean(this._modelObject) && Boolean(this._modelObject.props))
         {
            return this._modelObject.props.zlayer;
         }
         return 3;
      }
      
      public function get mode() : uint
      {
         return this._mode;
      }
      
      public function set mode(param1:uint) : void
      {
         if(this._mode != param1)
         {
            this._mode = param1;
            if(this._mode == VIEW_DECORATE)
            {
               this.setHandleVisibility(false);
            }
            this.draw();
         }
      }
      
      protected function addHandles() : void
      {
         var _loc1_:SimpleButton = null;
         var _loc2_:Vector.<Point> = null;
         var _loc3_:int = 0;
         if(suppressDraw)
         {
            return;
         }
         this._indicatorSlide = library.getDisplayObject(CreatorUIStates.INDICATOR_SLIDE) as Sprite;
         this._indicatorSlide.visible = false;
         this._indicatorSlide.mouseEnabled = false;
         addChild(this._indicatorSlide);
         this._indicatorLocked = library.getDisplayObject(CreatorUIStates.INDICATOR_LOCKED) as Sprite;
         this._indicatorLocked.visible = false;
         this._indicatorLocked.mouseEnabled = false;
         addChild(this._indicatorLocked);
         this._indicatorStatic = library.getDisplayObject(CreatorUIStates.INDICATOR_STATIC) as Sprite;
         this._indicatorStatic.visible = false;
         this._indicatorStatic.mouseEnabled = false;
         addChild(this._indicatorStatic);
         if(this._modelObject.props.shape != CreatorUIStates.SHAPE_RAMP)
         {
            this._handleRotate = library.getDisplayObject(CreatorUIStates.BUTTON_HANDLE_ROTATE) as SimpleButton;
            this._handleRotate.name = CreatorUIStates.ROTATE;
            this._handleRotate.visible = false;
            addChild(this._handleRotate);
            Prompt.connectButton(this._handleRotate,"Drag this to rotate the object. Double-click to reset rotation.");
         }
         this._handlePin = library.getDisplayObject(CreatorUIStates.BUTTON_HANDLE_PIN) as SimpleButton;
         this._handlePin.name = CreatorUIStates.PIN;
         this._handlePin.visible = false;
         addChild(this._handlePin);
         Prompt.connectButton(this._handlePin,"Drag this to change the center of rotation for this object.");
         if(this._modelObject.props.shape == CreatorUIStates.SHAPE_BOX || this._modelObject.props.shape == CreatorUIStates.SHAPE_RAMP)
         {
            if(this._modelObject.props.shape == CreatorUIStates.SHAPE_BOX)
            {
               this._handleTL = library.getDisplayObject(CreatorUIStates.BUTTON_HANDLE_CORNER) as SimpleButton;
               this._handleTL.name = CreatorUIStates.TOP_LEFT;
               this._handleTL.visible = false;
               addChild(this._handleTL);
               Prompt.connectButton(this._handleTL,"Drag this to change the shape of this object.");
            }
            this._handleTR = library.getDisplayObject(CreatorUIStates.BUTTON_HANDLE_CORNER) as SimpleButton;
            this._handleTR.name = CreatorUIStates.TOP_RIGHT;
            this._handleTR.visible = false;
            addChild(this._handleTR);
            Prompt.connectButton(this._handleTR,"Drag this to change the shape of this object.");
            this._handleBL = library.getDisplayObject(CreatorUIStates.BUTTON_HANDLE_CORNER) as SimpleButton;
            this._handleBL.name = CreatorUIStates.BOTTOM_LEFT;
            this._handleBL.visible = false;
            addChild(this._handleBL);
            Prompt.connectButton(this._handleBL,"Drag this to change the shape of this object.");
            this._handleBR = library.getDisplayObject(CreatorUIStates.BUTTON_HANDLE_CORNER) as SimpleButton;
            this._handleBR.name = CreatorUIStates.BOTTOM_RIGHT;
            this._handleBR.visible = false;
            addChild(this._handleBR);
            Prompt.connectButton(this._handleBR,"Drag this to change the shape of this object.");
         }
         else if(this._modelObject.props.shape == CreatorUIStates.SHAPE_POLY)
         {
            if(this._handlesV != null)
            {
               while(this._handlesV.length)
               {
                  removeChild(this._handlesV.pop());
               }
            }
            this._handlesV = new Vector.<SimpleButton>();
            if(!this._modelObject.props.vertices)
            {
               return;
            }
            _loc2_ = this._modelObject.props.vertices;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc1_ = library.getDisplayObject(CreatorUIStates.BUTTON_HANDLE_VERTEX) as SimpleButton;
               _loc1_.name = CreatorUIStates.VERTEX;
               _loc1_.visible = false;
               this._handlesV.push(_loc1_);
               _loc1_.x = _loc2_[_loc3_].x;
               _loc1_.y = _loc2_[_loc3_].y;
               addChild(_loc1_);
               Prompt.connectButton(_loc1_,"Drag this to change the shape of this object, double-click to remove.");
               _loc3_++;
            }
         }
         this._handlesAdded = true;
      }
      
      protected function setHandleVisibility(param1:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Point = null;
         var _loc2_:int = this._modelObject.props.width;
         var _loc3_:int = this._modelObject.props.height;
         if(this._handleRotate)
         {
            this._handleRotate.visible = param1;
            this._handleRotate.x = 0;
            this._handleRotate.y = this._modelObject.props.shape == CreatorUIStates.SHAPE_POLY ? Math.min(-40,0 - _loc3_ / 4) : 0 - _loc3_ / 2;
         }
         if(this._handleTL)
         {
            this._handleTL.visible = param1;
            this._handleTL.x = 0 - _loc2_ / 2;
            this._handleTL.y = 0 - _loc3_ / 2;
         }
         if(this._handleTR)
         {
            this._handleTR.visible = param1;
            this._handleTR.x = _loc2_ / 2;
            this._handleTR.y = 0 - _loc3_ / 2;
         }
         if(this._handleBL)
         {
            this._handleBL.visible = param1;
            this._handleBL.x = 0 - _loc2_ / 2;
            this._handleBL.y = _loc3_ / 2;
         }
         if(this._handleBR)
         {
            this._handleBR.visible = param1;
            this._handleBR.x = _loc2_ / 2;
            this._handleBR.y = _loc3_ / 2;
         }
         if(this._handlesV)
         {
            _loc4_ = int(this._handlesV.length);
            while(_loc4_--)
            {
               this._handlesV[_loc4_].visible = param1;
               this._handlesV[_loc4_].x = this._modelObject.props.vertices[_loc4_].x;
               this._handlesV[_loc4_].y = this._modelObject.props.vertices[_loc4_].y;
               this._handlesV[_loc4_].rotation = 0 - this._modelObject.rotation;
            }
         }
         if(this._indicatorSlide)
         {
            this._indicatorSlide.visible = param1 && this._modelObject.props.constraint == CreatorUIStates.MOVEMENT_SLIDE;
            this._indicatorSlide.rotation = 0 - this._modelObject.rotation;
         }
         if(this._indicatorLocked)
         {
            this._indicatorLocked.visible = param1 && this._modelObject.props.locked;
            this._indicatorLocked.rotation = 0 - this._modelObject.rotation;
         }
         if(this._modelObject.props.constraint == CreatorUIStates.MOVEMENT_PIN)
         {
            this._handlePin.visible = param1;
            _loc5_ = this._modelObject.pin;
            if(param1 && this._modelObject.rotation != 0)
            {
               _loc5_ = _loc5_.clone();
               Geom2d.rotate(_loc5_,0 - this._modelObject.rotation * Geom2d.dtr);
            }
            this._handlePin.x = _loc5_.x;
            this._handlePin.y = _loc5_.y;
            this._handlePin.rotation = 0 - this._modelObject.rotation;
         }
         else if(this._handlePin)
         {
            this._handlePin.visible = false;
         }
         if(this._modelObject.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
         {
            if(this._indicatorStatic)
            {
               this._indicatorStatic.visible = param1;
               this._indicatorStatic.rotation = 0 - this._modelObject.rotation;
            }
            if(this._indicatorLocked)
            {
               this._indicatorLocked.visible = false;
            }
         }
         else if(this._indicatorStatic)
         {
            this._indicatorStatic.visible = false;
         }
      }
      
      public function getHandleIndex(param1:SimpleButton) : int
      {
         return this._handlesV.indexOf(param1);
      }
      
      public function addVertexHandle() : SimpleButton
      {
         var _loc1_:SimpleButton = library.getDisplayObject(CreatorUIStates.BUTTON_HANDLE_VERTEX) as SimpleButton;
         _loc1_.name = CreatorUIStates.VERTEX;
         _loc1_.visible = false;
         this._handlesV.push(_loc1_);
         addChild(_loc1_);
         Prompt.connectButton(_loc1_,"Drag this to change the shape of this object, double-click to remove.");
         return _loc1_;
      }
      
      public function removeVertexHandle(param1:int) : void
      {
         var _loc2_:Vector.<SimpleButton> = null;
         if(Boolean(this._handlesV) && this._handlesV.length > param1)
         {
            _loc2_ = this._handlesV.splice(param1,1);
            if(_loc2_.length > 0 && Boolean(_loc2_[0].parent))
            {
               _loc2_[0].parent.removeChild(_loc2_[0]);
            }
         }
      }
      
      public function draw() : void
      {
         var _loc2_:ModelObject = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Vector.<Point> = null;
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         if(this._suspended || this._modelObject.deleted)
         {
            return;
         }
         if(suppressDraw)
         {
            return;
         }
         if(library == null)
         {
            return;
         }
         if(this._modelObject == null || this._modelObject.props == null || this._modelObject.props.shape == CreatorUIStates.SHAPE_NONE)
         {
            return;
         }
         if(!this._handlesAdded)
         {
            this.addHandles();
         }
         x = this._modelObject.origin.x;
         y = this._modelObject.origin.y;
         rotation = this._modelObject.rotation;
         if(this._modelObject.state == ModelObject.STATE_DRAGGING)
         {
            x += this._modelObject.offset.x;
            y += this._modelObject.offset.y;
         }
         else if(this._mode != VIEW_DECORATE && this._modelObject.state == ModelObject.STATE_SELECTED)
         {
            if(parent)
            {
               parent.setChildIndex(this,parent.numChildren - 1);
            }
         }
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         if(this._mode == VIEW_DECORATE)
         {
            _loc2_ = this._modelObject;
            if(_loc2_.props.attribs != null)
            {
               _loc3_ = library.getTextureBitmapData(_loc2_.props.attribs,64);
            }
            else if(_loc2_.props.texture > 0 || _loc2_.props.graphic > 0)
            {
               _loc3_ = Textures.getScaledBitmapData(_loc2_.props.textureName,8,0,this);
            }
            _loc4_ = _loc2_.state == ModelObject.STATE_SELECTED || _loc2_.state == ModelObject.STATE_DRAGGING;
            _loc5_ = _loc2_.props.color >= 0 && _loc2_.props.line == -2;
            if(_loc2_.props.shape == CreatorUIStates.SHAPE_CIRCLE && _loc2_.props.scribble == 0)
            {
               if(_loc5_)
               {
                  Shapes.drawCircle(_loc1_,_loc2_.props.size,null,0,0,8,_loc2_.props.color,0.65,false);
                  Shapes.drawCircle(_loc1_,_loc2_.props.size,null,0,0,16,_loc2_.props.color,0.4,false);
               }
               if(_loc4_)
               {
                  Shapes.drawCircle(_loc1_,_loc2_.props.size,null,0,0,8,16777215,0.35,false);
                  Shapes.drawCircle(_loc1_,_loc2_.props.size,null,0,0,16,16777215,0.15,false);
               }
               if(_loc2_.props.color >= 0 || _loc2_.props.line >= 0)
               {
                  Shapes.drawCircle(_loc1_,_loc2_.props.size,null,_loc2_.props.color >= 0 ? uint(_loc2_.props.color) : 0,_loc2_.props.color >= 0 ? (_loc2_.props.opaque == 1 ? 1 : 0.5) : 0.01,_loc2_.props.line >= 0 ? 4 : NaN,_loc2_.props.line >= 0 ? uint(_loc2_.props.line) : 0,1,false);
               }
               else if(_loc2_.props.texture == 0 && _loc2_.props.graphic == 0 && _loc2_.props.attribs == null)
               {
                  Shapes.drawCircle(_loc1_,_loc2_.props.size,null,0,0,2,65535,0.5,!_loc4_);
               }
               else if(_loc2_.props.graphic > 0)
               {
                  Shapes.drawCircle(_loc1_,_loc2_.props.size,null,0,0,2,16711782,0.25,!_loc4_);
               }
               if(_loc2_.props.texture > 0 || _loc2_.props.graphic > 0 || _loc2_.props.attribs != null)
               {
                  if(_loc3_)
                  {
                     this._m.createBox(_loc2_.props.size / (_loc3_.width * 0.5),_loc2_.props.size / (_loc3_.height * 0.5),0,_loc2_.props.size,_loc2_.props.size);
                     _loc1_.beginBitmapFill(_loc3_,this._m,true,true);
                     _loc1_.drawCircle(0,0,_loc2_.props.size);
                     _loc1_.endFill();
                  }
               }
            }
            else
            {
               _loc6_ = !!_loc2_.props.vertices ? _loc2_.props.vertices : Shapes.getVertices(_loc2_.props.shape,_loc2_.props.width,_loc2_.props.height,30,_loc2_.props.scribble * 2,this._modelObject.id);
               if(Boolean(_loc2_.props.vertices) && _loc2_.props.scribble == 1)
               {
                  _loc6_ = Shapes.tesselate(_loc2_.props.verticesClone(),30,2,this._modelObject.id);
               }
               if(_loc5_)
               {
                  Shapes.drawShape(_loc1_,_loc6_,null,0,0,8,_loc2_.props.color,0.65,false);
                  Shapes.drawShape(_loc1_,_loc6_,null,0,0,16,_loc2_.props.color,0.4,false);
               }
               if(_loc4_)
               {
                  Shapes.drawShape(_loc1_,_loc6_,null,0,0,8,16777215,0.35,false);
                  Shapes.drawShape(_loc1_,_loc6_,null,0,0,16,16777215,0.15,false);
               }
               if(_loc2_.props.color >= 0 || _loc2_.props.line >= 0)
               {
                  Shapes.drawShape(_loc1_,_loc6_,null,_loc2_.props.color >= 0 ? uint(_loc2_.props.color) : 0,_loc2_.props.color >= 0 ? (_loc2_.props.opaque == 1 ? 1 : 0.5) : 0.01,_loc2_.props.line >= 0 ? 4 : NaN,_loc2_.props.line >= 0 ? uint(_loc2_.props.line) : 0,1,false);
               }
               else if(_loc2_.props.texture == 0 && _loc2_.props.graphic == 0 && _loc2_.props.attribs == null)
               {
                  Shapes.drawShape(_loc1_,_loc6_,null,0,0,2,65535,0.5,false);
               }
               else if(_loc2_.props.graphic > 0)
               {
                  Shapes.drawShape(_loc1_,_loc6_,null,0,0,2,16711782,0.25,false);
               }
               if(_loc2_.props.texture > 0 || _loc2_.props.graphic > 0 || _loc2_.props.attribs != null)
               {
                  if(_loc3_)
                  {
                     switch(_loc2_.props.shape)
                     {
                        case CreatorUIStates.SHAPE_CIRCLE:
                        case CreatorUIStates.SHAPE_SQUARE:
                        case CreatorUIStates.SHAPE_PENT:
                        case CreatorUIStates.SHAPE_HEX:
                           this._m.createBox(_loc2_.props.size / (_loc3_.width * 0.5),_loc2_.props.size / (_loc3_.height * 0.5),0,_loc2_.props.size,_loc2_.props.size);
                           break;
                        case CreatorUIStates.SHAPE_BOX:
                           if(_loc2_.props.graphic > 0 || _loc2_.props.attribs != null)
                           {
                              this._m.createBox(_loc2_.props.size / (_loc3_.width * 0.5),_loc2_.props.size / (_loc3_.height * 0.5),0,_loc2_.props.size,_loc2_.props.size);
                              break;
                           }
                        default:
                           this._m.createBox(0.25,0.25,0,_loc3_.width * 0.125,_loc3_.height * 0.125);
                     }
                     Shapes.drawTexture(_loc1_,_loc6_,_loc3_,this._m,null,true);
                  }
               }
            }
            if(this._modelObject.state == ModelObject.STATE_SELECTED || this._modelObject.state == ModelObject.STATE_DRAGGING)
            {
               this.setHandleVisibility();
            }
            else
            {
               this.setHandleVisibility(false);
            }
            return;
         }
         _loc1_.clear();
         _loc1_.beginFill(getFillColor(this._modelObject),getFillAlpha(this._modelObject));
         if(this._modelObject.state == ModelObject.STATE_SELECTED || this._modelObject.state == ModelObject.STATE_DRAGGING)
         {
            _loc1_.lineStyle(4,16777215);
            this.setHandleVisibility();
         }
         else
         {
            _loc1_.lineStyle(getLineThickness(this._modelObject),getLineColor(this._modelObject));
            this.setHandleVisibility(false);
         }
         if(this._modelObject.props.width == 0 && this._modelObject.props.height == 0)
         {
            _loc1_.beginFill(16777215,1);
            _loc1_.lineStyle(4,16777215,0.5);
            _loc1_.drawCircle(0,0,4);
            return;
         }
         this.drawBody(_loc1_);
         if(this._modelObject.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
         {
            _loc1_.lineStyle(2,0,0.5);
         }
         if(getFillHatch(this._modelObject) != "")
         {
            this._m.createBox(1,1,0 - this._modelObject.rotation * Geom2d.dtr);
            _loc1_.beginBitmapFill(library.getBitmapData(getFillHatch(this._modelObject)),this._m);
            this.drawBody(_loc1_);
         }
         else if(this._modelObject.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
         {
            _loc1_.beginFill(0,0);
            this.drawBody(_loc1_);
         }
         if(this._modelObject.state == ModelObject.STATE_SELECTED && this._modelObject.props.constraint == CreatorUIStates.MOVEMENT_PIN)
         {
            _loc7_ = this._modelObject.pin.length;
            if(_loc7_ > 0)
            {
               _loc1_.lineStyle(2,16772096,0.5);
               _loc1_.beginFill(0,0);
               _loc8_ = this._modelObject.pin;
               if(this._modelObject.rotation != 0)
               {
                  _loc8_ = _loc8_.clone();
                  Geom2d.rotate(_loc8_,0 - this._modelObject.rotation * Geom2d.dtr);
               }
               _loc1_.drawCircle(_loc8_.x,_loc8_.y,_loc7_);
            }
         }
         _loc1_.lineStyle(NaN,NaN);
         _loc1_.beginFill(0,0.25);
         _loc1_.drawCircle(0,0,4);
         _loc1_.beginFill(16772096,1);
         _loc1_.drawCircle(0,0,2);
      }
      
      protected function drawBody(param1:Graphics) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:Vector.<Point> = null;
         var _loc2_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = this._modelObject.props.size;
         var _loc5_:Number = 0;
         switch(this._modelObject.props.shape)
         {
            case CreatorUIStates.SHAPE_BOX:
               param1.moveTo(0,0);
               param1.lineTo(0,0 - this._modelObject.props.height / 2);
               param1.drawRect(0 - this._modelObject.props.width / 2,0 - this._modelObject.props.height / 2,this._modelObject.props.width,this._modelObject.props.height);
               break;
            case CreatorUIStates.SHAPE_RAMP:
               param1.moveTo(this._modelObject.props.width / 2,0 - this._modelObject.props.height / 2);
               param1.lineTo(this._modelObject.props.width / 2,this._modelObject.props.height / 2);
               param1.lineTo(0 - this._modelObject.props.width / 2,this._modelObject.props.height / 2);
               param1.lineTo(this._modelObject.props.width / 2,0 - this._modelObject.props.height / 2);
               break;
            case CreatorUIStates.SHAPE_CIRCLE:
               param1.moveTo(0,0);
               param1.lineTo(0,0 - _loc4_);
               param1.drawCircle(0,0,_loc4_);
               break;
            case CreatorUIStates.SHAPE_SQUARE:
               param1.moveTo(0,0);
               param1.lineTo(0,0 - _loc4_);
               param1.drawRect(0 - _loc4_,0 - _loc4_,_loc4_ * 2,_loc4_ * 2);
               break;
            case CreatorUIStates.SHAPE_PENT:
               _loc2_ = 5;
            case CreatorUIStates.SHAPE_HEX:
               if(_loc2_ == 0)
               {
                  _loc2_ = 6;
               }
               _loc3_ = 0;
               _loc5_ = Math.PI * 2 / _loc2_;
               param1.moveTo(0,0);
               _loc6_ = 0;
               while(_loc6_ <= _loc2_)
               {
                  graphics.lineTo(_loc4_ * Math.cos(_loc3_ + _loc5_ * _loc6_),_loc4_ * Math.sin(_loc3_ + _loc5_ * _loc6_));
                  _loc6_++;
               }
               break;
            case CreatorUIStates.SHAPE_POLY:
               if(Boolean(this._modelObject.props.vertices) && this._modelObject.props.vertices.length > 2)
               {
                  _loc7_ = this._modelObject.props.vertices;
                  param1.moveTo(_loc7_[0].x,_loc7_[0].y);
                  _loc6_ = 1;
                  while(_loc6_ < _loc7_.length)
                  {
                     param1.lineTo(_loc7_[_loc6_].x,_loc7_[_loc6_].y);
                     _loc6_++;
                  }
                  param1.lineTo(_loc7_[0].x,_loc7_[0].y);
                  if(this._modelObject.state == ModelObject.STATE_SELECTED)
                  {
                     param1.moveTo(0,0);
                     param1.lineStyle(2,getLineColor(this._modelObject),0.5);
                     param1.lineTo(this._handleRotate.x,this._handleRotate.y);
                  }
               }
         }
      }
      
      public function suspend() : void
      {
         this._suspended = true;
      }
      
      public function release() : void
      {
         this._suspended = false;
         this.draw();
      }
      
      override public function toString() : String
      {
         return this._modelObject.toString();
      }
   }
}

