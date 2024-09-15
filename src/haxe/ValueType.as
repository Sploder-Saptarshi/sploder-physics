package haxe
{
   public final class ValueType extends enum
   {
      public static const __isenum:Boolean = true;
      
      public static var TBool:ValueType = new ValueType("TBool",3);
      
      public static var TFloat:ValueType = new ValueType("TFloat",2);
      
      public static var TFunction:ValueType = new ValueType("TFunction",5);
      
      public static var TInt:ValueType = new ValueType("TInt",1);
      
      public static var TNull:ValueType = new ValueType("TNull",0);
      
      public static var TObject:ValueType = new ValueType("TObject",4);
      
      public static var TUnknown:ValueType = new ValueType("TUnknown",8);
      
      public static var __constructs__:Array = ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"];
      
      public function ValueType(param1:String, param2:int, param3:Array = null)
      {
         super();
         this.tag = param1;
         this.index = param2;
         this.params = param3;
      }
      
      public static function TClass(param1:Class) : ValueType
      {
         return new ValueType("TClass",6,[param1]);
      }
      
      public static function TEnum(param1:Class) : ValueType
      {
         return new ValueType("TEnum",7,[param1]);
      }
   }
}

