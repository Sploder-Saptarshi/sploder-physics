package com.sploder.util
{
   public class Cleanser
   {
      public function Cleanser()
      {
         super();
      }
      
      public static function cleanse(param1:String) : String
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc2_:Array = [" ass ","lesbian","shit","nigger","f.u.c.k","s.h.i.t","s*h*i*t","b.i.t.c.h","b-i-t-c-h","s-h-i-t","f-u-c-k","f*u*c*k","f u c k","c.o.c.k","c o c k","s h i t","c u n t","b i t c h","w h o r e","p u s s y","f-u-c-k","penis","pussy ","bullshit","whore"," piss "," pissing"," pee "," peeing ","tranny","blow job","transexual","bitch"," shit ","bestiality","fucking","fucker","jackoff","dickhead","dickless","masturbation","masturbate","fuck","cocksucker","cocksucking"," cock ","hentai","bastard","shithead","shitface","shitty","shiteating","blowjob","horny","cunt","clitoris","clit","asshole","incest","foreskin","faggot","cock"];
         if(param1 == null)
         {
            return "";
         }
         param1 = param1.split("-").join("").split("_").join("").split("*").join("").split("^").join("").split("~").join("");
         var _loc3_:String = param1.toLowerCase();
         var _loc12_:Number = 0;
         while(_loc12_ < _loc2_.length)
         {
            _loc4_ = 0;
            while(_loc3_.indexOf(_loc2_[_loc12_]) !== -1)
            {
               _loc5_ = _loc2_[_loc12_];
               _loc6_ = Number(_loc3_.indexOf(_loc5_));
               _loc7_ = _loc6_ + _loc5_.length;
               _loc10_ = param1.substr(0,_loc6_);
               _loc11_ = param1.substr(_loc7_,param1.length - 1);
               _loc8_ = "";
               _loc9_ = "";
               if(_loc5_.charAt(0) == " ")
               {
                  _loc8_ = " ";
               }
               if(_loc5_.charAt(_loc5_.length - 1) == " ")
               {
                  _loc9_ = " ";
               }
               param1 = _loc10_ + _loc8_ + "BLEEP" + _loc9_ + _loc11_;
               _loc3_ = param1.toLowerCase();
               if(++_loc4_ > 1000)
               {
                  break;
               }
            }
            _loc12_++;
         }
         return param1;
      }
   }
}

