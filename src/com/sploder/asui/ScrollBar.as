package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ScrollBar extends Cell
   {
      private var _orientation:int;
      
      private var _btn_back:BButton;
      
      private var _btn_fwd:BButton;
      
      private var _slider:Slider;
      
      private var _pageRatio:Number = 1;
      
      private var _targetCell:Cell;
      
      public function ScrollBar(param1:Sprite = null, param2:Number = NaN, param3:Number = NaN, param4:int = 13, param5:Position = null, param6:Style = null)
      {
         super();
         this.init_ScrollBar(param1,param2,param3,param4,param5,param6);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get targetCell() : Cell
      {
         return this._targetCell;
      }
      
      public function set targetCell(param1:Cell) : void
      {
         this._targetCell = param1;
         if(this._orientation == Position.ORIENTATION_VERTICAL)
         {
            this._targetCell.scrollable = true;
         }
         if(this._targetCell != null)
         {
            this._targetCell.maskContent = true;
            clear();
            this.create();
            this.onTargetCellChange();
            this._targetCell.addEventListener(EVENT_CHANGE,this.onTargetCellChange);
            this._targetCell.addEventListener(EVENT_FOCUS,this.onTargetCellShow);
            this._targetCell.addEventListener(EVENT_BLUR,this.onTargetCellHide);
            this._targetCell.addEventListener(EVENT_HOVER_START,this.scrollBack);
            this._targetCell.addEventListener(EVENT_HOVER_END,this.scrollForward);
         }
      }
      
      private function init_ScrollBar(param1:Sprite = null, param2:Number = NaN, param3:Number = NaN, param4:int = 13, param5:Position = null, param6:Style = null) : void
      {
         super.init_Cell(param1,_width,_height,false,false,0,param5,param6);
         _type = "scrollbar";
         this._orientation = param4;
         _width = param2;
         _height = param3;
      }
      
      override public function create() : void
      {
         var _loc5_:Position = null;
         var _loc6_:int = 0;
         super.create();
         if(this._targetCell == null)
         {
            return;
         }
         var _loc1_:Number = 0;
         if(_parentCell != null)
         {
            if(_parentCell.style.border)
            {
               _loc1_ = _parentCell.style.borderWidth;
            }
            _loc6_ = this._targetCell.background == false ? 10 : 0;
            if(this._orientation == Position.ORIENTATION_HORIZONTAL)
            {
               _width = this._targetCell.width;
               _height = _height == 0 || isNaN(_height) ? 20 : _height;
               _position = new Position({
                  "margins":[_position.margin_top,_position.margin_right,_position.margin_bottom,_position.margin_left],
                  "placement":Position.PLACEMENT_ABSOLUTE,
                  "zindex":1000,
                  "top":this._targetCell.y + this._targetCell.height + _loc6_,
                  "left":this._targetCell.x
               });
            }
            else
            {
               _width = _width == 0 || isNaN(_width) ? 20 : _width;
               _height = this._targetCell.height;
               _position = new Position({
                  "margins":[_position.margin_top,_position.margin_right,_position.margin_bottom,_position.margin_left],
                  "placement":Position.PLACEMENT_ABSOLUTE,
                  "zindex":1000,
                  "top":this._targetCell.y,
                  "left":this._targetCell.x + this._targetCell.width + _loc6_
               });
            }
         }
         var _loc2_:Style = _style.clone();
         _loc2_.borderWidth = 2;
         _loc2_.borderColor = ColorTools.getTintedColor(_style.buttonColor,_style.backgroundColor,0.5);
         var _loc3_:Number = ColorTools.getTintedColor(_style.backgroundColor,_style.borderColor,0.3);
         var _loc4_:Number = ColorTools.getTintedColor(_style.backgroundColor,_style.borderColor,0.1);
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            _loc5_ = new Position({
               "placement":Position.PLACEMENT_FLOAT,
               "margin_right":2
            });
            DrawingMethods.roundedRect(_mc,true,0,0,_height,_height,"0",[_loc4_,_loc3_],[50,50],[0,255]);
            DrawingMethods.roundedRect(_mc,false,_height + 2,0,_width - _height * 2 - 4,_height,"0",[_loc4_,_loc3_],[50,50],[0,255]);
            DrawingMethods.roundedRect(_mc,false,_width - _height,0,_height,_height,"0",[_loc4_,_loc3_],[50,50],[0,255]);
            this._btn_back = BButton(addChild(new BButton(null,Create.ICON_ARROW_RIGHT,-1,20,20,false,false,false,_loc5_,_loc2_)));
            this._slider = Slider(addChild(new Slider(null,_width - 44,_height,this._orientation,0,_loc5_,_style)));
            this._btn_fwd = BButton(addChild(new BButton(null,Create.ICON_ARROW_LEFT,-1,20,20,false,false,false,_loc5_,_loc2_)));
         }
         else
         {
            _loc5_ = new Position({"margin_bottom":2});
            DrawingMethods.roundedRect(_mc,true,0,0,_width,_width,"0",[_loc4_,_loc3_],[50,50],[0,255]);
            DrawingMethods.roundedRect(_mc,false,0,_width + 2,_width,_height - _width * 2 - 4,"0",[_loc4_,_loc3_],[50,50],[0,255]);
            DrawingMethods.roundedRect(_mc,false,0,_height - _width,_width,_width,"0",[_loc4_,_loc3_],[50,50],[0,255]);
            this._btn_back = BButton(addChild(new BButton(null,Create.ICON_ARROW_UP,-1,_width,_width,false,false,false,_loc5_,_loc2_)));
            this._slider = Slider(addChild(new Slider(null,_width,_height - _width * 2 - 4,this._orientation,0,_loc5_,_style)));
            this._btn_fwd = BButton(addChild(new BButton(null,Create.ICON_ARROW_DOWN,-1,_width,_width,false,false,false,_loc5_,_loc2_)));
         }
         this._btn_back.addEventListener(EVENT_CLICK,this.pageBack);
         this._slider.addEventListener(EVENT_CHANGE,this.onChange);
         this._btn_fwd.addEventListener(EVENT_CLICK,this.pageForward);
         if(_parentCell)
         {
            _parentCell.addEventListener(EVENT_BLUR,this.onBlur);
         }
         this._btn_back.tabEnabled = this._slider.tabEnabled = this._btn_fwd.tabEnabled = false;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function alignToTarget() : void
      {
         var _loc1_:Number = NaN;
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            _loc1_ = this.targetCell.width - this.targetCell.contentWidth;
         }
         else
         {
            _loc1_ = this.targetCell.height - this.targetCell.contentHeight;
         }
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            this._slider.sliderValue = 0 - ((0 - this.targetCell.contentX + _loc1_) / _loc1_ - 1);
         }
         else
         {
            this._slider.sliderValue = 0 - ((0 - this.targetCell.contentY + _loc1_) / _loc1_ - 1);
         }
      }
      
      private function updateComponents() : void
      {
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            this._slider.ratio = this._targetCell.width / this._targetCell.contentWidth;
         }
         else
         {
            this._slider.ratio = this._targetCell.height / this._targetCell.contentHeight;
         }
         if(this._slider.ratio == 1)
         {
            this.disable();
         }
         else
         {
            this.enable();
         }
      }
      
      public function onChange(param1:Event = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = 0;
         if(this.targetCell == null)
         {
            return;
         }
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            _loc2_ = this.targetCell.width - this.targetCell.contentWidth;
         }
         else
         {
            _loc2_ = this.targetCell.height - this.targetCell.contentHeight;
         }
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            this.targetCell.contentX = Math.round(_loc2_ - _loc2_ * (1 - this._slider.sliderValue));
         }
         else
         {
            this.targetCell.contentY = Math.round(_loc2_ - _loc2_ * (1 - this._slider.sliderValue));
         }
      }
      
      public function onTargetCellChange(param1:Event = null) : void
      {
         var _loc3_:Number = NaN;
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            this._pageRatio = Math.min(1,Math.max(0.01,this.targetCell.width / (this.targetCell.contentWidth - this.targetCell.width)));
         }
         else
         {
            this._pageRatio = Math.min(1,Math.max(0.01,this.targetCell.height / (this.targetCell.contentHeight - this.targetCell.height)));
         }
         var _loc2_:int = this._targetCell.background == false ? 10 : 5;
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            _position.top = this._targetCell.y + this._targetCell.height + _position.margin_top + _loc2_;
            _position.left = this._targetCell.x;
         }
         else
         {
            _position.top = this._targetCell.y;
            _position.left = this._targetCell.x + this._targetCell.width + _position.margin_left + _loc2_;
         }
         x = _position.left;
         y = _position.top;
         this.updateComponents();
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            _loc3_ = this.targetCell.width - this.targetCell.contentWidth;
         }
         else
         {
            _loc3_ = this.targetCell.height - this.targetCell.contentHeight;
         }
         if(this._orientation == Position.ORIENTATION_HORIZONTAL)
         {
            this._slider.sliderValue = 0 - ((0 - this.targetCell.contentX + _loc3_) / _loc3_ - 1);
         }
         else
         {
            this._slider.sliderValue = 0 - ((0 - this.targetCell.contentY + _loc3_) / _loc3_ - 1);
         }
         this.onChange();
      }
      
      public function onTargetCellShow(param1:Event) : void
      {
         this.updateComponents();
         show();
      }
      
      public function onTargetCellHide(param1:Event = null) : void
      {
         if(this._targetCell.visible == false)
         {
            hide();
         }
      }
      
      override public function enable(param1:Event = null) : void
      {
         super.enable();
         this._btn_back.show();
         this._btn_fwd.show();
         this._slider.show();
      }
      
      override public function disable(param1:Event = null) : void
      {
         super.disable();
         this._btn_back.hide();
         this._btn_fwd.hide();
         this._slider.hide();
      }
      
      protected function pageForward(param1:Event = null) : void
      {
         this._slider.sliderValue += this._pageRatio / 3;
         this.onChange();
      }
      
      public function reset(param1:Event = null) : void
      {
         this._slider.sliderValue = 0;
         this.onChange();
      }
      
      protected function center(param1:Event = null) : void
      {
         this._slider.sliderValue = 0.5;
         this.onChange();
      }
      
      protected function pageBack(param1:Event = null) : void
      {
         this._slider.sliderValue -= this._pageRatio / 3;
         this.onChange();
      }
      
      public function scrollForward(param1:Event = null) : void
      {
         var _loc2_:Number = NaN;
         if(this._orientation == Position.ORIENTATION_VERTICAL)
         {
            _loc2_ = this._pageRatio / _height;
            this._slider.sliderValue += _loc2_ * 20;
         }
         else
         {
            _loc2_ = this._pageRatio / _width;
            this._slider.sliderValue += _loc2_ * 20;
         }
         this.onChange();
      }
      
      public function scrollBack(param1:Event = null) : void
      {
         var _loc2_:Number = NaN;
         if(this._orientation == Position.ORIENTATION_VERTICAL)
         {
            _loc2_ = this._pageRatio / _height;
            this._slider.sliderValue -= _loc2_ * 20;
         }
         else
         {
            _loc2_ = this._pageRatio / _width;
            this._slider.sliderValue -= _loc2_ * 20;
         }
         this.onChange();
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.delta;
         this._slider.sliderValue -= _loc2_ / 60;
         this.onChange();
      }
      
      public function applyDelta(param1:Number = 0) : void
      {
         this._slider.sliderValue -= param1 / 60;
         this.onChange();
      }
      
      override public function onBlur(param1:Event = null) : void
      {
         if(this._slider != null)
         {
            this._slider.sliderValue = 0;
         }
         this.onChange();
      }
   }
}

