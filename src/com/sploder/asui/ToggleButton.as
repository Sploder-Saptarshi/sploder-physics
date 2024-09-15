package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ToggleButton extends Component implements IComponent
   {
      private var _textLabel:String = "";
      
      private var _textLabelToggled:String = "";
      
      private var _labelAlign:Number;
      
      private var _alt:String = "";
      
      private var _toggledAlt:String = "";
      
      private var _icon:Array;
      
      private var _iconToggled:Array;
      
      private var _button_mc:Sprite;
      
      private var _btn:Sprite;
      
      private var _btn_inactive:Sprite;
      
      private var _btn_selected:Sprite;
      
      private var _btn_icon:Sprite;
      
      private var _toggled:Boolean = false;
      
      private var _valueX:Number = 0;
      
      private var _valueY:Number = 0;
      
      public function ToggleButton(param1:Sprite, param2:Object, param3:Object = null, param4:Boolean = false, param5:int = -1, param6:Number = NaN, param7:Number = NaN, param8:Position = null, param9:Style = null)
      {
         super();
         this.init_ToggleButton(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get button() : Sprite
      {
         return this._btn;
      }
      
      public function get textLabel() : String
      {
         return this._textLabel;
      }
      
      public function get alt() : String
      {
         return this._alt;
      }
      
      public function set alt(param1:String) : void
      {
         this._alt = param1;
      }
      
      public function get toggledAlt() : String
      {
         return this._toggledAlt;
      }
      
      public function set toggledAlt(param1:String) : void
      {
         this._toggledAlt = param1;
      }
      
      override public function get value() : String
      {
         return super.value != null ? super.value : this._textLabel;
      }
      
      public function get valueX() : Number
      {
         return this._valueX;
      }
      
      public function get valueY() : Number
      {
         return this._valueY;
      }
      
      public function set valueX(param1:Number) : void
      {
         this._valueX = Math.max(0,Math.min(1,param1));
         _mc.x = this._valueX * (parentCell.width - width);
      }
      
      public function set valueY(param1:Number) : void
      {
         this._valueY = Math.max(0,Math.min(1,param1));
         _mc.y = this._valueY * (parentCell.height - height);
      }
      
      public function get toggled() : Boolean
      {
         return this._toggled;
      }
      
      private function init_ToggleButton(param1:Sprite, param2:Object, param3:Object = null, param4:Boolean = false, param5:int = -1, param6:Number = NaN, param7:Number = NaN, param8:Position = null, param9:Style = null) : void
      {
         super.init(param1,param8,param9);
         _type = "togglebutton";
         if(typeof param2 == "string")
         {
            this._textLabel = String(param2);
         }
         else if(param2 is Array)
         {
            this._icon = param2 as Array;
         }
         if(typeof param3 == "string")
         {
            this._textLabelToggled = String(param3);
         }
         else if(param3 is Array)
         {
            this._iconToggled = param3 as Array;
         }
         this._labelAlign = param5 != -1 ? param5 : Position.ALIGN_CENTER;
         _width = param6;
         _height = param7;
         this._toggled = param4;
      }
      
      override public function create() : void
      {
         super.create();
         if(this._textLabel.length > 0)
         {
            this._button_mc = Create.button(_mc,this._textLabel,this._labelAlign,_width,_height,false,true,true,this._textLabelToggled,_style);
         }
         else
         {
            if(isNaN(_width))
            {
               _width = 32;
            }
            if(isNaN(_height))
            {
               _height = 32;
            }
            this._button_mc = Create.hitArea(_mc,this._icon,_width,_height,true,this._iconToggled,_style);
         }
         this._btn = this._button_mc.getChildByName("button_btn") as Sprite;
         this._btn_selected = this._button_mc.getChildByName("button_selected") as Sprite;
         this._btn_inactive = this._button_mc.getChildByName("button_inactive") as Sprite;
         this._btn_icon = _mc.getChildByName("icon") as Sprite;
         if(!isNaN(id))
         {
            this._btn.tabIndex = id;
         }
         if(isNaN(_width))
         {
            _width = this._button_mc.width;
         }
         if(isNaN(_height))
         {
            _height = this._button_mc.height;
         }
         connectButton(this._btn,_draggable);
         addEventListener(EVENT_M_OVER,this.rollover);
         addEventListener(EVENT_M_OUT,this.rollout);
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         _width = param1;
         _height = param2;
         _mc.graphics.clear();
         this._btn = null;
         this._btn_inactive = null;
         this._btn_selected = null;
         if(this._button_mc != null && this._button_mc.parent == _mc)
         {
            _mc.removeChild(this._button_mc);
         }
         this._button_mc = null;
         _created = false;
         this.create();
      }
      
      override public function enable(param1:Event = null) : void
      {
         super.enable();
         this._btn.visible = true;
         this._btn_inactive.visible = false;
         this._btn_selected.visible = false;
      }
      
      override public function disable(param1:Event = null) : void
      {
         super.disable();
         this.deselect();
         this._btn.visible = false;
         this._btn_inactive.visible = true;
         this._btn_selected.visible = false;
         Tagtip.hideTag();
      }
      
      public function select() : void
      {
         if(_enabled && !this._toggled)
         {
            this._btn_inactive.visible = false;
            this._btn_selected.visible = true;
            this._btn_selected.mouseEnabled = false;
            if(this._btn_icon != null)
            {
               this._btn_icon.visible = false;
            }
            this._toggled = true;
            dispatchEvent(new Event(EVENT_FOCUS));
         }
      }
      
      public function deselect() : void
      {
         if(_enabled && this._toggled)
         {
            this._btn.visible = true;
            this._btn_inactive.visible = false;
            this._btn_selected.visible = false;
            if(this._btn_icon != null)
            {
               this._btn_icon.visible = true;
            }
            this._toggled = false;
            dispatchEvent(new Event(EVENT_BLUR));
            Tagtip.hideTag();
         }
      }
      
      protected function rollover(param1:Event = null) : void
      {
         this._btn.alpha = 0.3;
         if(this._alt.length > 0 || this._toggledAlt.length > 0)
         {
            if(this.toggled && this._toggledAlt.length > 0)
            {
               Tagtip.showTag(this._toggledAlt);
            }
            else
            {
               Tagtip.showTag(this._alt);
            }
         }
      }
      
      protected function rollout(param1:Event = null) : void
      {
         this._btn.alpha = 0;
         Tagtip.hideTag();
      }
      
      public function addOnClick(param1:Function) : void
      {
         addEventListener(EVENT_CLICK,param1,false,0,true);
      }
      
      override protected function onClick(param1:MouseEvent = null) : void
      {
         if(this._toggled)
         {
            this.deselect();
         }
         else
         {
            this.select();
         }
         super.onClick(param1);
      }
      
      override public function toggle(param1:Event = null) : void
      {
         if(this._toggled)
         {
            this.deselect();
         }
         else
         {
            this.select();
         }
         dispatchEvent(new Event(EVENT_CHANGE));
      }
   }
}

