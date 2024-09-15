package com.sploder.game.morph
{
   import com.sploder.game.ViewSprite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class Morph extends Sprite
   {
      protected var _clip:ViewSprite;
      
      protected var _startTime:uint;
      
      protected var _morphTime:uint;
      
      public function Morph(param1:ViewSprite, param2:uint = 990, param3:Boolean = true)
      {
         super();
         this.init(param1,param2,param3);
      }
      
      protected function init(param1:ViewSprite, param2:uint = 990, param3:Boolean = true) : void
      {
         this._clip = param1;
         this._morphTime = param2;
         if(this._clip != null && Boolean(this._clip.parent))
         {
            x = this._clip.x;
            y = this._clip.y;
            if(param3)
            {
               if(stage)
               {
                  this.startMorph();
               }
               else
               {
                  addEventListener(Event.ADDED_TO_STAGE,this.startMorph);
               }
            }
         }
      }
      
      public function startMorph(param1:Event = null) : void
      {
         if(param1)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.startMorph);
         }
         if(stage)
         {
            stage.addEventListener(Event.ENTER_FRAME,this.doMorph,false,0,true);
         }
         this._startTime = getTimer();
      }
      
      protected function doMorph(param1:Event) : void
      {
         if(getTimer() - this._startTime > this._morphTime)
         {
            this.completeMorph();
         }
      }
      
      protected function completeMorph() : void
      {
         if(stage)
         {
            stage.removeEventListener(Event.ENTER_FRAME,this.doMorph);
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

