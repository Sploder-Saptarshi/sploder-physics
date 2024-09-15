package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.TextField;
   
   public class CheckBox extends Component
   {
      private var _textLabel:String;
      
      private var _tf:TextField;
      
      private var _box:Sprite;
      
      private var _checkSymbol:Sprite;
      
      private var _button:Sprite;
      
      private var _fieldbutton:Sprite;
      
      private var _highlight:Sprite;
      
      private var _checkedAtStart:Boolean = false;
      
      private var _checked:Boolean = false;
      
      private var _alt:String = "";
      
      public var showAltImmediate:Boolean = false;
      
      public var validate:Function;
      
      public function CheckBox(param1:Sprite = null, param2:String = "", param3:String = "", param4:Boolean = false, param5:Number = NaN, param6:Number = NaN, param7:String = "", param8:Position = null, param9:Style = null)
      {
         super();
         this.init_CheckBox(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         if(_container != null)
         {
            this.create();
         }
      }
      
      override public function get value() : String
      {
         return this._checked ? _value : "";
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
         this._checked = this._checkSymbol.visible = param1;
         if(this._tf)
         {
            if(this._checked)
            {
               this._tf.textColor = _style.highlightTextColor;
            }
            else
            {
               this._tf.textColor = _style.textColor;
            }
         }
         if(form != null && name.length > 0)
         {
            form[name] = param1;
         }
      }
      
      private function init_CheckBox(param1:Sprite = null, param2:String = "", param3:String = "", param4:Boolean = false, param5:Number = NaN, param6:Number = NaN, param7:String = "", param8:Position = null, param9:Style = null) : void
      {
         super.init(param1,param8,param9);
         _type = "checkbox";
         this._textLabel = param2;
         _value = param3.length > 0 ? param3 : param2.toLowerCase();
         this._checkedAtStart = this._checked = param4;
         _width = param5;
         _height = param6;
         this._alt = param7;
         _style = _style.clone({"borderWidth":2});
      }
      
      override public function create() : void
      {
         super.create();
         if(isNaN(_width))
         {
            _width = _parentCell.width - _position.margin_left - _position.margin_right;
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
         this._box = new Sprite();
         _mc.addChild(this._box);
         DrawingMethods.emptyRect(this._box,false,0,0,16,16,2,ColorTools.getTintedColor(_style.borderColor,_style.backgroundColor,0.7));
         DrawingMethods.rect(this._box,false,2,2,12,12,_style.backgroundColor);
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
         this._checkSymbol = new Sprite();
         _mc.addChild(this._checkSymbol);
         DrawingMethods.emptyRect(this._checkSymbol,false,0,0,16,16,2,_style.borderColor);
         Create.newIcon(Create.ICON_CHECK,this._checkSymbol,_style.titleColor,100,_style,1.5);
         this._checkSymbol.visible = this.checked;
         _width = _mc.width;
         this._highlight = new Sprite();
         _mc.addChild(this._highlight);
         DrawingMethods.emptyRect(this._highlight,false,0,0,16,16,2,_style.borderColor);
         DrawingMethods.emptyRect(this._highlight,false,-2,-2,20,20,2,ColorTools.getSaturatedColor(_style.haloColor,255),60);
         this._highlight.visible = false;
         this._button = new Sprite();
         _mc.addChild(this._button);
         DrawingMethods.rect(this._button,false,0,0,16,16,16777215,0.2);
         this._box.y = this._checkSymbol.y = this._button.y = this._highlight.y = Math.max(0,Math.floor((this._tf.height - 16) * 0.5));
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
         dispatchEvent(new Event(Component.EVENT_HOVER_START));
      }
      
      private function rollout(param1:Event) : void
      {
         Tagtip.hideTag();
         dispatchEvent(new Event(Component.EVENT_HOVER_END));
      }
      
      override public function toggle(param1:Event = null) : void
      {
         this._checked = this._checkSymbol.visible = !this._checked;
         if(this._checked)
         {
            this._tf.textColor = _style.highlightTextColor;
         }
         else
         {
            this._tf.textColor = _style.textColor;
         }
         dispatchEvent(new Event(EVENT_CHANGE));
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
         this._tf.textColor = _style.textColor;
         this._button.mouseEnabled = true;
         this._button.tabEnabled = true;
         this._box.alpha = 1;
         _mc.alpha = 1;
      }
      
      override public function disable(param1:Event = null) : void
      {
         super.disable();
         this._tf.textColor = ColorTools.getTintedColor(_style.textColor,_style.backgroundColor,0.8);
         this._highlight.visible = false;
         this._button.mouseEnabled = false;
         this._button.tabEnabled = false;
         this._box.alpha = 0;
         _mc.alpha = 0.5;
      }
      
      public function lock() : void
      {
         this.disable();
         this._tf.textColor = ColorTools.getTintedColor(_style.textColor,_style.backgroundColor,0.4);
      }
   }
}

