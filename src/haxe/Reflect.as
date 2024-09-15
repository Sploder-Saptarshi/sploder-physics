package haxe
{
   public class Reflect
   {
      public function Reflect()
      {
         super();
      }
      
      public static function hasField(param1:*, param2:String) : Boolean
      {
         return param1.hasOwnProperty(param2);
      }
      
      public static function field(param1:*, param2:String) : *
      {
         var o:* = param1;
         var field:String = param2;
         return (function():*
         {
            var $r:* = undefined;
            try
            {
               $r = o[field];
            }
            catch(e:*)
            {
               $r = null;
            }
            return $r;
         })();
      }
      
      public static function setField(param1:*, param2:String, param3:*) : void
      {
         param1[param2] = param3;
      }
      
      public static function getProperty(param1:*, param2:String) : *
      {
         var o:* = param1;
         var field:String = param2;
         try
         {
            return o["get_" + field]();
         }
         catch(e:*)
         {
            return o[field];
         }
         catch(e1:*)
         {
            return null;
         }
      }
      
      public static function setProperty(param1:*, param2:String, param3:*) : void
      {
         var o:* = param1;
         var field:String = param2;
         var value:* = param3;
         try
         {
            o["set_" + field](value);
         }
         catch(e:*)
         {
            o[field] = value;
         }
      }
      
      public static function callMethod(param1:*, param2:*, param3:Array) : *
      {
         return param2.apply(param1,param3);
      }
      
      public static function fields(param1:*) : Array
      {
         var a:Array;
         var i:int;
         var o:* = param1;
         if(o == null)
         {
            return new Array();
         }
         a = (function():Array
         {
            var _loc1_:* = undefined;
            var _loc2_:* = undefined;
            _loc1_ = new Array();
            for(_loc2_ in o)
            {
               _loc1_.push(_loc2_);
            }
            return _loc1_;
         })();
         i = 0;
         while(i < a.length)
         {
            if(!o.hasOwnProperty(a[i]))
            {
               a.splice(i,1);
            }
            else
            {
               i++;
            }
         }
         return a;
      }
      
      public static function isFunction(param1:*) : Boolean
      {
         return typeof param1 == "function";
      }
      
      public static function compare(param1:*, param2:*) : int
      {
         var _loc3_:* = param1;
         var _loc4_:* = param2;
         return _loc3_ == _loc4_ ? 0 : (_loc3_ > _loc4_ ? 1 : -1);
      }
      
      public static function compareMethods(param1:*, param2:*) : Boolean
      {
         return param1 == param2;
      }
      
      public static function isObject(param1:*) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:* = typeof param1;
         if(_loc2_ == "object")
         {
            try
            {
               if(param1.__enum__ == true)
               {
                  return false;
               }
            }
            catch(e:*)
            {
            }
            return true;
         }
         return _loc2_ == "string";
      }
      
      public static function deleteField(param1:*, param2:String) : Boolean
      {
         if(param1.hasOwnProperty(param2) != true)
         {
            return false;
         }
         delete param1[param2];
         return true;
      }
      
      public static function copy(param1:*) : *
      {
         var _loc5_:String = null;
         var _loc2_:* = {};
         var _loc3_:int = 0;
         var _loc4_:Array = Reflect.fields(param1);
         while(_loc3_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc3_];
            _loc3_++;
            Reflect.setField(_loc2_,_loc5_,Reflect.field(param1,_loc5_));
         }
         return _loc2_;
      }
      
      public static function makeVarArgs(param1:Function) : *
      {
         var f:Function = param1;
         return function(param1:Array):*
         {
            return f(param1);
         };
      }
   }
}

