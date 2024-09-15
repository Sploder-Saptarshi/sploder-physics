package com.sploder.data
{
   import flash.events.Event;
   
   public class DataLoaderEvent extends Event
   {
      public static const METADATA_LOADED:String = "metadata_loaded";
      
      public static const DATA_LOADED:String = "data_loaded";
      
      public static const METADATA_ERROR:String = "metadata_error";
      
      public static const DATA_ERROR:String = "data_error";
      
      public var dataObject:Object;
      
      public function DataLoaderEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         super(param1,param2,param3);
         this.dataObject = param4;
      }
      
      override public function clone() : Event
      {
         return new DataLoaderEvent(type,bubbles,cancelable,this.dataObject);
      }
      
      override public function toString() : String
      {
         return formatToString("CollisionEvent","type","bubbles","cancelable","dataObject");
      }
   }
}

