package com.sploder.asui
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class Prompt extends Sprite
   {
      public static var mainInstance:Prompt;
      
      public static var buttonTexts:Dictionary;
      
      public static var tweener:TweenManager;
      
      public static var defaultMessage:String = "";
      
      public static var permaMessage:String = "";
      
      protected var _cell:Cell;
      
      protected var _message:HTMLField;
      
      public var style:Style;
      
      public var tween:Boolean = true;
      
      public var promptWidth:int = 580;
      
      public var promptHeight:int = 45;
      
      public var promptRound:int = 0;
      
      public var promptTopMargin:int = 22;
      
      public var align:String = "center";
      
      public function Prompt()
      {
         super();
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
      }
      
      public static function prompt(param1:String = "") : void
      {
         if(permaMessage.length)
         {
            mainInstance.show(permaMessage);
            return;
         }
         if(Boolean(mainInstance) && Boolean(param1.length))
         {
            mainInstance.show(param1);
         }
         else if(Boolean(mainInstance) && Boolean(defaultMessage.length))
         {
            mainInstance.show(defaultMessage);
         }
         else if(mainInstance)
         {
            mainInstance.hide();
         }
      }
      
      public static function connectButton(param1:InteractiveObject, param2:String) : void
      {
         if(param1)
         {
            param1.addEventListener(MouseEvent.ROLL_OVER,onButtonOver,false,0,true);
            param1.addEventListener(MouseEvent.ROLL_OUT,onButtonOut);
            if(buttonTexts == null)
            {
               buttonTexts = new Dictionary(true);
            }
            buttonTexts[param1] = param2;
         }
      }
      
      public static function onButtonOver(param1:MouseEvent) : void
      {
         if(buttonTexts[param1.target])
         {
            prompt(buttonTexts[param1.target]);
         }
      }
      
      public static function onButtonOut(param1:MouseEvent) : void
      {
         if(permaMessage.length)
         {
            mainInstance.show(permaMessage);
            return;
         }
         if(Boolean(mainInstance) && Boolean(defaultMessage.length))
         {
            mainInstance.show(defaultMessage);
         }
         else if(mainInstance)
         {
            mainInstance.hide();
         }
      }
      
      protected function init(param1:Event = null) : void
      {
         if(param1)
         {
            stage.removeEventListener(Event.ADDED_TO_STAGE,this.init);
         }
         if(tweener == null)
         {
            tweener = new TweenManager(true);
         }
         this._cell = new Cell(this,this.promptWidth,this.promptHeight,true,false,this.promptRound,null,this.style);
         this._cell.mouseEnabled = false;
         this._message = new HTMLField(null,"<p align=\"" + this.align + "\">Watch this space for instructions as you use the game creator.</p>",this.promptWidth,false,new Position({"margin_top":this.promptTopMargin}),this.style);
         this._cell.addChild(this._message);
         if(this.tween)
         {
            this._cell.y = 0 - this._cell.height;
         }
         mainInstance = this;
      }
      
      public function show(param1:String) : void
      {
         if(param1.length)
         {
            this._message.value = "<p align=\"" + this.align + "\"><b>" + param1 + "</b></p>";
         }
         if(this.tween)
         {
            tweener.removeTweensOnObject(this._cell);
            tweener.createTween(this._cell,"y",this._cell.y,0,0.5,false,false,0,0,Tween.EASE_OUT,Tween.STYLE_CUBIC,null,this.hide);
         }
      }
      
      public function hide(param1:Tween = null) : void
      {
         if(param1)
         {
            tweener.removeTweensOnObject(this._cell);
            tweener.createTween(this._cell,"y",this._cell.y,0 - this._cell.height,0.5,false,false,0,!!param1 ? 3 : 0,Tween.EASE_IN,Tween.STYLE_CUBIC);
         }
         else
         {
            this._message.value = "";
         }
      }
   }
}

