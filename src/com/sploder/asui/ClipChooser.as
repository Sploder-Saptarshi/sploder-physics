package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ClipChooser extends Cell
   {
      protected var _textLabel:String = "";
      
      protected var _choices:Array;
      
      protected var _alts:Array;
      
      protected var _promptText:String = "";
      
      protected var _alt:String = "";
      
      protected var _open:Boolean = false;
      
      protected var _choiceButton:ClipButton;
      
      protected var _button:BButton;
      
      protected var _buttons:Array;
      
      protected var _dropdown:Cell;
      
      protected var _dropdownPosition:int;
      
      protected var _textField:HTMLField;
      
      protected var _selectionIndex:Number = -1;
      
      protected var _activeChoice:ClipButton;
      
      protected var _homeDepth:int = 1;
      
      protected var _startWidth:uint = 0;
      
      public var rowLength:int = 3;
      
      public var choicesPadding:int = -1;
      
      public var choicesShrink:int = 0;
      
      public var choicesOffsetX:int = 0;
      
      public var choicesOffsetY:int = 0;
      
      public var choicesLineMode:Boolean = false;
      
      protected var _choicesCreated:Boolean = false;
      
      protected var _firstCall:Boolean = true;
      
      public function ClipChooser(param1:Sprite, param2:String, param3:Array, param4:Array, param5:Number = 0, param6:String = "", param7:Number = NaN, param8:Number = NaN, param9:int = 16, param10:Position = null, param11:Style = null)
      {
         super();
         this.init_ClipChooser(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get alt() : String
      {
         return this._alt;
      }
      
      public function set alt(param1:String) : void
      {
         this._alt = param1;
      }
      
      override public function get value() : String
      {
         return this._choiceButton != null ? this._choiceButton.symbolName : "";
      }
      
      override public function set value(param1:String) : void
      {
         if(param1 == this.value)
         {
            return;
         }
         if(this._buttons == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._buttons.length)
         {
            if(ClipButton(this._buttons[_loc2_]).symbolName == param1)
            {
               this._activeChoice = this._buttons[_loc2_];
               this._activeChoice.select();
               this._choiceButton.setSymbol(this._activeChoice.symbolName);
               dispatchEvent(new Event(EVENT_CHANGE));
               return;
            }
            _loc2_++;
         }
      }
      
      public function get choices() : Array
      {
         return this._choices;
      }
      
      public function set choices(param1:Array) : void
      {
         this._choices = param1;
         this.recreate();
      }
      
      protected function init_ClipChooser(param1:Sprite, param2:String, param3:Array, param4:Array, param5:Number = 0, param6:String = "", param7:Number = NaN, param8:Number = NaN, param9:int = 16, param10:Position = null, param11:Style = null) : void
      {
         super.init_Cell(param1,NaN,NaN,false,false,0,param10,param11);
         _type = "combobox";
         this._textLabel = param2.length > 0 ? param2 : this._textLabel;
         this._choices = param3.concat();
         this._alts = param4;
         this._selectionIndex = !isNaN(param5) ? param5 : -1;
         this._promptText = param6.length > 0 ? param6 : this._promptText;
         _width = !isNaN(param7) ? param7 : 80;
         _height = !isNaN(param8) ? param8 : 60;
         this._dropdownPosition = param9;
         this._startWidth = _width;
      }
      
      override public function create() : void
      {
         super.create();
         this.createElements();
      }
      
      protected function createElements() : void
      {
         var _loc4_:Array = null;
         _width = this._startWidth;
         var _loc1_:Position = new Position({
            "placement":Position.PLACEMENT_FLOAT,
            "clear":Position.CLEAR_NONE,
            "margins":0,
            "padding":0
         });
         var _loc2_:Style = _style.clone();
         _loc2_.borderWidth = _style.borderWidth / 2;
         var _loc3_:Style = _loc2_.clone();
         _loc3_.padding = _style.padding;
         _loc3_.bgGradient = false;
         _loc3_.buttonColor = _loc3_.unselectedColor = _style.backgroundColor;
         this._choiceButton = new ClipButton(null,this._choices[this._selectionIndex],"",-1,_width - 20,_height,10,false,false,false,this.choicesLineMode,_loc1_,_loc3_);
         this._choiceButton.tabSide = Position.POSITION_RIGHT;
         this._choiceButton.alt = this._alt;
         addChild(this._choiceButton);
         this._choiceButton.toggleMode = false;
         this._choiceButton.addEventListener(EVENT_CLICK,this.toggle);
         switch(this._dropdownPosition)
         {
            case Position.POSITION_ABOVE:
               _loc4_ = Create.ICON_ARROW_UP;
               break;
            case Position.POSITION_RIGHT:
               _loc4_ = Create.ICON_ARROW_RIGHT;
               break;
            case Position.POSITION_BELOW:
               _loc4_ = Create.ICON_ARROW_DOWN;
               break;
            case Position.POSITION_LEFT:
               _loc4_ = Create.ICON_ARROW_LEFT;
         }
         this._button = new BButton(null,{
            "icon":Create.ICON_ARROW_LEFT,
            "iconToggled":_loc4_
         },-1,20,_height,false,false,false,_loc1_,_loc2_);
         this._button.tabSide = Position.POSITION_LEFT;
         this._button.alt = this._alt;
         addChild(this._button);
         this._button.addEventListener(EVENT_CLICK,this.toggle);
         this._choiceButton.linkedButton = this._button;
         this._button.linkedButton = this._choiceButton;
      }
      
      protected function createChoices() : void
      {
         var _loc2_:Array = null;
         var _loc9_:BButton = null;
         var _loc11_:ClipButton = null;
         if(this._choicesCreated)
         {
            return;
         }
         this._choicesCreated = true;
         var _loc1_:Position = new Position({
            "placement":Position.PLACEMENT_FLOAT,
            "clear":Position.CLEAR_NONE,
            "margins":0,
            "padding":0
         });
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = Math.min(this._choices.length,this.rowLength) * (_height - this.choicesShrink);
         var _loc6_:Number = Math.ceil(this._choices.length / this.rowLength) * (_height - this.choicesShrink);
         switch(this._dropdownPosition)
         {
            case Position.POSITION_ABOVE:
               _loc2_ = Create.ICON_ARROW_UP;
               _loc3_ = 0 - _loc6_;
               _loc4_ = 0;
               break;
            case Position.POSITION_RIGHT:
               _loc2_ = Create.ICON_ARROW_RIGHT;
               _loc3_ = 0;
               _loc4_ = _width;
               break;
            case Position.POSITION_BELOW:
               _loc2_ = Create.ICON_ARROW_DOWN;
               _loc3_ = _height;
               _loc4_ = 0;
               break;
            case Position.POSITION_LEFT:
               _loc2_ = Create.ICON_ARROW_LEFT;
               _loc3_ = 0;
               _loc4_ = 0 - _loc5_;
               _loc5_ = Math.min(this._choices.length,this.rowLength) * _height;
         }
         _loc4_ += this.choicesOffsetX;
         _loc3_ += this.choicesOffsetY;
         var _loc7_:Style;
         (_loc7_ = _style.clone()).padding = 0;
         _loc7_.bgGradient = true;
         _loc7_.bgGradientColors = [ColorTools.getTintedColor(_loc7_.inactiveColor,16777215,0.2),_loc7_.inactiveColor];
         _loc7_.borderColor = ColorTools.getTintedColor(_style.borderColor,_style.backgroundColor,0.5);
         this._dropdown = Cell(addChild(new Cell(null,_loc5_,_loc6_,true,true,this.choicesPadding == 0 ? 0 : _style.round,new Position({
            "placement":Position.PLACEMENT_ABSOLUTE,
            "top":_loc3_,
            "left":_loc4_,
            "ignoreContentPadding":true
         }),_loc7_)));
         this._dropdown.maskContent = this._dropdown.trapMouse = this._dropdown.collapse = true;
         this._dropdown.hide();
         var _loc8_:Style = _style.clone();
         _loc8_.background = _loc8_.border = false;
         _loc8_.gradient = false;
         _loc8_.unselectedTextColor = ColorTools.getTintedColor(_style.textColor,_style.backgroundColor,0.5);
         _loc8_.inverseTextColor = ColorTools.getTintedColor(_style.textColor,_style.backgroundColor,0.2);
         if(this.choicesPadding >= 0 && this.choicesPadding < _loc8_.round)
         {
            _loc8_.round = this.choicesPadding;
         }
         _loc1_.margin = 0;
         var _loc10_:String = "";
         this._buttons = [];
         var _loc12_:int = 0;
         while(_loc12_ < this._choices.length)
         {
            _loc10_ = "";
            if(Boolean(this._alts) && Boolean(this._alts[_loc12_]))
            {
               _loc10_ = this._alts[_loc12_];
            }
            _loc11_ = new ClipButton(null,this._choices[_loc12_],"",-1,_height - this.choicesShrink,_height - this.choicesShrink,this.choicesPadding >= 0 ? this.choicesPadding : 10,false,true,false,false,_loc1_,_loc8_);
            (_loc9_ = BButton(this._dropdown.addChild(_loc11_))).alt = _loc10_;
            _loc9_.reselectable = true;
            _loc9_.addEventListener(EVENT_CLICK,this.onChoice);
            this._buttons.push(_loc9_);
            _loc12_++;
         }
         addEventListener(EVENT_BLUR,this._dropdown.hide);
         if(this._textLabel.length)
         {
            this._textField = new HTMLField(null,"<p align=\"center\">" + this._textLabel + "</p>",_width,true,null,_style);
            addChild(this._textField);
            _height += this._textField.height;
         }
         if(this._selectionIndex >= 0)
         {
            if(BButton(this._dropdown.childNodes[this._selectionIndex]))
            {
               BButton(this._dropdown.childNodes[this._selectionIndex]).dispatchEvent(new Event(EVENT_CLICK));
            }
            this.toggle();
         }
      }
      
      protected function recreate() : void
      {
         clear();
         this._choicesCreated = false;
         this._selectionIndex = this._choices.length - 1;
         this.createElements();
      }
      
      public function onChoice(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._dropdown.childNodes.length)
         {
            if(this._dropdown.childNodes[_loc2_] != param1.target)
            {
               ClipButton(this._dropdown.childNodes[_loc2_]).deselect();
            }
            _loc2_++;
         }
         this._activeChoice = ClipButton(param1.target);
         this._activeChoice.select();
         var _loc3_:* = this._choiceButton.symbolName != this._activeChoice.symbolName;
         if(_loc3_)
         {
            this._choiceButton.setSymbol(this._activeChoice.symbolName);
         }
         dispatchEvent(new Event(EVENT_CLICK));
         if(!this._firstCall)
         {
            dispatchEvent(new Event(EVENT_SELECT));
         }
         this._firstCall = false;
         if(_loc3_)
         {
            dispatchEvent(new Event(EVENT_CHANGE));
         }
         this.toggle();
      }
      
      public function select(param1:uint = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = false;
         if(!this._choicesCreated)
         {
            this.createChoices();
         }
         if(this._buttons == null)
         {
            return;
         }
         if(param1 < this._buttons.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this._dropdown.childNodes.length)
            {
               if(_loc2_ != param1)
               {
                  BButton(this._dropdown.childNodes[_loc2_]).deselect();
               }
               _loc2_++;
            }
            this._activeChoice = this._buttons[param1];
            this._activeChoice.select();
            _loc3_ = this._choiceButton.symbolName != this._activeChoice.symbolName;
            if(_loc3_)
            {
               this._choiceButton.setSymbol(this._activeChoice.symbolName);
            }
            dispatchEvent(new Event(EVENT_CLICK));
            if(_loc3_)
            {
               dispatchEvent(new Event(EVENT_CHANGE));
            }
         }
      }
      
      public function selectByValue(param1:*) : void
      {
         var _loc2_:int = 0;
         if(this._choices != null)
         {
            _loc2_ = int(this._choices.indexOf(param1));
            if(_loc2_ >= 0)
            {
               this.select(_loc2_);
            }
         }
      }
      
      override public function toggle(param1:Event = null) : void
      {
         if(!this._choicesCreated)
         {
            this.createChoices();
         }
         if(this._dropdown)
         {
            this._dropdown.toggle();
         }
         if(Boolean(this._dropdown) && this._dropdown.visible)
         {
            focused = this;
            if(_mc.parent != null)
            {
               this._homeDepth = _mc.parent.getChildIndex(_mc);
               _mc.parent.setChildIndex(_mc,_mc.parent.numChildren - 1);
            }
            this._button.select();
            if(param1 == null)
            {
               dispatchEvent(new Event(EVENT_FOCUS));
            }
         }
         else
         {
            if(_mc.parent != null && this._homeDepth <= _mc.parent.numChildren)
            {
               _mc.parent.setChildIndex(_mc,this._homeDepth);
            }
            this._button.deselect();
            if(param1 == null)
            {
               dispatchEvent(new Event(EVENT_BLUR));
            }
         }
      }
      
      override public function enable(param1:Event = null) : void
      {
         super.enable(param1);
         if(this._activeChoice)
         {
            this._activeChoice.enable();
         }
      }
      
      override public function disable(param1:Event = null) : void
      {
         if(Boolean(this._dropdown) && this._dropdown.visible)
         {
            this.toggle(param1);
         }
         super.disable(param1);
         if(this._activeChoice)
         {
            this._activeChoice.disable();
         }
      }
      
      override public function onBlur(param1:Event = null) : void
      {
         if(Boolean(this._dropdown) && this._dropdown.visible)
         {
            this.toggle(param1);
         }
      }
   }
}

