package com.sploder.game
{
   import com.sploder.builder.CreatorUIStates;
   import nape.phys.Material;
   
   public class Constants
   {
      public static var MATERIAL_SUPERBALL:Material;
      
      public function Constants()
      {
         super();
      }
      
      public static function getMaterial(param1:String) : Material
      {
         switch(param1)
         {
            case CreatorUIStates.MATERIAL_GLASS:
               return Material.Glass;
            case CreatorUIStates.MATERIAL_ICE:
               return Material.Ice;
            case CreatorUIStates.MATERIAL_RUBBER:
               return Material.Rubber;
            case CreatorUIStates.MATERIAL_STEEL:
               return Material.Steel;
            case CreatorUIStates.MATERIAL_TIRE:
               return Material.Tire;
            case CreatorUIStates.MATERIAL_WOOD:
               return Material.Wood;
            case CreatorUIStates.MATERIAL_AIR_BALLOON:
               return Material.Ice;
            case CreatorUIStates.MATERIAL_HELIUM_BALLOON:
               return Material.Ice;
            case CreatorUIStates.MATERIAL_MAGNET:
               return Material.Wood;
            case CreatorUIStates.MATERIAL_SUPERBALL:
               if(MATERIAL_SUPERBALL == null)
               {
                  MATERIAL_SUPERBALL = new Material(2,Material.Rubber.dyn_fric,Material.Rubber.stat_fric,Material.Rubber.density);
               }
               return MATERIAL_SUPERBALL;
            default:
               return Material.Wood;
         }
      }
   }
}

