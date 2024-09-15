package
{
   import com.sploder.data.*;
   import com.sploder.game.Game;
   import com.sploder.game.sound.SoundManager;
   import com.sploder.texturegen_internal.TextureRendering;
   import com.sploder.texturegen_internal.util.ThreadedQueue;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.system.Security;
   
   public class Main extends MovieClip
   {
      public static var mainStage:Stage;
      
      public static var mainInstance:Main;
      
      public static var global:Object;
      
      public static var preloader:Preloader;
      
      public static var dataLoader:DataLoader;
      
      public static var debugmode:Boolean = true;
      
      public static var local:Boolean = false;
      
      public static var localContent:Boolean = false;
      
      protected var _game:Game;
      
      protected var _originalBaseURL:String = "";
      
      public function Main(param1:Preloader)
      {
         super();
         Main.preloader = param1;
         scaleX = scaleY = 1;
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
      }
      
      public static function debug(param1:Object, param2:String, param3:String = "NOTICE") : void
      {
         if(debugmode)
         {
         }
      }
      
      public function get game() : Game
      {
         return this._game;
      }
      
      public function set game(param1:Game) : void
      {
         this._game = param1;
      }
      
      protected function init(param1:Event = null) : void
      {
         global = {};
         mainStage = Game.mainStage = ThreadedQueue.mainStage = TextureRendering.mainStage = preloader.stage;
         mainInstance = this;
         dataLoader = new DataLoader(stage.root);
         SoundManager.generateSounds();
         Main.preloader.status = "Building game…";
         if(Preloader.testing)
         {
            Main.preloader.status = "Testing game…";
         }
         this.initializeData();
      }
      
      protected function initializeData() : void
      {
         var _loc2_:Loader = null;
         dataLoader.addEventListener(DataLoaderEvent.METADATA_ERROR,this.onDataError);
         if(Preloader.url.length > 0)
         {
            if(Preloader.url.indexOf("file://") != -1)
            {
               debug(this,"testing locally");
               if(!Preloader.testing)
               {
                  User.s = "d0018txl";
               }
               Security.allowDomain("*");
               dataLoader.baseURL = SoundManager.baseURL = "http://sploder.home/";
               User.s = "d001vwi7";
               local = true;
            }
            else if(Preloader.url.indexOf("http://sploder.home") != -1 || Preloader.url.indexOf("http://192.168.") != -1)
            {
               dataLoader.baseURL = SoundManager.baseURL = "http://" + Preloader.url.split("/")[2] + "/";
            }
            if(Preloader.url.indexOf("clearspring_widget") != -1)
            {
               dataLoader.baseURL = "http://www.sploder.com/";
               SoundManager.baseURL = "http://sploder.s3.amazonaws.com/";
            }
            this._originalBaseURL = dataLoader.baseURL;
         }
         var _loc1_:Object = dataLoader.embedParameters;
         if(User.u > 0)
         {
            dataLoader.metadata.u = User.u;
            dataLoader.metadata.c = User.c;
            dataLoader.metadata.m = User.m;
            this.onMetadataLoaded();
         }
         else if(Preloader.url.indexOf("clearspring") != -1)
         {
            User.s = Preloader.url.split("?s=")[1].split("&clear")[0];
            dataLoader.addEventListener(DataLoaderEvent.METADATA_LOADED,this.onMetadataLoaded);
            dataLoader.loadMetadata("http://www.sploder.com/php/getgameprops.php?pubkey=" + User.s,false);
         }
         else if(_loc1_.s != null || User.s != null)
         {
            if(_loc1_.s != undefined)
            {
               User.s = _loc1_.s;
            }
            dataLoader.addEventListener(DataLoaderEvent.METADATA_LOADED,this.onMetadataLoaded);
            dataLoader.loadMetadata("/php/getgameprops.php?pubkey=" + User.s);
         }
         else if(!Preloader.testing)
         {
            Preloader.instance.status = "Game not found.";
            _loc2_ = new Loader();
            addChild(_loc2_);
            _loc2_.load(new URLRequest("gamelinks.swf"));
         }
      }
      
      protected function onMetadataLoaded(param1:DataLoaderEvent = null) : void
      {
         dataLoader.removeEventListener(DataLoaderEvent.METADATA_LOADED,this.onMetadataLoaded);
         if(param1 != null)
         {
            User.parseUserData(param1.dataObject);
         }
         dataLoader.addEventListener(DataLoaderEvent.DATA_LOADED,this.onDataLoaded);
         if(User.a == "1")
         {
            dataLoader.baseURL = "http://sploder.s3.amazonaws.com/";
            dataLoader.loadXMLData(User.projectpath + "game.xml");
            dataLoader.addEventListener(DataLoaderEvent.DATA_ERROR,this.onDataArchiveError);
         }
         else
         {
            dataLoader.loadXMLData(User.projectpath + "game.xml");
            dataLoader.addEventListener(DataLoaderEvent.DATA_ERROR,this.onDataError);
         }
      }
      
      protected function onDataLoaded(param1:DataLoaderEvent = null) : void
      {
         dataLoader.baseURL = this._originalBaseURL;
         dataLoader.removeEventListener(DataLoaderEvent.DATA_LOADED,this.onDataLoaded);
         scaleX = scaleY = 1;
         this._game = new Game(this,param1.dataObject,this);
      }
      
      protected function onDataArchiveError(param1:DataLoaderEvent) : void
      {
         dataLoader.removeEventListener(DataLoaderEvent.DATA_ERROR,this.onDataArchiveError);
         dataLoader.baseURL = this._originalBaseURL;
         dataLoader.loadXMLData(User.projectpath + "game.xml");
         dataLoader.addEventListener(DataLoaderEvent.DATA_ERROR,this.onDataError);
      }
      
      protected function onDataError(param1:DataLoaderEvent) : void
      {
         dataLoader.removeEventListener(DataLoaderEvent.DATA_ERROR,this.onDataError);
         Main.preloader.status = "Error Loading Game";
      }
   }
}

