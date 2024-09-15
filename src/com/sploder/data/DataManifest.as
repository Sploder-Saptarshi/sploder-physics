package com.sploder.data
{
   import flash.geom.Point;
   import flash.utils.describeType;
   
   public class DataManifest
   {
      public static const modelObjectPropertiesProps:Array = ["shape","width","height","vertices","constraint","material","strength","locked","collision_group","passthru_group","sensor_group","color","line","texture","zlayer","opaque","scribble","actions","graphic","graphic_version","graphic_flip","animation","custom_texture"];
      
      public static const stringMap:Array = ["icon_shape_none","icon_shape_poly","icon_shape_hex","icon_shape_pent","icon_shape_box","icon_shape_ramp","icon_shape_circle","icon_shape_square","icon_movement_static","icon_movement_slide","icon_movement_pin","icon_movement_free","icon_material_tire","icon_material_glass","icon_material_rubber","icon_material_ice","icon_material_steel","icon_material_wood","icon_material_air_balloon","icon_material_helium_balloon","icon_material_magnet","icon_strength_perm","icon_strength_strong","icon_strength_medium","icon_strength_weak","modifier_pusher","modifier_pinjoint","modifier_bolt","modifier_dampedspring","modifier_loosespring","modifier_groovejoint","modifier_motor","modifier_rotator","modifier_mover","modifier_slider","modifier_launcher","modifier_selector","modifier_adder","modifier_elevator","modifier_spawner","modifier_connector","modifier_magnet","modifier_factory","modifier_unlocker","modifier_switcher","modifier_jumper","modifier_emagnet","modifier_gearjoint","modifier_aimer","modifier_pointer","modifier_dragger","icon_material_superball","modifier_thruster","modifier_propeller","modifier_clicker","modifier_arcademover"];
      
      public function DataManifest()
      {
         super();
      }
      
      public static function describe(param1:Object) : String
      {
         var _loc4_:String = null;
         var _loc5_:XML = null;
         var _loc2_:XMLList = describeType(param1)..accessor;
         var _loc3_:Array = [];
         for each(_loc5_ in _loc2_)
         {
            _loc4_ = _loc5_.@name;
            if(_loc5_.@access == "readwrite")
            {
               _loc3_.push(_loc4_);
            }
         }
         _loc3_.sort();
         return "\"" + _loc3_.join("\",\"") + "\"";
      }
      
      public static function pointToString(param1:Point) : String
      {
         return param1.x + ":" + param1.y;
      }
      
      public static function stringToPoint(param1:String, param2:Point = null) : Point
      {
         var _loc3_:Array = null;
         if(param1 == null || param1.indexOf(":") == -1)
         {
            return new Point();
         }
         _loc3_ = param1.split(":");
         if(param2)
         {
            param2.x = parseInt(_loc3_[0]);
            param2.y = parseInt(_loc3_[1]);
            return param2;
         }
         return new Point(parseInt(_loc3_[0]),parseInt(_loc3_[1]));
      }
   }
}

