package haxe
{
   public class Std1
   {
      public function Std1()
      {
         super();
      }
      
      public static function _is(param1:*, param2:*) : Boolean
      {
         try
         {
            if(param2 == Object)
            {
               return true;
            }
            return param1 is param2;
         }
         catch(e:*)
         {
         }
         return false;
      }
      
      public static function string(param1:*) : String
      {
         return StringTools.__string_rec(param1,"");
      }
      
      public static function _int(param1:Number) : int
      {
         return int(param1);
      }
      
      public static function _parseInt(param1:String) : *
      {
         var _loc2_:* = parseInt(param1);
         if(isNaN(_loc2_))
         {
            return null;
         }
         return _loc2_;
      }
      
      public static function _parseFloat(param1:String) : Number
      {
         return parseFloat(param1);
      }
      
      public static function random(param1:int) : int
      {
         return Math.floor(Math.random() * param1);
      }
   }
}

