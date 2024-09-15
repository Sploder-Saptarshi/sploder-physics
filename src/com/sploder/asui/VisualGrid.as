package com.sploder.asui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class VisualGrid extends Cell
   {
      protected var _spacing:int;
      
      public function VisualGrid(param1:Sprite, param2:Number = NaN, param3:Number = NaN, param4:Number = 10, param5:Position = null, param6:Style = null)
      {
         super();
         this.init_VisualGrid(param1,param2,param3,param4,param5,param6);
         if(_container != null)
         {
            this.create();
         }
      }
      
      protected function init_VisualGrid(param1:Sprite, param2:Number = NaN, param3:Number = NaN, param4:Number = 10, param5:Position = null, param6:Style = null) : void
      {
         super.init_Cell(param1,param2,param3,false,false,0,param5,param6);
         this._spacing = param4;
      }
      
      override public function create() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:BitmapData = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.create();
         if(isNaN(_width) || isNaN(_height) || _width <= 0 || _height <= 0)
         {
            if(Boolean(_mc) && Boolean(_mc.stage))
            {
               if(_parentCell && _parentCell.width > 0 && _parentCell.height > 0)
               {
                  _width = _parentCell.width;
                  _height = _parentCell.height;
               }
               else
               {
                  _width = _mc.stage.stageWidth;
                  _height = _mc.stage.stageHeight;
               }
            }
         }
         if(_width > 0 && _height > 0)
         {
            _loc1_ = new Bitmap(new BitmapData(_width,_height,true,0));
            _loc2_ = _loc1_.bitmapData;
            _loc1_.smoothing = true;
            _loc3_ = 0;
            while(_loc3_ < _height)
            {
               _loc4_ = 0;
               while(_loc4_ < _width)
               {
                  if(_loc4_ > 0 && _loc3_ > 0)
                  {
                     _loc2_.setPixel32(_loc4_,_loc3_,4278190080 + _style.borderColor);
                  }
                  _loc4_ += this._spacing;
               }
               _loc3_ += this._spacing;
            }
            _mc.addChild(_loc1_);
         }
      }
   }
}

