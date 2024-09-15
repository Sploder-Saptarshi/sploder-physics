package com.sploder.game.library
{
   import com.sploder.asui.Library;
   import com.sploder.texturegen_internal.TextureAttributes;
   import com.sploder.texturegen_internal.TextureRenderingCache;
   import com.sploder.texturegen_internal.TextureRenderingJob;
   import com.sploder.texturegen_internal.TextureRenderingQueue;
   import com.sploder.util.Geom2d;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EmbeddedLibrary extends Library
   {
      public static var textureQueue:TextureRenderingQueue;
      
      public static const INITIALIZED:String = "embeddedlibrary_initialized";
      
      public function EmbeddedLibrary(param1:Class, param2:Boolean = false)
      {
         super(param1,param2);
      }
      
      override protected function init() : void
      {
         super.init();
         if(TextureRenderingQueue.mainInstance != null)
         {
            textureQueue = TextureRenderingQueue.mainInstance;
         }
         else
         {
            textureQueue = new TextureRenderingQueue().init();
            textureQueue.pauseInterval = 1;
            textureQueue.tasksPerFrame = 1;
         }
      }
      
      public function getMovieClipAsBitmap(param1:String, param2:String = "", param3:Array = null) : Bitmap
      {
         return new Bitmap(this.getDisplayObjectBitmapData(param1,param2,param3),PixelSnapping.ALWAYS,smoothing);
      }
      
      public function getMovieClipBitmapData(param1:String, param2:String = "", param3:Array = null, param4:Number = 0) : BitmapData
      {
         return this.getDisplayObjectBitmapData(param1,param2,param3,param4);
      }
      
      public function getDisplayObjectBitmapData(param1:String, param2:String = "", param3:Array = null, param4:Number = 0, param5:Boolean = false) : BitmapData
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:BitmapData = null;
         var _loc12_:Matrix = null;
         var _loc13_:int = 0;
         var _loc6_:String = param2 != "" ? "__" + param2 : "";
         var _loc7_:int = param4 == 0 ? 0 : int(Math.floor(Geom2d.dtr * param4));
         if(bitmapDataCache[param1 + _loc6_ + "_" + _loc7_] != null && bitmapDataCache[param1 + _loc6_ + "_" + _loc7_] is BitmapData)
         {
            return BitmapData(bitmapDataCache[param1 + _loc6_ + "_" + _loc7_]);
         }
         var _loc8_:DisplayObject = getDisplayObject(param1);
         if(param2 != "" && _loc8_ is MovieClip)
         {
            MovieClip(_loc8_).gotoAndStop(param2);
         }
         if(_loc8_ != null)
         {
            _loc9_ = _loc8_.width;
            _loc10_ = _loc8_.height;
            _loc11_ = new BitmapData(Math.floor(_loc9_ * scale),Math.floor(_loc10_ * scale),true,0);
            _loc12_ = new Matrix();
            _loc12_.createBox(scale,scale,param4,Math.floor(_loc9_ * 0.5 * scale),Math.floor(_loc10_ * 0.5 * scale));
            _loc11_.draw(_loc8_,_loc12_);
            if(param3 != null)
            {
               _loc13_ = 0;
               while(_loc13_ < param3.length)
               {
                  _loc11_.applyFilter(_loc11_,new Rectangle(0,0,_loc11_.width,_loc11_.height),new Point(0,0),param3[_loc13_]);
                  _loc13_++;
               }
            }
            bitmapDataCache[param1] = _loc11_;
            return _loc11_;
         }
         return null;
      }
      
      public function getTextureAsBitmap(param1:TextureAttributes, param2:int = 120, param3:int = 0) : Bitmap
      {
         return new Bitmap(this.getTextureBitmapData(param1,param2,param3),PixelSnapping.ALWAYS,false);
      }
      
      public function getTextureBitmapData(param1:TextureAttributes, param2:int = 120, param3:int = 0) : BitmapData
      {
         var _loc4_:BitmapData = null;
         var _loc5_:TextureRenderingJob = null;
         if(!TextureRenderingCache.hasTexture(param1,param2,param3))
         {
            _loc4_ = new BitmapData(param2 * 4,param2 * 4,true,0);
            _loc4_.fillRect(_loc4_.rect,4278190080 + param1.diffuseColor);
            _loc5_ = new TextureRenderingJob().initWithProperties(param1,_loc4_,_loc4_.rect,param3,true,true,true);
            textureQueue.queueObject(_loc5_);
            TextureRenderingCache.setTexture(_loc4_,param1,param2,param3);
         }
         else
         {
            _loc4_ = TextureRenderingCache.getTexture(param1,param2,param3);
         }
         return _loc4_;
      }
      
      public function cleanTextureQueue() : void
      {
         TextureRenderingCache.queue = textureQueue;
         TextureRenderingCache.clearCache();
      }
      
      public function updateTexture(param1:Bitmap, param2:TextureAttributes, param3:int = 120, param4:int = 0) : void
      {
         var _loc5_:BitmapData = param1.bitmapData;
         _loc5_ = this.getTextureBitmapData(param2,param3,param4);
         if(_loc5_ != null)
         {
            param1.bitmapData = _loc5_;
         }
      }
   }
}

