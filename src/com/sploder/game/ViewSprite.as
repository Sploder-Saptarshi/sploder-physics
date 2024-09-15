package com.sploder.game
{
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.builder.Shapes;
   import com.sploder.builder.Textures;
   import com.sploder.builder.model.ModelObject;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class ViewSprite extends Sprite
   {
      public var offset:Point;
      
      protected var _modelObject:ModelObject;
      
      public var id:int = 0;
      
      public var zlayer:int = 3;
      
      public var frame:int = 0;
      
      public var totalFrames:int = 1;
      
      public var flipped:Boolean = false;
      
      public var rotated:Boolean = false;
      
      public var doCycle:Boolean = false;
      
      protected var _m:Matrix;
      
      protected var _r:Rectangle;
      
      public var halo:Boolean = false;
      
      protected var _shape:Shape;
      
      protected var _blingTime:int;
      
      protected var _blingAmount:int;
      
      protected var _sharpCorners:Boolean = false;
      
      protected var _bitmapData:BitmapData;
      
      public function ViewSprite()
      {
         super();
         this._shape = new Shape();
         addChild(this._shape);
         this.offset = new Point();
      }
      
      public function get modelObject() : ModelObject
      {
         return this._modelObject;
      }
      
      public function set modelObject(param1:ModelObject) : void
      {
         this._modelObject = param1;
         this.id = this._modelObject.id;
         this.zlayer = this._modelObject.props.zlayer;
         this.draw();
      }
      
      override public function get rotation() : Number
      {
         return super.rotation;
      }
      
      override public function set rotation(param1:Number) : void
      {
         if(!this.rotated)
         {
            super.rotation = param1;
         }
      }
      
      public function set rotatedRotation(param1:Number) : void
      {
         super.rotation = param1;
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      public function get m() : Matrix
      {
         return this._m;
      }
      
      public function get r() : Rectangle
      {
         return this._r;
      }
      
      public function get textureName() : String
      {
         if(Boolean(this._modelObject) && Boolean(this._modelObject.props))
         {
            return this._modelObject.props.textureName;
         }
         return "";
      }
      
      public function draw(param1:Graphics = null, param2:Boolean = false, param3:Boolean = false, param4:Boolean = true, param5:Point = null) : void
      {
         var _loc6_:Vector.<Point> = null;
         var _loc8_:BitmapData = null;
         var _loc10_:BitmapData = null;
         if(param5 == null)
         {
            param5 = this.offset;
         }
         if(this._modelObject == null || this._modelObject.deleted)
         {
            return;
         }
         if(this._modelObject.props.shape == CreatorUIStates.SHAPE_NONE)
         {
            return;
         }
         var _loc7_:ModelObject = this._modelObject;
         if((_loc7_.props.texture > 0 || _loc7_.props.graphic > 0 || _loc7_.props.attribs != null) && this._m == null)
         {
            this._m = new Matrix();
            if(_loc7_.props.attribs != null)
            {
               _loc8_ = Textures.library.getTextureBitmapData(_loc7_.props.attribs,64);
            }
            else if(_loc7_.props.texture > 0 || _loc7_.props.graphic > 0)
            {
               this.frame = 0;
               _loc8_ = Textures.getScaledBitmapData(_loc7_.props.textureName,8,0,this);
               if((Boolean(_loc8_)) && _loc7_.props.graphic > 0)
               {
                  if(_loc7_.props.animation >= 1)
                  {
                     _loc8_ = _loc8_.clone();
                     _loc10_ = Textures.getOriginal(_loc7_.props.textureName);
                     if(_loc10_)
                     {
                        this.totalFrames = _loc10_.width / _loc10_.height;
                     }
                  }
                  else
                  {
                     this.totalFrames = 1;
                  }
               }
            }
         }
         if(param1 == null)
         {
            param1 = this._shape.graphics;
         }
         if(param4)
         {
            param1.clear();
         }
         var _loc9_:Boolean = _loc7_.props.color >= 0 && _loc7_.props.line == -2;
         if(param2 && param3)
         {
            if(_loc7_.props.shape == CreatorUIStates.SHAPE_CIRCLE && _loc7_.props.scribble == 0)
            {
               Shapes.drawCircle(param1,_loc7_.props.size,param5,16777215,1,NaN,0,1,false);
            }
            else
            {
               _loc6_ = !!_loc7_.props.vertices ? _loc7_.props.vertices : Shapes.getVertices(_loc7_.props.shape,_loc7_.props.width,_loc7_.props.height,30,_loc7_.props.scribble * 2,this._modelObject.id);
               if(Boolean(_loc7_.props.vertices) && _loc7_.props.scribble == 1)
               {
                  _loc6_ = Shapes.tesselate(_loc7_.props.verticesClone(),30,2,this._modelObject.id);
               }
               Shapes.drawShape(param1,_loc6_,param5,16777215,1,NaN,0,1,false);
            }
         }
         else if(_loc7_.props.shape == CreatorUIStates.SHAPE_CIRCLE && _loc7_.props.scribble == 0)
         {
            if(_loc9_ && !param2)
            {
               Shapes.drawCircle(param1,_loc7_.props.size,param5,0,0,8,_loc7_.props.color,0.65,false);
               Shapes.drawCircle(param1,_loc7_.props.size,param5,0,0,16,_loc7_.props.color,0.4,false);
            }
            if(_loc7_.props.color >= 0 || _loc7_.props.line >= 0 && !param2)
            {
               Shapes.drawCircle(param1,_loc7_.props.size,param5,_loc7_.props.color >= 0 ? uint(_loc7_.props.color) : 0,_loc7_.props.color >= 0 ? (_loc7_.props.opaque == 1 ? 1 : 0.5) : 0.01,_loc7_.props.line >= 0 && !param2 ? 4 : NaN,_loc7_.props.line >= 0 && !param2 ? uint(_loc7_.props.line) : 0,1,false);
            }
            if(!param3 && (_loc7_.props.texture > 0 || _loc7_.props.graphic > 0 || _loc7_.props.attribs != null))
            {
               if(_loc8_)
               {
                  this._m.createBox(_loc7_.props.size / (_loc8_.width * 0.5),_loc7_.props.size / (_loc8_.height * 0.5),0,_loc7_.props.size,_loc7_.props.size);
                  param1.beginBitmapFill(_loc8_,this._m,true,true);
                  param1.drawCircle(0,0,_loc7_.props.size);
                  param1.endFill();
                  this._bitmapData = _loc8_;
                  this._r = new Rectangle(0,0,_loc8_.width,_loc8_.height);
               }
            }
         }
         else
         {
            _loc6_ = !!_loc7_.props.vertices ? _loc7_.props.vertices : Shapes.getVertices(_loc7_.props.shape,_loc7_.props.width,_loc7_.props.height,30,_loc7_.props.scribble * 2,this._modelObject.id);
            if(Boolean(_loc7_.props.vertices) && _loc7_.props.scribble == 1)
            {
               _loc6_ = Shapes.tesselate(_loc7_.props.verticesClone(),30,2,this._modelObject.id);
            }
            if(_loc9_ && !param2)
            {
               Shapes.drawShape(param1,_loc6_,param5,0,0,8,_loc7_.props.color,0.65,false,this._sharpCorners);
               Shapes.drawShape(param1,_loc6_,param5,0,0,16,_loc7_.props.color,0.4,false,this._sharpCorners);
            }
            if(_loc7_.props.color >= 0 || _loc7_.props.line >= 0 && !param2)
            {
               Shapes.drawShape(param1,_loc6_,param5,_loc7_.props.color >= 0 ? uint(_loc7_.props.color) : 0,_loc7_.props.color >= 0 ? (_loc7_.props.opaque == 1 ? 1 : 0.5) : 0.01,_loc7_.props.line >= 0 && !param2 ? 4 : NaN,_loc7_.props.line >= 0 && !param2 ? uint(_loc7_.props.line) : 0,1,false,this._sharpCorners);
            }
            if(!param3 && (_loc7_.props.texture > 0 || _loc7_.props.graphic > 0 || _loc7_.props.attribs != null))
            {
               if(_loc8_)
               {
                  switch(_loc7_.props.shape)
                  {
                     case CreatorUIStates.SHAPE_CIRCLE:
                     case CreatorUIStates.SHAPE_SQUARE:
                     case CreatorUIStates.SHAPE_PENT:
                     case CreatorUIStates.SHAPE_HEX:
                        this._m.createBox(_loc7_.props.size / (_loc8_.width * 0.5),_loc7_.props.size / (_loc8_.height * 0.5),0,_loc7_.props.size,_loc7_.props.size);
                        break;
                     case CreatorUIStates.SHAPE_BOX:
                        if(_loc7_.props.graphic > 0 || _loc7_.props.attribs != null)
                        {
                           this._m.createBox(_loc7_.props.size / (_loc8_.width * 0.5),_loc7_.props.size / (_loc8_.height * 0.5),0,_loc7_.props.size,_loc7_.props.size);
                           break;
                        }
                     default:
                        this._m.createBox(0.25,0.25,0,_loc8_.width * 0.125 + param5.x,_loc8_.height * 0.125 + param5.y);
                  }
                  Shapes.drawTexture(param1,_loc6_,_loc8_,this._m,param5,true);
                  this._bitmapData = _loc8_;
                  this._r = new Rectangle(0,0,_loc8_.width,_loc8_.height);
               }
            }
         }
      }
      
      public function drawExtras() : void
      {
         var _loc4_:Vector.<Point> = null;
         if(this._modelObject == null || this._modelObject.deleted)
         {
            return;
         }
         if(this._modelObject.props.shape == CreatorUIStates.SHAPE_NONE)
         {
            return;
         }
         var _loc1_:ModelObject = this._modelObject;
         var _loc2_:Graphics = graphics;
         _loc2_.clear();
         var _loc3_:Number = getTimer() % 500 / 25;
         if(_loc1_.props.shape == CreatorUIStates.SHAPE_CIRCLE && _loc1_.props.scribble == 0)
         {
            if(this.halo)
            {
               Shapes.drawCircle(_loc2_,_loc1_.props.size,this.offset,0,0,12 + _loc3_,16777215,0.25,false);
               Shapes.drawCircle(_loc2_,_loc1_.props.size,this.offset,0,0,(12 + _loc3_) * 0.5,16777215,0.5,false);
            }
            if(this._blingAmount > 0)
            {
               Shapes.drawCircle(_loc2_,_loc1_.props.size,this.offset,0,0,6 + this._blingAmount / 50,16777215,0.25,false);
               Shapes.drawCircle(_loc2_,_loc1_.props.size,this.offset,0,0,(6 + this._blingAmount / 50) * 0.5,16777215,0.5,false);
            }
         }
         else
         {
            _loc4_ = !!_loc1_.props.vertices ? _loc1_.props.vertices : Shapes.getVertices(_loc1_.props.shape,_loc1_.props.width,_loc1_.props.height,30,_loc1_.props.scribble * 2,this._modelObject.id);
            if(Boolean(_loc1_.props.vertices) && _loc1_.props.scribble == 1)
            {
               _loc4_ = Shapes.tesselate(_loc1_.props.verticesClone(),30,2,this._modelObject.id);
            }
            if(this.halo)
            {
               Shapes.drawShape(_loc2_,_loc4_,this.offset,0,0,12 + _loc3_,16777215,0.25,false);
               Shapes.drawShape(_loc2_,_loc4_,this.offset,0,0,(12 + _loc3_) * 0.5,16777215,0.5,false);
            }
            if(this._blingAmount > 0)
            {
               Shapes.drawShape(_loc2_,_loc4_,this.offset,0,0,6 + this._blingAmount / 50,16777215,0.25,false);
               Shapes.drawShape(_loc2_,_loc4_,this.offset,0,0,(6 + this._blingAmount / 50) * 0.5,16777215,0.5,false);
            }
         }
      }
      
      public function clear() : void
      {
         if(this._shape)
         {
            this._shape.graphics.clear();
         }
      }
      
      public function clearExtras() : void
      {
         graphics.clear();
      }
      
      public function bling() : void
      {
         if(this._blingAmount == 0)
         {
            this._blingTime = getTimer();
            if(stage)
            {
               stage.addEventListener(Event.ENTER_FRAME,this.doBling,false,0,true);
            }
         }
      }
      
      protected function doBling(param1:Event) : void
      {
         this._blingAmount = 500 - (getTimer() - this._blingTime);
         if(this._blingAmount <= 0 && Boolean(stage))
         {
            this._blingAmount = 0;
            graphics.clear();
            stage.removeEventListener(Event.ENTER_FRAME,this.doBling);
            return;
         }
         this.drawExtras();
      }
      
      public function end() : void
      {
         if(stage)
         {
            stage.removeEventListener(Event.ENTER_FRAME,this.doBling);
         }
         graphics.clear();
         if(this._shape)
         {
            this._shape.graphics.clear();
            if(this._shape.parent)
            {
               this._shape.parent.removeChild(this._shape);
            }
            this._shape = null;
         }
         this._modelObject = null;
         this._m = null;
      }
   }
}

