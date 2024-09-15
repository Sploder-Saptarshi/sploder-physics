package com.sploder.asui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   import flash.utils.Timer;
   
   public class Library extends EventDispatcher
   {
      public static var scale:Number = 1;
      
      public static const INITIALIZED:String = "embeddedlibrary_initialized";
      
      protected var _smoothing:Boolean = false;
      
      protected var embeddedLibrary:Class;
      
      protected var loader:Loader;
      
      protected var debugmode:Boolean;
      
      protected var bitmapDataCache:Object;
      
      protected var _timer:Timer;
      
      protected var _eventSent:Boolean = false;
      
      public function Library(param1:Class, param2:Boolean = false)
      {
         super();
         this.embeddedLibrary = param1;
         this.debugmode = param2;
         this.init();
      }
      
      public function get smoothing() : Boolean
      {
         return this._smoothing;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         this._smoothing = param1;
      }
      
      protected function get initialized() : Boolean
      {
         return this.loader.content != null;
      }
      
      protected function init() : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.onInitialize,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
         this.loader.loadBytes(new this.embeddedLibrary());
         this.bitmapDataCache = {};
         this._timer = new Timer(250,0);
         this._timer.addEventListener(TimerEvent.TIMER,this.checkEvent);
         this._timer.start();
      }
      
      protected function onInitialize(param1:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.onInitialize);
         dispatchEvent(new Event(Event.INIT));
         this._eventSent = true;
      }
      
      protected function onComplete(param1:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
      }
      
      protected function checkEvent(param1:TimerEvent) : void
      {
         if(this.initialized)
         {
            if(!this._eventSent)
            {
               dispatchEvent(new Event(Event.INIT));
            }
            this._timer.stop();
         }
      }
      
      public function getDisplayObject(param1:String) : DisplayObject
      {
         var obj:Object = null;
         var symbolName:String = param1;
         if(!this.initialized)
         {
            throw new Error("ERROR: Component Library not initialized.");
         }
         try
         {
            obj = this.getSymbolInstance(symbolName);
            if(obj is DisplayObject)
            {
               return obj as DisplayObject;
            }
            throw new Error();
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function getBitmapData(param1:String) : BitmapData
      {
         var obj:Object = null;
         var symbolName:String = param1;
         if(!this.initialized)
         {
            throw new Error("ERROR: Component Library not initialized.");
         }
         try
         {
            obj = this.getSymbolInstance(symbolName);
            if(obj is BitmapData)
            {
               return obj as BitmapData;
            }
            throw new Error();
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function getDisplayObjectAsBitmap(param1:String, param2:Array = null) : Bitmap
      {
         var _loc4_:BitmapData = null;
         var _loc5_:Matrix = null;
         var _loc6_:int = 0;
         if(!this.initialized)
         {
            throw new Error("ERROR: Component Library not initialized.");
         }
         if(this.bitmapDataCache[param1] != null && this.bitmapDataCache[param1] is BitmapData)
         {
            return new Bitmap(this.bitmapDataCache[param1],PixelSnapping.NEVER,this.smoothing);
         }
         var _loc3_:DisplayObject = this.getDisplayObject(param1);
         if(_loc3_ != null)
         {
            _loc4_ = new BitmapData(Math.floor(_loc3_.width * scale),Math.floor(_loc3_.height * scale),true,0);
            _loc5_ = new Matrix();
            _loc5_.createBox(scale,scale,0,Math.floor(_loc3_.width * 0.5 * scale),Math.floor(_loc3_.height * 0.5 * scale));
            _loc4_.draw(_loc3_,_loc5_);
            if(param2 != null)
            {
               _loc6_ = 0;
               while(_loc6_ < param2.length)
               {
                  _loc4_.applyFilter(_loc4_,new Rectangle(0,0,_loc4_.width,_loc4_.height),new Point(0,0),param2[_loc6_]);
                  _loc6_++;
               }
            }
            this.bitmapDataCache[param1] = _loc4_;
            return new Bitmap(_loc4_);
         }
         return null;
      }
      
      public function getSound(param1:String) : Sound
      {
         var obj:Object = null;
         var symbolName:String = param1;
         if(!this.initialized)
         {
            throw new Error("ERROR: Component Library not initialized.");
         }
         try
         {
            obj = this.getSymbolInstance(symbolName);
            if(obj is Sound)
            {
               return obj as Sound;
            }
            throw new Error();
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function getFont(param1:String) : Class
      {
         var obj:Object = null;
         var fontClassName:String = param1;
         try
         {
            return this.getSymbolDefinition(fontClassName);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      protected function getSymbolInstance(param1:String) : Object
      {
         var _loc2_:Class = this.getSymbolDefinition(param1);
         return !!_loc2_ ? new _loc2_() : null;
      }
      
      protected function getSymbolDefinition(param1:String) : Class
      {
         if(this.initialized)
         {
            if(this.loader.contentLoaderInfo.applicationDomain.hasDefinition(param1))
            {
               return this.loader.contentLoaderInfo.applicationDomain.getDefinition(param1) as Class;
            }
         }
         return null;
      }
   }
}

