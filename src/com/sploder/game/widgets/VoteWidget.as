package com.sploder.game.widgets
{
   import com.sploder.data.User;
   import com.sploder.game.Game;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class VoteWidget extends MovieClip
   {
      protected var _container:MovieClip;
      
      public var _gameID:String;
      
      public var _sessionID:String;
      
      public var _loggedIn:Boolean;
      
      protected var voteClip:MovieClip;
      
      public var rating:Number;
      
      public var voted:Boolean = false;
      
      public var vote:Number;
      
      protected var _ratingLoader:URLLoader;
      
      protected var _ratingRequest:URLRequest;
      
      protected var _ratingVars:URLVariables;
      
      protected var _voteLoader:URLLoader;
      
      protected var _voteRequest:URLRequest;
      
      protected var _voteVars:URLVariables;
      
      public function VoteWidget(param1:MovieClip)
      {
         super();
         this.init(param1);
      }
      
      protected function init(param1:MovieClip) : void
      {
         this._container = param1;
         this.initFrames();
         this._gameID = User.m;
         this._sessionID = Main.dataLoader.embedParameters.sid;
         if(Main.dataLoader.embedParameters.nu == undefined && Main.dataLoader.embedParameters.onsplodercom == "true")
         {
            this._loggedIn = true;
         }
         else
         {
            this._loggedIn = false;
         }
         if(this._gameID != null)
         {
            if(!isNaN(Game.rating))
            {
               this.rating = Game.rating;
            }
         }
      }
      
      public function setButtonActions() : void
      {
         var _loc2_:Sprite = null;
         var _loc1_:SimpleButton = this._container["activate"];
         if(this._gameID != null)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.onActivateButtonClicked);
            _loc2_ = this._container["currentrating"];
            this.showRating(_loc2_);
         }
         else
         {
            _loc1_.visible = false;
         }
      }
      
      protected function onActivateButtonClicked(param1:MouseEvent) : void
      {
         if(this._loggedIn)
         {
            this._container.play();
         }
         else
         {
            this._container.gotoAndPlay(40);
         }
      }
      
      protected function initFrames() : void
      {
         var _loc1_:FrameLabel = null;
         for each(_loc1_ in this._container.currentLabels)
         {
            this._container.addFrameScript(_loc1_.frame - 1,this.onLabel);
         }
      }
      
      protected function onLabel() : void
      {
         if(this._container == null)
         {
            return;
         }
         var _loc1_:String = this._container.currentLabel;
         switch(_loc1_)
         {
            case "init":
               this._container.stop();
               this.setButtonActions();
               break;
            case "setVote":
               this._container.stop();
               this.setVoteClip(this._container["myvote"]);
               if(this.voted)
               {
                  this.showChoice(this.vote);
               }
               break;
            case "done":
               this._container.stop();
               this.dovote(this.vote);
               break;
            case "warningdone":
               this._container.gotoAndPlay(4);
         }
      }
      
      public function showRating(param1:Sprite) : void
      {
         var i:int = 0;
         var currentRating:Sprite = param1;
         var num:int = Math.floor(this.rating);
         if(num > 0)
         {
            try
            {
               i = 1;
               while(i <= num)
               {
                  currentRating["star" + i].gotoAndStop(3);
                  i++;
               }
               i = num + 1;
               while(i <= 5)
               {
                  currentRating["star" + i].gotoAndStop(1);
                  i++;
               }
               if(this.rating - num == 0.5)
               {
                  currentRating["star" + (num + 1)].gotoAndStop(2);
               }
               currentRating["toprated"].visible = num == 5;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function setRating(param1:Boolean) : void
      {
         if(param1)
         {
         }
      }
      
      public function setVoteClip(param1:MovieClip) : void
      {
         var _loc2_:SimpleButton = null;
         this.voteClip = param1;
         var _loc3_:int = 1;
         while(_loc3_ <= 5)
         {
            _loc2_ = this.voteClip["star" + _loc3_ + "_button"];
            _loc2_.addEventListener(MouseEvent.CLICK,this.onStarClicked);
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onStarRollOver);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onStarRollOut);
            _loc3_++;
         }
      }
      
      protected function onStarClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = parseInt(String(param1.target.name).split("_")[0].split("star")[1]);
         this.vote = _loc2_;
         this._container.play();
      }
      
      protected function onStarRollOver(param1:MouseEvent) : void
      {
         var _loc2_:int = parseInt(String(param1.target.name).split("_")[0].split("star")[1]);
         this.showChoice(_loc2_);
      }
      
      protected function onStarRollOut(param1:MouseEvent) : void
      {
         this.hideChoice();
      }
      
      public function showChoice(param1:int) : void
      {
         var i:int = 0;
         var num:int = param1;
         if(num < 1 || isNaN(num))
         {
            if(this.vote > 0)
            {
               num = this.vote;
            }
            else
            {
               num = 0;
            }
         }
         try
         {
            i = 1;
            while(i <= num)
            {
               this.voteClip["star" + i].gotoAndStop(3);
               i++;
            }
            i = num + 1;
            while(i <= 5)
            {
               this.voteClip["star" + i].gotoAndStop(1);
               i++;
            }
            this.voteClip.toprated.visible = num == 5;
         }
         catch(e:Error)
         {
         }
      }
      
      public function hideChoice() : void
      {
         this.showChoice(this.vote);
      }
      
      public function dovote(param1:int) : void
      {
         var _loc2_:String = null;
         this.voted = true;
         this.vote = param1;
         this.rating = this.vote;
         if(this._gameID != null)
         {
            this._voteVars = new URLVariables();
            this._voteVars.ssid = this._gameID;
            this._voteVars.score = this.vote;
            this._voteVars.PHPSESSID = this._sessionID;
            _loc2_ = Main.dataLoader.baseURL;
            if(_loc2_.indexOf("amazon") != -1 || _loc2_.length < 5)
            {
               _loc2_ = "http://www.sploder.com";
            }
            this._voteRequest = new URLRequest(_loc2_ + "/php/vote.php");
            this._voteRequest.method = "GET";
            this._voteRequest.data = this._voteVars;
            this._voteLoader = new URLLoader();
            this._voteLoader.addEventListener(Event.COMPLETE,this.onVoteRequestSent);
            this._voteLoader.load(this._voteRequest);
         }
      }
      
      protected function onVoteRequestSent(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:String = _loc2_.data;
         if(_loc3_.charAt(0) == "&")
         {
            _loc3_ = _loc3_.replace("&","");
         }
         var _loc4_:URLVariables = new URLVariables();
         _loc4_.decode(_loc3_);
         if(_loc4_.vote_average != null)
         {
            this.rating = parseInt(_loc4_.vote_average);
         }
         this._container.gotoAndPlay(4);
      }
   }
}

