package com.sploder.asui
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class DialogueBox extends Cell
   {
      protected var _buttonMask:Sprite;
      
      protected var _closeButton:BButton;
      
      protected var _title:String;
      
      protected var _titleField:HTMLField;
      
      protected var _controls:Array;
      
      protected var _controlsCell:Cell;
      
      protected var _contentCell:Cell;
      
      protected var _scroll:Boolean;
      
      protected var _scrollbar:ScrollBar;
      
      protected var _buttons:Array;
      
      public var pointer:Boolean = false;
      
      public var pointerPosition:int = 0;
      
      public var pointerSize:int = 0;
      
      public var useBackgroundMask:Boolean = true;
      
      public var offsetX:int = 0;
      
      public var offsetY:int = 0;
      
      public var contentHasBackground:Boolean = false;
      
      public var contentHasBorder:Boolean = false;
      
      public var contentPadding:int = 20;
      
      public var contentBottomMargin:Number = 20;
      
      public var contentStyle:Style;
      
      public function DialogueBox(param1:Sprite, param2:Number, param3:Number, param4:String = "", param5:Array = null, param6:Boolean = false, param7:Number = 0, param8:Position = null, param9:Style = null)
      {
         super();
         this.init_DialogueBox(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get buttons() : Array
      {
         return this._buttons;
      }
      
      public function get contentCell() : Cell
      {
         return this._contentCell;
      }
      
      public function get titleField() : HTMLField
      {
         return this._titleField;
      }
      
      public function get scrollbar() : ScrollBar
      {
         return this._scrollbar;
      }
      
      private function init_DialogueBox(param1:Sprite, param2:Number, param3:Number, param4:String = "", param5:Array = null, param6:Boolean = false, param7:Number = 0, param8:Position = null, param9:Style = null) : void
      {
         super.init_Cell(param1,_width,_height,true,true,0,param8,param9);
         _type = "dialoguebox";
         _width = param2;
         _height = param3;
         this._title = param4;
         this._controls = param5;
         this._scroll = param6;
         this._buttons = [];
         _round = param7;
         _position.zindex = 10000;
      }
      
      override public function create() : void
      {
         var _loc3_:Number = NaN;
         var _loc5_:Graphics = null;
         var _loc6_:BButton = null;
         var _loc7_:Style = null;
         var _loc8_:int = 0;
         if(isNaN(_width))
         {
            _width = Math.floor(_parentCell.width / 2);
         }
         if(isNaN(_height))
         {
            _height = Math.floor(_parentCell.height / 2);
         }
         if(_position == null || _position.placement != Position.PLACEMENT_ABSOLUTE)
         {
            _position = new Position({
               "placement":Position.PLACEMENT_ABSOLUTE,
               "top":(_parentCell.height - _height) / 2 + this.offsetY,
               "left":(_parentCell.width - _width) / 2 + this.offsetX
            });
         }
         _position.zindex = 10000;
         super.create();
         if(this.useBackgroundMask)
         {
            this._buttonMask = new Sprite();
            _mc.addChild(this._buttonMask);
            _loc5_ = this._buttonMask.graphics;
            _loc5_.beginFill(_style.maskColor,_style.maskAlpha);
            _loc5_.drawRect(0,0,_parentCell.width,_parentCell.height);
            this._buttonMask.x = 0 - _position.left;
            this._buttonMask.y = 0 - _position.top;
            _mc.setChildIndex(this._buttonMask,0);
            connectButton(this._buttonMask,false);
            this._buttonMask.useHandCursor = false;
         }
         _mc.filters = [new DropShadowFilter(6,45,0,0.25,8,8,1,2)];
         if(this._title.length > 0)
         {
            this._titleField = new HTMLField(null,"<p align=\"center\"><h3>" + this._title + "</h3></p>",_width - _style.borderWidth * 2 - _round * 2,false,new Position(null,-1,-1,-1,_style.borderWidth + 10 + " 0 0 " + (_style.borderWidth + _round)),_style);
            addChild(this._titleField);
         }
         var _loc1_:Style = _style.clone();
         _loc1_.border = false;
         _loc1_.background = false;
         _loc1_.gradient = false;
         _loc1_.buttonTextColor = _style.buttonColor;
         this._closeButton = addChild(new BButton(null,Create.ICON_CLOSE,-1,20,20,false,false,false,new Position({
            "zindex":1000,
            "placement":Position.PLACEMENT_ABSOLUTE,
            "top":_style.borderWidth + _round / 3,
            "left":_width - 20 - _style.borderWidth - _round / 3
         }),_loc1_)) as BButton;
         this._closeButton.name = name + "_close";
         this._closeButton.addEventListener(Component.EVENT_CLICK,hide);
         if(this._controls != null)
         {
            (_loc7_ = _style.clone()).borderWidth = Math.min(2,_style.borderWidth / 2);
            _loc7_.round = Math.min(10,_style.round);
            this._controlsCell = new Cell(null,_width,50,false,false,0,new Position({
               "placement":Position.PLACEMENT_ABSOLUTE,
               "top":_height - 50
            },Position.ALIGN_CENTER),_style);
            addChild(this._controlsCell);
            _loc8_ = 0;
            while(_loc8_ < this._controls.length)
            {
               (_loc6_ = this._controlsCell.addChild(new BButton(null,this._controls[_loc8_],-1,NaN,NaN,false,false,false,new Position({
                  "placement":Position.PLACEMENT_FLOAT,
                  "margin_right":5
               }),_loc7_)) as BButton).name = name + "_" + _loc6_.value.toLowerCase().split(" ").join("_");
               this._buttons.push(_loc6_);
               _loc8_++;
            }
            this._controlsCell.y = _height - this._controlsCell.height - Math.max(10,_round / 2);
         }
         var _loc2_:Number = _width - Math.max(35,_round * 2 + _style.borderWidth * 2);
         var _loc4_:int = 0;
         if(this._titleField != null)
         {
            _loc3_ = _height - this._titleField.y - this._titleField.height;
         }
         else
         {
            _loc3_ = _height;
            _loc4_ = Math.max(25,_style.borderWidth + _round / 2);
         }
         if(this._controlsCell != null)
         {
            _loc3_ -= this._controlsCell.height + Math.max(10,_round / 2);
         }
         _loc3_ -= this.contentBottomMargin;
         if(this._scroll)
         {
            _loc2_ -= 20;
         }
         if(this.contentStyle == null)
         {
            this.contentStyle = _style;
         }
         this._contentCell = new Cell(null,_loc2_,_loc3_,this.contentHasBackground,this.contentHasBorder,0,new Position(null,-1,-1,-1,_loc4_ + " 0 0 " + Math.max(this.contentPadding,_style.borderWidth + _round)),this.contentStyle);
         this._contentCell.name = name + "_content";
         addChild(this._contentCell);
         if(this._scroll)
         {
            this._scrollbar = new ScrollBar(null,NaN,NaN,Position.ORIENTATION_VERTICAL,null,_style);
            addChild(this._scrollbar);
            this._scrollbar.targetCell = this._contentCell;
         }
      }
      
      override protected function onClick(param1:MouseEvent = null) : void
      {
         super.onClick(param1);
         hide();
      }
      
      override protected function drawBackground() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.drawBackground();
         var _loc3_:int = this.pointerSize;
         var _loc4_:int = _style.borderWidth;
         var _loc5_:Number = _loc4_ * 0.5;
         var _loc6_:Graphics = _bkgd.graphics;
         if(!this.pointer)
         {
            return;
         }
         if(isNaN(this.pointerPosition) || this.pointerPosition == 0)
         {
            this.pointerPosition = _width * 1.5 + _height;
         }
         if(this.pointerPosition < _width)
         {
            _loc1_ = Math.max(this.pointerSize + _loc4_,Math.min(_width - this.pointerSize - _loc4_,this.pointerPosition));
            _loc2_ = 0;
            if(_border)
            {
               _loc6_.moveTo(_loc1_ - _loc3_ + _loc4_ - _loc5_,_loc2_);
               _loc6_.beginFill(_style.borderColor,_style.borderAlpha);
               _loc6_.lineTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_);
               _loc6_.lineTo(_loc1_ + _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_ + _loc3_ - _loc4_ - _loc5_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_ + _loc4_ + _loc5_);
               _loc6_.lineTo(_loc1_ - _loc3_ + _loc4_ + _loc5_,_loc2_);
               _loc6_.endFill();
               _loc6_.moveTo(_loc1_ - _loc3_ + _loc4_ - _loc5_,_loc2_ + _loc4_);
               _loc6_.beginFill(_style.backgroundColor,_style.backgroundAlpha);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_ + _loc4_ + _loc5_);
               _loc6_.lineTo(_loc1_ + _loc3_ - _loc4_ + _loc5_,_loc2_ + _loc4_);
               _loc6_.lineTo(_loc1_ - _loc3_ + _loc4_ - _loc5_,_loc2_ + _loc4_);
               _loc6_.endFill();
            }
            else
            {
               _loc6_.moveTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.beginFill(_style.backgroundColor,_style.backgroundAlpha);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_);
               _loc6_.lineTo(_loc1_ + _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.endFill();
            }
         }
         else if(this.pointerPosition < _width + _height)
         {
            _loc1_ = _width;
            _loc2_ = Math.max(this.pointerSize + _loc4_,Math.min(_height - this.pointerSize - _loc4_,this.pointerPosition - _width));
            if(_border)
            {
               _loc6_.moveTo(_loc1_,_loc2_ - _loc3_ + _loc4_ - _loc5_);
               _loc6_.beginFill(_style.borderColor,_style.borderAlpha);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_);
               _loc6_.lineTo(_loc1_ + _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_ - _loc4_ - _loc5_);
               _loc6_.lineTo(_loc1_ + _loc3_ - _loc4_ - _loc5_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_ + _loc4_ + _loc5_);
               _loc6_.endFill();
               _loc6_.moveTo(_loc1_ - _loc4_,_loc2_ - _loc3_ + _loc4_ - _loc5_);
               _loc6_.beginFill(_style.backgroundColor,_style.backgroundAlpha);
               _loc6_.lineTo(_loc1_ + _loc3_ - _loc4_ - _loc5_,_loc2_);
               _loc6_.lineTo(_loc1_ - _loc4_,_loc2_ + _loc3_ - _loc4_ + _loc5_);
               _loc6_.lineTo(_loc1_ - _loc4_,_loc2_ - _loc3_ + _loc4_ - _loc5_);
               _loc6_.endFill();
            }
            else
            {
               _loc6_.moveTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.beginFill(_style.backgroundColor,_style.backgroundAlpha);
               _loc6_.lineTo(_loc1_ + _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_);
               _loc6_.endFill();
            }
         }
         else if(this.pointerPosition < _width * 2 + _height)
         {
            _loc1_ = Math.max(this.pointerSize + _loc4_,Math.min(_width - this.pointerSize - _loc4_,this.pointerPosition - _width - _height));
            _loc1_ = _width - _loc1_;
            _loc2_ = _height;
            if(_border)
            {
               _loc6_.moveTo(_loc1_ - _loc3_ + _loc4_ - _loc5_,_loc2_);
               _loc6_.beginFill(_style.borderColor,_style.borderAlpha);
               _loc6_.lineTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_);
               _loc6_.lineTo(_loc1_ + _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_ + _loc3_ - _loc4_ - _loc5_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_ - _loc4_ - _loc5_);
               _loc6_.lineTo(_loc1_ - _loc3_ + _loc4_ + _loc5_,_loc2_);
               _loc6_.endFill();
               _loc6_.moveTo(_loc1_ - _loc3_ + _loc4_ - _loc5_,_loc2_ - _loc4_);
               _loc6_.beginFill(_style.backgroundColor,_style.backgroundAlpha);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_ - _loc4_ - _loc5_);
               _loc6_.lineTo(_loc1_ + _loc3_ - _loc4_ + _loc5_,_loc2_ - _loc4_);
               _loc6_.lineTo(_loc1_ - _loc3_ + _loc4_ - _loc5_,_loc2_ - _loc4_);
               _loc6_.endFill();
            }
            else
            {
               _loc6_.moveTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.beginFill(_style.backgroundColor,_style.backgroundAlpha);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_);
               _loc6_.lineTo(_loc1_ + _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.endFill();
            }
         }
         else
         {
            _loc1_ = 0;
            _loc2_ = Math.max(this.pointerSize + _loc4_,Math.min(_height - this.pointerSize - _loc4_,this.pointerPosition - _width * 2 - _height));
            _loc2_ = _height - _loc2_;
            if(_border)
            {
               _loc6_.moveTo(_loc1_,_loc2_ - _loc3_ + _loc4_ - _loc5_);
               _loc6_.beginFill(_style.borderColor,_style.borderAlpha);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_);
               _loc6_.lineTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_ - _loc4_ - _loc5_);
               _loc6_.lineTo(_loc1_ - _loc3_ + _loc4_ + _loc5_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_ + _loc4_ + _loc5_);
               _loc6_.endFill();
               _loc6_.moveTo(_loc1_ + _loc4_,_loc2_ - _loc3_ + _loc4_ - _loc5_);
               _loc6_.beginFill(_style.backgroundColor,_style.backgroundAlpha);
               _loc6_.lineTo(_loc1_ - _loc3_ + _loc4_ + _loc5_,_loc2_);
               _loc6_.lineTo(_loc1_ + _loc4_,_loc2_ + _loc3_ - _loc4_ + _loc5_);
               _loc6_.lineTo(_loc1_ + _loc4_,_loc2_ - _loc3_ + _loc4_ - _loc5_);
               _loc6_.endFill();
            }
            else
            {
               _loc6_.moveTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.beginFill(_style.backgroundColor,_style.backgroundAlpha);
               _loc6_.lineTo(_loc1_ - _loc3_,_loc2_);
               _loc6_.lineTo(_loc1_,_loc2_ + _loc3_);
               _loc6_.lineTo(_loc1_,_loc2_ - _loc3_);
               _loc6_.endFill();
            }
         }
      }
      
      public function addButtonListener(param1:String = null, param2:Function = null, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         var _loc6_:BButton = null;
         for each(_loc6_ in this._buttons)
         {
            _loc6_.addEventListener(param1,param2,param3,param4,param5);
         }
      }
   }
}

