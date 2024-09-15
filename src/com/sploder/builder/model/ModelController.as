package com.sploder.builder.model
{
   import com.sploder.asui.Component;
   import com.sploder.builder.Creator;
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.util.Geom2d;
   import com.sploder.util.Key;
   import flash.display.Graphics;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import nape.*;
   import nape.geom.GeomPoly;
   import nape.geom.GeomVert;
   import nape.geom.Vec2;
   
   public class ModelController
   {
      public static var mainInstance:ModelController;
      
      public static const STATE_IDLE:int = 0;
      
      public static const STATE_CREATING:int = 1;
      
      public static const STATE_EDITING:int = 2;
      
      public static const STATE_COPYING:int = 3;
      
      public static const STATE_SELECTING:int = 4;
      
      public static const STATE_ROTATING:int = 5;
      
      public static const STATE_SIZING:int = 6;
      
      private var _state:int = 0;
      
      private var _subState:String = "";
      
      private var _creator:Creator;
      
      private var _model:Model;
      
      private var _newObject:ModelObject;
      
      private var _selection:ModelSelection;
      
      private var _history:UndoHistory;
      
      private var _prevSelection:ModelObjectContainer;
      
      private var _mouseVector:Point;
      
      private var _dragVector:Point;
      
      public var paintFillColor:int = 10040064;
      
      public var paintLineColor:int = 13395456;
      
      public var paintTexture:int = 0;
      
      public var paintLayer:int = 3;
      
      public var paintOpaque:int = 1;
      
      public var paintScribble:int = 0;
      
      private var _vertexIndex:int = 0;
      
      private var _vertices:Array;
      
      private var px:Number;
      
      private var py:Number;
      
      private var _mouseIsDown:Boolean;
      
      private var _mouseDownTime:int = 0;
      
      private var _mouseDownTimeLast:int = 0;
      
      public var snap:Boolean = true;
      
      private var _clipboard:String = "";
      
      protected var _focusObject:ModelObject;
      
      public function ModelController(param1:Creator)
      {
         super();
         this.init(param1);
      }
      
      public function get clipboard() : String
      {
         return this._clipboard;
      }
      
      public function set clipboard(param1:String) : void
      {
         this._clipboard = param1;
      }
      
      public function get newObject() : ModelObject
      {
         return this._newObject;
      }
      
      public function get selection() : ModelSelection
      {
         return this._selection;
      }
      
      public function get history() : UndoHistory
      {
         return this._history;
      }
      
      public function get mouseVector() : Point
      {
         return this._mouseVector;
      }
      
      public function get dragVector() : Point
      {
         return this._dragVector;
      }
      
      public function get focusObject() : ModelObject
      {
         return this._focusObject;
      }
      
      public function set focusObject(param1:ModelObject) : void
      {
         if(this._focusObject)
         {
            this._focusObject.focused = false;
         }
         this._focusObject = param1;
         ModifierSprite.focusObject = param1;
         if(this._focusObject)
         {
            this._focusObject.focused = true;
         }
      }
      
      protected function init(param1:Creator) : void
      {
         this._creator = param1;
         this._model = this._creator.model;
         mainInstance = this;
         ModifierSprite.focusClass = ModelController;
         this._mouseVector = new Point();
         this._dragVector = new Point();
         this._vertices = [];
         this._model.newObjectContainer.mouseEnabled = this._model.newObjectContainer.mouseChildren = false;
         this._model.newObjectContainer.transform.colorTransform = new ColorTransform(1,0.8,0,1,255,230,0);
         this._model.selectionWindow.mouseEnabled = this._model.selectionWindow.mouseChildren = false;
         this._model.modifiers.addEventListener(Event.SELECT,this.onModifierSelect);
         this._selection = new ModelSelection(this._model,this,this._model.selectionWindow);
         this._history = new UndoHistory(this._model,this);
         this._prevSelection = new ModelObjectContainer();
      }
      
      public function connect() : void
      {
         this._creator.ui.tools.addEventListener(Component.EVENT_CHANGE,this.onToolChange);
         this._creator.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDown);
         this._creator.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
      }
      
      public function createNewObject() : void
      {
         var _loc1_:Point = this._mouseVector;
         this._newObject = new ModelObject();
         this._newObject.clip.suspend();
         this._newObject.origin.x = this.snap ? Math.round(_loc1_.x / 10) * 10 : _loc1_.x;
         this._newObject.origin.y = this.snap ? Math.round(_loc1_.y / 10) * 10 : _loc1_.y;
         this._newObject.props.shape = this._creator.ui.shapes.value;
         this._newObject.props.zlayer = this.paintLayer;
         this.updateObjectFromUI(this._newObject);
         this._model.newObjectContainer.addChild(this._newObject.clip);
         this._newObject.clip.release();
      }
      
      public function createNewModifier(param1:String, param2:ModelObject, param3:ModelObject = null) : void
      {
         var _loc4_:Modifier = null;
         _loc4_ = new Modifier();
         _loc4_.clip.suspend();
         _loc4_.props.type = param1;
         _loc4_.props.parent = param2;
         switch(param1)
         {
            case CreatorUIStates.MODIFIER_SWITCHER:
            case CreatorUIStates.MODIFIER_EMAGNET:
               param3 = null;
               break;
            case CreatorUIStates.MODIFIER_MOTOR:
               param3 = null;
               _loc4_.props.amount = 1;
               if(_loc4_.props.parent.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
               {
                  _loc4_.props.parent.props.constraint = CreatorUIStates.MOVEMENT_PIN;
               }
               break;
            case CreatorUIStates.MODIFIER_ROTATOR:
            case CreatorUIStates.MODIFIER_LAUNCHER:
            case CreatorUIStates.MODIFIER_SELECTOR:
            case CreatorUIStates.MODIFIER_AIMER:
            case CreatorUIStates.MODIFIER_DRAGGER:
            case CreatorUIStates.MODIFIER_CLICKER:
            case CreatorUIStates.MODIFIER_POINTER:
               param3 = null;
               _loc4_.props.amount = 1;
               break;
            case CreatorUIStates.MODIFIER_ARCADEMOVER:
               param3 = null;
               _loc4_.props.amount = 10;
               break;
            case CreatorUIStates.MODIFIER_ADDER:
            case CreatorUIStates.MODIFIER_SPAWNER:
            case CreatorUIStates.MODIFIER_FACTORY:
               _loc4_.props.amount = 1000;
               _loc4_.props.amount2 = 0;
               _loc4_.props.amount3 = 10;
            case CreatorUIStates.MODIFIER_PUSHER:
            case CreatorUIStates.MODIFIER_MOVER:
            case CreatorUIStates.MODIFIER_JUMPER:
               param3 = null;
               _loc4_.props.childOffset.y = -50;
               break;
            case CreatorUIStates.MODIFIER_THRUSTER:
            case CreatorUIStates.MODIFIER_PROPELLER:
               param3 = null;
               _loc4_.props.childOffset.y = -50;
               _loc4_.props.amount = 90;
               break;
            case CreatorUIStates.MODIFIER_SLIDER:
               param3 = null;
               _loc4_.props.childOffset.x = -50;
               break;
            case CreatorUIStates.MODIFIER_UNLOCKER:
            case CreatorUIStates.MODIFIER_GEARJOINT:
            case CreatorUIStates.MODIFIER_PINJOINT:
            case CreatorUIStates.MODIFIER_DAMPEDSPRING:
            case CreatorUIStates.MODIFIER_LOOSESPRING:
               _loc4_.props.childOffset.y = -100;
               break;
            case CreatorUIStates.MODIFIER_GROOVEJOINT:
               _loc4_.props.parentOffset.x = -100;
               _loc4_.props.childOffset.x = 100;
               break;
            case CreatorUIStates.MODIFIER_ELEVATOR:
               _loc4_.props.parentOffset.y = -100;
               _loc4_.props.childOffset.y = 100;
         }
         if(this._selection.length == 2 && (param1 == CreatorUIStates.MODIFIER_DAMPEDSPRING || param1 == CreatorUIStates.MODIFIER_LOOSESPRING || param1 == CreatorUIStates.MODIFIER_PINJOINT))
         {
            param3 = this._selection.objects[0] == param2 ? this._selection.objects[1] : this._selection.objects[0];
         }
         if(this._selection.length == 2 && param1 == CreatorUIStates.MODIFIER_UNLOCKER)
         {
            param3 = this._focusObject == this._selection.objects[0] ? this._selection.objects[1] : this._selection.objects[0];
            _loc4_.props.childOffset.x = _loc4_.props.childOffset.y = 0;
         }
         if(param3)
         {
            _loc4_.props.child = param3;
            _loc4_.props.setChildOffset(0,0);
         }
         this._model.modifiers.addObject(_loc4_);
         _loc4_.clip.release();
      }
      
      public function addModifiersParentOnly(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._selection.length)
         {
            this.createNewModifier(param1,this._selection.objects[_loc2_]);
            _loc2_++;
         }
      }
      
      public function addModifiersParentChildStep(param1:String) : void
      {
         if(this._creator.ui.tools.value == CreatorUIStates.TOOL_WINDOW)
         {
            this._selection.sortSpatially();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._selection.length - 1)
         {
            this.createNewModifier(param1,this._selection.objects[_loc2_],this._selection.objects[_loc2_ + 1]);
            _loc2_++;
         }
      }
      
      public function addModifiersParentChildSpoke(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._selection.length)
         {
            if(this._selection.objects[_loc2_] != this._focusObject)
            {
               this.createNewModifier(param1,this._focusObject,this._selection.objects[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function updateObjectFromUI(param1:ModelObject) : void
      {
         param1.props.constraint = this._creator.ui.constraints.value;
         param1.props.material = this._creator.ui.materials.value;
         param1.props.strength = this._creator.ui.strengths.value;
         param1.props.locked = this._creator.ui.moveLock.toggled;
         param1.props.color = ModelObjectSprite.getFillColor(param1);
         param1.props.line = ModelObjectSprite.getLineColor(param1);
         param1.props.opaque = param1.props.material == CreatorUIStates.MATERIAL_GLASS ? 0 : 1;
      }
      
      public function updateSelection(param1:String) : void
      {
         var _loc2_:ModelObject = null;
         this._history.record();
         var _loc3_:int = int(this._selection.length);
         while(_loc3_--)
         {
            _loc2_ = this._selection.objects[_loc3_];
            switch(param1)
            {
               case CreatorUIStates.MOVEMENT:
                  _loc2_.props.constraint = this._creator.ui.constraints.value;
                  break;
               case CreatorUIStates.MATERIAL:
                  _loc2_.props.material = this._creator.ui.materials.value;
                  break;
               case CreatorUIStates.STRENGTH:
                  _loc2_.props.strength = this._creator.ui.strengths.value;
                  break;
               case CreatorUIStates.LOCK:
                  _loc2_.props.locked = this._creator.ui.moveLock.toggled;
                  break;
               case CreatorUIStates.DECORATE_FILL:
                  if(this._creator.ui.fills.value == CreatorUIStates.NONE)
                  {
                     _loc2_.props.color = -1;
                  }
                  else
                  {
                     _loc2_.props.color = parseInt(this._creator.ui.fills.value);
                  }
                  break;
               case CreatorUIStates.DECORATE_LINE:
                  if(this._creator.ui.lines.value == CreatorUIStates.NONE)
                  {
                     _loc2_.props.line = -1;
                  }
                  else if(this._creator.ui.lines.value == CreatorUIStates.GLOW)
                  {
                     _loc2_.props.line = -2;
                  }
                  else
                  {
                     _loc2_.props.line = parseInt(this._creator.ui.lines.value);
                  }
                  break;
               case CreatorUIStates.TEXTURE:
                  _loc2_.props.texture = this.paintTexture;
                  _loc2_.props.graphic = 0;
                  _loc2_.props.graphic_version = 0;
                  _loc2_.props.graphic_flip = 0;
                  _loc2_.props.animation = 0;
                  break;
               case CreatorUIStates.DECORATE_ZLAYER:
                  _loc2_.props.zlayer = this.paintLayer;
                  this._model.zSort();
                  break;
               case CreatorUIStates.OPAQUE:
                  _loc2_.props.opaque = this.paintOpaque;
                  break;
               case CreatorUIStates.SCRIBBLE:
                  _loc2_.props.scribble = this.paintScribble;
                  break;
            }
         }
      }
      
      protected function onToolChange(param1:Event) : void
      {
         this._model.touchArea.buttonMode = this._model.touchArea.useHandCursor = false;
         this._model.objectsContainer.buttonMode = this._model.objectsContainer.useHandCursor = false;
         this._model.objectsContainer.mouseEnabled = this._model.objectsContainer.mouseChildren = false;
         this._model.modifiersContainer.mouseEnabled = this._model.modifiersContainer.mouseChildren = false;
         this._model.modifiersContainer.alpha = 0.5;
         this._model.touchArea.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this._model.touchArea.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this._model.objectsContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.onObjectPress);
         this._model.objectsContainer.removeEventListener(MouseEvent.MOUSE_UP,this.onObjectRelease);
         this._model.objectsContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.onObjectPaintPress);
         this._model.objectsContainer.removeEventListener(MouseEvent.MOUSE_UP,this.onObjectPaintRelease);
         this._model.objectsContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.onObjectPaintPick);
         this._model.touchArea.removeEventListener(MouseEvent.MOUSE_UP,this.onObjectPaintDeselect);
         this.snap = true;
         switch(this._creator.ui.tools.value)
         {
            case CreatorUIStates.TOOL_SELECT:
               this._model.objectsContainer.buttonMode = this._model.objectsContainer.useHandCursor = true;
               this._model.objectsContainer.mouseEnabled = this._model.objectsContainer.mouseChildren = true;
               this._model.modifiersContainer.mouseChildren = true;
               this._model.modifiersContainer.alpha = 1;
               this._model.touchArea.buttonMode = true;
               this._model.touchArea.useHandCursor = false;
               this._model.objectsContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.onObjectPress);
               this._model.objectsContainer.addEventListener(MouseEvent.MOUSE_UP,this.onObjectRelease);
               this._model.touchArea.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               this._model.touchArea.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
               break;
            case CreatorUIStates.TOOL_WINDOW:
               this._model.objectsContainer.buttonMode = this._model.objectsContainer.useHandCursor = true;
               this._model.objectsContainer.mouseEnabled = this._model.objectsContainer.mouseChildren = true;
               this._model.objectsContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.onObjectPress);
               this._model.objectsContainer.addEventListener(MouseEvent.MOUSE_UP,this.onObjectRelease);
               this._model.touchArea.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               this._model.touchArea.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
               this._model.modifiers.focusObject = null;
               break;
            case CreatorUIStates.TOOL_DRAW:
               this._model.touchArea.buttonMode = this._model.touchArea.useHandCursor = true;
               this._model.touchArea.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               this._model.touchArea.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
               this._selection.clear();
               this._model.modifiers.focusObject = null;
               break;
            case CreatorUIStates.TOOL_PAINT:
               this._model.objectsContainer.buttonMode = this._model.objectsContainer.useHandCursor = true;
               this._model.objectsContainer.mouseEnabled = this._model.objectsContainer.mouseChildren = true;
               this._model.objectsContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.onObjectPaintPress);
               this._model.objectsContainer.addEventListener(MouseEvent.MOUSE_UP,this.onObjectPaintRelease);
               this._model.touchArea.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               this._model.touchArea.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
               this._model.modifiers.focusObject = null;
               break;
            case CreatorUIStates.TOOL_PICK:
               this._model.objectsContainer.buttonMode = this._model.objectsContainer.useHandCursor = true;
               this._model.objectsContainer.mouseEnabled = this._model.objectsContainer.mouseChildren = true;
               this._model.objectsContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.onObjectPaintPick);
         }
      }
      
      protected function onModifierSelect(param1:Event) : void
      {
         if(this._model.modifiers.focusObject)
         {
            this._selection.clear();
         }
         this.focusObject = null;
      }
      
      protected function setMouseAnchorPoint(param1:Boolean = false) : void
      {
         this._mouseVector.x = this._model.touchArea.mouseX;
         this._mouseVector.y = this._model.touchArea.mouseY;
         if(param1)
         {
            this._mouseVector.x = Math.round(this._mouseVector.x / 10) * 10;
            this._mouseVector.y = Math.round(this._mouseVector.y / 10) * 10;
         }
      }
      
      protected function setMouseDragPoint(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._dragVector.x = this._model.touchArea.mouseX - this._mouseVector.x;
         this._dragVector.y = this._model.touchArea.mouseY - this._mouseVector.y;
         if(param1 || this._subState == CreatorUIStates.PIN)
         {
            this._dragVector.x = Math.round(this._dragVector.x / 10) * 10;
            this._dragVector.y = Math.round(this._dragVector.y / 10) * 10;
         }
         if(Key.shiftKey && this._state != STATE_COPYING && this._subState != CreatorUIStates.VERTEX)
         {
            if(this._state == STATE_SIZING)
            {
               _loc2_ = Math.abs(Math.max(this._dragVector.x,this._dragVector.y));
               _loc3_ = this._dragVector.x >= 0 ? 1 : -1;
               _loc4_ = this._dragVector.y >= 0 ? 1 : -1;
               this._dragVector.x = this._dragVector.y = _loc2_;
               this._dragVector.x *= _loc3_;
               this._dragVector.y *= _loc4_;
            }
            else if(this._state != STATE_ROTATING)
            {
               if(Math.abs(this._dragVector.x) > Math.abs(this._dragVector.y))
               {
                  this._dragVector.y = 0;
               }
               else
               {
                  this._dragVector.x = 0;
               }
            }
         }
      }
      
      protected function clearMouseDragPoint() : void
      {
         this._dragVector.x = this._dragVector.y = 0;
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Graphics = null;
         if(this._creator.testing)
         {
            return;
         }
         if(this._state == STATE_IDLE)
         {
            this._selection.clear();
            if(this._newObject)
            {
               this.onMouseUp(param1);
            }
            this._subState = "";
            this.focusObject = null;
            this._mouseIsDown = true;
            switch(this._creator.ui.tools.value)
            {
               case CreatorUIStates.TOOL_SELECT:
                  this.setMouseAnchorPoint();
                  break;
               case CreatorUIStates.TOOL_WINDOW:
               case CreatorUIStates.TOOL_PAINT:
                  this._state = STATE_SELECTING;
                  this.setMouseAnchorPoint();
                  this._selection.startSelection();
                  this._model.objectsContainer.mouseEnabled = this._model.objectsContainer.mouseChildren = false;
                  this._model.modifiersContainer.mouseChildren = false;
                  break;
               case CreatorUIStates.TOOL_DRAW:
                  this._state = STATE_CREATING;
                  if(this._model.getLayerView(2) == false)
                  {
                     this._model.setLayerView(2,true);
                  }
                  this.setMouseAnchorPoint();
                  this._history.record();
                  this.createNewObject();
                  if(this._newObject.props.shape == CreatorUIStates.SHAPE_POLY)
                  {
                     _loc2_ = this._model.newObjectContainer.mouseX;
                     _loc3_ = this._model.newObjectContainer.mouseY;
                     _loc4_ = this._model.newObjectContainer.graphics;
                     _loc4_.lineStyle(2,0,1);
                     this._vertices.push(new Vec2(_loc2_,_loc3_));
                     _loc4_.moveTo(_loc2_,_loc3_);
                     this.px = _loc2_;
                     this.py = _loc3_;
                  }
            }
            this._model.touchArea.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         }
      }
      
      protected function onMouseMove(param1:MouseEvent = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Graphics = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this._creator.testing)
         {
            return;
         }
         switch(this._creator.ui.tools.value)
         {
            case CreatorUIStates.TOOL_SELECT:
               if(this._mouseIsDown && this._model.container.scaleX == 1)
               {
                  this._creator.ui.playfieldContainer.contentX -= this._dragVector.x;
                  this._creator.ui.playfieldContainer.contentY -= this._dragVector.y;
                  this.setMouseDragPoint();
                  this._creator.ui.playfieldContainer.contentX += this._dragVector.x;
                  this._creator.ui.playfieldContainer.contentY += this._dragVector.y;
                  this._creator.ui.playfieldContainer.contentX = Math.min(0,Math.max(this._creator.ui.playfieldContainer.contentX,0 - this._model.width + 640 - 24));
                  this._creator.ui.playfieldContainer.contentY = Math.min(0,Math.max(this._creator.ui.playfieldContainer.contentY,0 - this._model.height + 480 - 24));
                  this._creator.ui.hScroll.alignToTarget();
                  this._creator.ui.vScroll.alignToTarget();
               }
         }
         switch(this._state)
         {
            case STATE_SELECTING:
               this.setMouseDragPoint();
               this._selection.updateSelection();
               break;
            case STATE_CREATING:
               if(this._newObject)
               {
                  this.setMouseDragPoint();
                  if(this._newObject.props.shape == CreatorUIStates.SHAPE_POLY)
                  {
                     if(this._mouseIsDown)
                     {
                        _loc2_ = this._model.newObjectContainer.mouseX;
                        _loc3_ = this._model.newObjectContainer.mouseY;
                        _loc4_ = this._model.newObjectContainer.graphics;
                        _loc5_ = _loc2_ - this.px;
                        _loc6_ = _loc3_ - this.py;
                        if(_loc5_ * _loc5_ + _loc6_ * _loc6_ > 100)
                        {
                           if(param1.shiftKey)
                           {
                              _loc2_ = Math.round(_loc2_ / 10) * 10;
                              _loc3_ = Math.round(_loc3_ / 10) * 10;
                           }
                           this._vertices.push(new Vec2(_loc2_,_loc3_));
                           this.px = _loc2_;
                           this.py = _loc3_;
                           _loc4_.lineTo(_loc2_,_loc3_);
                        }
                     }
                  }
                  else
                  {
                     this._newObject.clip.suspend();
                     this._newObject.updateFromVector(this._dragVector,this._mouseVector,this._newObject.props.shape == CreatorUIStates.SHAPE_BOX || this._newObject.props.shape == CreatorUIStates.SHAPE_RAMP ? CreatorUIStates.BOTTOM_RIGHT : CreatorUIStates.ORIGIN,this.snap,param1.shiftKey);
                     this._newObject.clip.release();
                  }
               }
         }
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Graphics = null;
         var _loc3_:GeomPoly = null;
         var _loc4_:Vector.<Point> = null;
         var _loc5_:GeomVert = null;
         if(this._creator.testing)
         {
            return;
         }
         this._mouseIsDown = false;
         switch(this._creator.ui.tools.value)
         {
            case CreatorUIStates.TOOL_SELECT:
               this._model.touchArea.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         }
         switch(this._state)
         {
            case STATE_SELECTING:
               this._selection.endSelection();
               this._model.objectsContainer.mouseEnabled = this._model.objectsContainer.mouseChildren = true;
               if(this._creator.ui.tools.value == CreatorUIStates.TOOL_SELECT)
               {
                  this._model.modifiersContainer.mouseChildren = true;
               }
               if(getTimer() - this._mouseDownTime <= 250)
               {
                  this._creator.ui.tools.activateTab(null,this._creator.ui.tools.tabs[CreatorUIStates.TOOL_SELECT]);
               }
               this._state = STATE_IDLE;
               break;
            case STATE_CREATING:
               this._model.touchArea.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
               this.onMouseMove(param1);
               if(this._newObject)
               {
                  if(this._newObject.props.shape == CreatorUIStates.SHAPE_POLY)
                  {
                     _loc2_ = this._model.newObjectContainer.graphics;
                     if(this._vertices.length >= 3)
                     {
                        _loc3_ = new GeomPoly(this._vertices);
                        if(param1.shiftKey)
                        {
                           _loc3_.simplify(1000,100);
                        }
                        else
                        {
                           _loc3_.simplify(4000,120);
                        }
                        if(!_loc3_.selfIntersecting())
                        {
                           if(!_loc3_.cw())
                           {
                              _loc3_.points.reverse();
                           }
                           _loc4_ = new Vector.<Point>();
                           _loc5_ = _loc3_.points;
                           do
                           {
                              if(_loc5_.p)
                              {
                                 _loc4_.push(new Point(_loc5_.p.px - this._newObject.origin.x,_loc5_.p.py - this._newObject.origin.y));
                              }
                           }
                           while(_loc5_ = _loc5_.next, _loc5_);
                           
                           this._newObject.props.vertices = _loc4_;
                           this._newObject.centerVertices();
                        }
                     }
                     _loc2_.clear();
                     this._vertices = new Array();
                     this.px = -100;
                  }
                  if(this._newObject.isValid())
                  {
                     this._model.addObject(this._newObject);
                     this._newObject.state = ModelObject.STATE_IDLE;
                  }
                  else
                  {
                     this._newObject.destroy();
                     if(getTimer() - this._mouseDownTime <= 250)
                     {
                        this._creator.ui.tools.activateTab(null,this._creator.ui.tools.tabs[CreatorUIStates.TOOL_SELECT]);
                     }
                  }
                  this._newObject = null;
               }
               this._state = STATE_IDLE;
               break;
            case STATE_EDITING:
            case STATE_SIZING:
               this.onObjectRelease(param1);
               break;
            case STATE_COPYING:
               break;
            default:
               this._selection.clear();
               this._model.modifiers.focusObject = null;
               if(getTimer() - this._mouseDownTime <= 250)
               {
                  if(this._creator.ui.tools.activeTab.value == CreatorUIStates.TOOL_SELECT)
                  {
                     this._creator.ui.tools.activateTab(null,this._creator.ui.tools.tabs[CreatorUIStates.TOOL_WINDOW]);
                  }
               }
         }
         if(this._state != STATE_COPYING)
         {
            this.clearMouseDragPoint();
         }
      }
      
      protected function onObjectPaintPress(param1:MouseEvent) : void
      {
         if(this._creator.testing)
         {
            return;
         }
         this.onObjectPress(param1,true);
         var _loc2_:ModelObject = ModelObject(param1.target.obj);
         if(Boolean(_loc2_) && Boolean(_loc2_.props))
         {
            if(this._selection.contains(_loc2_))
            {
               if(!param1.shiftKey && !param1.ctrlKey)
               {
                  if(_loc2_.props.graphic == 0 && getTimer() - this._mouseDownTime < 250)
                  {
                     _loc2_.props.color = this.paintFillColor;
                     _loc2_.props.line = this.paintLineColor;
                     _loc2_.props.texture = this.paintTexture;
                     _loc2_.props.zlayer = this.paintLayer;
                     _loc2_.props.opaque = this.paintOpaque;
                     _loc2_.props.scribble = this.paintScribble;
                  }
               }
            }
         }
         this._mouseDownTime = getTimer();
      }
      
      protected function onObjectPaintRelease(param1:MouseEvent) : void
      {
         if(this._creator.testing)
         {
            return;
         }
         this.onObjectRelease(param1);
      }
      
      protected function onObjectPaintDeselect(param1:MouseEvent) : void
      {
         if(this._creator.testing)
         {
            return;
         }
         this._selection.clear();
      }
      
      protected function onObjectPaintPick(param1:MouseEvent) : void
      {
         if(this._creator.testing)
         {
            return;
         }
         var _loc2_:ModelObject = ModelObject(param1.target.obj);
         if(Boolean(_loc2_) && Boolean(_loc2_.props))
         {
            this.paintFillColor = _loc2_.props.color;
            this.paintLineColor = _loc2_.props.line;
            this.paintLayer = _loc2_.props.zlayer;
            this._creator.uiController.getPaintState();
         }
      }
      
      protected function onObjectPress(param1:MouseEvent, param2:Boolean = false) : void
      {
         var _loc4_:ModelObject = null;
         var _loc5_:int = 0;
         if(this._creator.testing)
         {
            return;
         }
         this._history.record();
         this._subState = "";
         this.focusObject = null;
         if(!(param1.target is ModelObjectSprite))
         {
            this._state == STATE_IDLE;
            if(param1.target is SimpleButton && SimpleButton(param1.target).parent is ModelObjectSprite)
            {
               _loc4_ = ModelObjectSprite(param1.target.parent).obj;
               this._selection.clear();
               this._selection.addObject(_loc4_);
               this._mouseVector.x = _loc4_.origin.x;
               this._mouseVector.y = _loc4_.origin.y;
               switch(param1.target.name)
               {
                  case CreatorUIStates.ROTATE:
                     if(getTimer() - this._mouseDownTime < 250)
                     {
                        _loc4_.rotation = 0;
                     }
                     this._state = STATE_ROTATING;
                     break;
                  case CreatorUIStates.VERTEX:
                     this._state = STATE_SIZING;
                     this._subState = param1.target.name;
                     this._mouseVector.x = _loc4_.origin.x;
                     this._mouseVector.y = _loc4_.origin.y;
                     this._vertexIndex = _loc4_.clip.getHandleIndex(param1.target as SimpleButton);
                     if(this._vertexIndex == -1)
                     {
                        this._state = STATE_EDITING;
                     }
                     else if(getTimer() - this._mouseDownTime < 250 && _loc4_.props.vertices.length > 3)
                     {
                        _loc4_.deleteVertex(this._vertexIndex);
                        this._state = STATE_EDITING;
                        this._subState = "";
                     }
                     break;
                  case CreatorUIStates.PIN:
                     this._state = STATE_SIZING;
                     this._subState = param1.target.name;
                     this._mouseVector.x = _loc4_.origin.x;
                     this._mouseVector.y = _loc4_.origin.y;
                     if(getTimer() - this._mouseDownTime < 250)
                     {
                        _loc4_.setPinPosition(new Point(0,0));
                        this._state = STATE_EDITING;
                        this._subState = "";
                     }
                     break;
                  default:
                     this._state = STATE_SIZING;
                     this._subState = param1.target.name;
                     switch(this._subState)
                     {
                        case CreatorUIStates.TOP_LEFT:
                           this._mouseVector.x = _loc4_.props.width / 2;
                           this._mouseVector.y = _loc4_.props.height / 2;
                           break;
                        case CreatorUIStates.TOP_RIGHT:
                           this._mouseVector.x = 0 - _loc4_.props.width / 2;
                           this._mouseVector.y = _loc4_.props.height / 2;
                           break;
                        case CreatorUIStates.BOTTOM_LEFT:
                           this._mouseVector.x = _loc4_.props.width / 2;
                           this._mouseVector.y = 0 - _loc4_.props.height / 2;
                           break;
                        case CreatorUIStates.BOTTOM_RIGHT:
                           this._mouseVector.x = 0 - _loc4_.props.width / 2;
                           this._mouseVector.y = 0 - _loc4_.props.height / 2;
                     }
                     Geom2d.rotate(this._mouseVector,_loc4_.rotation * Geom2d.dtr);
                     this._mouseVector.x += _loc4_.origin.x;
                     this._mouseVector.y += _loc4_.origin.y;
               }
               this._model.container.addEventListener(MouseEvent.MOUSE_MOVE,this.onObjectDrag);
            }
         }
         var _loc3_:ModelObject = ModelObject(param1.target.obj);
         if(_loc3_ != null && this._state == STATE_IDLE)
         {
            switch(this._creator.ui.tools.value)
            {
               case CreatorUIStates.TOOL_SELECT:
               case CreatorUIStates.TOOL_WINDOW:
               case CreatorUIStates.TOOL_PAINT:
                  this.setMouseAnchorPoint();
                  this._state = STATE_EDITING;
                  if(!this._selection.contains(_loc3_))
                  {
                     if(!param1.shiftKey && !param1.ctrlKey)
                     {
                        this._selection.clear();
                     }
                     if(_loc3_.group)
                     {
                        this._selection.addObjects(_loc3_.group.objects);
                     }
                     else
                     {
                        this._selection.addObject(_loc3_);
                     }
                  }
                  else if(param1.ctrlKey)
                  {
                     if(_loc3_.group)
                     {
                        this._selection.removeObjects(_loc3_.group.objects);
                     }
                     else
                     {
                        this._selection.removeObject(_loc3_);
                     }
                  }
                  else if(param1.shiftKey)
                  {
                     this._prevSelection.clear();
                     this._prevSelection.addObjects(this._selection.objects);
                     this._selection.duplicateObjects();
                     _loc5_ = 0;
                     while(_loc5_ < this._selection.length)
                     {
                        this._selection.objects[_loc5_].state = ModelObject.STATE_NEW;
                        this._selection.objects[_loc5_].clip.draw();
                        this._model.newObjectContainer.addChild(this._selection.objects[_loc5_].clip);
                        _loc5_++;
                     }
                     this._state = STATE_COPYING;
                  }
                  else if(getTimer() - this._mouseDownTime < 250 && _loc3_.props.shape == CreatorUIStates.SHAPE_POLY)
                  {
                     _loc3_.addVertex();
                  }
                  this._model.container.addEventListener(MouseEvent.MOUSE_MOVE,this.onObjectDrag);
            }
         }
         this._mouseIsDown = true;
         if(!param2)
         {
            this._mouseDownTime = getTimer();
         }
      }
      
      protected function onObjectDrag(param1:MouseEvent) : void
      {
         var _loc2_:ModelObject = null;
         if(this._creator.testing)
         {
            return;
         }
         if(!this._mouseIsDown)
         {
            this.onObjectRelease(param1);
            return;
         }
         switch(this._state)
         {
            case STATE_EDITING:
            case STATE_COPYING:
               this.setMouseDragPoint();
               this._selection.drag();
               break;
            case STATE_ROTATING:
               if(this._selection.length == 1)
               {
                  this.setMouseDragPoint();
                  _loc2_ = this._selection.objects[0];
                  _loc2_.clip.suspend();
                  _loc2_.updateFromVector(this._dragVector,this._mouseVector,CreatorUIStates.ORIGIN,this.snap,param1.shiftKey);
                  _loc2_.clip.release();
               }
               break;
            case STATE_SIZING:
               if(this._selection.length == 1)
               {
                  this.setMouseDragPoint();
                  _loc2_ = this._selection.objects[0];
                  _loc2_.clip.suspend();
                  if(this._subState == CreatorUIStates.PIN)
                  {
                     _loc2_.setPinPosition(this._dragVector);
                  }
                  else if(this._subState == CreatorUIStates.VERTEX)
                  {
                     _loc2_.setVertexPosition(this._vertexIndex,this._dragVector);
                  }
                  else
                  {
                     _loc2_.updateFromVector(this._dragVector,this._mouseVector,this._subState,this.snap,param1.shiftKey);
                  }
                  _loc2_.clip.release();
               }
         }
      }
      
      protected function onObjectRelease(param1:MouseEvent) : void
      {
         var ps:Vector.<ModelObject> = null;
         var ns:Vector.<ModelObject> = null;
         var i:int = 0;
         var groups:Dictionary = null;
         var pm:ModelObject = null;
         var m:ModelObject = null;
         var g:ModelObjectContainer = null;
         var md:Modifier = null;
         var e:MouseEvent = param1;
         if(this._creator.testing)
         {
            return;
         }
         this._model.container.removeEventListener(MouseEvent.MOUSE_MOVE,this.onObjectDrag);
         if(this._state == STATE_EDITING || this._state == STATE_COPYING)
         {
            this.setMouseAnchorPoint();
            if(this._state == STATE_COPYING && Math.abs(this._dragVector.x) < 10 && Math.abs(this._dragVector.y) < 10)
            {
               this._selection.destroyObjects();
            }
            else
            {
               ps = this._prevSelection.objects;
               ns = this._selection.objects.concat();
               this._selection.drop();
               if(this._state == STATE_COPYING && ps && ns && ps.length > 0)
               {
                  groups = new Dictionary();
                  i = 0;
                  while(i < ns.length)
                  {
                     pm = ps[i];
                     m = ns[i];
                     m.state = ModelObject.STATE_SELECTED;
                     this._model.objectsContainer.addChild(m.clip);
                     if(pm.groupID > 0)
                     {
                        if(groups[pm.groupID] == null)
                        {
                           groups[pm.groupID] = new ModelObjectContainer();
                        }
                        g = groups[pm.groupID];
                        g.addObject(m);
                        m.group = g;
                     }
                     i++;
                  }
                  try
                  {
                     i = 0;
                     while(i < this._model.modifiers.objects.length)
                     {
                        md = this._model.modifiers.objects[i];
                        if(md && md.props && md.props.parent && ps.indexOf(md.props.parent) != -1 && ps.indexOf(md.props.parent) < ps.length)
                        {
                           md = md.clone();
                           if(ps.length > ps.indexOf(md.props.parent))
                           {
                              md.props.parent = ns[ps.indexOf(md.props.parent)];
                           }
                           if(md.props && md.props.child && ps.indexOf(md.props.child) != -1 && ps.indexOf(md.props.child) < ps.length)
                           {
                              md.props.child = ns[ps.indexOf(md.props.child)];
                           }
                           this._model.modifiers.addObject(md);
                           md.clip.draw();
                        }
                        i++;
                     }
                  }
                  catch(e:Error)
                  {
                  }
               }
            }
         }
         if(this._state == STATE_SIZING && this._subState == CreatorUIStates.VERTEX)
         {
            if(this._selection.length == 1)
            {
               this._selection.objects[0].centerVertices();
            }
         }
         this._state = STATE_IDLE;
         this._subState = "";
         this.clearMouseDragPoint();
         this._mouseIsDown = false;
      }
      
      private function onStageMouseDown(param1:MouseEvent) : void
      {
         if(this._creator.testing)
         {
            return;
         }
         this._mouseDownTimeLast = getTimer();
      }
      
      protected function onStageMouseUp(param1:MouseEvent) : void
      {
         if(this._creator.testing)
         {
            return;
         }
         switch(this._state)
         {
            case STATE_IDLE:
               this._mouseIsDown = false;
               break;
            case STATE_CREATING:
               this.onMouseUp(param1);
               break;
            case STATE_EDITING:
            case STATE_COPYING:
            case STATE_SELECTING:
            case STATE_SIZING:
               this.onObjectRelease(param1);
         }
         this._mouseDownTime = this._mouseDownTimeLast;
      }
      
      public function lockSelectedObjects() : void
      {
         this._history.record();
         var _loc1_:int = int(this._selection.length);
         while(_loc1_--)
         {
            this._selection.objects[_loc1_].props.locked = true;
         }
      }
      
      public function unlockSelectedObjects() : void
      {
         this._history.record();
         var _loc1_:int = int(this._selection.length);
         while(_loc1_--)
         {
            this._selection.objects[_loc1_].props.locked = false;
         }
      }
      
      public function groupSelectedObjects() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ModelObject = null;
         this._history.record();
         this.ungroupSelectedObjects();
         var _loc3_:ModelObjectContainer = new ModelObjectContainer();
         _loc1_ = int(this._selection.length);
         while(_loc1_--)
         {
            _loc2_ = this._selection.objects[_loc1_];
            _loc3_.addObject(_loc2_);
            _loc2_.group = _loc3_;
            _loc2_.clip.draw();
         }
         this._selection.dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function ungroupSelectedObjects() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ModelObject = null;
         this._history.record();
         _loc1_ = int(this._selection.length);
         while(_loc1_--)
         {
            _loc2_ = this._selection.objects[_loc1_];
            if(_loc2_.group)
            {
               _loc2_.group.removeObject(_loc2_);
               _loc2_.group = null;
               _loc2_.clip.draw();
            }
         }
         this._selection.dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function getLayerState(param1:ModelObject, param2:int, param3:int = 0) : Boolean
      {
         var _loc4_:String = null;
         switch(param3)
         {
            case ModelObjectProperties.LAYER_COLLISION:
               _loc4_ = param1.props.collision_group.toString(2);
               break;
            case ModelObjectProperties.LAYER_PASSTHRU:
               return param2 == param1.props.passthru_group;
            case ModelObjectProperties.LAYER_SENSOR:
               _loc4_ = param1.props.sensor_group.toString(2);
         }
         while(_loc4_.length < 5)
         {
            _loc4_ = "0" + _loc4_;
         }
         return _loc4_.charAt(param2) == "1";
      }
      
      public function setLayerState(param1:ModelObject, param2:int, param3:Boolean, param4:int = 0) : void
      {
         var _loc5_:String = null;
         switch(param4)
         {
            case ModelObjectProperties.LAYER_COLLISION:
               _loc5_ = param1.props.collision_group.toString(2);
               break;
            case ModelObjectProperties.LAYER_PASSTHRU:
               param1.props.passthru_group = param3 ? param2 : -1;
               return;
            case ModelObjectProperties.LAYER_SENSOR:
               _loc5_ = param1.props.sensor_group.toString(2);
         }
         while(_loc5_.length < 5)
         {
            _loc5_ = "0" + _loc5_;
         }
         var _loc6_:String = "";
         var _loc7_:int = 0;
         while(_loc7_ < 5)
         {
            if(_loc7_ == param2)
            {
               _loc6_ += param3 ? "1" : "0";
            }
            else
            {
               _loc6_ += _loc5_.charAt(_loc7_);
            }
            _loc7_++;
         }
         switch(param4)
         {
            case ModelObjectProperties.LAYER_COLLISION:
               param1.props.collision_group = parseInt(_loc6_,2);
               break;
            case ModelObjectProperties.LAYER_SENSOR:
               param1.props.sensor_group = parseInt(_loc6_,2);
         }
      }
      
      public function setLayers(param1:ModelObject, param2:String, param3:int = 0) : void
      {
         var _loc4_:int = parseInt(param2,2);
         switch(param3)
         {
            case ModelObjectProperties.LAYER_COLLISION:
               param1.props.collision_group = _loc4_;
               break;
            case ModelObjectProperties.LAYER_PASSTHRU:
               param1.props.passthru_group = parseInt(param2,10);
               break;
            case ModelObjectProperties.LAYER_SENSOR:
               param1.props.sensor_group = _loc4_;
         }
      }
      
      public function updateLayersForSelection() : void
      {
         this._history.record();
         var _loc1_:Array = this._creator.uiController.getLayersState();
         var _loc2_:int = int(this._selection.length);
         while(_loc2_--)
         {
            this.setLayers(this._selection.objects[_loc2_],_loc1_[0],ModelObjectProperties.LAYER_COLLISION);
            this.setLayers(this._selection.objects[_loc2_],_loc1_[1],ModelObjectProperties.LAYER_PASSTHRU);
            this.setLayers(this._selection.objects[_loc2_],_loc1_[2],ModelObjectProperties.LAYER_SENSOR);
         }
      }
      
      public function getActionsState() : uint
      {
         if(this._creator.modelController.selection.length > 0)
         {
            return this._selection.objects[0].props.actions;
         }
         return 0;
      }
      
      public function setActions(param1:uint) : void
      {
         this._history.record();
         var _loc2_:int = int(this._selection.length);
         while(_loc2_--)
         {
            this._selection.objects[_loc2_].props.actions = param1;
         }
      }
   }
}

