package com.sploder.asui
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class ColorChip extends Component
   {
      protected var _chip:Sprite;
      
      protected var _color:int;
      
      public function ColorChip(param1:Sprite = null, param2:int = 0, param3:Number = NaN, param4:Number = NaN, param5:Position = null, param6:Style = null)
      {
         super();
         this.init_ColorChip(param1,param2,param3,param4,param5,param6);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get color() : int
      {
         return this._color;
      }
      
      public function set color(param1:int) : void
      {
         this._color = param1;
         this.draw();
      }
      
      private function init_ColorChip(param1:Sprite = null, param2:int = 0, param3:Number = NaN, param4:Number = NaN, param5:Position = null, param6:Style = null) : void
      {
         super.init(param1,param5,param6);
         _type = "colorchip";
         _width = !isNaN(param3) ? param3 : 16;
         _height = !isNaN(param3) ? param4 : 16;
         this._color = param2;
      }
      
      override public function create() : void
      {
         super.create();
         this._chip = new Sprite();
         _mc.addChild(this._chip);
         this.draw();
      }
      
      protected function draw() : void
      {
         var _loc1_:Graphics = this._chip.graphics;
         _loc1_.beginFill(_style.borderColor,1);
         _loc1_.drawRect(0,0,_width,_height);
         _loc1_.endFill();
         _loc1_.beginFill(this._color,1);
         _loc1_.drawRect(2,2,_width - 4,_height - 4);
         _loc1_.endFill();
      }
   }
}

