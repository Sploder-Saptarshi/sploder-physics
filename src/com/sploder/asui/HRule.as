package com.sploder.asui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class HRule extends Component
   {
      public var dotted:Boolean = false;
      
      public function HRule(param1:Sprite = null, param2:Number = NaN, param3:Position = null, param4:Style = null)
      {
         super();
         this.init_HRule(param1,param2,param3,param4);
         if(_container != null)
         {
            this.create();
         }
      }
      
      private function init_HRule(param1:Sprite = null, param2:Number = NaN, param3:Position = null, param4:Style = null) : void
      {
         super.init(param1,param3,param4);
         _type = "hrule";
         _width = param2;
         _height = Math.max(1,Math.floor(_style.borderWidth * 0.5));
      }
      
      override public function create() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:int = 0;
         super.create();
         if(isNaN(_width))
         {
            _width = _parentCell.width - _position.margin_left - _position.margin_right;
         }
         if(!this.dotted)
         {
            DrawingMethods.rect(_mc,true,0,0,_width,_height,ColorTools.getTintedColor(_style.borderColor,_style.backgroundColor,0.5));
         }
         else
         {
            _loc1_ = new Bitmap();
            _loc1_.bitmapData = new BitmapData(_width,1,true,0);
            _loc2_ = 0;
            while(_loc2_ <= _loc1_.bitmapData.width)
            {
               _loc1_.bitmapData.setPixel32(_loc2_,0,2566914048 + _style.borderColor);
               _loc2_ += 2;
            }
            _mc.addChild(_loc1_);
         }
      }
   }
}

