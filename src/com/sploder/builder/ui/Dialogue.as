package com.sploder.builder.ui
{
   import com.sploder.asui.Component;
   import com.sploder.asui.DialogueBox;
   import com.sploder.builder.Creator;
   import com.sploder.builder.CreatorUI;
   import com.sploder.builder.Styles;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Dialogue extends EventDispatcher
   {
      public static var currentDialogue:Dialogue;
      
      protected var _creator:Creator;
      
      protected var _width:int;
      
      protected var _height:int;
      
      protected var _title:String = "";
      
      protected var _buttons:Array;
      
      public var scroll:Boolean = false;
      
      public var round:Number = 0;
      
      public var contentPadding:int = 20;
      
      protected var _contentCreated:Boolean = false;
      
      public var dbox:DialogueBox;
      
      public function Dialogue(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super();
         this.init(param1,param2,param3,param4,param5);
      }
      
      protected function init(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null) : void
      {
         this._creator = param1;
         this._width = param2;
         this._height = param3;
         this._title = param4;
         if(param5)
         {
            this._buttons = param5;
         }
         else
         {
            this._buttons = ["CANCEL","APPLY"];
         }
      }
      
      public function create() : void
      {
         this.dbox = new DialogueBox(null,this._width,this._height,this._title,this._buttons,this.scroll,this.round,Styles.dialoguePosition,Styles.dialogueStyle);
         this.dbox.contentPadding = this.contentPadding;
         this.dbox.contentBottomMargin = 40;
      }
      
      protected function getSettings() : void
      {
      }
      
      protected function applyChanges() : void
      {
      }
      
      protected function onClick(param1:Event) : void
      {
      }
      
      public function show() : void
      {
         if(currentDialogue)
         {
            currentDialogue.hide();
         }
         currentDialogue = this;
         this.getSettings();
         this.dbox.show();
         if(this._creator.uiController)
         {
            this._creator.uiController.keyboardEnabled = false;
         }
      }
      
      public function hide() : void
      {
         this.dbox.hide();
         if(this._creator.uiController)
         {
            this._creator.uiController.keyboardEnabled = true;
         }
         CreatorUI.stage.focus = Component.mainStage;
      }
   }
}

