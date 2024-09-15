package com.sploder.builder.ui
{
   import com.sploder.asui.Component;
   import com.sploder.asui.HTMLField;
   import com.sploder.builder.Creator;
   import com.sploder.builder.Styles;
   import flash.events.Event;
   
   public class DialogueConfirm extends Dialogue
   {
      protected var _callback:Function;
      
      protected var _callbackObject:Object;
      
      protected var _callbackArgs:Array;
      
      protected var _message:HTMLField;
      
      public function DialogueConfirm(param1:Creator, param2:int = 300, param3:int = 150, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["CANCEL","OK"];
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
               break;
            case dbox.buttons[1]:
               this.applyChanges();
               hide();
         }
      }
      
      public function confirm(param1:Object, param2:Function, param3:Array = null, param4:String = "") : void
      {
         this._callback = param2;
         this._callbackObject = param1;
         this._callbackArgs = param3;
         if(param4.length)
         {
            this._message.value = "<h1><p align=\"center\">" + param4 + "</p></h1>";
         }
         show();
      }
      
      override protected function applyChanges() : void
      {
         if(this._callback != null)
         {
            this._callback.apply(this._callbackObject,this._callbackArgs);
         }
      }
   }
}

