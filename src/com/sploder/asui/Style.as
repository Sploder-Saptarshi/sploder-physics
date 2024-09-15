package com.sploder.asui
{
   import flash.system.Capabilities;
   import flash.text.StyleSheet;
   
   public class Style
   {
      public static const DEFAULT_HTML_FONT:String = "Verdana, Helvetica, Arial";
      
      private var _styleSheet:StyleSheet;
      
      private var css:String;
      
      private var cloneParams:Array;
      
      private var _textColor:Number = 13421772;
      
      private var _titleColor:Number = 16772096;
      
      private var _linkColor:Number = 16772096;
      
      private var _hoverColor:Number = 16777011;
      
      private var _inverseTextColor:Number = 16777215;
      
      private var _buttonTextColor:Number = 16777215;
      
      private var _backgroundColor:Number = 0;
      
      private var _inputColorA:Number = 0;
      
      private var _inputColorB:Number = 3355443;
      
      private var _borderColor:Number = 10066329;
      
      private var _backgroundAlpha:Number = 1;
      
      private var _buttonColor:Number = 6684774;
      
      private var _buttonBorderColor:Number = -1;
      
      private var _selectedButtonColor:Number = -1;
      
      private var _selectedButtonBorderColor:Number = -1;
      
      private var _borderAlpha:Number = 1;
      
      private var _maskColor:Number = 0;
      
      private var _maskAlpha:Number = 0.5;
      
      private var _unselectedColor:Number = 3342387;
      
      private var _unselectedTextColor:Number = 6710886;
      
      private var _unselectedBorderColor:Number = -1;
      
      private var _inactiveColor:Number = 3342387;
      
      private var _inactiveTextColor:Number = 6710886;
      
      private var _haloColor:Number = 16750848;
      
      private var _highlightTextColor:Number = 16763904;
      
      private var _gradient:Boolean = true;
      
      private var _background:Boolean = true;
      
      private var _border:Boolean = true;
      
      private var _bgGradient:Boolean = false;
      
      private var _bgGradientColors:Array;
      
      private var _bgGradientRatios:Array;
      
      private var _bgGradientHeight:int = 0;
      
      private var _padding:Number = 6;
      
      private var _round:Number = 8;
      
      private var _borderWidth:Number = 4;
      
      private var _buttonDropShadow:Boolean = false;
      
      private var _fontSize:Number = 12;
      
      private var _titleFontSize:Number = 15;
      
      private var _buttonFontSize:Number = 12;
      
      private var _embedFonts:Boolean = false;
      
      private var _font:String = "Verdana";
      
      private var _fonts:Array;
      
      private var _buttonFont:String = "";
      
      private var _titleFont:String = "";
      
      private var _htmlFont:String = "Verdana, Helvetica, Arial";
      
      private var _options:Object;
      
      public function Style(param1:Object = null)
      {
         this.cloneParams = ["_textColor","_titleColor","_linkColor","_hoverColor","_inverseTextColor","_buttonTextColor","_backgroundColor","_inputColorA","_inputColorB","_borderColor","_backgroundAlpha","_buttonColor","_buttonBorderColor","_selectedButtonColor","_selectedButtonBorderColor","_borderAlpha","_maskColor","_maskAlpha","_unselectedColor","_unselectedTextColor","_unselectedBorderColor","_inactiveColor","_inactiveTextColor","_haloColor","_highlightTextColor","_gradient","_background","_border","_bgGradient","_bgGradientColors"," _bgGradientRatios","_bgGradientHeight","_padding","_round","_borderWidth","_buttonDropShadow","_fontSize","_titleFontSize","_buttonFontSize","_embedFonts","_font","_fonts","_buttonFont","_titleFont","_htmlFont"];
         this._bgGradientColors = [16777215,15658734];
         this._bgGradientRatios = [0,255];
         this._fonts = ["Verdana","Tahoma","Arial"];
         super();
         this.init(param1);
      }
      
      public function get textColor() : Number
      {
         return this._textColor;
      }
      
      public function set textColor(param1:Number) : void
      {
         this._textColor = param1;
         this._inverseTextColor = ColorTools.getInverseColor(this._textColor);
         this.updateColors();
         this.updateCSS();
      }
      
      public function get titleColor() : Number
      {
         return this._titleColor;
      }
      
      public function set titleColor(param1:Number) : void
      {
         this._titleColor = param1;
         this.updateColors();
         this.updateCSS();
      }
      
      public function get linkColor() : Number
      {
         return this._linkColor;
      }
      
      public function set linkColor(param1:Number) : void
      {
         this._linkColor = param1;
         this.updateColors();
         this.updateCSS();
      }
      
      public function get hoverColor() : Number
      {
         return this._hoverColor;
      }
      
      public function set hoverColor(param1:Number) : void
      {
         this._hoverColor = param1;
         this.updateCSS();
      }
      
      public function get backgroundColor() : Number
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(param1:Number) : void
      {
         this._backgroundColor = param1;
         this.updateColors();
         this.updateCSS();
      }
      
      public function get inputColorA() : Number
      {
         return this._inputColorA;
      }
      
      public function set inputColorA(param1:Number) : void
      {
         this._inputColorA = param1;
      }
      
      public function get inputColorB() : Number
      {
         return this._inputColorB;
      }
      
      public function set inputColorB(param1:Number) : void
      {
         this._inputColorB = param1;
      }
      
      public function get borderColor() : Number
      {
         return !isNaN(this._borderColor) ? this._borderColor : this._textColor;
      }
      
      public function set borderColor(param1:Number) : void
      {
         this._borderColor = param1;
         this.updateColors();
      }
      
      public function get buttonColor() : Number
      {
         return this._buttonColor;
      }
      
      public function set buttonColor(param1:Number) : void
      {
         this._buttonColor = param1;
         this.updateColors();
      }
      
      public function get buttonBorderColor() : Number
      {
         return this._buttonBorderColor != -1 ? this._buttonBorderColor : ColorTools.getTintedColor(this._buttonColor,0,0.2);
      }
      
      public function set buttonBorderColor(param1:Number) : void
      {
         this._buttonBorderColor = param1;
      }
      
      public function get selectedButtonColor() : Number
      {
         return this._selectedButtonColor != -1 ? this._selectedButtonColor : this._inverseTextColor;
      }
      
      public function set selectedButtonColor(param1:Number) : void
      {
         this._selectedButtonColor = param1;
      }
      
      public function get selectedButtonBorderColor() : Number
      {
         return this._selectedButtonBorderColor != -1 ? this._selectedButtonBorderColor : this._inverseTextColor;
      }
      
      public function set selectedButtonBorderColor(param1:Number) : void
      {
         this._selectedButtonBorderColor = param1;
      }
      
      public function get borderAlpha() : Number
      {
         return this._borderAlpha;
      }
      
      public function set borderAlpha(param1:Number) : void
      {
         this._borderAlpha = param1;
      }
      
      public function get maskColor() : Number
      {
         return this._maskColor;
      }
      
      public function set maskColor(param1:Number) : void
      {
         this._maskColor = param1;
      }
      
      public function get maskAlpha() : Number
      {
         return this._maskAlpha;
      }
      
      public function set maskAlpha(param1:Number) : void
      {
         this._maskAlpha = param1;
      }
      
      public function get inverseTextColor() : Number
      {
         return this._inverseTextColor;
      }
      
      public function set inverseTextColor(param1:Number) : void
      {
         this._inverseTextColor = param1;
      }
      
      public function get gradient() : Boolean
      {
         return this._gradient;
      }
      
      public function set gradient(param1:Boolean) : void
      {
         this._gradient = param1;
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set background(param1:Boolean) : void
      {
         this._background = param1;
      }
      
      public function get backgroundAlpha() : Number
      {
         return this._backgroundAlpha;
      }
      
      public function set backgroundAlpha(param1:Number) : void
      {
         this._backgroundAlpha = param1;
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set border(param1:Boolean) : void
      {
         this._border = param1;
         if(!this._border)
         {
            this._borderWidth = 0;
         }
      }
      
      public function get padding() : Number
      {
         return this._padding;
      }
      
      public function set padding(param1:Number) : void
      {
         this._padding = param1;
      }
      
      public function get round() : Number
      {
         return this._round;
      }
      
      public function set round(param1:Number) : void
      {
         this._round = param1;
      }
      
      public function get borderWidth() : Number
      {
         return this._borderWidth;
      }
      
      public function set borderWidth(param1:Number) : void
      {
         this._borderWidth = param1;
      }
      
      public function get buttonDropShadow() : Boolean
      {
         return this._buttonDropShadow;
      }
      
      public function set buttonDropShadow(param1:Boolean) : void
      {
         this._buttonDropShadow = param1;
      }
      
      public function get fontSize() : Number
      {
         return this._fontSize;
      }
      
      public function set fontSize(param1:Number) : void
      {
         this._fontSize = param1;
         this.updateCSS();
      }
      
      public function get titleFontSize() : Number
      {
         return this._titleFontSize;
      }
      
      public function set titleFontSize(param1:Number) : void
      {
         this._titleFontSize = param1;
      }
      
      public function get buttonFontSize() : Number
      {
         return this._buttonFontSize;
      }
      
      public function set buttonFontSize(param1:Number) : void
      {
         this._buttonFontSize = param1;
      }
      
      public function get inactiveColor() : Number
      {
         return this._inactiveColor;
      }
      
      public function set inactiveColor(param1:Number) : void
      {
         this._inactiveColor = param1;
      }
      
      public function get inactiveTextColor() : Number
      {
         return this._inactiveTextColor;
      }
      
      public function set inactiveTextColor(param1:Number) : void
      {
         this._inactiveTextColor = param1;
      }
      
      public function get unselectedColor() : Number
      {
         return this._unselectedColor;
      }
      
      public function set unselectedColor(param1:Number) : void
      {
         this._unselectedColor = param1;
      }
      
      public function get unselectedTextColor() : Number
      {
         return this._unselectedTextColor;
      }
      
      public function set unselectedTextColor(param1:Number) : void
      {
         this._unselectedTextColor = param1;
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         this._styleSheet = param1;
      }
      
      public function get haloColor() : Number
      {
         return this._haloColor;
      }
      
      public function set haloColor(param1:Number) : void
      {
         this._haloColor = param1;
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         this._embedFonts = param1;
      }
      
      public function get font() : String
      {
         return this._font;
      }
      
      public function set font(param1:String) : void
      {
         this._font = param1;
      }
      
      public function get titleFont() : String
      {
         return this._titleFont.length > 0 ? this._titleFont : this._font;
      }
      
      public function set titleFont(param1:String) : void
      {
         this._titleFont = param1;
      }
      
      public function get buttonFont() : String
      {
         return this._buttonFont.length > 0 ? this._buttonFont : this._font;
      }
      
      public function set buttonFont(param1:String) : void
      {
         this._buttonFont = param1;
      }
      
      public function setFont(param1:Number) : void
      {
         if(this._fonts[param1] != null)
         {
            this._font = this._fonts[param1];
         }
      }
      
      public function getFontsAsString() : String
      {
         return this._font + ", " + this._fonts.join(", ");
      }
      
      public function get htmlFont() : String
      {
         return this._htmlFont;
      }
      
      public function set htmlFont(param1:String) : void
      {
         this._htmlFont = param1;
         this.updateCSS();
      }
      
      public function get highlightTextColor() : Number
      {
         return this._highlightTextColor;
      }
      
      public function set highlightTextColor(param1:Number) : void
      {
         this._highlightTextColor = param1;
      }
      
      public function get bgGradient() : Boolean
      {
         return this._bgGradient;
      }
      
      public function set bgGradient(param1:Boolean) : void
      {
         this._bgGradient = param1;
      }
      
      public function get bgGradientColors() : Array
      {
         return this._bgGradientColors;
      }
      
      public function set bgGradientColors(param1:Array) : void
      {
         this._bgGradientColors = param1;
      }
      
      public function get bgGradientRatios() : Array
      {
         return this._bgGradientRatios;
      }
      
      public function set bgGradientRatios(param1:Array) : void
      {
         this._bgGradientRatios = param1;
      }
      
      public function get bgGradientHeight() : int
      {
         return this._bgGradientHeight;
      }
      
      public function set bgGradientHeight(param1:int) : void
      {
         this._bgGradientHeight = param1;
      }
      
      public function get buttonTextColor() : Number
      {
         return this._buttonTextColor != -1 ? this._buttonTextColor : this._inverseTextColor;
      }
      
      public function set buttonTextColor(param1:Number) : void
      {
         this._buttonTextColor = param1;
      }
      
      public function get unselectedBorderColor() : Number
      {
         return this._unselectedBorderColor;
      }
      
      public function set unselectedBorderColor(param1:Number) : void
      {
         this._unselectedBorderColor = param1;
      }
      
      private function init(param1:Object = null) : void
      {
         var _loc2_:String = null;
         this._options = param1 != null ? param1 : {};
         for(_loc2_ in param1)
         {
            if(this[_loc2_] != undefined)
            {
               this[_loc2_] = param1[_loc2_];
            }
            else
            {
               this.debug("WARNING: " + _loc2_ + " does not exist in ui.Style");
            }
         }
         if(this._options.haloColor == undefined)
         {
            this._haloColor = ColorTools.getTintedColor(ColorTools.getInverseColor(this._buttonColor),this._backgroundColor,0.2);
         }
         if(this._options.inactiveTextColor == undefined)
         {
            this._inactiveTextColor = ColorTools.getDesaturatedColor(ColorTools.getTintedColor(this._inactiveColor,this._inverseTextColor,0.6));
         }
         if(this._options.unselectedTextColor == undefined)
         {
            this._unselectedTextColor = ColorTools.getTintedColor(this._inverseTextColor,this._buttonColor,0.3);
         }
         if(this._options.unselectedColor == undefined)
         {
            this._unselectedColor = ColorTools.getTintedColor(this._buttonColor,this._borderColor,0.25);
         }
         if(this._styleSheet == null)
         {
            this._styleSheet = new StyleSheet();
         }
         this.updateCSS();
         if(Capabilities.os.indexOf("Mac") == -1)
         {
            this._fonts = ["Verdana","Arial","Tahoma"];
         }
         else
         {
            this._fonts = ["Verdana","Monaco","Geneva"];
         }
      }
      
      private function updateColors() : void
      {
         if(this._options.haloColor == undefined)
         {
            this._haloColor = ColorTools.getTintedColor(ColorTools.getInverseColor(this._buttonColor),this._backgroundColor,0.2);
         }
         if(this._options.inactiveTextColor == undefined)
         {
            this.inactiveTextColor = ColorTools.getTintedColor(this._inactiveColor,0,0.6);
         }
         if(this._options.unselectedTextColor == undefined)
         {
            this._unselectedTextColor = ColorTools.getTintedColor(this._inverseTextColor,this._buttonColor,0.3);
         }
         if(this._options.unselectedColor == undefined)
         {
            this._unselectedColor = ColorTools.getTintedColor(this._buttonColor,this._borderColor,0.25);
         }
         if(this._options.hoverColor == undefined)
         {
            this._hoverColor = ColorTools.getTintedColor(this._linkColor,16777215,0.3);
         }
      }
      
      private function updateCSS() : void
      {
         if(this._styleSheet == null)
         {
            this._styleSheet = new StyleSheet();
         }
         var _loc1_:String = ColorTools.numberToHTMLColor(this._titleColor);
         var _loc2_:String = ColorTools.numberToHTMLColor(this._textColor);
         var _loc3_:String = ColorTools.numberToHTMLColor(this._linkColor);
         var _loc4_:String = ColorTools.numberToHTMLColor(this._hoverColor);
         var _loc5_:String = ColorTools.numberToHTMLColor(ColorTools.getTintedColor(this.textColor,this.backgroundColor,0.5));
         var _loc6_:String = ColorTools.numberToHTMLColor(ColorTools.getTintedColor(this._titleColor,this.backgroundColor,0.2));
         this.css = "";
         this.css += "h1 { font-family: " + this._htmlFont + "; font-weight: bold; font-size: " + Math.min(18,this.titleFontSize * 2) + "px; color: " + _loc1_ + "; leading: " + Math.ceil(Math.min(18,this.titleFontSize * 2) / 3) + "px; } ";
         this.css += "h2 { font-family: " + this._htmlFont + "; font-weight: bold; font-size: " + (this.titleFontSize + 6) + "px; color: " + _loc1_ + "; leading: " + Math.ceil((this.titleFontSize + 6) / 3) + "px; } ";
         this.css += "h3 { font-family: " + this._htmlFont + "; font-weight: bold; font-size: " + this.titleFontSize + "px; color: " + _loc1_ + "; leading: " + Math.ceil(this.titleFontSize / 3) + "px; } ";
         this.css += "h4 { font-family: " + this._htmlFont + "; font-weight: bold; font-size: " + Math.ceil((this.fontSize + this.titleFontSize) / 2) + "px; color: " + _loc1_ + "; leading: " + Math.ceil((this.fontSize + this.titleFontSize) / 6) + "px; } ";
         this.css += "h5 { font-weight: bold; font-size: 11px; leading: 0; color: " + _loc6_ + "; } ";
         this.css += "p { font-family: " + this._htmlFont + "; font-weight: normal; font-size: " + this.fontSize + "px; color: " + _loc2_ + "; leading: 2px; } ";
         this.css += "a { font-weight: bold; color: " + _loc3_ + "; text-decoration: underline; } ";
         this.css += "a:hover { font-weight: bold; color: " + _loc4_ + "; textDecoration: underline; } ";
         this.css += ".litelink { font-weight: bold; color: " + _loc3_ + "; text-decoration: none; } ";
         this.css += ".litelink:hover { font-weight: bold; color: " + _loc4_ + "; textDecoration: none; } ";
         this.css += ".center { text-align: center; }";
         this.css += ".note { font-family: Monaco, " + this._htmlFont + "; font-weight: normal; font-size: " + Math.max(12,this._fontSize - 2) + "px; color: " + _loc5_ + "; leading: 0px; } ";
         this.css += ".numeric { font-family: Monaco, Lucida Sans Unicode," + this._htmlFont + "; font-weight: normal; font-size: " + Math.max(12,this._fontSize - 2) + "px; color: " + _loc2_ + "; leading: 2px; } ";
         if(!this._styleSheet.parseCSS(this.css))
         {
            this.debug("CSS error!");
         }
      }
      
      public function clone(param1:Object = null) : Style
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc2_:Object = {};
         for(_loc3_ in this._options)
         {
            _loc2_[_loc3_] = this._options[_loc3_];
         }
         _loc4_ = 0;
         while(_loc4_ < this.cloneParams.length)
         {
            _loc3_ = this.cloneParams[_loc4_];
            if(_loc3_.indexOf("_") == 0)
            {
               if(this[_loc3_] is Array)
               {
                  _loc2_[_loc3_] = this[_loc3_].concat();
               }
               else
               {
                  _loc2_[_loc3_.split("_").join("")] = this[_loc3_];
               }
            }
            _loc4_++;
         }
         if(param1 != null)
         {
            for(_loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            for(_loc3_ in param1)
            {
               _loc2_["_" + _loc3_] = param1[_loc3_];
            }
         }
         return new Style(_loc2_);
      }
      
      private function debug(param1:String) : void
      {
      }
   }
}

