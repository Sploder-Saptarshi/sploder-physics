package com.sploder.util
{
   import flash.net.*;
   
   public class Settings
   {
      public static var so:SharedObject;
      
      private static var _bucket:String = "sploderglobal";
      
      public function Settings()
      {
         super();
      }
      
      public static function get bucketName() : String
      {
         return _bucket;
      }
      
      public static function set bucketName(param1:String) : void
      {
         _bucket = param1.length > 0 ? param1 : _bucket;
         initialize();
      }
      
      public static function initialize() : void
      {
         so = SharedObject.getLocal(_bucket);
      }
      
      public static function loadSetting(param1:String) : Object
      {
         if(so == null)
         {
            initialize();
         }
         if(param1.length > 0)
         {
            return so.data[param1];
         }
         return null;
      }
      
      public static function saveSetting(param1:String, param2:Object) : void
      {
         if(so == null)
         {
            initialize();
         }
         if(param1.length > 0)
         {
            so.data[param1] = param2;
         }
         so.flush();
      }
      
      public static function clearSettings() : void
      {
         if(so == null)
         {
            initialize();
         }
         so.clear();
      }
   }
}

