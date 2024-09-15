package com.sploder.builder.ui
{
   import com.sploder.asui.Cell;
   import com.sploder.asui.Clip;
   import com.sploder.asui.Component;
   import com.sploder.builder.Creator;
   import com.sploder.builder.CreatorUIStates;
   import flash.events.Event;
   
   public class DialogueWelcome extends Dialogue
   {
      protected var _logo:Clip;
      
      public function DialogueWelcome(param1:Creator, param2:int = 300, param3:int = 150, param4:String = "Welcome to Sploder\'s", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["Take a Tour","Skip Tour"];
         super.create();
         dbox.contentPadding = 60;
         _creator.ui.uiContainer.addChild(dbox);
         dbox.addButtonListener(Component.EVENT_CLICK,this.onClick);
         dbox.contentCell.addChild(new Cell(null,NaN,20));
         this._logo = new Clip(null,CreatorUIStates.ICON_CREATOR_LOGO);
         dbox.contentCell.addChild(this._logo);
         hide();
      }
      
      override protected function onClick(param1:Event) : void
      {
         super.onClick(param1);
         switch(param1.target)
         {
            case dbox.buttons[0]:
               _creator.showTour();
               hide();
               break;
            case dbox.buttons[1]:
               hide();
               _creator.onWelcomeClosed();
         }
      }
   }
}

