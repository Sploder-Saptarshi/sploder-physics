package
{
   import com.sploder.builder.Creator;
   import com.sploder.data.*;
   import com.sploder.game.sound.SoundManager;
   import flash.display.Loader;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageQuality;
   import flash.events.*;
   import flash.system.Security;
   
   public class CreatorMain extends Sprite
   {
      public static var mainStage:Stage;
      
      public static var global:Object;
      
      public static var preloader:CreatorPreloader;
      
      public static var dataLoader:DataLoader;
      
      protected static var _creator:Creator;
      
      protected static var _gameLoader:Loader;
      
      protected static var _testButton:SimpleButton;
      
      public static var mainInstance:CreatorMain;
      
      public static var debugmode:Boolean = true;
      
      protected static var _previewing:Boolean = false;
      
      protected static var firstTest:Boolean = true;
      
      public function CreatorMain(param1:Stage, param2:CreatorPreloader)
      {
         super();
         this.init(param1,param2);
      }
      
      public static function get creator() : Creator
      {
         return _creator;
      }
      
      public static function debug(param1:Object, param2:String, param3:String = "NOTICE") : void
      {
         if(debugmode)
         {
         }
      }
      
      public static function onCreatorInit(param1:Event) : void
      {
         preloader.done();
         mainStage.quality = StageQuality.HIGH;
      }
      
      protected function init(param1:Stage, param2:CreatorPreloader) : void
      {
         global = {};
         mainStage = param1;
         mainInstance = this;
         CreatorMain.preloader = param2;
         Security.loadPolicyFile("http://www.sploder.com/crossdomain.xml");
         Security.loadPolicyFile("http://sploder.s3.amazonaws.com/crossdomain.xml");
         dataLoader = new DataLoader(param1.root);
         CreatorMain.preloader.status = "Initializing Creator…";
         if(this.stage)
         {
            this.initializeData();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         }
      }
      
      protected function onAdded(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         this.initializeData();
      }
      
      protected function initializeData() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(CreatorPreloader.url.length > 0)
         {
            if(CreatorPreloader.url.indexOf("http://www.sploder.com/") === 0 || CreatorPreloader.url.indexOf("http://sploder.com/") === 0)
            {
               _loc2_ = true;
            }
            else if(CreatorPreloader.url.indexOf("file:///") === 0)
            {
               debug(this,"testing locally");
               _loc1_ = true;
               dataLoader.baseURL = SoundManager.baseURL = "https://sploder.xyz";
               _loc2_ = true;
            }
            else if(CreatorPreloader.url.indexOf("http://sploder.home") === 0 || CreatorPreloader.url.indexOf("http://192.168.") === 0)
            {
               dataLoader.baseURL = SoundManager.baseURL = "";
               _loc2_ = true;
            }
         }
         if(dataLoader.embedParameters.userid == null || dataLoader.embedParameters.userid == "demo")
         {
            User.u = 0;
            User.c = "0000000000";
            User.m = "temp";
         }
         else
         {
            User.u = parseInt(dataLoader.embedParameters.userid);
            User.c = String(dataLoader.embedParameters.creationdate);
         }
         preloader.status = "Initializing...";
         _loc2_ = true;
         if(_loc2_)
         {
            _creator = new Creator(this,this);
            _creator.local = _loc1_;
            _creator.addEventListener(Creator.INITIALIZED,onCreatorInit);
         }
         else
         {
            preloader.status = "Something is funky!";
         }
      }
   }
}

