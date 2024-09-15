package haxe
{
   import flash.utils.describeType;
   public class Serializer
   {
      public static var USE_CACHE:Boolean = false;
      
      public static var USE_ENUM_INDEX:Boolean = false;
      
      public var useEnumIndex:Boolean;
      
      public var useCache:Boolean;
      
      protected var scount:int;
      
      protected var shash:Hash;
      
      protected var cache:Array;
      
      protected var buf:StringBuf;
      
      public function Serializer()
      {
         super();
         this.buf = new StringBuf();
         this.cache = new Array();
         this.useCache = Serializer.USE_CACHE;
         this.useEnumIndex = Serializer.USE_ENUM_INDEX;
         this.shash = new Hash();
         this.scount = 0;
      }
      
      public static function run(param1:*) : String
      {
         var _loc2_:Serializer = new Serializer();
         _loc2_.serialize(param1);
         return _loc2_.toString();
      }
      
      public function serializeException(param1:*) : void
      {
         var _loc2_:Error = null;
         var _loc3_:String = null;
         this.buf.add("x");
         if(param1 is Error)
         {
            _loc2_ = param1;
            _loc3_ = _loc2_.getStackTrace();
            if(_loc3_ == null)
            {
               this.serialize(_loc2_.message);
            }
            else
            {
               this.serialize(_loc3_);
            }
            return;
         }
         this.serialize(param1);
      }
      
      public function serialize(param1:*) : void
      {
         var $e:enum = null;
         var c:Class = null;
         var e1:Class = null;
         var ucount:int = 0;
         var v1:Array = null;
         var l:int = 0;
         var _g:int = 0;
         var i:int = 0;
         var v2:List = null;
         var $it2:* = undefined;
         var i1:* = undefined;
         var d:Date = null;
         var v3:Hash = null;
         var $it3:* = undefined;
         var k:String = null;
         var v4:IntHash = null;
         var $it4:* = undefined;
         var k1:int = 0;
         var pl:Array = null;
         var _g1:int = 0;
         var p:* = undefined;
         var v:* = param1;
         $e = Type._typeof(v);
         switch($e.index)
         {
            case 0:
               this.buf.add("n");
               break;
            case 1:
               if(v == 0)
               {
                  this.buf.add("z");
                  return;
               }
               this.buf.add("i");
               this.buf.add(v);
               break;
            case 2:
               if(isNaN(v))
               {
                  this.buf.add("k");
               }
               else if(!isFinite(v))
               {
                  this.buf.add(v < 0 ? "m" : "p");
               }
               else
               {
                  this.buf.add("d");
                  this.buf.add(v);
               }
               break;
            case 3:
               this.buf.add(!!v ? "t" : "f");
               break;
            case 6:
               c = $e.params[0];
               if(c == String)
               {
                  this.serializeString(v);
                  return;
               }
               if(this.useCache && this.serializeRef(v))
               {
                  return;
               }
               switch(c)
               {
                  case Array:
                     ucount = 0;
                     this.buf.add("a");
                     v1 = v;
                     l = int(v1.length);
                     _g = 0;
                     while(_g < l)
                     {
                        i = _g++;
                        if(v1[i] == null)
                        {
                           ucount++;
                        }
                        else
                        {
                           if(ucount > 0)
                           {
                              if(ucount == 1)
                              {
                                 this.buf.add("n");
                              }
                              else
                              {
                                 this.buf.add("u");
                                 this.buf.add(ucount);
                              }
                              ucount = 0;
                           }
                           this.serialize(v1[i]);
                        }
                     }
                     if(ucount > 0)
                     {
                        if(ucount == 1)
                        {
                           this.buf.add("n");
                        }
                        else
                        {
                           this.buf.add("u");
                           this.buf.add(ucount);
                        }
                     }
                     this.buf.add("h");
                     break;
                  case List:
                     this.buf.add("l");
                     v2 = v;
                     $it2 = v2.iterator();
                     while($it2.hasNext())
                     {
                        i1 = $it2.next();
                        this.serialize(i1);
                     }
                     this.buf.add("h");
                     break;
                  case Date:
                     d = v;
                     this.buf.add("v");
                     this.buf.add(d["toStringHX"]());
                     break;
                  case Hash:
                     this.buf.add("b");
                     v3 = v;
                     $it3 = v3.keys();
                     while($it3.hasNext())
                     {
                        k = $it3.next();
                        this.serializeString(k);
                        this.serialize(v3.get(k));
                     }
                     this.buf.add("h");
                     break;
                  case IntHash:
                     this.buf.add("q");
                     v4 = v;
                     $it4 = v4.keys();
                     while($it4.hasNext())
                     {
                        k1 = int($it4.next());
                        this.buf.add(":");
                        this.buf.add(k1);
                        this.serialize(v4.get(k1));
                     }
                     this.buf.add("h");
                     break;
                  default:
                     this.cache.pop();
                     if((function(param1:Serializer):Boolean
                     {
                        var $r5:* = undefined;
                        var $this:Serializer = param1;
                        try
                        {
                           $r5 = v.hxSerialize != null;
                        }
                        catch(e:*)
                        {
                           $r5 = false;
                        }
                        return $r5;
                     })(this))
                     {
                        this.buf.add("C");
                        this.serializeString(Type.getClassName(c));
                        this.cache.push(v);
                        v.hxSerialize(this);
                        this.buf.add("g");
                     }
                     else
                     {
                        this.buf.add("c");
                        this.serializeString(Type.getClassName(c));
                        this.cache.push(v);
                        this.serializeClassFields(v,c);
                     }
               }
               break;
            case 4:
               if(this.useCache && this.serializeRef(v))
               {
                  return;
               }
               this.buf.add("o");
               this.serializeFields(v);
               break;
            case 7:
               e1 = $e.params[0];
               if(this.useCache && this.serializeRef(v))
               {
                  return;
               }
               this.cache.pop();
               this.buf.add(this.useEnumIndex ? "j" : "w");
               this.serializeString(Type.getEnumName(e1));
               if(this.useEnumIndex)
               {
                  this.buf.add(":");
                  this.buf.add(v.index);
               }
               else
               {
                  this.serializeString(v.tag);
               }
               this.buf.add(":");
               pl = v.params;
               if(pl == null)
               {
                  this.buf.add(0);
               }
               else
               {
                  this.buf.add(pl.length);
                  _g1 = 0;
                  while(_g1 < pl.length)
                  {
                     p = pl[_g1];
                     _g1++;
                     this.serialize(p);
                  }
               }
               this.cache.push(v);
               break;
            case 5:
               throw "Cannot serialize function";
            default:
               throw "Cannot serialize " + Std.string(v);
         }
      }
      
      protected function serializeFields(param1:*) : void
      {
         var _loc4_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Array = Reflect.fields(param1);
         while(_loc2_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc2_];
            _loc2_++;
            this.serializeString(_loc4_);
            this.serialize(Reflect.field(param1,_loc4_));
         }
         this.buf.add("g");
      }
      
      protected function serializeClassFields(param1:*, param2:Class) : void
      {
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc3_:XML = describeType(param2);
         var _loc4_:XMLList = _loc3_.factory[0].child("variable");
         var _loc5_:int = 0;
         var _loc6_:int = int(_loc4_.length());
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _loc8_ = _loc4_[_loc7_].attribute("name").toString();
            if(param1.hasOwnProperty(_loc8_))
            {
               this.serializeString(_loc8_);
               this.serialize(Reflect.field(param1,_loc8_));
            }
         }
         this.buf.add("g");
      }
      
      protected function serializeRef(param1:*) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = int(this.cache.length);
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            if(this.cache[_loc4_] == param1)
            {
               this.buf.add("r");
               this.buf.add(_loc4_);
               return true;
            }
         }
         this.cache.push(param1);
         return false;
      }
      
      protected function serializeString(param1:String) : void
      {
         var _loc2_:* = this.shash.get(param1);
         if(_loc2_ != null)
         {
            this.buf.add("R");
            this.buf.add(_loc2_);
            return;
         }
         this.shash.set(param1,this.scount++);
         this.buf.add("y");
         param1 = StringTools.urlEncode(param1);
         this.buf.add(param1.length);
         this.buf.add(":");
         this.buf.add(param1);
      }
      
      public function toString() : String
      {
         return this.buf.toString();
      }
   }
}

