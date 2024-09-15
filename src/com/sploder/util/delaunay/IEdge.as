package com.sploder.util.delaunay
{
   public class IEdge
   {
      public var p1:int;
      
      public var p2:int;
      
      public var tris:Array;
      
      public var numTris:int = 0;
      
      public var interPoints:Array;
      
      public function IEdge(param1:* = null, param2:* = null)
      {
         super();
         if(param1 == null)
         {
            this.p1 = this.p2 = -1;
         }
         else
         {
            this.p1 = param1;
            this.p2 = param2;
         }
      }
   }
}

