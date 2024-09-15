package com.sploder.builder
{
   import com.sploder.asui.Library;
   import com.sploder.asui.Position;
   import com.sploder.asui.Style;
   import flash.text.Font;
   
   public class Styles
   {
      public static var containerStyle:Style;
      
      public static var backgroundStyle:Style;
      
      public static var mainStyle:Style;
      
      public static var menuStyle:Style;
      
      public static var playfieldStyle:Style;
      
      public static var trayStyle:Style;
      
      public static var trayItemStyle:Style;
      
      public static var chromelessStyle:Style;
      
      public static var dialogueStyle:Style;
      
      public static var promptStyle:Style;
      
      public static var previewStyle:Style;
      
      public static var dialoguePosition:Position;
      
      public static var panelPosition:Position;
      
      public static var promptPosition:Position;
      
      public static var floatPosition:Position;
      
      public static var absPosition:Position;
      
      protected static var _initialized:Boolean = false;
      
      public function Styles()
      {
         super();
      }
      
      public static function initializeFonts(param1:Library) : void
      {
         var _loc2_:Class = null;
         _loc2_ = param1.getFont("myriad");
         Font.registerFont(_loc2_);
         _loc2_ = param1.getFont("myriad_bold");
         Font.registerFont(_loc2_);
      }
      
      public static function initialize() : void
      {
         if(!_initialized)
         {
            dialoguePosition = new Position(null,-1,-1,-1,null,0,0,1000);
            panelPosition = new Position(null,Position.ALIGN_CENTER,Position.PLACEMENT_ABSOLUTE,Position.CLEAR_BOTH,null,70,30);
            promptPosition = new Position(null,Position.ALIGN_CENTER,Position.PLACEMENT_ABSOLUTE,Position.CLEAR_BOTH,null,70,110,-1);
            floatPosition = new Position(null,Position.ALIGN_LEFT,Position.PLACEMENT_FLOAT);
            absPosition = new Position(null,Position.ALIGN_LEFT,Position.PLACEMENT_ABSOLUTE);
            _initialized = true;
            containerStyle = new Style();
            containerStyle.backgroundColor = 8268116;
            containerStyle.borderWidth = 0;
            backgroundStyle = new Style();
            backgroundStyle.backgroundColor = 10040166;
            backgroundStyle.borderWidth = 0;
            backgroundStyle.selectedButtonBorderColor = 10040166;
            mainStyle = new Style();
            mainStyle.buttonColor = 39423;
            mainStyle.backgroundColor = 10040166;
            mainStyle.borderColor = 16737996;
            mainStyle.textColor = 0;
            mainStyle.titleColor = 16777215;
            mainStyle.linkColor = 16772096;
            mainStyle.font = mainStyle.titleFont = "Myriad Web";
            mainStyle.fontSize = 16;
            mainStyle.titleFontSize = 24;
            mainStyle.round = 0;
            mainStyle.buttonFont = "Myriad Web Bold";
            mainStyle.buttonFontSize = 16;
            mainStyle.padding = 10;
            mainStyle.buttonDropShadow = true;
            mainStyle.embedFonts = true;
            menuStyle = new Style();
            menuStyle.font = menuStyle.buttonFont = menuStyle.titleFont = "Myriad Web Bold";
            menuStyle.embedFonts = true;
            menuStyle.bgGradient = true;
            menuStyle.buttonColor = 10027161;
            menuStyle.buttonTextColor = 16777215;
            menuStyle.inactiveColor = 10027161;
            menuStyle.inactiveTextColor = 15597806;
            menuStyle.bgGradientColors = [13369548,6684774];
            menuStyle.borderWidth = 0;
            menuStyle.buttonFontSize = 18;
            menuStyle.round = 0;
            playfieldStyle = new Style();
            playfieldStyle.bgGradient = true;
            playfieldStyle.bgGradientColors = [4937078,3488851,5661063];
            playfieldStyle.bgGradientHeight = 480;
            playfieldStyle.bgGradientRatios = [0,180,240];
            trayStyle = new Style();
            trayStyle.font = trayStyle.buttonFont = trayStyle.titleFont = "Myriad Web Bold";
            trayStyle.embedFonts = true;
            trayStyle.backgroundColor = 5660551;
            trayStyle.buttonColor = 13209;
            trayStyle.unselectedColor = 0;
            trayStyle.buttonTextColor = 16777215;
            trayStyle.unselectedTextColor = 10066329;
            trayStyle.selectedButtonColor = 13209;
            trayStyle.inactiveColor = 0;
            trayStyle.border = false;
            trayStyle.buttonFontSize = 12;
            trayStyle.round = 0;
            trayStyle.padding = 8;
            trayItemStyle = new Style();
            trayItemStyle.fontSize = 11;
            trayItemStyle.backgroundAlpha = 0.1;
            trayItemStyle.backgroundColor = 16777215;
            trayItemStyle.borderWidth = 2;
            trayItemStyle.gradient = true;
            chromelessStyle = new Style();
            chromelessStyle.background = false;
            chromelessStyle.border = false;
            chromelessStyle.font = "Myriad Web Bold";
            chromelessStyle.buttonFontSize = 14;
            chromelessStyle.gradient = false;
            chromelessStyle.buttonTextColor = 16772096;
            chromelessStyle.embedFonts = true;
            chromelessStyle.padding = 0;
            chromelessStyle.inactiveTextColor = 6684723;
            dialogueStyle = new Style();
            dialogueStyle.bgGradient = true;
            dialogueStyle.bgGradientColors = [3355443,0];
            dialogueStyle.borderColor = 6710886;
            dialogueStyle.borderWidth = 2;
            dialogueStyle.maskColor = 0;
            dialogueStyle.maskAlpha = 0.25;
            dialogueStyle.round = 0;
            dialogueStyle.textColor = 10066329;
            dialogueStyle.highlightTextColor = 16777215;
            dialogueStyle.titleColor = 13421772;
            dialogueStyle.buttonColor = 10027161;
            dialogueStyle.buttonTextColor = 16777215;
            dialogueStyle.inputColorA = 0;
            dialogueStyle.inputColorB = 3355443;
            dialogueStyle.font = "Myriad Web";
            dialogueStyle.titleFont = "Myriad Web Bold";
            dialogueStyle.buttonFont = "Myriad Web Bold";
            dialogueStyle.fontSize = 14;
            dialogueStyle.titleFontSize = 20;
            dialogueStyle.embedFonts = true;
            dialogueStyle.haloColor = 16750848;
            promptStyle = new Style();
            promptStyle.backgroundColor = 0;
            promptStyle.backgroundAlpha = 0.2;
            promptStyle.borderWidth = 2;
            promptStyle.linkColor = 16746734;
            promptStyle.textColor = promptStyle.inverseTextColor = promptStyle.inactiveTextColor = promptStyle.unselectedTextColor = 13421772;
            promptStyle.fontSize = 10;
            promptStyle.font = "_sans";
            previewStyle = new Style();
            setPreviewDefaults();
         }
      }
      
      public static function setPreviewDefaults() : void
      {
         previewStyle.backgroundColor = 3355443;
         previewStyle.borderColor = 16777215;
         previewStyle.highlightTextColor = 16777215;
         previewStyle.borderWidth = 6;
         previewStyle.textColor = -1;
         previewStyle.linkColor = -1;
      }
   }
}

