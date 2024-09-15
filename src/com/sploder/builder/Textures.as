package com.sploder.builder
{
   import com.sploder.asui.ObjectEvent;
   import com.sploder.game.library.EmbeddedLibrary;
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   
   public class Textures
   {
      public static var library:EmbeddedLibrary;
      
      protected static var _dispatcher:EventDispatcher;
      
      protected static var _textureCache:Object;
      
      protected static var _m:Matrix;
      
      public static const TEXTURE_REQUEST:String = "texture_request";
      
      public function Textures()
      {
         super();
      }
      
      public static function getCacheKey(param1:String, param2:int = 2, param3:uint = 0) : String
      {
         return param1 + "_" + param2 + "_" + param3;
      }
      
      public static function getOriginal(param1:String) : BitmapData
      {
         if(_textureCache == null)
         {
            _textureCache = {};
         }
         return _textureCache[param1];
      }
      
      public static function getScaledBitmapData(param1:String, param2:int = 2, param3:uint = 0, param4:Object = null) : BitmapData
      {
         var _loc6_:BitmapData = null;
         var _loc7_:BitmapData = null;
         var _loc5_:String = getCacheKey(param1,param2,param3);
         if(_textureCache == null)
         {
            _textureCache = {};
         }
         else if(_textureCache[_loc5_] is BitmapData)
         {
            return BitmapData(_textureCache[_loc5_]);
         }
         if(library)
         {
            if(isLoaded(param1))
            {
               _loc6_ = _textureCache[param1];
            }
            else
            {
               if(!isNaN(parseInt(param1.charAt(0))))
               {
                  if(param4 != null)
                  {
                     dispatcher.dispatchEvent(new ObjectEvent(TEXTURE_REQUEST,false,false,param4));
                  }
                  return null;
               }
               _loc6_ = library.getBitmapData(param1);
            }
            try
            {
               if(_loc6_)
               {
                  _loc7_ = new BitmapData(_loc6_.height * param2,_loc6_.height * param2,true,0);
                  if(_m == null)
                  {
                     _m = new Matrix();
                  }
                  _m.createBox(param2,param2,0,0,0);
                  _m.tx = 0 - _loc6_.height * param2 * param3;
                  _loc7_.draw(_loc6_,_m);
                  _textureCache[_loc5_] = _loc7_;
                  return _loc7_;
               }
            }
            catch(e:Error)
            {
            }
         }
         return null;
      }
      
      public static function isLoaded(param1:String) : Boolean
      {
         if(_textureCache == null)
         {
            _textureCache = {};
         }
         return _textureCache[param1] is BitmapData;
      }
      
      public static function addBitmapDataToCache(param1:String, param2:BitmapData) : void
      {
         if(_textureCache == null)
         {
            _textureCache = {};
         }
         _textureCache[param1] = param2;
      }
      
      public static function cleanCache() : void
      {
         var _loc1_:Object = null;
         if(_textureCache)
         {
            for each(_loc1_ in _textureCache)
            {
               if(_loc1_ is BitmapData)
               {
                  BitmapData(_loc1_).dispose();
               }
            }
            _textureCache = {};
         }
      }
      
      public static function get dispatcher() : EventDispatcher
      {
         if(_dispatcher == null)
         {
            _dispatcher = new EventDispatcher();
         }
         return _dispatcher;
      }
   }
}

