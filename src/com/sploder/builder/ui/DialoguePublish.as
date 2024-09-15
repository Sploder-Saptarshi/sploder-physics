package com.sploder.builder.ui
{
   import com.sploder.asui.Cell;
   import com.sploder.asui.CheckBox;
   import com.sploder.asui.Component;
   import com.sploder.builder.Creator;
   import com.sploder.builder.Styles;
   import flash.events.Event;
   
   public class DialoguePublish extends Dialogue
   {
      protected var _comments:CheckBox;
      
      protected var _isprivate:CheckBox;
      
      protected var _turbo:CheckBox;
      
      private var _allowcopying:CheckBox;
      
      public function DialoguePublish(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["Cancel","Publish"];
         super.create();
         dbox.contentPadding = 100;
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
         this._comments = new CheckBox(null,"Allow Comments","comments",false,140,30,"",Styles.floatPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this._comments);
         this._isprivate = new CheckBox(null,"Keep Private","comments",false,140,30,"",Styles.floatPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this._isprivate);
         this._turbo = new CheckBox(null,"Turn off smoothing (fast mode)","true",false,290,30,"",Styles.floatPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this._turbo);
         this._allowcopying = new CheckBox(null,"Allow copying <a class=\"litelink\" href=\"event:showtag\">(?)</a>","true",false,290,30,"",Styles.floatPosition,Styles.dialogueStyle);
         this._allowcopying.alt = "Check this box to allow others to copy your game levels to learn from and adapt to their own games";
         dbox.contentCell.addChild(this._allowcopying);
         _contentCreated = true;
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
               _creator.project.publishProject();
               hide();
         }
      }
      
      override protected function getSettings() : void
      {
         this._comments.checked = _creator.project.comments;
         this._isprivate.checked = _creator.project.isprivate;
         this._turbo.checked = _creator.project.turbo;
         this._allowcopying.checked = _creator.project.allowcopying;
      }
      
      override protected function applyChanges() : void
      {
         _creator.project.comments = this._comments.checked;
         _creator.project.isprivate = this._isprivate.checked;
         _creator.project.turbo = this._turbo.checked;
         _creator.project.allowcopying = this._allowcopying.checked;
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

