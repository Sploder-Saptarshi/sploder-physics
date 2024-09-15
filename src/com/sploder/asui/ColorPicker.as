package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ColorPicker extends Cell
   {
      protected var _title:HTMLField;
      
      protected var _spectrum:ColorSpectrum;
      
      protected var _slider:Slider;
      
      protected var _field:FormField;
      
      protected var _chip:ColorChip;
      
      protected var _color:int = 10066329;
      
      protected var _size:int = 100;
      
      protected var _textLabel:String = "";
      
      protected var _sliderStyle:Style;
      
      public var showFullPicker:Boolean = true;
      
      public var showColorWheelOnly:Boolean = false;
      
      public var dimColorWheel:Boolean = true;
      
      public function ColorPicker(param1:Sprite, param2:int = 10066329, param3:int = 100, param4:String = "", param5:Position = null, param6:Style = null)
      {
         super();
         this.init_ColorPicker(param1,param2,param3,param4,param5,param6);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get field() : FormField
      {
         return this._field;
      }
      
      override public function get value() : String
      {
         return ColorTools.numberToHTMLColor(this._color);
      }
      
      override public function set value(param1:String) : void
      {
         super.value = param1;
         if(param1 != "")
         {
            this.color = ColorTools.HTMLColorToNumber(param1);
         }
         else
         {
            this.color = -1;
         }
         if(form != null && name.length > 0)
         {
            form[name] = param1;
         }
      }
      
      public function get color() : int
      {
         return this._color;
      }
      
      public function set color(param1:int) : void
      {
         if(param1 >= 0 && param1 <= 16777215)
         {
            this._color = param1;
            if(this.showFullPicker)
            {
               this._slider.sliderValue = 1 - ColorTools.hex2hsv(this._color).v / 100;
            }
            if(this.showFullPicker)
            {
               this._spectrum.color = this._color;
            }
            this.setFieldValue();
            if(this._chip)
            {
               this._chip.color = this._color;
            }
            if(this._chip)
            {
               this._chip.mc.alpha = 1;
            }
         }
         else if(param1 == -1)
         {
            if(this._field)
            {
               this._field.value = "";
            }
            this._color = -1;
            if(this._chip)
            {
               this._chip.color = 13421772;
            }
            if(this._chip)
            {
               this._chip.mc.alpha = 0.3;
            }
         }
      }
      
      private function init_ColorPicker(param1:Sprite, param2:int = 10066329, param3:int = 100, param4:String = "", param5:Position = null, param6:Style = null) : void
      {
         super.init_Cell(param1,NaN,NaN,false,false,0,param5,param6);
         _type = "colorpicker";
         this._color = param2;
         this._size = param3;
         this._textLabel = param4.length > 0 ? param4 : this._textLabel;
      }
      
      override public function create() : void
      {
         super.create();
         var _loc1_:Style = _style.clone({"embedFonts":false});
         var _loc2_:Number = ColorTools.hex2hsv(this._color).v / 100;
         if(this._textLabel != "")
         {
            this._title = new HTMLField(null,"<p><b>" + this._textLabel + "<b></p>",this._size + 10 + 16,false,new Position({"margin_bottom":4}),_style);
            addChild(this._title);
         }
         if(this.showFullPicker || this.showColorWheelOnly)
         {
            this._spectrum = new ColorSpectrum(null,this._size,this._size,new Position({
               "placement":Position.PLACEMENT_FLOAT,
               "margin_right":10,
               "margin_bottom":10
            }),_loc1_);
            this._spectrum.dimColorWheel = this.dimColorWheel;
            addChild(this._spectrum);
            this._spectrum.color = this._color;
            this._spectrum.addEventListener(EVENT_CHANGE,this.onSpectrumChange);
            this._sliderStyle = _loc1_.clone();
            this._sliderStyle.bgGradient = true;
            this.setSliderColors();
            this._slider = new Slider(null,20,this._size,Position.ORIENTATION_VERTICAL,0,new Position({
               "placement":Position.PLACEMENT_FLOAT,
               "margin_left":4
            }),this._sliderStyle);
            this._slider.showGradient = true;
            addChild(this._slider);
            this._slider.ratio = 0.01;
            this._slider.sliderValue = 1 - _loc2_;
            this._slider.addEventListener(EVENT_CHANGE,this.onSliderChange);
         }
         if(!this.showColorWheelOnly)
         {
            this._field = new FormField(null,"",this._size,26,true,new Position({
               "placement":Position.PLACEMENT_FLOAT,
               "margin_right":4,
               "margin_bottom":10,
               "clear":Position.CLEAR_LEFT
            }),_loc1_);
            addChild(this._field);
            this._field.value = this._color.toString(16);
            this._field.addEventListener(EVENT_CHANGE,this.onFieldChange);
            this._field.restrict = "0123456789abcdef";
            this._field.maxChars = 6;
            this._chip = new ColorChip(null,this._color,26,26,new Position({"margin_top":0},Position.ALIGN_LEFT,Position.PLACEMENT_FLOAT),_loc1_);
            addChild(this._chip);
         }
         _width = Position.getCellContentWidth(this);
         _height = Position.getCellContentHeight(this);
      }
      
      protected function setSliderColors() : void
      {
         var _loc1_:Object = ColorTools.hex2hsv(this._color);
         _loc1_.v = 90;
         var _loc2_:Object = ColorTools.hex2hsv(this._color);
         _loc2_.v = 10;
         this._sliderStyle.bgGradientColors = [ColorTools.hsv2hex(_loc1_.h,_loc1_.s,_loc1_.v),ColorTools.hsv2hex(_loc2_.h,_loc2_.s,_loc2_.v)];
         if(this._slider != null)
         {
            this._slider.background = true;
         }
      }
      
      protected function setFieldValue() : void
      {
         if(this._color != -1)
         {
            if(this._field)
            {
               this._field.value = this._color.toString(16);
               while(this._field.value.length < 6)
               {
                  this._field.value = "0" + this._field.value;
               }
            }
         }
         else if(this._field)
         {
            this._field.value = "";
         }
      }
      
      protected function onSliderChange(param1:Event) : void
      {
         if(this._spectrum.brightness != 1 - this._slider.sliderValue)
         {
            this._spectrum.brightness = 1 - this._slider.sliderValue;
            this._color = this._spectrum.color;
            this.setFieldValue();
            this.setSliderColors();
            if(this._chip)
            {
               this._chip.color = this._color;
            }
         }
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      protected function onSpectrumChange(param1:Event) : void
      {
         if(this._slider.sliderValue > 0.8)
         {
            this._slider.sliderValue = 0.6;
            this._spectrum.brightness = 1 - this._slider.sliderValue;
         }
         this._color = this._spectrum.color;
         this.setFieldValue();
         this.setSliderColors();
         if(this._chip)
         {
            this._chip.color = this._color;
         }
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      protected function onFieldChange(param1:Event) : void
      {
         if(this._field.value.length == 6 && parseInt(this._field.value,16) >= 0 && parseInt(this._field.value,16) <= 16777215)
         {
            this._color = parseInt(this._field.value,16);
            if(this.showFullPicker)
            {
               this._slider.sliderValue = 1 - ColorTools.hex2hsv(this._color).v / 100;
            }
            if(this.showFullPicker)
            {
               this._spectrum.color = this._color;
            }
            if(this._chip)
            {
               this._chip.color = this._color;
               this._chip.mc.alpha = 1;
            }
         }
         else if(this._chip)
         {
            this._chip.mc.alpha = 0.3;
         }
         dispatchEvent(new Event(EVENT_CHANGE));
      }
   }
}

