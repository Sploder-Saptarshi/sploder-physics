package com.sploder.util.delaunay
{
   public class XYZ
   {
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function XYZ(param1:* = null, param2:* = null, param3:* = null)
      {
         super();
         if(param1 != null)
         {
            this.x = param1;
            this.y = param2;
            this.z = param3;
         }
      }
   }
}

