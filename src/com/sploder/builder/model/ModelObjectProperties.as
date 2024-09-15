package com.sploder.builder.model
{
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.data.DataManifest;
   import com.sploder.texturegen_internal.TextureAttributes;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.describeType;
   
   public class ModelObjectProperties extends EventDispatcher
   {
      public static const LAYER_COLLISION:int = 0;
      
      public static const LAYER_SENSOR:int = 1;
      
      public static const LAYER_PASSTHRU:int = 2;
      
      protected var _width:int = 0;
      
      protected var _height:int = 0;
      
      protected var _shape:String = "icon_shape_none";
      
      protected var _constraint:String = "icon_movement_free";
      
      protected var _material:String = "icon_material_wood";
      
      protected var _strength:String = "icon_strength_perm";
      
      protected var _locked:Boolean = false;
      
      protected var _vertices:Vector.<Point>;
      
      protected var _collision_group:int = 31;
      
      protected var _passthru_group:int = -1;
      
      protected var _sensor_group:int = 0;
      
      protected var _color:int = 0;
      
      protected var _line:int = -1;
      
      protected var _zlayer:int = 3;
      
      protected var _clip:uint = 0;
      
      protected var _opaque:uint = 1;
      
      protected var _scribble:uint = 0;
      
      protected var _texture:uint = 0;
      
      protected var _actions:uint = 0;
      
      protected var _graphic:uint = 0;
      
      protected var _graphic_version:uint = 0;
      
      protected var _graphic_flip:uint = 0;
      
      protected var _animation:uint = 0;
      
      protected var _custom_texture:String = "";
      
      protected var _attribs:TextureAttributes;
      
      public function ModelObjectProperties()
      {
         super();
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function set width(param1:int) : void
      {
         this._width = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function set height(param1:int) : void
      {
         this._height = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get shape() : String
      {
         return this._shape;
      }
      
      public function set shape(param1:String) : void
      {
         this._shape = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get constraint() : String
      {
         return this._constraint;
      }
      
      public function set constraint(param1:String) : void
      {
         this._constraint = param1;
         if(this._constraint == CreatorUIStates.MOVEMENT_STATIC)
         {
            this._locked = false;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get material() : String
      {
         return this._material;
      }
      
      public function set material(param1:String) : void
      {
         this._material = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get strength() : String
      {
         return this._strength;
      }
      
      public function set strength(param1:String) : void
      {
         this._strength = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get size() : int
      {
         return Math.max(this._width,this._height) / 2;
      }
      
      public function set size(param1:int) : void
      {
         this._width = this._height = param1 * 2;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(param1:Boolean) : void
      {
         this._locked = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get vertices() : Vector.<Point>
      {
         return this._vertices;
      }
      
      public function set vertices(param1:Vector.<Point>) : void
      {
         this._vertices = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get collision_group() : int
      {
         return this._collision_group;
      }
      
      public function set collision_group(param1:int) : void
      {
         this._collision_group = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get passthru_group() : int
      {
         return this._passthru_group;
      }
      
      public function set passthru_group(param1:int) : void
      {
         this._passthru_group = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get sensor_group() : int
      {
         return this._sensor_group;
      }
      
      public function set sensor_group(param1:int) : void
      {
         this._sensor_group = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get color() : int
      {
         return this._color;
      }
      
      public function set color(param1:int) : void
      {
         this._color = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get line() : int
      {
         return this._line;
      }
      
      public function set line(param1:int) : void
      {
         this._line = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get zlayer() : int
      {
         return this._zlayer;
      }
      
      public function set zlayer(param1:int) : void
      {
         this._zlayer = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get clip() : uint
      {
         return this._clip;
      }
      
      public function set clip(param1:uint) : void
      {
         this._clip = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get opaque() : uint
      {
         return this._opaque;
      }
      
      public function set opaque(param1:uint) : void
      {
         this._opaque = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get scribble() : uint
      {
         return this._scribble;
      }
      
      public function set scribble(param1:uint) : void
      {
         this._scribble = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get texture() : uint
      {
         return this._texture;
      }
      
      public function set texture(param1:uint) : void
      {
         this._texture = param1;
         if(this._texture > 0)
         {
            this._attribs = null;
            this._custom_texture = "";
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get actions() : uint
      {
         return this._actions;
      }
      
      public function set actions(param1:uint) : void
      {
         this._actions = param1;
      }
      
      public function get graphic() : uint
      {
         return this._graphic;
      }
      
      public function set graphic(param1:uint) : void
      {
         this._graphic = param1;
         if(this._graphic > 0)
         {
            this._attribs = null;
            this._custom_texture = "";
         }
      }
      
      public function get graphic_version() : uint
      {
         return this._graphic_version;
      }
      
      public function set graphic_version(param1:uint) : void
      {
         this._graphic_version = param1;
      }
      
      public function get graphic_flip() : uint
      {
         return this._graphic_flip;
      }
      
      public function set graphic_flip(param1:uint) : void
      {
         this._graphic_flip = param1;
      }
      
      public function get animation() : uint
      {
         return this._animation;
      }
      
      public function set animation(param1:uint) : void
      {
         this._animation = param1;
      }
      
      public function get textureName() : String
      {
         if(this._graphic > 0 && this._graphic_version > 0)
         {
            return this._graphic + "_" + this._graphic_version;
         }
         if(this._texture > 0)
         {
            return CreatorUIStates.textures[this._texture];
         }
         return "";
      }
      
      public function get custom_texture() : String
      {
         return this._custom_texture;
      }
      
      public function set custom_texture(param1:String) : void
      {
         this._custom_texture = param1;
         if(this._custom_texture != null && this._custom_texture.length > 0)
         {
            if(this._attribs == null)
            {
               this._attribs = new TextureAttributes().initWithData(this._custom_texture);
            }
            else
            {
               this._attribs.unserialize(this._custom_texture);
            }
            this._graphic = this._graphic_version = this._graphic_flip = this._animation = this._texture = 0;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get attribs() : TextureAttributes
      {
         return this._attribs;
      }
      
      public function set attribs(param1:TextureAttributes) : void
      {
         this._attribs = param1;
      }
      
      public function verticesClone() : Vector.<Point>
      {
         var _loc1_:Vector.<Point> = null;
         var _loc2_:int = 0;
         if(this._vertices)
         {
            _loc1_ = new Vector.<Point>();
            _loc2_ = int(this._vertices.length);
            while(_loc2_--)
            {
               _loc1_.unshift(this._vertices[_loc2_].clone());
            }
            return _loc1_;
         }
         return null;
      }
      
      public function clone() : ModelObjectProperties
      {
         var _loc2_:String = null;
         var _loc4_:XML = null;
         var _loc1_:ModelObjectProperties = new ModelObjectProperties();
         var _loc3_:XMLList = describeType(_loc1_)..accessor;
         for each(_loc4_ in _loc3_)
         {
            _loc2_ = _loc4_.@name;
            if(_loc4_.@access == "readwrite" && _loc2_ != "size")
            {
               _loc1_[_loc2_] = this[_loc2_];
            }
         }
         _loc1_.vertices = this.verticesClone();
         return _loc1_;
      }
      
      override public function toString() : String
      {
         var _loc3_:Array = null;
         var _loc5_:int = 0;
         var _loc1_:Array = DataManifest.modelObjectPropertiesProps;
         var _loc2_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            if(_loc1_[_loc4_] == "vertices")
            {
               if(this._vertices)
               {
                  _loc3_ = [];
                  _loc5_ = 0;
                  while(_loc5_ < this._vertices.length)
                  {
                     _loc3_.push(DataManifest.pointToString(this._vertices[_loc5_]));
                     _loc5_++;
                  }
                  _loc2_.push(_loc3_.join(","));
               }
               else
               {
                  _loc2_.push("");
               }
            }
            else if(_loc1_[_loc4_] == "custom_texture")
            {
               _loc2_.push(this._custom_texture != null ? this._custom_texture : "");
            }
            else if(this[_loc1_[_loc4_]] is String && DataManifest.stringMap.indexOf(this[_loc1_[_loc4_]]) != -1)
            {
               _loc2_.push(DataManifest.stringMap.indexOf(this[_loc1_[_loc4_]]));
            }
            else if(this[_loc1_[_loc4_]] is Boolean)
            {
               _loc2_.push(!!this[_loc1_[_loc4_]] ? 1 : 0);
            }
            else
            {
               _loc2_.push(this[_loc1_[_loc4_]]);
            }
            _loc4_++;
         }
         return _loc2_.join(";");
      }
      
      public function fromString(param1:String) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc7_:int = 0;
         if(param1 == null || param1 == "")
         {
            return;
         }
         var _loc2_:Array = DataManifest.modelObjectPropertiesProps;
         var _loc3_:Array = param1.split(";");
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            if(_loc2_[_loc6_] == "vertices")
            {
               if(String(_loc3_[_loc6_]).length)
               {
                  _loc4_ = String(_loc3_[_loc6_]).split(",");
                  if(this._vertices == null)
                  {
                     this._vertices = new Vector.<Point>();
                  }
                  _loc7_ = int(_loc4_.length);
                  while(_loc7_--)
                  {
                     this._vertices.unshift(DataManifest.stringToPoint(_loc4_[_loc7_]));
                  }
               }
            }
            else if(_loc2_[_loc6_] == "custom_texture")
            {
               this._custom_texture = "";
               if(_loc3_[_loc6_] != null && _loc3_[_loc6_] is String && String(_loc3_[_loc6_]).length > 0)
               {
                  this._custom_texture = String(_loc3_[_loc6_]);
                  this._attribs = new TextureAttributes().initWithData(this._custom_texture);
               }
            }
            else if(this[_loc2_[_loc6_]] is String && DataManifest.stringMap.length > parseInt(_loc3_[_loc6_]))
            {
               this[_loc2_[_loc6_]] = DataManifest.stringMap[parseInt(_loc3_[_loc6_])];
            }
            else if(this[_loc2_[_loc6_]] is Boolean)
            {
               this[_loc2_[_loc6_]] = parseInt(_loc3_[_loc6_]) == 1;
            }
            else
            {
               this[_loc2_[_loc6_]] = _loc3_[_loc6_];
            }
            _loc6_++;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}

