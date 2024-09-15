package haxe
{
   import flash.utils.getQualifiedClassName;
   
   public class StringTools
   {
      public function StringTools()
      {
         super();
      }
      
      public static function urlEncode(param1:String) : String
      {
         return encodeURIComponent(param1);
      }
      
      public static function urlDecode(param1:String) : String
      {
         return decodeURIComponent(param1.split("+").join(" "));
      }
      
      public static function htmlEscape(param1:String) : String
      {
         return param1.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
      }
      
      public static function htmlUnescape(param1:String) : String
      {
         return param1.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
      }
      
      public static function startsWith(param1:String, param2:String) : Boolean
      {
         return param1.length >= param2.length && param1.substr(0,param2.length) == param2;
      }
      
      public static function endsWith(param1:String, param2:String) : Boolean
      {
         var _loc3_:int = param2.length;
         var _loc4_:int = param1.length;
         return _loc4_ >= _loc3_ && param1.substr(_loc4_ - _loc3_,_loc3_) == param2;
      }
      
      public static function isSpace(param1:String, param2:int) : Boolean
      {
         var _loc3_:* = param1["charCodeAtHX"](param2);
         return _loc3_ >= 9 && _loc3_ <= 13 || _loc3_ == 32;
      }
      
      public static function ltrim(param1:String) : String
      {
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_ && StringTools.isSpace(param1,_loc3_))
         {
            _loc3_++;
         }
         if(_loc3_ > 0)
         {
            return param1.substr(_loc3_,_loc2_ - _loc3_);
         }
         return param1;
      }
      
      public static function rtrim(param1:String) : String
      {
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_ && StringTools.isSpace(param1,_loc2_ - _loc3_ - 1))
         {
            _loc3_++;
         }
         if(_loc3_ > 0)
         {
            return param1.substr(0,_loc2_ - _loc3_);
         }
         return param1;
      }
      
      public static function trim(param1:String) : String
      {
         return StringTools.ltrim(StringTools.rtrim(param1));
      }
      
      public static function rpad(param1:String, param2:String, param3:int) : String
      {
         var _loc4_:int = param1.length;
         var _loc5_:int = param2.length;
         while(_loc4_ < param3)
         {
            if(param3 - _loc4_ < _loc5_)
            {
               param1 += param2.substr(0,param3 - _loc4_);
               _loc4_ = param3;
            }
            else
            {
               param1 += param2;
               _loc4_ += _loc5_;
            }
         }
         return param1;
      }
      
      public static function lpad(param1:String, param2:String, param3:int) : String
      {
         var _loc4_:String = "";
         var _loc5_:int = param1.length;
         if(_loc5_ >= param3)
         {
            return param1;
         }
         var _loc6_:int = param2.length;
         while(_loc5_ < param3)
         {
            if(param3 - _loc5_ < _loc6_)
            {
               _loc4_ += param2.substr(0,param3 - _loc5_);
               _loc5_ = param3;
            }
            else
            {
               _loc4_ += param2;
               _loc5_ += _loc6_;
            }
         }
         return _loc4_ + param1;
      }
      
      public static function replace(param1:String, param2:String, param3:String) : String
      {
         return param1.split(param2).join(param3);
      }
      
      public static function hex(param1:int, param2:* = null) : String
      {
         var _loc3_:uint = uint(param1);
         var _loc4_:String = _loc3_.toString(16);
         _loc4_ = _loc4_.toUpperCase();
         if(param2 != null)
         {
            while(_loc4_.length < param2)
            {
               _loc4_ = "0" + _loc4_;
            }
         }
         return _loc4_;
      }
      
      public static function fastCodeAt(param1:String, param2:int) : int
      {
         return param1.charCodeAt(param2);
      }
      
      public static function isEOF(param1:int) : Boolean
      {
         return param1 == 0;
      }
      
      public static function enum_to_string(param1:*) : String
      {
         var _loc5_:* = undefined;
         if(param1.params == null)
         {
            return param1.tag;
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:Array = param1.params;
         while(_loc3_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc3_];
            _loc3_++;
            _loc2_.push(__string_rec(_loc5_,""));
         }
         return param1.tag + "(" + _loc2_.join(",") + ")";
      }
      
      public static function __string_rec(param1:*, param2:String) : String
      {
         var k:Array = null;
         var s:String = null;
         var first:Boolean = false;
         var _g1:int = 0;
         var _g:int = 0;
         var i:int = 0;
         var key:String = null;
         var s1:String = null;
         var i1:* = undefined;
         var first1:Boolean = false;
         var a:Array = null;
         var _g11:int = 0;
         var _g2:int = 0;
         var i2:int = 0;
         var v:* = param1;
         var str:String = param2;
         var cname:String = getQualifiedClassName(v);
         switch(cname)
         {
            case "Object":
               k = (function():Array
               {
                  var _loc1_:* = undefined;
                  var _loc2_:* = undefined;
                  _loc1_ = new Array();
                  for(_loc2_ in v)
                  {
                     _loc1_.push(_loc2_);
                  }
                  return _loc1_;
               })();
               s = "{";
               first = true;
               _g1 = 0;
               _g = int(k.length);
               while(_g1 < _g)
               {
                  i = _g1++;
                  key = k[i];
                  if(key == "toString")
                  {
                     try
                     {
                        return v.toString();
                     }
                     catch(e:*)
                     {
                     }
                  }
                  if(first)
                  {
                     first = false;
                  }
                  else
                  {
                     s += ",";
                  }
                  s += " " + key + " : " + __string_rec(v[key],str);
               }
               if(!first)
               {
                  s += " ";
               }
               s += "}";
               return s;
            case "Array":
               if(v == Array)
               {
                  return "#Array";
               }
               s1 = "[";
               first1 = true;
               a = v;
               _g11 = 0;
               _g2 = int(a.length);
               while(_g11 < _g2)
               {
                  i2 = _g11++;
                  if(first1)
                  {
                     first1 = false;
                  }
                  else
                  {
                     s1 += ",";
                  }
                  s1 += __string_rec(a[i2],str);
               }
               return s1 + "]";
               break;
            default:
               switch(typeof v)
               {
                  case "function":
                     return "<function>";
                  default:
                     return new String(v);
               }
         }
      }
   }
}

