package com.sploder.builder.ui
{
   import com.sploder.asui.Component;
   import com.sploder.asui.FormField;
   import com.sploder.asui.HTMLField;
   import com.sploder.asui.Style;
   import com.sploder.builder.Creator;
   import com.sploder.builder.Styles;
   import flash.events.Event;
   import flash.system.System;
   
   public class DialogueClipboard extends Dialogue
   {
      private var warningText:HTMLField;
      
      protected var _clipboard:String = "";
      
      protected var _clipboardField:FormField;
      
      public function DialogueClipboard(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["Cancel","Clear","Copy to Clipboard","Paste with Layers","Paste into Layer"];
         super.create();
         dbox.contentPadding = 20;
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
         var _loc1_:HTMLField = new HTMLField(null,"Clipboard Contents (Copy: CTRL-C, Paste: CTRL-V) <a class=\"litelink\" href=\"event:showtag\">(?)</a>:",NaN,false,null,Styles.dialogueStyle);
         _loc1_.alt = "You can copy the contents of your clipboard and share it with others! Select objects in your game and press CTRL-C to copy them. To put objects into your game, click the text area below and press CTRL-V!";
         dbox.contentCell.addChild(_loc1_);
         var _loc2_:Style = Styles.dialogueStyle.clone();
         _loc2_.font = "_sans";
         _loc2_.fontSize = 11;
         _loc2_.textColor = 65535;
         _loc2_.embedFonts = false;
         this._clipboardField = new FormField(null,"",520,100,true,null,_loc2_);
         this._clipboardField.addEventListener(Component.EVENT_CLICK,this.onClick);
         dbox.contentCell.addChild(this._clipboardField);
         this._clipboardField.editable = true;
         this._clipboardField.restrict = "0123456789.,#?%$|:;\\-";
         this._clipboardField.selectable = true;
         this.warningText = new HTMLField(null,"<font color=\"#ffcc00\">Select objects in your game if you wish to copy them, otherwise paste in your data.</font>",NaN,false,null,Styles.dialogueStyle);
         dbox.contentCell.addChild(this.warningText);
         _contentCreated = true;
      }
      
      override protected function onClick(param1:Event) : void
      {
         super.onClick(param1);
         switch(param1.target)
         {
            case this._clipboardField:
               this._clipboardField.focus();
               break;
            case dbox.buttons[0]:
               hide();
               break;
            case dbox.buttons[1]:
               this._clipboardField.value = "";
               break;
            case dbox.buttons[2]:
               System.setClipboard(this._clipboard);
               hide();
               break;
            case dbox.buttons[3]:
               this.paste(true);
               hide();
               break;
            case dbox.buttons[4]:
               this.paste(false);
               hide();
         }
      }
      
      override protected function getSettings() : void
      {
         this._clipboard = _creator.modelController.clipboard;
         this._clipboardField.value = this._clipboard;
      }
      
      protected function paste(param1:Boolean = false) : void
      {
         this._clipboard = this._clipboardField.value;
         _creator.modelController.clipboard = this._clipboard;
         _creator.uiController.paste(false,"",param1);
      }
      
      override public function show() : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         this._clipboardField.focus();
         super.show();
         if(this.warningText)
         {
            if(this._clipboardField.text.length)
            {
               this.warningText.hide();
            }
            else
            {
               this.warningText.show();
            }
         }
      }
   }
}

