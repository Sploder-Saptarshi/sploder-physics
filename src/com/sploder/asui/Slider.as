package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Slider extends Cell
   {
      protected var _orientation:int;
      
      protected var _backing:BButton;
      
      protected var _dragger:BButton;
      
      protected var _snap:int = 0;
      
      protected var _sliderValue:Number;
      
      private var _ratio:Number = 1;
      
      public var showGradient:Boolean = false;
      
      public function Slider(param1:Sprite, param2:Number, param3:Number, param4:int = 13, param5:int = 0, param6:Position = null, param7:Style = null)
      {
         super();
         this.init_Slider(param1,param2,param3,param4,param5,param6,param7);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get sliderValue() : Number
      {
         if(this._snap > 0)
         {
            return Math.round(this._sliderValue * this._snap) / this._snap;
         }
         return this._sliderValue;
      }
      
      public function set sliderValue(param1:Number) : void
      {
         param1 = Math.min(1,Math.max(0,param1));
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            this._sliderValue = this._dragger.valueX = param1;
         }
         else
         {
            this._sliderValue = this._dragger.valueY = param1;
         }
         if(form != null && name.length > 0)
         {
            form[name] = param1;
         }
      }
      
      public function get ratio() : Number
      {
         return this._ratio;
      }
      
      public function set ratio(param1:Number) : void
      {
         this._ratio = Math.min(1,Math.max(0,param1));
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            this._dragger.resize(Math.max(_height,Math.ceil(_width * this._ratio)),_height);
         }
         else
         {
            this._dragger.resize(_width,Math.max(_width,Math.ceil(_height * this._ratio)));
         }
      }
      
      private function init_Slider(param1:Sprite, param2:Number, param3:Number, param4:int = 13, param5:int = 0, param6:Position = null, param7:Style = null) : void
      {
         super.init_Cell(param1,_width,_height,false,false,0,param6,param7);
         _type = "slider";
         this._orientation = param4;
         _width = param2;
         _height = param3;
         this._snap = param5;
      }
      
      override public function create() : void
      {
         super.create();
         var _loc1_:Style = _style.clone({"gradient":false});
         if(!this.showGradient)
         {
            _loc1_.border = false;
            _loc1_.borderWidth = 0;
            _loc1_.round = 0;
            _loc1_.backgroundColor = _style.buttonColor;
            _loc1_.backgroundAlpha = 50;
         }
         else
         {
            _border = true;
            _loc1_.background = false;
            _loc1_.border = false;
            background = true;
         }
         this._backing = BButton(addChild(new BButton(null,"",-1,_width,_height,false,false,true,null,_loc1_)));
         this._backing.addEventListener(EVENT_PRESS,this.onSliderClick);
         var _loc2_:Style = _style.clone();
         _loc2_.borderWidth = 2;
         _loc2_.borderColor = ColorTools.getTintedColor(_style.buttonColor,_style.backgroundColor,0.75);
         _loc2_.backgroundColor = _style.buttonColor;
         this._dragger = BButton(addChild(new BButton(null,"",-1,_width,_height,false,false,true,null,_loc2_)));
         this._dragger.addEventListener(EVENT_CHANGE,this.onSliderMove);
         this._dragger.addEventListener(EVENT_RELEASE,this.onSliderRelease);
      }
      
      public function onSliderClick(param1:Event) : void
      {
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            if(_mc.mouseX < this._dragger.x)
            {
               this._dragger.valueX -= this._dragger.width / width;
            }
            else if(_mc.mouseX > this._dragger.x + this._dragger.width)
            {
               this._dragger.valueX += this._dragger.width / width;
            }
            this._sliderValue = this._dragger.valueX;
         }
         else
         {
            if(_mc.mouseY < this._dragger.y)
            {
               this._dragger.valueY -= this._dragger.height / height;
            }
            else if(_mc.mouseY > this._dragger.y + this._dragger.height)
            {
               this._dragger.valueY += this._dragger.height / height;
            }
            this._sliderValue = this._dragger.valueY;
         }
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      public function onSliderMove(param1:Event) : void
      {
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            this._sliderValue = BButton(param1.target).valueX;
         }
         else
         {
            this._sliderValue = BButton(param1.target).valueY;
         }
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      public function onSliderRelease(param1:Event) : void
      {
         if(this._snap > 0)
         {
            this.sliderValue = Math.round(this._sliderValue * this._snap) / this._snap;
         }
      }
   }
}

