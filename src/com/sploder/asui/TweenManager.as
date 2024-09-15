package com.sploder.asui
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class TweenManager
   {
      private var _tweens:Array;
      
      private var _lastTweenID:int = 0;
      
      private var _lastTweenGroupID:int = 0;
      
      private var _currentTime:int = 0;
      
      public function TweenManager(param1:Boolean = false)
      {
         super();
         this.init(param1);
      }
      
      public function get time() : int
      {
         return this._currentTime;
      }
      
      public function get newTweenID() : int
      {
         ++this._lastTweenID;
         return this._lastTweenID;
      }
      
      public function get currentGroupID() : int
      {
         return this._lastTweenGroupID;
      }
      
      private function init(param1:Boolean = false) : void
      {
         this._tweens = [];
         if(param1)
         {
            this.start();
         }
      }
      
      public function update(param1:Event) : void
      {
         var _loc2_:Tween = null;
         this._currentTime = getTimer();
         for each(_loc2_ in this._tweens)
         {
            _loc2_.ease();
         }
      }
      
      public function align(param1:Array, param2:String, param3:Number) : void
      {
         var _loc4_:Object = null;
         for(_loc4_ in param1)
         {
            _loc4_[param2] = param3;
         }
      }
      
      public function createTween(param1:Object, param2:String, param3:Number = NaN, param4:Number = NaN, param5:Number = 1, param6:Boolean = false, param7:Boolean = false, param8:int = 0, param9:Number = 0, param10:uint = 0, param11:uint = 0, param12:Function = null, param13:Function = null, param14:int = 0) : int
      {
         if(param14 == 0)
         {
            this.advanceGroupID();
         }
         if(param9 == 0)
         {
            this.removeTweenOnObjectWithAttribute(param1,param2);
         }
         this._tweens.push(new Tween(this,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13));
         return this._lastTweenGroupID;
      }
      
      public function createTweens(param1:Array, param2:Object, param3:Object, param4:Number = 1, param5:Boolean = false, param6:Boolean = false, param7:int = 0, param8:Number = 0, param9:uint = 0, param10:uint = 0, param11:Function = null, param12:Function = null) : int
      {
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc16_:Object = null;
         this.advanceGroupID();
         for each(_loc16_ in param1)
         {
            if(_loc16_ != null)
            {
               if(param3 is Array)
               {
                  _loc14_ = int(param1.indexOf(_loc16_));
                  if(param3[_loc14_] != null)
                  {
                     for(_loc15_ in param3[_loc14_])
                     {
                        _loc13_ = param2[_loc14_] != null && !isNaN(param2[_loc14_][_loc15_]) ? Number(param2[_loc14_][_loc15_]) : (!isNaN(_loc16_[_loc15_]) ? Number(_loc16_[_loc15_]) : NaN);
                        this.createTween(_loc16_,_loc15_,_loc13_,param3[_loc14_][_loc15_],param4,param5,param6,param7,param8,param9,param10,param11,param12,this._lastTweenGroupID);
                     }
                  }
               }
               else
               {
                  for(_loc15_ in param3)
                  {
                     _loc13_ = !isNaN(param2[_loc15_]) ? Number(param2[_loc15_]) : (!isNaN(_loc16_[_loc15_]) ? Number(_loc16_[_loc15_]) : NaN);
                     this.createTween(_loc16_,_loc15_,_loc13_,param3[_loc15_],param4,param5,param6,param7,param8,param9,param10,param11,param12,this._lastTweenGroupID);
                  }
               }
            }
         }
         return this._lastTweenGroupID;
      }
      
      private function advanceGroupID() : void
      {
         ++this._lastTweenGroupID;
      }
      
      public function removeTween(param1:Tween) : void
      {
         var _loc2_:Tween = null;
         for each(_loc2_ in this._tweens)
         {
            if(_loc2_.id == param1.id)
            {
               this._tweens.splice(this._tweens.indexOf(_loc2_),1);
               break;
            }
         }
      }
      
      public function removeTweenGroup(param1:int) : void
      {
         var _loc2_:Tween = null;
         for each(_loc2_ in this._tweens)
         {
            if(_loc2_.groupID == param1)
            {
               this._tweens.splice(this._tweens.indexOf(_loc2_),1);
            }
         }
      }
      
      public function removeTweensOnObject(param1:Object) : void
      {
         var _loc2_:Tween = null;
         for each(_loc2_ in this._tweens)
         {
            if(_loc2_.tweenObject == param1)
            {
               this._tweens.splice(this._tweens.indexOf(_loc2_),1);
            }
         }
      }
      
      public function removeTweenOnObjectWithAttribute(param1:Object, param2:String) : void
      {
         var _loc3_:Tween = null;
         for each(_loc3_ in this._tweens)
         {
            if(_loc3_.tweenObject == param1 && _loc3_.attribute == param2)
            {
               this._tweens.splice(this._tweens.indexOf(_loc3_),1);
               break;
            }
         }
      }
      
      public function clearAllTweens() : void
      {
         this._tweens = [];
      }
      
      public function start() : void
      {
         Component.mainStage.addEventListener(Event.ENTER_FRAME,this.update,false,2);
      }
      
      public function stop() : void
      {
         Component.mainStage.removeEventListener(Event.ENTER_FRAME,this.update);
      }
      
      public function end() : void
      {
         this.stop();
         this.clearAllTweens();
      }
      
      public function fadeOutObject(param1:DisplayObject, param2:Number = 1) : void
      {
         var obj:DisplayObject = param1;
         var time:Number = param2;
         this.createTween(obj,"alpha",obj.alpha,0,time,false,false,0,0,0,0,null,function():void
         {
            obj.visible = false;
         });
      }
      
      public function fadeInObject(param1:DisplayObject, param2:Number = 1) : void
      {
         var obj:DisplayObject = param1;
         var time:Number = param2;
         this.createTween(obj,"alpha",obj.alpha,1,time,false,false,0,0,0,0,function():void
         {
            obj.visible = true;
         });
      }
   }
}

