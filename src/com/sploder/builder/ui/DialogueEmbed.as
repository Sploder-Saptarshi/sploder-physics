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
   
   public class DialogueEmbed extends Dialogue
   {
      protected var _embed:String = "";
      
      protected var _embedField:FormField;
      
      public function DialogueEmbed(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
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
         dbox.contentCell.addChild(new HTMLField(null,"Embed Code:",NaN,false,null,Styles.dialogueStyle));
         var _loc1_:Style = Styles.dialogueStyle.clone();
         _loc1_.font = "_sans";
         _loc1_.fontSize = 11;
         _loc1_.textColor = 65535;
         _loc1_.embedFonts = false;
         this._embedField = new FormField(null,"",NaN,100,true,null,_loc1_);
         this._embedField.addEventListener(Component.EVENT_CLICK,this.onClick);
         dbox.contentCell.addChild(this._embedField);
         _contentCreated = true;
      }
      
      override protected function onClick(param1:Event) : void
      {
         super.onClick(param1);
         switch(param1.target)
         {
            case this._embedField:
               this._embedField.focus();
               break;
            case dbox.buttons[0]:
               _creator.project.saveProject();
               hide();
               break;
            case dbox.buttons[1]:
               _creator.project.saveProject();
               this.applyChanges();
               hide();
         }
      }
      
      override protected function getSettings() : void
      {
         this._embed = "<div align=\"center\">" + "<embed type=\"application/x-shockwave-flash\" src=\"http://www.sploder.com/player3.php?s=" + _creator.project.pubkey + "\" id=\"splodergame\" base=\"http://www.sploder.com\" width=\"640\" height=\"480\" salign=\"tl\" scale=\"noscale\" >" + "</embed><br />" + "<a href=\"http://www.sploder.com\">Make Your Own Game for Free!</a>" + "</div>";
         this._embedField.value = this._embed;
      }
      
      override protected function applyChanges() : void
      {
         System.setClipboard(this._embed);
      }
      
      override public function show() : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         this._embedField.focus();
         super.show();
      }
   }
}

