package haxe
{
   public class List
   {
      public var length:int;
      
      protected var q:Array;
      
      protected var h:Array;
      
      public function List()
      {
         super();
         this.length = 0;
      }
      
      public function map(param1:Function) : List
      {
         var _loc4_:* = undefined;
         var _loc2_:List = new List();
         var _loc3_:Array = this.h;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_[0];
            _loc3_ = _loc3_[1];
            _loc2_.add(param1(_loc4_));
         }
         return _loc2_;
      }
      
      public function filter(param1:Function) : List
      {
         var _loc4_:* = undefined;
         var _loc2_:List = new List();
         var _loc3_:Array = this.h;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_[0];
            _loc3_ = _loc3_[1];
            if(param1(_loc4_))
            {
               _loc2_.add(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function join(param1:String) : String
      {
         var _loc2_:StringBuf = new StringBuf();
         var _loc3_:Boolean = true;
         var _loc4_:Array = this.h;
         while(_loc4_ != null)
         {
            if(_loc3_)
            {
               _loc3_ = false;
            }
            else
            {
               _loc2_.add(param1);
            }
            _loc2_.add(_loc4_[0]);
            _loc4_ = _loc4_[1];
         }
         return _loc2_.toString();
      }
      
      public function toString() : String
      {
         var _loc1_:StringBuf = new StringBuf();
         var _loc2_:Boolean = true;
         var _loc3_:Array = this.h;
         _loc1_.add("{");
         while(_loc3_ != null)
         {
            if(_loc2_)
            {
               _loc2_ = false;
            }
            else
            {
               _loc1_.add(", ");
            }
            _loc1_.add(Std.string(_loc3_[0]));
            _loc3_ = _loc3_[1];
         }
         _loc1_.add("}");
         return _loc1_.toString();
      }
      
      public function iterator() : *
      {
         return {
            "h":this.h,
            "hasNext":function():*
            {
               return this.h != null;
            },
            "next":function():*
            {
               if(this.h == null)
               {
                  return null;
               }
               var _loc1_:* = this.h[0];
               this.h = this.h[1];
               return _loc1_;
            }
         };
      }
      
      public function remove(param1:*) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:Array = this.h;
         while(_loc3_ != null)
         {
            if(_loc3_[0] == param1)
            {
               if(_loc2_ == null)
               {
                  this.h = _loc3_[1];
               }
               else
               {
                  _loc2_[1] = _loc3_[1];
               }
               if(this.q == _loc3_)
               {
                  this.q = _loc2_;
               }
               --this.length;
               return true;
            }
            _loc2_ = _loc3_;
            _loc3_ = _loc3_[1];
         }
         return false;
      }
      
      public function clear() : void
      {
         this.h = null;
         this.q = null;
         this.length = 0;
      }
      
      public function isEmpty() : Boolean
      {
         return this.h == null;
      }
      
      public function pop() : *
      {
         if(this.h == null)
         {
            return null;
         }
         var _loc1_:* = this.h[0];
         this.h = this.h[1];
         if(this.h == null)
         {
            this.q = null;
         }
         --this.length;
         return _loc1_;
      }
      
      public function last() : *
      {
         return this.q == null ? null : this.q[0];
      }
      
      public function first() : *
      {
         return this.h == null ? null : this.h[0];
      }
      
      public function push(param1:*) : void
      {
         var _loc2_:Array = [param1,this.h];
         this.h = _loc2_;
         if(this.q == null)
         {
            this.q = _loc2_;
         }
         ++this.length;
      }
      
      public function add(param1:*) : void
      {
         var _loc2_:Array = [param1];
         if(this.h == null)
         {
            this.h = _loc2_;
         }
         else
         {
            this.q[1] = _loc2_;
         }
         this.q = _loc2_;
         ++this.length;
      }
   }
}

