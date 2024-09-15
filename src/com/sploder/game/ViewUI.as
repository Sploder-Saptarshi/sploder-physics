package com.sploder.game
{
   import com.sploder.asui.Library;
   import com.sploder.asui.ObjectEvent;
   import com.sploder.builder.model.Environment;
   import com.sploder.game.sound.SoundManager;
   import com.sploder.game.sound.Sounds;
   import com.sploder.util.PlayTimeCounter;
   import com.sploder.util.StringUtils;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class ViewUI
   {
      public static var library:Library;
      
      public static var _nextID:int = 0;
      
      protected var _simulation:Simulation;
      
      protected var _clip:Sprite;
      
      protected var _id:int = 0;
      
      protected var _lifeTF:TextField;
      
      protected var _penaltyTF:TextField;
      
      protected var _scoreTF:TextField;
      
      protected var _levelClip:Sprite;
      
      protected var _levelTF:TextField;
      
      protected var _timerClip:Sprite;
      
      protected var _timerTF:TextField;
      
      protected var _soundStatusTF:TextField;
      
      protected var _topBar:MovieClip;
      
      protected var _taskNotice:MovieClip;
      
      protected var _bottomBar:MovieClip;
      
      protected var _bottomBarBackground:MovieClip;
      
      protected var _helpButton:SimpleButton;
      
      protected var _retryButton:SimpleButton;
      
      protected var _musicIcon:MovieClip;
      
      protected var _logo:Sprite;
      
      protected var _soundToggle:MovieClip;
      
      protected var _soundToggleButton:SimpleButton;
      
      protected var _copyClip:MovieClip;
      
      protected var _copyButton:SimpleButton;
      
      protected var _clockTimer:Timer;
      
      protected var _taskNoticeTimer:Timer;
      
      protected var _soundStatusInterval:int;
      
      protected var _playtimeText:TextField;
      
      protected var _playtimeInterval:int;
      
      protected var _prevSecondsCounted:int = -1;
      
      protected var _prevComplete:Boolean = false;
      
      protected var _origin:Point;
      
      public function ViewUI(param1:Simulation)
      {
         super();
         this._simulation = param1;
         ++_nextID;
         this._id = _nextID;
         if(library)
         {
            this.build();
         }
      }
      
      protected function build() : void
      {
         this._clip = library.getDisplayObject("console") as Sprite;
         this._clip.mouseEnabled = true;
         this._clip.mouseChildren = true;
         this._clip.tabEnabled = false;
         this._clip.tabChildren = false;
         this._clip.focusRect = false;
         this._simulation.view.ui.addChild(this._clip);
         this._origin = new Point();
         this.initConsole();
      }
      
      protected function initConsole() : void
      {
         this._topBar = this._clip["topbar"];
         this._lifeTF = this._clip["life"];
         this._penaltyTF = this._clip["penalty"];
         this._scoreTF = this._clip["score"];
         this._levelClip = this._clip["level"];
         this._levelTF = this._levelClip["tf"];
         this._timerClip = this._clip["time"];
         this._timerTF = this._timerClip["tf"];
         this._helpButton = this._clip["help"];
         this._retryButton = this._clip["retry"];
         this._taskNotice = this._clip["taskNotice"];
         this._bottomBar = this._clip["bottom_bar"];
         this._playtimeText = this._bottomBar["playtime"];
         this._logo = this._bottomBar["logo"];
         this._musicIcon = this._bottomBar["music"];
         this._soundStatusTF = this._bottomBar["soundstatus"];
         this._soundToggle = this._bottomBar["soundtoggle"];
         this._soundToggleButton = this._soundToggle["btn"];
         this._bottomBarBackground = this._bottomBar["bkgd"];
         this._copyClip = this._bottomBar["copy"];
         this._copyButton = this._copyClip["btn"];
         this._clip.mouseEnabled = false;
         this._clip.mouseChildren = true;
         this._topBar.mouseEnabled = this._topBar.mouseChildren = false;
         this._bottomBar.mouseEnabled = false;
         this._bottomBar.mouseChildren = true;
         this._bottomBarBackground.stop();
         this._bottomBarBackground.mouseEnabled = false;
         this._copyClip.visible = false;
         this._taskNotice.visible = false;
         this._musicIcon.visible = false;
         if(!SoundManager.soundsGenerated)
         {
            this._soundStatusInterval = setInterval(this.updateSoundStatus,500);
         }
         else
         {
            this._soundStatusTF.text = "";
         }
         this._soundStatusTF.mouseEnabled = false;
         if(SoundManager.hasSound)
         {
            this._soundToggle.gotoAndStop(1);
         }
         else
         {
            this._soundToggle.gotoAndStop(2);
         }
         this._soundToggleButton.addEventListener(MouseEvent.CLICK,this.onSoundToggleButtonClicked,false,0,true);
         this.onResize();
         this.setInitialValues();
         this.updateSoundStatus();
         this._simulation.view.addEventListener(Event.RESIZE,this.onResize,false,0,true);
         this._simulation.events.addEventListener(States.ACTION_ADDLIFE,this.onStatus,false,0,true);
         this._simulation.events.addEventListener(States.ACTION_ENDGAME,this.onStatus,false,0,true);
         this._simulation.events.addEventListener(States.ACTION_LOSELIFE,this.onStatus,false,0,true);
         this._simulation.events.addEventListener(States.ACTION_PENALTY,this.onStatus,false,0,true);
         this._simulation.events.addEventListener(States.ACTION_SCORE,this.onStatus,false,0,true);
         this._simulation.events.addEventListener(States.EVENT_AMMOLOW,this.onStatus,false,0,true);
         if(PlayTimeCounter.showTime)
         {
            if(PlayTimeCounter.timeLimit > 0)
            {
               this._playtimeInterval = setInterval(this.updatePlayTime,500);
            }
            else
            {
               this.updatePlayScore();
            }
            this._bottomBarBackground.gotoAndStop(2);
            this._logo.visible = false;
            this._soundToggle.x -= 104;
            this._copyClip.x -= 104;
         }
         else
         {
            this._playtimeText.visible = false;
         }
      }
      
      public function onResize(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(this._simulation) && Boolean(this._simulation.view))
         {
            _loc2_ = int(this._simulation.view.width);
            _loc3_ = int(this._simulation.view.height);
            this._topBar.width = _loc2_;
            this._levelClip.x = _loc2_ - 160;
            this._timerClip.x = _loc2_ - 64;
            this._taskNotice.x = (_loc2_ - this._taskNotice.width) * 0.5;
            this._taskNotice.y = _loc3_ - 80;
            this._bottomBar.y = _loc3_ - 20;
            this._bottomBarBackground.width = _loc2_;
            this._logo.x = _loc2_ - Math.floor(this._logo.width) - 20;
            this._helpButton.y = this._retryButton.y = _loc3_ - 29;
            this._copyClip.x = this._logo.x - 10;
            this._soundToggle.x = _loc2_ - 14;
            this._clip.x = Math.floor(this._simulation.view.x);
            this._clip.y = Math.floor(this._simulation.view.y);
            if(this._simulation.environment.vMusic == "")
            {
               this._musicIcon.visible = false;
               this._soundStatusTF.x = 115;
            }
            else
            {
               this._musicIcon.visible = true;
               this._soundStatusTF.x = 125;
            }
         }
      }
      
      public function setInitialValues() : void
      {
         this._lifeTF.text = this._simulation.environment.total_lives + "";
         if(this._simulation.environment.total_penalties)
         {
            this._penaltyTF.text = "0" + "/" + this._simulation.environment.total_penalties;
         }
         else
         {
            this._penaltyTF.text = "0";
         }
         if(this._simulation.environment.total_score)
         {
            this._scoreTF.text = 0 + "/" + this._simulation.environment.total_score;
         }
         else
         {
            this._scoreTF.text = 0 + "";
         }
         this._levelTF.text = "LEVEL " + EventHandler.levelNum + "/" + EventHandler.totalLevels;
         if(this._simulation.environment.total_time == 0)
         {
            this._timerClip.visible = false;
            this._levelClip.x = this._timerClip.x - 27;
         }
         else
         {
            this._clockTimer = new Timer(250,0);
            this._clockTimer.addEventListener(TimerEvent.TIMER,this.updateClock,false,0,true);
            this._clockTimer.start();
         }
      }
      
      protected function onStatus(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         switch(param1.type)
         {
            case States.ACTION_ADDLIFE:
               this._lifeTF.text = Math.max(0,this._simulation.events.lives) + "";
               this.addEventEffect("event_addlife");
               break;
            case States.ACTION_ENDGAME:
               if(this._simulation.events.won)
               {
                  if(this._simulation.environment.total_score > 0)
                  {
                     this._taskNotice.gotoAndStop("win_score");
                  }
                  else
                  {
                     this._taskNotice.gotoAndStop("win_time");
                  }
               }
               else if(this._simulation.events.lives <= 0)
               {
                  this._taskNotice.gotoAndStop("lose");
               }
               else
               {
                  this._taskNotice.gotoAndStop("lose_time");
               }
               this._taskNotice.visible = true;
               break;
            case States.ACTION_LOSELIFE:
               this._lifeTF.text = Math.max(0,this._simulation.events.lives) + "";
               this.addEventEffect("event_loselife");
               break;
            case States.ACTION_PENALTY:
               if(this._simulation.environment.total_penalties)
               {
                  this._penaltyTF.text = Math.max(0,this._simulation.events.penalty) + "/" + this._simulation.environment.total_penalties;
               }
               else
               {
                  this._penaltyTF.text = Math.max(0,this._simulation.events.penalty) + "";
               }
               this.addEventEffect("event_penalty");
               break;
            case States.ACTION_SCORE:
               if(this._simulation.environment.total_score)
               {
                  this._scoreTF.text = Math.max(0,this._simulation.events.score) + "/" + this._simulation.environment.total_score;
               }
               else
               {
                  this._scoreTF.text = Math.max(0,this._simulation.events.score) + "";
               }
               this.addEventEffect("event_score");
               if(PlayTimeCounter.scoreLimit > 0)
               {
                  this.updatePlayScore();
               }
               break;
            case States.EVENT_AMMOLOW:
               if(param1 is ObjectEvent)
               {
                  _loc2_ = parseInt(ObjectEvent(param1).object.total);
                  if(_loc2_ < 10)
                  {
                     _loc3_ = this.addEventEffect("event_ammolow");
                     _loc3_.x = ObjectEvent(param1).object.x;
                     _loc3_.y = ObjectEvent(param1).object.y;
                     if(this._simulation.environment.size == Environment.SIZE_DOUBLE)
                     {
                        _loc3_.x *= 0.5;
                        _loc3_.y *= 0.5;
                        _loc3_.scaleX = _loc3_.scaleY = 0.5;
                     }
                     else
                     {
                        _loc3_.scaleX = _loc3_.scaleY = 1;
                     }
                     TextField(_loc3_["tf"]).text = _loc2_ + "";
                  }
               }
         }
      }
      
      protected function addEventEffect(param1:String) : Sprite
      {
         var _loc2_:Point = this._simulation.view.viewport.localToGlobal(this._simulation.events.lastEventPos);
         _loc2_ = this._clip.globalToLocal(_loc2_);
         var _loc3_:Sprite = library.getDisplayObject(param1) as Sprite;
         if(_loc3_)
         {
            _loc3_.scaleX = _loc3_.scaleY = this._simulation.view.viewport.scaleX * 2;
            _loc3_.x = _loc2_.x;
            _loc3_.y = _loc2_.y;
            this._clip.addChild(_loc3_);
         }
         return _loc3_;
      }
      
      protected function updateClock(param1:TimerEvent = null) : void
      {
         var _loc2_:String = this._timerTF.text;
         this.setGameTime(this._timerTF);
         if(this._timerTF.text != _loc2_)
         {
            if(this._simulation.events.timeElapsed <= this._simulation.environment.total_time && this._simulation.environment.total_time - this._simulation.events.timeElapsed <= 10)
            {
               this._simulation.playSound(null,Sounds.TICK,1,false);
            }
         }
      }
      
      public function reinit() : void
      {
         this.initConsole();
      }
      
      public function setGameTime(param1:TextField) : void
      {
         if(this._simulation == null)
         {
            return;
         }
         if(this._simulation.environment == null)
         {
            return;
         }
         if(this._simulation.events == null)
         {
            return;
         }
         var _loc2_:int = Math.max(0,this._simulation.environment.total_time - this._simulation.events.timeElapsed);
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
      
      protected function updateSoundStatus() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         if(this._soundStatusTF == null)
         {
            return;
         }
         if(SoundManager.soundsGenerated)
         {
            if(this._musicIcon.visible)
            {
               _loc1_ = this._simulation.environment.vMusic.split("/");
               _loc2_ = String(_loc1_[1]).split("?")[0];
               _loc2_ = StringUtils.titleCase(unescape(_loc2_).split(".mod").join("").split("-").join(" "));
               this._soundStatusTF.htmlText = _loc2_ + " - " + "<font color=\"#ffec00\"><a href=\"http://www.sploder.com/music/author_redirect.php?author=" + _loc1_[0] + "\" target=\"_blank\">" + _loc1_[0] + " ¬</a></font>";
               this._soundStatusTF.visible = true;
               this._soundStatusTF.mouseEnabled = true;
            }
            else
            {
               this._soundStatusTF.text = "";
               this._soundStatusTF.visible = false;
            }
            if(this._soundStatusInterval)
            {
               clearInterval(this._soundStatusInterval);
            }
         }
         else
         {
            this._soundStatusTF.text = "GENERATING SOUNDS: " + Math.floor(SoundManager.soundGenerationPercent * 100) + "%";
            this._soundStatusTF.visible = true;
         }
      }
      
      protected function updatePlayTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(PlayTimeCounter.mainInstance != null)
         {
            _loc1_ = PlayTimeCounter.mainInstance.secondsCounted;
            if(this._playtimeText != null && (this._prevSecondsCounted != _loc1_ || this._prevComplete != PlayTimeCounter.mainInstance.complete))
            {
               this._prevSecondsCounted = _loc1_;
               this._prevComplete = PlayTimeCounter.mainInstance.complete;
               if(PlayTimeCounter.timeLimit == 0)
               {
                  this._playtimeText.htmlText = StringUtils.timeInMinutes(this._prevSecondsCounted);
               }
               else
               {
                  _loc2_ = Math.max(0,PlayTimeCounter.timeLimit - this._prevSecondsCounted);
                  _loc3_ = StringUtils.timeInMinutes(_loc2_);
                  if(this._prevComplete && _loc2_ > 0)
                  {
                     this._playtimeText.htmlText = "<font color=\"#00ff66\">" + _loc3_ + "</font>";
                  }
                  else if(_loc2_ < 20)
                  {
                     this._playtimeText.htmlText = "<font color=\"#ff3300\">" + _loc3_ + "</font>";
                  }
                  else
                  {
                     this._playtimeText.htmlText = _loc3_;
                  }
               }
            }
         }
      }
      
      protected function updatePlayScore() : void
      {
         var _loc1_:int = EventHandler.totalScore + this._simulation.events.score;
         if(PlayTimeCounter.scoreLimit > 0 && _loc1_ >= PlayTimeCounter.scoreLimit)
         {
            this._playtimeText.htmlText = "<font color=\"#00ff66\">" + _loc1_ + "</font>";
         }
         else
         {
            this._playtimeText.htmlText = !isNaN(_loc1_) ? _loc1_ + "" : "0";
         }
      }
      
      public function allowCopying() : void
      {
         if(this._copyButton)
         {
            this._copyClip.visible = true;
            this._copyButton.addEventListener(MouseEvent.CLICK,this.onCopyButtonClicked,false,0,true);
         }
      }
      
      protected function onCopyButtonClicked(param1:MouseEvent) : void
      {
         System.setClipboard(this._simulation.model.toString());
         this._copyClip.gotoAndPlay(2);
      }
      
      protected function onSoundToggleButtonClicked(param1:MouseEvent) : void
      {
         SoundManager.hasSound = !SoundManager.hasSound;
         if(SoundManager.hasSound)
         {
            this._soundToggle.gotoAndStop(1);
         }
         else
         {
            this._soundToggle.gotoAndStop(2);
         }
         if(SoundManager.hasSound && this._simulation.environment.vMusic != "")
         {
            Simulation.sounds.pauseSong();
            Simulation.sounds.resumeSong();
         }
      }
      
      public function end() : void
      {
         if(this._soundStatusInterval)
         {
            clearInterval(this._soundStatusInterval);
            this._soundStatusInterval = 0;
         }
         if(this._soundToggleButton)
         {
            this._soundToggleButton.removeEventListener(MouseEvent.CLICK,this.onSoundToggleButtonClicked);
            this._soundToggleButton = null;
         }
         if(this._simulation)
         {
            if(this._simulation.view)
            {
               this._simulation.view.removeEventListener(Event.RESIZE,this.onResize);
            }
            if(this._simulation.events)
            {
               this._simulation.events.removeEventListener(States.ACTION_ADDLIFE,this.onStatus);
               this._simulation.events.removeEventListener(States.ACTION_ENDGAME,this.onStatus);
               this._simulation.events.removeEventListener(States.ACTION_LOSELIFE,this.onStatus);
               this._simulation.events.removeEventListener(States.ACTION_PENALTY,this.onStatus);
               this._simulation.events.removeEventListener(States.ACTION_SCORE,this.onStatus);
            }
         }
         if(this._clockTimer)
         {
            this._clockTimer.removeEventListener(TimerEvent.TIMER,this.updateClock);
            this._clockTimer.stop();
            this._clockTimer = null;
         }
         if(Boolean(this._clip) && Boolean(this._clip.parent))
         {
            this._clip.parent.removeChild(this._clip);
         }
         this._lifeTF = this._penaltyTF = this._scoreTF = this._levelTF = this._timerTF = this._soundStatusTF = null;
         this._levelClip = this._timerClip = this._logo = null;
         this._topBar = this._taskNotice = this._bottomBar = this._bottomBarBackground = this._soundToggle = this._copyClip = null;
         this._helpButton = this._retryButton = this._soundToggleButton = this._copyButton = null;
         this._clip = null;
      }
      
      public function get helpButton() : SimpleButton
      {
         return this._helpButton;
      }
      
      public function get retryButton() : SimpleButton
      {
         return this._retryButton;
      }
   }
}

