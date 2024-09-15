package com.sploder.asui
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class Component extends EventDispatcher implements IComponent
   {
      public static var mainStage:Stage;
      
      public static var library:Library;
      
      public static var globalStyle:Style;
      
      protected static var _nextID:int = 0;
      
      public static const EVENT_PRESS:String = "event_press";
      
      public static const EVENT_RELEASE:String = "event_release";
      
      public static const EVENT_CLICK:String = "event_click";
      
      public static const EVENT_M_OVER:String = "event_m_over";
      
      public static const EVENT_M_OUT:String = "event_m_out";
      
      public static const EVENT_DRAG:String = "event_drag";
      
      public static const EVENT_MOVE:String = "event_move";
      
      public static const EVENT_DROP:String = "event_drop";
      
      public static const EVENT_HOVER_START:String = "event_hover_start";
      
      public static const EVENT_HOVER_END:String = "event_hover_end";
      
      public static const EVENT_FOCUS:String = "event_focus";
      
      public static const EVENT_BLUR:String = "event_blur";
      
      public static const EVENT_CHANGE:String = "event_change";
      
      public static const EVENT_SELECT:String = "event_select";
      
      public static const EVENT_CREATE:String = "event_create";
      
      public static const EVENT_REMOVE:String = "event_remove";
      
      public static const EVENT_DESTROY:String = "event_destroy";
      
      protected var _id:int = 0;
      
      protected var _type:String = "comp";
      
      public var name:String = "";
      
      protected var _value:String;
      
      protected var _form:Object;
      
      protected var _created:Boolean = false;
      
      protected var _deleted:Boolean = false;
      
      protected var _container:Sprite;
      
      protected var _parentCell:Cell;
      
      protected var _draggable:Boolean;
      
      protected var _position:Position;
      
      public var arranged:Boolean = false;
      
      protected var _mc:Sprite;
      
      protected var _style:Style;
      
      protected var _active:Boolean = true;
      
      protected var _enabled:Boolean = true;
      
      protected var _width:Number = 0;
      
      protected var _height:Number = 0;
      
      protected var _target:Component;
      
      protected var _targetEvent:String;
      
      protected var _targetProperty:String;
      
      public function Component()
      {
         super();
      }
      
      public static function get nextID() : int
      {
         ++_nextID;
         return _nextID;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get value() : String
      {
         return this._value;
      }
      
      public function set value(param1:String) : void
      {
         this._value = param1;
      }
      
      public function get form() : Object
      {
         return this._form;
      }
      
      public function set form(param1:Object) : void
      {
         this._form = param1;
      }
      
      public function get created() : Boolean
      {
         return this._created;
      }
      
      public function get deleted() : Boolean
      {
         return this._deleted;
      }
      
      public function set deleted(param1:Boolean) : void
      {
         this._deleted = param1;
         if(this._deleted)
         {
            dispatchEvent(new Event(EVENT_REMOVE));
         }
      }
      
      public function get container() : Sprite
      {
         return this._container;
      }
      
      public function set container(param1:Sprite) : void
      {
         this._container = param1;
      }
      
      public function get parentCell() : Cell
      {
         return this._parentCell;
      }
      
      public function set parentCell(param1:Cell) : void
      {
         this._parentCell = param1;
         if(this._parentCell != null)
         {
            this._container = this._parentCell.contents;
            this.create();
         }
      }
      
      public function get draggable() : Boolean
      {
         return this._draggable;
      }
      
      public function get position() : Position
      {
         return this._position;
      }
      
      public function set position(param1:Position) : void
      {
         this._position = param1;
      }
      
      public function get mc() : Sprite
      {
         return this._mc;
      }
      
      public function get tabEnabled() : Boolean
      {
         return this._mc.tabChildren;
      }
      
      public function set tabEnabled(param1:Boolean) : void
      {
         this._mc.tabChildren = param1;
      }
      
      public function get mouseEnabled() : Boolean
      {
         return this._mc.mouseEnabled;
      }
      
      public function set mouseEnabled(param1:Boolean) : void
      {
         this._mc.mouseEnabled = this._mc.mouseChildren = param1;
      }
      
      public function get style() : Style
      {
         return this._style;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.enable();
         }
         else
         {
            this.disable();
         }
      }
      
      public function get x() : Number
      {
         return this._mc != null ? this._mc.x : 0;
      }
      
      public function set x(param1:Number) : void
      {
         if(!isNaN(param1) && this._mc != null)
         {
            this._mc.x = param1;
         }
      }
      
      public function get y() : Number
      {
         return this._mc != null ? this._mc.y : 0;
      }
      
      public function set y(param1:Number) : void
      {
         if(!isNaN(param1) && this._mc != null)
         {
            this._mc.y = param1;
         }
      }
      
      public function get zindex() : Number
      {
         return this._position.zindex;
      }
      
      public function get scale() : Number
      {
         return this._mc != null ? this._mc.scaleX : 1;
      }
      
      public function set scale(param1:Number) : void
      {
         if(this._mc != null)
         {
            this._mc.scaleX = this._mc.scaleY = param1;
         }
      }
      
      public function get rotation() : Number
      {
         return this._mc != null ? this._mc.rotation : 0;
      }
      
      public function set rotation(param1:Number) : void
      {
         if(!isNaN(param1) && this._mc != null)
         {
            this._mc.rotation = param1;
         }
      }
      
      public function get visible() : Boolean
      {
         return this._mc.visible;
      }
      
      public function get width() : uint
      {
         return Math.ceil(this._width);
      }
      
      public function get height() : uint
      {
         return Math.ceil(this._height);
      }
      
      protected function init(param1:Sprite, param2:Position = null, param3:Style = null) : void
      {
         this._id = nextID;
         this._container = param1 != null ? param1 : null;
         if(mainStage == null)
         {
            if(!(this._container != null && this._container.stage is Stage))
            {
               throw new Error("ASUILIB ERROR: Please register stage with Component.mainStage");
            }
            mainStage = this._container.stage;
         }
         var _loc4_:Object = {};
         if(this._type == "formfield" || this._type == "htmlfield" || this._type == "combobox" || this._type == "slider" || this._type == "hrule")
         {
            _loc4_.margins = [0,0,15,0];
         }
         this._position = param2 != null ? param2 : new Position(_loc4_);
         this._style = param3 != null ? param3 : (globalStyle != null ? globalStyle : new Style());
      }
      
      public function create() : void
      {
         if(this.created)
         {
            return;
         }
         var _loc1_:Sprite = new Sprite();
         this._mc = Sprite(this._container.addChild(_loc1_));
         this._mc.name = this._type + "_" + this.id;
         this._mc.focusRect = false;
         this._created = true;
      }
      
      protected function onClick(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(EVENT_CLICK,true));
      }
      
      protected function onPress(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(EVENT_PRESS,true));
         if(this._draggable && Component.mainStage != null)
         {
            mainStage.addEventListener(MouseEvent.MOUSE_UP,this.onRelease,false,0,true);
         }
      }
      
      protected function onRelease(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(EVENT_RELEASE,true));
         if(this._draggable && Component.mainStage != null)
         {
            mainStage.removeEventListener(MouseEvent.MOUSE_UP,this.onRelease);
         }
      }
      
      protected function onRollOver(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(EVENT_M_OVER,true));
      }
      
      protected function onRollOut(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(EVENT_M_OUT,true));
      }
      
      public function connect(param1:String, param2:Component, param3:String) : void
      {
         if(this._target != null && this._targetEvent != null)
         {
            this._target.removeEventListener(this._targetEvent,this.onTargetEvent);
         }
         this._target = param2;
         this._targetEvent = param1;
         this._targetProperty = param3;
         if(this._target != null)
         {
            this._target.addEventListener(this._targetEvent,this.onTargetEvent);
            this.onTargetEvent();
         }
      }
      
      public function onTargetEvent(param1:Event = null) : void
      {
         if(typeof this._target[this._targetProperty] == "function")
         {
            if(this._target[this._targetProperty]() != false)
            {
               this.enable();
            }
            else
            {
               this.disable();
            }
         }
         else if(this._target[this._targetProperty] != false)
         {
            this.enable();
         }
         else
         {
            this.disable();
         }
      }
      
      protected function connectButton(param1:Sprite, param2:Boolean = false) : void
      {
         param1.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         if(param2 != true)
         {
            param1.addEventListener(MouseEvent.CLICK,this.onClick);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         }
         else
         {
            param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onPress);
            param1.addEventListener(MouseEvent.MOUSE_UP,this.onRelease);
         }
         param1.buttonMode = true;
      }
      
      protected function connectSimpleButton(param1:SimpleButton, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(param2 != true)
         {
            param1.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            param1.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            param1.addEventListener(MouseEvent.CLICK,this.onClick);
         }
         else
         {
            param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onPress);
            param1.addEventListener(MouseEvent.MOUSE_UP,this.onRelease);
            if(param3)
            {
               param1.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
               param1.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            }
         }
      }
      
      protected function connectTextField(param1:TextField) : void
      {
         param1.addEventListener(Event.CHANGE,this.onTextChange);
         param1.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         param1.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      }
      
      protected function onTextChange(param1:Event) : void
      {
         dispatchEvent(new Event(Component.EVENT_CHANGE));
      }
      
      protected function onFocusIn(param1:FocusEvent) : void
      {
         dispatchEvent(new Event(Component.EVENT_FOCUS));
      }
      
      protected function onFocusOut(param1:FocusEvent) : void
      {
         dispatchEvent(new Event(Component.EVENT_BLUR));
      }
      
      public function enable(param1:Event = null) : void
      {
         this._enabled = true;
      }
      
      public function disable(param1:Event = null) : void
      {
         this._enabled = false;
      }
      
      public function show(param1:Event = null) : void
      {
         this._mc.visible = true;
         dispatchEvent(new Event(EVENT_FOCUS));
      }
      
      public function hide(param1:Event = null) : void
      {
         this._mc.visible = false;
         dispatchEvent(new Event(EVENT_BLUR));
      }
      
      public function toggle(param1:Event = null) : void
      {
         if(this._mc.visible)
         {
            this.hide();
         }
         else
         {
            this.show();
         }
      }
      
      public function destroy() : Boolean
      {
         if(this._mc == null)
         {
            return false;
         }
         if(this._mc.parent != null && this._mc.parent.getChildIndex(this.mc) != -1)
         {
            this._mc.parent.removeChild(this._mc);
         }
         this._mc = null;
         this._deleted = true;
         dispatchEvent(new Event(EVENT_DESTROY));
         return true;
      }
   }
}

