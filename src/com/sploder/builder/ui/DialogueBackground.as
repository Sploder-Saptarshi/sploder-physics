package com.sploder.builder.ui
{
   import com.sploder.asui.Cell;
   import com.sploder.asui.ColorPicker;
   import com.sploder.asui.ComboBox;
   import com.sploder.asui.Component;
   import com.sploder.asui.HTMLField;
   import com.sploder.asui.Position;
   import com.sploder.asui.Style;
   import com.sploder.builder.Creator;
   import com.sploder.builder.Styles;
   import com.sploder.builder.model.Environment;
   import com.sploder.game.effect.BackgroundEffect;
   import flash.events.Event;
   
   public class DialogueBackground extends Dialogue
   {
      private var bgColorTop:ColorPicker;
      
      private var bgColorBottom:ColorPicker;
      
      private var previewStyle:Style;
      
      private var preview:Cell;
      
      private var effect:BackgroundEffect;
      
      private var effectChooser:ComboBox;
      
      public function DialogueBackground(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["Cancel","Reset","Apply"];
         super.create();
         dbox.contentPadding = 35;
         _creator.ui.uiContainer.addChild(dbox);
         dbox.addButtonListener(Component.EVENT_CLICK,this.onClick);
         this.hide();
      }
      
      public function createContent() : void
      {
         if(_contentCreated)
         {
            return;
         }
         this.previewStyle = new Style();
         this.previewStyle.gradient = true;
         this.previewStyle.bgGradient = true;
         this.previewStyle.bgGradientColors = [13260,39423];
         this.previewStyle.borderWidth = 2;
         this.preview = new Cell(null,300,230,true,true,0,Styles.floatPosition.clone({
            "margin_top":15,
            "margin_right":40
         }),this.previewStyle);
         dbox.contentCell.addChild(this.preview);
         var _loc1_:Cell = new Cell(null,160,230,false,false,0,Styles.floatPosition);
         dbox.contentCell.addChild(_loc1_);
         this.bgColorTop = new ColorPicker(null,13260,110,"Top Color",new Position({"margin_bottom":20}),Styles.dialogueStyle);
         this.bgColorTop.showColorWheelOnly = true;
         this.bgColorTop.dimColorWheel = false;
         _loc1_.addChild(this.bgColorTop);
         this.bgColorTop.addEventListener(Component.EVENT_CHANGE,this.onChange);
         this.bgColorBottom = new ColorPicker(null,52479,110,"Bottom Color",null,Styles.dialogueStyle);
         this.bgColorBottom.showColorWheelOnly = true;
         this.bgColorBottom.dimColorWheel = false;
         _loc1_.addChild(this.bgColorBottom);
         this.bgColorBottom.addEventListener(Component.EVENT_CHANGE,this.onChange);
         this.effect = new BackgroundEffect(300,230);
         this.preview.mc.addChild(this.effect);
         dbox.contentCell.addChild(new Cell(null,300,25));
         var _loc2_:HTMLField = new HTMLField(null,"<p align=\"right\">Background Effect:</p>",176,false,Styles.floatPosition.clone({
            "margin_top":3,
            "margin_right":10
         }),Styles.dialogueStyle);
         dbox.contentCell.addChild(_loc2_);
         this.effectChooser = new ComboBox(null,"",[Environment.EFFECT_NONE,Environment.EFFECT_SNOW,Environment.EFFECT_RAIN,Environment.EFFECT_CLOUDS,Environment.EFFECT_STARS,Environment.EFFECT_SILK,Environment.EFFECT_LEAFY,Environment.EFFECT_SMOKE,Environment.EFFECT_GRID],0,"",120,Styles.floatPosition,Styles.dialogueStyle);
         this.effectChooser.dropDownPosition = Position.POSITION_ABOVE;
         dbox.contentCell.addChild(this.effectChooser);
         this.effectChooser.addEventListener(Component.EVENT_CHANGE,this.onChange);
         _contentCreated = true;
      }
      
      protected function onChange(param1:Event) : void
      {
         switch(param1.target)
         {
            case this.effectChooser:
               this.effect.type = this.effectChooser.value;
               break;
            case this.bgColorTop:
            case this.bgColorBottom:
               this.updatePreview();
         }
      }
      
      protected function updatePreview() : void
      {
         this.previewStyle.bgGradientColors[0] = this.bgColorTop.color;
         this.previewStyle.bgGradientColors[1] = this.bgColorBottom.color;
         this.preview.resizeCell(300,230);
      }
      
      override protected function onClick(param1:Event) : void
      {
         super.onClick(param1);
         switch(param1.target)
         {
            case dbox.buttons[0]:
               this.getSettings();
               this.hide();
               break;
            case dbox.buttons[1]:
               this.getSettings();
               break;
            case dbox.buttons[2]:
               this.applyChanges();
               this.hide();
         }
      }
      
      override protected function getSettings() : void
      {
         this.bgColorTop.color = _creator.environment.bgColorTop;
         this.bgColorBottom.color = _creator.environment.bgColorBottom;
         this.effectChooser.select(this.effectChooser.choices.indexOf(_creator.environment.bgEffect));
         this.updatePreview();
      }
      
      override protected function applyChanges() : void
      {
         _creator.environment.bgColorTop = this.bgColorTop.color;
         _creator.environment.bgColorBottom = this.bgColorBottom.color;
         _creator.environment.bgEffect = this.effect.type;
      }
      
      override public function show() : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         super.show();
         this.preview.mc.addChild(this.effect);
      }
      
      override public function hide() : void
      {
         super.hide();
         if(Boolean(this.effect) && Boolean(this.effect.parent))
         {
            this.effect.parent.removeChild(this.effect);
         }
      }
   }
}

