package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class HTMLField extends Component implements IComponent
   {
      private var _text:String;
      
      private var _tf:TextField;
      
      protected var _alt:String = "";
      
      public var autoSize:String = "left";
      
      private var _multiLine:Boolean = true;
      
      private var _textOverflowing:Boolean = false;
      
      private var _otf:TextField;
      
      private var _otfButton:Sprite;
      
      public var linkEvent:String = "";
      
      public function HTMLField(param1:Sprite, param2:String, param3:Number = NaN, param4:Boolean = false, param5:Position = null, param6:Style = null)
      {
         super();
         this.init_HTMLField(param1,param2,param3,param4,param5,param6);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get textOverflowing() : Boolean
      {
         return this._textOverflowing;
      }
      
      override public function get value() : String
      {
         return this._text;
      }
      
      override public function set value(param1:String) : void
      {
         this.reset(param1);
      }
      
      public function set width(param1:uint) : void
      {
         _width = this._tf.width = param1;
      }
      
      public function set height(param1:uint) : void
      {
         this._tf.autoSize = TextFieldAutoSize.NONE;
         _height = this._tf.height = param1;
      }
      
      public function set outerWidth(param1:uint) : void
      {
         _width = param1;
         if(this._tf)
         {
            this._tf.x = (_width - this._tf.width) * 0.5;
         }
      }
      
      public function set outerHeight(param1:uint) : void
      {
         _height = param1;
         if(this._tf)
         {
            this._tf.y = (_height - this._tf.height) * 0.5 - 3;
         }
      }
      
      public function set boundsWidth(param1:uint) : void
      {
         _width = param1;
      }
      
      public function set boundsHeight(param1:uint) : void
      {
         _height = param1;
      }
      
      public function set innerX(param1:int) : void
      {
         if(this._tf)
         {
            this._tf.x = param1;
         }
      }
      
      public function set innerY(param1:int) : void
      {
         if(this._tf)
         {
            this._tf.y = param1;
         }
      }
      
      override public function set rotation(param1:Number) : void
      {
         this._tf.rotation = param1;
      }
      
      public function get alt() : String
      {
         return this._alt;
      }
      
      public function set alt(param1:String) : void
      {
         this._alt = param1;
      }
      
      public function get tf() : TextField
      {
         return this._tf;
      }
      
      private function init_HTMLField(param1:Sprite, param2:String, param3:Number = NaN, param4:Boolean = false, param5:Position = null, param6:Style = null) : void
      {
         super.init(param1,param5,param6);
         _type = "htmlfield";
         this._text = param2;
         _width = param3;
         this._multiLine = param4;
      }
      
      override public function create() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:TextField = null;
         super.create();
         if(this._text == null || this._text == "null" || this._text == "undefined")
         {
            return;
         }
         this._tf = new TextField();
         this._tf.width = 500;
         this._tf.height = 10;
         _mc.addChild(this._tf);
         this._tf.selectable = false;
         this._tf.autoSize = this.autoSize;
         this._tf.multiline = this._multiLine;
         this._tf.wordWrap = this._multiLine;
         this._tf.condenseWhite = true;
         this._tf.embedFonts = _style.embedFonts;
         if(_style.embedFonts)
         {
            if(this._text.indexOf("<h") == -1)
            {
               this._tf.setTextFormat(new TextFormat(_style.font,_style.fontSize,_style.textColor,false));
               this._tf.defaultTextFormat = new TextFormat(_style.font,_style.fontSize,_style.textColor,false);
               _style.htmlFont = _style.font;
            }
            else
            {
               this._tf.setTextFormat(new TextFormat(_style.titleFont,_style.titleFontSize,_style.titleColor,true));
               this._tf.defaultTextFormat = new TextFormat(_style.titleFont,_style.titleFontSize,_style.titleColor,true);
               _style.htmlFont = _style.titleFont;
            }
            this._tf.styleSheet = _style.styleSheet;
            this._tf.htmlText = this._text;
            this._tf.antiAliasType = AntiAliasType.ADVANCED;
         }
         else
         {
            this._tf.styleSheet = _style.styleSheet;
            this._tf.htmlText = this._text;
         }
         if(!isNaN(_width) && _width > 0)
         {
            if(!this._multiLine)
            {
               _height = this._tf.height;
            }
            _loc1_ = this._tf.width;
            if(!this._multiLine)
            {
               this._tf.autoSize = TextFieldAutoSize.NONE;
            }
            this._tf.width = _width;
            if(!this._multiLine)
            {
               this._tf.height = _height;
            }
            if(!this._multiLine && _loc1_ > _width)
            {
               this._textOverflowing = true;
            }
         }
         else if(isNaN(_width) && _parentCell != null)
         {
            this._tf.width = _parentCell.width - _position.margin_right - _position.margin_left;
         }
         _width = this._tf.width;
         _height = this._tf.height;
         if(this.textOverflowing)
         {
            this._otf = new TextField();
            _mc.addChild(this._otf);
            this._otf.x = this._tf.x + this._tf.width - 15;
            this._otf.y = this._tf.y;
            this._otf.width = 15;
            this._otf.height = this._tf.height;
            this._otf.background = true;
            this._otf.backgroundColor = _style.backgroundColor;
            if(this._text.indexOf("<h") == -1)
            {
               this._otf.setTextFormat(new TextFormat(_style.font,_style.fontSize,_style.textColor,true,false,false,"","","right"));
               this._otf.defaultTextFormat = new TextFormat(_style.font,_style.fontSize,_style.textColor,false);
            }
            else
            {
               this._otf.setTextFormat(new TextFormat(_style.titleFont,_style.titleFontSize,_style.titleColor,true,false,false,"","","right"));
               this._otf.defaultTextFormat = new TextFormat(_style.titleFont,_style.titleFontSize,_style.titleColor,true);
            }
            this._otf.styleSheet = _style.styleSheet;
            if(_style.embedFonts)
            {
               this._otf.embedFonts = true;
               this._otf.antiAliasType = AntiAliasType.ADVANCED;
            }
            this._otf.selectable = false;
            this._otf.htmlText = "<p><a class=\"litelink\">...</a></p>";
            if(this._tf.htmlText.indexOf("</p") != -1 || this._tf.htmlText.indexOf("</h") != -1)
            {
               this._tf.htmlText = this._tf.htmlText.split("</p").join("     .</p").split("</h").join("    .</h");
            }
            else
            {
               this._tf.htmlText += "       .";
            }
            this._otfButton = new Sprite();
            DrawingMethods.rect(this._otfButton,false,this._tf.x,this._tf.y,this._tf.width,this._tf.height,0,0);
            this._otfButton.useHandCursor = false;
            _mc.addChild(this._otfButton);
            _loc2_ = this._tf;
            this._otfButton.addEventListener(MouseEvent.ROLL_OVER,this.onFieldRollover,false,0,true);
            this._otfButton.addEventListener(MouseEvent.ROLL_OUT,this.onFieldRollout,false,0,true);
            if(this._text.indexOf("href=\'") != -1)
            {
               this._otfButton.addEventListener(MouseEvent.CLICK,this.onFieldClick);
            }
         }
         this._tf.addEventListener(TextEvent.LINK,this.dispatchLink);
         this._tf.addEventListener(MouseEvent.ROLL_OUT,this.onFieldRollout);
      }
      
      protected function onFieldRollover(param1:MouseEvent) : void
      {
         if(this.textOverflowing)
         {
            mainStage.addEventListener(Event.ENTER_FRAME,this.scrollText);
         }
         if(this._alt.length > 0)
         {
            Tagtip.showTag(this._alt);
         }
      }
      
      protected function onFieldRollout(param1:MouseEvent) : void
      {
         if(this.textOverflowing)
         {
            mainStage.removeEventListener(Event.ENTER_FRAME,this.scrollText);
            this._tf.scrollH = 0;
         }
         Tagtip.hideTag();
      }
      
      protected function scrollText(param1:Event) : void
      {
         this._tf.scrollH += 1;
         if(_mc.mouseX < 0 || _mc.mouseY < 0 || _mc.mouseX > _width || _mc.mouseY > _height)
         {
            mainStage.removeEventListener(Event.ENTER_FRAME,this.scrollText);
            this._tf.scrollH = 0;
         }
      }
      
      protected function onFieldClick(param1:MouseEvent) : void
      {
         var _loc2_:String = this._text.split("href=\'")[1].split("\'")[0];
         navigateToURL(new URLRequest(_loc2_),"_blank");
      }
      
      protected function dispatchLink(param1:TextEvent) : void
      {
         this.linkEvent = param1.text;
         if(this.linkEvent == "showtag" && this._alt.length > 0)
         {
            Tagtip.showTag(this._alt,true);
            return;
         }
         dispatchEvent(new Event(EVENT_CLICK));
         this.linkEvent = "";
      }
      
      protected function reset(param1:String) : void
      {
         if(param1.indexOf("<") == -1)
         {
            if(this._text.indexOf("align=\"center\"") != -1)
            {
               param1 = "<p align=\"center\">" + param1 + "</p>";
            }
            else
            {
               param1 = "<p>" + param1 + "</p>";
            }
         }
         this._text = this._tf.htmlText = param1;
         _height = this._tf.height;
      }
      
      protected function stripTags(param1:String) : String
      {
         var _loc2_:Number = NaN;
         while(_loc2_ = Number(param1.indexOf("<")), _loc2_ != -1)
         {
            param1 = param1.split(param1.substr(_loc2_,param1.indexOf(">") - _loc2_ + 1)).join("");
         }
         return param1;
      }
   }
}

