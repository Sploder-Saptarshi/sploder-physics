package com.sploder.util
{
   public class SignString
   {
      private static var cap:Boolean = false;
      
      private static var radix:Number = 8;
      
      public static var sA:String = "098e7fe5f0e70987fadfe00e70897dcd";
      
      public static var sB:String = "d97f6cd9876fcd4d564f7d654fadf967";
      
      public function SignString()
      {
         super();
      }
      
      public static function sign(param1:String) : String
      {
         return f15(param1);
      }
      
      private static function f1(param1:String) : String
      {
         return f4(f3(f2(param1),param1.length * radix));
      }
      
      private static function f2(param1:String) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:Number = (1 << radix) - 1;
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length * radix)
         {
            _loc2_[_loc4_ >> 5] |= (param1.charCodeAt(_loc4_ / radix) & _loc3_) << _loc4_ % 32;
            _loc4_ += radix;
         }
         return _loc2_;
      }
      
      private static function f3(param1:Array, param2:Number) : Array
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         param1[param2 >> 5] |= 128 << param2 % 32;
         param1[(param2 + 64 >>> 9 << 4) + 14] = param2;
         var _loc3_:Number = 1732584193;
         var _loc4_:Number = -271733879;
         var _loc5_:Number = -1732584194;
         var _loc6_:Number = 271733878;
         var _loc7_:Number = 0;
         while(_loc7_ < param1.length)
         {
            _loc8_ = _loc3_;
            _loc9_ = _loc4_;
            _loc10_ = _loc5_;
            _loc11_ = _loc6_;
            _loc3_ = f5(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 0],7,-680876936);
            _loc6_ = f5(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 1],12,-389564586);
            _loc5_ = f5(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 2],17,606105819);
            _loc4_ = f5(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 3],22,-1044525330);
            _loc3_ = f5(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 4],7,-176418897);
            _loc6_ = f5(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 5],12,1200080426);
            _loc5_ = f5(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 6],17,-1473231341);
            _loc4_ = f5(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 7],22,-45705983);
            _loc3_ = f5(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 8],7,1770035416);
            _loc6_ = f5(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 9],12,-1958414417);
            _loc5_ = f5(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 10],17,-42063);
            _loc4_ = f5(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 11],22,-1990404162);
            _loc3_ = f5(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 12],7,1804603682);
            _loc6_ = f5(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 13],12,-40341101);
            _loc5_ = f5(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 14],17,-1502002290);
            _loc4_ = f5(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 15],22,1236535329);
            _loc3_ = f6(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 1],5,-165796510);
            _loc6_ = f6(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 6],9,-1069501632);
            _loc5_ = f6(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 11],14,643717713);
            _loc4_ = f6(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 0],20,-373897302);
            _loc3_ = f6(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 5],5,-701558691);
            _loc6_ = f6(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 10],9,38016083);
            _loc5_ = f6(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 15],14,-660478335);
            _loc4_ = f6(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 4],20,-405537848);
            _loc3_ = f6(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 9],5,568446438);
            _loc6_ = f6(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 14],9,-1019803690);
            _loc5_ = f6(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 3],14,-187363961);
            _loc4_ = f6(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 8],20,1163531501);
            _loc3_ = f6(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 13],5,-1444681467);
            _loc6_ = f6(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 2],9,-51403784);
            _loc5_ = f6(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 7],14,1735328473);
            _loc4_ = f6(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 12],20,-1926607734);
            _loc3_ = f7(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 5],4,-378558);
            _loc6_ = f7(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 8],11,-2022574463);
            _loc5_ = f7(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 11],16,1839030562);
            _loc4_ = f7(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 14],23,-35309556);
            _loc3_ = f7(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 1],4,-1530992060);
            _loc6_ = f7(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 4],11,1272893353);
            _loc5_ = f7(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 7],16,-155497632);
            _loc4_ = f7(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 10],23,-1094730640);
            _loc3_ = f7(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 13],4,681279174);
            _loc6_ = f7(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 0],11,-358537222);
            _loc5_ = f7(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 3],16,-722521979);
            _loc4_ = f7(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 6],23,76029189);
            _loc3_ = f7(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 9],4,-640364487);
            _loc6_ = f7(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 12],11,-421815835);
            _loc5_ = f7(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 15],16,530742520);
            _loc4_ = f7(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 2],23,-995338651);
            _loc3_ = f8(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 0],6,-198630844);
            _loc6_ = f8(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 7],10,1126891415);
            _loc5_ = f8(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 14],15,-1416354905);
            _loc4_ = f8(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 5],21,-57434055);
            _loc3_ = f8(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 12],6,1700485571);
            _loc6_ = f8(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 3],10,-1894986606);
            _loc5_ = f8(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 10],15,-1051523);
            _loc4_ = f8(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 1],21,-2054922799);
            _loc3_ = f8(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 8],6,1873313359);
            _loc6_ = f8(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 15],10,-30611744);
            _loc5_ = f8(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 6],15,-1560198380);
            _loc4_ = f8(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 13],21,1309151649);
            _loc3_ = f8(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 4],6,-145523070);
            _loc6_ = f8(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 11],10,-1120210379);
            _loc5_ = f8(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 2],15,718787259);
            _loc4_ = f8(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 9],21,-343485551);
            _loc3_ = f9(_loc3_,_loc8_);
            _loc4_ = f9(_loc4_,_loc9_);
            _loc5_ = f9(_loc5_,_loc10_);
            _loc6_ = f9(_loc6_,_loc11_);
            _loc7_ += 16;
         }
         return new Array(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      private static function f4(param1:Array) : String
      {
         var _loc2_:String = cap ? "0123456789ABCDEF" : "0123456789abcdef";
         var _loc3_:String = "";
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length * 4)
         {
            _loc3_ += _loc2_.charAt(param1[_loc4_ >> 2] >> _loc4_ % 4 * 8 + 4 & 0x0F) + _loc2_.charAt(param1[_loc4_ >> 2] >> _loc4_ % 4 * 8 & 0x0F);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private static function f5(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         return f10(param2 & param3 | ~param2 & param4,param1,param2,param5,param6,param7);
      }
      
      private static function f6(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         return f10(param2 & param4 | param3 & ~param4,param1,param2,param5,param6,param7);
      }
      
      private static function f7(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         return f10(param2 ^ param3 ^ param4,param1,param2,param5,param6,param7);
      }
      
      private static function f8(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         return f10(param3 ^ (param2 | ~param4),param1,param2,param5,param6,param7);
      }
      
      private static function f9(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param1 & 0xFFFF) + (param2 & 0xFFFF);
         var _loc4_:Number = (param1 >> 16) + (param2 >> 16) + (_loc3_ >> 16);
         return _loc4_ << 16 | _loc3_ & 0xFFFF;
      }
      
      private static function f10(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         return f9(f11(f9(f9(param2,param1),f9(param4,param6)),param5),param3);
      }
      
      private static function f11(param1:Number, param2:Number) : Number
      {
         return param1 << param2 | param1 >>> 32 - param2;
      }
      
      private static function f14() : void
      {
         sA = f1(sB);
      }
      
      private static function f15(param1:String) : String
      {
         return f1(param1 + sA);
      }
   }
}

