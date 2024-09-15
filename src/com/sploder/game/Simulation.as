package com.sploder.game
{
   import com.sploder.asui.ObjectEvent;
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.builder.Shapes;
   import com.sploder.builder.model.Environment;
   import com.sploder.builder.model.Model;
   import com.sploder.builder.model.ModelObject;
   import com.sploder.builder.model.ModelObjectContainer;
   import com.sploder.builder.model.Modifier;
   import com.sploder.game.morph.Shatter;
   import com.sploder.game.sound.SoundManager;
   import com.sploder.game.sound.Sounds;
   import com.sploder.util.Closest;
   import com.sploder.util.Geom2d;
   import com.sploder.util.Key;
   import cx.CxFastAllocList_Callback;
   import cx.CxFastList_PhysObj;
   import cx.CxFastNode_Constraint;
   import cx.CxFastNode_PhysObj;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import nape.*;
   import nape.callbacks.*;
   import nape.constraint.*;
   import nape.dynamics.RayCast;
   import nape.geom.*;
   import nape.phys.*;
   import nape.shape.Circle;
   import nape.shape.Polygon;
   import nape.shape.Shape;
   import nape.space.*;
   import nape.util.*;
   
   public class Simulation
   {
      protected static var _sounds:SoundManager;
      
      public static var _nextID:int = 0;
      
      protected var _container:Sprite;
      
      protected var _model:Model;
      
      protected var _environment:Environment;
      
      protected var _space:UniformSpace;
      
      protected var _frame:int = 0;
      
      protected var _id:int = 0;
      
      protected var _built:Boolean = false;
      
      protected var _running:Boolean = false;
      
      protected var _bodies:Dictionary;
      
      protected var _bodiesLockStates:Dictionary;
      
      protected var _constraints:Vector.<Constraint>;
      
      protected var _constraintsAddedStates:Dictionary;
      
      protected var _constraintsBodies:Dictionary;
      
      protected var _elevators:Dictionary;
      
      protected var _motors:Dictionary;
      
      protected var _switchTimes:Dictionary;
      
      protected var _elevatorStates:Dictionary;
      
      protected var _lastSpawns:Dictionary;
      
      protected var _spawners:Dictionary;
      
      protected var _spawnedBodyModifiers:Dictionary;
      
      protected var _spawnedBodyTimes:Dictionary;
      
      protected var _spawnedBodyExplodes:Dictionary;
      
      protected var _spawnedBodyLifespans:Dictionary;
      
      protected var _spawnedBodyLastBodies:Vector.<PhysObj>;
      
      protected var _spawnLimits:Dictionary;
      
      protected var _spawnTotals:Dictionary;
      
      protected var _spawnIntervals:Dictionary;
      
      protected var _jumpedStates:Dictionary;
      
      protected var _jumpedTimes:Dictionary;
      
      protected var _emagnetStates:Dictionary;
      
      protected var _emagnetPressed:Dictionary;
      
      protected var _groups:Vector.<Group>;
      
      protected var _pinnedBodies:Dictionary;
      
      protected var _jointedBodies:Dictionary;
      
      protected var _pivotJoints:Vector.<PivotJoint>;
      
      protected var _pivotJointGroups:Vector.<Group>;
      
      protected var _pivotJointGroupMap:Dictionary;
      
      protected var _gearJoints:Dictionary;
      
      protected var _force:Point;
      
      protected var _origin:Point;
      
      protected var _origin2:Point;
      
      protected var _sense_id:int;
      
      protected var _lastAdd:int = -1000;
      
      protected var _firstControlledObject:ModelObject;
      
      protected var _focusObject:ModelObject;
      
      protected var _focusBody:PhysObj;
      
      protected var _focusObjectStates:Dictionary;
      
      protected var _focusObjectMap:Dictionary;
      
      protected var _removedObjs:Vector.<PhysObj>;
      
      protected var _dragObject:ModelObject;
      
      protected var _dragConstraint:PivotJoint;
      
      public var gravity:int = 250;
      
      public var linDamp:Number = 0.995;
      
      public var angDamp:Number = 0.995;
      
      protected var _width:int = 640;
      
      protected var _height:int = 480;
      
      protected var _view:View;
      
      protected var _viewUI:ViewUI;
      
      protected var _turbo:Boolean = false;
      
      protected var _events:EventHandler;
      
      protected var _mouseDown:Boolean = false;
      
      private var frictionAmount:Number = 0;
      
      private var _focusObjectOnFloor:Boolean;
      
      public function Simulation(param1:Sprite, param2:Model, param3:Environment, param4:Boolean = false)
      {
         super();
         this._container = param1;
         this._model = param2;
         this._environment = param3;
         this._turbo = param4;
         ++_nextID;
         this._id = _nextID;
         if(this._container.stage)
         {
            this.init();
         }
         else
         {
            this._container.addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
      }
      
      public static function get sounds() : SoundManager
      {
         return _sounds;
      }
      
      public static function localToGlobal(param1:Point, param2:PhysObj) : Point
      {
         param1 = param1.clone();
         if(param2.a != 0)
         {
            Geom2d.rotate(param1,param2.a);
         }
         param1.x += param2.px;
         param1.y += param2.py;
         return param1;
      }
      
      public function get view() : View
      {
         return this._view;
      }
      
      public function get viewUI() : ViewUI
      {
         return this._viewUI;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function get space() : UniformSpace
      {
         return this._space;
      }
      
      public function get bodies() : Dictionary
      {
         return this._bodies;
      }
      
      public function get focusBody() : PhysObj
      {
         return this._focusBody;
      }
      
      public function get environment() : Environment
      {
         return this._environment;
      }
      
      public function get events() : EventHandler
      {
         return this._events;
      }
      
      public function get model() : Model
      {
         return this._model;
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      private function init(param1:Event = null) : void
      {
         this._container.removeEventListener(Event.ADDED_TO_STAGE,this.init);
         if(this._environment.size != Environment.SIZE_NORMAL)
         {
            this._width = 1280;
            this._height = 960;
         }
         if(!this._environment.gravity)
         {
            this.gravity = 0;
            Shatter.gravPull = 0;
         }
         else
         {
            Shatter.gravPull = 2;
         }
         if(this._environment.resistance)
         {
            this.linDamp = 0.25;
            this.angDamp = 0.15;
         }
         else
         {
            this.linDamp = 0.995;
            this.angDamp = 0.995;
         }
         Material.Steel.density = 3;
         if(Capabilities.cpuArchitecture == "ARM" || Capabilities.screenResolutionX <= 480 || Capabilities.screenResolutionY <= 480)
         {
            this._turbo = true;
         }
         this._view = new View(this._container,this._model,this._environment,this._turbo);
         this._events = new EventHandler(this,this._model,this._environment);
         if(_sounds == null)
         {
            _sounds = new SoundManager();
         }
         _sounds.simulation = this;
         _sounds.initialize(this._container.stage);
         this._viewUI = new ViewUI(this);
         if(this._container.stage)
         {
            this._container.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
            this._container.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
         }
         if(this._environment.vMusic != "" && SoundManager.hasSound)
         {
            _sounds.loadSong(this._environment.vMusic);
         }
      }
      
      public function build() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Body = null;
         var _loc4_:int = 0;
         var _loc5_:ModelObject = null;
         if(this._built)
         {
            return;
         }
         this._bodiesLockStates = new Dictionary(true);
         this._constraints = new Vector.<Constraint>();
         this._constraintsAddedStates = new Dictionary(true);
         this._constraintsBodies = new Dictionary(true);
         this._elevatorStates = new Dictionary(true);
         this._spawners = new Dictionary(true);
         this._lastSpawns = new Dictionary(true);
         this._spawnedBodyModifiers = new Dictionary(true);
         this._spawnedBodyTimes = new Dictionary(true);
         this._spawnedBodyExplodes = new Dictionary(true);
         this._spawnedBodyLifespans = new Dictionary(true);
         this._spawnedBodyLastBodies = new Vector.<PhysObj>();
         this._spawnLimits = new Dictionary(true);
         this._spawnTotals = new Dictionary(true);
         this._spawnIntervals = new Dictionary(true);
         this._focusObjectStates = new Dictionary(true);
         this._focusObjectMap = new Dictionary(true);
         this._elevators = new Dictionary(true);
         this._motors = new Dictionary(true);
         this._switchTimes = new Dictionary(true);
         this._jumpedStates = new Dictionary(true);
         this._jumpedTimes = new Dictionary(true);
         this._emagnetStates = new Dictionary(true);
         this._emagnetPressed = new Dictionary(true);
         this._pinnedBodies = new Dictionary(true);
         this._jointedBodies = new Dictionary(true);
         this._pivotJoints = new Vector.<PivotJoint>();
         this._pivotJointGroups = new Vector.<Group>();
         this._pivotJointGroupMap = new Dictionary(true);
         this._gearJoints = new Dictionary(true);
         this._removedObjs = new Vector.<PhysObj>();
         this._force = new Point();
         this._origin = new Point();
         this._origin2 = new Point();
         var _loc2_:UniformSpace = this._space = new UniformSpace(new AABB(-320,-320,this._width + 640,this._height + 640),15,new Vec2(0,this.gravity));
         switch(this._environment.extents)
         {
            case Environment.EXTENTS_ENCLOSED:
               _loc3_ = Tools.createBox(this._width * 0.5,-50,this._width + 200,100,0,0,0,true,Material.Wood);
               _loc2_.addObject(_loc3_);
               _loc3_ = Tools.createBox(-50,this._height * 0.5,100,this._height,0,0,0,true,Material.Wood);
               _loc2_.addObject(_loc3_);
               _loc3_ = Tools.createBox(this._width + 50,this._height * 0.5,100,this._height,0,0,0,true,Material.Wood);
               _loc2_.addObject(_loc3_);
            case Environment.EXTENTS_GROUND:
               _loc3_ = Tools.createBox(this._width * 0.5,this._height + 50,this._width + 600,100,0,0,0,true,Material.Wood);
               _loc2_.addObject(_loc3_);
         }
         this._groups = new Vector.<Group>();
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            this._groups.push(new Group());
            this._groups[_loc1_].ignore = true;
            _loc1_++;
         }
         this._sense_id = CbType.get();
         _loc2_.addCbSenseBegin(this._sense_id,this._sense_id);
         _loc2_.addCbSenseEnd(this._sense_id,this._sense_id);
         this._bodies = new Dictionary(true);
         _loc4_ = 0;
         while(_loc4_ < this._model.objects.length)
         {
            _loc5_ = this._model.objects[_loc4_];
            if(!_loc5_.deleted)
            {
               _loc3_ = this.addObject(_loc5_);
            }
            _loc4_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            _loc2_.addGroup(this._groups[_loc1_]);
            _loc1_++;
         }
         this.buildModifiers();
         this.addPivotGroups();
         this._built = true;
      }
      
      protected function buildModifiers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Modifier = null;
         var _loc3_:Dictionary = new Dictionary();
         _loc1_ = 0;
         while(_loc1_ < this._model.modifiers.objects.length)
         {
            _loc2_ = this._model.modifiers.objects[_loc1_];
            if(!_loc2_.deleted && _loc2_.props.type == CreatorUIStates.MODIFIER_FACTORY && _loc2_.props.parent && Boolean(_loc2_.props.parent.group))
            {
               _loc3_[_loc2_.props.parent.group] = true;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._model.modifiers.objects.length)
         {
            _loc2_ = this._model.modifiers.objects[_loc1_];
            if(!_loc2_.deleted && !(Boolean(_loc2_.props.parent) && Boolean(_loc2_.props.parent.group) && Boolean(_loc3_[_loc2_.props.parent.group]) && (_loc2_.props.type == CreatorUIStates.MODIFIER_ADDER || _loc2_.props.type == CreatorUIStates.MODIFIER_SPAWNER)))
            {
               this.addModifier(this._model.modifiers.objects[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      protected function addModifier(param1:Modifier) : void
      {
         var _loc2_:Body = null;
         var _loc3_:Body = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Vec2 = null;
         var _loc8_:Vec2 = null;
         var _loc9_:Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:Constraint = null;
         var _loc12_:Shape = null;
         var _loc13_:ModelObject = null;
         var _loc14_:int = 0;
         var _loc15_:Body = null;
         if(param1 && !param1.deleted && param1.props && Boolean(param1.props.parent))
         {
            _loc2_ = this._bodies[param1.props.parent];
            _loc3_ = this._bodies[param1.props.child];
            if(this._spawners[_loc2_] != null && (param1.props.type == CreatorUIStates.MODIFIER_PROPELLER || param1.props.type == CreatorUIStates.MODIFIER_MAGNET))
            {
               return;
            }
            if(Boolean(_loc2_) && _loc2_.added_to_space)
            {
               switch(param1.props.type)
               {
                  case CreatorUIStates.MODIFIER_MOTOR:
                     if(_loc2_)
                     {
                        _loc10_ = param1.props.amount;
                        _loc11_ = new SimpleMotor(this._space.STATIC,_loc2_,_loc10_,1);
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                        this._motors[param1.props.parent] = _loc11_;
                     }
                     break;
                  case CreatorUIStates.MODIFIER_GEARJOINT:
                     if(Boolean(_loc2_) && Boolean(_loc3_))
                     {
                        _loc10_ = param1.props.amount;
                        _loc11_ = new SimpleMotor(_loc3_,_loc2_,0,-1);
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                     }
                     break;
                  case CreatorUIStates.MODIFIER_PUSHER:
                     if(_loc2_)
                     {
                        _loc2_.stopAll();
                        _loc2_.setVel(param1.props.childOffset.x * 2,param1.props.childOffset.y * 2);
                     }
                     break;
                  case CreatorUIStates.MODIFIER_PINJOINT:
                     if(Boolean(_loc2_) && Boolean(_loc3_))
                     {
                        _loc4_ = localToGlobal(param1.props.parentOffset,_loc2_);
                        _loc7_ = new Vec2(_loc4_.x,_loc4_.y);
                        _loc5_ = localToGlobal(param1.props.childOffset,_loc3_);
                        _loc8_ = new Vec2(_loc5_.x,_loc5_.y);
                        if(Math.abs(_loc8_.px - _loc7_.px) <= 10 && Math.abs(_loc8_.py - _loc7_.py) <= 10)
                        {
                           _loc11_ = new PivotJoint(_loc2_,_loc3_,_loc7_);
                           this._pivotJoints.push(PivotJoint(_loc11_));
                        }
                        else
                        {
                           _loc11_ = new PinJoint(_loc2_,_loc3_,_loc7_,_loc8_);
                        }
                        this._jointedBodies[_loc2_] = this._jointedBodies[_loc3_] = _loc11_;
                     }
                     else
                     {
                        _loc4_ = param1.props.parent.localToGlobal(param1.props.parentOffset);
                        _loc7_ = new Vec2(_loc4_.x,_loc4_.y);
                        _loc5_ = param1.props.parent.localToGlobal(param1.props.childOffset);
                        _loc8_ = new Vec2(_loc5_.x,_loc5_.y);
                        if(Math.abs(_loc8_.px - _loc7_.px) <= 10 && Math.abs(_loc8_.py - _loc7_.py) <= 10)
                        {
                           _loc11_ = new PivotJoint(_loc2_,this._space.STATIC,_loc7_);
                        }
                        else
                        {
                           _loc11_ = new PinJoint(_loc2_,this._space.STATIC,_loc7_,_loc8_);
                        }
                        this._jointedBodies[_loc2_] = _loc11_;
                     }
                     this._constraints.push(_loc11_);
                     this._space.addConstraint(_loc11_);
                     break;
                  case CreatorUIStates.MODIFIER_CONNECTOR:
                     if(Boolean(_loc2_) && Boolean(_loc3_))
                     {
                        _loc11_ = new GearJoint(_loc2_,_loc3_,_loc3_.a,1);
                        this._space.addConstraint(_loc11_);
                        this._gearJoints[_loc3_] = _loc11_;
                     }
                     if(Boolean(_loc2_) && Boolean(_loc3_))
                     {
                        _loc11_ = new PivotJoint(this._space.STATIC,_loc3_,new Vec2(_loc3_.px,_loc3_.py));
                        this._space.addConstraint(_loc11_);
                        this._constraints.push(_loc11_);
                        _loc3_.shapes.front().group = 0;
                        if(_loc3_.shapes.front().next)
                        {
                           _loc3_.shapes.front().next.group = 0;
                        }
                        this._pivotJoints.push(PivotJoint(_loc11_));
                        if(_loc3_.data is ModelObject && ModelObject(_loc3_.data).props.graphic > 0 && ModelObject(_loc3_.data).props.animation == 0 && _loc3_.graphic is ViewSprite)
                        {
                           this._view.animations.register(ViewSprite(_loc3_.graphic),_loc3_);
                        }
                     }
                     break;
                  case CreatorUIStates.MODIFIER_DAMPEDSPRING:
                     if(Boolean(_loc2_) && Boolean(_loc3_))
                     {
                        _loc4_ = localToGlobal(param1.props.parentOffset,_loc2_);
                        _loc7_ = new Vec2(_loc4_.x,_loc4_.y);
                        _loc5_ = localToGlobal(param1.props.childOffset,_loc3_);
                        _loc8_ = new Vec2(_loc5_.x,_loc5_.y);
                        _loc10_ = _loc5_.subtract(_loc4_).length;
                        if(_loc10_ <= 21)
                        {
                           _loc10_ += 5;
                        }
                        _loc11_ = new DampedSpring(_loc2_,_loc3_,_loc7_,_loc8_,_loc10_,300000,1000);
                        DampedSpring(_loc11_).restLength = DampedSpring(_loc11_).restLength * 0.5;
                        this._jointedBodies[_loc2_] = this._jointedBodies[_loc3_] = _loc11_;
                     }
                     else
                     {
                        _loc4_ = param1.props.parent.localToGlobal(param1.props.parentOffset);
                        _loc7_ = new Vec2(_loc4_.x,_loc4_.y);
                        _loc5_ = param1.props.parent.localToGlobal(param1.props.childOffset);
                        _loc8_ = new Vec2(_loc5_.x,_loc5_.y);
                        _loc11_ = new DampedSpring(_loc2_,this._space.STATIC,_loc7_,_loc8_,_loc5_.subtract(_loc4_).length,300000,1000);
                        DampedSpring(_loc11_).restLength = Math.max(param1.props.parent.props.width,param1.props.parent.props.height);
                        this._jointedBodies[_loc2_] = _loc11_;
                     }
                     this._constraints.push(_loc11_);
                     this._space.addConstraint(_loc11_);
                     break;
                  case CreatorUIStates.MODIFIER_LOOSESPRING:
                     if(Boolean(_loc2_) && Boolean(_loc3_))
                     {
                        _loc4_ = localToGlobal(param1.props.parentOffset,_loc2_);
                        _loc7_ = new Vec2(_loc4_.x,_loc4_.y);
                        _loc5_ = localToGlobal(param1.props.childOffset,_loc3_);
                        _loc8_ = new Vec2(_loc5_.x,_loc5_.y);
                        _loc11_ = new DampedSpring(_loc2_,_loc3_,_loc7_,_loc8_,_loc5_.subtract(_loc4_).length,30000,1000);
                        DampedSpring(_loc11_).restLength = DampedSpring(_loc11_).restLength * 0.25;
                        this._jointedBodies[_loc2_] = this._jointedBodies[_loc3_] = _loc11_;
                     }
                     else
                     {
                        _loc4_ = param1.props.parent.localToGlobal(param1.props.parentOffset);
                        _loc7_ = new Vec2(_loc4_.x,_loc4_.y);
                        _loc5_ = param1.props.parent.localToGlobal(param1.props.childOffset);
                        _loc8_ = new Vec2(_loc5_.x,_loc5_.y);
                        _loc11_ = new DampedSpring(_loc2_,this._space.STATIC,_loc7_,_loc8_,_loc5_.subtract(_loc4_).length,30000,1000);
                        DampedSpring(_loc11_).restLength = DampedSpring(_loc11_).restLength * 0.5;
                        this._jointedBodies[_loc2_] = _loc11_;
                     }
                     this._constraints.push(_loc11_);
                     this._space.addConstraint(_loc11_);
                     break;
                  case CreatorUIStates.MODIFIER_ELEVATOR:
                     if(_loc2_)
                     {
                        this._elevatorStates[param1.props.parent] = true;
                        _loc2_.gmass = 0;
                     }
                  case CreatorUIStates.MODIFIER_GROOVEJOINT:
                     if(_loc2_)
                     {
                        _loc4_ = param1.props.parent.localToGlobal(param1.props.parentOffset);
                        _loc7_ = new Vec2(_loc4_.x,_loc4_.y);
                        _loc5_ = param1.props.parent.localToGlobal(param1.props.childOffset);
                        _loc8_ = new Vec2(_loc5_.x,_loc5_.y);
                        _loc6_ = Closest.pointClosestTo(param1.props.parent.origin,_loc4_,_loc5_);
                        _loc9_ = new Vec2(_loc6_.x,_loc6_.y);
                        _loc11_ = new GrooveJoint(this._space.STATIC,_loc2_,_loc7_,_loc8_,_loc9_);
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                        if(param1.props.type == CreatorUIStates.MODIFIER_ELEVATOR)
                        {
                           this._elevators[param1.props.parent] = _loc11_;
                        }
                        this._jointedBodies[_loc2_] = _loc11_;
                     }
                     break;
                  case CreatorUIStates.MODIFIER_POINTER:
                     if(_loc2_)
                     {
                        _loc10_ = param1.props.amount;
                        _loc11_ = new SimpleMotor(this._space.STATIC,_loc2_,0,1);
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                     }
                     break;
                  case CreatorUIStates.MODIFIER_AIMER:
                  case CreatorUIStates.MODIFIER_ROTATOR:
                     if(_loc2_)
                     {
                        _loc10_ = param1.props.amount;
                        _loc11_ = new SimpleMotor(this._space.STATIC,_loc2_,0,1);
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                        if(this._firstControlledObject == null)
                        {
                           this._firstControlledObject = param1.props.parent;
                        }
                     }
                     break;
                  case CreatorUIStates.MODIFIER_EMAGNET:
                     this._emagnetStates[_loc2_] = true;
                  case CreatorUIStates.MODIFIER_LAUNCHER:
                     if(_loc2_)
                     {
                        this._bodiesLockStates[_loc2_] = false;
                     }
                  case CreatorUIStates.MODIFIER_MOVER:
                  case CreatorUIStates.MODIFIER_ARCADEMOVER:
                  case CreatorUIStates.MODIFIER_SLIDER:
                  case CreatorUIStates.MODIFIER_JUMPER:
                  case CreatorUIStates.MODIFIER_THRUSTER:
                     if(_loc2_)
                     {
                        _loc11_ = new Constraint();
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                        if(this._firstControlledObject == null)
                        {
                           this._firstControlledObject = param1.props.parent;
                        }
                     }
                     break;
                  case CreatorUIStates.MODIFIER_SWITCHER:
                     this._switchTimes[_loc2_] = 33;
                  case CreatorUIStates.MODIFIER_PROPELLER:
                     if(_loc2_)
                     {
                        _loc11_ = new Constraint();
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                     }
                     break;
                  case CreatorUIStates.MODIFIER_UNLOCKER:
                     if(_loc2_)
                     {
                        _loc11_ = new Constraint();
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                        this._events.addSensorLink(_loc2_,param1);
                        if(Boolean(param1.props.child) && this._events.hasActionForEvent(param1.props.child,3))
                        {
                           _loc2_.cbOutOfBounds = true;
                        }
                     }
                     break;
                  case CreatorUIStates.MODIFIER_DRAGGER:
                     if(_loc2_)
                     {
                        _loc11_ = new Constraint();
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                        if(_loc2_.hasGraphic && Boolean(_loc2_.graphic))
                        {
                           this._focusObjectMap[_loc2_.graphic] = _loc2_;
                           _loc2_.graphic.addEventListener(MouseEvent.MOUSE_DOWN,this.onObjectPress,false,0,true);
                           if(_loc2_.graphic is Sprite)
                           {
                              Sprite(_loc2_.graphic).buttonMode = true;
                              Sprite(_loc2_.graphic).mouseEnabled = true;
                           }
                        }
                        if(this._firstControlledObject == null)
                        {
                           this._firstControlledObject = param1.props.parent;
                        }
                     }
                     break;
                  case CreatorUIStates.MODIFIER_CLICKER:
                     if(_loc2_)
                     {
                        if(_loc2_.hasGraphic && Boolean(_loc2_.graphic))
                        {
                           this._focusObjectMap[_loc2_.graphic] = _loc2_;
                           _loc2_.graphic.addEventListener(MouseEvent.MOUSE_DOWN,this.onObjectClickSensor,false,0,true);
                           if(_loc2_.graphic is Sprite)
                           {
                              Sprite(_loc2_.graphic).buttonMode = true;
                              Sprite(_loc2_.graphic).mouseEnabled = true;
                           }
                        }
                     }
                  case CreatorUIStates.MODIFIER_SELECTOR:
                     if(_loc2_)
                     {
                        _loc11_ = new Constraint();
                        this._constraints.push(_loc11_);
                        this._space.addConstraint(_loc11_);
                        this._focusObjectStates[param1.props.parent] = true;
                        if(this._focusObject == null)
                        {
                           this._focusObject = param1.props.parent;
                           this._focusBody = _loc2_;
                        }
                        if(_loc2_.hasGraphic && Boolean(_loc2_.graphic))
                        {
                           this._focusObjectMap[_loc2_.graphic] = _loc2_;
                           _loc2_.graphic.addEventListener(MouseEvent.CLICK,this.onObjectClick,false,0,true);
                           if(_loc2_.graphic is Sprite)
                           {
                              Sprite(_loc2_.graphic).buttonMode = true;
                              Sprite(_loc2_.graphic).mouseEnabled = true;
                           }
                        }
                     }
                     break;
                  case CreatorUIStates.MODIFIER_ADDER:
                     if(this._firstControlledObject == null)
                     {
                        this._firstControlledObject = param1.props.parent;
                     }
                  case CreatorUIStates.MODIFIER_SPAWNER:
                     if(_loc2_)
                     {
                        this.removeConstraints(_loc2_,true);
                        this._spawners[_loc2_] = param1;
                        _loc11_ = new Constraint();
                        this._constraints.push(_loc11_);
                        this._lastSpawns[_loc2_] = -1000;
                        this._spawnLimits[_loc2_] = param1.props.amount2;
                        this._spawnTotals[_loc2_] = 0;
                        this._spawnIntervals[_loc2_] = param1.props.amount > 0 ? Math.floor(param1.props.amount / 1000 * 42) : 17;
                        _loc2_.gmass = 0;
                        _loc2_.shapes.front().sensor = 0;
                        _loc2_.shapes.front().group = 0;
                        _loc12_ = _loc2_.shapes.front();
                        while(_loc12_)
                        {
                           _loc12_.sensor = 0;
                           _loc12_.group = 0;
                           _loc12_ = _loc12_.next;
                        }
                        if(_loc2_.graphic)
                        {
                           _loc2_.graphic.alpha = 0.25;
                        }
                     }
                     break;
                  case CreatorUIStates.MODIFIER_FACTORY:
                     if(Boolean(_loc2_) && Boolean(param1.props.parent))
                     {
                        _loc13_ = param1.props.parent;
                        if(_loc13_.group)
                        {
                           _loc11_ = new Constraint();
                           this._constraints.push(_loc11_);
                           this._lastSpawns[_loc13_.group] = -1000;
                           this._spawnLimits[_loc13_.group] = param1.props.amount2;
                           this._spawnTotals[_loc13_.group] = 0;
                           this._spawnIntervals[_loc13_.group] = param1.props.amount > 0 ? Math.floor(param1.props.amount / 1000 * 42) : 17;
                           _loc14_ = int(_loc13_.group.length);
                           while(true)
                           {
                              if(_loc14_--)
                              {
                                 _loc15_ = this._bodies[_loc13_.group.objects[_loc14_]];
                                 if(_loc15_)
                                 {
                                    _loc15_.gmass = 0;
                                    _loc12_ = _loc15_.shapes.front();
                                    while(_loc12_)
                                    {
                                       _loc12_.sensor = 0;
                                       _loc12_.group = 0;
                                       _loc12_ = _loc12_.next;
                                    }
                                    if(_loc15_.graphic)
                                    {
                                       _loc15_.graphic.alpha = 0.25;
                                    }
                                    _loc15_.stopAll();
                                 }
                                 continue;
                              }
                           }
                        }
                     }
               }
            }
            if(_loc11_)
            {
               _loc11_.data = param1;
               if(_loc2_)
               {
                  this._constraintsBodies[_loc11_] = _loc2_;
               }
               this._constraintsAddedStates[_loc11_] = true;
            }
         }
      }
      
      protected function drawConstraints() : void
      {
         var _loc2_:Constraint = null;
         var _loc3_:ClassicCons = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc9_:GrooveJoint = null;
         var _loc1_:CxFastNode_Constraint = this._space.constraints.begin();
         var _loc8_:Graphics = this._view.constraints.graphics;
         _loc8_.clear();
         _loc8_.lineStyle(8,0,0.25);
         while(_loc1_)
         {
            _loc2_ = _loc1_.elem();
            if(_loc2_ is ClassicCons)
            {
               _loc3_ = _loc2_ as ClassicCons;
               _loc4_ = _loc3_.r1x + _loc3_.b1.px;
               _loc5_ = _loc3_.r1y + _loc3_.b1.py;
               _loc6_ = _loc3_.r2x + _loc3_.b2.px;
               _loc7_ = _loc3_.r2y + _loc3_.b2.py;
               _loc8_.moveTo(_loc4_,_loc5_);
               _loc8_.lineTo(_loc6_,_loc7_);
            }
            else if(_loc2_ is GrooveJoint)
            {
               _loc9_ = _loc2_ as GrooveJoint;
               _loc4_ = _loc9_.gax + _loc9_.b1.px;
               _loc5_ = _loc9_.gay + _loc9_.b1.py;
               _loc6_ = _loc9_.gbx + _loc9_.b1.px;
               _loc7_ = _loc9_.gby + _loc9_.b1.py;
               _loc8_.moveTo(_loc4_,_loc5_);
               _loc8_.lineTo(_loc6_,_loc7_);
               _loc4_ = _loc9_.r2x + _loc9_.b2.px;
               _loc5_ = _loc9_.r2y + _loc9_.b2.py;
               _loc6_ = _loc9_.b2.px;
               _loc7_ = _loc9_.b2.py;
               _loc8_.moveTo(_loc4_,_loc5_);
               _loc8_.lineTo(_loc6_,_loc7_);
            }
            _loc1_ = _loc1_.next;
         }
      }
      
      protected function checkCallbacks() : void
      {
         var _loc2_:Callback = null;
         var _loc1_:CxFastAllocList_Callback = this._space.callbacks;
         while(!_loc1_.empty())
         {
            _loc2_ = _loc1_.front();
            switch(_loc2_.type)
            {
               case Callback.SENSE_BEGIN:
                  this._events.handleSensorEvent(_loc2_);
                  break;
               case Callback.PHYSOBJ_OUTOFBOUNDS:
                  this._events.handleOutOfBoundsEvent(_loc2_.obj);
                  break;
            }
            _loc1_.pop();
         }
      }
      
      protected function checkControls() : void
      {
         var _loc2_:Constraint = null;
         var _loc3_:Modifier = null;
         var _loc4_:ModelObject = null;
         var _loc5_:Body = null;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:CxFastList_PhysObj = null;
         var _loc11_:PhysObj = null;
         var _loc12_:CxFastNode_PhysObj = null;
         var _loc13_:ViewSprite = null;
         var _loc14_:Number = NaN;
         var _loc15_:Boolean = false;
         var _loc16_:Body = null;
         var _loc1_:int = int(this._constraints.length);
         while(_loc1_--)
         {
            _loc2_ = this._constraints[_loc1_];
            _loc3_ = _loc2_.data as Modifier;
            _loc5_ = this._bodies[_loc3_.props.parent];
            _loc4_ = _loc5_.data as ModelObject;
            _loc8_ = _loc5_.gmass;
            if(!(_loc5_ != null && !this._bodiesLockStates[_loc5_] && _loc4_ != null && (!this._focusObjectStates[_loc4_] || this._focusObject == _loc4_)))
            {
               continue;
            }
            switch(_loc3_.props.type)
            {
               case CreatorUIStates.MODIFIER_ROTATOR:
                  if(Key.isDown(Keyboard.LEFT) || Key.isDown(Keyboard.RIGHT) || Key.charIsDown("a") || Key.charIsDown("d"))
                  {
                     if(Key.isDown(Keyboard.LEFT) || Key.charIsDown("a"))
                     {
                        SimpleMotor(_loc2_).rate = 0 - _loc3_.props.amount;
                     }
                     else
                     {
                        SimpleMotor(_loc2_).rate = _loc3_.props.amount;
                     }
                     if(_loc4_.props.constraint != CreatorUIStates.MOVEMENT_PIN && _loc4_.props.shape != CreatorUIStates.SHAPE_CIRCLE)
                     {
                        if(!this._constraintsAddedStates[_loc2_])
                        {
                           this._space.addConstraint(_loc2_);
                           this._space.wakeConstraint(_loc2_);
                           this._constraintsAddedStates[_loc2_] = true;
                        }
                     }
                     else
                     {
                        SimpleMotor(_loc2_).rate = SimpleMotor(_loc2_).rate * 2;
                     }
                     this._space.wakeObject(_loc5_);
                  }
                  else if(_loc4_.props.constraint != CreatorUIStates.MOVEMENT_PIN && _loc4_.props.shape != CreatorUIStates.SHAPE_CIRCLE)
                  {
                     if(this._constraintsAddedStates[_loc2_])
                     {
                        this._space.removeConstraint(_loc2_);
                        this._constraintsAddedStates[_loc2_] = false;
                     }
                  }
                  else
                  {
                     SimpleMotor(_loc2_).rate = 0;
                     this._space.wakeConstraint(_loc2_);
                  }
                  break;
               case CreatorUIStates.MODIFIER_MOVER:
                  if(this._constraintsAddedStates[_loc2_])
                  {
                     this._space.removeConstraint(_loc2_);
                     this._constraintsAddedStates[_loc2_] = false;
                  }
                  if(!_loc3_.props.optionB && (Key.isDown(Keyboard.UP) || Key.isDown(Keyboard.DOWN)) || !_loc3_.props.optionA && (Key.charIsDown("w") || Key.charIsDown("s")))
                  {
                     this._space.wakeObject(_loc5_);
                     if(!_loc5_.activeMotion())
                     {
                        this._space.warmStart();
                     }
                     this._force.x = _loc3_.props.childOffset.x / 5;
                     this._force.y = _loc3_.props.childOffset.y / 5;
                     Geom2d.rotate(this._force,_loc5_.a);
                     if(!_loc3_.props.optionB && Key.isDown(Keyboard.UP) || !_loc3_.props.optionA && Key.charIsDown("w"))
                     {
                        _loc5_.setVel(_loc5_.vx + this._force.x,_loc5_.vy + this._force.y);
                     }
                     else
                     {
                        _loc5_.setVel(_loc5_.vx - this._force.x,_loc5_.vy - this._force.y);
                     }
                     _loc5_.calcProperties();
                     _loc5_.gmass = _loc8_;
                     if(_loc4_.props.constraint == CreatorUIStates.MOVEMENT_SLIDE)
                     {
                        _loc5_.stopRotation();
                     }
                  }
                  break;
               case CreatorUIStates.MODIFIER_JUMPER:
                  if(this._constraintsAddedStates[_loc2_])
                  {
                     this._space.removeConstraint(_loc2_);
                     this._constraintsAddedStates[_loc2_] = false;
                  }
                  if(!_loc3_.props.optionB && Key.isDown(Keyboard.UP) || !_loc3_.props.optionA && Key.charIsDown("w"))
                  {
                     if(_loc3_.props.optionC && (this._jumpedTimes[_loc5_] == null || getTimer() - this._jumpedTimes[_loc5_] > 500) || !_loc5_.activeMotion() || _loc5_.vy > -3 && _loc5_.vy < 3 && !this._jumpedStates[_loc5_] || this._focusObjectOnFloor)
                     {
                        this._space.wakeObject(_loc5_);
                        if(!_loc5_.activeMotion())
                        {
                           this._space.warmStart();
                        }
                        this._force.x = _loc3_.props.childOffset.x * 5;
                        this._force.y = _loc3_.props.childOffset.y * 5;
                        _loc5_.setVel(this._force.x,this._force.y);
                        this._space.wakeObject(_loc5_);
                        _loc5_.calcProperties();
                        _loc5_.gmass = _loc8_;
                        if(_loc4_.props.constraint == CreatorUIStates.MOVEMENT_SLIDE)
                        {
                           _loc5_.stopRotation();
                        }
                        this._jumpedStates[_loc5_] = true;
                        if(_loc3_.props.optionC)
                        {
                           this._jumpedTimes[_loc5_] = getTimer();
                        }
                        this.playSound(_loc5_,Sounds.JUMP);
                     }
                  }
                  else
                  {
                     this._jumpedStates[_loc5_] = false;
                  }
                  break;
               case CreatorUIStates.MODIFIER_SLIDER:
                  if(this._constraintsAddedStates[_loc2_])
                  {
                     this._space.removeConstraint(_loc2_);
                     this._constraintsAddedStates[_loc2_] = false;
                  }
                  if(!_loc3_.props.optionB && (Key.isDown(Keyboard.LEFT) || Key.isDown(Keyboard.RIGHT)) || !_loc3_.props.optionA && (Key.charIsDown("a") || Key.charIsDown("d")))
                  {
                     this._space.wakeObject(_loc5_);
                     if(!_loc5_.activeMotion())
                     {
                        this._space.warmStart();
                     }
                     this._force.x = _loc3_.props.childOffset.x / 5;
                     this._force.y = _loc3_.props.childOffset.y / 5;
                     if(this.gravity == 0)
                     {
                        Geom2d.rotate(this._force,_loc5_.a);
                     }
                     if(!_loc3_.props.optionB && Key.isDown(Keyboard.LEFT) || !_loc3_.props.optionA && Key.charIsDown("a"))
                     {
                        _loc5_.setVel(_loc5_.vx + this._force.x,_loc5_.vy + this._force.y);
                     }
                     else
                     {
                        _loc5_.setVel(_loc5_.vx - this._force.x,_loc5_.vy - this._force.y);
                     }
                     _loc5_.calcProperties();
                     _loc5_.gmass = _loc8_;
                     if(_loc4_.props.constraint == CreatorUIStates.MOVEMENT_SLIDE)
                     {
                        _loc5_.stopRotation();
                     }
                     else if(_loc4_.props.constraint == CreatorUIStates.MOVEMENT_PIN)
                     {
                        _loc5_.stopMovement();
                     }
                  }
                  break;
               case CreatorUIStates.MODIFIER_ARCADEMOVER:
                  if(this._constraintsAddedStates[_loc2_])
                  {
                     this._space.removeConstraint(_loc2_);
                     this._constraintsAddedStates[_loc2_] = false;
                  }
                  if(this.gravity != 0)
                  {
                     _loc9_ = Math.abs(_loc5_.pre_py - _loc5_.py) < 3 && _loc5_.p_arbiters_false_false_true_true_Shape_Shape.head != null;
                  }
                  _loc14_ = Math.abs(_loc3_.props.amount);
                  if(!_loc3_.props.optionB && (Key.isDown(Keyboard.UP) || Key.isDown(Keyboard.DOWN)) || !_loc3_.props.optionA && (Key.charIsDown("w") || Key.charIsDown("s")) || !_loc3_.props.optionB && (Key.isDown(Keyboard.LEFT) || Key.isDown(Keyboard.RIGHT)) || !_loc3_.props.optionA && (Key.charIsDown("a") || Key.charIsDown("d")))
                  {
                     if(this.gravity == 0)
                     {
                        this._space.wakeObject(_loc5_);
                        if(!_loc5_.activeMotion())
                        {
                           this._space.warmStart();
                        }
                        this._force.x = this._force.y = 0;
                        if(!_loc3_.props.optionB && Key.isDown(Keyboard.UP) || !_loc3_.props.optionA && Key.charIsDown("w"))
                        {
                           this._force.y -= _loc14_;
                        }
                        if(!_loc3_.props.optionB && Key.isDown(Keyboard.DOWN) || !_loc3_.props.optionA && Key.charIsDown("s"))
                        {
                           this._force.y += _loc14_;
                        }
                        if(!_loc3_.props.optionB && Key.isDown(Keyboard.LEFT) || !_loc3_.props.optionA && Key.charIsDown("a"))
                        {
                           this._force.x -= _loc14_;
                        }
                        if(!_loc3_.props.optionB && Key.isDown(Keyboard.RIGHT) || !_loc3_.props.optionA && Key.charIsDown("d"))
                        {
                           this._force.x += _loc14_;
                        }
                        _loc5_.setVel(this._force.x * 10,this._force.y * 10);
                        _loc5_.calcProperties();
                     }
                     else
                     {
                        this._space.wakeObject(_loc5_);
                        if(!_loc5_.activeMotion())
                        {
                           this._space.warmStart();
                        }
                        this._force.x = this._force.y = 0;
                        _loc15_ = false;
                        if(_loc9_)
                        {
                           if(!_loc3_.props.optionB && Key.isDown(Keyboard.UP) || !_loc3_.props.optionA && Key.charIsDown("w"))
                           {
                              _loc15_ = true;
                           }
                           if(!_loc3_.props.optionB && Key.isDown(Keyboard.LEFT) || !_loc3_.props.optionA && Key.charIsDown("a"))
                           {
                              this._force.x -= _loc14_ * 4;
                           }
                           if(!_loc3_.props.optionB && Key.isDown(Keyboard.RIGHT) || !_loc3_.props.optionA && Key.charIsDown("d"))
                           {
                              this._force.x += _loc14_ * 4;
                           }
                        }
                        else
                        {
                           if(!_loc3_.props.optionB && Key.isDown(Keyboard.LEFT) || !_loc3_.props.optionA && Key.charIsDown("a"))
                           {
                              this._force.x -= _loc14_;
                           }
                           if(!_loc3_.props.optionB && Key.isDown(Keyboard.RIGHT) || !_loc3_.props.optionA && Key.charIsDown("d"))
                           {
                              this._force.x += _loc14_;
                           }
                        }
                        this._force.x /= _loc5_.imass;
                        this._force.y /= _loc5_.imass;
                        if(_loc15_)
                        {
                           _loc5_.applyRelativeForce(this._force.x,_loc14_ * -1200 / _loc5_.imass,0,0);
                        }
                        else
                        {
                           _loc5_.applyRelativeForce(this._force.x * 40,0,0,0);
                        }
                     }
                  }
                  else
                  {
                     if(this.gravity == 0)
                     {
                        _loc5_.setVel(0,0);
                     }
                     else if(_loc9_)
                     {
                        _loc5_.setVel(0,_loc5_.vy);
                     }
                     else
                     {
                        _loc5_.setVel(_loc5_.vx * 0.75,_loc5_.vy);
                     }
                     _loc5_.calcProperties();
                  }
                  if(_loc4_.props.constraint == CreatorUIStates.MOVEMENT_SLIDE)
                  {
                     _loc5_.stopRotation();
                  }
                  _loc5_.vx = Math.max(-10 * _loc14_,Math.min(20 * _loc14_,_loc5_.vx));
                  break;
               case CreatorUIStates.MODIFIER_ADDER:
                  _loc7_ = _loc3_.props.optionA ? this._mouseDown : Key.isDown(Keyboard.SPACE);
                  if((_loc7_) && this._frame - this._lastSpawns[_loc5_] > this._spawnIntervals[_loc5_])
                  {
                     this._spawnTotals[_loc5_] += 1;
                     _loc16_ = this.addObject(_loc4_,true,_loc5_.px,_loc5_.py,true);
                     this._force.x = _loc3_.props.childOffset.x * 2;
                     this._force.y = _loc3_.props.childOffset.y * 2;
                     _loc16_.a = _loc5_.a;
                     Geom2d.rotate(this._force,_loc5_.a);
                     if(Boolean(_loc5_) && _loc5_.graphic is ViewSprite)
                     {
                        _loc13_ = ViewSprite(_loc5_.graphic);
                        if(_loc13_.rotated)
                        {
                           Geom2d.rotate(this._force,_loc13_.rotation * Geom2d.dtr);
                           _loc16_.a += _loc13_.rotation * Geom2d.dtr;
                        }
                        else if(_loc13_.flipped)
                        {
                           if(_loc16_.graphic)
                           {
                              _loc16_.graphic.scaleX = -1;
                           }
                        }
                     }
                     _loc16_.vx = this._force.x;
                     _loc16_.vy = this._force.y;
                     this.playSound(_loc16_,Sounds.SPAWN);
                     this._spawnedBodyTimes[_loc16_] = this._lastSpawns[_loc5_] = this._frame;
                     this._spawnedBodyLifespans[_loc16_] = _loc3_.props.amount3 == 0 ? 100000000 : _loc3_.props.amount3 * 42;
                     if(_loc3_.props.optionB)
                     {
                        this._spawnedBodyExplodes[_loc16_] = true;
                     }
                     if(this._spawnLimits[_loc5_] > 0 && this._spawnTotals[_loc5_] >= this._spawnLimits[_loc5_])
                     {
                        this._spawnedBodyModifiers[_loc16_] = _loc3_;
                        this._spawnedBodyLastBodies.push(_loc16_);
                        this._space.removeConstraint(_loc2_);
                        if(this._constraints.indexOf(_loc2_) != -1)
                        {
                           this._constraints.splice(this._constraints.indexOf(_loc2_),1);
                        }
                        this.playSound(_loc5_,Sounds.EMPTY,1,false);
                     }
                     if(this._spawnLimits[_loc5_])
                     {
                        this._events.dispatchEvent(new ObjectEvent(States.EVENT_AMMOLOW,false,false,{
                           "x":_loc5_.px,
                           "y":_loc5_.py,
                           "total":this._spawnLimits[_loc5_] - this._spawnTotals[_loc5_]
                        }));
                     }
                     if(_loc16_ && _loc3_ && _loc3_.props && Boolean(_loc3_.props.parent))
                     {
                        this.addModifiersForSpawnedObject(_loc16_,_loc3_.props.parent);
                     }
                  }
                  else if(!_loc7_)
                  {
                     this._lastSpawns[_loc5_] = -5000;
                  }
                  break;
               case CreatorUIStates.MODIFIER_LAUNCHER:
                  if(this._view.mouseDown)
                  {
                     this._force.x = this._view.viewport.mouseX - _loc5_.px;
                     this._force.y = this._view.viewport.mouseY - _loc5_.py;
                     Geom2d.rotate(this._force,_loc5_.a);
                     _loc5_.setVel(this._force.x,this._force.y);
                     _loc10_ = this._space.touching(_loc5_);
                     if((Boolean(_loc10_)) && !_loc10_.empty())
                     {
                        _loc12_ = _loc10_.head;
                        while(_loc12_)
                        {
                           _loc11_ = _loc12_.elem();
                           if(_loc11_.hasGraphic && _loc11_.graphic && _loc5_.graphic.hitTestObject(_loc11_.graphic))
                           {
                              _loc11_.setVel(this._force.x,this._force.y);
                           }
                           _loc12_ = _loc12_.next;
                        }
                     }
                     this._space.wakeObject(_loc5_);
                  }
                  else
                  {
                     _loc5_.setVel(0,0);
                  }
                  break;
               case CreatorUIStates.MODIFIER_AIMER:
                  this._origin.x = this._view.viewport.mouseX;
                  this._origin.y = this._view.viewport.mouseY;
                  this._origin2.x = _loc5_.px;
                  this._origin2.y = _loc5_.py;
                  _loc6_ = Geom2d.angleBetween(this._origin2,this._origin);
                  _loc6_ = Geom2d.normalizeAngle(_loc6_);
                  if((_loc6_ = (_loc6_ = (_loc6_ = _loc6_ - Geom2d.normalizeAngle(_loc5_.a)) + Geom2d.HALFPI) % Geom2d.TWOPI) > Geom2d.PI)
                  {
                     _loc6_ -= Geom2d.TWOPI;
                  }
                  else if(_loc6_ < 0 - Geom2d.PI)
                  {
                     _loc6_ += Geom2d.TWOPI;
                  }
                  if(_loc6_ > 0.05)
                  {
                     SimpleMotor(_loc2_).rate = 2.5;
                  }
                  else if(_loc6_ < -0.05)
                  {
                     SimpleMotor(_loc2_).rate = -2.5;
                  }
                  else
                  {
                     SimpleMotor(_loc2_).rate = 0;
                  }
                  break;
               case CreatorUIStates.MODIFIER_THRUSTER:
                  if(this._constraintsAddedStates[_loc2_])
                  {
                     this._space.removeConstraint(_loc2_);
                     this._constraintsAddedStates[_loc2_] = false;
                  }
                  if(Key.isDown(_loc3_.props.amount))
                  {
                     this._space.wakeObject(_loc5_);
                     if(!_loc5_.activeMotion())
                     {
                        this._space.warmStart();
                     }
                     this._force.x = (_loc3_.props.childOffset.x - _loc3_.props.parentOffset.x) * 10000;
                     this._force.y = (_loc3_.props.childOffset.y - _loc3_.props.parentOffset.y) * 10000;
                     if(!_loc3_.props.optionA)
                     {
                        Geom2d.rotate(this._force,_loc5_.a);
                     }
                     this._origin.x = _loc3_.props.parentOffset.x;
                     this._origin.y = _loc3_.props.parentOffset.y;
                     Geom2d.rotate(this._origin,_loc5_.a);
                     this._origin.x += _loc5_.px;
                     this._origin.y += _loc5_.py;
                     _loc5_.applyGlobalForce(this._force.x,this._force.y,this._origin.x,this._origin.y);
                     _loc5_.calcProperties();
                     _loc5_.gmass = _loc8_;
                     if(_loc4_.props.constraint == CreatorUIStates.MOVEMENT_SLIDE)
                     {
                        _loc5_.stopRotation();
                     }
                     else if(_loc4_.props.constraint == CreatorUIStates.MOVEMENT_PIN)
                     {
                        _loc5_.stopMovement();
                     }
                  }
                  break;
            }
         }
      }
      
      protected function checkActuators() : void
      {
         var _loc2_:Constraint = null;
         var _loc3_:Modifier = null;
         var _loc4_:ModelObject = null;
         var _loc5_:Body = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:CxFastList_PhysObj = null;
         var _loc9_:PhysObj = null;
         var _loc10_:CxFastNode_PhysObj = null;
         var _loc11_:ViewSprite = null;
         var _loc12_:ViewSprite = null;
         var _loc13_:Number = NaN;
         var _loc14_:Body = null;
         var _loc15_:ModelObjectContainer = null;
         var _loc16_:PhysObj = null;
         var _loc17_:SimpleMotor = null;
         var _loc18_:Body = null;
         if(!this._running)
         {
            return;
         }
         if(this._events == null || this._events.ended)
         {
            return;
         }
         if(this._constraints == null || this._bodies == null)
         {
            return;
         }
         var _loc1_:int = int(this._constraints.length);
         while(_loc1_--)
         {
            _loc2_ = this._constraints[_loc1_];
            _loc3_ = _loc2_.data as Modifier;
            _loc5_ = this._bodies[_loc3_.props.parent];
            _loc7_ = _loc5_.gmass;
            if(!(_loc5_ != null && !this._bodiesLockStates[_loc5_]))
            {
               continue;
            }
            _loc4_ = _loc5_.data as ModelObject;
            switch(_loc3_.props.type)
            {
               case CreatorUIStates.MODIFIER_ELEVATOR:
                  this._space.wakeConstraint(_loc2_);
                  this._force.x = _loc3_.props.parentOffset.x - _loc3_.props.childOffset.x;
                  this._force.y = _loc3_.props.parentOffset.y - _loc3_.props.childOffset.y;
                  this._force.normalize(1);
                  this._origin.x = _loc5_.px - _loc4_.origin.x;
                  this._origin.y = _loc5_.py - _loc4_.origin.y;
                  _loc13_ = Geom2d.percentAlongLine(this._origin,_loc3_.props.parentOffset,_loc3_.props.childOffset);
                  if(this._elevatorStates[_loc3_.props.parent])
                  {
                     if(_loc13_ < 1)
                     {
                        _loc5_.px -= this._force.x;
                        _loc5_.py -= this._force.y;
                     }
                     else
                     {
                        this._elevatorStates[_loc3_.props.parent] = false;
                     }
                  }
                  else if(_loc13_ > 0.01)
                  {
                     _loc5_.px += this._force.x;
                     _loc5_.py += this._force.y;
                  }
                  else
                  {
                     this._elevatorStates[_loc3_.props.parent] = true;
                  }
                  _loc5_.stopMovement();
                  _loc5_.setVel((_loc5_.px - _loc5_.pre_px) * 45,(_loc5_.py - _loc5_.pre_py) * 45);
                  break;
               case CreatorUIStates.MODIFIER_SPAWNER:
                  if(_loc5_ && this._frame - this._lastSpawns[_loc5_] > this._spawnIntervals[_loc5_] && _loc4_ && _loc3_ && this._spawnTotals[_loc5_] != undefined)
                  {
                     this._spawnTotals[_loc5_] += 1;
                     _loc14_ = this.addObject(_loc4_,true,_loc5_.px,_loc5_.py,true);
                     this._force.x = _loc3_.props.childOffset.x * 2;
                     this._force.y = _loc3_.props.childOffset.y * 2;
                     _loc14_.a = _loc5_.a;
                     Geom2d.rotate(this._force,_loc5_.a);
                     if(Boolean(_loc5_) && _loc5_.graphic is ViewSprite)
                     {
                        _loc11_ = ViewSprite(_loc5_.graphic);
                        if(_loc11_.rotated)
                        {
                           Geom2d.rotate(this._force,_loc11_.rotation * Geom2d.dtr);
                           _loc14_.a += _loc11_.rotation * Geom2d.dtr;
                        }
                        else if(_loc11_.flipped)
                        {
                           if(_loc14_.graphic)
                           {
                              _loc14_.graphic.scaleX = -1;
                           }
                        }
                     }
                     _loc14_.vx = this._force.x;
                     _loc14_.vy = this._force.y;
                     this.playSound(_loc14_,Sounds.SPAWN);
                     this._spawnedBodyTimes[_loc14_] = this._lastSpawns[_loc5_] = this._frame;
                     this._spawnedBodyLifespans[_loc14_] = _loc3_.props.amount3 == 0 ? 100000000 : _loc3_.props.amount3 * 42;
                     if(_loc3_.props.optionB)
                     {
                        this._spawnedBodyExplodes[_loc14_] = true;
                     }
                     if(this._spawnLimits[_loc5_] > 0 && this._spawnTotals[_loc5_] >= this._spawnLimits[_loc5_])
                     {
                        this._spawnedBodyModifiers[_loc14_] = _loc3_;
                        this._spawnedBodyLastBodies.push(_loc14_);
                        this._space.removeConstraint(_loc2_);
                        if(this._constraints.indexOf(_loc2_) != -1)
                        {
                           this._constraints.splice(this._constraints.indexOf(_loc2_),1);
                        }
                        this.playSound(_loc5_,Sounds.EMPTY);
                        this.removeObject(_loc5_);
                     }
                     if(_loc14_ && _loc3_ && _loc3_.props && Boolean(_loc3_.props.parent))
                     {
                        this.addModifiersForSpawnedObject(_loc14_,_loc3_.props.parent);
                     }
                  }
                  break;
               case CreatorUIStates.MODIFIER_FACTORY:
                  if(_loc5_.data is ModelObject && Boolean(_loc5_.data.group))
                  {
                     _loc15_ = _loc5_.data.group as ModelObjectContainer;
                     if(this._frame - this._lastSpawns[_loc15_] > this._spawnIntervals[_loc15_])
                     {
                        this._spawnTotals[_loc15_] += 1;
                        this._lastSpawns[_loc15_] = this._frame;
                        this.addGroup(_loc15_,_loc3_.props.amount3,_loc3_.props.optionB);
                        if(this._spawnLimits[_loc15_] > 0 && this._spawnTotals[_loc15_] >= this._spawnLimits[_loc15_])
                        {
                           if(_loc15_.objects.length > 0)
                           {
                              if(this._bodies[_loc15_.objects[0]] is PhysObj)
                              {
                                 this._spawnedBodyModifiers[this._bodies[_loc15_.objects[0]]] = _loc3_;
                                 this._spawnedBodyLastBodies.push(this._bodies[_loc15_.objects[0]]);
                              }
                           }
                           this._space.removeConstraint(_loc2_);
                           if(this._constraints.indexOf(_loc2_) != -1)
                           {
                              this._constraints.splice(this._constraints.indexOf(_loc2_),1);
                           }
                           this.playSound(_loc5_,Sounds.EMPTY);
                           this.removeGroup(_loc15_);
                        }
                        if(_loc15_.objects.length > 0 && Boolean(this._bodies[_loc15_.objects[0]]))
                        {
                           this.playSound(this._bodies[_loc15_.objects[0]],Sounds.SPAWN);
                        }
                     }
                  }
                  break;
               case CreatorUIStates.MODIFIER_CONNECTOR:
                  this._force.x = _loc3_.props.child.x - _loc3_.props.parent.x;
                  this._force.y = _loc3_.props.child.y - _loc3_.props.parent.y;
                  if(Boolean(_loc5_) && _loc5_.graphic is ViewSprite)
                  {
                     _loc11_ = ViewSprite(_loc5_.graphic);
                     if(_loc11_.rotated)
                     {
                        Geom2d.rotate(this._force,_loc11_.rotation * Geom2d.dtr);
                     }
                     else if(_loc11_.flipped)
                     {
                        this._force.x = 0 - this._force.x;
                     }
                  }
                  Geom2d.rotate(this._force,_loc5_.a);
                  if(_loc5_.added_to_space)
                  {
                     this._force.x += _loc5_.px;
                     this._force.y += _loc5_.py;
                     PivotJoint(_loc2_).a1x = this._force.x;
                     PivotJoint(_loc2_).a1y = this._force.y;
                     _loc16_ = PivotJoint(_loc2_).b2;
                     if(_loc5_.graphic is ViewSprite && _loc16_ && _loc16_.graphic is ViewSprite)
                     {
                        _loc11_ = ViewSprite(_loc5_.graphic);
                        (_loc12_ = ViewSprite(_loc16_.graphic)).flipped = _loc11_.flipped;
                        if(_loc11_.rotated)
                        {
                           _loc12_.rotated = _loc11_.rotated;
                           _loc12_.rotatedRotation = _loc11_.rotation;
                        }
                        else if(_loc11_.flipped)
                        {
                           _loc12_.scaleX = -1;
                        }
                        else
                        {
                           _loc12_.scaleX = 1;
                        }
                     }
                     if(Boolean(_loc16_) && _loc16_.added_to_space)
                     {
                        this._force.x -= _loc16_.px;
                        this._force.y -= _loc16_.py;
                        _loc16_.px += this._force.x;
                        _loc16_.py += this._force.y;
                        _loc16_.allowAll();
                        _loc16_.stopMovement();
                        _loc16_.setVel(this._force.x * 45,this._force.y * 45);
                     }
                     this._space.wakeConstraint(_loc2_);
                     if(this._gearJoints[_loc16_])
                     {
                        this._space.wakeConstraint(this._gearJoints[_loc16_]);
                        if(Boolean(_loc12_) && Boolean(_loc12_.modelObject))
                        {
                           GearJoint(this._gearJoints[_loc16_]).biasCoef = 1;
                           if(_loc12_.flipped)
                           {
                              GearJoint(this._gearJoints[_loc16_]).phase = 0 - _loc12_.modelObject.rotation * Geom2d.dtr;
                           }
                           else
                           {
                              GearJoint(this._gearJoints[_loc16_]).phase = _loc12_.modelObject.rotation * Geom2d.dtr;
                           }
                        }
                     }
                  }
                  break;
               case CreatorUIStates.MODIFIER_MAGNET:
                  _loc8_ = this._space.touching(_loc5_);
                  if((Boolean(_loc8_)) && !_loc8_.empty())
                  {
                     _loc10_ = _loc8_.head;
                     while(_loc10_)
                     {
                        _loc9_ = _loc10_.elem();
                        if(_loc5_ && _loc5_.graphic && _loc9_ && _loc9_ != _loc5_ && _loc9_.data is ModelObject && ModelObject(_loc9_.data).props && ModelObject(_loc9_.data).props.material == CreatorUIStates.MATERIAL_STEEL && _loc9_.graphic && _loc5_.graphic.hitTestObject(_loc9_.graphic))
                        {
                           this._force.x = _loc5_.px - _loc9_.px;
                           this._force.y = _loc5_.py - _loc9_.py;
                           this._force.x *= Math.min(_loc5_.gmass,2000);
                           this._force.y *= Math.min(_loc5_.gmass,2000);
                           _loc9_.applyRelativeForce(this._force.x * 100,this._force.y * 100,0,0);
                           _loc5_.applyRelativeForce(0 - this._force.x * 100,0 - this._force.y * 100,0,0);
                        }
                        _loc10_ = _loc10_.next;
                     }
                     this._space.wakeObject(_loc5_);
                  }
                  break;
               case CreatorUIStates.MODIFIER_EMAGNET:
                  if(Key.isDown(Keyboard.SPACE) && !this._emagnetPressed[_loc5_])
                  {
                     this._emagnetPressed[_loc5_] = true;
                     this._emagnetStates[_loc5_] = !this._emagnetStates[_loc5_];
                  }
                  else if(!Key.isDown(Keyboard.SPACE))
                  {
                     this._emagnetPressed[_loc5_] = false;
                  }
                  if(Boolean(_loc5_.graphic) && _loc5_.graphic is ViewSprite)
                  {
                     ViewSprite(_loc5_.graphic).halo = this._emagnetStates[_loc5_];
                     if(this._emagnetStates[_loc5_])
                     {
                        ViewSprite(_loc5_.graphic).drawExtras();
                     }
                     else
                     {
                        ViewSprite(_loc5_.graphic).clearExtras();
                     }
                  }
                  if(this._emagnetStates[_loc5_])
                  {
                     _loc8_ = this._space.touching(_loc5_);
                     if((Boolean(_loc8_)) && !_loc8_.empty())
                     {
                        _loc10_ = _loc8_.head;
                        while(_loc10_)
                        {
                           _loc9_ = _loc10_.elem();
                           if(_loc5_ && _loc5_.graphic && _loc9_ && _loc9_ != _loc5_ && _loc9_.data is ModelObject && ModelObject(_loc9_.data).props && ModelObject(_loc9_.data).props.material == CreatorUIStates.MATERIAL_STEEL && _loc9_.graphic && _loc5_.graphic.hitTestObject(_loc9_.graphic))
                           {
                              this._force.x = _loc5_.px - _loc9_.px;
                              this._force.y = _loc5_.py - _loc9_.py;
                              this._force.x *= Math.min(_loc5_.gmass,2000);
                              this._force.y *= Math.min(_loc5_.gmass,2000);
                              _loc9_.applyRelativeForce(this._force.x * 100,this._force.y * 100,0,0);
                              _loc5_.applyRelativeForce(0 - this._force.x * 100,0 - this._force.y * 100,0,0);
                           }
                           _loc10_ = _loc10_.next;
                        }
                        this._space.wakeObject(_loc5_);
                     }
                  }
                  break;
               case CreatorUIStates.MODIFIER_SWITCHER:
                  if(this._motors[_loc3_.props.parent])
                  {
                     _loc17_ = this._motors[_loc3_.props.parent];
                     if(Math.random() > 0.99 && this._frame - this._switchTimes[_loc5_] > 33)
                     {
                        _loc17_.rate = 0 - _loc17_.rate;
                        this._switchTimes[_loc5_] = this._frame;
                     }
                  }
                  if(this._elevators[_loc3_.props.parent])
                  {
                     if(Math.random() > 0.99 && this._frame - this._switchTimes[_loc5_] > 33)
                     {
                        this._elevatorStates[_loc3_.props.parent] = !this._elevatorStates[_loc3_.props.parent];
                        this._switchTimes[_loc5_] = this._frame;
                     }
                  }
                  break;
               case CreatorUIStates.MODIFIER_POINTER:
                  if(this._focusObject)
                  {
                     _loc18_ = this._bodies[this._focusObject];
                     if(_loc18_)
                     {
                        this._origin.x = _loc18_.px;
                        this._origin.y = _loc18_.py;
                        this._origin2.x = _loc5_.px;
                        this._origin2.y = _loc5_.py;
                        _loc6_ = Geom2d.angleBetween(this._origin2,this._origin);
                        _loc6_ = Geom2d.normalizeAngle(_loc6_);
                        if((_loc6_ = (_loc6_ = (_loc6_ = _loc6_ - Geom2d.normalizeAngle(_loc5_.a)) + Geom2d.HALFPI) % Geom2d.TWOPI) > Geom2d.PI)
                        {
                           _loc6_ -= Geom2d.TWOPI;
                        }
                        else if(_loc6_ < 0 - Geom2d.PI)
                        {
                           _loc6_ += Geom2d.TWOPI;
                        }
                        if(_loc6_ > 0.05)
                        {
                           SimpleMotor(_loc2_).rate = 2.5;
                        }
                        else if(_loc6_ < -0.05)
                        {
                           SimpleMotor(_loc2_).rate = -2.5;
                        }
                        else
                        {
                           SimpleMotor(_loc2_).rate = 0;
                        }
                     }
                  }
                  break;
               case CreatorUIStates.MODIFIER_PROPELLER:
                  if(this._constraintsAddedStates[_loc2_])
                  {
                     this._space.removeConstraint(_loc2_);
                     this._constraintsAddedStates[_loc2_] = false;
                  }
                  this._space.wakeObject(_loc5_);
                  if(!_loc5_.activeMotion())
                  {
                     this._space.warmStart();
                  }
                  this._force.x = (_loc3_.props.childOffset.x - _loc3_.props.parentOffset.x) * 5000;
                  this._force.y = (_loc3_.props.childOffset.y - _loc3_.props.parentOffset.y) * 5000;
                  Geom2d.rotate(this._force,_loc5_.a);
                  this._origin.x = _loc3_.props.parentOffset.x;
                  this._origin.y = _loc3_.props.parentOffset.y;
                  Geom2d.rotate(this._origin,_loc5_.a);
                  this._origin.x += _loc5_.px;
                  this._origin.y += _loc5_.py;
                  _loc5_.applyGlobalForce(this._force.x,this._force.y,this._origin.x,this._origin.y);
                  _loc5_.calcProperties();
                  _loc5_.gmass = _loc7_;
                  if(Boolean(_loc4_) && Boolean(_loc4_.props))
                  {
                     if(_loc4_.props.constraint == CreatorUIStates.MOVEMENT_SLIDE)
                     {
                        _loc5_.stopRotation();
                     }
                     else if(_loc4_.props.constraint == CreatorUIStates.MOVEMENT_PIN)
                     {
                        _loc5_.stopMovement();
                     }
                  }
                  break;
            }
         }
      }
      
      protected function checkSpawnedBodies() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:PhysObj = null;
         var _loc4_:Modifier = null;
         var _loc5_:Object = null;
         for(_loc5_ in this._spawnedBodyTimes)
         {
            _loc1_ = this._frame - this._spawnedBodyTimes[_loc5_];
            if(_loc1_ > this._spawnedBodyLifespans[_loc5_])
            {
               delete this._spawnedBodyTimes[_loc5_];
               delete this._spawnedBodyLifespans[_loc5_];
               if(_loc5_ is PhysObj)
               {
                  _loc3_ = _loc5_ as PhysObj;
                  _loc2_ = int(this._spawnedBodyLastBodies.indexOf(_loc3_));
                  _loc4_ = this._spawnedBodyModifiers[_loc3_];
                  if(_loc2_ != -1)
                  {
                     this._events.handleEmptyEvent(_loc3_,_loc4_);
                     this._spawnedBodyLastBodies.splice(_loc2_,1);
                  }
               }
               if(this._spawnedBodyExplodes[_loc5_])
               {
                  this.explodeObject(_loc5_ as PhysObj);
               }
               else
               {
                  this.removeObject(_loc5_ as PhysObj,View.EFFECT_BLOOM);
               }
            }
         }
      }
      
      protected function checkDraggedObject() : void
      {
         if(this._dragConstraint)
         {
            this._dragConstraint.a2x = this._view.viewport.mouseX;
            this._dragConstraint.a2y = this._view.viewport.mouseY;
            this._space.wakeConstraint(this._dragConstraint);
         }
      }
      
      protected function checkCollisionForces() : void
      {
         var _loc2_:Vec2 = null;
         var _loc3_:Number = NaN;
         var _loc4_:ModelObject = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc9_:PhysObj = null;
         var _loc10_:int = 0;
         var _loc11_:Modifier = null;
         var _loc13_:Number = NaN;
         var _loc1_:CxFastNode_PhysObj = this._space.objects.begin();
         var _loc7_:Boolean = false;
         var _loc8_:Vector.<PhysObj> = new Vector.<PhysObj>();
         do
         {
            if(Boolean(_loc1_) && Boolean(_loc1_.elem()))
            {
               _loc9_ = _loc1_.elem();
               _loc2_ = this._space.impactImpulse(_loc9_);
               _loc3_ = this._space.pressure(_loc9_);
               _loc4_ = _loc9_.data;
               if(this._focusBody)
               {
                  _loc13_ = Math.abs(this._space.totalImpulsesWithFriction(this._focusBody).px) / 15000;
                  if(_loc13_ < 1)
                  {
                     this.frictionAmount += (_loc13_ - 0.25) * 0.005;
                  }
                  if(Math.abs(this._focusBody.vx) < 5)
                  {
                     this.frictionAmount -= 0.02;
                  }
                  this.frictionAmount = Math.min(0.5,Math.max(0,this.frictionAmount));
                  if(_sounds.noisePlaying)
                  {
                     _sounds.noiseVolume = this.frictionAmount * 0.25;
                  }
                  else
                  {
                     this.playSound(_loc9_,Sounds.FRICTION,this.frictionAmount * 0.25);
                  }
                  if(this._jointedBodies[this._focusBody] == null)
                  {
                     this._focusObjectOnFloor = this._space.totalImpulsesWithFriction(this._focusBody).py < -12000;
                  }
               }
               else if(_sounds.noisePlaying && _sounds.noiseVolume > 0)
               {
                  _sounds.noiseVolume = 0;
               }
               if(Boolean(_loc4_) && Boolean(_loc4_.props))
               {
                  if(_loc2_.lsq() > 1000000)
                  {
                     _loc5_ = _loc2_.length() * _loc9_.cmass;
                     _loc7_ = false;
                     if(_loc4_.props.strength != CreatorUIStates.STRENGTH_PERM)
                     {
                        switch(_loc4_.props.strength)
                        {
                           case CreatorUIStates.STRENGTH_STRONG:
                              _loc6_ = 500;
                              break;
                           case CreatorUIStates.STRENGTH_MEDIUM:
                              _loc6_ = 250;
                              break;
                           case CreatorUIStates.STRENGTH_WEAK:
                              _loc6_ = 100;
                        }
                        if(_loc5_ > _loc6_)
                        {
                           _loc7_ = true;
                           this.playSound(_loc9_,Sounds.CRASH,_loc5_ / 600);
                           _loc8_.push(_loc9_);
                           _loc10_ = int(this._spawnedBodyLastBodies.indexOf(_loc9_));
                           _loc11_ = this._spawnedBodyModifiers[_loc9_];
                           if(_loc10_ != -1)
                           {
                              this._events.handleEmptyEvent(_loc9_,_loc11_);
                              this._spawnedBodyLastBodies.splice(_loc10_,1);
                           }
                        }
                     }
                     if(!_loc7_ && _loc5_ > 70)
                     {
                        if(_loc9_ == this._focusBody)
                        {
                           if(_loc5_ > 300)
                           {
                              this.playSound(_loc9_,Sounds.SELF_BUMP,1);
                           }
                           else if(_loc5_ > 150)
                           {
                              this.playSound(_loc9_,Sounds.BUMP_BIG,1);
                           }
                           else
                           {
                              this.playSound(_loc9_,Sounds.BUMP,1);
                           }
                        }
                        else if(_loc5_ > 500)
                        {
                           if(_loc4_.props.material == CreatorUIStates.MATERIAL_ICE || _loc4_.props.material == CreatorUIStates.MATERIAL_STEEL || _loc4_.props.material == CreatorUIStates.MATERIAL_MAGNET)
                           {
                              if(_loc5_ > 800)
                              {
                                 this.playSound(_loc9_,Sounds.CLANG,_loc5_ / 600);
                              }
                              else
                              {
                                 this.playSound(_loc9_,Sounds.SWOOSH,_loc5_ / 600);
                              }
                           }
                           else if(_loc5_ > 800)
                           {
                              this.playSound(_loc9_,Sounds.RESONATE_LONG,_loc5_ / 600);
                           }
                           else
                           {
                              this.playSound(_loc9_,Sounds.RESONATE,_loc5_ / 600);
                           }
                        }
                        if(_loc4_.props.material == CreatorUIStates.MATERIAL_ICE || _loc4_.props.material == CreatorUIStates.MATERIAL_STEEL || _loc4_.props.material == CreatorUIStates.MATERIAL_MAGNET)
                        {
                           if(_loc5_ > 500)
                           {
                              this.playSound(_loc9_,Sounds.TINK_BIG,_loc5_ / 200);
                           }
                           else
                           {
                              this.playSound(_loc9_,Sounds.TINK,_loc5_ / 300);
                           }
                        }
                        else if(_loc5_ > 500)
                        {
                           this.playSound(_loc9_,Sounds.BUMP_BIG,_loc5_ / 200);
                        }
                        else
                        {
                           this.playSound(_loc9_,Sounds.BUMP,_loc5_ / 300);
                        }
                     }
                     else if(!_loc7_ && _loc5_ > 40)
                     {
                        this.playSound(_loc9_,Sounds.TOUCH,_loc5_ / 300);
                     }
                  }
               }
            }
            if(_loc1_)
            {
               _loc1_ = _loc1_.next;
            }
         }
         while(_loc1_ != null);
         
         var _loc12_:int = int(_loc8_.length);
         while(_loc12_--)
         {
            this._events.handleCrushEvent(_loc8_[_loc12_]);
            this.removeObject(_loc8_[_loc12_],View.EFFECT_SHATTER);
         }
      }
      
      protected function onObjectClick(param1:MouseEvent) : void
      {
         var _loc2_:PhysObj = this._focusObjectMap[param1.target];
         if(_loc2_ && _loc2_.data is ModelObject && _loc2_.added_to_space)
         {
            this._focusObject = ModelObject(_loc2_.data);
            this._focusBody = _loc2_;
         }
      }
      
      protected function onObjectPress(param1:MouseEvent) : void
      {
         var _loc2_:PhysObj = this._focusObjectMap[param1.target];
         if(_loc2_ && _loc2_.data is ModelObject && _loc2_.added_to_space)
         {
            this._dragObject = ModelObject(_loc2_.data);
            this._dragConstraint = new PivotJoint(_loc2_,this._space.STATIC,new Vec2(this._view.viewport.mouseX,this._view.viewport.mouseY));
            this._dragConstraint.maxBias = 3000000;
            this._dragConstraint.maxForce = 6000000;
            this._space.addConstraint(this._dragConstraint);
         }
      }
      
      protected function onObjectClickSensor(param1:MouseEvent) : void
      {
         var _loc2_:PhysObj = this._focusObjectMap[param1.target];
         if(_loc2_)
         {
            this._events.handleClickSensorEvent(_loc2_);
         }
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         this._mouseDown = true;
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         this._mouseDown = false;
         if(this._dragConstraint)
         {
            if(this._space)
            {
               this._space.removeConstraint(this._dragConstraint);
            }
            this._dragConstraint = null;
            this._dragObject = null;
         }
      }
      
      public function start() : void
      {
         var _loc1_:CxFastNode_PhysObj = null;
         if(!this._running)
         {
            if(Boolean(this._firstControlledObject) && this._focusObject == null)
            {
               this._focusObject = this._firstControlledObject;
               this._focusBody = this._bodies[this._firstControlledObject];
            }
            this._container.stage.addEventListener(Event.ENTER_FRAME,this.stepDouble,false,0,true);
            this._view.zSort();
            if(this._turbo && this._container && Boolean(this._container.stage))
            {
               this._container.stage.quality = StageQuality.LOW;
            }
            else
            {
               this._container.stage.quality = StageQuality.HIGH;
            }
            this._running = true;
            _loc1_ = this._space.objects.begin();
            while(_loc1_)
            {
               _loc1_.elem().update();
               _loc1_ = _loc1_.next;
            }
            if(this._environment.vMusic != "")
            {
               _sounds.resumeSong();
            }
         }
      }
      
      public function playSound(param1:PhysObj, param2:String, param3:Number = 1, param4:Boolean = true) : void
      {
         if(!this._running)
         {
            return;
         }
         if(Boolean(_sounds) && Boolean(param2.length))
         {
            if(param1 == this._focusBody)
            {
               param3 = 1;
            }
            _sounds.addSound(param1,param2,param4 && this._environment.size == Environment.SIZE_FOLLOW,param3);
         }
      }
      
      protected function addPivotGroups() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Body = null;
         var _loc3_:Body = null;
         var _loc4_:PivotJoint = null;
         var _loc5_:Group = null;
         var _loc6_:Group = null;
         var _loc8_:CxFastNode_PhysObj = null;
         var _loc7_:Dictionary = this._pivotJointGroupMap;
         _loc1_ = int(this._pivotJoints.length);
         while(_loc1_--)
         {
            _loc4_ = this._pivotJoints[_loc1_];
            _loc2_ = _loc4_.b1 as Body;
            _loc3_ = _loc4_.b2 as Body;
            if(Boolean(_loc2_.group_obj) && this._groups.indexOf(_loc2_.group_obj) != -1)
            {
               _loc7_[_loc2_] = this._groups[this._groups.indexOf(_loc2_.group_obj)];
            }
            if(Boolean(_loc3_.group_obj) && this._groups.indexOf(_loc3_.group_obj) != -1)
            {
               _loc7_[_loc3_] = this._groups[this._groups.indexOf(_loc3_.group_obj)];
            }
            if(Boolean(_loc7_[_loc2_]) && Boolean(_loc7_[_loc3_]))
            {
               if(_loc7_[_loc2_] != _loc7_[_loc3_])
               {
                  _loc5_ = _loc7_[_loc2_] as Group;
                  _loc6_ = _loc7_[_loc3_] as Group;
                  _loc8_ = _loc6_.objs.begin();
                  while(_loc8_)
                  {
                     _loc5_.addObject(_loc8_.elem());
                     _loc7_[_loc8_.elem()] = _loc5_;
                     _loc8_ = _loc8_.next;
                  }
                  if(this._pivotJointGroups.indexOf(_loc6_) != -1)
                  {
                     this._pivotJointGroups.splice(this._pivotJointGroups.indexOf(_loc6_),1);
                  }
                  _loc7_[_loc3_] = _loc5_;
               }
            }
            else if(_loc7_[_loc2_])
            {
               _loc5_ = _loc7_[_loc2_] as Group;
               _loc5_.addObject(_loc3_);
               _loc7_[_loc3_] = _loc5_;
            }
            else if(_loc7_[_loc3_])
            {
               _loc5_ = _loc7_[_loc3_] as Group;
               _loc5_.addObject(_loc2_);
               _loc7_[_loc2_] = _loc5_;
            }
            else
            {
               (_loc5_ = new Group()).ignore = true;
               _loc5_.addObject(_loc2_);
               _loc7_[_loc2_] = _loc5_;
               _loc5_.addObject(_loc3_);
               _loc7_[_loc3_] = _loc5_;
               this._pivotJointGroups.push(_loc5_);
            }
         }
         _loc1_ = int(this._pivotJointGroups.length);
         while(_loc1_--)
         {
            this._space.addGroup(this._pivotJointGroups[_loc1_]);
         }
         this._pivotJoints = new Vector.<PivotJoint>();
         this._pivotJointGroups = new Vector.<Group>();
         this._pivotJointGroupMap = new Dictionary(true);
      }
      
      protected function addGroup(param1:ModelObjectContainer, param2:int = 0, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ModelObject = null;
         var _loc6_:Body = null;
         var _loc8_:Modifier = null;
         var _loc7_:Dictionary = new Dictionary(false);
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1.objects[_loc4_];
            _loc6_ = this.addObject(_loc5_,true);
            if(param3)
            {
               this._spawnedBodyExplodes[_loc6_] = true;
            }
            this._spawnedBodyTimes[_loc6_] = this._frame;
            this._spawnedBodyLifespans[_loc6_] = param2 == 0 ? 100000000 : param2 * 42;
            _loc7_[_loc5_] = _loc6_.data;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this._model.modifiers.objects.length)
         {
            if(this._model.modifiers.objects[_loc4_] && this._model.modifiers.objects[_loc4_].props && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_FACTORY && this._model.modifiers.objects[_loc4_].props.parent && param1.contains(this._model.modifiers.objects[_loc4_].props.parent))
            {
               _loc8_ = this._model.modifiers.objects[_loc4_].clone();
               _loc8_.props.parent = _loc7_[_loc8_.props.parent];
               if(Boolean(_loc8_.props.child) && _loc8_.props.child.group == param1)
               {
                  _loc8_.props.child = _loc7_[_loc8_.props.child];
               }
               this.addModifier(_loc8_);
            }
            _loc4_++;
         }
         this.addPivotGroups();
      }
      
      protected function addModifiersForSpawnedObject(param1:PhysObj, param2:ModelObject) : void
      {
         var _loc3_:Modifier = null;
         var _loc4_:int = 0;
         while(_loc4_ < this._model.modifiers.objects.length)
         {
            if(param1 && param1.data is ModelObject && this._model.modifiers.objects[_loc4_] && this._model.modifiers.objects[_loc4_].props && this._model.modifiers.objects[_loc4_].props.parent == param2 && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_FACTORY && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_SPAWNER && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_ADDER && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_CONNECTOR && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_UNLOCKER && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_GROOVEJOINT && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_GEARJOINT && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_LAUNCHER && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_PUSHER && this._model.modifiers.objects[_loc4_].props.type != CreatorUIStates.MODIFIER_ELEVATOR)
            {
               _loc3_ = this._model.modifiers.objects[_loc4_].clone();
               _loc3_.props.parent = ModelObject(param1.data);
               this.addModifier(_loc3_);
            }
            _loc4_++;
         }
      }
      
      protected function addObject(param1:ModelObject, param2:Boolean = false, param3:Number = NaN, param4:Number = NaN, param5:Boolean = false) : Body
      {
         var _loc7_:Modifier = null;
         var _loc8_:Body = null;
         var _loc9_:Body = null;
         var _loc10_:ViewSprite = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:PivotJoint = null;
         var _loc16_:Array = null;
         var _loc17_:GeomPoly = null;
         var _loc18_:Vector.<Point> = null;
         var _loc19_:Point = null;
         var _loc20_:Sprite = null;
         var _loc21_:Point = null;
         var _loc22_:Constraint = null;
         var _loc23_:Modifier = null;
         if(param2)
         {
            param1 = param1.clone();
         }
         var _loc6_:UniformSpace = this._space;
         _loc8_ = null;
         _loc11_ = param1.origin.x;
         _loc12_ = param1.origin.y;
         if(!isNaN(param3))
         {
            _loc11_ = param3;
         }
         if(!isNaN(param4))
         {
            _loc12_ = param4;
         }
         this._events.registerActions(param1);
         switch(param1.props.shape)
         {
            case CreatorUIStates.SHAPE_CIRCLE:
               _loc8_ = Tools.createCircle(_loc11_,_loc12_,param1.props.size,0,0,0,false,true,Constants.getMaterial(param1.props.material),param1.props.collision_group,param1.props.sensor_group);
               break;
            case CreatorUIStates.SHAPE_BOX:
            case CreatorUIStates.SHAPE_SQUARE:
               _loc8_ = Tools.createBox(_loc11_,_loc12_,param1.props.width,param1.props.height,0,0,0,false,Constants.getMaterial(param1.props.material),param1.props.collision_group,param1.props.sensor_group);
               break;
            case CreatorUIStates.SHAPE_PENT:
            case CreatorUIStates.SHAPE_HEX:
               _loc8_ = Tools.createRegular(_loc11_,_loc12_,param1.props.width / 2,param1.props.height / 2,param1.props.shape == CreatorUIStates.SHAPE_PENT ? 5 : 6,0,0,0,false,true,Constants.getMaterial(param1.props.material),param1.props.collision_group,param1.props.sensor_group);
               break;
            case CreatorUIStates.SHAPE_RAMP:
               _loc16_ = [];
               _loc16_.push(new Vec2(_loc11_ + param1.props.width / 2,_loc12_ - param1.props.height / 2));
               _loc16_.push(new Vec2(_loc11_ + param1.props.width / 2,_loc12_ + param1.props.height / 2));
               _loc16_.push(new Vec2(_loc11_ - param1.props.width / 2,_loc12_ + param1.props.height / 2));
            case CreatorUIStates.SHAPE_POLY:
               if(_loc16_ == null)
               {
                  _loc16_ = [];
                  _loc18_ = param1.props.verticesClone();
                  _loc14_ = 0;
                  while(_loc14_ < param1.props.vertices.length)
                  {
                     _loc16_.push(new Vec2(_loc18_[_loc14_].x + _loc11_,_loc18_[_loc14_].y + _loc12_));
                     _loc14_++;
                  }
               }
               _loc17_ = new GeomPoly(_loc16_);
               if(!_loc17_.selfIntersecting())
               {
                  if(!_loc17_.cw())
                  {
                     _loc17_.points.reverse();
                  }
                  _loc8_ = Tools.createConcave(_loc17_,0,0,0,false,Constants.getMaterial(param1.props.material),param1.props.collision_group,param1.props.sensor_group);
               }
               _loc16_ = null;
         }
         if(_loc8_)
         {
            this._bodies[param1] = _loc8_;
            this._bodiesLockStates[_loc8_] = param5 ? false : param1.props.locked;
            _loc8_.properties.angDamp = this.angDamp;
            _loc8_.properties.linDamp = this.linDamp;
            if(param1.props.shape == CreatorUIStates.SHAPE_POLY)
            {
               _loc20_ = new Sprite();
               Shapes.drawShape(_loc20_.graphics,param1.props.vertices);
               _loc19_ = new Point(_loc8_.graphic.getRect(_loc8_.graphic).x - _loc20_.getRect(_loc20_).x,_loc8_.graphic.getRect(_loc8_.graphic).y - _loc20_.getRect(_loc20_).y);
            }
            else if(param1.props.shape == CreatorUIStates.SHAPE_PENT || param1.props.shape == CreatorUIStates.SHAPE_HEX)
            {
               _loc19_ = new Point();
            }
            else
            {
               _loc19_ = new Point(_loc8_.graphic.getRect(_loc8_.graphic).x + _loc8_.graphic.getRect(_loc8_.graphic).width / 2,_loc8_.graphic.getRect(_loc8_.graphic).y + _loc8_.graphic.getRect(_loc8_.graphic).height / 2);
            }
            _loc10_ = this._view.register(param1,_loc19_,_loc8_);
            _loc8_.assignGraphic(_loc10_);
            _loc8_.update();
            if(param1.rotation != 0)
            {
               _loc21_ = _loc19_.clone();
               Geom2d.rotate(_loc21_,param1.rotation * Geom2d.dtr);
               _loc21_.x -= _loc19_.x;
               _loc21_.y -= _loc19_.y;
               _loc8_.px -= _loc21_.x;
               _loc8_.py -= _loc21_.y;
            }
            if(param1.rotation != 0)
            {
               _loc8_.setAngle(param1.rotation * Geom2d.dtr);
               _loc8_.update();
            }
            _loc8_.calcProperties();
            if(param1.props.material == CreatorUIStates.MATERIAL_AIR_BALLOON)
            {
               _loc8_.gmass = 0;
            }
            else if(param1.props.material == CreatorUIStates.MATERIAL_HELIUM_BALLOON)
            {
               _loc8_.gmass = 0 - _loc8_.gmass * 0.2;
            }
            else if(param1.props.material == CreatorUIStates.MATERIAL_MAGNET)
            {
               _loc22_ = new Constraint();
               _loc23_ = new Modifier(null,false);
               _loc23_.props.type = CreatorUIStates.MODIFIER_MAGNET;
               _loc23_.props.parent = param1;
               _loc22_.data = _loc23_;
               this._constraints.push(_loc22_);
            }
            if(!param5 && param1.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
            {
               _loc8_.stopAll();
            }
            if(param1.props.sensor_group != 0)
            {
               _loc8_.cbType = this._sense_id;
            }
            if(param1.props.passthru_group == -1)
            {
               _loc6_.addObject(_loc8_);
            }
            else
            {
               this._groups[param1.props.passthru_group].addObject(_loc8_);
               if(param2)
               {
                  this._space.addObject(_loc8_);
               }
            }
            switch(param1.props.constraint)
            {
               case CreatorUIStates.MOVEMENT_PIN:
                  if(param1.pin.x == 0 && param1.pin.y == 0)
                  {
                     _loc8_.stopMovement();
                  }
                  else
                  {
                     _loc15_ = new PivotJoint(_loc6_.STATIC,_loc8_,new Vec2(_loc11_ + param1.pin.x,_loc12_ + param1.pin.y));
                     _loc6_.addConstraint(_loc15_);
                     this._pinnedBodies[_loc8_] = _loc15_;
                  }
                  break;
               case CreatorUIStates.MOVEMENT_SLIDE:
                  _loc8_.stopRotation();
            }
            if(!param5 && param1.props.locked && !param2)
            {
               _loc8_.stopAll();
            }
            _loc8_.data = param1;
            if(this._events.hasActionForEvent(param1,3))
            {
               _loc8_.cbOutOfBounds = true;
            }
         }
         return _loc8_;
      }
      
      public function removeObject(param1:PhysObj, param2:int = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Modifier = null;
         if(Boolean(param1) && param1.graphic is ViewSprite)
         {
            this._view.unregister(ViewSprite(param1.graphic),param2);
         }
         if(param1)
         {
            if(this._spawnedBodyLifespans[param1])
            {
               _loc3_ = int(this._spawnedBodyLastBodies.indexOf(param1));
               if(_loc3_ != -1)
               {
                  _loc4_ = this._spawnedBodyModifiers[param1];
                  this._events.handleEmptyEvent(param1,_loc4_);
                  this._spawnedBodyLastBodies.splice(_loc3_,1);
               }
            }
         }
         this._removedObjs.push(param1);
         delete this._spawnedBodyTimes[param1];
         delete this._spawnedBodyLifespans[param1];
         if(Boolean(param1) && param1.data == this._focusObject)
         {
            this._focusObject = null;
            this._focusBody = null;
            if(param1.graphic)
            {
               param1.graphic.removeEventListener(MouseEvent.CLICK,this.onObjectClick);
            }
            delete this._focusObjectStates[param1.data];
            delete this._focusObjectMap[param1];
         }
         this.removeConstraints(param1);
         this._space.removeConstraints(param1);
         this._space.removeObject(param1);
         param1.graphic = null;
         param1.data = null;
      }
      
      public function unlockObject(param1:PhysObj) : void
      {
         var _loc2_:Body = null;
         var _loc3_:ModelObject = null;
         var _loc4_:Modifier = null;
         var _loc5_:Object = null;
         var _loc6_:PhysObj = null;
         var _loc7_:GearJoint = null;
         if(param1 is Body && Boolean(this._bodiesLockStates[param1]))
         {
            _loc2_ = param1 as Body;
            _loc3_ = _loc2_.data as ModelObject;
            if(_loc3_)
            {
               if(_loc2_.graphic is ViewSprite)
               {
                  ViewSprite(_loc2_.graphic).bling();
               }
               if(_loc3_.props.constraint == CreatorUIStates.MOVEMENT_FREE)
               {
                  _loc2_.allowAll();
               }
               else if(_loc3_.props.constraint == CreatorUIStates.MOVEMENT_SLIDE)
               {
                  _loc2_.allowMovement();
               }
               else if(_loc3_.props.constraint == CreatorUIStates.MOVEMENT_PIN)
               {
                  if(this._pinnedBodies[_loc2_])
                  {
                     _loc2_.allowAll();
                     this._space.wakeConstraint(this._pinnedBodies[_loc2_]);
                  }
                  else
                  {
                     _loc2_.allowRotation();
                  }
               }
               this._bodiesLockStates[_loc2_] = false;
               this._space.wakeObject(_loc2_);
               for(_loc5_ in this._constraintsBodies)
               {
                  if(this._constraintsBodies[_loc5_] == param1)
                  {
                     if(this._constraints.indexOf(_loc5_) != -1)
                     {
                        if(_loc5_.data is Modifier)
                        {
                           _loc4_ = _loc5_.data as Modifier;
                           if(_loc4_.props.type == CreatorUIStates.MODIFIER_CONNECTOR)
                           {
                              if(param1.data == _loc4_.props.parent && Boolean(_loc4_.props.child))
                              {
                                 _loc6_ = this._bodies[_loc4_.props.child];
                                 if(this._gearJoints[_loc6_])
                                 {
                                    _loc7_ = this._gearJoints[_loc6_];
                                    this._space.removeConstraint(_loc7_);
                                    this._bodiesLockStates[_loc6_] = false;
                                    this._space.removeObject(_loc6_);
                                    this._space.addObject(_loc6_);
                                    this._space.wakeObject(_loc6_);
                                    _loc7_ = new GearJoint(param1,_loc6_,_loc6_.a,1);
                                    this._space.addConstraint(_loc7_);
                                    this._gearJoints[_loc6_] = _loc7_;
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function explodeObject(param1:PhysObj) : void
      {
         var _loc5_:RayResult = null;
         var _loc6_:ModelObject = null;
         var _loc7_:Body = null;
         var _loc8_:Number = NaN;
         var _loc10_:CxFastNode_PhysObj = null;
         var _loc11_:PhysObj = null;
         var _loc12_:CxFastNode_PhysObj = null;
         var _loc13_:Boolean = false;
         var _loc14_:PhysObj = null;
         var _loc15_:Shape = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Boolean = false;
         var _loc21_:ModelObject = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc2_:Vec2 = new Vec2(param1.px,param1.py);
         var _loc3_:Vec2 = new Vec2();
         var _loc4_:Ray = new Ray(_loc2_,_loc2_);
         var _loc9_:Boolean = false;
         this._removedObjs.push(param1);
         if(param1 != null)
         {
            _loc10_ = this._space.objects.begin();
            while(_loc10_ != this._space.objects.end())
            {
               _loc11_ = _loc10_.elem();
               _loc10_ = _loc10_.next;
               if(!(_loc11_ == null || _loc11_ == param1 || !_loc11_.added_to_space))
               {
                  if(_loc11_.data != null)
                  {
                     if(!(_loc11_ is Body && Body(_loc11_).shapes.next.group == 0))
                     {
                        _loc12_ = this._space.objects.begin();
                        _loc4_.ax = param1.px;
                        _loc4_.ay = param1.py;
                        _loc4_.vx = _loc11_.px - param1.px;
                        _loc4_.vy = _loc11_.py - param1.py;
                        _loc13_ = false;
                        while(_loc12_ != this._space.objects.end())
                        {
                           _loc14_ = _loc12_.elem();
                           _loc12_ = _loc12_.next;
                           if(!(_loc14_ == _loc11_ || _loc14_ == param1 || _loc11_ == param1))
                           {
                              if(_loc14_ is Body)
                              {
                                 _loc7_ = Body(_loc14_);
                                 if((_loc15_ = _loc7_.shapes.next) is Circle)
                                 {
                                    _loc8_ = RayCast.rayCircle(_loc4_,Circle(_loc15_));
                                 }
                                 else if(_loc15_ is Polygon)
                                 {
                                    _loc8_ = RayCast.rayPolygon(_loc4_,Polygon(_loc15_),_loc3_);
                                 }
                                 if(_loc8_ != RayCast.FAIL && _loc14_.data is ModelObject)
                                 {
                                    _loc6_ = ModelObject(_loc14_.data);
                                    if(this._bodiesLockStates[_loc7_] || _loc6_.props.constraint == CreatorUIStates.MOVEMENT_LOCKED || _loc6_.props.strength == CreatorUIStates.STRENGTH_PERM)
                                    {
                                       _loc13_ = true;
                                    }
                                    break;
                                 }
                              }
                           }
                        }
                        if(!_loc13_)
                        {
                           if(this._removedObjs.indexOf(_loc11_) == -1)
                           {
                              _loc16_ = _loc11_.px - param1.px;
                              _loc17_ = _loc11_.py - param1.py;
                              _loc18_ = Math.abs(_loc16_) + Math.abs(_loc17_);
                              _loc18_ *= _loc18_;
                              _loc18_ = _loc18_ *= _loc18_ * 0.015;
                              _loc19_ = FastMath.invsqrt(_loc16_ * _loc16_ + _loc17_ * _loc17_);
                              _loc16_ *= _loc19_ * 20000000;
                              _loc17_ *= _loc19_ * 20000000;
                              _loc16_ /= _loc18_;
                              _loc17_ /= _loc18_;
                              _loc16_ *= param1.gmass * 0.5;
                              _loc17_ *= param1.gmass * 0.5;
                              _loc16_ = Math.max(-30000000,Math.min(30000000,_loc16_));
                              _loc17_ = Math.max(-30000000,Math.min(30000000,_loc17_));
                              _loc20_ = false;
                              _loc21_ = _loc11_.data as ModelObject;
                              if((Boolean(_loc21_)) && _loc21_.props.strength != CreatorUIStates.STRENGTH_PERM)
                              {
                                 _loc22_ = Math.sqrt(_loc16_ * _loc16_ + _loc17_ * _loc17_) / 100000;
                                 switch(_loc21_.props.strength)
                                 {
                                    case CreatorUIStates.STRENGTH_STRONG:
                                       _loc23_ = 400;
                                       break;
                                    case CreatorUIStates.STRENGTH_MEDIUM:
                                       _loc23_ = 300;
                                       break;
                                    case CreatorUIStates.STRENGTH_WEAK:
                                       _loc23_ = 200;
                                 }
                                 if(_loc22_ > _loc23_)
                                 {
                                    this.playSound(_loc11_,Sounds.CRASH,_loc22_ / 600);
                                    this._removedObjs.push(_loc11_);
                                    this._events.handleCrushEvent(_loc11_);
                                    this.removeObject(_loc11_,View.EFFECT_SHATTER);
                                    _loc20_ = true;
                                 }
                              }
                              if(!_loc20_)
                              {
                                 if(param1.gmass > 5000)
                                 {
                                    _loc9_ = true;
                                 }
                                 this.space.wakeObject(_loc11_);
                                 _loc11_.applyRelativeForce(_loc16_,_loc17_,0,0);
                              }
                           }
                        }
                     }
                  }
               }
            }
            this.playSound(param1,_loc9_ ? Sounds.EXPLODE_HUGE : Sounds.EXPLODE);
            this.removeObject(param1,View.EFFECT_EXPLODE);
         }
      }
      
      protected function removeGroup(param1:ModelObjectContainer) : void
      {
         var _loc3_:ModelObject = null;
         var _loc2_:int = int(param1.length);
         while(_loc2_--)
         {
            _loc3_ = param1.objects[_loc2_];
            if(Boolean(this._bodies[_loc3_]) && this._bodies[_loc3_] is PhysObj)
            {
               this.removeObject(this._bodies[_loc3_] as PhysObj);
            }
         }
      }
      
      protected function removeConstraints(param1:PhysObj, param2:Boolean = false) : void
      {
         var _loc4_:Modifier = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:PhysObj = null;
         var _loc3_:Array = [];
         for(_loc5_ in this._constraintsBodies)
         {
            if(this._constraintsBodies[_loc5_] == param1)
            {
               if(param2 && _loc5_ && _loc5_.data is Modifier)
               {
                  _loc4_ = _loc5_.data as Modifier;
                  if(_loc4_.props.type != CreatorUIStates.MODIFIER_PROPELLER && _loc4_.props.type != CreatorUIStates.MODIFIER_MAGNET && _loc4_.props.type != CreatorUIStates.MODIFIER_UNLOCKER)
                  {
                     continue;
                  }
               }
               if(this._constraints.indexOf(_loc5_) != -1)
               {
                  this._constraints.splice(this._constraints.indexOf(_loc5_),1);
                  _loc3_.push(_loc5_);
                  if(_loc5_.data is Modifier)
                  {
                     _loc4_ = _loc5_.data as Modifier;
                     if(_loc4_.props.type == CreatorUIStates.MODIFIER_CONNECTOR)
                     {
                        if(param1.data == _loc4_.props.parent && Boolean(_loc4_.props.child))
                        {
                           _loc7_ = this._bodies[_loc4_.props.child];
                           if(_loc7_)
                           {
                              this.removeObject(_loc7_);
                           }
                        }
                     }
                  }
               }
            }
         }
         _loc6_ = int(_loc3_.length);
         while(_loc6_--)
         {
            this._constraintsBodies[_loc3_[_loc6_]] = null;
            delete this._constraintsBodies[_loc3_[_loc6_]];
         }
      }
      
      public function stepDouble(param1:Event = null) : void
      {
         if(this._focusObject && this._view.camera && this._view.camera.watchObject != this._bodies[this._focusObject])
         {
            this._view.camera.startWatching(this._bodies[this._focusObject],10);
         }
         this.checkDraggedObject();
         this.checkControls();
         this.checkActuators();
         this.checkCollisionForces();
         this.step(param1);
         this.checkCallbacks();
         this.checkActuators();
         this.checkCollisionForces();
         this.step(param1);
         this.checkCallbacks();
         this.checkSpawnedBodies();
         this.drawConstraints();
         this._view.update();
         if(this._removedObjs.length > 100)
         {
            this._removedObjs = new Vector.<PhysObj>();
         }
         this._events.checkEndGameStatus();
         ++this._frame;
      }
      
      protected function step(param1:Event) : void
      {
         var e:Event = param1;
         if(this._space)
         {
            try
            {
               this._space.step(1 / 45,6,6);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function stop() : void
      {
         if(this._running)
         {
            if(Boolean(this._container) && Boolean(this._container.stage))
            {
               this._container.stage.removeEventListener(Event.ENTER_FRAME,this.stepDouble);
               this._container.stage.quality = StageQuality.HIGH;
            }
            if(this._environment.vMusic != "")
            {
               _sounds.pauseSong();
            }
            this._running = false;
         }
      }
      
      public function end() : void
      {
         var _loc1_:int = 0;
         if(this._running)
         {
            this.stop();
         }
         if(this._environment.vMusic != "")
         {
            _sounds.unloadSong();
         }
         if(this._built)
         {
            if(Boolean(this._container) && Boolean(this._container.stage))
            {
               this._container.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               this._container.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            }
            if(this._viewUI)
            {
               this._viewUI.end();
               this._viewUI = null;
            }
            if(this._view)
            {
               this._view.end();
               this._view = null;
            }
            if(this._events)
            {
               this._events.end();
               this._events = null;
            }
            if(this._model && this._bodies && Boolean(this._space))
            {
               _loc1_ = int(this._model.objects.length);
               while(_loc1_--)
               {
                  if(this._bodies[this._model.objects[_loc1_]] is PhysObj)
                  {
                     this._space.removeConstraints(this._bodies[this._model.objects[_loc1_]]);
                     this._space.removeObject(this._bodies[this._model.objects[_loc1_]]);
                  }
               }
            }
            this._bodies = this._bodiesLockStates = this._constraintsAddedStates = this._constraintsBodies = this._elevators = this._motors = this._switchTimes = this._elevatorStates = this._lastSpawns = this._spawners = this._spawnedBodyModifiers = this._spawnedBodyTimes = this._spawnedBodyExplodes = this._spawnedBodyLifespans = this._spawnLimits = this._spawnTotals = this._spawnIntervals = this._jumpedStates = this._jumpedTimes = this._emagnetStates = this._emagnetPressed = this._pinnedBodies = this._gearJoints = this._focusObjectStates = this._focusObjectMap = null;
            this._groups = null;
            this._spawnedBodyLastBodies = null;
            this._constraints = null;
            this._pivotJoints = null;
            this._pivotJointGroups = null;
            this._pivotJointGroupMap = null;
            this._firstControlledObject = null;
            this._focusObject = null;
            this._focusBody = null;
            this._removedObjs = null;
            if(this._space)
            {
             //  this._space.clear();
               this._space = null;
            }
            if(_sounds)
            {
               _sounds.simulation = null;
            }
            if(_sounds && this._container && Boolean(this._container.stage))
            {
               _sounds.unregisterStage(this._container.stage);
            }
            SoundManager.stopAll();
            this._model = null;
            this._environment = null;
            this._container = null;
            this._built = false;
         }
      }
   }
}

