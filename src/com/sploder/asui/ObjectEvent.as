package com.sploder.asui
{
   import flash.events.Event;
   
   public dynamic class ObjectEvent extends Event
   {
      public var object:Object;
      
      public function ObjectEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         super(param1,param2,param3);
         this.object = param4;
      }
      
      override public function clone() : Event
      {
         return new ObjectEvent(type,bubbles,cancelable,this.object);
      }
      
      override public function toString() : String
      {
         return formatToString("ObjectEvent","type","bubbles","cancelable",this.object);
      }
   }
}

