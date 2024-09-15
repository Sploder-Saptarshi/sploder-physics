package com.sploder.builder.ui
{
   import com.sploder.asui.Cell;
   import com.sploder.asui.Component;
   import com.sploder.asui.HTMLField;
   import com.sploder.builder.Creator;
   import com.sploder.builder.Styles;
   import flash.events.Event;
   
   public class DialoguePublishComplete extends Dialogue
   {
      protected var _message:HTMLField;
      
      public function DialoguePublishComplete(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["Get Embed Code","Play Again","Done"];
         super.create();
         dbox.contentPadding = 35;
         _creator.ui.uiContainer.addChild(dbox);
         dbox.addButtonListener(Component.EVENT_CLICK,this.onClick);
         hide();
      }
      
      public function createContent() : void
      {
         if(_contentCreated)
         {
            return;
         }
         dbox.contentCell.addChild(new Cell(null,NaN,10));
         this._message = new HTMLField(null,"<h1><p align=\"center\">Your game is now saving to the server...</p></h1>",dbox.width - 70,true,null,Styles.dialogueStyle.clone({"titleColor":10066329}));
         dbox.contentCell.addChild(this._message);
         _contentCreated = true;
      }
      
      override protected function onClick(param1:Event) : void
      {
         super.onClick(param1);
         switch(param1.target)
         {
            case dbox.buttons[0]:
               _creator.ui.ddEmbed.show();
               hide();
               break;
            case dbox.buttons[1]:
               _creator.project.playPubMovie();
               break;
            case dbox.buttons[2]:
               _creator.project.saveProject();
               hide();
         }
      }
      
      override protected function getSettings() : void
      {
      }
      
      override protected function applyChanges() : void
      {
      }
      
      public function alert(param1:String = "") : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         if(param1.length)
         {
            this._message.value = "<h1><p align=\"center\">" + param1 + "</p></h1>";
         }
         this.show();
      }
      
      override public function show() : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         super.show();
      }
   }
}

