package com.sploder.game.morph
{
   import com.sploder.game.ViewSprite;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   
   public class Bloom extends Morph
   {
      private var _color:ColorTransform;
      
      private var _offset:Number = 0;
      
      private var _oldX:Number = 0;
      
      public var colorChange:int = 20;
      
      public var scaleChange:Number = 0.1;
      
      public var rotationChange:int = 10;
      
      public function Bloom(param1:ViewSprite, param2:uint = 990, param3:Boolean = true, param4:Boolean = false)
      {
         var _loc5_:Shape = null;
         super(param1,990,param3);
         if(_clip != null)
         {
            rotation = _clip.rotation;
            this._color = new ColorTransform();
            this._color.redMultiplier = this._color.blueMultiplier = this._color.greenMultiplier = 10;
            transform.colorTransform = this._color;
         }
         _clip.draw(graphics,true,true);
         if(param4)
         {
            scaleX = scaleY = 2;
            _loc5_ = new Shape();
            addChild(_loc5_);
            _loc5_.scaleX = _loc5_.scaleY = 1.5;
            _loc5_.alpha = 0.5;
            _clip.draw(_loc5_.graphics,true,true);
         }
      }
      
      override protected function doMorph(param1:Event) : void
      {
         if(alpha > 0)
         {
            alpha -= 0.1;
            scaleX += this.scaleChange;
            scaleY += this.scaleChange;
            this._color = transform.colorTransform;
            this._offset += this.colorChange;
            this._color.redOffset = this._color.blueOffset = this._color.greenOffset = this._offset;
            transform.colorTransform = this._color;
         }
         super.doMorph(param1);
      }
   }
}

