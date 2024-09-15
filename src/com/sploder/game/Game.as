package com.sploder.game
{
   import com.sploder.asui.Library;
   import com.sploder.builder.Textures;
   import com.sploder.data.*;
   import com.sploder.game.library.EmbeddedLibrary;
   import com.sploder.game.widgets.GameConsole;
   import com.sploder.util.Base64;
   import com.sploder.util.Key;
   import com.sploder.util.SignString;
   import com.sploder.util.Stats;
   import flash.Boot;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.*;
   import flash.net.LocalConnection;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class Game
   {
      public static var mainStage:Stage;
      
      public static var library:EmbeddedLibrary;
      
      public static var gameInstance:Game;
      
      public static var s:String;
      
      public static var gamedata:URLVariables;
      
      public static var console:GameConsole;
      
      protected static var eventLC:LocalConnection;
      
      public static const START:String = "game_start";
      
      public static const END:String = "game_end";
      
      public static const PAUSE:String = "game_pause";
      
      public static const RESTART:String = "game_restart";
      
      public static const RESULT_SUBMIT:String = "game_result_submit";
      
      public static const RESULT_SUBMIT_DONE:String = "game_result_submit_done";
      
      public static var do_submit_score:Boolean = true;
      
      public static var LibrarySWF:Class = Game_LibrarySWF;
      
      public static var title:String = "Game Preview";
      
      public static var author:String = "You";
      
      public static var difficulty:int = 5;
      
      public static var rating:int = 3;
      
      public static var totalLevels:int = 1;
      
      public static var totalTime:int = 0;
      
      public static var ended:Boolean = false;
      
      public static var wonGame:Boolean = false;
      
      public static var gameResultSubmitted:Boolean = false;
      
      public static var testing:Boolean = false;
      
      protected static var eventLCName:String = "_sploder_events";
      
      protected var _main:Main;
      
      protected var _container:Sprite;
      
      protected var _levelContainer:Sprite;
      
      protected var _consoleContainer:Sprite;
      
      protected var _levelScreen:Sprite;
      
      protected var _width:int;
      
      protected var _height:int;
      
      protected var _currentLevel:GameLevel;
      
      protected var _currentLevelNum:uint = 0;
      
      protected var _firstLevel:Boolean = true;
      
      protected var _gameXML:XMLDocument;
      
      private var _timer:Timer;
      
      public var ctr:int = 0;
      
      public var gameResultLoader:URLLoader;
      
      public var gameResultVars:URLVariables;
      
      public var gameResultRequest:URLRequest;
      
      public function Game(param1:Main, param2:Object, param3:Sprite = null)
      {
         super();
         this.init(param1,param2,param3);
      }
      
      public static function restartLevel() : void
      {
         ended = wonGame = gameResultSubmitted = false;
         if(gameInstance)
         {
            --gameInstance.currentLevelNum;
            gameInstance.nextLevel();
         }
      }
      
      public static function restartGame() : void
      {
         ended = wonGame = gameResultSubmitted = false;
         if(gameInstance)
         {
            gameInstance.end();
         }
         Preloader.restart();
      }
      
      public static function unloadAllReferences() : void
      {
         Main.global = null;
         GameLevel.gameEngine = null;
         console = null;
         Main.mainInstance = null;
      }
      
      public static function endGame(param1:Boolean) : void
      {
         ended = true;
         if(gameInstance)
         {
            if(gameInstance.currentLevel)
            {
               gameInstance.currentLevel.stop();
            }
            Main.mainStage.removeEventListener(Event.ENTER_FRAME,gameInstance.updateGame);
         }
         if(param1)
         {
            wonGame = true;
            sendEvent(2);
         }
         else
         {
            wonGame = false;
            sendEvent(3);
         }
         if(!testing)
         {
            if(gameInstance)
            {
               gameInstance.sendGameResult(param1);
            }
         }
      }
      
      public static function sendEvent(param1:Number) : void
      {
         if(!testing)
         {
            eventLC.send(eventLCName,"onReceive",{
               "e":param1,
               "g":title,
               "s":s
            });
         }
      }
      
      public static function onEventStatus(param1:Event) : void
      {
      }
      
      public function get timer() : Timer
      {
         return this._timer;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function get gameXML() : XMLDocument
      {
         return this._gameXML;
      }
      
      public function get currentLevel() : GameLevel
      {
         return this._currentLevel;
      }
      
      public function get uiLibrary() : Library
      {
         return library;
      }
      
      public function get currentLevelNum() : uint
      {
         return this._currentLevelNum;
      }
      
      public function set currentLevelNum(param1:uint) : void
      {
         this._currentLevelNum = param1;
      }
      
      protected function init(param1:Main, param2:Object, param3:Sprite = null) : void
      {
         var _loc4_:Stats = null;
         new Boot();
         this._main = param1;
         testing = Preloader.testing;
         this._gameXML = new XMLDocument();
         this._gameXML.ignoreWhite = true;
         this._gameXML.parseXML(String(param2));
         this.extractGraphicsFromXMLDocument();
         title = unescape(this._gameXML.firstChild.attributes.title);
         author = unescape(this._gameXML.firstChild.attributes.author);
         s = User.s;
         this._container = param3;
         this._levelContainer = new Sprite();
         this._container.addChild(this._levelContainer);
         this._consoleContainer = new Sprite();
         this._container.addChild(this._consoleContainer);
         if(Main.local)
         {
            _loc4_ = new Stats();
            this._container.addChild(_loc4_);
         }
         gameInstance = this;
         ended = wonGame = false;
         EventHandler.totalLevels = totalLevels = this._gameXML.firstChild.firstChild.childNodes.length;
         EventHandler.totalTime = totalTime = 0;
         GameLevel.initialize();
         if(this._container == null)
         {
            this._container = Sprite(Main.mainStage.addChild(new Sprite()));
         }
         Main.mainStage.scaleMode = StageScaleMode.NO_SCALE;
         Main.mainStage.align = StageAlign.TOP_LEFT;
         this._width = Math.max(Main.mainStage.stageWidth,360);
         this._height = Math.max(Main.mainStage.stageHeight,240);
         Main.mainStage.addEventListener(Event.RESIZE,this.onResize,false,0,true);
         Main.dataLoader.addEventListener(DataLoaderEvent.DATA_LOADED,this.onXML,false,0,true);
         if(!testing)
         {
            eventLC = new LocalConnection();
            eventLC.addEventListener(StatusEvent.STATUS,onEventStatus,false,0,true);
            eventLC.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onEventStatus,false,0,true);
         }
         if(gamedata == null && !Main.localContent)
         {
            if(Preloader.url.indexOf("clearspring") != -1)
            {
               Main.dataLoader.loadMetadata("http://www.sploder.com/php/getgamedata.php?g=" + User.m,false,this.onGameDataLoaded);
            }
            else
            {
               Main.dataLoader.loadMetadata("/php/getgamedata.php?g=" + User.m,true,this.onGameDataLoaded);
            }
         }
         library = new EmbeddedLibrary(LibrarySWF);
         library.addEventListener(Event.INIT,this.onUILibraryLoaded,false,0,true);
      }
      
      public function onGameDataLoaded(param1:Event) : void
      {
         var e:Event = param1;
         var loader:URLLoader = URLLoader(e.target);
         var urlVars:String = loader.data;
         if(urlVars.charAt(0) == "&")
         {
            urlVars = urlVars.replace("&","");
         }
         gamedata = new URLVariables();
         try
         {
            gamedata.decode(urlVars);
            if(gamedata.username != null)
            {
               author = gamedata.username;
            }
            if(gamedata.difficulty != null && !isNaN(parseInt(gamedata.difficulty)))
            {
               difficulty = parseInt(gamedata.difficulty);
            }
            if(gamedata.rating != null && !isNaN(parseInt(gamedata.rating)))
            {
               rating = parseInt(gamedata.rating);
            }
         }
         catch(e:Error)
         {
            author = "Unknown";
            difficulty = 5;
            rating = 3;
         }
      }
      
      protected function onXML(param1:DataLoaderEvent) : void
      {
         this._gameXML = new XMLDocument(Main.dataLoader.xml.toString());
         if(this._gameXML != null)
         {
            this.initializeMediaManagers();
         }
      }
      
      protected function extractGraphicsFromXMLDocument() : void
      {
         var _loc1_:XMLNode = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:ByteArray = null;
         var _loc6_:Loader = null;
         if(this._gameXML && this._gameXML.firstChild && this._gameXML.firstChild.firstChild && Boolean(this._gameXML.firstChild.firstChild.nextSibling))
         {
            _loc1_ = this._gameXML.firstChild.firstChild.nextSibling;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.childNodes.length)
            {
               _loc3_ = XMLNode(_loc1_.childNodes[_loc2_]).attributes.name;
               if(Boolean(_loc3_) && !Textures.isLoaded(_loc3_))
               {
                  _loc4_ = XMLNode(_loc1_.childNodes[_loc2_]).firstChild.nodeValue;
                  if(_loc4_)
                  {
                     _loc5_ = Base64.decodeToByteArray(_loc4_);
                     if(_loc5_)
                     {
                        (_loc6_ = new Loader()).name = _loc3_;
                        _loc6_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onGraphicExtracted);
                        _loc6_.loadBytes(_loc5_);
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      protected function onGraphicExtracted(param1:Event) : void
      {
         var _loc2_:Loader = null;
         if(param1.target is LoaderInfo)
         {
            _loc2_ = LoaderInfo(param1.target).loader;
            if(_loc2_.content is Bitmap)
            {
               Textures.addBitmapDataToCache(_loc2_.name,Bitmap(_loc2_.content).bitmapData);
            }
         }
      }
      
      protected function onResize(param1:Event) : void
      {
         if(this._levelScreen)
         {
            if(mainStage.stageWidth > 0)
            {
               this._levelScreen.x = Math.floor(mainStage.stageWidth * 0.5 - this._levelScreen.width * 0.5);
               this._levelScreen.y = Math.floor(mainStage.stageHeight * 0.5 - this._levelScreen.height * 0.5);
            }
            else
            {
               this._levelScreen.x = Math.floor(this._width * 0.5 - this._levelScreen.width * 0.5);
               this._levelScreen.y = Math.floor(this._height * 0.5 - this._levelScreen.height * 0.5);
            }
         }
      }
      
      protected function initializeMediaManagers() : void
      {
      }
      
      protected function onUILibraryLoaded(param1:Event) : void
      {
         library.removeEventListener(Event.INIT,this.onUILibraryLoaded);
         Key.initialize(mainStage);
         Textures.library = library;
         ViewUI.library = library;
         View.stickToOrigin = false;
         this.startGame();
      }
      
      public function startGame() : void
      {
         this.nextLevel();
         Main.mainStage.addEventListener(Event.ENTER_FRAME,this.updateGame,false,0,true);
         Main.mainStage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyPress,false,0,true);
      }
      
      public function updateGame(param1:Event) : void
      {
         if(!ended && User["done"] == true)
         {
            endGame(false);
            if(this._currentLevel != null)
            {
               this._currentLevel.end();
               this._currentLevel = null;
            }
            unloadAllReferences();
         }
      }
      
      public function nextLevel() : void
      {
         if(this._currentLevel)
         {
            this._currentLevel.end();
            this._currentLevel = null;
         }
         this._currentLevelNum = Math.min(totalLevels,this._currentLevelNum + 1);
         Preloader.instance.hide();
         this.showLevelScreen(this._currentLevelNum,0);
         this._timer = new Timer(this._currentLevelNum == 1 ? 6000 : 3000,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.loadNextLevel,false,0,true);
         this._timer.start();
      }
      
      protected function loadNextLevel(param1:TimerEvent) : void
      {
         if(this._currentLevel)
         {
            this._currentLevel.end();
            this._currentLevel = null;
         }
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.loadNextLevel);
            this._timer = null;
         }
         if(ended)
         {
            return;
         }
         this._currentLevel = new GameLevel(this,this._levelContainer,this._currentLevelNum,this._firstLevel);
         this._currentLevel.buildGame();
         this._firstLevel = false;
      }
      
      public function onLevelLoaded() : void
      {
      }
      
      public function showLevelScreen(param1:uint = 1, param2:int = 0) : void
      {
         if(this._levelScreen == null)
         {
            this._levelScreen = this.uiLibrary.getDisplayObject("leveldialogue") as Sprite;
         }
         if(this._levelScreen != null)
         {
            this._levelScreen.mouseEnabled = true;
            this._levelScreen.mouseChildren = true;
            if(mainStage.stageWidth > 0)
            {
               this._levelScreen.x = Math.floor(mainStage.stageWidth * 0.5 - this._levelScreen.width * 0.5);
               this._levelScreen.y = Math.floor(mainStage.stageHeight * 0.5 - this._levelScreen.height * 0.5);
            }
            else
            {
               this._levelScreen.x = Math.floor(this._width * 0.5 - this._levelScreen.width * 0.5);
               this._levelScreen.y = Math.floor(this._height * 0.5 - this._levelScreen.height * 0.5);
            }
            this._container.addChild(this._levelScreen);
            this._levelScreen["anim"].gotoAndPlay(1);
            this.initLevelScreen(param1,param2);
         }
      }
      
      public function removeLevelScreen() : void
      {
         if(Boolean(this._levelScreen) && Boolean(this._levelScreen.parent))
         {
            this._levelScreen.parent.removeChild(this._levelScreen);
         }
      }
      
      protected function initLevelScreen(param1:uint = 1, param2:int = 0) : void
      {
         var _loc5_:MovieClip = null;
         var _loc3_:TextField = this._levelScreen["title"];
         if(_loc3_)
         {
            _loc3_.text = "LEVEL " + param1;
         }
         var _loc4_:int = 1;
         while(_loc4_ <= 9)
         {
            (_loc5_ = this._levelScreen["level" + _loc4_]).alpha = _loc4_ < param1 ? 0.5 : 1;
            if(_loc4_ <= param1)
            {
               _loc5_.gotoAndStop(_loc4_ + 2);
            }
            else if(_loc4_ <= Game.totalLevels)
            {
               _loc5_.gotoAndStop("locked");
            }
            else
            {
               _loc5_.gotoAndStop(1);
            }
            _loc4_++;
         }
         this._levelScreen["game_title"].text = Game.title;
         this._levelScreen["game_author"].htmlText = "<font color=\"#999999\">BY:</font> " + Game.author.toUpperCase();
         this._levelScreen["game_difficulty"].gotoAndStop(Game.difficulty + 2);
         this._levelScreen["game_level"].text = "LEVEL " + this._currentLevelNum + " LOADING";
      }
      
      public function updateConsole() : void
      {
         if(console == null)
         {
            console = new GameConsole(this,this._consoleContainer,this._width,this._height);
         }
      }
      
      public function onPauseToggle(param1:Event) : void
      {
         if(this._currentLevel)
         {
            if(this._currentLevel.running)
            {
               this._currentLevel.pause();
               console.showPauseScreen();
            }
            else
            {
               this._currentLevel.resume();
               console.hidePauseScreen();
               console.hideTitleScreen();
               console.hideRetryScreen();
            }
         }
      }
      
      public function sendGameResult(param1:Boolean) : void
      {
         if(s == null && User.s == null)
         {
            return;
         }
         if(!do_submit_score)
         {
            gameResultSubmitted = true;
            return;
         }
         var _loc2_:String = param1 ? "true" : "false";
         this.gameResultVars = new URLVariables();
         this.gameResultVars.w = _loc2_;
         this.gameResultVars.gtm = Math.floor(EventHandler.totalTime);
         if(s != null)
         {
            this.gameResultVars.pubkey = s;
         }
         else if(User.s != null)
         {
            this.gameResultVars.pubkey = User.s;
         }
         this.gameResultRequest = new URLRequest(Main.dataLoader.baseURL + "/php/gameresults.php?ax=" + SignString.sign(s + this.gameResultVars.w + this.gameResultVars.gtm));
         this.gameResultRequest.method = "POST";
         this.gameResultRequest.data = this.gameResultVars;
         this.gameResultLoader = new URLLoader();
         this.gameResultLoader.addEventListener(Event.COMPLETE,this.onGameResultSent,false,0,true);
         this.gameResultLoader.load(this.gameResultRequest);
      }
      
      public function onGameResultSent(param1:Event) : void
      {
         gameResultSubmitted = true;
      }
      
      protected function onKeyPress(param1:KeyboardEvent) : void
      {
         switch(param1.charCode)
         {
            case String("p").charCodeAt(0):
               this.onPauseToggle(param1);
               break;
            case String("y").charCodeAt(0):
         }
      }
      
      public function end() : void
      {
         if(Boolean(this._timer) && this._timer.running)
         {
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.loadNextLevel);
            this._timer.stop();
         }
         if(console)
         {
            console.end();
         }
         if(gameInstance)
         {
            if(gameInstance.currentLevel)
            {
               gameInstance.currentLevel.end();
            }
            gameInstance = null;
         }
         Main.mainStage.removeEventListener(Event.RESIZE,this.onResize);
         Main.mainStage.removeEventListener(Event.ENTER_FRAME,this.updateGame);
         Main.mainStage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyPress);
         unloadAllReferences();
      }
   }
}

