package com.sploder.game.widgets
{
   import com.sploder.data.User;
   import com.sploder.game.Game;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class Leaderboard
   {
      public var baseURL:String;
      
      public var boardURL:String;
      
      public var boardXML:XML;
      
      public var loadInterval:Number;
      
      public var prev_src:String;
      
      public var rcvXML:XML;
      
      public var destY:Number;
      
      public var scores:Array;
      
      public var container:Sprite;
      
      public function Leaderboard(param1:Sprite)
      {
         super();
         this.container = param1;
         if(User.projectpath != null)
         {
            this.init(User.projectpath + "leaderboard.xml");
         }
      }
      
      private function init(param1:String) : void
      {
         this.boardURL = param1;
         this.boardXML = new XML();
         this.loadBoard();
      }
      
      public function loadBoard() : void
      {
         var _loc1_:String = Main.dataLoader.baseURL;
         if(_loc1_.indexOf("amazon") != -1 || _loc1_.length < 5)
         {
            _loc1_ = "http://www.sploder.com";
         }
         Main.dataLoader.loadXMLData(_loc1_ + "/php/getleaderboard.php?loc=" + this.boardURL + "&nocache=" + getTimer() + "_" + Math.floor(Math.random() * 100000),false,this.onData);
      }
      
      public function onData(param1:Event) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:String = param1.target.data;
         if(_loc2_ != null)
         {
            if(_loc2_ != this.prev_src)
            {
               this.prev_src = _loc2_;
               if(_loc2_ != "<empty />")
               {
                  this.boardXML = new XML("<scores>" + _loc2_ + "</scores>");
                  this.populate();
               }
               else
               {
                  _loc3_ = Game.library.getDisplayObject("noScoresSymbol") as Sprite;
                  this.container.addChild(_loc3_);
               }
            }
         }
      }
      
      public function populate() : void
      {
         var _loc1_:Sprite = null;
         var _loc4_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:Number = 0;
         for each(_loc4_ in this.boardXML..score)
         {
            if(this.container["score_" + _loc2_] == undefined)
            {
               _loc1_ = Game.library.getDisplayObject("scoreSymbol") as Sprite;
               this.container.addChild(_loc1_);
               _loc1_["rank"].text = _loc2_ + 1;
               _loc1_["username"].text = _loc4_.@username.toUpperCase();
               _loc1_["score"].text = this.getTimeString(parseInt(_loc4_.@value,10));
               _loc1_.y = _loc3_ + 2;
               if(_loc2_ % 2 == 1)
               {
                  _loc1_.x += _loc1_.width + 6;
               }
               if(_loc2_ % 2 == 1)
               {
                  _loc3_ += 18;
               }
            }
            _loc2_++;
         }
         if(_loc2_ < 15)
         {
            _loc2_ = _loc2_;
            while(_loc2_ < 16)
            {
               if(this.container["score_" + _loc2_] == undefined)
               {
                  _loc1_ = Game.library.getDisplayObject("scoreSymbolEmpty") as Sprite;
                  this.container.addChild(_loc1_);
                  _loc1_.y = _loc3_ + 2;
                  if(_loc2_ % 2 == 1)
                  {
                     _loc1_.x += _loc1_.width + 6;
                  }
                  if(_loc2_ % 2 == 1)
                  {
                     _loc3_ += 18;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function getTimeString(param1:Number) : String
      {
         var _loc2_:* = "";
         if(param1 > 0)
         {
            if(param1 > 60)
            {
               _loc2_ = Math.floor(param1 / 60) + ":";
            }
            else
            {
               _loc2_ = "0:";
            }
            if(param1 % 60 == 0)
            {
               _loc2_ += "00";
            }
            else if(param1 % 60 < 10)
            {
               _loc2_ += "0" + param1 % 60;
            }
            else
            {
               _loc2_ += "" + param1 % 60;
            }
         }
         else
         {
            _loc2_ = "-:--";
         }
         return _loc2_;
      }
   }
}

