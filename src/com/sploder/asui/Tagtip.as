package com.sploder.asui
{
   import flash.display.Graphics;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   
   public class Tagtip
   {
      private static var _mc:Sprite;
      
      private static var _mcBg:Sprite;
      
      private static var _mcBgShadow:Sprite;
      
      private static var _container:Sprite;
      
      private static var _stage:Stage;
      
      private static var _initialized:Boolean;
      
      private static var _tipFormat:TextFormat;
      
      private static var _tipText:TextField;
      
      private static var cornerRadius:Number;
      
      private static var arrowRadius:Number;
      
      private static var padding:Number;
      
      private static var bkgdColor:Number;
      
      private static var borderColor:Number;
      
      private static var borderThickness:Number;
      
      private static var textColor:Number;
      
      private static var heightOffset:Number;
      
      private static var showInterval:Number;
      
      private static var _width:Number = 150;
      
      private static var border:Boolean = false;
      
      private static var showTime:Number = 0;
      
      private static var fontName:String = "Verdana";
      
      private static var fontSize:Number = 10;
      
      private static var embed:Boolean = false;
      
      public static var showing:Boolean = false;
      
      public static var active:Boolean = true;
      
      public static var showMaxTime:Number = 8000;
      
      public static var showDelay:Number = 1000;
      
      public function Tagtip()
      {
         super();
      }
      
      public static function initialize(param1:Stage) : void
      {
         if(_initialized)
         {
            return;
         }
         _stage = param1;
         _container = new Sprite();
         _container.mouseEnabled = _container.mouseChildren = false;
         _stage.addChild(_container);
         cornerRadius = 4;
         arrowRadius = 10;
         padding = 4;
         heightOffset = -4;
         bkgdColor = 3355443;
         border = true;
         borderColor = 6710886;
         textColor = 16777215;
         borderThickness = 2;
         _mc = new Sprite();
         _mc.mouseEnabled = _mc.mouseChildren = false;
         _container.addChild(_mc);
         makeTextField();
         _mc.visible = false;
         _initialized = true;
      }
      
      public static function destroy() : void
      {
         if(_mc != null && _container != null && _container.getChildIndex(_mc) != -1)
         {
            _container.removeChild(_mc);
         }
      }
      
      private static function makeTextField() : void
      {
         _tipFormat = new TextFormat();
         _tipFormat.align = "center";
         _tipFormat.font = fontName;
         _tipFormat.size = fontSize;
         _tipFormat.color = textColor;
         _tipText = new TextField();
         _tipText.width = _width;
         _tipText.height = parseInt(_tipFormat.size as String);
         _mc.addChild(_tipText);
         _tipText.embedFonts = embed;
         _tipText.selectable = false;
         _tipText.multiline = true;
         _tipText.wordWrap = true;
         _tipText.autoSize = "center";
         _tipText.mouseEnabled = false;
         _tipText.text = "";
         _tipText.setTextFormat(_tipFormat);
      }
      
      private static function drawTag() : void
      {
         var _loc7_:Graphics = null;
         if(!_mc)
         {
            return;
         }
         var _loc1_:Number = _tipText.y - 2;
         var _loc2_:Number = _tipText.width + padding + 10;
         var _loc3_:Number = _tipText.height + padding;
         var _loc4_:Number = arrowRadius;
         var _loc5_:Number = arrowRadius;
         var _loc6_:Number = Math.max(0 - (_container.mouseX - 20) + _tipText.width / 2,Math.min(0,_stage.stageWidth - (_container.mouseX + 20) - _tipText.width / 2));
         _tipText.x = _loc6_ - _tipText.width / 2;
         if(_mcBg == null)
         {
            _mcBgShadow = new Sprite();
            _mcBgShadow.mouseEnabled = false;
            _mc.addChild(_mcBgShadow);
            _mcBg = new Sprite();
            _mcBg.mouseEnabled = false;
            _mc.addChild(_mcBg);
         }
         else
         {
            _mcBg.graphics.clear();
            _mcBgShadow.graphics.clear();
         }
         _loc7_ = _mcBg.graphics;
         _loc7_.beginFill(bkgdColor,1);
         if(border == true)
         {
            _loc7_.lineStyle(borderThickness,borderColor,1,true);
         }
         var _loc8_:Number = Math.max(_loc6_ - _tipText.width / 2 + 4,Math.min(0,_loc6_ + _tipText.width / 2 - 4));
         _loc7_.moveTo(_loc6_ + 0 - _loc2_ / 2 + cornerRadius,_loc1_);
         _loc7_.lineTo(_loc6_ + _loc2_ / 2 - cornerRadius,_loc1_);
         _loc7_.curveTo(_loc6_ + _loc2_ / 2,_loc1_,_loc6_ + _loc2_ / 2,_loc1_ + cornerRadius);
         _loc7_.lineTo(_loc6_ + _loc2_ / 2,_loc1_ + cornerRadius);
         _loc7_.lineTo(_loc6_ + _loc2_ / 2,_loc1_ + _loc3_ - cornerRadius);
         _loc7_.curveTo(_loc6_ + _loc2_ / 2,_loc1_ + _loc3_,_loc6_ + _loc2_ / 2 - cornerRadius,_loc1_ + _loc3_);
         _loc7_.lineTo(_loc6_ + _loc2_ / 2 - cornerRadius,_loc1_ + _loc3_);
         _loc7_.lineTo(_loc4_ / 2 + _loc8_,_loc1_ + _loc3_);
         _loc7_.lineTo(0 + _loc8_,0);
         _loc7_.lineTo(0 - _loc4_ / 2 + _loc8_,_loc1_ + _loc3_);
         _loc7_.lineTo(_loc6_ + 0 - _loc2_ / 2 + cornerRadius,_loc1_ + _loc3_);
         _loc7_.curveTo(_loc6_ + 0 - _loc2_ / 2,_loc1_ + _loc3_,_loc6_ + 0 - _loc2_ / 2,_loc1_ + _loc3_ - cornerRadius);
         _loc7_.lineTo(_loc6_ + 0 - _loc2_ / 2,_loc1_ + _loc3_ - cornerRadius);
         _loc7_.lineTo(_loc6_ + 0 - _loc2_ / 2,_loc1_ + cornerRadius);
         _loc7_.curveTo(_loc6_ + 0 - _loc2_ / 2,_loc1_,_loc6_ + 0 - _loc2_ / 2 + cornerRadius,_loc1_);
         _loc7_.lineTo(_loc6_ + 0 - _loc2_ / 2 + cornerRadius,_loc1_);
         _loc7_.endFill();
         _mcBgShadow.x = _mcBgShadow.y = 4;
         _loc7_ = _mcBgShadow.graphics;
         _loc7_.beginFill(0,0.1);
         _loc7_.moveTo(_loc6_ + 0 - _loc2_ / 2 + cornerRadius,_loc1_);
         _loc7_.lineTo(_loc6_ + _loc2_ / 2 - cornerRadius,_loc1_);
         _loc7_.curveTo(_loc6_ + _loc2_ / 2,_loc1_,_loc6_ + _loc2_ / 2,_loc1_ + cornerRadius);
         _loc7_.lineTo(_loc6_ + _loc2_ / 2,_loc1_ + cornerRadius);
         _loc7_.lineTo(_loc6_ + _loc2_ / 2,_loc1_ + _loc3_ - cornerRadius);
         _loc7_.curveTo(_loc6_ + _loc2_ / 2,_loc1_ + _loc3_,_loc6_ + _loc2_ / 2 - cornerRadius,_loc1_ + _loc3_);
         _loc7_.lineTo(_loc6_ + _loc2_ / 2 - cornerRadius,_loc1_ + _loc3_);
         _loc7_.lineTo(_loc4_ / 2 + _loc8_,_loc1_ + _loc3_);
         _loc7_.lineTo(0 + _loc8_,0);
         _loc7_.lineTo(0 - _loc4_ / 2 + _loc8_,_loc1_ + _loc3_);
         _loc7_.lineTo(_loc6_ + 0 - _loc2_ / 2 + cornerRadius,_loc1_ + _loc3_);
         _loc7_.curveTo(_loc6_ + 0 - _loc2_ / 2,_loc1_ + _loc3_,_loc6_ + 0 - _loc2_ / 2,_loc1_ + _loc3_ - cornerRadius);
         _loc7_.lineTo(_loc6_ + 0 - _loc2_ / 2,_loc1_ + _loc3_ - cornerRadius);
         _loc7_.lineTo(_loc6_ + 0 - _loc2_ / 2,_loc1_ + cornerRadius);
         _loc7_.curveTo(_loc6_ + 0 - _loc2_ / 2,_loc1_,_loc6_ + 0 - _loc2_ / 2 + cornerRadius,_loc1_);
         _loc7_.lineTo(_loc6_ + 0 - _loc2_ / 2 + cornerRadius,_loc1_);
         _loc7_.endFill();
         _mc.setChildIndex(_tipText,2);
      }
      
      public static function showTag(param1:String, param2:Boolean = false) : void
      {
         if(!_mc)
         {
            return;
         }
         if(!active)
         {
            return;
         }
         if(showInterval > 0)
         {
            clearInterval(showInterval);
            showInterval = 0;
         }
         _container.parent.setChildIndex(_container,_container.parent.numChildren - 1);
         if(!showing && param1.length > 0 && param1 != "undefined")
         {
            showing = true;
            _tipText.text = param1;
            _tipText.setTextFormat(_tipFormat);
            _tipText.y = 0 - (_tipText.height + 10);
            _mc.x = _container.mouseX;
            _mc.y = _container.mouseY;
            drawTag();
            _mc.visible = false;
            _mc.alpha = 1;
            showTime = getTimer();
            _mc.addEventListener(Event.ENTER_FRAME,followMouse,false,0,true);
            showInterval = setInterval(showDelayed,param2 ? 10 : showDelay);
         }
         else
         {
            hideTag();
         }
      }
      
      protected static function showDelayed() : void
      {
         _mc.visible = true;
      }
      
      public static function hideTag() : void
      {
         if(showing)
         {
            if(showInterval > 0)
            {
               clearInterval(showInterval);
               showInterval = 0;
            }
            if(!_mc)
            {
               return;
            }
            showing = false;
            _mc.visible = false;
            _mc.alpha = 1;
            _mc.removeEventListener(Event.ENTER_FRAME,followMouse);
         }
      }
      
      public static function followMouse(param1:Event) : void
      {
         if(!_mc)
         {
            return;
         }
         _mc.x = _container.mouseX >> 0;
         _mc.y = _container.mouseY + heightOffset >> 0;
         _mc.scaleY = _tipText.scaleY = 1;
         _tipText.y = 0 - (_tipText.height + 10);
         drawTag();
         if(_container.mouseY > 40)
         {
            _mc.scaleY = _tipText.scaleY = 1;
            _tipText.y = 0 - (_tipText.height + 10);
         }
         else
         {
            _mc.scaleY = _tipText.scaleY = -1;
            _tipText.y = -10;
            _mc.y += 20;
         }
         if(getTimer() - showTime > showMaxTime)
         {
            _mc.alpha = Math.max(0,100 - (getTimer() - showTime - showMaxTime) / 5) / 100;
            if(_mc.alpha <= 0)
            {
               hideTag();
            }
         }
      }
      
      public static function connectButton(param1:SimpleButton, param2:String = "", param3:Boolean = false) : void
      {
         var b:SimpleButton = param1;
         var alt:String = param2;
         var now:Boolean = param3;
         b.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            Tagtip.showTag(alt,now);
         },false,0,true);
         b.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
         {
            Tagtip.hideTag();
         },false,0,true);
      }
   }
}

