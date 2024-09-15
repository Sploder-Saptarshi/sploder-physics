package com.sploder.builder.ui
{
   import com.sploder.asui.Component;
   import com.sploder.asui.HTMLField;
   import com.sploder.builder.Creator;
   import com.sploder.builder.Styles;
   import flash.events.Event;
   
   public class DialogueAlert extends Dialogue
   {
      protected var _message:HTMLField;
      
      public function DialogueAlert(param1:Creator, param2:int = 300, param3:int = 150, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["OK"];
         super.create();
         dbox.contentPadding = 35;
         _creator.ui.uiContainer.addChild(dbox);
         dbox.addButtonListener(Component.EVENT_CLICK,this.onClick);
         this._message = new HTMLField(null,"<h1><p align=\"center\">Are you sure you want to do this?</p></h1>",dbox.width - 70,true,null,Styles.dialogueStyle.clone({"titleColor":10066329}));
         dbox.contentCell.addChild(this._message);
         hide();
      }
      
      override protected function onClick(param1:Event) : void
      {
         super.onClick(param1);
         switch(param1.target)
         {
            case dbox.buttons[0]:
               hide();
         }
      }
      
      public function alert(param1:String = "") : void
      {
         if(param1.length)
         {
            this._message.value = "<h1><p align=\"center\">" + param1 + "</p></h1>";
         }
         show();
      }
   }
}

