package com.sploder.game
{
   import com.sploder.builder.CreatorUIStates;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ViewSpriteTurbo extends ViewSprite
   {
      protected var _initialRotationSet:Boolean = false;
      
      protected var _lockRotation:Boolean = false;
      
      protected var _b:Bitmap;
      
      public function ViewSpriteTurbo()
      {
         _sharpCorners = true;
         super();
      }
      
      override public function set x(param1:Number) : void
      {
         if(x != param1)
         {
            super.x = Math.round(param1);
         }
      }
      
      override public function set y(param1:Number) : void
      {
         if(y != param1)
         {
            super.y = Math.round(param1);
         }
      }
      
      override public function set rotation(param1:Number) : void
      {
         if((!this._lockRotation || !this._initialRotationSet) && rotation != param1)
         {
            super.rotation = Math.round(param1);
            this._initialRotationSet = true;
         }
      }
      
      override public function draw(param1:Graphics = null, param2:Boolean = false, param3:Boolean = false, param4:Boolean = true, param5:Point = null) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:BitmapData = null;
         var _loc8_:Rectangle = null;
         var _loc9_:Matrix = null;
         super.draw(param1,param2,param3,param4,param5);
         if(_shape.width > 0 && _shape.width < 1440 && _shape.height > 0 && _shape.width < 1440)
         {
            _loc6_ = 0.5;
            _loc7_ = new BitmapData(_shape.width * _loc6_,_shape.height * _loc6_,true,0);
            _loc8_ = _shape.getBounds(this);
            _loc9_ = new Matrix();
            _loc9_.createBox(_loc6_,_loc6_,0,0 - _loc8_.x * _loc6_,0 - _loc8_.y * _loc6_);
            _loc7_.draw(this,_loc9_);
            if(Boolean(_shape) && Boolean(_shape.parent))
            {
               _shape.parent.removeChild(_shape);
            }
            this._b = new Bitmap(_loc7_);
            this._b.x = _loc8_.x;
            this._b.y = _loc8_.y;
            this._b.scaleX = this._b.scaleY = 1 / _loc6_;
            addChild(this._b);
         }
         if(_modelObject.props.constraint == CreatorUIStates.MOVEMENT_SLIDE || _modelObject.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
         {
            this._lockRotation = true;
         }
         if(_modelObject.props.shape == CreatorUIStates.SHAPE_BOX || _modelObject.props.shape == CreatorUIStates.SHAPE_SQUARE)
         {
            if(_modelObject.props.color != -1)
            {
               if(_modelObject.props.line >= 0)
               {
                  this._b.opaqueBackground = _modelObject.props.line;
               }
               else
               {
                  this._b.opaqueBackground = _modelObject.props.color;
               }
               opaqueBackground = 1;
               cacheAsBitmap = true;
            }
         }
      }
   }
}

