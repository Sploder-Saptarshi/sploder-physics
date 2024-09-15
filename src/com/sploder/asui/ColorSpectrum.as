package com.sploder.asui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ColorSpectrum extends Component
   {
      protected var _btn:Sprite;
      
      protected var _bitmapData:BitmapData;
      
      protected var _bitmap:Bitmap;
      
      protected var _bitmapMask:Sprite;
      
      protected var _color:Number = 0;
      
      protected var _brightness:Number = 1;
      
      public var dimColorWheel:Boolean = true;
      
      public function ColorSpectrum(param1:Sprite, param2:int, param3:int, param4:Position = null, param5:Style = null)
      {
         super();
         this.init_ColorSpectrum(param1,param2,param3,param4,param5);
         if(_container != null)
         {
            this.create();
         }
      }
      
      private function init_ColorSpectrum(param1:Sprite, param2:int, param3:int, param4:Position = null, param5:Style = null) : void
      {
         super.init(param1,param4,param5);
         _type = "spectrum";
         _width = param2;
         _height = param3;
      }
      
      override public function create() : void
      {
         super.create();
         this._bitmapData = new BitmapData(_width,_height,true,4278190080 + _style.backgroundColor);
         this._bitmap = new Bitmap(this._bitmapData);
         _mc.addChild(this._bitmap);
         this._bitmapMask = new Sprite();
         this._bitmapMask.graphics.beginFill(267386880,1);
         this._bitmapMask.graphics.drawCircle(width / 2,height / 2,Math.min(width / 2,height / 2));
         this._bitmap.mask = this._bitmapMask;
         _mc.addChild(this._bitmapMask);
         this._btn = new Sprite();
         this._btn.graphics.lineStyle(2,_style.borderColor);
         this._btn.graphics.beginFill(16777215,0);
         this._btn.graphics.drawCircle(width / 2,height / 2,Math.min(width / 2,height / 2));
         this._btn.buttonMode = true;
         _mc.addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.pickColor);
         this._btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onBtnPress);
         this._btn.addEventListener(MouseEvent.MOUSE_OUT,this.onBtnRelease);
         this._btn.addEventListener(MouseEvent.MOUSE_UP,this.onBtnRelease);
         this.drawSpectrum();
      }
      
      protected function onBtnPress(param1:MouseEvent) : void
      {
         this._btn.addEventListener(MouseEvent.MOUSE_MOVE,this.pickColor);
      }
      
      protected function onBtnRelease(param1:MouseEvent) : void
      {
         this._btn.removeEventListener(MouseEvent.MOUSE_MOVE,this.pickColor);
      }
      
      protected function drawSpectrum() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Number = NaN;
         var _loc8_:int = 0;
         var _loc2_:int = Math.min(_width,_height) * 0.5;
         var _loc4_:Point = new Point();
         var _loc5_:Number = 0;
         var _loc6_:* = false;
         var _loc7_:int = 0;
         while(_loc7_ < _height)
         {
            _loc8_ = 0;
            while(_loc8_ < _width)
            {
               _loc4_.x = _loc8_ - _loc2_;
               _loc4_.y = _loc7_ - _loc2_;
               _loc5_ = Math.abs(_loc4_.length / _loc2_);
               _loc3_ = (Math.PI + Math.atan2(_loc4_.y,_loc4_.x)) * (180 / Math.PI);
               _loc6_ = _loc5_ > 1;
               if(_loc5_ > 1)
               {
                  _loc5_ = 1;
               }
               if(this.dimColorWheel)
               {
                  _loc1_ = ColorTools.hsv2hex(_loc3_,_loc5_ * 100,this._brightness * 100);
               }
               else
               {
                  _loc1_ = ColorTools.hsv2hex(_loc3_,_loc5_ * 100,100);
               }
               if(_loc5_ > 1)
               {
                  _loc1_ = _style.backgroundColor;
               }
               this._bitmapData.setPixel(_loc8_,_loc7_,_loc1_);
               _loc8_++;
            }
            _loc7_++;
         }
      }
      
      protected function pickColor(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         _loc3_ = Math.min(_width,_height) * 0.5;
         _loc5_ = new Point();
         var _loc6_:Number = 0;
         var _loc7_:Boolean = false;
         _loc5_.x = param1.localX - _loc3_;
         _loc5_.y = param1.localY - _loc3_;
         _loc6_ = Math.abs(_loc5_.length / _loc3_);
         _loc4_ = (Math.PI + Math.atan2(_loc5_.y,_loc5_.x)) * (180 / Math.PI);
         if(_loc6_ > 1)
         {
            _loc6_ = 1;
         }
         this._color = ColorTools.hsv2hex(_loc4_,_loc6_ * 100,this._brightness * 100);
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      public function get color() : Number
      {
         return this._color;
      }
      
      public function set color(param1:Number) : void
      {
         this._color = param1;
         var _loc2_:Object = ColorTools.hex2hsv(this._color);
         this._brightness = _loc2_.v / 100;
         this.drawSpectrum();
      }
      
      public function get brightness() : Number
      {
         return this._brightness;
      }
      
      public function set brightness(param1:Number) : void
      {
         this._brightness = param1;
         var _loc2_:Object = ColorTools.hex2hsv(this._color);
         _loc2_.v = this._brightness * 100;
         this._color = ColorTools.hsv2hex(_loc2_.h,_loc2_.s,_loc2_.v);
         this.drawSpectrum();
      }
   }
}

