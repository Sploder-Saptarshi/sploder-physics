package com.sploder.asui
{
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class Container extends Component
   {
      private var _alt:String = "";
      
      protected var _clip:DisplayObject;
      
      protected var _altTimes:int = 0;
      
      public function Container(param1:Sprite, param2:DisplayObject = null, param3:String = "", param4:Position = null, param5:Style = null)
      {
         super();
         this.init_Container(param1,param2,param3,param4,param5);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get alt() : String
      {
         return this._alt;
      }
      
      public function set alt(param1:String) : void
      {
         this._alt = param1;
      }
      
      public function get clip() : DisplayObject
      {
         return this._clip;
      }
      
      public function set clip(param1:DisplayObject) : void
      {
         if(this._clip != null && this._clip.parent == _mc)
         {
            _mc.removeChild(this._clip);
         }
         this._clip = param1;
         if(this._clip is DisplayObject)
         {
            _mc.addChild(this._clip);
         }
      }
      
      private function init_Container(param1:Sprite, param2:DisplayObject = null, param3:String = "", param4:Position = null, param5:Style = null) : void
      {
         super.init(param1,param4,param5);
         _type = "container";
         this._clip = param2;
         if(this._clip != null)
         {
            _width = this._clip.width;
            _height = this._clip.height;
         }
         if(param3.length > 0)
         {
            this._alt = param3;
         }
      }
      
      override public function create() : void
      {
         super.create();
         if(this._clip != null)
         {
            _mc.addChild(this._clip);
         }
         if(this._clip != null && this._clip["btn"] != undefined)
         {
            if(this._clip["btn"] is SimpleButton)
            {
               connectSimpleButton(this._clip["btn"]);
            }
            if(this._clip["btn"] is Sprite)
            {
               connectButton(this._clip["btn"]);
            }
         }
      }
      
      override protected function onRollOver(param1:MouseEvent = null) : void
      {
         super.onRollOver(param1);
         ++this._altTimes;
         if(this._alt.length > 0 && this._altTimes <= 7)
         {
            Tagtip.showTag(this._alt);
         }
      }
      
      override protected function onRollOut(param1:MouseEvent = null) : void
      {
         super.onRollOut(param1);
         Tagtip.hideTag();
      }
   }
}

