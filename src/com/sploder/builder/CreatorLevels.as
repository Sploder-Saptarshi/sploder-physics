package com.sploder.builder
{
   import com.sploder.asui.Component;
   import com.sploder.builder.model.ModelObjectSprite;
   import flash.events.Event;
   
   public class CreatorLevels
   {
      protected var _creator:Creator;
      
      protected var _currentLevel:uint = 0;
      
      protected var _levelData:Array;
      
      protected var _levelEnv:Array;
      
      protected var _defaultNum:uint;
      
      public function CreatorLevels(param1:Creator)
      {
         super();
         this.init(param1);
      }
      
      public function get currentLevel() : uint
      {
         return this._currentLevel;
      }
      
      public function get currentLevelName() : String
      {
         return "Level " + (this._currentLevel + 1);
      }
      
      public function get totalLevels() : uint
      {
         return this._levelData.length;
      }
      
      protected function init(param1:Creator) : void
      {
         this._creator = param1;
         this._levelData = [];
         this._levelEnv = [];
         this._creator.ui.levelSelector.addEventListener(Component.EVENT_CHANGE,this.changeLevel);
         this._creator.ui.addLevelButton.addEventListener(Component.EVENT_CLICK,this.addLevel);
         this._creator.ui.removeLevelButton.addEventListener(Component.EVENT_CLICK,this.removeLevel);
         this._creator.ui.removeLevelButton.disable();
         this._creator.ui.moveLevelButton.addEventListener(Component.EVENT_CLICK,this.moveLevel);
         this._creator.project.addEventListener(CreatorProject.EVENT_LOAD,this.onProjectLoaded);
         this._creator.project.addEventListener(CreatorProject.EVENT_NEW,this.reset);
      }
      
      public function loadCurrentLevel() : void
      {
         if(this._creator.model)
         {
            this._creator.model.clear();
            this._creator.modelController.history.clear();
            if(ModelObjectSprite.library != null)
            {
               ModelObjectSprite.library.cleanTextureQueue();
            }
            this._creator.model.fromString(this.exportLevelData(this._currentLevel));
         }
      }
      
      public function loadCurrentEnvironment() : void
      {
         if(this._creator.environment)
         {
            this._creator.environment.setDefaults();
            this._creator.environment.fromString(this.exportEnvironmentData(this._currentLevel));
         }
      }
      
      public function saveCurrentLevel() : void
      {
         this._levelData[this._currentLevel] = this._creator.model.toString();
      }
      
      public function saveCurrentEnvironment() : void
      {
         this._levelEnv[this._currentLevel] = this._creator.environment.toString();
      }
      
      public function clearCurrentLevel() : void
      {
         this._levelData[this._currentLevel] = "";
      }
      
      public function clearCurrentEnvironment() : void
      {
         this._levelEnv[this._currentLevel] = "";
      }
      
      public function reset(param1:Event = null) : void
      {
         this._creator.ui.levelSelector.removeEventListener(Component.EVENT_CHANGE,this.changeLevel);
         this._levelData = [];
         this._levelData.push("");
         this._currentLevel = 0;
         this._creator.ui.levelSelector.choices = ["Level 1"];
         this._creator.ui.addLevelButton.enable();
         this._creator.ui.removeLevelButton.disable();
         this._creator.ui.moveLevelButton.disable();
         this._creator.environment.setDefaults();
         this._levelEnv = [];
         this._levelEnv.push(this._creator.environment.toString());
         this.loadCurrentLevel();
         this.loadCurrentEnvironment();
         this._creator.ui.levelSelector.addEventListener(Component.EVENT_CHANGE,this.changeLevel);
      }
      
      protected function onProjectLoaded(param1:Event) : void
      {
         this._creator.ui.levelSelector.removeEventListener(Component.EVENT_CHANGE,this.changeLevel);
         this._levelData = [];
         this._levelEnv = [];
         this._currentLevel = 0;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this._creator.project.getTotalLevels())
         {
            this.importLevelData(_loc3_);
            this.importEnvironmentData(_loc3_);
            _loc2_.push("Level " + (_loc3_ + 1));
            _loc3_++;
         }
         this._creator.ui.levelSelector.choices = _loc2_;
         this._creator.ui.levelSelector.select(0);
         if(this._levelData.length > 1)
         {
            this._creator.ui.removeLevelButton.enable();
         }
         else
         {
            this._creator.ui.removeLevelButton.disable();
         }
         if(this._levelData.length < 9)
         {
            this._creator.ui.addLevelButton.enable();
         }
         else
         {
            this._creator.ui.addLevelButton.disable();
         }
         this._creator.ui.moveLevelButton.disable();
         this.loadCurrentLevel();
         this.loadCurrentEnvironment();
         this._creator.ui.levelSelector.addEventListener(Component.EVENT_CHANGE,this.changeLevel);
      }
      
      public function importLevelData(param1:int = -1) : void
      {
         if(param1 >= 0)
         {
            this._levelData[param1] = this._creator.project.getObjects(param1);
         }
      }
      
      public function importEnvironmentData(param1:int = -1) : void
      {
         if(param1 >= 0)
         {
            this._levelEnv[param1] = this._creator.project.getEnvironment(param1);
         }
      }
      
      public function exportLevelData(param1:int) : String
      {
         if(this._levelData.length > param1)
         {
            return this._levelData[param1];
         }
         return "";
      }
      
      public function exportEnvironmentData(param1:int) : String
      {
         if(this._levelEnv.length > param1)
         {
            return this._levelEnv[param1];
         }
         return "";
      }
      
      public function exportLevels() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this._levelData.length)
         {
            _loc1_.push(this.exportLevelData(_loc2_));
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function exportEnvironments() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this._levelEnv.length)
         {
            _loc1_.push(this.exportEnvironmentData(_loc2_));
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function exportGraphics() : Object
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc1_:Object = {};
         var _loc2_:int = 0;
         while(_loc2_ < this._levelData.length)
         {
            _loc3_ = this.exportLevelData(_loc2_).split("$");
            _loc4_ = String(_loc3_[0]).split("|");
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(Boolean(_loc4_[_loc5_]) && Boolean(String(_loc4_[_loc5_]).length))
               {
                  _loc6_ = _loc4_[_loc5_].split("#")[5].split(";");
                  if(parseInt(_loc6_[18]) > 0)
                  {
                     _loc7_ = parseInt(_loc6_[18]) + "_" + parseInt(_loc6_[19]);
                     _loc1_[_loc7_] = Textures.getOriginal(_loc7_);
                  }
               }
               _loc5_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function changeLevel(param1:Event) : void
      {
         var _loc2_:uint = 0;
         if(this._creator.ui.levelSelector != null)
         {
            if(this._creator.ui.levelSelector.value.length > 0)
            {
               _loc2_ = parseInt(this._creator.ui.levelSelector.value.split(" ")[1]) - 1;
               if(_loc2_ != this._currentLevel)
               {
                  this.saveCurrentLevel();
                  this.saveCurrentEnvironment();
                  this._currentLevel = _loc2_;
                  this.loadCurrentLevel();
                  this.loadCurrentEnvironment();
                  if(this._currentLevel == 0)
                  {
                     this._creator.ui.moveLevelButton.disable();
                  }
                  else
                  {
                     this._creator.ui.moveLevelButton.enable();
                  }
               }
            }
         }
      }
      
      protected function addLevel(param1:Event) : void
      {
         this.saveCurrentLevel();
         this.saveCurrentEnvironment();
         this._creator.ui.levelSelector.removeEventListener(Component.EVENT_CHANGE,this.changeLevel);
         var _loc2_:Array = this._creator.ui.levelSelector.choices.concat();
         _loc2_.push("Level " + (_loc2_.length + 1));
         this._creator.ui.levelSelector.choices = _loc2_;
         this._creator.ui.removeLevelButton.enable();
         if(_loc2_.length >= 9)
         {
            this._creator.ui.addLevelButton.disable();
         }
         this._levelData.push("");
         this._levelEnv.push("");
         this._currentLevel = this._levelData.length - 1;
         if(this._currentLevel == 0)
         {
            this._creator.ui.moveLevelButton.disable();
         }
         else
         {
            this._creator.ui.moveLevelButton.enable();
         }
         this.loadCurrentLevel();
         this.loadCurrentEnvironment();
         this._creator.ui.levelSelector.addEventListener(Component.EVENT_CHANGE,this.changeLevel);
         this._creator.uiController.notice("You just added a level to your game! You can switch between levels to edit them one at a time.");
      }
      
      protected function removeLevel(param1:Event) : void
      {
         this._creator.uiController.confirm(this,this.doRemoveLevel,null,"Removing this level will remove all of the contents of the level.");
      }
      
      public function doRemoveLevel() : void
      {
         this._creator.ui.levelSelector.removeEventListener(Component.EVENT_CHANGE,this.changeLevel);
         var _loc1_:Array = this._creator.ui.levelSelector.choices.concat();
         _loc1_.pop();
         this._creator.ui.levelSelector.choices = _loc1_;
         this._levelData.splice(this._currentLevel,1);
         this._levelEnv.splice(this._currentLevel,1);
         if(this._levelData.length > 1)
         {
            this._creator.ui.removeLevelButton.enable();
         }
         else
         {
            this._creator.ui.removeLevelButton.disable();
         }
         if(this._levelData.length < 9)
         {
            this._creator.ui.addLevelButton.enable();
         }
         this._currentLevel = Math.max(0,Math.min(this._currentLevel,this._levelData.length - 1));
         if(this._currentLevel == 0)
         {
            this._creator.ui.moveLevelButton.disable();
         }
         else
         {
            this._creator.ui.moveLevelButton.enable();
         }
         this.loadCurrentLevel();
         this.loadCurrentEnvironment();
         this._creator.ui.levelSelector.addEventListener(Component.EVENT_CHANGE,this.changeLevel);
      }
      
      protected function moveLevel(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this._currentLevel > 0)
         {
            this.saveCurrentLevel();
            _loc2_ = this._levelData[this._currentLevel - 1];
            this._levelData[this._currentLevel - 1] = this._levelData[this._currentLevel];
            this._levelData[this._currentLevel] = _loc2_;
            _loc3_ = this._levelEnv[this._currentLevel - 1];
            this._levelEnv[this._currentLevel - 1] = this._levelEnv[this._currentLevel];
            this._levelEnv[this._currentLevel] = _loc3_;
            --this._currentLevel;
            this._creator.ui.levelSelector.removeEventListener(Component.EVENT_CHANGE,this.changeLevel);
            this._creator.ui.levelSelector.select(this._currentLevel);
            this._creator.ui.levelSelector.addEventListener(Component.EVENT_CHANGE,this.changeLevel);
            this.loadCurrentLevel();
            this.loadCurrentEnvironment();
            this._creator.project.saveLocalProject();
         }
      }
   }
}

