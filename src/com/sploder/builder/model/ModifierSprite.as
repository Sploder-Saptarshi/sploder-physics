package com.sploder.builder.model
{
   import com.sploder.asui.Prompt;
   import com.sploder.asui.Tagtip;
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.game.library.EmbeddedLibrary;
   import com.sploder.util.Geom2d;
   import com.sploder.util.Key;
   import flash.display.Graphics;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class ModifierSprite extends Sprite
   {
      public static var library:EmbeddedLibrary;
      
      public static var mainStage:Stage;
      
      public static var focusObject:ModelObject;
      
      public static var focusClass:Class;
      
      public static var suppressDraw:Boolean = false;
      
      protected var _modifier:Modifier;
      
      protected var _indicatorBolt:Sprite;
      
      protected var _buttonActivate:SimpleButton;
      
      protected var _buttonActivate2:SimpleButton;
      
      protected var _handleParent:SimpleButton;
      
      protected var _handleChild:SimpleButton;
      
      protected var _handleAmount:SimpleButton;
      
      protected var _handleDelete:SimpleButton;
      
      protected var _clip:Sprite;
      
      protected var _clipContainer:Sprite;
      
      protected var _clipAdded:Boolean = false;
      
      protected var _handlesAdded:Boolean = false;
      
      protected var _clickTime:int = 0;
      
      protected var _suspended:Boolean = false;
      
      protected var _currentHandle:SimpleButton;
      
      protected var _dropPoint:Point;
      
      protected var _sx:Number = 0;
      
      protected var _sy:Number = 0;
      
      protected var _ex:Number = 0;
      
      protected var _ey:Number = 0;
      
      protected var _dx:Number = 0;
      
      protected var _dy:Number = 0;
      
      protected var _ch:Number = 0;
      
      public function ModifierSprite(param1:Modifier)
      {
         super();
         this._modifier = param1;
         this._dropPoint = new Point();
      }
      
      public function get obj() : Modifier
      {
         return this._modifier;
      }
      
      protected function addClip() : void
      {
         if(this._modifier.props && this._modifier.props.type && this._modifier.props.type != "")
         {
            this._clipContainer = new Sprite();
            addChild(this._clipContainer);
            this._clip = library.getDisplayObject(this._modifier.props.type) as Sprite;
            this._clip.addEventListener(MouseEvent.CLICK,this.onClipClick);
            this._clipContainer.mouseEnabled = false;
            this._clipContainer.mouseChildren = true;
            this._clipContainer.addChild(this._clip);
            this._clipAdded = true;
         }
      }
      
      protected function addHandles() : void
      {
         if(suppressDraw)
         {
            return;
         }
         this._buttonActivate = library.getDisplayObject(CreatorUIStates.BUTTON_ACTIVATE_OVERLAY) as SimpleButton;
         this._buttonActivate.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this._buttonActivate.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this._buttonActivate.addEventListener(MouseEvent.MOUSE_DOWN,this.onClipClick);
         addChild(this._buttonActivate);
         var _loc1_:Boolean = true;
         var _loc2_:Boolean = true;
         switch(this._modifier.props.type)
         {
            case CreatorUIStates.MODIFIER_MOTOR:
               this._handleAmount = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_HANDLE_TWIST) as SimpleButton;
               Prompt.connectButton(this._handleAmount,"Click and drag to adjust the speed of the motor.");
               this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_HANDLE_DELETE) as SimpleButton;
            case CreatorUIStates.MODIFIER_ROTATOR:
               if(!this._handleAmount)
               {
                  this._handleAmount = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_CONTROL_TWIST) as SimpleButton;
                  Prompt.connectButton(this._handleAmount,"Click and drag to adjust the speed of rotation.");
               }
               this._handleAmount.addEventListener(MouseEvent.MOUSE_DOWN,this.onHandlePress);
               this._handleAmount.addEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
               this._handleAmount.visible = false;
               addChild(this._handleAmount);
               if(!this._handleDelete)
               {
                  this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_CONTROL_DELETE) as SimpleButton;
               }
               this._handleDelete.addEventListener(MouseEvent.CLICK,this.onDeleteClick);
               addChild(this._handleDelete);
               break;
            case CreatorUIStates.MODIFIER_LAUNCHER:
            case CreatorUIStates.MODIFIER_SELECTOR:
            case CreatorUIStates.MODIFIER_AIMER:
            case CreatorUIStates.MODIFIER_DRAGGER:
            case CreatorUIStates.MODIFIER_CLICKER:
            case CreatorUIStates.MODIFIER_ARCADEMOVER:
               this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_CONTROL_DELETE) as SimpleButton;
               this._handleDelete.addEventListener(MouseEvent.CLICK,this.onDeleteClick);
               addChild(this._handleDelete);
               break;
            case CreatorUIStates.MODIFIER_CONNECTOR:
               this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_DELETE) as SimpleButton;
               this._handleDelete.addEventListener(MouseEvent.CLICK,this.onDeleteClick);
               addChild(this._handleDelete);
               break;
            case CreatorUIStates.MODIFIER_UNLOCKER:
               if(!this._handleChild)
               {
                  this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_UNLOCK_MOVE) as SimpleButton;
                  Prompt.connectButton(this._handleChild,"Drag this end onto the object that should receive sensor events.");
               }
            case CreatorUIStates.MODIFIER_SPAWNER:
               if(!this._handleChild)
               {
                  this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_MOVE) as SimpleButton;
                  Prompt.connectButton(this._handleChild,"Drag this end to adjust the direction and speed that objects go when they are spawned.");
               }
               if(!this._handleDelete)
               {
                  this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_DELETE) as SimpleButton;
               }
            case CreatorUIStates.MODIFIER_ADDER:
            case CreatorUIStates.MODIFIER_MOVER:
            case CreatorUIStates.MODIFIER_SLIDER:
            case CreatorUIStates.MODIFIER_JUMPER:
               if(!this._handleChild)
               {
                  this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_CONTROL_MOVE) as SimpleButton;
                  Prompt.connectButton(this._handleChild,"Drag this end to adjust the direction. Make the arrow longer to increase the speed.");
               }
               if(!this._handleDelete)
               {
                  this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_CONTROL_DELETE) as SimpleButton;
               }
            case CreatorUIStates.MODIFIER_PUSHER:
               if(!this._handleChild)
               {
                  this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_HANDLE_MOVE) as SimpleButton;
                  Prompt.connectButton(this._handleChild,"Drag this end to adjust the direction objects are pushed. Make the arrow longer to increase the speed.");
               }
               if(!this._handleDelete)
               {
                  this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_HANDLE_DELETE) as SimpleButton;
               }
               _loc1_ = false;
               _loc2_ = false;
            case CreatorUIStates.MODIFIER_ELEVATOR:
               if(!this._handleChild)
               {
                  this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_MOVE) as SimpleButton;
                  Prompt.connectButton(this._handleChild,"Drag this end to adjust the location of the end point.");
               }
               if(!this._handleParent)
               {
                  this._handleParent = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_MOVE) as SimpleButton;
                  Prompt.connectButton(this._handleParent,"Drag this end to adjust the location of the start point.");
               }
               if(!this._handleDelete)
               {
                  this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_DELETE) as SimpleButton;
               }
            case CreatorUIStates.MODIFIER_GROOVEJOINT:
               if(!this._handleChild)
               {
                  this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_JOINT_MOVE) as SimpleButton;
                  Prompt.connectButton(this._handleChild,"Drag this end to adjust the location of the end point.");
               }
               if(_loc2_ && !this._buttonActivate2)
               {
                  this._buttonActivate2 = library.getDisplayObject(CreatorUIStates.BUTTON_ACTIVATE_OVERLAY) as SimpleButton;
                  this._buttonActivate2.addEventListener(MouseEvent.MOUSE_DOWN,this.onClipClick);
                  addChild(this._buttonActivate2);
               }
            case CreatorUIStates.MODIFIER_GEARJOINT:
               if(!this._handleChild)
               {
                  this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_GEARJOINT_MOVE) as SimpleButton;
               }
            case CreatorUIStates.MODIFIER_PINJOINT:
            case CreatorUIStates.MODIFIER_DAMPEDSPRING:
            case CreatorUIStates.MODIFIER_LOOSESPRING:
               if(!this._handleChild)
               {
                  this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_JOINT_LINK) as SimpleButton;
                  Prompt.connectButton(this._handleChild,"Drag this end onto an object to link this object to it. Drag onto the background to link the object to a fixed spot.");
               }
               if(!this._handleDelete)
               {
                  this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_JOINT_DELETE) as SimpleButton;
               }
               this._handleChild.addEventListener(MouseEvent.MOUSE_DOWN,this.onHandlePress);
               this._handleChild.addEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
               this._handleChild.visible = false;
               addChild(this._handleChild);
               if(_loc1_)
               {
                  if(!this._handleParent)
                  {
                     this._handleParent = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_JOINT_MOVE) as SimpleButton;
                     Prompt.connectButton(this._handleParent,"Drag this end to adjust the location this joint attaches to the parent object.");
                  }
                  this._handleParent.addEventListener(MouseEvent.MOUSE_DOWN,this.onHandlePress);
                  this._handleParent.addEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
                  this._handleParent.visible = false;
                  addChild(this._handleParent);
               }
               this._indicatorBolt = library.getDisplayObject(CreatorUIStates.MODIFIER_BOLT) as Sprite;
               this._indicatorBolt.visible = false;
               addChild(this._indicatorBolt);
               this._indicatorBolt.parent.setChildIndex(this._indicatorBolt,0);
               this._indicatorBolt.mouseEnabled = this._indicatorBolt.mouseChildren = false;
               this._handleDelete.addEventListener(MouseEvent.CLICK,this.onDeleteClick);
               addChild(this._handleDelete);
               break;
            case CreatorUIStates.MODIFIER_FACTORY:
            case CreatorUIStates.MODIFIER_SWITCHER:
            case CreatorUIStates.MODIFIER_EMAGNET:
            case CreatorUIStates.MODIFIER_POINTER:
               this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_DELETE) as SimpleButton;
               this._handleDelete.addEventListener(MouseEvent.CLICK,this.onDeleteClick);
               addChild(this._handleDelete);
               break;
            case CreatorUIStates.MODIFIER_THRUSTER:
               this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_CONTROL_MOVE) as SimpleButton;
               Prompt.connectButton(this._handleChild,"Drag this end to adjust the direction of thrust. Make the arrow longer to increase the power.");
               this._handleParent = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_CONTROL_MOVE) as SimpleButton;
               Prompt.connectButton(this._handleParent,"Drag this end to adjust the point on the object in which to apply the thrust force.");
               this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_CONTROL_DELETE) as SimpleButton;
               this._handleChild.addEventListener(MouseEvent.MOUSE_DOWN,this.onHandlePress);
               this._handleChild.addEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
               this._handleChild.visible = false;
               addChild(this._handleChild);
               this._handleParent.addEventListener(MouseEvent.MOUSE_DOWN,this.onHandlePress);
               this._handleParent.addEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
               this._handleParent.visible = false;
               addChild(this._handleParent);
               this._handleDelete.addEventListener(MouseEvent.CLICK,this.onDeleteClick);
               addChild(this._handleDelete);
               break;
            case CreatorUIStates.MODIFIER_PROPELLER:
               this._handleChild = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_MOVE) as SimpleButton;
               Prompt.connectButton(this._handleChild,"Drag this end to adjust the direction of propulsion. Make the arrow longer to increase the power.");
               this._handleParent = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_MOVE) as SimpleButton;
               Prompt.connectButton(this._handleParent,"Drag this end to adjust the point on the object in which to apply the propulsion force.");
               this._handleDelete = library.getDisplayObject(CreatorUIStates.BUTTON_MODIFIER_ACTUATOR_DELETE) as SimpleButton;
               this._handleChild.addEventListener(MouseEvent.MOUSE_DOWN,this.onHandlePress);
               this._handleChild.addEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
               this._handleChild.visible = false;
               addChild(this._handleChild);
               this._handleParent.addEventListener(MouseEvent.MOUSE_DOWN,this.onHandlePress);
               this._handleParent.addEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
               this._handleParent.visible = false;
               addChild(this._handleParent);
               this._handleDelete.addEventListener(MouseEvent.CLICK,this.onDeleteClick);
               addChild(this._handleDelete);
         }
         Prompt.connectButton(this._handleDelete,"Click to delete this modifier.");
         this._handlesAdded = true;
      }
      
      protected function setHandleVisibility(param1:Boolean = true) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         if(this._buttonActivate)
         {
            this._buttonActivate.x = this._sx;
            this._buttonActivate.y = this._sy;
            this._buttonActivate.visible = !param1;
         }
         if(this._buttonActivate2)
         {
            this._buttonActivate2.x = this._ex;
            this._buttonActivate2.y = this._ey;
            this._buttonActivate2.visible = !param1;
         }
         if(this._handleAmount)
         {
            _loc2_ = Point.polar(30,this._modifier.props.amount);
            this._handleAmount.x = _loc2_.x;
            this._handleAmount.y = _loc2_.y;
            this._handleAmount.visible = param1;
            _loc3_ = this._modifier.props.amount * Geom2d.rtd;
            if(_loc3_ < 0)
            {
               _loc3_ += 180;
            }
            this._handleAmount.rotation = _loc3_;
         }
         if(this._handleChild)
         {
            this._handleChild.x = this._ex;
            this._handleChild.y = this._ey;
            this._handleChild.visible = param1;
         }
         if(this._handleDelete)
         {
            this._handleDelete.x = this._sx + this._dx / 2;
            this._handleDelete.y = this._sy + this._dy / 2;
            this._handleDelete.rotation = 0 - rotation;
            this._handleDelete.visible = param1;
         }
         if(this._handleParent)
         {
            this._handleParent.x = this._sx;
            this._handleParent.y = this._sy;
            this._handleParent.visible = param1;
         }
         if(this._modifier.props.type == CreatorUIStates.MODIFIER_PINJOINT && Boolean(this._indicatorBolt))
         {
            this._indicatorBolt.x = this._sx;
            this._indicatorBolt.y = this._sy;
            this._indicatorBolt.visible = Math.abs(this._dx) <= 10 && Math.abs(this._dy) <= 10;
            this._clip.visible = !this._indicatorBolt.visible;
            if(param1 && this._indicatorBolt.visible)
            {
               this._handleParent.visible = this._handleChild.visible = false;
               this._handleDelete.visible = true;
            }
         }
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
         if(Boolean(this._indicatorBolt) && this._indicatorBolt.visible)
         {
            Tagtip.showTag("These objects are bolted together! Drag them apart to edit this joint.",true);
         }
      }
      
      protected function onMouseOut(param1:MouseEvent) : void
      {
         Tagtip.hideTag();
      }
      
      protected function onClipClick(param1:MouseEvent) : void
      {
         this._modifier.container.focusObject = this._modifier;
      }
      
      protected function onDeleteClick(param1:MouseEvent) : void
      {
         this._modifier.destroy();
      }
      
      protected function onHandlePress(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case this._handleAmount:
            case this._handleChild:
            case this._handleParent:
               this._currentHandle = param1.target as SimpleButton;
               mainStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onHandleMove);
               this._currentHandle.addEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
               mainStage.addEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
         }
      }
      
      protected function onHandleMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Point = null;
         switch(this._currentHandle)
         {
            case this._handleAmount:
               _loc2_ = Math.atan2(mouseY,mouseX);
               if(Key.shiftKey)
               {
                  _loc2_ *= Geom2d.rtd;
                  _loc2_ = Math.round(_loc2_ / 15) * 15;
                  _loc2_ *= Geom2d.dtr;
               }
               _loc3_ = Point.polar(40,_loc2_);
               this._handleAmount.x = _loc3_.x;
               this._handleAmount.y = _loc3_.y;
               this._modifier.props.amount = _loc2_;
               break;
            case this._handleChild:
               this._modifier.props.child = null;
               this._handleChild.x = this._modifier.props.childOffset.x = Math.round(mouseX / 5) * 5;
               this._handleChild.y = this._modifier.props.childOffset.y = Math.round(mouseY / 5) * 5;
               if(Key.shiftKey)
               {
                  if(Math.abs(this._handleChild.x) > Math.abs(this._handleChild.y))
                  {
                     this._handleChild.y = this._modifier.props.childOffset.y = 0;
                  }
                  else
                  {
                     this._handleChild.x = this._modifier.props.childOffset.x = 0;
                  }
               }
               switch(this._modifier.props.type)
               {
                  case CreatorUIStates.MODIFIER_CONNECTOR:
                  case CreatorUIStates.MODIFIER_PINJOINT:
                  case CreatorUIStates.MODIFIER_DAMPEDSPRING:
                  case CreatorUIStates.MODIFIER_LOOSESPRING:
                  case CreatorUIStates.MODIFIER_UNLOCKER:
                  case CreatorUIStates.MODIFIER_GEARJOINT:
                     this.findObjectUnderMouse();
               }
               this.draw();
               if(this._handleParent && this._handleChild.x == this._handleParent.x && this._handleParent.y == this._handleChild.y)
               {
                  this._handleChild.alpha = 0.1;
               }
               else
               {
                  this._handleChild.alpha = 1;
               }
               break;
            case this._handleParent:
               this._handleParent.x = this._modifier.props.parentOffset.x = Math.round(mouseX / 5) * 5;
               this._handleParent.y = this._modifier.props.parentOffset.y = Math.round(mouseY / 5) * 5;
               this.draw();
         }
      }
      
      protected function onHandleRelease(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         mainStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onHandleMove);
         if(this._currentHandle)
         {
            this._currentHandle.removeEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
         }
         mainStage.removeEventListener(MouseEvent.MOUSE_UP,this.onHandleRelease);
         if(this._modifier.deleted)
         {
            return;
         }
         switch(this._currentHandle)
         {
            case this._handleChild:
               switch(this._modifier.props.type)
               {
                  case CreatorUIStates.MODIFIER_PINJOINT:
                  case CreatorUIStates.MODIFIER_DAMPEDSPRING:
                  case CreatorUIStates.MODIFIER_LOOSESPRING:
                  case CreatorUIStates.MODIFIER_UNLOCKER:
                  case CreatorUIStates.MODIFIER_GEARJOINT:
                     if(focusObject == null)
                     {
                        this.findObjectUnderMouse();
                     }
                     if(Boolean(focusObject) && focusObject != this._modifier.props.parent)
                     {
                        this._modifier.props.child = focusObject;
                        _loc2_ = this._modifier.props.child.clip.globalToLocal(this._dropPoint);
                        if(this._modifier.props.type == CreatorUIStates.MODIFIER_UNLOCKER || this._modifier.props.type == CreatorUIStates.MODIFIER_GEARJOINT)
                        {
                           this._modifier.props.setChildOffset(0,0);
                        }
                        else
                        {
                           _loc2_.x = Math.round(_loc2_.x / 5) * 5;
                           _loc2_.y = Math.round(_loc2_.y / 5) * 5;
                           this._modifier.props.setChildOffset(_loc2_.x,_loc2_.y);
                        }
                     }
                     else
                     {
                        this._modifier.props.child = null;
                        if(this._modifier.props.type == CreatorUIStates.MODIFIER_UNLOCKER || this._modifier.props.type == CreatorUIStates.MODIFIER_GEARJOINT)
                        {
                           this._modifier.props.setChildOffset(0,-100);
                        }
                     }
               }
               this.draw();
               break;
            case this._handleParent:
               this.findObjectUnderMouse();
               _loc2_ = this._modifier.props.parent.clip.globalToLocal(this._dropPoint);
               _loc2_.x = Math.round(_loc2_.x / 5) * 5;
               _loc2_.y = Math.round(_loc2_.y / 5) * 5;
               this._modifier.props.setParentOffset(_loc2_.x,_loc2_.y);
               this.draw();
         }
         this._currentHandle = null;
         this._clickTime = getTimer();
      }
      
      protected function findObjectUnderMouse() : void
      {
         this._dropPoint.x = mainStage.mouseX;
         this._dropPoint.y = mainStage.mouseY;
         if(focusClass)
         {
            focusClass.mainInstance.focusObject = this._modifier.container.model.objectAtPoint(this._dropPoint,this._modifier.props.parent);
         }
      }
      
      public function draw() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Number = NaN;
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:ModelObject = null;
         var _loc11_:Graphics = null;
         var _loc12_:Rectangle = null;
         if(this._suspended || this._modifier.deleted)
         {
            return;
         }
         if(suppressDraw)
         {
            return;
         }
         if(library == null)
         {
            return;
         }
         if(this._modifier == null || this._modifier.props == null || this._modifier.props.type == null)
         {
            return;
         }
         if(!this._clipAdded)
         {
            this.addClip();
         }
         if(!this._handlesAdded)
         {
            this.addHandles();
         }
         mouseEnabled = mouseChildren = true;
         if(getTimer() - this._clickTime < 250)
         {
            if(this._currentHandle == this._handleParent)
            {
               this._modifier.props.parentOffset.x = this._modifier.props.parentOffset.y = 0;
            }
            if(this._currentHandle == this._handleChild)
            {
               this._modifier.props.childOffset.x = this._modifier.props.childOffset.y = 0;
            }
         }
         if(Boolean(this._modifier.props) && Boolean(this._modifier.props.parent))
         {
            x = this._sx = this._modifier.props.parent.x;
            y = this._sy = this._modifier.props.parent.y;
            rotation = this._modifier.props.parent.rotation;
            _loc1_ = new Point();
            if(this._modifier.props.parentOffset.x != 0 || this._modifier.props.parentOffset.y != 0)
            {
               _loc1_ = this._modifier.props.parent.clip.localToGlobal(this._modifier.props.parentOffset);
               _loc1_ = globalToLocal(_loc1_);
            }
            this._sx = _loc1_.x;
            this._sy = _loc1_.y;
            if(this._modifier.props.child)
            {
               _loc1_ = this._modifier.props.child.clip.localToGlobal(this._modifier.props.childOffset);
            }
            else
            {
               _loc1_ = this._modifier.props.parent.clip.localToGlobal(this._modifier.props.childOffset);
            }
            _loc1_ = globalToLocal(_loc1_);
            this._ex = _loc1_.x;
            this._ey = _loc1_.y;
            this._dx = this._ex - this._sx;
            this._dy = this._ey - this._sy;
            if(Math.abs(this._dx) <= 5 && Math.abs(this._dy) <= 5)
            {
               this._dx = this._dy = 0;
            }
            if(this._clipAdded)
            {
               this._clip.mouseEnabled = this._clip.mouseChildren = mouseEnabled = Boolean(this._modifier.props.parent) && this._modifier.props.parent.state == ModelObject.STATE_IDLE && (this._modifier.props.child == null || this._modifier.props.child.state == ModelObject.STATE_IDLE);
            }
            alpha = this._modifier.state == Modifier.STATE_SELECTED ? 1 : 0.5;
            if(this._buttonActivate)
            {
               this._buttonActivate.rotation = 0 - rotation;
            }
            switch(this._modifier.props.type)
            {
               case CreatorUIStates.MODIFIER_MOTOR:
               case CreatorUIStates.MODIFIER_ROTATOR:
                  x += this._modifier.props.parent.pin.x;
                  y += this._modifier.props.parent.pin.y;
                  this._sx = this._sy = this._ex = this._ey = this._dx = this._dy = 0;
                  rotation = 0;
                  _loc2_ = this._modifier.props.amount * Geom2d.rtd;
                  if(this._clip)
                  {
                     _loc3_ = this._clip["mask_neg"];
                     _loc4_ = this._clip["mask_pos"];
                     if(Boolean(_loc3_) && Boolean(_loc4_))
                     {
                        _loc3_.rotation = _loc4_.rotation = 0;
                        if(_loc2_ > 0)
                        {
                           _loc4_.rotation = _loc2_;
                        }
                        if(_loc2_ < 0)
                        {
                           _loc3_.rotation = _loc2_;
                        }
                     }
                  }
                  this._handleAmount.visible = true;
                  this._handleAmount.enabled = this._modifier.state == Modifier.STATE_SELECTED;
                  break;
               case CreatorUIStates.MODIFIER_CONNECTOR:
               case CreatorUIStates.MODIFIER_PUSHER:
               case CreatorUIStates.MODIFIER_PINJOINT:
               case CreatorUIStates.MODIFIER_DAMPEDSPRING:
               case CreatorUIStates.MODIFIER_LOOSESPRING:
               case CreatorUIStates.MODIFIER_GROOVEJOINT:
               case CreatorUIStates.MODIFIER_ELEVATOR:
               case CreatorUIStates.MODIFIER_JUMPER:
               case CreatorUIStates.MODIFIER_ADDER:
               case CreatorUIStates.MODIFIER_SPAWNER:
               case CreatorUIStates.MODIFIER_UNLOCKER:
               case CreatorUIStates.MODIFIER_GEARJOINT:
               case CreatorUIStates.MODIFIER_THRUSTER:
               case CreatorUIStates.MODIFIER_PROPELLER:
                  this._ch = Math.max(30,Math.sqrt(this._dx * this._dx + this._dy * this._dy)) + 31;
                  this._clip.height = this._ch;
                  this._clip.y = 0 - this._ch / 2 + 15;
                  this._clipContainer.rotation = Math.atan2(this._dy,this._dx) * Geom2d.rtd + 90;
                  this._clipContainer.x = this._sx;
                  this._clipContainer.y = this._sy;
                  if(this._handleChild)
                  {
                     this._handleChild.rotation = this._clipContainer.rotation;
                  }
                  break;
               case CreatorUIStates.MODIFIER_MOVER:
               case CreatorUIStates.MODIFIER_SLIDER:
                  this._ch = Math.max(30,Math.sqrt(this._dx * this._dx + this._dy * this._dy)) + 21;
                  this._clip.height = this._ch * 2;
                  this._clip.x = this._clip.y = 0;
                  this._clipContainer.rotation = Math.atan2(this._dy,this._dx) * Geom2d.rtd + 90;
                  this._clipContainer.x = 0;
                  this._clipContainer.y = 0;
                  if(this._handleChild)
                  {
                     this._handleChild.rotation = this._clipContainer.rotation;
                  }
            }
            if(this._modifier.props.type == CreatorUIStates.MODIFIER_FACTORY || this._modifier.props.type == CreatorUIStates.MODIFIER_SWITCHER || this._modifier.props.type == CreatorUIStates.MODIFIER_EMAGNET)
            {
               rotation = 0;
            }
            this.setHandleVisibility(this._modifier.state == Modifier.STATE_SELECTED);
            if(this._handleDelete && this._ch < 80 && this._modifier.props.type != CreatorUIStates.MODIFIER_MOTOR && this._modifier.props.type != CreatorUIStates.MODIFIER_ROTATOR && this._modifier.props.type != CreatorUIStates.MODIFIER_MOVER && this._modifier.props.type != CreatorUIStates.MODIFIER_SLIDER && this._modifier.props.type != CreatorUIStates.MODIFIER_LAUNCHER && this._modifier.props.type != CreatorUIStates.MODIFIER_SELECTOR && this._modifier.props.type != CreatorUIStates.MODIFIER_FACTORY && this._modifier.props.type != CreatorUIStates.MODIFIER_SWITCHER && this._modifier.props.type != CreatorUIStates.MODIFIER_EMAGNET && this._modifier.props.type != CreatorUIStates.MODIFIER_AIMER && this._modifier.props.type != CreatorUIStates.MODIFIER_DRAGGER && this._modifier.props.type != CreatorUIStates.MODIFIER_CLICKER && this._modifier.props.type != CreatorUIStates.MODIFIER_ARCADEMOVER && this._modifier.props.type != CreatorUIStates.MODIFIER_POINTER && !(this._modifier.props.type == CreatorUIStates.MODIFIER_PINJOINT && this._dx == 0 && this._dy == 0))
            {
               this._handleDelete.visible = false;
            }
            if(this._modifier.props.type == CreatorUIStates.MODIFIER_MOVER || this._modifier.props.type == CreatorUIStates.MODIFIER_SLIDER)
            {
               this._handleDelete.x = this._handleDelete.y = 0;
               if(this._ch < 40)
               {
                  this._handleDelete.visible = false;
               }
            }
            if(this._modifier.props.type == CreatorUIStates.MODIFIER_MOTOR || this._modifier.props.type == CreatorUIStates.MODIFIER_ROTATOR)
            {
               this._handleAmount.visible = true;
               this._handleAmount.mouseEnabled = this._modifier.state == Modifier.STATE_SELECTED;
            }
            if(this._modifier.props.type == CreatorUIStates.MODIFIER_UNLOCKER || this._modifier.props.type == CreatorUIStates.MODIFIER_GEARJOINT)
            {
               this._handleChild.rotation = 0 - rotation;
               this._handleChild.visible = true;
            }
            if(this._modifier.props.type == CreatorUIStates.MODIFIER_FACTORY)
            {
               if(this._modifier.props.parent.group == null)
               {
                  return;
               }
               _loc5_ = 10000;
               _loc6_ = -10000;
               _loc7_ = 10000;
               _loc8_ = -10000;
               _loc9_ = int(this._modifier.props.parent.group.length);
               while(_loc9_--)
               {
                  _loc10_ = this._modifier.props.parent.group.objects[_loc9_];
                  if(Boolean(_loc10_.clip) && Boolean(_loc10_.clip.parent))
                  {
                     _loc12_ = _loc10_.clip.getBounds(_loc10_.clip.parent);
                     _loc5_ = Math.min(_loc5_,_loc12_.x);
                     _loc6_ = Math.max(_loc6_,_loc12_.x + _loc12_.width);
                     _loc7_ = Math.min(_loc7_,_loc12_.y);
                     _loc8_ = Math.max(_loc8_,_loc12_.y + _loc12_.height);
                  }
               }
               _loc5_ -= x;
               _loc6_ -= x;
               _loc7_ -= y;
               _loc8_ -= y;
               _loc11_ = this._clipContainer.graphics;
               _loc11_.clear();
               if(this._modifier.state == Modifier.STATE_SELECTED)
               {
                  _loc11_.lineStyle(4,16777215,2);
               }
               else
               {
                  _loc11_.lineStyle(2,16737792,2);
               }
               _loc11_.drawRect(_loc5_,_loc7_,_loc6_ - _loc5_,_loc8_ - _loc7_);
               this._buttonActivate.x = this._handleDelete.x = this._clip.x = (_loc6_ + _loc5_) / 2;
               this._buttonActivate.y = this._handleDelete.y = this._clip.y = (_loc8_ + _loc7_) / 2;
               alpha = 1;
            }
         }
      }
      
      public function suspend() : void
      {
         this._suspended = true;
      }
      
      public function release() : void
      {
         this._suspended = false;
         this.draw();
      }
      
      override public function toString() : String
      {
         return this._modifier.toString();
      }
   }
}

