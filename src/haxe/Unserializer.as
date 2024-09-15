package haxe
{
   public class Unserializer
   {
      public static var DEFAULT_RESOLVER:* = Type;
      
      protected var resolver:*;
      
      protected var scache:Array;
      
      protected var cache:Array;
      
      protected var length:int;
      
      protected var pos:int;
      
      protected var buf:String;
      
      public function Unserializer(param1:String = null)
      {
         super();
         this.buf = param1;
         this.length = param1.length;
         this.pos = 0;
         this.scache = new Array();
         this.cache = new Array();
         var _loc2_:* = Unserializer.DEFAULT_RESOLVER;
         if(_loc2_ == null)
         {
            _loc2_ = Type;
            Unserializer.DEFAULT_RESOLVER = _loc2_;
         }
         this.setResolver(_loc2_);
      }
      
      public static function run(param1:String) : *
      {
         return new Unserializer(param1).unserialize();
      }
      
      public function unserialize() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = undefined;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:Class = null;
         var _loc14_:* = undefined;
         var _loc15_:String = null;
         var _loc16_:Class = null;
         var _loc17_:* = undefined;
         var _loc18_:String = null;
         var _loc19_:Class = null;
         var _loc20_:int = 0;
         var _loc21_:String = null;
         var _loc22_:* = undefined;
         var _loc23_:List = null;
         var _loc24_:String = null;
         var _loc25_:Hash = null;
         var _loc26_:String = null;
         var _loc27_:String = null;
         var _loc28_:IntHash = null;
         var _loc29_:String = null;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:Date = null;
         var _loc33_:String = null;
         var _loc34_:Class = null;
         var _loc35_:* = undefined;
         switch(this.get(this.pos++))
         {
            case 110:
               return null;
            case 116:
               return true;
            case 102:
               return false;
            case 122:
               return 0;
            case 105:
               return this.readDigits();
            case 100:
               _loc1_ = this.pos;
               while(true)
               {
                  _loc2_ = this.get(this.pos);
                  if(!(_loc2_ >= 43 && _loc2_ < 58 || _loc2_ == 101 || _loc2_ == 69))
                  {
                     break;
                  }
                  ++this.pos;
               }
               return Std1._parseFloat(this.buf.substr(_loc1_,this.pos - _loc1_));
            case 121:
               _loc3_ = this.readDigits();
               if(this.get(this.pos++) != 58 || this.length - this.pos < _loc3_)
               {
                  throw "Invalid string length";
               }
               _loc4_ = this.buf.substr(this.pos,_loc3_);
               this.pos += _loc3_;
               _loc4_ = StringTools.urlDecode(_loc4_);
               this.scache.push(_loc4_);
               return _loc4_;
               break;
            case 107:
               return NaN;
            case 109:
               return Number.NEGATIVE_INFINITY;
            case 112:
               return Number.POSITIVE_INFINITY;
            case 97:
               _loc5_ = this.buf;
               _loc6_ = new Array();
               this.cache.push(_loc6_);
               while(_loc7_ = this.get(this.pos), _loc7_ != 104)
               {
                  if(_loc7_ == 117)
                  {
                     ++this.pos;
                     _loc8_ = this.readDigits();
                     _loc6_[_loc6_.length + _loc8_ - 1] = null;
                  }
                  else
                  {
                     _loc6_.push(this.unserialize());
                  }
               }
               ++this.pos;
               return _loc6_;
            case 111:
               _loc9_ = {};
               this.cache.push(_loc9_);
               this.unserializeObject(_loc9_);
               return _loc9_;
            case 114:
               _loc10_ = this.readDigits();
               if(_loc10_ < 0 || _loc10_ >= this.cache.length)
               {
                  throw "Invalid reference";
               }
               return this.cache[_loc10_];
               break;
            case 82:
               _loc11_ = this.readDigits();
               if(_loc11_ < 0 || _loc11_ >= this.scache.length)
               {
                  throw "Invalid string reference";
               }
               return this.scache[_loc11_];
               break;
            case 120:
               throw this.unserialize();
            case 99:
               _loc12_ = this.unserialize();
               _loc13_ = this.resolver.resolveClass(_loc12_);
               if(_loc13_ == null)
               {
                  throw "Class not found " + _loc12_;
               }
               _loc14_ = Type.createEmptyInstance(_loc13_);
               this.cache.push(_loc14_);
               this.unserializeObject(_loc14_);
               return _loc14_;
               break;
            case 119:
               _loc15_ = this.unserialize();
               _loc16_ = this.resolver.resolveEnum(_loc15_);
               if(_loc16_ == null)
               {
                  throw "Enum not found " + _loc15_;
               }
               _loc17_ = this.unserializeEnum(_loc16_,this.unserialize());
               this.cache.push(_loc17_);
               return _loc17_;
               break;
            case 106:
               _loc18_ = this.unserialize();
               _loc19_ = this.resolver.resolveEnum(_loc18_);
               if(_loc19_ == null)
               {
                  throw "Enum not found " + _loc18_;
               }
               ++this.pos;
               _loc20_ = this.readDigits();
               _loc21_ = Type.getEnumConstructs(_loc19_)[_loc20_];
               if(_loc21_ == null)
               {
                  throw "Unknown enum index " + _loc18_ + "@" + _loc20_;
               }
               _loc22_ = this.unserializeEnum(_loc19_,_loc21_);
               this.cache.push(_loc22_);
               return _loc22_;
               break;
            case 108:
               _loc23_ = new List();
               this.cache.push(_loc23_);
               _loc24_ = this.buf;
               while(this.get(this.pos) != 104)
               {
                  _loc23_.add(this.unserialize());
               }
               ++this.pos;
               return _loc23_;
            case 98:
               _loc25_ = new Hash();
               this.cache.push(_loc25_);
               _loc26_ = this.buf;
               while(this.get(this.pos) != 104)
               {
                  _loc27_ = this.unserialize();
                  _loc25_.set(_loc27_,this.unserialize());
               }
               ++this.pos;
               return _loc25_;
            case 113:
               _loc28_ = new IntHash();
               this.cache.push(_loc28_);
               _loc29_ = this.buf;
               _loc30_ = this.get(this.pos++);
               while(_loc30_ == 58)
               {
                  _loc31_ = this.readDigits();
                  _loc28_.set(_loc31_,this.unserialize());
                  _loc30_ = this.get(this.pos++);
               }
               if(_loc30_ != 104)
               {
                  throw "Invalid IntHash format";
               }
               return _loc28_;
               break;
            case 118:
               _loc32_ = Date["fromString"](this.buf.substr(this.pos,19));
               this.cache.push(_loc32_);
               this.pos += 19;
               return _loc32_;
            case 67:
               _loc33_ = this.unserialize();
               _loc34_ = this.resolver.resolveClass(_loc33_);
               if(_loc34_ == null)
               {
                  throw "Class not found " + _loc33_;
               }
               _loc35_ = Type.createEmptyInstance(_loc34_);
               this.cache.push(_loc35_);
               _loc35_.hxUnserialize(this);
               if(this.get(this.pos++) != 103)
               {
                  throw "Invalid custom data";
               }
               return _loc35_;
               break;
            default:
               --this.pos;
               throw "Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos;
         }
      }
      
      protected function unserializeEnum(param1:Class, param2:String) : *
      {
         if(this.get(this.pos++) != 58)
         {
            throw "Invalid enum format";
         }
         var _loc3_:int = this.readDigits();
         if(_loc3_ == 0)
         {
            return Type.createEnum(param1,param2);
         }
         var _loc4_:Array = new Array();
         while(_loc3_-- > 0)
         {
            _loc4_.push(this.unserialize());
         }
         return Type.createEnum(param1,param2,_loc4_);
      }
      
      protected function unserializeObject(param1:*) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         while(this.pos < this.length)
         {
            if(this.get(this.pos) == 103)
            {
               ++this.pos;
               return;
            }
            _loc2_ = this.unserialize();
            if(!Std1._is(_loc2_,String))
            {
               throw "Invalid object key";
            }
            _loc3_ = this.unserialize();
            Reflect.setField(param1,_loc2_,_loc3_);
         }
         throw "Invalid object";
      }
      
      protected function readDigits() : int
      {
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = this.pos;
         while(true)
         {
            _loc4_ = this.get(this.pos);
            if(StringTools.isEOF(_loc4_))
            {
               break;
            }
            if(_loc4_ == 45)
            {
               if(this.pos != _loc3_)
               {
                  break;
               }
               _loc2_ = true;
               ++this.pos;
            }
            else
            {
               if(_loc4_ < 48 || _loc4_ > 57)
               {
                  break;
               }
               _loc1_ = _loc1_ * 10 + (_loc4_ - 48);
               ++this.pos;
            }
         }
         if(_loc2_)
         {
            _loc1_ *= -1;
         }
         return _loc1_;
      }
      
      protected function get(param1:int) : int
      {
         return StringTools.fastCodeAt(this.buf,param1);
      }
      
      public function getResolver() : *
      {
         return this.resolver;
      }
      
      public function setResolver(param1:*) : void
      {
         var r:* = param1;
         if(r == null)
         {
            this.resolver = {
               "resolveClass":function(param1:String):Class
               {
                  return null;
               },
               "resolveEnum":function(param1:String):Class
               {
                  return null;
               }
            };
         }
         else
         {
            this.resolver = r;
         }
      }
   }
}

