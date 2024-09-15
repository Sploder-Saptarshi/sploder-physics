package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ComboBox extends Cell
   {
      private var _textLabel:String = "";
      
      private var _choices:Array;
      
      private var _promptText:String = "";
      
      private var _open:Boolean = false;
      
      private var _field:FormField;
      
      private var _fieldbutton:BButton;
      
      private var _button:BButton;
      
      private var _buttons:Array;
      
      private var _dropdown:Cell;
      
      private var _selectionIndex:Number = -1;
      
      private var _activeChoice:BButton;
      
      private var _homeDepth:int = 1;
      
      protected var _startWidth:uint = 0;
      
      public var dropDownPosition:int = 15;
      
      public function ComboBox(param1:Sprite, param2:String, param3:Array, param4:Number = 0, param5:String = "", param6:Number = NaN, param7:Position = null, param8:Style = null)
      {
         super();
         this.init_ComboBox(param1,param2,param3,param4,param5,param6,param7,param8);
         if(_container != null)
         {
            this.create();
         }
      }
      
      override public function get value() : String
      {
         return this._field != null ? this._field.value : "";
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
      
      private function init_ComboBox(param1:Sprite, param2:String, param3:Array, param4:Number = 0, param5:String = "", param6:Number = NaN, param7:Position = null, param8:Style = null) : void
      {
         super.init_Cell(param1,NaN,NaN,false,false,0,param7,param8);
         _type = "combobox";
         this._textLabel = param2.length > 0 ? param2 : this._textLabel;
         this._choices = param3.concat();
         this._selectionIndex = !isNaN(param4) ? param4 : -1;
         this._promptText = param5.length > 0 ? param5 : this._promptText;
         _width = !isNaN(param6) ? param6 : 224;
         this._startWidth = _width;
      }
      
      override public function create() : void
      {
         super.create();
         this.createElements();
      }
      
      protected function createElements() : void
      {
         var _loc5_:BButton = null;
         _width = this._startWidth;
         this._field = FormField(addChild(new FormField(null,this._promptText,_width - 34,NaN,false,new Position({
            "placement":Position.PLACEMENT_FLOAT,
            "margins":0,
            "padding":0
         }),_style)));
         this._field.clear = false;
         this._field.tabEnabled = false;
         this._field.editable = false;
         var _loc1_:Style = _style.clone();
         _loc1_.round = 0;
         _loc1_.borderWidth = 2;
         var _loc2_:int = 9;
         if(_style.embedFonts)
         {
            _loc2_ = 7;
         }
         this._button = BButton(addChild(new BButton(null,Create.ICON_ARROW_DOWN,-1,this._field.height - _loc2_,this._field.height - _loc2_,false,false,false,new Position({
            "placement":Position.PLACEMENT_FLOAT,
            "margins":0,
            "padding":0
         }),_loc1_)));
         var _loc3_:Style = _style.clone();
         _loc3_.borderWidth = 2;
         _loc3_.borderColor = ColorTools.getTintedColor(_style.borderColor,_style.backgroundColor,0.5);
         this._dropdown = Cell(addChild(new Cell(null,_width - 38,100,true,true,0,new Position({
            "placement":Position.PLACEMENT_ABSOLUTE,
            "top":25,
            "left":0,
            "ignoreContentPadding":true
         }),_loc3_)));
         this._dropdown.maskContent = this._dropdown.trapMouse = this._dropdown.collapse = true;
         this._dropdown.hide();
         var _loc4_:Style = _style.clone();
         _loc4_.background = _loc4_.border = _loc4_.gradient = false;
         _loc4_.unselectedTextColor = ColorTools.getTintedColor(_style.textColor,_style.backgroundColor,0.5);
         _loc4_.inverseTextColor = ColorTools.getTintedColor(_style.textColor,_style.backgroundColor,0.2);
         _loc4_.round = 0;
         _loc4_.padding = 7;
         this._buttons = [];
         var _loc6_:int = 0;
         while(_loc6_ < this._choices.length)
         {
            _loc5_ = BButton(this._dropdown.addChild(new BButton(null,this._choices[_loc6_],Position.ALIGN_LEFT,_width - 38,NaN,false,true,false,new Position({"margins":0}),_loc4_)));
            _loc5_.addEventListener(EVENT_CLICK,this.onChoice);
            this._buttons.push(_loc5_);
            _loc6_++;
         }
         if(this.dropDownPosition == Position.POSITION_ABOVE)
         {
            this._dropdown.position.top = this._dropdown.y = 0 - this._dropdown.height;
         }
         this._fieldbutton = BButton(addChild(new BButton(null,"",-1,_width - 34,this._field.height - _loc2_,false,false,false,new Position({
            "placement":Position.PLACEMENT_ABSOLUTE,
            "top":0,
            "left":0
         }),_loc4_)));
         this._button.addEventListener(EVENT_CLICK,this.toggle);
         this._fieldbutton.addEventListener(EVENT_CLICK,this.toggle);
         addEventListener(EVENT_BLUR,this._dropdown.hide);
         _height = this._field.height;
         if(this._selectionIndex >= 0)
         {
            BButton(this._dropdown.childNodes[this._selectionIndex]).dispatchEvent(new Event(EVENT_CLICK));
            this.toggle();
         }
      }
      
      protected function recreate() : void
      {
         clear();
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
               BButton(this._dropdown.childNodes[_loc2_]).deselect();
            }
            _loc2_++;
         }
         this._activeChoice = BButton(param1.target);
         this._activeChoice.select();
         var _loc3_:* = this._field.text != this._activeChoice.textLabel;
         this._field.text = this._activeChoice.textLabel;
         dispatchEvent(new Event(EVENT_CLICK));
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
            _loc3_ = this._field.text != this._activeChoice.textLabel;
            this._field.text = this._activeChoice.textLabel;
            dispatchEvent(new Event(EVENT_CLICK));
            if(_loc3_)
            {
               dispatchEvent(new Event(EVENT_CHANGE));
            }
         }
      }
      
      override public function toggle(param1:Event = null) : void
      {
         this._dropdown.toggle();
         if(this._dropdown.visible)
         {
            focused = this;
            if(_mc.parent != null)
            {
               this._homeDepth = _mc.parent.getChildIndex(_mc);
               _mc.parent.setChildIndex(_mc,_mc.parent.numChildren - 1);
            }
            this._field.onFocus();
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
            this._field.onBlur();
            if(param1 == null)
            {
               dispatchEvent(new Event(EVENT_BLUR));
            }
         }
      }
      
      override public function onBlur(param1:Event = null) : void
      {
         if(this._dropdown.visible)
         {
            this.toggle(param1);
         }
      }
   }
}

