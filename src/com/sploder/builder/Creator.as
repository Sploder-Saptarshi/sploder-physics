package com.sploder.builder
{
   import com.sploder.asui.Clip;
   import com.sploder.asui.Component;
   import com.sploder.asui.Library;
   import com.sploder.asui.Prompt;
   import com.sploder.builder.model.Environment;
   import com.sploder.builder.model.Model;
   import com.sploder.builder.model.ModelController;
   import com.sploder.builder.model.ModelGraphics;
   import com.sploder.data.*;
   import com.sploder.game.Simulation;
   import com.sploder.game.ViewUI;
   import com.sploder.game.sound.SoundManager;
   import com.sploder.util.Key;
   import com.sploder.util.Settings;
   import com.sploder.util.StringUtils;
   import flash.Boot;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import flash.xml.*;
   
   public class Creator extends EventDispatcher
   {
      protected static var _mainInstance:Creator;
      
      public static var gameLibrary:Library;
      
      public static var projectToLoad:String;
      
      public static const INITIALIZED:String = "creator_initialized";
      
      public static const GAME_VERSION:String = "5";
      
      public static var LibrarySWF:Class = Creator_LibrarySWF;
      
      protected var _main:CreatorMain;
      
      protected var _container:Sprite;
      
      protected var _solBucketName:String;
      
      public var resultXML:XML;
      
      public var gameMode:Number;
      
      public var todaysdate:Date;
      
      public var activedate:Date;
      
      public var today:String;
      
      public var todaycgi:String;
      
      public var activeday:String;
      
      public var activedaycgi:String;
      
      public var sessionExpired:Boolean = false;
      
      public var keepTimer:Timer;
      
      public var keepLoader:URLLoader;
      
      public var ui:CreatorUI;
      
      public var uiController:CreatorUIController;
      
      public var menuController:CreatorMenu;
      
      public var levels:CreatorLevels;
      
      public var model:Model;
      
      public var modelController:ModelController;
      
      public var environment:Environment;
      
      public var graphics:ModelGraphics;
      
      protected var _project:CreatorProject;
      
      private var debugmode:Boolean = false;
      
      public var betaMode:Boolean = false;
      
      public var demo:Boolean = false;
      
      public var local:Boolean = false;
      
      protected var _testSimulation:Simulation;
      
      protected var _testing:Boolean = false;
      
      public function Creator(param1:CreatorMain, param2:Sprite = null)
      {
         this._solBucketName = "creator" + GAME_VERSION;
         super();
         this.init(param1,param2);
      }
      
      public static function get mainInstance() : Creator
      {
         return _mainInstance;
      }
      
      public function get stage() : Stage
      {
         return this._container.stage;
      }
      
      public function get project() : CreatorProject
      {
         return this._project;
      }
      
      public function get testing() : Boolean
      {
         return this._testing;
      }
      
      protected function init(param1:CreatorMain, param2:Sprite = null) : void
      {
         this._main = param1;
         this._container = param2;
         _mainInstance = this;
         Component.mainStage = this.stage;
         Key.initialize(this.stage);
         gameLibrary = new Library(LibrarySWF);
         if(CreatorMain.dataLoader.baseURL.indexOf("http://sploder.home") == 0)
         {
            this.betaMode = false;
         }
         this._project = new CreatorProject(this,"/php/saveproject" + GAME_VERSION + ".php","version=" + GAME_VERSION,"/php/savegamedata" + GAME_VERSION + ".php");
         this.gameMode = 5;
         if(CreatorMain.dataLoader.embedParameters.userid == undefined || CreatorMain.dataLoader.embedParameters.userid == "demo")
         {
            this.demo = true;
         }
         if(this.demo)
         {
            User.u = 1;
            if(CreatorMain.dataLoader.embedParameters.creationdate != undefined)
            {
               User.c = String(CreatorMain.dataLoader.embedParameters.creationdate);
            }
            else
            {
               User.c = "20061226154248";
            }
         }
         else
         {
            User.u = parseInt(CreatorMain.dataLoader.embedParameters.userid);
            User.name = String(CreatorMain.dataLoader.embedParameters.username);
            this._project.author = User.name;
            User.c = String(CreatorMain.dataLoader.embedParameters.creationdate);
         }
         this.todaysdate = new Date();
         this.activedate = new Date();
         this.today = StringUtils.prettydatestring(this.todaysdate);
         this.todaycgi = StringUtils.cgidatestring(this.todaysdate);
         this.activeday = StringUtils.prettydatestring(this.todaysdate);
         this.activedaycgi = StringUtils.cgidatestring(this.todaysdate);
         if(!this.demo)
         {
            this.keepTimer = new Timer(20000,0);
            this.keepTimer.addEventListener(TimerEvent.TIMER,this.keepAlive);
            this.keepTimer.start();
         }
         CreatorMain.dataLoader.addEventListener(DataLoaderEvent.DATA_ERROR,this.onServerError);
         CreatorMain.dataLoader.addEventListener(DataLoaderEvent.METADATA_ERROR,this.onServerError);
         this.build();
         dispatchEvent(new Event(INITIALIZED));
      }
      
      protected function build() : void
      {
         new Boot();
         this.ui = new CreatorUI(this);
         this._container.addChild(this.ui);
         this.ui.addEventListener(Event.INIT,this.onUIInit);
         this.ui.start();
      }
      
      protected function onUIInit(param1:Event) : void
      {
         this.levels = new CreatorLevels(this);
         this.model = new Model(this.ui.playfield.mc,640,480);
         this.environment = new Environment();
         this.graphics = new ModelGraphics();
         this.uiController = new CreatorUIController(this);
         this.modelController = new ModelController(this);
         this.menuController = new CreatorMenu(this);
         this.uiController.connect();
         this.modelController.connect();
         this.menuController.saveEnabled = this.menuController.saveAsEnabled = this.menuController.publishEnabled = !this.demo;
         this.menuController.publishEnabled = !this.betaMode;
         this.ui.ddManager.listURL = "/php/getprojects.php";
         this.ui.ddManager.listParamString = "version=" + GAME_VERSION;
         this.ui.ddMusic.listURL = "/music/modules/index.m3u";
         this.ui.ddMusic.listParamString = "";
         this.ui.tools.activateTab(null,this.ui.tools.tabs[CreatorUIStates.TOOL_DRAW]);
         this.ui.ddWelcome.show();
         SoundManager.generateSounds();
      }
      
      public function showTour() : void
      {
         var tour:Clip = null;
         tour = new Clip(this._container,CreatorUIStates.SCREEN_TOUR,Clip.EMBED_LOCAL,720,590);
         tour.loadedClip.getChildAt(0)["done_btn"].addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            tour.destroy();
            onWelcomeClosed();
         });
         tour.underClipMouseEnabled = true;
      }
      
      public function onWelcomeClosed() : void
      {
         this.start();
      }
      
      protected function start() : void
      {
         var _loc1_:String = null;
         CreatorMain.preloader.done();
         Settings.bucketName = String(this._solBucketName + "_" + User.u);
         if(CreatorMain.dataLoader.embedParameters.copyaction == "true")
         {
            this.ui.ddClipboard.show();
         }
         else if(this.demo)
         {
            if(this.project.hasLocalProject)
            {
               _loc1_ = Settings.loadSetting(this.project.sharedObjectName) as String;
               if(Boolean(_loc1_) && _loc1_.indexOf("geoff") == -1)
               {
                  this.project.confirmLoadLocalProject();
               }
               else
               {
                  this.project.newProject();
                  if(!this.local)
                  {
                     this.ui.ddAlert.alert(CreatorUIStates.MESSAGE_GAME_DEMO);
                  }
               }
            }
            else
            {
               this.project.newProject();
               if(!this.local)
               {
                  this.ui.ddAlert.alert(CreatorUIStates.MESSAGE_GAME_DEMO);
               }
            }
         }
         else
         {
            if(!this.project.hasLocalProject)
            {
               Settings.bucketName = String(this._solBucketName + "_1");
               if(this.project.hasLocalProject)
               {
                  _loc1_ = Settings.loadSetting(this.project.sharedObjectName) as String;
                  Settings.saveSetting(this.project.sharedObjectName,"");
                  Settings.bucketName = String(this._solBucketName + "_" + User.u);
                  if(_loc1_.indexOf("geoff") == -1)
                  {
                     Settings.saveSetting(this.project.sharedObjectName,_loc1_);
                  }
               }
               else
               {
                  Settings.bucketName = String(this._solBucketName + "_" + User.u);
               }
            }
            if(this.project.hasLocalProject)
            {
               this.project.confirmLoadLocalProject();
            }
            else
            {
               this.project.newProject();
            }
         }
      }
      
      public function test() : void
      {
         if(this._testSimulation)
         {
            this._testSimulation.end();
         }
         ViewUI.library = gameLibrary;
         this._testSimulation = new Simulation(this._container,this.model,this.environment);
         this._testSimulation.build();
         var _loc1_:Sprite = this._testSimulation.view.container;
         _loc1_.x = 180;
         _loc1_.y = 90;
         if(this._testSimulation.viewUI)
         {
            if(this._testSimulation.viewUI.helpButton)
            {
               this._testSimulation.viewUI.helpButton.visible = false;
            }
            if(this._testSimulation.viewUI.retryButton)
            {
               this._testSimulation.viewUI.retryButton.visible = false;
            }
         }
         this._testSimulation.start();
         this._testing = true;
         this.ui.modifierPropertiesEditor.hide();
         this.ui.testMask.visible = true;
         this.ui.testEndButtonContainer.show();
         this.uiController.keyboardEnabled = false;
         Prompt.permaMessage = SoundManager.soundsGenerated ? "Your game level is now being tested. It may play a little slower in the creator." : "Your game level is now being tested. Sounds are still being generated while you test.";
      }
      
      public function testEnd() : void
      {
         if(this._testSimulation)
         {
            this._testSimulation.end();
            this._testSimulation = null;
            this._testing = false;
            this.ui.testEndButtonContainer.hide();
            this.ui.testMask.visible = false;
            this.uiController.keyboardEnabled = true;
         }
         Prompt.permaMessage = "";
         Prompt.prompt("Done testing your game level.");
      }
      
      protected function onServerError(param1:DataLoaderEvent) : void
      {
         this.ui.ddAlert.alert("There was an error communicating with the server.");
      }
      
      public function resetactivedate() : void
      {
         this.activedate = new Date();
         this.activeday = this.today;
         this.activedaycgi = this.todaycgi;
      }
      
      public function setGameMode(param1:Number) : void
      {
         this.gameMode = !isNaN(param1) ? param1 : this.gameMode;
         if(this.gameMode != 2)
         {
            this.gameMode = 2;
         }
      }
      
      public function keepAlive(param1:TimerEvent) : void
      {
         this.keepLoader = new URLLoader();
         this.keepLoader.addEventListener(Event.COMPLETE,this.checkAlive);
         this.keepLoader.load(new URLRequest("php/keepalive.php" + CreatorMain.dataLoader.getCacheString()));
      }
      
      public function checkAlive(param1:Event) : void
      {
         if(param1.target.data != "keepalive=1")
         {
            this.ui.ddAlert.alert(CreatorUIStates.MESSAGE_SESSION_EXPIRE);
            this.project.saveLocalProject();
            this.sessionExpired = true;
         }
         else if(this.sessionExpired == true)
         {
            this.sessionExpired = false;
         }
      }
   }
}

