package com.sploder.game
{
   import com.sploder.builder.model.Environment;
   import com.sploder.builder.model.Model;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.Timer;
   import flash.xml.XMLNode;
   
   public class GameLevel
   {
      public static var gameEngine:Simulation;
      
      public static var lostLifeTime:int;
      
      public static var forceTurbo:Boolean = false;
      
      public var turbo:Boolean = false;
      
      protected var _levelNum:uint = 1;
      
      protected var _isFirstLevel:Boolean = false;
      
      protected var _game:Game;
      
      protected var _container:Sprite;
      
      protected var _simulation:Simulation;
      
      protected var _levelNode:XMLNode;
      
      protected var _envData:String;
      
      protected var _newLifeTimer:Timer;
      
      protected var _started:Boolean = false;
      
      protected var _running:Boolean = false;
      
      protected var _exiting:Boolean = false;
      
      protected var _exitTimer:Timer;
      
      protected var _model:Model;
      
      protected var _environment:Environment;
      
      protected var _modelContainer:Sprite;
      
      public function GameLevel(param1:Game, param2:Sprite, param3:uint = 1, param4:Boolean = false)
      {
         super();
         this.init(param1,param2,param3,param4);
      }
      
      public static function initialize() : void
      {
      }
      
      public function get levelNum() : uint
      {
         return this._levelNum;
      }
      
      public function get game() : Game
      {
         return this._game;
      }
      
      public function get simulation() : Simulation
      {
         return this._simulation;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function get model() : Model
      {
         return this._model;
      }
      
      public function get environment() : Environment
      {
         return this._environment;
      }
      
      protected function init(param1:Game, param2:Sprite, param3:uint = 1, param4:Boolean = false) : void
      {
         this._game = param1;
         this._container = param2;
         this._levelNum = param3;
         this._isFirstLevel = param4;
      }
      
      public function buildGame(param1:Event = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc4_:ContextMenu = null;
         var _loc6_:ContextMenuItem = null;
         this._levelNode = this._game.gameXML.firstChild.firstChild.childNodes[this._levelNum - 1];
         this._envData = String(this._levelNode.attributes.env);
         this._modelContainer = new Sprite();
         this._model = new Model(this._modelContainer,640,480);
         this._environment = new Environment();
         this._environment.fromString(this._envData);
         if(this._environment.size != Environment.SIZE_NORMAL)
         {
            this._model.resize(1280,960);
         }
         this._model.fromString(this._levelNode.firstChild.nodeValue);
         Main.mainStage.scaleMode = StageScaleMode.NO_SCALE;
         Game.library.cleanTextureQueue();
         var _loc3_:Boolean = forceTurbo || Boolean(this._game.gameXML) && this._game.gameXML.firstChild.attributes.turbo == "1";
         this.turbo = _loc3_;
         if(!_loc3_)
         {
            _loc4_ = new ContextMenu();
            _loc6_ = new ContextMenuItem("Play in FAST DISPLAY mode...",true,true,true);
            _loc6_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onFastDisplaySelect,false,0,true);
            _loc4_.customItems.push(_loc6_);
         }
         else
         {
            _loc4_ = new ContextMenu();
         }
         this._container.contextMenu = _loc4_;
         EventHandler.levelNum = this._levelNum;
         this._simulation = new Simulation(this._container,this._model,this._environment,_loc3_);
         this._simulation.build();
         this._simulation.view.zSort();
         this._simulation.events.addEventListener(States.ACTION_ENDGAME,this.onGameObjectiveComplete,false,0,true);
         Main.preloader.hide();
         this._game.removeLevelScreen();
         this._game.updateConsole();
         if(this._simulation.viewUI.helpButton)
         {
            this._simulation.viewUI.helpButton.addEventListener(MouseEvent.CLICK,this.onHelpButtonClicked,false,0,true);
         }
         if(this._simulation.viewUI.retryButton)
         {
            this._simulation.viewUI.retryButton.addEventListener(MouseEvent.CLICK,this.onRetryButtonClicked,false,0,true);
         }
         var _loc5_:Boolean = Boolean(this._game.gameXML) && this._game.gameXML.firstChild.attributes.allowcopying == "1";
         if(_loc5_)
         {
            this._simulation.viewUI.allowCopying();
         }
         if(!this._isFirstLevel)
         {
            Game.console.showTitleScreen();
         }
      }
      
      public function rebuildGame() : void
      {
         this.populateGame();
      }
      
      protected function populateGame() : void
      {
         this._simulation.build();
         this._game.onLevelLoaded();
      }
      
      protected function onGameObjectiveComplete(param1:Event) : void
      {
         this.exitIfComplete();
      }
      
      protected function onFastDisplaySelect(param1:Event) : void
      {
         forceTurbo = true;
         Game.restartGame();
      }
      
      public function start() : void
      {
         this._container.focusRect = false;
         Game.mainStage.focus = this._container;
         if(this._simulation)
         {
            this._simulation.start();
            this._started = true;
            this._running = true;
         }
      }
      
      public function stop() : void
      {
         if(this._simulation)
         {
            this._simulation.stop();
            this._running = false;
         }
         Game.mainStage.quality = StageQuality.HIGH;
      }
      
      public function pause() : void
      {
         if(this._started && !this._exiting && Boolean(this._simulation))
         {
            this._simulation.stop();
            this._running = false;
         }
      }
      
      public function resume() : void
      {
         if(this._started && !this._exiting && Boolean(this._simulation))
         {
            this._simulation.start();
            this._running = true;
         }
      }
      
      protected function onHelpButtonClicked(param1:MouseEvent) : void
      {
         if(this._started && !this._exiting)
         {
            this.pause();
            Game.console.hidePauseScreen();
            Game.console.hideRetryScreen();
            Game.console.showTitleScreen();
         }
      }
      
      protected function onRetryButtonClicked(param1:MouseEvent) : void
      {
         if(this._started && !this._exiting)
         {
            this.pause();
            Game.console.hidePauseScreen();
            Game.console.hideTitleScreen();
            Game.console.showRetryScreen();
         }
      }
      
      public function exitIfComplete() : void
      {
         if(!this._exiting && this._simulation && Boolean(this._simulation.events))
         {
            Game.totalTime = EventHandler.totalTime;
            if(!this._simulation.events.won)
            {
               Game.console.finishGame(false);
            }
            else if(this._levelNum == Game.totalLevels)
            {
               Game.console.finishGame(true);
            }
            else
            {
               this._exiting = true;
               this._exitTimer = new Timer(2000,1);
               this._exitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onExitTimerComplete,false,0,true);
               this._exitTimer.start();
            }
         }
      }
      
      protected function onExitTimerComplete(param1:TimerEvent) : void
      {
         this._exitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onExitTimerComplete);
         this._game.nextLevel();
      }
      
      public function end() : void
      {
         Game.mainStage.quality = StageQuality.HIGH;
         if(this._exitTimer)
         {
            this._exitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onExitTimerComplete);
            if(this._exitTimer.running)
            {
               this._exitTimer.stop();
            }
            this._exitTimer = null;
         }
         if(this._simulation)
         {
            if(this._simulation.events)
            {
               this._simulation.events.removeEventListener(States.ACTION_ENDGAME,this.onGameObjectiveComplete);
            }
            if(this._simulation.viewUI)
            {
               if(this._simulation.viewUI.helpButton)
               {
                  this._simulation.viewUI.helpButton.removeEventListener(MouseEvent.CLICK,this.onHelpButtonClicked);
               }
               if(this._simulation.viewUI.retryButton)
               {
                  this._simulation.viewUI.retryButton.removeEventListener(MouseEvent.CLICK,this.onRetryButtonClicked);
               }
            }
            this._simulation.end();
            this._simulation = null;
            gameEngine = null;
         }
         this._model.end();
         this._model = null;
         this._modelContainer = null;
         this._container = null;
         this._environment = null;
      }
   }
}

