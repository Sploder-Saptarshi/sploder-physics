package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class BButton extends Component implements IComponent
   {
      protected var _textLabel:String = "";
      
      protected var _labelAlign:Number;
      
      protected var _alt:String = "";
      
      protected var _icon:Array;
      
      protected var _label:Object;
      
      protected var _labelToggled:Object;
      
      protected var _iconToggled:Array;
      
      protected var _button_mc:Sprite;
      
      protected var _btn:Sprite;
      
      protected var _btn_tf:TextField;
      
      protected var _btn_icon:Sprite;
      
      protected var _btn_icon_first:Boolean = true;
      
      protected var _btn_inactive:Sprite;
      
      protected var _btn_icon_inactive:Sprite;
      
      protected var _btn_selected:Sprite;
      
      protected var _tabMode:Boolean = false;
      
      protected var _groupMode:Boolean = false;
      
      protected var _selected:Boolean = false;
      
      protected var _droop:Boolean = false;
      
      public var tabSide:int = -1;
      
      public var forceWidth:Boolean = false;
      
      public var extraWidth:int = 0;
      
      public var linkedButton:BButton;
      
      protected var _valueX:Number = 0;
      
      protected var _valueY:Number = 0;
      
      public var reselectable:Boolean = false;
      
      public function BButton(param1:Sprite = null, param2:Object = null, param3:int = -1, param4:Number = NaN, param5:Number = NaN, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Position = null, param10:Style = null, param11:Boolean = false)
      {
         super();
         this.init_BButton(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
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
      
      protected function init_BButton(param1:Sprite = null, param2:Object = null, param3:int = -1, param4:Number = NaN, param5:Number = NaN, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Position = null, param10:Style = null, param11:Boolean = false) : void
      {
         super.init(param1,param9,param10);
         _type = "button";
         if(typeof param2 == "string")
         {
            this._textLabel = String(param2);
         }
         else if(param2 is Array)
         {
            this._icon = param2 as Array;
         }
         else if(param2 is Object)
         {
            if(param2.text)
            {
               this._textLabel = param2.text;
               if(param2.icon is Array)
               {
                  this._icon = param2.icon;
               }
               this._btn_icon_first = param2.first != "false";
               this._label = param2;
               if(Boolean(param2.iconToggled) || Boolean(param2.textToggled))
               {
                  this._labelToggled = {
                     "icon":param2.iconToggled,
                     "text":param2.textToggled
                  };
               }
            }
            else
            {
               if(param2.icon is Array)
               {
                  this._icon = param2.icon;
               }
               if(param2.iconToggled is Array)
               {
                  this._iconToggled = param2.iconToggled;
               }
            }
         }
         this._labelAlign = param3 != -1 ? param3 : Position.ALIGN_CENTER;
         _width = param4;
         _height = param5;
         this._tabMode = param6;
         this._groupMode = param7;
         _draggable = param8;
         this._droop = param11;
      }
      
      override public function create() : void
      {
         super.create();
         if(this._textLabel.length > 0 && this._label == null)
         {
            this._button_mc = Create.button(_mc,this._textLabel,this._labelAlign,_width,_height,this._tabMode,this._groupMode,false,this._labelToggled,_style,this.forceWidth,this.extraWidth,this._droop);
         }
         else if(this._label != null)
         {
            this._button_mc = Create.button(_mc,this._label,this._labelAlign,_width,_height,this._tabMode,this._groupMode,false,this._labelToggled,_style,this.forceWidth,this.extraWidth,this._droop);
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
            this._button_mc = Create.hitArea(_mc,this._icon,_width,_height,false,this._iconToggled,_style,this._icon != null && this.tabSide == -1,this.tabSide);
         }
         this._btn = this._button_mc.getChildByName("button_btn") as Sprite;
         this._btn_tf = this._button_mc.getChildByName("_buttontext") as TextField;
         this._btn_selected = this._button_mc.getChildByName("button_selected") as Sprite;
         this._btn_inactive = this._button_mc.getChildByName("button_inactive") as Sprite;
         this._btn_icon = _mc.getChildByName("icon") as Sprite;
         this._btn_icon_inactive = _mc.getChildByName("icon_inactive") as Sprite;
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
         if(draggable)
         {
            addEventListener(EVENT_PRESS,this.startDrag);
            addEventListener(EVENT_RELEASE,this.stopDrag);
            addEventListener(EVENT_DRAG,this.onDrag);
         }
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
         if(this._btn_tf != null)
         {
            this._btn_tf.visible = true;
         }
         if(this._btn_icon != null)
         {
            this._btn_icon.visible = true;
         }
         if(this._btn_icon_inactive != null)
         {
            this._btn_icon_inactive.visible = false;
         }
         this._btn_inactive.visible = false;
         this._btn_selected.visible = false;
      }
      
      override public function disable(param1:Event = null) : void
      {
         super.disable();
         this._btn.visible = false;
         if(this._btn_tf != null)
         {
            this._btn_tf.visible = false;
         }
         if(this._btn_icon != null)
         {
            this._btn_icon.visible = false;
         }
         if(this._btn_icon_inactive != null)
         {
            this._btn_icon_inactive.visible = true;
         }
         this._btn_inactive.visible = true;
         this._btn_selected.visible = false;
         Tagtip.hideTag();
      }
      
      public function select() : void
      {
         if(_enabled)
         {
            this._selected = true;
            if(_parentCell == null || Cell.focused != _parentCell && _parentCell.parentCell != Cell.focused)
            {
               Cell.focused = null;
            }
            this._btn.visible = false;
            this._btn_inactive.visible = false;
            this._btn_selected.visible = true;
            if(this._btn_icon_inactive != null)
            {
               this._btn_icon_inactive.visible = false;
            }
            dispatchEvent(new Event(EVENT_FOCUS));
         }
      }
      
      public function deselect() : void
      {
         if(_enabled)
         {
            this._selected = false;
            this._btn.visible = true;
            this._btn_inactive.visible = false;
            this._btn_selected.visible = false;
            if(this._groupMode && this._btn_icon_inactive != null)
            {
               this._btn_icon_inactive.visible = true;
            }
            dispatchEvent(new Event(EVENT_BLUR));
            Tagtip.hideTag();
         }
      }
      
      protected function rollover(param1:Event = null, param2:Boolean = false) : void
      {
         this._btn.alpha = 0.3;
         if(!param2 && this._alt && this._alt.length > 0)
         {
            Tagtip.showTag(this._alt);
         }
         if(!param2 && Boolean(this.linkedButton))
         {
            this.linkedButton.rollover(param1,true);
         }
      }
      
      protected function rollout(param1:Event = null, param2:Boolean = false) : void
      {
         this._btn.alpha = 0;
         Tagtip.hideTag();
         if(!param2 && Boolean(this.linkedButton))
         {
            this.linkedButton.rollout(param1,true);
         }
      }
      
      protected function startDrag(param1:Event = null) : void
      {
         var _loc2_:Object = this;
         mainStage.addEventListener(Event.ENTER_FRAME,this.onDragMC,false,0,true);
         _mc.startDrag(false,new Rectangle(0,0,parentCell.width - width,parentCell.height - height));
      }
      
      protected function onDragMC(param1:Event) : void
      {
         dispatchEvent(new Event(EVENT_DRAG));
      }
      
      protected function onDrag(param1:Event) : void
      {
         if(parentCell.width - width <= 0)
         {
            this._valueX = 1;
         }
         else
         {
            this._valueX = _mc.x / (parentCell.width - width);
         }
         if(parentCell.height - height <= 0)
         {
            this._valueY = 1;
         }
         else
         {
            this._valueY = _mc.y / (parentCell.height - height);
         }
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      protected function stopDrag(param1:Event = null) : void
      {
         mainStage.removeEventListener(Event.ENTER_FRAME,this.onDrag);
         mainStage.removeEventListener(Event.ENTER_FRAME,this.onDragMC);
         _mc.stopDrag();
      }
      
      public function addOnClick(param1:Function) : void
      {
         addEventListener(EVENT_CLICK,param1,false,0,true);
      }
   }
}

