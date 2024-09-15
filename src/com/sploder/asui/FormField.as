package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class FormField extends Component
   {
      private var _textLabel:String;
      
      private var _selectable:Boolean = true;
      
      private var _tf:TextField;
      
      private var _highlight:Sprite;
      
      private var _useHTMLtext:Boolean = false;
      
      private var _clear:Boolean = true;
      
      private var _tftype:String = "dynamic";
      
      protected var _restrict:String = "";
      
      protected var _maxChars:int = 0;
      
      public var validate:Function;
      
      public function FormField(param1:Sprite = null, param2:String = "", param3:Number = NaN, param4:Number = NaN, param5:Boolean = true, param6:Position = null, param7:Style = null)
      {
         super();
         this.init_FormField(param1,param2,param3,param4,param5,param6,param7);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this._selectable = param1;
         if(this._tf)
         {
            this._tf.selectable = this._tf.mouseEnabled = param1;
            this._tf.defaultTextFormat = new TextFormat("Verdana",_style.fontSize,_style.textColor,false,false,false,"","","left");
            if(this._tf.selectable)
            {
               this._tf.addEventListener(MouseEvent.CLICK,onClick);
            }
            else
            {
               this._tf.removeEventListener(MouseEvent.CLICK,onClick);
            }
         }
      }
      
      public function get useHTMLtext() : Boolean
      {
         return this._useHTMLtext;
      }
      
      public function set useHTMLtext(param1:Boolean) : void
      {
         this._useHTMLtext = param1;
      }
      
      public function get text() : String
      {
         return this._tf.text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._useHTMLtext)
         {
            this._tf.htmlText = param1;
         }
         else
         {
            this._tf.text = param1;
         }
         if(!_style.embedFonts)
         {
            this._tf.defaultTextFormat = new TextFormat("_sans",_style.fontSize,_style.textColor,false,false,false,"","","left");
         }
      }
      
      public function get clear() : Boolean
      {
         return this._clear;
      }
      
      public function set clear(param1:Boolean) : void
      {
         this._clear = param1;
      }
      
      public function get changed() : Boolean
      {
         return this._tf.text != this._textLabel;
      }
      
      override public function get value() : String
      {
         return this._textLabel.indexOf("...") != -1 && this._tf.text == this._textLabel ? "" : this._tf.text;
      }
      
      override public function set value(param1:String) : void
      {
         if(this._useHTMLtext)
         {
            this._tf.htmlText = param1.length > 0 ? param1 : "";
         }
         else
         {
            this._tf.text = param1.length > 0 ? param1 : "";
         }
         if(form != null && name.length > 0)
         {
            form[name] = param1;
         }
      }
      
      public function set editable(param1:Boolean) : void
      {
         if(this._tf)
         {
            if(param1)
            {
               this._tftype = this._tf.type = "input";
            }
            else
            {
               this._tftype = this._tf.type = "dynamic";
            }
         }
         else if(param1)
         {
            this._tftype = "input";
         }
         else
         {
            this._tftype = "dynamic";
         }
         if(param1)
         {
            addEventListener(EVENT_FOCUS,this.onFocus);
            addEventListener(EVENT_BLUR,this.onBlur);
         }
         else
         {
            removeEventListener(EVENT_FOCUS,this.onFocus);
            removeEventListener(EVENT_BLUR,this.onBlur);
         }
      }
      
      public function set restrict(param1:String) : void
      {
         if(this._tf)
         {
            this._restrict = this._tf.restrict = param1 + ".";
         }
         else
         {
            this._restrict = param1 + ".";
         }
      }
      
      public function set password(param1:Boolean) : void
      {
         this._tf.displayAsPassword = param1;
      }
      
      public function set maxChars(param1:int) : void
      {
         if(this._tf)
         {
            this._maxChars = this._tf.maxChars = param1;
         }
         else
         {
            this._maxChars = param1;
         }
      }
      
      private function init_FormField(param1:Sprite = null, param2:String = "", param3:Number = NaN, param4:Number = NaN, param5:Boolean = true, param6:Position = null, param7:Style = null) : void
      {
         super.init(param1,param6,param7);
         _type = "formfield";
         this._textLabel = param2;
         _width = param3;
         _height = param4;
         this._selectable = param5;
      }
      
      override public function create() : void
      {
         super.create();
         if(isNaN(_width))
         {
            _width = _parentCell.width - _position.margin_left - _position.margin_right;
         }
         this._tf = Create.inputText(this._textLabel,"formTF",_mc,_width - 6,NaN,_style);
         this._tf.x = 6;
         this._tf.tabIndex = id;
         this._tf.restrict = this._restrict;
         this._tf.maxChars = this._maxChars;
         this._tf.width = _width - 6;
         if(isNaN(_height))
         {
            this._tf.y = Math.floor(Math.max(2,_style.padding / 2));
            _height = this._tf.height - _style.borderWidth;
         }
         else
         {
            this._tf.text = "MMM";
            this._tf.autoSize = TextFieldAutoSize.LEFT;
            this._tf.y = Math.floor((_height - this._tf.height) * 0.5);
            if(_height > 30)
            {
               this._tf.multiline = true;
               this._tf.wordWrap = true;
               this._tf.autoSize = TextFieldAutoSize.NONE;
               this._tf.text = "";
               this._tf.width = _width - 6;
               this._tf.height = _height - 6;
               this._tf.y = 3;
            }
            else
            {
               this._tf.text = "";
               this._tf.autoSize = TextFieldAutoSize.NONE;
               this._tf.width = _width - 6;
            }
         }
         DrawingMethods.emptyRect(_mc,false,0,0,_width,_height,2,ColorTools.getTintedColor(_style.borderColor,_style.backgroundColor,0.7));
         DrawingMethods.roundedRect(_mc,false,2,2,_width - 4,_height - 4,"0",[_style.inputColorA,_style.inputColorB]);
         connectTextField(this._tf);
         if(this._selectable || this._tftype == "input")
         {
            this._tf.type = TextFieldType.INPUT;
            addEventListener(EVENT_FOCUS,this.onFocus);
            addEventListener(EVENT_BLUR,this.onBlur);
         }
         else
         {
            this._tf.type = TextFieldType.DYNAMIC;
            this._tf.selectable = false;
         }
         this._highlight = new Sprite();
         _mc.addChild(this._highlight);
         DrawingMethods.emptyRect(this._highlight,false,0,0,_width,_height,2,_style.borderColor);
         DrawingMethods.emptyRect(this._highlight,false,-2,-2,_width + 4,_height + 4,2,ColorTools.getSaturatedColor(_style.haloColor,255),0.6);
         this._highlight.visible = false;
         _width = _mc.width;
         _height = _mc.height;
         if(this._useHTMLtext)
         {
            this._tf.htmlText = this._textLabel;
         }
         else
         {
            this._tf.text = this._textLabel;
         }
         if(this._tf.selectable)
         {
            this._tf.addEventListener(MouseEvent.CLICK,onClick);
         }
      }
      
      public function focus() : void
      {
         mainStage.focus = this._tf;
         this.onFocus();
         if(this._tf.text.length > 0)
         {
            this._tf.setSelection(0,this._tf.text.length);
         }
      }
      
      public function onFocus(param1:Event = null) : void
      {
         if(_enabled)
         {
            this._highlight.visible = true;
            if(this._tf.text == this._textLabel && this._tf.text.indexOf("...") != -1 && this._clear)
            {
               this._tf.text = this._tf.htmlText = "";
            }
            else if(this._selectable)
            {
               this._highlight.addEventListener(MouseEvent.MOUSE_UP,this.onSelect);
            }
         }
      }
      
      protected function onSelect(param1:MouseEvent) : void
      {
         if(this._tf.selectionBeginIndex == this._tf.selectionEndIndex)
         {
            this.focus();
         }
         dispatchEvent(new Event(EVENT_SELECT));
      }
      
      public function onBlur(param1:Event = null) : void
      {
         this._highlight.visible = false;
         this._highlight.removeEventListener(MouseEvent.MOUSE_UP,this.onSelect);
         if(this._tf.text == "" && this._clear)
         {
            this._tf.text = this._textLabel;
            if(!_style.embedFonts)
            {
               this._tf.defaultTextFormat = new TextFormat("_sans",_style.fontSize,_style.textColor,false,false,false,"","","left");
            }
            dispatchEvent(new Event(EVENT_CHANGE));
         }
      }
      
      override public function enable(param1:Event = null) : void
      {
         super.enable();
         this._tf.textColor = _style.textColor;
         this._tf.selectable = true;
         this._tf.type = TextFieldType.INPUT;
         this._tf.tabEnabled = true;
      }
      
      override public function disable(param1:Event = null) : void
      {
         super.disable();
         this._tf.textColor = ColorTools.getTintedColor(_style.textColor,_style.backgroundColor,0.8);
         this._tf.selectable = false;
         this._tf.type = TextFieldType.DYNAMIC;
         this._tf.tabEnabled = false;
         this._highlight.visible = false;
      }
      
      public function lock() : void
      {
         this.disable();
         this._tf.textColor = ColorTools.getTintedColor(_style.textColor,_style.backgroundColor,0.4);
      }
   }
}

