package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.TextField;
   
   public class RadioButton extends Component
   {
      public static var groups:Object;
      
      private var _textLabel:String;
      
      private var _groupName:String;
      
      private var _grouped:Boolean = false;
      
      private var _group:Object;
      
      private var _tf:TextField;
      
      private var _back:Sprite;
      
      private var _checkSymbol:Sprite;
      
      private var _button:Sprite;
      
      private var _fieldbutton:Sprite;
      
      private var _highlight:Sprite;
      
      private var _checkedAtStart:Boolean = false;
      
      private var _checked:Boolean = false;
      
      private var _alt:String = "";
      
      public var showAltImmediate:Boolean = false;
      
      public var radioSymbolName:String = "";
      
      public var validate:Function;
      
      public function RadioButton(param1:Sprite = null, param2:String = "", param3:String = "", param4:String = "", param5:Boolean = false, param6:Number = NaN, param7:Number = NaN, param8:String = "", param9:Position = null, param10:Style = null)
      {
         super();
         this.init_RadioButton(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
         if(_container != null)
         {
            this.create();
         }
      }
      
      override public function get value() : String
      {
         if(this._grouped)
         {
            return this._group.value;
         }
         if(this._checked)
         {
            return _value;
         }
         return "";
      }
      
      public function get text() : String
      {
         return this._tf.text;
      }
      
      public function set text(param1:String) : void
      {
         this._tf.text = param1;
      }
      
      public function get alt() : String
      {
         return this._alt;
      }
      
      public function set alt(param1:String) : void
      {
         this._alt = param1;
      }
      
      public function get changed() : Boolean
      {
         return this._checkedAtStart != this._checked;
      }
      
      public function get checked() : Boolean
      {
         return this._checked;
      }
      
      public function set checked(param1:Boolean) : void
      {
         if(param1 != this._checked)
         {
            this.toggle();
         }
      }
      
      private function init_RadioButton(param1:Sprite = null, param2:String = "", param3:String = "", param4:String = "", param5:Boolean = false, param6:Number = NaN, param7:Number = NaN, param8:String = "", param9:Position = null, param10:Style = null) : void
      {
         super.init(param1,param9,param10);
         _type = "radiobutton";
         this._textLabel = param2;
         _value = param3.length > 0 ? param3 : param2.toLowerCase();
         this._groupName = param4.length > 0 ? param4 : "";
         this._checkedAtStart = this._checked = param5;
         _width = param6;
         _height = param7;
         this._alt = param8;
         if(this._groupName.length > 0)
         {
            this._grouped = true;
            if(RadioButton.groups == null)
            {
               RadioButton.groups = {};
            }
            if(RadioButton.groups[this._groupName] == null)
            {
               RadioButton.groups[this._groupName] = {};
               RadioButton.groups[this._groupName].buttons = {};
               this._checked = true;
            }
            this._group = RadioButton.groups[this._groupName];
            this._group.buttons[param3] = this;
            if(this._checked)
            {
               if(this._group.activeRadioButton != null)
               {
                  this._group.activeRadioButton.checked = false;
               }
               this._group.activeRadioButton = this;
               this._group.value = this.value;
            }
         }
      }
      
      override public function create() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Number = NaN;
         super.create();
         if(isNaN(_width))
         {
            if(_parentCell != null)
            {
               _width = _parentCell.width - _position.margin_left - _position.margin_right;
            }
            else
            {
               _width = 500;
            }
         }
         this._tf = Create.newText(this._textLabel,"labelTF",_mc,_style,NaN,NaN,true);
         this._tf.x = 6;
         this._tf.y = 0;
         this._tf.tabIndex = id;
         this._tf.selectable = false;
         this._tf.tabEnabled = false;
         this._tf.multiline = true;
         this._tf.wordWrap = true;
         this._tf.x = 20;
         this._back = new Sprite();
         _mc.addChild(this._back);
         if(!isNaN(_width))
         {
            this._tf.width = _width - 16 - 4;
         }
         if(isNaN(_height))
         {
            _height = this._tf.height;
         }
         else
         {
            this._tf.height = _height - 4;
         }
         if(this.radioSymbolName == "")
         {
            DrawingMethods.circle(this._back,false,8,8,6,16,_style.backgroundColor,100,2,ColorTools.getTintedColor(_style.borderColor,_style.backgroundColor,0.7),100);
            this._checkSymbol = new Sprite();
            _mc.addChild(this._checkSymbol);
            DrawingMethods.circle(this._checkSymbol,false,8,8,6,16,_style.backgroundColor,0,2,_style.borderColor,100);
            DrawingMethods.circle(this._checkSymbol,false,8,8,3,16,_style.buttonColor,100);
            this._checkSymbol.visible = this.checked;
            _width = _mc.width;
            this._highlight = new Sprite();
            _mc.addChild(this._highlight);
            DrawingMethods.circle(this._highlight,false,8,8,10,2,ColorTools.getSaturatedColor(_style.haloColor,255),0.6);
            this._highlight.visible = false;
            this._button = new Sprite();
            _mc.addChild(this._button);
            DrawingMethods.circle(this._button,false,8,8,7,2,_style.textColor,0.2);
            this._back.y = this._checkSymbol.y = this._button.y = this._highlight.y = Math.max(0,Math.floor((this._tf.height - 16) * 0.5));
         }
         else
         {
            _loc1_ = Component.library.getDisplayObject(this.radioSymbolName) as Sprite;
            this._back.addChild(_loc1_);
            _loc2_ = this._back.width / this._back.height;
            this._tf.x = _loc1_.width + 5;
            this._tf.width = _width - _loc1_.width - 5;
            this._tf.y = (_loc1_.height - this._tf.height) / 2;
            this._checkSymbol = new Sprite();
            _mc.addChild(this._checkSymbol);
            DrawingMethods.emptyRect(this._checkSymbol,true,-2,-2,_loc1_.width + 4,_loc1_.height + 4,2,_style.haloColor,1);
            this._checkSymbol.visible = this.checked;
            _width = _mc.width;
            this._highlight = new Sprite();
            _mc.addChild(this._highlight);
            DrawingMethods.emptyRect(this._highlight,false,-2,-2,_loc1_.width + 4,_loc1_.height + 4,4,ColorTools.getSaturatedColor(_style.haloColor,255),0.6);
            this._highlight.visible = false;
            this._button = new Sprite();
            _mc.addChild(this._button);
            DrawingMethods.rect(this._button,false,0,0,_loc1_.width,_loc1_.height,_style.textColor,0.2);
         }
         connectButton(this._button);
         addEventListener(EVENT_CLICK,this.toggle);
         _mc.tabChildren = this._button.tabEnabled = true;
         this._button.tabIndex = _id;
         this._button.addEventListener(FocusEvent.FOCUS_IN,this.onFocus);
         this._button.addEventListener(FocusEvent.FOCUS_OUT,this.onBlur);
         this._fieldbutton = new Sprite();
         _mc.addChild(this._fieldbutton);
         DrawingMethods.rect(this._fieldbutton,false,this._tf.x - 4,this._tf.y,this._tf.width + 4,this._tf.height,16777215,0);
         connectButton(this._fieldbutton);
         this._fieldbutton.tabEnabled = false;
         if(this._checked)
         {
            this._tf.textColor = _style.highlightTextColor;
         }
         else
         {
            this._tf.textColor = _style.textColor;
         }
         if(this._alt.length > 0)
         {
            addEventListener(EVENT_M_OVER,this.rollover);
            addEventListener(EVENT_M_OUT,this.rollout);
         }
      }
      
      private function rollover(param1:Event) : void
      {
         if(this._alt.length > 0)
         {
            Tagtip.showTag(this._alt,this.showAltImmediate);
         }
      }
      
      private function rollout(param1:Event) : void
      {
         Tagtip.hideTag();
      }
      
      override public function toggle(param1:Event = null) : void
      {
         if(param1 != null && this._checked && this._grouped && this._group.activeRadioButton == this)
         {
            return;
         }
         if(!this._checked && this._grouped)
         {
            if(this._group.activeRadioButton != null)
            {
               RadioButton(this._group.activeRadioButton).checked = false;
            }
            this._group.activeRadioButton = this;
            this._group.value = _value;
         }
         this._checked = !this._checked;
         if(this._checkSymbol)
         {
            this._checkSymbol.visible = this._checked;
         }
         if(this._checked)
         {
            this._tf.textColor = _style.highlightTextColor;
         }
         else
         {
            this._tf.textColor = _style.textColor;
         }
         if(this._checked || !this._grouped)
         {
            dispatchEvent(new Event(EVENT_CHANGE));
         }
      }
      
      public function onFocus(param1:Event) : void
      {
         if(_enabled)
         {
            this._highlight.visible = true;
         }
      }
      
      public function onBlur(param1:Event) : void
      {
         this._highlight.visible = false;
      }
      
      override public function enable(param1:Event = null) : void
      {
         super.enable();
         this._tf.alpha = 1;
         this._button.tabEnabled = true;
         this._button.mouseEnabled = this._fieldbutton.mouseEnabled = true;
      }
      
      override public function disable(param1:Event = null) : void
      {
         super.disable();
         this._tf.alpha = 0.25;
         this._highlight.visible = false;
         this._button.tabEnabled = false;
         this._button.mouseEnabled = this._fieldbutton.mouseEnabled = false;
      }
      
      public function lock() : void
      {
         this.disable();
         this._tf.textColor = ColorTools.getTintedColor(_style.textColor,_style.backgroundColor,0.4);
      }
   }
}

