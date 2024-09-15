package com.sploder.game.widgets
{
   import com.sploder.data.*;
   import com.sploder.game.Game;
   import com.sploder.game.GameLevel;
   import com.sploder.game.States;
   import flash.display.FrameLabel;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class GameConsole extends EventDispatcher
   {
      public static const TEST_COMPLETE:String = "test_complete";
      
      protected var _game:Game;
      
      protected var _container:Sprite;
      
      protected var _width:int;
      
      protected var _height:int;
      
      protected var _clip:Sprite;
      
      protected var _titleScreen:MovieClip;
      
      protected var _pauseScreen:Sprite;
      
      protected var _retryScreen:MovieClip;
      
      protected var _endScreen:MovieClip;
      
      protected var _leaderboard:Leaderboard;
      
      protected var _voteWidget:VoteWidget;
      
      protected var _winEventSent:Boolean = false;
      
      protected var _wonGame:Boolean = false;
      
      protected var _finishing:Boolean = false;
      
      protected var _finishTimer:Timer;
      
      protected var _displayedLives:int = 1;
      
      protected var _taskNoticeTimer:Timer;
      
      private var _playInterval:Number;
      
      public function GameConsole(param1:Game, param2:Sprite, param3:int, param4:int)
      {
         super();
         this._game = param1;
         this._container = param2;
         this._width = param3;
         this._height = param4;
         this.build();
      }
      
      protected function build() : void
      {
         this._clip = new Sprite();
         this._clip.mouseEnabled = true;
         this._clip.mouseChildren = true;
         this._clip.tabEnabled = false;
         this._clip.tabChildren = false;
         this._clip.focusRect = false;
         this._container.addChild(this._clip);
         this.initConsole();
         this.showTitleScreen();
      }
      
      protected function initConsole() : void
      {
         this.updateStatus();
         if(Boolean(this._container) && Boolean(this._container.stage))
         {
            this._container.stage.addEventListener(Event.RESIZE,this.onResize);
         }
      }
      
      public function onResize(param1:Event = null) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Stage = null;
         if(this._container && this._container.stage && this._container.stage.stageWidth > 0)
         {
            _loc2_ = this._container;
            _loc3_ = this._container.stage;
            this._width = _loc3_.stageWidth;
            this._height = _loc3_.stageHeight;
            if(this._titleScreen)
            {
               this._titleScreen.x = Math.floor(this._width * 0.5 - this._titleScreen.width * 0.5) + 10;
               this._titleScreen.y = Math.floor(this._height * 0.5 - this._titleScreen.height * 0.5);
            }
            if(this._pauseScreen)
            {
               this._pauseScreen.x = Math.floor(this._width * 0.5);
               this._pauseScreen.y = Math.floor(this._height * 0.5) - 10;
            }
            if(this._retryScreen)
            {
               this._retryScreen.x = Math.floor(this._width * 0.5);
               this._retryScreen.y = Math.floor(this._height * 0.5) - 10;
            }
            if(this._endScreen)
            {
               this._endScreen.x = Math.floor(this._width * 0.5 - this._endScreen.width * 0.5);
               this._endScreen.y = Math.floor(this._height * 0.5 - this._endScreen.height * 0.5);
            }
         }
      }
      
      public function updateStatus(param1:Event = null) : void
      {
      }
      
      public function reinit() : void
      {
         this.initConsole();
      }
      
      public function finishGame(param1:Boolean) : void
      {
         if(!this._finishing)
         {
            this._finishing = true;
            this._wonGame = param1;
            this._finishTimer = new Timer(1000,1);
            this._finishTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onFinishGameTimer);
            this._finishTimer.start();
         }
      }
      
      protected function onFinishGameTimer(param1:TimerEvent) : void
      {
         if(this._finishTimer)
         {
            this._finishTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onFinishGameTimer);
            Game.endGame(this._wonGame);
            this.showEndScreen();
            this._finishTimer = null;
         }
      }
      
      public function showPauseScreen() : void
      {
         if(this._pauseScreen)
         {
            this._pauseScreen.visible = true;
         }
         else
         {
            this._pauseScreen = this._game.uiLibrary.getDisplayObject("pausescreen") as Sprite;
            this._pauseScreen.mouseEnabled = this._pauseScreen.mouseChildren = false;
            this._pauseScreen.x = Math.floor(this._width * 0.5);
            this._pauseScreen.y = Math.floor(this._height * 0.5) - 10;
         }
         this._container.addChild(this._pauseScreen);
      }
      
      public function hidePauseScreen() : void
      {
         if(this._pauseScreen)
         {
            this._pauseScreen.visible = false;
            if(this._pauseScreen.parent)
            {
               this._pauseScreen.parent.removeChild(this._pauseScreen);
            }
         }
      }
      
      public function showRetryScreen() : void
      {
         if(this._retryScreen)
         {
            this._retryScreen.visible = true;
         }
         else
         {
            this._retryScreen = this._game.uiLibrary.getDisplayObject("retryscreen") as MovieClip;
            this._retryScreen.x = Math.floor(this._width * 0.5);
            this._retryScreen.y = Math.floor(this._height * 0.5) - 10;
            this._retryScreen["no"].addEventListener(MouseEvent.CLICK,this.onRetryNo);
            this._retryScreen["yes"].addEventListener(MouseEvent.CLICK,this.onRetryYes);
         }
         this._container.addChild(this._retryScreen);
      }
      
      public function hideRetryScreen() : void
      {
         if(this._retryScreen)
         {
            this._retryScreen.visible = false;
            if(this._retryScreen.parent)
            {
               this._retryScreen.parent.removeChild(this._retryScreen);
            }
         }
      }
      
      public function showTitleScreen() : void
      {
         if(this._titleScreen)
         {
            this._titleScreen.visible = true;
            this._titleScreen.gotoAndPlay(1);
         }
         else
         {
            this._titleScreen = this._game.uiLibrary.getDisplayObject("titledialogue") as MovieClip;
            this._titleScreen.mouseEnabled = true;
            this._titleScreen.mouseChildren = true;
            this._titleScreen.x = Math.floor(this._width * 0.5 - this._titleScreen.width * 0.5) + 10;
            this._titleScreen.y = Math.floor(this._height * 0.5 - this._titleScreen.height * 0.5);
            this.initTitleScreen();
         }
         this._container.addChild(this._titleScreen);
      }
      
      public function hideTitleScreen() : void
      {
         if(this._titleScreen)
         {
            this._titleScreen.visible = false;
            this._titleScreen.gotoAndStop(1);
            if(this._titleScreen.parent)
            {
               this._titleScreen.parent.removeChild(this._titleScreen);
            }
         }
      }
      
      protected function initTitleScreen() : void
      {
         var _loc1_:FrameLabel = null;
         if(this._titleScreen == null)
         {
            return;
         }
         for each(_loc1_ in this._titleScreen.currentLabels)
         {
            this._titleScreen.addFrameScript(_loc1_.frame - 1,this.onTitleScreenLabel);
         }
      }
      
      protected function onTitleScreenLabel() : void
      {
         var _loc2_:TextField = null;
         var _loc3_:TextField = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:SimpleButton = null;
         if(this._titleScreen == null)
         {
            return;
         }
         var _loc1_:String = this._titleScreen.currentLabel;
         switch(_loc1_)
         {
            case "getInstructions":
               _loc2_ = this._titleScreen.goals;
               _loc3_ = this._titleScreen.instructions;
               _loc2_.text = Game.gameInstance.currentLevel.environment.getGameInfo();
               _loc4_ = Game.gameInstance.currentLevel.environment.vInstructions;
               if(_loc4_.length == 0)
               {
                  _loc4_ = Game.gameInstance.currentLevel.model.modifiers.guessInstructions();
               }
               _loc3_.text = _loc4_;
               _loc2_.autoSize = TextFieldAutoSize.LEFT;
               _loc3_.y = _loc2_.y + _loc2_.height + 10;
               _loc5_ = Game.gameInstance.currentLevel.model.modifiers.getControls();
               if(_loc5_.indexOf(States.CONTROLS_MOUSE) != -1)
               {
                  this._titleScreen.mouse.alpha = 1;
               }
               if(_loc5_.indexOf(States.CONTROLS_UPDOWN) != -1)
               {
                  this._titleScreen.updown.alpha = 1;
               }
               if(_loc5_.indexOf(States.CONTROLS_LEFTRIGHT) != -1)
               {
                  this._titleScreen.leftright.alpha = 1;
               }
               if(_loc5_.indexOf(States.CONTROLS_SPACEBAR) != -1)
               {
                  this._titleScreen.spacebar.alpha = 1;
               }
               _loc6_ = SimpleButton(this._titleScreen.fastmode);
               if(this._game.currentLevel.turbo)
               {
                  _loc6_.visible = false;
               }
               else
               {
                  _loc6_.addEventListener(MouseEvent.CLICK,this.onFastmodeButtonClicked,false,0,true);
               }
               break;
            case "getPlayAction":
               SimpleButton(this._titleScreen.game_play).addEventListener(MouseEvent.MOUSE_UP,this.onPlayButtonClicked,false,0,true);
               this._titleScreen.stop();
               break;
            case "end":
               this._container.removeChild(this._titleScreen);
               this._titleScreen.stop();
               this._titleScreen = null;
         }
      }
      
      protected function onFastmodeButtonClicked(param1:MouseEvent) : void
      {
         GameLevel.forceTurbo = true;
         Game.restartGame();
      }
      
      protected function onPlayButtonClicked(param1:MouseEvent) : void
      {
         SimpleButton(this._titleScreen.game_play).removeEventListener(MouseEvent.MOUSE_UP,this.onPlayButtonClicked);
         this._titleScreen.play();
         clearInterval(this._playInterval);
         this._playInterval = setInterval(this.doThePlaying,500);
         Game.sendEvent(1);
      }
      
      protected function doThePlaying() : void
      {
         clearInterval(this._playInterval);
         this._game.currentLevel.start();
      }
      
      public function showEndScreen() : void
      {
         if(this._endScreen == null)
         {
            this._endScreen = this._game.uiLibrary.getDisplayObject("enddialogue") as MovieClip;
         }
         if(this._endScreen != null)
         {
            this._endScreen.mouseEnabled = true;
            this._endScreen.mouseChildren = true;
            this._endScreen.x = Math.floor(this._width * 0.5 - this._endScreen.width * 0.5);
            this._endScreen.y = Math.floor(this._height * 0.5 - this._endScreen.height * 0.5);
            this._container.addChild(this._endScreen);
            this.initEndScreen();
         }
      }
      
      public function removeEndScreen() : void
      {
         if(this._endScreen != null && this._container.getChildIndex(this._endScreen) != -1)
         {
            this._container.removeChild(this._endScreen);
            this._endScreen = null;
         }
      }
      
      protected function initEndScreen() : void
      {
         var _loc1_:FrameLabel = null;
         for each(_loc1_ in this._endScreen.currentLabels)
         {
            this._endScreen.addFrameScript(_loc1_.frame - 1,this.onEndScreenLabel);
         }
      }
      
      protected function onEndScreenLabel() : void
      {
         var _loc1_:SimpleButton = null;
         if(this._endScreen == null)
         {
            return;
         }
         var _loc2_:String = this._endScreen.currentLabel;
         switch(_loc2_)
         {
            case "setResult":
               if(Game.wonGame)
               {
                  this._endScreen["result"].gotoAndPlay(30);
               }
               break;
            case "checkSubmission":
               if(Game.gameResultSubmitted)
               {
                  this._endScreen.play();
               }
               else
               {
                  this._endScreen.gotoAndPlay(75);
               }
               break;
            case "showGameTime":
               if(this._endScreen["game_time"] != null)
               {
                  this.setGameTime(this._endScreen["game_time"]);
               }
               break;
            case "showGameResult":
               if(this._endScreen["game_result"] != null)
               {
                  if(Game.wonGame)
                  {
                     this._endScreen["game_result"].gotoAndStop(3);
                  }
                  else
                  {
                     this._endScreen["game_result"].gotoAndStop(2);
                  }
               }
            case "showAuthor":
               if(this._endScreen["game_author"] != null)
               {
                  this.setGameAuthor(this._endScreen["game_author"]);
               }
               if(this._endScreen["author_button"] != null)
               {
                  _loc1_ = this._endScreen["author_button"];
                  _loc1_.addEventListener(MouseEvent.CLICK,this.onAuthorNameClicked,false,0,true);
               }
               break;
            case "showLeaderboard":
               this._leaderboard = new Leaderboard(this._endScreen["leaderboard"]);
               break;
            case "voteWidget":
               if(this._endScreen["vote_widget"] != null)
               {
                  this._voteWidget = new VoteWidget(this._endScreen["vote_widget"]);
               }
               if(this._endScreen["try_again_button"] != null)
               {
                  _loc1_ = this._endScreen["try_again_button"];
                  if(Game.wonGame)
                  {
                     _loc1_.visible = false;
                  }
               }
               break;
            case "buildComplete":
               if(this._endScreen["try_again_button"] != null)
               {
                  _loc1_ = this._endScreen["try_again_button"];
                  _loc1_.addEventListener(MouseEvent.CLICK,this.onReplayButtonClicked,false,0,true);
               }
               if(this._endScreen["replay_game_button"] != null)
               {
                  _loc1_ = this._endScreen["replay_game_button"];
                  _loc1_.addEventListener(MouseEvent.CLICK,this.onReplayButtonClicked,false,0,true);
               }
               if(this._endScreen["play_more_games_button"] != null)
               {
                  _loc1_ = this._endScreen["play_more_games_button"];
                  _loc1_.addEventListener(MouseEvent.CLICK,this.onPlayMoreGamesButtonClicked,false,0,true);
               }
               this._endScreen.stop();
         }
      }
      
      public function setGameTime(param1:TextField) : void
      {
         var _loc2_:int = Game.totalTime;
         if(_loc2_ > 0)
         {
            if(_loc2_ > 60)
            {
               param1.text = Math.floor(_loc2_ / 60) + ":";
            }
            else
            {
               param1.text = "0:";
            }
            if(_loc2_ % 60 == 0)
            {
               param1.appendText("00");
            }
            else if(_loc2_ % 60 < 10)
            {
               param1.appendText("0" + _loc2_ % 60);
            }
            else
            {
               param1.appendText("" + _loc2_ % 60);
            }
         }
         else
         {
            param1.text = "-:--";
         }
      }
      
      public function setGameAuthor(param1:TextField, param2:Boolean = true) : void
      {
         var _loc3_:String = "";
         if(param2)
         {
            _loc3_ = unescape("%20%AC%AC");
         }
         param1.htmlText = "<a href=\"http://www.sploder.com/games/members/" + Game.author.toLowerCase() + "/\">" + Game.author.toUpperCase() + _loc3_ + "</a>";
      }
      
      public function onAuthorNameClicked(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://www.sploder.com/games/members/" + Game.author.toLowerCase() + "/");
         try
         {
            navigateToURL(_loc2_,"_blank");
         }
         catch(e:Error)
         {
         }
      }
      
      public function onRetryNo(param1:MouseEvent) : void
      {
         this.hideRetryScreen();
         this._game.currentLevel.resume();
      }
      
      public function onRetryYes(param1:MouseEvent) : void
      {
         this.removeEndScreen();
         this.hideRetryScreen();
         this.hidePauseScreen();
         this.hideTitleScreen();
         this._finishing = false;
         Game.restartLevel();
      }
      
      public function onReplayButtonClicked(param1:MouseEvent) : void
      {
         this.removeEndScreen();
         this._finishing = false;
         if(Game.wonGame)
         {
            Game.restartGame();
         }
         else
         {
            Game.restartLevel();
         }
      }
      
      public function onPlayMoreGamesButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:SimpleButton = null;
         if(this._endScreen["play_more_games_button"] != null)
         {
            _loc2_ = this._endScreen["play_more_games_button"];
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onPlayMoreGamesButtonClicked);
            this.loadLinks();
         }
      }
      
      protected function loadLinks() : void
      {
         var _loc1_:String = null;
         if(Main.dataLoader.baseURL.indexOf("http://sploder.home") == -1 && Main.dataLoader.baseURL.indexOf("192.168.") == -1 && Main.dataLoader.embedParameters.onsplodercom == undefined)
         {
            _loc1_ = "http://www.sploder.com/gamelinks.swf";
         }
         else
         {
            _loc1_ = "gamelinks.swf";
         }
         var _loc2_:Loader = new Loader();
         this._container.addChild(_loc2_);
         var _loc3_:URLRequest = new URLRequest(_loc1_);
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLinksLoaded);
         _loc2_.load(_loc3_);
      }
      
      protected function onLinksLoaded(param1:Event) : void
      {
         this.removeEndScreen();
      }
      
      public function end() : void
      {
         if(Boolean(this._container) && Boolean(this._container.stage))
         {
            this._container.stage.removeEventListener(Event.RESIZE,this.onResize);
         }
         if(Boolean(this._clip) && Boolean(this._container))
         {
            this._container.removeChild(this._clip);
         }
         this._container = null;
         this._clip = null;
         this._voteWidget = null;
         this._leaderboard = null;
      }
   }
}

