package
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class Preloader extends MovieClip
   {
      public static var instance:Preloader;
      
      public static var mainInstance:DisplayObject;
      
      public static var url:String = "";
      
      public static var testing:Boolean = false;
      
      public static const GAME_LOADED:String = "game_loaded";
      
      public static const SFX_LOADED:String = "SFX_loaded";
      
      protected static var _SFXLoaded:Boolean = false;
      
      protected static var _gameLoaded:Boolean = false;
      
      protected var preloaderSWF:Class;
      
      protected var preloaderClip:Sprite;
      
      protected var statusText:TextField;
      
      protected var _placed:Boolean = false;
      
      protected var _started:Boolean = false;
      
      public var SFXClass:Class;
      
      public var loader:Loader;
      
      public function Preloader()
      {
         this.preloaderSWF = Preloader_preloaderSWF;
         super();
         _gameLoaded = _SFXLoaded = false;
         instance = this;
         this.init();
      }
      
      public static function get SFXLoaded() : Boolean
      {
         return _SFXLoaded;
      }
      
      public static function get gameLoaded() : Boolean
      {
         return _gameLoaded;
      }
      
      public static function restart() : void
      {
         if(mainInstance != null && instance.getChildIndex(mainInstance) != -1)
         {
            instance.show();
            instance.removeChild(mainInstance);
            instance.startup();
         }
      }
      
      protected function init() : void
      {
         Security.allowDomain("www.sploder.com");
         Security.allowDomain("sploder.com");
         Security.allowDomain("sploder.s3.amazonaws.com");
         Security.allowDomain("sploder.home");
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
      }
      
      public function onAdded(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         stage.showDefaultContextMenu = false;
         if(stage.loaderInfo != null && stage.loaderInfo.url != null)
         {
            url = stage.loaderInfo.url;
         }
         addEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progress);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.preloaderClip = new this.preloaderSWF() as Sprite;
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         if(!this._placed)
         {
            this.place();
         }
         this.statusText = this.preloaderClip["statusText"];
         addChild(this.preloaderClip);
      }
      
      protected function onLoadError(param1:IOErrorEvent) : void
      {
      }
      
      protected function progress(param1:ProgressEvent) : void
      {
         this.status = "Loading " + Math.ceil(root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal * 100) + "%";
         if(!this._placed)
         {
            this.place();
         }
         this.preloaderClip.visible = true;
      }
      
      protected function place() : void
      {
         var _loc1_:Number = Math.ceil((stage.stageWidth - this.preloaderClip.width) * 0.5);
         var _loc2_:Number = Math.ceil((stage.stageHeight - this.preloaderClip.height) * 0.5);
         if(!isNaN(_loc1_) && !isNaN(_loc2_))
         {
            this.preloaderClip.x = _loc1_;
            this.preloaderClip.y = _loc2_;
            this._placed = true;
         }
      }
      
      protected function checkFrame(param1:Event) : void
      {
         if(currentFrame == 2 && !this._started)
         {
            if(!_gameLoaded)
            {
               _gameLoaded = true;
               this.startup();
               dispatchEvent(new Event(GAME_LOADED));
            }
         }
         else if(currentFrame == 3)
         {
            if(!_SFXLoaded)
            {
               this.addSFX();
               _SFXLoaded = true;
               dispatchEvent(new Event(SFX_LOADED));
            }
            removeEventListener(Event.ENTER_FRAME,this.checkFrame);
            stop();
         }
      }
      
      public function startup() : void
      {
         stage.quality = StageQuality.HIGH;
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progress);
         if(loaderInfo.url.indexOf("testing") != -1)
         {
            testing = true;
         }
         this._started = true;
         this.addMain();
      }
      
      public function hide() : void
      {
         if(this.preloaderClip.parent != null)
         {
            this.preloaderClip.parent.removeChild(this.preloaderClip);
         }
      }
      
      public function show() : void
      {
         stage.quality = StageQuality.HIGH;
         if(this.preloaderClip.parent == null)
         {
            addChild(this.preloaderClip);
         }
      }
      
      public function set status(param1:String) : void
      {
         if(this.statusText)
         {
            this.statusText.text = param1;
         }
      }
      
      public function addMain() : void
      {
         var _loc1_:Class = null;
         if(loaderInfo != null && loaderInfo.applicationDomain.hasDefinition("Main"))
         {
            mainInstance = new Main(this) as DisplayObject;
         }
         else
         {
            mainInstance = new Main(this) as DisplayObject;
         }
      }
      
      protected function addSFX() : void
      {
         var _loc1_:Class = null;
         if(loaderInfo != null && loaderInfo.applicationDomain.hasDefinition("Sounds"))
         {
            _loc1_ = loaderInfo.applicationDomain.getDefinition("Sounds") as Class;
         }
         else
         {
            _loc1_ = getDefinitionByName("Sounds") as Class;
         }
         addChild(new _loc1_(this) as DisplayObject);
      }
      
      public function setSFXClass(param1:Class) : void
      {
         this.SFXClass = param1;
      }
      
      protected function onRemove(param1:Event) : void
      {
         if(mainInstance != null && mainInstance.parent != null)
         {
            mainInstance.parent.removeChild(mainInstance);
         }
         mainInstance = null;
      }
   }
}

