package com.sploder.data
{
   public dynamic class User
   {
      public static var u:int;
      
      public static var c:String;
      
      public static var m:String;
      
      public static var name:String;
      
      public static var s:String;
      
      public static var a:String = "0";
      
      public static const projectFolderName:String = "projects";
      
      public static const imageFolderName:String = "photos";
      
      public static const thumbFolderName:String = "thumbs";
      
      public function User()
      {
         super();
      }
      
      public static function get path() : String
      {
         if(u > 0 && c.length > 0)
         {
            return "/users/group" + Math.floor(u / 1000) + "/user" + u + "_" + c + "/";
         }
         return "";
      }
      
      public static function get projectpath() : String
      {
         if(m == "temp")
         {
            return path + projectFolderName + "/temp/";
         }
         if(parseInt(m) > 0)
         {
            return path + projectFolderName + "/proj" + m + "/";
         }
         return "";
      }
      
      public static function get imagepath() : String
      {
         return path + imageFolderName + "/";
      }
      
      public static function get thumbspath() : String
      {
         return path + thumbFolderName + "/";
      }
      
      public static function parseUserData(param1:Object) : void
      {
         if(param1.u != undefined)
         {
            u = parseInt(param1.u);
         }
         if(param1.c != undefined)
         {
            c = String(param1.c);
         }
         if(param1.m != undefined)
         {
            m = String(param1.m);
         }
         if(param1.a != undefined)
         {
            a = String(param1.a);
         }
      }
   }
}

