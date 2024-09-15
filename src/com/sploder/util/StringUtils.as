package com.sploder.util
{
   public class StringUtils
   {
      public static var monthNames:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
      
      public static var monthShortNames:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
      
      public static var dayNames:Array = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
      
      public static const RESTRICT_ALNUM:String = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz";
      
      public static const RESTRICT_BASIC:String = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz.,!?#$-";
      
      public function StringUtils()
      {
         super();
      }
      
      public static function prettydatestring(param1:Date) : String
      {
         return dayNames[param1.getDay()] + ", " + monthNames[param1.getMonth()] + " " + param1.getDate() + ", " + param1.getFullYear();
      }
      
      public static function cgidatestring(param1:Date) : String
      {
         var _loc2_:String = "" + param1.getDate();
         if(param1.getDate() < 10)
         {
            _loc2_ = "0" + _loc2_;
         }
         var _loc3_:String = "" + param1.getMonth() + 1;
         if(param1.getMonth() + 1 < 10)
         {
            _loc3_ = "0" + _loc3_;
         }
         var _loc4_:String = "" + param1.getFullYear();
         return _loc3_ + "." + _loc2_ + "." + _loc4_;
      }
      
      public static function timeInMinutes(param1:int) : String
      {
         var _loc2_:int = Math.floor(param1 / 60);
         var _loc3_:int = param1 % 60;
         return _loc2_ + ":" + (_loc3_ < 10 ? "0" : "") + _loc3_;
      }
      
      public static function titleCase(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc5_:* = false;
         var _loc2_:Array = param1.split(" ");
         var _loc3_:int = int(_loc2_.length);
         while(_loc3_--)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = _loc3_ == 0;
            if(!_loc5_)
            {
               switch(_loc4_)
               {
                  case "a":
                  case "and":
                  case "the":
                  case "at":
                  case "to":
                  case "for":
                  case "or":
                  case "that":
                  case "in":
                  case "on":
                  case "which":
                  case "what":
                  case "that":
                  case "they":
                  case "their":
                  case "into":
                  case "onto":
                     break;
                  default:
                     _loc5_ = true;
               }
            }
            if(_loc5_)
            {
               _loc2_[_loc3_] = _loc4_.charAt(0).toUpperCase() + _loc4_.substr(1,_loc4_.length - 1);
            }
         }
         return _loc2_.join(" ");
      }
   }
}

