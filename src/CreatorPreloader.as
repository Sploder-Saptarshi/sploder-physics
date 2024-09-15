package
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class CreatorPreloader extends MovieClip
   {
      public static var instance:CreatorPreloader;
      
      public static var mainInstance:DisplayObject;
      
      public static var url:String = "";
      
      protected var preloaderSWF:Class;
      
      protected var preloaderClip:Sprite;
      
      protected var statusText:TextField;
      
      protected var _placed:Boolean = false;
      
      public function CreatorPreloader()
      {
         this.preloaderSWF = CreatorPreloader_preloaderSWF;
         super();
         instance = this;
         this.init();
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
         if(stage.loaderInfo != null && stage.loaderInfo.url != null)
         {
            url = stage.loaderInfo.url;
         }
         addEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progress);
         this.preloaderClip = new this.preloaderSWF() as Sprite;
         if(!this._placed)
         {
            this.place();
         }
         this.statusText = this.preloaderClip["statusText"];
         addChild(this.preloaderClip);
      }
      
      protected function progress(param1:ProgressEvent) : void
      {
         this.statusText.text = "Loading " + Math.ceil(root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal * 100) + "%";
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
         if(currentFrame == totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkFrame);
            if(root.loaderInfo.loaderURL.indexOf("http://www.sploder.com") == 0 || root.loaderInfo.loaderURL.indexOf("http://sploder.com") == 0 || root.loaderInfo.loaderURL.indexOf("http://sploder.s3.amazonaws.com") == 0 || root.loaderInfo.loaderURL.indexOf("http://sploder.home") == 0 || root.loaderInfo.loaderURL.indexOf("http://192.168.") == 0 || root.loaderInfo.loaderURL.indexOf("file://") == 0)
            {
               this.startup();
            }
            else
            {
               this.startup();
            }
         }
      }
      
      protected function startup() : void
      {
         stop();
         stage.quality = StageQuality.HIGH;
         if(stage.loaderInfo != null && stage.loaderInfo.url != null)
         {
            url = stage.loaderInfo.url;
         }
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progress);
         mainInstance = new CreatorMain(stage,this) as DisplayObject;
         addChild(mainInstance);
      }
      
      public function done() : void
      {
         if(this.preloaderClip != null && getChildIndex(this.preloaderClip) != -1)
         {
            removeChild(this.preloaderClip);
         }
         this.preloaderClip = null;
      }
      
      public function set status(param1:String) : void
      {
         this.statusText.text = param1;
      }
   }
}

