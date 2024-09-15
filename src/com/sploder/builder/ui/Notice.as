package com.sploder.builder.ui
{
   import com.sploder.asui.Cell;
   import com.sploder.asui.Clip;
   import com.sploder.asui.HTMLField;
   import com.sploder.asui.Position;
   import com.sploder.asui.Style;
   import com.sploder.asui.Tween;
   import com.sploder.asui.TweenManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Notice extends Sprite
   {
      public static var tweener:TweenManager;
      
      protected var _cell:Cell;
      
      protected var _message:HTMLField;
      
      public var style:Style;
      
      public var xoffset:int = 0;
      
      public var icon:String = "";
      
      public function Notice()
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
      
      protected function init(param1:Event = null) : void
      {
         var _loc2_:Position = null;
         var _loc3_:Clip = null;
         if(param1)
         {
            stage.removeEventListener(Event.ADDED_TO_STAGE,this.init);
         }
         if(tweener == null)
         {
            tweener = new TweenManager(true);
         }
         this._cell = new Cell(this,stage.stageWidth * 0.6,30,true,true,10,new Position(null,-1,Position.PLACEMENT_ABSOLUTE),this.style);
         this._cell.collapse = true;
         this._cell.x = stage.stageWidth * 0.2 + this.xoffset;
         this._cell.y = stage.stageHeight;
         this._cell.mc.addEventListener(MouseEvent.CLICK,this.onClick);
         if(this.icon == "")
         {
            this._message = new HTMLField(null,"<h1><p align=\"center\">Are you sure you want to do this?</p></h1>",NaN,true,new Position({"margins":"10 30 0 30"}),this.style);
            this._cell.addChild(this._message);
         }
         else
         {
            _loc2_ = new Position({"margins":"9 0 0 20"},-1,Position.PLACEMENT_FLOAT);
            _loc3_ = new Clip(null,this.icon,Clip.EMBED_SMART,40,40,Clip.SCALEMODE_FILL,"",false,"",_loc2_,this.style);
            this._cell.addChild(_loc3_);
            this._message = new HTMLField(null,"<h1><p align=\"left\">Are you sure you want to do this?</p></h1>",this._cell.width - 100,true,new Position({
               "margins":"10 30 0 10",
               "placement":Position.PLACEMENT_FLOAT
            }),this.style);
            this._cell.addChild(this._message);
         }
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         tweener.removeTweensOnObject(this._cell);
         tweener.createTween(this._cell,"y",this._cell.y,stage.stageHeight,0.25,false,false,0,0,Tween.EASE_IN,Tween.STYLE_EXPO);
      }
      
      public function show(param1:String) : void
      {
         if(param1.length)
         {
            if(this.icon == "")
            {
               this._message.value = "<h1><p align=\"center\">" + param1 + "</p></h1>";
            }
            else
            {
               this._message.value = "<h1><p align=\"left\">" + param1 + "</p></h1>";
            }
            this._cell.update();
         }
         tweener.createTween(this._cell,"y",this._cell.y,stage.stageHeight - this._cell.height - 40,0.5,false,false,0,0,Tween.EASE_OUT,Tween.STYLE_CUBIC,null,this.hide);
      }
      
      public function hide(param1:Tween = null) : void
      {
         tweener.createTween(this._cell,"y",this._cell.y,stage.stageHeight,0.5,false,false,0,3000 + this._message.value.length * 20,Tween.EASE_IN,Tween.STYLE_CUBIC);
      }
   }
}

