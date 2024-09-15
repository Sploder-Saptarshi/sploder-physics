package com.sploder.asui
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class Create
   {
      public static const ICON_ARROW_LEFT:Array = [-0.2,-0.5,0.4,0,-0.2,0.5];
      
      public static const ICON_ARROW_RIGHT:Array = [0.2,-0.5,-0.4,0,0.2,0.5];
      
      public static const ICON_DOUBLE_ARROW_LEFT:Array = [-0.5,0.48,-0.02,0,-0.5,-0.49,-0.5,0.48,0.01,0.48,0.5,0,0.01,-0.49,0.01,0.48];
      
      public static const ICON_DOUBLE_ARROW_RIGHT:Array = [0.01,0,0.5,0.48,0.5,-0.49,0.01,0,-0.5,0,-0.02,0.48,-0.02,-0.49,-0.5,0];
      
      public static const ICON_ARROW_UP:Array = [-0.5,0.3,0,-0.3,0.5,0.3];
      
      public static const ICON_ARROW_DOWN:Array = [-0.5,-0.3,0,0.3,0.5,-0.3];
      
      public static const ICON_BACK_ARROW:Array = [-0.42,-0.09,-0.42,-0.09,-0.09,-0.42,0.04,-0.3,-0.16,-0.09,0.49,-0.09,0.49,0.09,-0.16,0.09,0.04,0.29,-0.09,0.41,-0.51,-0.01,-0.42,-0.09];
      
      public static const ICON_NEXT_ARROW:Array = [0.15,-0.09,-0.5,-0.09,-0.5,0.09,0.15,0.09,-0.05,0.29,0.08,0.41,0.5,-0.01,0.41,-0.09,0.41,-0.09,0.08,-0.42,-0.05,-0.3,0.15,-0.09];
      
      public static const ICON_IN_ARROW:Array = [0.26,-0.28,0.49,-0.28,0.49,0.5,0.33,0.5,0.33,0.5,-0.27,0.5,-0.27,0.26,0.1,0.26,-0.5,-0.34,-0.34,-0.5,0.26,0.09,0.26,-0.28];
      
      public static const ICON_OUT_ARROW:Array = [0.49,-0.5,0.33,-0.5,0.33,-0.5,-0.27,-0.5,-0.27,-0.27,0.1,-0.27,-0.5,0.33,-0.34,0.5,0.26,-0.1,0.26,0.27,0.49,0.26,0.49,-0.5];
      
      public static const ICON_CHECK:Array = [0.5,-0.2,-0.1,0.4,-0.5,0,-0.3,-0.2,-0.1,0,0.3,-0.4,0.5,-0.2];
      
      public static const ICON_PLUS:Array = [0.12,-0.5,0.12,-0.12,0.5,-0.12,0.5,0.12,0.12,0.12,0.12,0.5,-0.12,0.5,-0.12,-0.12,-0.5,-0.12,-0.5,0.12,-0.12,0.12,-0.12,-0.5];
      
      public static const ICON_MINUS:Array = [-0.5,-0.12,0.5,-0.12,0.5,0.12,-0.5,0.12];
      
      public static const ICON_PLAY:Array = [-0.3,-0.5,0.5,0,-0.3,0.5];
      
      public static const ICON_PAUSE:Array = [-0.1,-0.5,-0.1,0.5,-0.5,0.5,-0.5,-0.5,-0.1,-0.5,0.5,-0.5,0.5,0.5,0.1,0.5,0.1,-0.5,0.5,-0.5];
      
      public static const ICON_CLOSE:Array = [0.5,-0.5,0.5,-0.31,0.18,0,0.345,0.165,0.35,0.165,0.5,0.315,0.5,0.5,0.31,0.5,0,0.18,-0.095,0.28,-0.095,0.28,-0.315,0.5,-0.5,0.5,-0.5,0.315,-0.18,0,-0.28,-0.095,-0.28,-0.095,-0.5,-0.31,-0.5,-0.5,-0.315,-0.5,-0.145,-0.325,-0.145,-0.325,0,-0.18,0.31,-0.5,0.5,-0.5];
      
      public static const ICON_NEXTTRACK:Array = [0.5,0.45,0.5,-0.46,0.4,-0.46,0.4,-0.04,-0.05,-0.46,-0.05,-0.04,-0.5,-0.46,-0.5,0.45,-0.05,0.04,-0.05,0.45,0.4,0.04,0.4,0.45,0.5,0.45];
      
      public static const ICON_PREVTRACK:Array = [0.5,-0.46,0.5,0.45,0.04,0.04,0.04,0.45,-0.41,0.04,-0.41,0.45,-0.5,0.45,-0.5,-0.46,-0.41,-0.46,-0.41,-0.04,0.04,-0.46,0.04,-0.04,0.5,-0.46];
      
      public static const ICON_FASTFORWARD:Array = [-0.5,0.47,-0.03,0.04,-0.03,0.47,0.5,0,-0.03,-0.48,-0.03,-0.05,-0.5,-0.48,-0.5,0.47];
      
      public static const ICON_REWIND:Array = [0.5,-0.48,0.5,0.47,0.02,0.04,0.02,0.47,-0.5,0,0.02,-0.48,0.02,-0.05,0.5,-0.48];
      
      public static const ICON_LAUNCH:Array = [0,-0.25,-0.25,-0.5,0.5,-0.5,0.5,0.25,0.25,0,-0.25,0.5,-0.5,0.25];
      
      public function Create()
      {
         super();
      }
      
      public static function button(param1:Sprite, param2:Object, param3:Number = -1, param4:Number = NaN, param5:Number = NaN, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Object = null, param10:Style = null, param11:Boolean = false, param12:int = 0, param13:Boolean = false) : Sprite
      {
         var _loc14_:String = null;
         var _loc15_:Object = null;
         var _loc16_:Boolean = false;
         var _loc17_:String = null;
         var _loc18_:Object = null;
         var _loc21_:TextField = null;
         var _loc24_:TextField = null;
         var _loc26_:TextField = null;
         var _loc33_:TextField = null;
         var _loc35_:Sprite = null;
         var _loc36_:Number = NaN;
         var _loc37_:Sprite = null;
         var _loc38_:Sprite = null;
         if(param10 == null)
         {
            param10 = new Style();
         }
         if(typeof param2 == "string")
         {
            _loc14_ = param2 as String;
         }
         else
         {
            _loc14_ = param2.text != null ? param2.text : "";
            _loc15_ = param2.icon != null ? param2.icon : null;
            _loc16_ = param2.first != null ? param2.first != "false" : true;
         }
         _loc17_ = _loc14_;
         _loc18_ = _loc15_;
         if(typeof param9 == "string")
         {
            _loc17_ = param9 as String;
         }
         else if(param9 != null)
         {
            _loc17_ = param9.text != null ? param9.text : _loc14_;
            _loc18_ = param9.icon != null ? param9.icon : _loc15_;
         }
         var _loc19_:* = String(param10.round);
         if(param3 == -1)
         {
            param3 = Position.ALIGN_CENTER;
         }
         if(param6)
         {
            _loc19_ = _loc19_ + " " + _loc19_ + " 0 0";
         }
         var _loc20_:Sprite;
         (_loc20_ = new Sprite()).name = "btn";
         var _loc22_:Sprite;
         (_loc22_ = new Sprite()).name = "button_btn";
         _loc22_.buttonMode = true;
         var _loc23_:Sprite;
         (_loc23_ = new Sprite()).name = "button_inactive";
         var _loc25_:Sprite;
         (_loc25_ = new Sprite()).name = "button_selected";
         var _loc27_:Sprite = param1;
         var _loc28_:Array = _loc19_.split(" ");
         var _loc29_:int = 0;
         while(_loc29_ < _loc28_.length)
         {
            _loc28_[_loc29_] = parseInt(_loc28_[_loc29_]) > 0 ? parseInt(_loc28_[_loc29_]) - param10.borderWidth : 0;
            _loc29_++;
         }
         var _loc30_:String = _loc28_.join(" ");
         param1.addChild(_loc20_);
         _loc21_ = newText(_loc14_,"_buttontext",_loc20_,param10,param7 ? param10.unselectedTextColor : param10.buttonTextColor,param10.buttonFontSize,false,true);
         var _loc31_:Number = _loc21_.width;
         _loc21_.text = _loc14_;
         _loc31_ = Math.max(_loc31_,_loc21_.width);
         if(isNaN(param4))
         {
            param4 = _loc31_ + param10.padding * 3 + Math.max(8,param10.borderWidth * 2);
         }
         else if(!param11)
         {
            param4 = Math.max(param4,_loc31_ + param10.padding * 3 + Math.max(8,param10.borderWidth * 2) - 2);
         }
         param4 += param12;
         param4 = Math.floor(param4);
         if(isNaN(param5))
         {
            param5 = _loc21_.height + param10.padding + param10.borderWidth * 2;
         }
         else
         {
            param5 = Math.max(param5,_loc21_.height + param10.padding + param10.borderWidth * 2 - 2);
         }
         if(param3 == Position.ALIGN_LEFT)
         {
            _loc21_.x = param10.padding;
         }
         else if(param3 == Position.ALIGN_RIGHT)
         {
            _loc21_.x = param4 - _loc21_.width - param10.padding;
         }
         else
         {
            _loc21_.x = Math.floor((param4 - _loc21_.width) * 0.5);
         }
         _loc21_.y = Math.floor((param5 - _loc21_.height) * 0.5);
         _loc27_ = _loc20_;
         var _loc32_:Number = 0;
         if(param6)
         {
            _loc32_ = param10.borderWidth;
         }
         if(param10.border)
         {
            DrawingMethods.roundedRect(_loc27_,false,0,0,param4,param5 - _loc32_,_loc19_,[param10.unselectedBorderColor > -1 ? param10.unselectedBorderColor : param10.buttonBorderColor],[param10.backgroundAlpha],[1]);
         }
         if(param10.background)
         {
            DrawingMethods.roundedRect(_loc27_,false,param10.borderWidth,param10.borderWidth,param4 - param10.borderWidth * 2,param5 - param10.borderWidth * 2,_loc30_,[param7 ? param10.unselectedColor : param10.buttonColor],[param10.backgroundAlpha],[1]);
         }
         if(param10.gradient)
         {
            DrawingMethods.roundedRect(_loc27_,false,param10.borderWidth,param10.borderWidth,param4 - param10.borderWidth * 2,param5 - param10.borderWidth * 2,_loc30_,[16777215,16777215,0,0],[0.4,0.15,0,0.1],[0,128,128,255]);
         }
         _loc20_.addChild(_loc22_);
         _loc27_ = _loc22_;
         if(param10.background || param10.border || param10.gradient || !param10.embedFonts)
         {
            DrawingMethods.roundedRect(_loc27_,false,param10.borderWidth,param10.borderWidth,param4 - param10.borderWidth * 2,param5 - param10.borderWidth * 2,_loc30_,[16777215],[20],[1]);
         }
         else
         {
            DrawingMethods.roundedRect(_loc27_,false,0,0,param4,param5,_loc30_,[16777215],[0],[1]);
            (_loc33_ = newText(_loc14_,"_buttontext",_loc22_,param10,16777215,param10.buttonFontSize,false,true)).mouseEnabled = false;
            _loc33_.x = _loc21_.x;
            _loc33_.y = _loc21_.y;
            _loc33_.alpha = 1.5;
         }
         _loc22_.alpha = 0;
         _loc20_.addChild(_loc25_);
         _loc27_ = _loc25_;
         var _loc34_:int = param13 ? int(param10.borderWidth) : 0;
         if(!param8)
         {
            if(param10.border)
            {
               DrawingMethods.roundedRect(_loc27_,false,0,0,param4,_loc34_ + param5 - _loc32_,_loc19_,[param10.selectedButtonBorderColor],[param10.backgroundAlpha],[1]);
            }
            if(param10.background)
            {
               DrawingMethods.roundedRect(_loc27_,false,param10.borderWidth,param10.borderWidth,param4 - param10.borderWidth * 2,_loc34_ + param5 - param10.borderWidth * 2,_loc30_,[param10.buttonColor],[param10.backgroundAlpha],[1]);
            }
            if(param10.gradient)
            {
               DrawingMethods.roundedRect(_loc27_,false,param10.borderWidth,param10.borderWidth,param4 - param10.borderWidth * 2,_loc34_ + param5 - param10.borderWidth * 2,_loc30_,[16777215,16777215,0,0],[0.4,0.15,0,0.1],[0,128,128,255]);
            }
            (_loc26_ = newText(_loc14_,"_buttontext",_loc25_,param10,param7 ? param10.buttonTextColor : param10.inverseTextColor,param10.buttonFontSize,false,true)).x = _loc21_.x;
            _loc26_.y = _loc21_.y;
            _loc25_.visible = false;
         }
         else
         {
            if(param10.border)
            {
               DrawingMethods.roundedRect(_loc27_,false,0,0,param4,_loc34_ + param5 - _loc32_,_loc19_,[param10.buttonBorderColor],[param10.backgroundAlpha],[1]);
            }
            if(param10.background)
            {
               DrawingMethods.roundedRect(_loc27_,false,param10.borderWidth,param10.borderWidth,param4 - param10.borderWidth * 2,_loc34_ + param5 - param10.borderWidth * 2,_loc30_,[ColorTools.getTintedColor(param10.buttonColor,0,0.2)],[param10.backgroundAlpha],[1]);
            }
            if(param10.gradient)
            {
               DrawingMethods.roundedRect(_loc27_,false,param10.borderWidth,param10.borderWidth,param4 - param10.borderWidth * 2,_loc34_ + param5 - param10.borderWidth * 2,_loc30_,[0,0,16777215,16777215],[0.2,0,0.1,0.2],[0,128,128,255]);
            }
            _loc26_ = newText(_loc17_.length > 0 ? _loc17_ : _loc14_,"_buttontext",_loc25_,param10,param10.inverseTextColor,param10.buttonFontSize,false,true);
            if(param3 == Position.ALIGN_LEFT)
            {
               _loc26_.x = param10.padding;
            }
            else if(param3 == Position.ALIGN_RIGHT)
            {
               _loc26_.x = param4 - _loc26_.width - param10.padding;
            }
            else
            {
               _loc26_.x = Math.floor((param4 - _loc26_.width) * 0.5);
            }
            _loc26_.y = _loc21_.y;
            _loc25_.visible = false;
         }
         _loc20_.addChild(_loc23_);
         _loc27_ = _loc23_;
         if(param10.border)
         {
            DrawingMethods.roundedRect(_loc27_,false,0,0,param4,param5 - _loc32_,_loc19_,[ColorTools.getTintedColor(param10.inactiveColor,0,0.25)],[param10.backgroundAlpha],[1]);
         }
         if(param10.background)
         {
            DrawingMethods.roundedRect(_loc27_,false,param10.borderWidth,param10.borderWidth,param4 - param10.borderWidth * 2,param5 - param10.borderWidth * 2,_loc30_,[param10.inactiveColor],[param10.backgroundAlpha],[1]);
         }
         if(param10.gradient)
         {
            DrawingMethods.roundedRect(_loc27_,false,param10.borderWidth,param10.borderWidth,param4 - param10.borderWidth * 2,param5 - param10.borderWidth * 2,_loc30_,[16777215,16777215,0,0],[0.4,0.15,0,0.1],[0,128,128,255]);
         }
         (_loc24_ = newText(_loc14_,"_buttontext",_loc23_,param10,param10.inactiveTextColor,param10.buttonFontSize,false,true)).x = _loc21_.x;
         _loc24_.y = _loc21_.y;
         _loc23_.visible = false;
         if(param8)
         {
            _loc20_.setChildIndex(_loc22_,3);
         }
         if(param10.buttonDropShadow)
         {
            param1.filters = [new DropShadowFilter(4,45,0,0.2,4,4,1,2)];
         }
         if(_loc15_ != null && _loc15_ is Array)
         {
            (_loc35_ = new Sprite()).mouseEnabled = false;
            _loc35_.name = "icon";
            newIcon(_loc18_ as Array,_loc35_,param10.buttonTextColor,1,param10);
            _loc36_ = _loc35_.width / _loc35_.height;
            if(_loc36_ <= 1)
            {
               _loc35_.height = _loc21_.height * 0.5;
               _loc35_.width = _loc35_.height * _loc36_;
            }
            else
            {
               _loc35_.width = _loc21_.height * 0.5;
               _loc35_.height = _loc35_.width / _loc36_;
            }
            if(_loc16_)
            {
               if(param3 == Position.ALIGN_CENTER)
               {
                  _loc35_.x = _loc21_.x - _loc21_.height / 4;
                  _loc21_.x += _loc21_.height / 4;
               }
               else
               {
                  _loc35_.x = _loc21_.x + _loc35_.width / 2;
                  _loc21_.x += _loc35_.x + _loc35_.width / 2 + param10.padding / 2;
               }
            }
            else if(param3 == Position.ALIGN_CENTER)
            {
               _loc35_.x = _loc21_.x + _loc21_.width + _loc21_.height / 4;
               _loc21_.x -= _loc21_.height / 4;
            }
            else
            {
               _loc35_.x = _loc20_.width - Math.max(10,param10.padding + param10.round);
            }
            _loc24_.x = _loc26_.x = _loc21_.x;
            _loc35_.y = _loc21_.y + _loc21_.height / 2;
            if(param7)
            {
               _loc25_.addChild(_loc35_);
            }
            else
            {
               _loc20_.addChild(_loc35_);
            }
            (_loc37_ = new Sprite()).mouseEnabled = false;
            _loc37_.name = "icon_inactive";
            newIcon(_loc15_ as Array,_loc37_,param7 ? param10.unselectedTextColor : param10.inactiveTextColor,1,param10);
            _loc36_ = _loc37_.width / _loc37_.height;
            _loc37_.height = _loc24_.height * 0.65;
            if(_loc36_ <= 1)
            {
               _loc37_.height = _loc21_.height * 0.5;
               _loc37_.width = _loc37_.height * _loc36_;
            }
            else
            {
               _loc37_.width = _loc21_.height * 0.5;
               _loc37_.height = _loc37_.width / _loc36_;
            }
            _loc37_.x = _loc35_.x;
            _loc37_.y = _loc35_.y;
            if(!param7)
            {
               _loc37_.visible = false;
            }
            param1.addChild(_loc37_);
            if(_loc33_ != null)
            {
               (_loc38_ = new Sprite()).mouseEnabled = false;
               _loc38_.name = "icon_button";
               newIcon(_loc15_ as Array,_loc38_,16777215,1,param10);
               _loc38_.x = _loc37_.x;
               _loc38_.y = _loc37_.y;
               _loc38_.width = _loc37_.width;
               _loc38_.height = _loc37_.height;
               _loc33_.x = _loc21_.x;
               _loc33_.y = _loc21_.y;
               _loc38_.alpha = 1.5;
               _loc22_.addChild(_loc38_);
            }
            _loc20_.setChildIndex(_loc22_,_loc20_.numChildren - 1);
         }
         return _loc20_;
      }
      
      public static function hitArea(param1:Sprite, param2:Array, param3:Number, param4:Number, param5:Boolean = false, param6:Array = null, param7:Style = null, param8:Boolean = true, param9:int = -1) : Sprite
      {
         var _loc17_:Sprite = null;
         if(param7 == null)
         {
            param7 = new Style();
         }
         var _loc10_:* = param7.round.toString();
         var _loc11_:* = Math.max(0,param7.round - param7.borderWidth).toString();
         if(param8)
         {
            _loc10_ = _loc11_ = "0";
         }
         else if(param9 >= 0)
         {
            switch(param9)
            {
               case Position.POSITION_ABOVE:
                  _loc10_ = "0 0 " + _loc10_ + " " + _loc10_;
                  _loc11_ = "0 0 " + _loc11_ + " " + _loc11_;
                  break;
               case Position.POSITION_RIGHT:
                  _loc10_ = _loc10_ + " 0 0 " + _loc10_;
                  _loc11_ = _loc11_ + " 0 0 " + _loc11_;
                  break;
               case Position.POSITION_BELOW:
                  _loc10_ = _loc10_ + " " + _loc10_ + " 0 0";
                  _loc11_ = _loc11_ + " " + _loc11_ + " 0 0";
                  break;
               case Position.POSITION_LEFT:
                  _loc10_ = "0 " + _loc10_ + " " + _loc10_ + " 0";
                  _loc11_ = "0 " + _loc11_ + " " + _loc11_ + " 0";
            }
         }
         var _loc12_:Sprite;
         (_loc12_ = new Sprite()).name = "btn";
         var _loc13_:Sprite;
         (_loc13_ = new Sprite()).name = "button_btn";
         _loc13_.buttonMode = true;
         var _loc14_:Sprite;
         (_loc14_ = new Sprite()).name = "button_inactive";
         var _loc15_:Sprite;
         (_loc15_ = new Sprite()).name = "button_selected";
         var _loc16_:Sprite = param1;
         param1.addChild(_loc12_);
         _loc16_ = _loc12_;
         if(param7.border)
         {
            DrawingMethods.roundedRect(_loc16_,false,0,0,param3,param4,_loc10_,[param7.unselectedBorderColor != -1 ? param7.unselectedBorderColor : param7.buttonBorderColor],[param7.backgroundAlpha],[1]);
         }
         if(param7.background)
         {
            DrawingMethods.roundedRect(_loc16_,false,param7.borderWidth,param7.borderWidth,param3 - param7.borderWidth * 2,param4 - param7.borderWidth * 2,_loc11_,[param7.unselectedColor],[param7.backgroundAlpha],[1]);
         }
         else
         {
            DrawingMethods.rect(_loc16_,false,0,0,param3,param4,0,0);
         }
         if(param7.gradient)
         {
            DrawingMethods.roundedRect(_loc16_,false,param7.borderWidth,param7.borderWidth,param3 - param7.borderWidth * 2,param4 - param7.borderWidth * 2,_loc11_,[16777215,16777215,0,0],[0.4,0.15,0,0.1],[0,128,128,255]);
         }
         if(param2 != null)
         {
            (_loc17_ = newIcon(param2,_loc12_,param7.buttonTextColor,1,param7)).name = "icon";
         }
         _loc12_.addChild(_loc13_);
         _loc16_ = _loc13_;
         if(param7.background || param7.border || param7.gradient || param2 == null)
         {
            DrawingMethods.roundedRect(_loc16_,false,param7.borderWidth,param7.borderWidth,param3 - param7.borderWidth * 2,param4 - param7.borderWidth * 2,_loc11_,[16777215],[20],[1]);
         }
         else
         {
            DrawingMethods.roundedRect(_loc16_,false,0,0,param3,param4,_loc10_,[16777215],[0],[1]);
            (_loc17_ = newIcon(param2,_loc16_,16777215,1,param7)).mouseEnabled = false;
            _loc17_.alpha = 1.5;
         }
         _loc13_.alpha = 0;
         _loc12_.addChild(_loc15_);
         _loc16_ = _loc15_;
         if(!param5)
         {
            if(param7.border)
            {
               DrawingMethods.roundedRect(_loc16_,false,0,0,param3,param4,_loc10_,[param7.buttonBorderColor],[param7.backgroundAlpha],[1]);
            }
            if(param7.background || param7.selectedButtonColor > -1)
            {
               DrawingMethods.roundedRect(_loc16_,false,param7.borderWidth,param7.borderWidth,param3 - param7.borderWidth * 2,param4 - param7.borderWidth * 2,_loc11_,[param7.selectedButtonColor == -1 ? param7.buttonColor : param7.selectedButtonColor],[param7.backgroundAlpha],[1]);
            }
            else
            {
               DrawingMethods.rect(_loc16_,false,0,0,param3,param4,0,0);
            }
            if(param7.gradient)
            {
               DrawingMethods.roundedRect(_loc16_,false,param7.borderWidth,param7.borderWidth,param3 - param7.borderWidth * 2,param4 - param7.borderWidth * 2,_loc11_,[16777215,16777215,0,0],[0.4,0.15,0,0.1],[0,128,128,255]);
            }
            if(param2 != null)
            {
               (_loc17_ = newIcon(param6 != null ? param6 : param2,_loc16_,param7.buttonTextColor,1,param7)).name = "icon_selected";
            }
         }
         else
         {
            if(param7.border)
            {
               DrawingMethods.roundedRect(_loc16_,false,0,0,param3,param4,_loc10_,[param7.buttonBorderColor],[param7.backgroundAlpha],[1]);
            }
            if(param7.background)
            {
               DrawingMethods.roundedRect(_loc16_,false,param7.borderWidth,param7.borderWidth,param3 - param7.borderWidth * 2,param4 - param7.borderWidth * 2,_loc11_,[param7.buttonColor],[param7.backgroundAlpha],[1]);
            }
            else
            {
               DrawingMethods.rect(_loc16_,false,0,0,param3,param4,0,0);
            }
            if(param7.gradient)
            {
               DrawingMethods.roundedRect(_loc16_,false,param7.borderWidth,param7.borderWidth,param3 - param7.borderWidth * 2,param4 - param7.borderWidth * 2,_loc11_,[0,0,16777215,16777215],[0.2,0,0.1,0.2],[0,128,128,255]);
            }
            if(param2 != null)
            {
               (_loc17_ = newIcon(param6 != null ? param6 : param2,_loc16_,param7.buttonTextColor,1,param7)).name = "icon_selected";
            }
         }
         _loc15_.visible = false;
         _loc12_.addChild(_loc14_);
         _loc16_ = _loc14_;
         DrawingMethods.rect(_loc16_,false,0,0,param3,param4,0,0);
         if(param7.border)
         {
            DrawingMethods.roundedRect(_loc16_,false,param7.borderWidth,param7.borderWidth,param3 - param7.borderWidth * 2,param4 - param7.borderWidth * 2,_loc11_,[param7.inactiveColor],[param7.backgroundAlpha],[1]);
         }
         if(param2 != null)
         {
            (_loc17_ = newIcon(param2,_loc16_,param7.inactiveTextColor,1,param7)).name = "icon_inactive";
         }
         _loc14_.visible = false;
         if(param5)
         {
            _loc12_.setChildIndex(_loc13_,2);
         }
         if(param7.buttonDropShadow)
         {
            param1.filters = [new DropShadowFilter(4,45,0,0.2,4,4,1,2)];
         }
         _loc12_.setChildIndex(_loc13_,_loc12_.numChildren - 1);
         return _loc12_;
      }
      
      public static function dragArea(param1:Sprite, param2:Number, param3:Number, param4:Style) : void
      {
         var _loc9_:int = 0;
         var _loc5_:Graphics = param1.graphics;
         _loc5_.clear();
         _loc5_.beginFill(0,0);
         _loc5_.drawRect(0,0,param2,param3);
         var _loc6_:Number = ColorTools.getTintedColor(param4.backgroundColor,16777215,0.2);
         var _loc7_:Number = ColorTools.getTintedColor(param4.backgroundColor,0,0.4);
         var _loc8_:int = 0;
         while(_loc8_ < param3)
         {
            _loc9_ = 0;
            while(_loc9_ < param2)
            {
               _loc5_.beginFill(_loc6_,1);
               _loc5_.drawRect(_loc9_,_loc8_,3,3);
               _loc5_.beginFill(_loc7_,1);
               _loc5_.drawRect(_loc9_ + 2,_loc8_,1,3);
               _loc5_.drawRect(_loc9_,_loc8_ + 2,2,1);
               _loc9_ += 4;
            }
            _loc8_ += 4;
         }
      }
      
      public static function newText(param1:String, param2:String, param3:Sprite, param4:Style, param5:Number = NaN, param6:Number = NaN, param7:Boolean = false, param8:Boolean = false) : TextField
      {
         if(isNaN(param5))
         {
            param5 = param4.textColor;
         }
         if(isNaN(param6))
         {
            param6 = param8 ? param4.buttonFontSize : param4.fontSize;
         }
         var _loc9_:TextField;
         (_loc9_ = new TextField()).width = 200;
         _loc9_.height = 10;
         _loc9_.name = param2;
         param3.addChild(_loc9_);
         _loc9_.autoSize = TextFieldAutoSize.LEFT;
         _loc9_.embedFonts = param4.embedFonts;
         if(param7)
         {
            _loc9_.htmlText = param1;
         }
         else
         {
            _loc9_.text = param1;
         }
         _loc9_.selectable = false;
         _loc9_.setTextFormat(new TextFormat(param8 ? param4.buttonFont : param4.font,param6,param5,true));
         _loc9_.defaultTextFormat = new TextFormat(param8 ? param4.buttonFont : param4.font,param6,param5,true);
         if(param4.embedFonts)
         {
            _loc9_.antiAliasType = AntiAliasType.ADVANCED;
         }
         _loc9_.textColor = param5;
         return _loc9_;
      }
      
      public static function inputText(param1:String, param2:String, param3:Sprite, param4:Number, param5:Number, param6:Style) : TextField
      {
         var _loc7_:TextField;
         (_loc7_ = newText(param1,param2,param3,param6)).selectable = true;
         _loc7_.multiline = false;
         _loc7_.wordWrap = false;
         _loc7_.type = "input";
         _loc7_.autoSize = TextFieldAutoSize.LEFT;
         if(param6.embedFonts)
         {
            _loc7_.setTextFormat(new TextFormat(param6.font,param6.fontSize,param6.textColor,false,false,false,"","","left"));
            _loc7_.defaultTextFormat = new TextFormat(param6.font,param6.fontSize,param6.textColor,false,false,false,"","","left");
            _loc7_.embedFonts = true;
         }
         else
         {
            _loc7_.setTextFormat(new TextFormat("_sans",param6.fontSize,param6.textColor,false,false,false,"","","left"));
            _loc7_.defaultTextFormat = new TextFormat("_sans",param6.fontSize,param6.textColor,false,false,false,"","","left");
         }
         _loc7_.text = "TEMPj\'|";
         var _loc8_:int = Math.ceil(_loc7_.height);
         _loc7_.autoSize = TextFieldAutoSize.NONE;
         _loc7_.text = "";
         if(!isNaN(param4) && param4 > 0)
         {
            _loc7_.width = param4;
         }
         if(!isNaN(param5) && param5 > 0)
         {
            _loc7_.height = param5;
         }
         else
         {
            _loc7_.height = _loc8_ + 2 + param6.borderWidth * 2;
         }
         return _loc7_;
      }
      
      public static function newIcon(param1:Array, param2:Sprite, param3:Number, param4:Number = 1, param5:Style = null, param6:Number = 1) : Sprite
      {
         var _loc11_:int = 0;
         var _loc7_:Sprite;
         (_loc7_ = new Sprite()).name = "icon";
         param2.addChild(_loc7_);
         _loc7_.mouseEnabled = false;
         _loc7_.x = param2.width * 0.5;
         _loc7_.y = param2.height * 0.5;
         var _loc8_:Graphics = _loc7_.graphics;
         if(param5 == null)
         {
            param5 = new Style();
         }
         var _loc9_:Number = (param2.width - param5.borderWidth * 2) * param6;
         var _loc10_:Number = (param2.height - param5.borderWidth * 2) * param6;
         if(_loc9_ <= 1)
         {
            _loc9_ = 10;
         }
         if(_loc10_ <= 1)
         {
            _loc10_ = 10;
         }
         _loc9_ = _loc10_ = Math.max(22,Math.min(_loc9_,_loc10_));
         if(param1.length > 2)
         {
            _loc8_.beginFill(param3,param4);
            _loc8_.moveTo(param1[0] * _loc9_ * 0.5,param1[1] * _loc10_ * 0.5);
            _loc11_ = 2;
            while(_loc11_ < param1.length)
            {
               _loc8_.lineTo(param1[_loc11_] * _loc9_ * 0.5,param1[_loc11_ + 1] * _loc10_ * 0.5);
               _loc11_ += 2;
            }
            _loc8_.endFill();
         }
         return _loc7_;
      }
      
      public static function background(param1:Sprite, param2:Number, param3:Number, param4:Style = null, param5:Boolean = false, param6:Number = -1) : void
      {
         var _loc9_:Matrix = null;
         if(param4 == null)
         {
            param4 = Component.globalStyle;
         }
         var _loc7_:Number = param5 ? param4.borderWidth : 0;
         var _loc8_:Number = param6 == -1 ? param4.round : param6;
         if(param5)
         {
            DrawingMethods.roundedRect(param1,false,0,0,param2,param3,_loc8_.toString(),[param4.borderColor],[param4.borderAlpha],[1]);
         }
         if(param4.background && !param4.bgGradient)
         {
            DrawingMethods.roundedRect(param1,false,_loc7_,_loc7_,param2 - _loc7_ * 2,param3 - _loc7_ * 2,Math.max(0,_loc8_ - _loc7_).toString(),[param4.backgroundColor],[param4.backgroundAlpha],[1]);
         }
         else if(param4.background && param4.bgGradient)
         {
            _loc9_ = null;
            if(param4.bgGradientHeight > 0)
            {
               _loc9_ = new Matrix();
               _loc9_.createGradientBox(param2 - _loc7_ * 2,param4.bgGradientHeight,90 * (Math.PI / 180),_loc7_,_loc7_);
            }
            DrawingMethods.roundedRect(param1,false,_loc7_,_loc7_,param2 - _loc7_ * 2,param3 - _loc7_ * 2,Math.max(0,_loc8_ - _loc7_).toString(),param4.bgGradientColors,[param4.backgroundAlpha],param4.bgGradientRatios,_loc9_);
         }
      }
   }
}

