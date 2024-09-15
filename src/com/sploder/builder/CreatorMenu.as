package com.sploder.builder
{
   import com.sploder.asui.BButton;
   import com.sploder.asui.Component;
   import com.sploder.builder.ui.DialogueFileManager;
   import flash.events.Event;
   
   public class CreatorMenu
   {
      protected var _creator:Creator;
      
      protected var _saveToggle:BButton;
      
      protected var _saveAsToggle:BButton;
      
      protected var _publishToggle:BButton;
      
      public function CreatorMenu(param1:Creator)
      {
         super();
         this.init(param1);
      }
      
      public function get saveEnabled() : Boolean
      {
         return this._saveAsToggle.enabled;
      }
      
      public function set saveEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            this._saveToggle.enable();
         }
         else
         {
            this._saveToggle.disable();
         }
      }
      
      public function get saveAsEnabled() : Boolean
      {
         return this._saveAsToggle.enabled;
      }
      
      public function set saveAsEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            this._saveAsToggle.enable();
         }
         else
         {
            this._saveAsToggle.disable();
         }
      }
      
      public function get publishEnabled() : Boolean
      {
         return this._publishToggle.enabled;
      }
      
      public function set publishEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            this._publishToggle.enable();
         }
         else
         {
            this._publishToggle.disable();
         }
      }
      
      protected function init(param1:Creator) : void
      {
         this._creator = param1;
         var _loc2_:Array = this._creator.ui.menu.childNodes;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] is BButton)
            {
               switch(_loc2_[_loc3_].value)
               {
                  case "New":
                  case "Load":
                     break;
                  case "Save":
                     this._saveToggle = _loc2_[_loc3_];
                     break;
                  case "Save As":
                     this._saveAsToggle = _loc2_[_loc3_];
                     break;
                  case "Test":
                     break;
                  case "Publish":
                     this._publishToggle = _loc2_[_loc3_];
               }
               BButton(_loc2_[_loc3_]).addEventListener(Component.EVENT_CLICK,this.onClick);
            }
            _loc3_++;
         }
      }
      
      protected function onClick(param1:Event) : void
      {
         var _loc2_:String = param1.target.value;
         if(param1.target.name == "btn")
         {
            _loc2_ = param1.target.parent.name;
         }
         this._creator.project.savingAs = false;
         switch(_loc2_)
         {
            case "New":
               this.requestNewProject();
               break;
            case "Load":
               this.requestLoadProject();
               break;
            case "Save":
               if(this.saveEnabled)
               {
                  this._creator.project.saveProject();
               }
               break;
            case "Save As":
               this._creator.project.savingAs = true;
               if(this.saveAsEnabled)
               {
                  this._creator.project.saveProjectAs();
               }
               break;
            case "Test":
               this._creator.project.testProject();
               break;
            case "Publish":
               if(this.publishEnabled)
               {
                  this._creator.project.publishGame();
               }
         }
      }
      
      protected function requestNewProject() : void
      {
         if(this._creator.model.objects.length > 0)
         {
            this._creator.uiController.confirm(this._creator.project,this._creator.project.newProject,null,"Creating a new game will erase any unsaved game you are working on.");
         }
         else
         {
            this._creator.project.newProject();
         }
      }
      
      protected function requestLoadProject() : void
      {
         this._creator.ui.ddManager.title = "Load a Game";
         this._creator.ui.ddManager.mode = DialogueFileManager.MODE_LOAD;
         if(!this._creator.demo && this._creator.model.objects.length > 0)
         {
            this._creator.uiController.confirm(this._creator.ui.ddManager,this._creator.ui.ddManager.loadList,null,"Loading an existing game will erase any unsaved game you are working on.");
         }
         else
         {
            this._creator.ui.ddManager.loadList();
         }
      }
   }
}

