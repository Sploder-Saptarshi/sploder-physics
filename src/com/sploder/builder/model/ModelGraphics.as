package com.sploder.builder.model
{
   import com.sploder.asui.ObjectEvent;
   import com.sploder.builder.Textures;
   import com.sploder.game.ViewSprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class ModelGraphics
   {
      protected var _base:String = "";
      
      protected var _graphics:Dictionary;
      
      protected var _requestedGraphics:Array;
      
      protected var _waitingObjects:Dictionary;
      
      protected var _loaders:Dictionary;
      
      public function ModelGraphics()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._graphics = new Dictionary();
         this._requestedGraphics = [];
         this._waitingObjects = new Dictionary(true);
         this._loaders = new Dictionary();
         Textures.dispatcher.addEventListener(Textures.TEXTURE_REQUEST,this.onTextureRequest);
         if(CreatorMain.preloader.loaderInfo.url.indexOf("sploder") == -1 || CreatorMain.preloader.loaderInfo.url.indexOf("file") != -1)
         {
            this._base = "http://sploder_dev.s3.amazonaws.com/gfx/png/";
         }
         else
         {
            this._base = "http://sploder.s3.amazonaws.com/gfx/png/";
         }
      }
      
      public function clean() : void
      {
         Textures.cleanCache();
         Textures.dispatcher.removeEventListener(Textures.TEXTURE_REQUEST,this.onTextureRequest);
         this.init();
      }
      
      private function onTextureRequest(param1:ObjectEvent) : void
      {
         if(param1.object is ModelObjectSprite && Boolean(ModelObjectSprite(param1.object).obj.props))
         {
            this.assignGraphicToObject(ModelObjectSprite(param1.object).obj.props.graphic,ModelObjectSprite(param1.object).obj.props.graphic_version,param1.object);
         }
         else if(param1.object is ViewSprite)
         {
            this.assignGraphicToObject(ViewSprite(param1.object).modelObject.props.graphic,ViewSprite(param1.object).modelObject.props.graphic_version,param1.object);
            this._waitingObjects[param1.object] = this.getGraphicKey(ViewSprite(param1.object).modelObject.props.graphic,ViewSprite(param1.object).modelObject.props.graphic_version);
         }
      }
      
      protected function getGraphicKey(param1:uint, param2:uint) : String
      {
         return param1 + "_" + param2;
      }
      
      protected function loadGraphic(param1:uint, param2:uint) : void
      {
         var _loc3_:Loader = new Loader();
         this._loaders[_loc3_.contentLoaderInfo] = this.getGraphicKey(param1,param2);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onGraphicLoaded);
         _loc3_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onGraphicError);
         _loc3_.load(new URLRequest(this._base + this.getGraphicKey(param1,param2) + ".png"));
      }
      
      protected function onGraphicLoaded(param1:Event) : void
      {
         var _loc4_:* = false;
         var _loc2_:String = this._loaders[param1.target];
         var _loc3_:BitmapData = Bitmap(LoaderInfo(param1.target).content).bitmapData;
         if(Boolean(_loc2_) && Boolean(_loc3_))
         {
            _loc4_ = _loc3_.width > _loc3_.height;
            this._graphics[_loc2_] = _loc3_;
            Textures.addBitmapDataToCache(_loc2_,_loc3_);
            this.handleWaitingObjects(_loc4_);
         }
         this._loaders[param1.target] = null;
         delete this._loaders[param1.target];
         this.clearRequest(_loc2_);
      }
      
      protected function onGraphicError(param1:Event) : void
      {
         var _loc2_:String = this._loaders[param1.target];
         this._loaders[param1.target] = null;
         delete this._loaders[param1.target];
         this.clearRequest(_loc2_);
      }
      
      protected function clearRequest(param1:String) : void
      {
         if(this._requestedGraphics.indexOf(param1) != -1)
         {
            this._requestedGraphics.splice(this._requestedGraphics.indexOf(param1),1);
         }
      }
      
      protected function handleWaitingObjects(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         for(_loc2_ in this._waitingObjects)
         {
            if(this._waitingObjects[_loc2_] is String && this.isLoaded(this._waitingObjects[_loc2_]))
            {
               if(_loc2_ is ModelObjectSprite)
               {
                  ModelObjectSprite(_loc2_).draw();
                  if(param1 && ModelObjectSprite(_loc2_).obj.props.animation == 0)
                  {
                     ModelObjectSprite(_loc2_).obj.props.animation = 1;
                  }
               }
               else if(_loc2_ is ViewSprite)
               {
                  ViewSprite(_loc2_).draw();
                  if(param1 && ViewSprite(_loc2_).modelObject.props.animation == 0)
                  {
                     ViewSprite(_loc2_).modelObject.props.animation = 1;
                  }
               }
               this._waitingObjects[_loc2_] = null;
               delete this._waitingObjects[_loc2_];
            }
         }
      }
      
      protected function isLoaded(param1:String) : Boolean
      {
         return this._graphics[param1] is BitmapData;
      }
      
      public function assignGraphicToObject(param1:uint, param2:uint, param3:Object) : void
      {
         var _loc4_:String = this.getGraphicKey(param1,param2);
         if(this.isLoaded(_loc4_))
         {
            if(param3 is ModelObjectSprite)
            {
               ModelObjectSprite(param3).draw();
            }
            else if(param3 is ViewSprite)
            {
               ViewSprite(param3).draw();
            }
         }
         else
         {
            this._waitingObjects[param3] = _loc4_;
            if(this._requestedGraphics.indexOf(_loc4_) == -1)
            {
               this.loadGraphic(param1,param2);
               this._requestedGraphics.push(_loc4_);
            }
         }
      }
      
      public function removeUnused() : void
      {
      }
      
      public function fromString(param1:String) : void
      {
      }
      
      public function toString() : String
      {
         return "";
      }
   }
}

