package com.sploder.asui
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.LoaderContext;
   
   public class Clip extends Component
   {
      public static const SCALEMODE_NOSCALE:int = 1;
      
      public static const SCALEMODE_CENTER:int = 2;
      
      public static const SCALEMODE_FILL:int = 3;
      
      public static const SCALEMODE_FIT:int = 4;
      
      public static const SCALEMODE_STRETCH:int = 5;
      
      public static const EMBED_REMOTE:int = 1;
      
      public static const EMBED_LOCAL:int = 2;
      
      public static const EMBED_SMART:int = 3;
      
      public static var baseURL:String = "";
      
      public static var clipsLoading:int = 0;
      
      private var _scaleMode:Number = 1;
      
      private var _url:String = "";
      
      private var _linkURL:String = "";
      
      private var _newWindow:Boolean = false;
      
      private var _alt:String = "";
      
      public var showAltImmediate:Boolean = false;
      
      private var _embedded:Boolean = false;
      
      private var _loaderclip:Sprite;
      
      private var _request:URLRequest;
      
      private var _loader:Loader;
      
      private var _btn:Sprite;
      
      private var _clickable:Boolean = false;
      
      private var _loading:Boolean = false;
      
      private var _loaded:Boolean = false;
      
      private var _debugmode:Boolean = false;
      
      public var forceCentered:Boolean = false;
      
      public var forceBorder:Boolean = false;
      
      public function Clip(param1:Sprite, param2:String, param3:int = 3, param4:Number = NaN, param5:Number = NaN, param6:Number = 1, param7:String = "", param8:Boolean = false, param9:String = "", param10:Position = null, param11:Style = null)
      {
         super();
         this.init_Clip(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get alt() : String
      {
         return this._alt;
      }
      
      public function set alt(param1:String) : void
      {
         this._alt = param1;
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      public function get loadedClip() : Sprite
      {
         return this._loaderclip;
      }
      
      public function get embedded() : Boolean
      {
         return this._embedded;
      }
      
      public function set underClipMouseEnabled(param1:Boolean) : void
      {
         super.mouseEnabled = param1;
         _mc.mouseEnabled = _mc.mouseChildren = true;
         if(this._loaderclip)
         {
            this._loaderclip.mouseEnabled = this._loaderclip.mouseChildren = true;
         }
         if(this._btn)
         {
            this._btn.visible = false;
         }
      }
      
      protected function init_Clip(param1:Sprite, param2:String, param3:int, param4:Number, param5:Number, param6:Number, param7:String, param8:Boolean, param9:String, param10:Position, param11:Style) : void
      {
         super.init(param1,param10,param11);
         _type = "clip";
         this._url = param2;
         if(param3 == EMBED_SMART)
         {
            this._embedded = param2.indexOf("/") == -1;
         }
         else
         {
            this._embedded = param3 == EMBED_LOCAL;
         }
         _width = param4;
         _height = param5;
         this._scaleMode = !isNaN(param6) && _width > 0 && _height > 0 ? param6 : SCALEMODE_NOSCALE;
         this._linkURL = param7.length > 0 ? param7 : "";
         this._newWindow = param8 == true;
         if(param9.length > 0)
         {
            this._alt = param9;
         }
      }
      
      override public function create() : void
      {
         super.create();
         if(this._url != null && this._url.length > 0)
         {
            this._loaderclip = new Sprite();
            _mc.addChild(this._loaderclip);
            if(!this._embedded)
            {
               this.load();
            }
            else
            {
               this.embed();
            }
         }
      }
      
      private function rollover(param1:Event) : void
      {
         if(this._alt.length > 0)
         {
            Tagtip.showTag(this._alt,this.showAltImmediate);
         }
      }
      
      private function rollout(param1:Event) : void
      {
         Tagtip.hideTag();
      }
      
      private function load() : void
      {
         var _loc1_:LoaderContext = null;
         if(!this._loading && !this._loaded)
         {
            ++clipsLoading;
            if(baseURL.length > 0 && baseURL.charAt(baseURL.length - 1) != "/")
            {
               baseURL += "/";
            }
            this._request = new URLRequest(baseURL + this._url);
            this._loader = new Loader();
            this._loaderclip.addChild(this._loader);
            this.configureListeners(this._loader.contentLoaderInfo);
            _loc1_ = new LoaderContext();
            _loc1_.checkPolicyFile = true;
            this._loader.load(this._request,_loc1_);
            this._loading = true;
         }
      }
      
      private function configureListeners(param1:IEventDispatcher) : void
      {
         param1.addEventListener(Event.COMPLETE,this.completeHandler);
         param1.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
         param1.addEventListener(Event.INIT,this.initHandler);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         param1.addEventListener(Event.OPEN,this.openHandler);
         param1.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         param1.addEventListener(Event.UNLOAD,this.unLoadHandler);
      }
      
      protected function embed() : void
      {
         var _loc1_:DisplayObject = null;
         if(library == null)
         {
            throw new Error("Register a library with Component in order to embed clips!");
         }
         _loc1_ = library.getDisplayObject(this._url);
         this._loaderclip.addChild(_loc1_);
         if(isNaN(_width) || _width == 0)
         {
            _width = _loc1_.width;
         }
         if(isNaN(_height) || _height == 0)
         {
            _height = _loc1_.height;
         }
         this.initHandler(_loc1_);
      }
      
      private function completeHandler(param1:Event) : void
      {
         --clipsLoading;
         this._loading = false;
         this._loaded = true;
      }
      
      private function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      private function openHandler(param1:Event) : void
      {
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
      }
      
      private function unLoadHandler(param1:Event) : void
      {
      }
      
      private function initHandler(param1:Object) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc6_:Sprite = null;
         var _loc7_:Sprite = null;
         if(param1 is Event)
         {
            _loc2_ = LoaderInfo(param1.target).loader as DisplayObject;
         }
         else
         {
            if(!(param1 is DisplayObject))
            {
               return;
            }
            _loc2_ = param1 as DisplayObject;
         }
         if(_loc2_.width == 0)
         {
            return;
         }
         this._btn = new Sprite();
         _mc.addChild(this._btn);
         DrawingMethods.rect(this._btn,false,0,0,_width,_height,0,0.2);
         this._btn.alpha = 0;
         connectButton(this._btn,false);
         if(this._alt.length > 0)
         {
            addEventListener(EVENT_M_OVER,this.rollover);
            addEventListener(EVENT_M_OUT,this.rollout);
         }
         if(this._linkURL.length == 0)
         {
            this._btn.useHandCursor = false;
         }
         var _loc3_:Number = _loc2_.width / _loc2_.height;
         var _loc4_:Number = _width / _height;
         if(_loc2_ is Loader)
         {
            if(Loader(_loc2_).content is Bitmap)
            {
               Bitmap(Loader(_loc2_).content).smoothing = true;
            }
         }
         switch(this._scaleMode)
         {
            case SCALEMODE_NOSCALE:
               break;
            case SCALEMODE_FILL:
               if(_loc3_ > _loc4_)
               {
                  _loc2_.height = _height;
                  _loc2_.width = _loc2_.height * _loc3_;
               }
               else
               {
                  _loc2_.width = width;
                  _loc2_.height = _loc2_.width / _loc3_;
               }
               break;
            case SCALEMODE_FIT:
               if(_loc3_ < _loc4_)
               {
                  _loc2_.height = _height;
                  _loc2_.width = _loc2_.height * _loc3_;
               }
               else
               {
                  _loc2_.width = width;
                  _loc2_.height = _loc2_.width / _loc3_;
               }
            case SCALEMODE_CENTER:
               if(_loc2_.width > 0 && _loc2_.width < _width)
               {
                  _loc2_.x = Math.floor((_width - _loc2_.width) * 0.5);
               }
               if(_loc2_.height > 0 && _loc2_.height < _height)
               {
                  _loc2_.y = Math.floor((_height - _loc2_.height) * 0.5);
               }
               break;
            case SCALEMODE_STRETCH:
               _loc2_.width = _width;
               _loc2_.height = _height;
         }
         if(this._scaleMode == SCALEMODE_FILL)
         {
            _loc6_ = new Sprite();
            _mc.addChild(_loc6_);
            DrawingMethods.rect(_loc6_,false,0,0,_width,_height,_style.backgroundColor,0);
            _loc2_.mask = _loc6_;
         }
         var _loc5_:Rectangle = _loc2_.getRect(_mc);
         if(this.forceCentered)
         {
            _loc5_ = _loc2_.getRect(_mc);
            _loc2_.x = (0 - _loc2_.width) * 0.5 - _loc5_.x;
            _loc2_.y = (0 - _loc2_.height) * 0.5 - _loc5_.y;
         }
         if(this.forceBorder)
         {
            _loc7_ = new Sprite();
            _mc.addChild(_loc7_);
            _loc5_ = _loc2_.getRect(_mc);
            DrawingMethods.emptyRect(_loc7_,false,_loc5_.x,_loc5_.y,_loc5_.width,_loc5_.height,2,_style.borderColor,1);
         }
      }
      
      override protected function onClick(param1:MouseEvent = null) : void
      {
         if(this._linkURL.indexOf("event:") == 0)
         {
            if(form != null && name != null && name.length > 0)
            {
               form[name] = value;
            }
         }
         else
         {
            this.launchURL(param1);
         }
         super.onClick(param1);
      }
      
      protected function launchURL(param1:Event = null) : void
      {
         var _loc2_:URLRequest = null;
         if(this._linkURL.length)
         {
            _loc2_ = new URLRequest(this._linkURL);
            if(this._newWindow)
            {
               navigateToURL(_loc2_,"_blank");
            }
            else
            {
               navigateToURL(_loc2_);
            }
         }
      }
      
      protected function debug(param1:String) : void
      {
         if(this._debugmode)
         {
         }
      }
   }
}

