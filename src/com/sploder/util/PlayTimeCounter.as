package com.sploder.util
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PlayTimeCounter
   {
      public static var mainInstance:PlayTimeCounter;
      
      public static var showTime:Boolean = false;
      
      public static var timeLimit:int = 0;
      
      public static var scoreLimit:int = 0;
      
      private var _timer:Timer;
      
      private var _running:Boolean = false;
      
      public var complete:Boolean = false;
      
      private var _secondsCounted:int = 0;
      
      public function PlayTimeCounter()
      {
         super();
      }
      
      public function init() : PlayTimeCounter
      {
         mainInstance = this;
         if(this._timer == null)
         {
            this._timer = new Timer(1000,0);
            this._timer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
            this._timer.start();
         }
         return this;
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         if(this._running)
         {
            ++this._secondsCounted;
         }
      }
      
      public function get secondsCounted() : int
      {
         return this._secondsCounted;
      }
      
      public function reset() : void
      {
         this._running = false;
         this.complete = false;
         this._secondsCounted = 0;
      }
      
      public function pause() : void
      {
         this._running = false;
      }
      
      public function resume() : void
      {
         this._running = true;
      }
      
      public function end() : void
      {
         if(this._timer != null)
         {
            this._timer.stop();
            this._timer = null;
         }
      }
   }
}

