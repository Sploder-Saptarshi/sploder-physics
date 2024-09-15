package com.sploder.builder
{
   import com.adobe.images.PNGEncoder;
   import com.sploder.builder.model.Environment;
   import com.sploder.builder.ui.DialogueFileManager;
   import com.sploder.data.User;
   import com.sploder.game.Simulation;
   import com.sploder.game.sound.SoundManager;
   import com.sploder.util.Base64;
   import com.sploder.util.Cleanser;
   import com.sploder.util.Settings;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class CreatorProject extends EventDispatcher
   {
      public static const EVENT_LOAD:String = "load";
      
      public static const EVENT_SAVE:String = "save";
      
      public static const EVENT_NEW:String = "new";
      
      public static const EVENT_TEST:String = "test";
      
      protected var _creator:Creator;
      
      protected var _xml:XMLDocument;
      
      protected var _sharedObjectName:String = "creator5temp";
      
      public var previewWidth:Number = 480;
      
      public var previewHeight:Number = 360;
      
      public var isprivate:Boolean = false;
      
      public var comments:Boolean = true;
      
      public var turbo:Boolean = false;
      
      public var allowcopying:Boolean = false;
      
      public var pubkey:String;
      
      public var title:String;
      
      public var author:String;
      
      public var projID:String;
      
      public var pubDate:Date;
      
      public var saved:Boolean = false;
      
      protected var _version:int = 5;
      
      public var gameXML:XMLDocument;
      
      protected var _newXMLString:String = "<project title=\"\"><levels id=\"levels\"><level></level></levels><graphics></graphics></project>";
      
      protected var _prevXMLString:String = "";
      
      protected var _saveURL:String = "";
      
      protected var _saveParams:String = "";
      
      protected var _publishURL:String = "";
      
      protected var _projectVars:URLVariables;
      
      protected var _projectRequest:URLRequest;
      
      protected var _projectSaver:URLLoader;
      
      protected var _gameVars:URLVariables;
      
      protected var _gameRequest:URLRequest;
      
      protected var _gameSaver:URLLoader;
      
      protected var _savingAs:Boolean = false;
      
      protected var _bigThumb:ByteArray;
      
      protected var _smallThumb:ByteArray;
      
      protected var _bigThumbRequest:URLRequest;
      
      protected var _smallThumbRequest:URLRequest;
      
      protected var _bigThumbSaver:URLLoader;
      
      protected var _smallThumbSaver:URLLoader;
      
      protected var _getProjectURL:String = "/php/getproject.php";
      
      protected var _thumbPostURL:String = "/php/savethumb.php";
      
      protected var _localSaveTimer:Timer;
      
      protected var _transferring:Boolean = false;
      
      public function CreatorProject(param1:Creator, param2:String, param3:String = "", param4:String = "")
      {
         super();
         this.init(param1,param2,param3,param4);
      }
      
      public function get xml() : XMLDocument
      {
         return this._xml;
      }
      
      public function set xml(param1:XMLDocument) : void
      {
         this._xml = param1;
      }
      
      public function get sharedObjectName() : String
      {
         return this._sharedObjectName;
      }
      
      public function get version() : int
      {
         return this._version;
      }
      
      public function get savingAs() : Boolean
      {
         return this._savingAs;
      }
      
      public function set savingAs(param1:Boolean) : void
      {
         this._savingAs = param1;
      }
      
      protected function init(param1:Creator, param2:String, param3:String = "", param4:String = "") : void
      {
         this._creator = param1;
         this._saveURL = param2;
         this._saveParams = param3;
         this._publishURL = param4;
         this._sharedObjectName = "creator" + Creator.GAME_VERSION + "temp";
         this._localSaveTimer = new Timer(10000,0);
         this._localSaveTimer.addEventListener(TimerEvent.TIMER,this.saveLocalProject);
         this._localSaveTimer.start();
         this._xml = new XMLDocument(this._newXMLString);
      }
      
      public function onManagerConfirm(param1:Event) : void
      {
         if(this._creator.ui.ddManager.mode == DialogueFileManager.MODE_LOAD)
         {
            this.loadProject();
         }
         else if(this._creator.ui.ddManager.mode == DialogueFileManager.MODE_SAVE)
         {
            this.saveProject();
         }
      }
      
      public function getObjects(param1:uint = 0) : String
      {
         var _loc2_:XMLNode = null;
         if(this._xml != null && this._xml.idMap["levels"] != null)
         {
            if(this._xml.idMap["levels"].childNodes.length > param1)
            {
               _loc2_ = this._xml.idMap["levels"].childNodes[param1];
               return _loc2_.firstChild.nodeValue;
            }
         }
         else if(this._xml != null && this._xml.firstChild.firstChild != null)
         {
            if(this._xml.firstChild.firstChild.childNodes.length > param1)
            {
               _loc2_ = this._xml.firstChild.firstChild.childNodes[param1];
               return _loc2_.firstChild.nodeValue;
            }
         }
         return "";
      }
      
      public function getEnvironment(param1:uint = 0) : String
      {
         var _loc2_:XMLNode = null;
         if(this._xml != null && this._xml.idMap["levels"] != null)
         {
            if(this._xml.idMap["levels"].childNodes.length > param1)
            {
               _loc2_ = this._xml.idMap["levels"].childNodes[param1];
               if(_loc2_ != null && _loc2_.attributes["env"] != null)
               {
                  return _loc2_.attributes["env"];
               }
            }
         }
         else if(this._xml != null && this._xml.firstChild.firstChild != null)
         {
            if(this._xml.firstChild.firstChild.childNodes.length > param1)
            {
               _loc2_ = this._xml.firstChild.firstChild.childNodes[param1];
               if(_loc2_ != null && _loc2_.attributes["env"] != null)
               {
                  return _loc2_.attributes["env"];
               }
            }
         }
         return "";
      }
      
      public function getTotalLevels() : uint
      {
         if(this._xml != null && this._xml.idMap["levels"] != null)
         {
            return this._xml.idMap["levels"].childNodes.length;
         }
         if(this._xml != null && this._xml.firstChild.firstChild != null)
         {
            return this._xml.firstChild.firstChild.childNodes.length;
         }
         return 0;
      }
      
      public function newDocument() : void
      {
         this._xml = new XMLDocument(this._newXMLString);
         this.pubkey = this.projID = null;
         this.title = "";
         this.comments = true;
         this.isprivate = false;
         this.turbo = false;
         this.allowcopying = false;
         this._version = 5;
         this.clearLocalProject();
      }
      
      public function buildDocument(param1:Boolean = false, param2:Boolean = false) : void
      {
         var levelsNodes:String;
         var template:String;
         var i:int = 0;
         var graphics:Object = null;
         var graphicsNodes:String = null;
         var name:String = null;
         var newGraphicsNode:String = null;
         var png:ByteArray = null;
         var bString:String = null;
         var currentLevelOnly:Boolean = param1;
         var addGraphics:Boolean = param2;
         if(this._xml == null)
         {
            this.newDocument();
         }
         this._creator.levels.saveCurrentLevel();
         this._creator.levels.saveCurrentEnvironment();
         levelsNodes = "";
         if(!currentLevelOnly)
         {
            i = 0;
            while(i < this._creator.levels.totalLevels)
            {
               levelsNodes += "<level env=\"" + this._creator.levels.exportEnvironmentData(i) + "\">" + this._creator.levels.exportLevelData(i) + "</level>";
               i++;
            }
         }
         else
         {
            levelsNodes += "<level env=\"" + this._creator.levels.exportEnvironmentData(this._creator.levels.currentLevel) + "\">" + this._creator.levels.exportLevelData(this._creator.levels.currentLevel) + "</level>";
         }
         template = this._newXMLString;
         template = template.split("<level></level>").join(levelsNodes);
         if(addGraphics)
         {
            graphics = this._creator.levels.exportGraphics();
            graphicsNodes = "";
            for(name in graphics)
            {
               newGraphicsNode = "";
               try
               {
                  if(graphics[name] is BitmapData && BitmapData(graphics[name]).width > 0 && BitmapData(graphics[name]).height > 0)
                  {
                     png = PNGEncoder.encode(BitmapData(graphics[name]));
                     if(png is ByteArray)
                     {
                        bString = Base64.encodeByteArray(png);
                        newGraphicsNode = "<graphic name=\"" + name + "\">" + bString + "</graphic>";
                     }
                  }
               }
               catch(e:Error)
               {
                  if(e.errorID == 2015)
                  {
                     newGraphicsNode = "";
                  }
               }
               graphicsNodes += newGraphicsNode;
            }
            template = template.split("<graphics></graphics>").join("<graphics>" + graphicsNodes + "</graphics>");
         }
         this._xml = new XMLDocument(template);
         if(this.projID != null && this.projID.length > 0)
         {
            this._xml.firstChild.attributes.id = this.projID;
         }
         this._xml.firstChild.attributes.pubkey = this.pubkey;
         this._xml.firstChild.attributes.title = escape(this.title);
         if(this.author != null && this.author.length > 0)
         {
            this._xml.firstChild.attributes.author = this.author;
         }
         else
         {
            this._xml.firstChild.attributes.author = "demo";
         }
         this._xml.firstChild.attributes.mode = this._creator.gameMode;
         this._xml.firstChild.attributes.date = this._creator.today;
         this._xml.firstChild.attributes.comments = this.comments ? "1" : "0";
         this._xml.firstChild.attributes.isprivate = this.isprivate ? "1" : "0";
         this._xml.firstChild.attributes.turbo = this.turbo ? "1" : "0";
         this._xml.firstChild.attributes.allowcopying = this.allowcopying ? "1" : "0";
      }
      
      public function buildProject() : void
      {
         this._creator.ui.ddServer.hide();
         this._version = 5;
         if(this._xml.firstChild.attributes.id != undefined)
         {
            this.projID = this._xml.firstChild.attributes.id;
         }
         else
         {
            this.projID = "";
         }
         if(this._xml.firstChild.attributes.title != undefined)
         {
            this.title = unescape(this._xml.firstChild.attributes.title);
         }
         else
         {
            this.title = "";
         }
         if(this._xml.firstChild.attributes.mode != undefined)
         {
            this._creator.setGameMode(parseInt(this._xml.firstChild.attributes.mode));
         }
         else
         {
            this._creator.setGameMode(5);
         }
         this.turbo = this._xml.firstChild.attributes.turbo == "1";
         this.comments = this._xml.firstChild.attributes.comments != "0";
         this.isprivate = this._xml.firstChild.attributes.isprivate == "1";
         this.allowcopying = this._xml.firstChild.attributes.allowcopying == "1";
         this.extractGraphicsFromXMLDocument();
      }
      
      protected function extractGraphicsFromXMLDocument() : void
      {
         var _loc1_:XMLNode = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:ByteArray = null;
         var _loc6_:Loader = null;
         this._creator.graphics.clean();
         if(this._xml && this._xml.firstChild && this._xml.firstChild.firstChild && Boolean(this._xml.firstChild.firstChild.nextSibling))
         {
            _loc1_ = this._xml.firstChild.firstChild.nextSibling;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.childNodes.length)
            {
               _loc3_ = XMLNode(_loc1_.childNodes[_loc2_]).attributes.name;
               if(Boolean(_loc3_) && !Textures.isLoaded(_loc3_))
               {
                  _loc4_ = XMLNode(_loc1_.childNodes[_loc2_]).firstChild.nodeValue;
                  if(_loc4_)
                  {
                     _loc5_ = Base64.decodeToByteArray(_loc4_);
                     if(_loc5_)
                     {
                        (_loc6_ = new Loader()).name = _loc3_;
                        _loc6_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onGraphicExtracted);
                        _loc6_.loadBytes(_loc5_);
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      protected function onGraphicExtracted(param1:Event) : void
      {
         var _loc2_:Loader = null;
         if(param1.target is LoaderInfo)
         {
            _loc2_ = LoaderInfo(param1.target).loader;
            if(_loc2_.content is Bitmap)
            {
               Textures.addBitmapDataToCache(_loc2_.name,Bitmap(_loc2_.content).bitmapData);
            }
         }
      }
      
      public function getProject(param1:uint) : void
      {
         this._creator.ui.ddServer.alert("Loading Project...");
         this._transferring = true;
         CreatorMain.dataLoader.loadXMLData(this._getProjectURL + CreatorMain.dataLoader.getCacheString("u=" + User.u + "&c=" + User.c + "&p=" + param1),true,this.onProjectLoaded,this.onProjectLoadError);
      }
      
      public function onProjectLoaded(param1:Event) : void
      {
         this._xml = new XMLDocument();
         this._xml.ignoreWhite = true;
         this._xml.parseXML(param1.target.data);
         this._transferring = false;
         this._creator.ui.ddServer.hide();
         this.buildProject();
         this.clearLocalProject();
         dispatchEvent(new Event(EVENT_LOAD));
      }
      
      public function onProjectLoadError(param1:IOErrorEvent) : void
      {
         this._transferring = false;
         this._creator.ui.ddServer.hide();
         this._creator.uiController.alert("Unable to load project.  There was a problem loading it from the server");
      }
      
      public function newProject() : void
      {
         this._creator.graphics.clean();
         this.newDocument();
         this.pubkey = "";
         this._creator.ui.ddManager.currentProjectID = null;
         this._creator.ui.ddManager.currentProjectTitle = "";
         this.projID = "";
         dispatchEvent(new Event(EVENT_NEW));
         this._transferring = false;
      }
      
      public function saveLocalProject(param1:TimerEvent = null) : void
      {
         var _loc2_:String = null;
         if(!this._transferring && !this._creator.model.populating && this._creator.model.objects.length > 0)
         {
            this.buildDocument(false,true);
            _loc2_ = this._xml.toString();
            if(_loc2_ != this._prevXMLString)
            {
               Settings.saveSetting(this._sharedObjectName,_loc2_);
               this._prevXMLString = _loc2_;
            }
         }
      }
      
      public function get hasLocalProject() : Boolean
      {
         return Settings.loadSetting(this._sharedObjectName) != null && String(Settings.loadSetting(this._sharedObjectName)).length > 0;
      }
      
      public function confirmLoadLocalProject() : void
      {
         this._creator.uiController.confirm(this,this.loadLocalProject,null,"Your project was saved in memory.  Click OK to restore it.");
      }
      
      public function loadLocalProject(param1:Event = null) : void
      {
         if(this.hasLocalProject)
         {
            this._prevXMLString = Settings.loadSetting(this._sharedObjectName) as String;
            this._xml = new XMLDocument(this._prevXMLString);
            this.buildProject();
            dispatchEvent(new Event(EVENT_LOAD));
         }
      }
      
      public function clearLocalProject() : void
      {
         Settings.saveSetting(this._sharedObjectName,"");
         this._prevXMLString = this._xml.toString();
      }
      
      public function testProject(param1:Event = null, param2:Boolean = false) : void
      {
         this.buildDocument(param2);
         User["data"] = "";
         User["data"] = this._xml.toString();
         this._creator.test();
         dispatchEvent(new Event(EVENT_TEST));
      }
      
      public function loadProject() : void
      {
         this.getProject(parseInt(this._creator.ui.ddManager.currentProjectID.split("proj").join("")));
      }
      
      public function saveProject() : void
      {
         if(this._creator.model.objects.length > 0 && !this._creator.demo)
         {
            if(this._xml && this._creator.ui.ddManager.currentProjectID != null && this._creator.ui.ddManager.currentProjectID.length > 0 && this._creator.ui.ddManager.currentProjectID != this._xml.firstChild.attributes.id && this._creator.ui.ddManager.currentProjectTitle != null && this._creator.ui.ddManager.currentProjectTitle.length > 0)
            {
               this.projID = this._creator.ui.ddManager.currentProjectID;
               this.title = Cleanser.cleanse(this._creator.ui.ddManager.currentProjectTitle);
               if(this.title.length == 0)
               {
                  this.title = "My New Game";
               }
               this.saveConfirm();
            }
            else if(this._xml && this._xml.firstChild.attributes.id != undefined && !this._savingAs)
            {
               this.projID = this._xml.firstChild.attributes.id;
               this.title = unescape(this._xml.firstChild.attributes.title);
               this.saveProjectData();
            }
            else if(this._xml && this._creator.ui.ddManager.currentProjectTitle != null && this._creator.ui.ddManager.currentProjectTitle.length > 0 && this._creator.ui.ddManager.currentProjectTitle.indexOf("...") == -1)
            {
               this.projID = "";
               this._creator.ui.ddManager.currentProjectID = "";
               delete this._xml.firstChild.attributes.id;
               this.title = Cleanser.cleanse(this._creator.ui.ddManager.currentProjectTitle);
               if(this.title.length == 0)
               {
                  this.title = "My New Game";
               }
               this.saveProjectData();
            }
            else
            {
               this.saveProjectAs();
            }
         }
      }
      
      public function saveProjectAs() : void
      {
         if(this._creator.model.objects.length > 0 && !this._creator.demo)
         {
            this._creator.ui.ddManager.title = "Save Your Game";
            if(this._xml)
            {
               this._creator.ui.ddManager.currentProjectID = this._xml.firstChild.attributes.id;
               this._creator.ui.ddManager.currentProjectTitle = unescape(this._xml.firstChild.attributes.title);
            }
            else
            {
               this._creator.ui.ddManager.currentProjectID = "";
               this._creator.ui.ddManager.currentProjectTitle = "";
            }
            this._creator.ui.ddManager.mode = DialogueFileManager.MODE_SAVE;
            this._creator.ui.ddManager.loadList();
         }
      }
      
      public function saveConfirm(param1:Boolean = false) : void
      {
         this._creator.uiController.confirm(this,this.overwriteProjectData,null,"Saving this project will overwrite your previous project.");
      }
      
      protected function overwriteProjectData(param1:Event = null) : void
      {
         if(this.projID != null && this.projID.length > 0 && this.title != null && this.title.length > 0)
         {
            this._xml.firstChild.attributes.id = this.projID;
            this.saveProjectData();
         }
      }
      
      public function saveProjectData() : void
      {
         this._creator.ui.ddServer.alert("Saving Game Project...");
         CreatorMain.mainStage.invalidate();
         this.buildDocument(false,true);
         this._projectVars = new URLVariables();
         if(this._xml.firstChild.attributes.id == undefined || this._xml.firstChild.attributes.id.length < 3)
         {
            this._xml.firstChild.attributes.id = "noid-unsaved-project";
            this._projectRequest = new URLRequest(CreatorMain.dataLoader.baseURL + this._saveURL + CreatorMain.dataLoader.getCacheString(this._saveParams));
         }
         else
         {
            this._projectRequest = new URLRequest(CreatorMain.dataLoader.baseURL + this._saveURL + CreatorMain.dataLoader.getCacheString(this._saveParams + "&projid=" + this._xml.firstChild.attributes.id));
         }
         this._xml.firstChild.attributes.title = escape(unescape(unescape(this._xml.firstChild.attributes.title)));
         this._projectVars.xml = this._xml.toString();
         this._projectRequest.method = URLRequestMethod.POST;
         this._projectRequest.data = this._projectVars;
         this._projectSaver = new URLLoader();
         this._projectSaver.addEventListener(Event.COMPLETE,this.saveResult);
         this._projectSaver.addEventListener(IOErrorEvent.IO_ERROR,this.onSaveError);
         this._projectSaver.load(this._projectRequest);
         this._transferring = true;
      }
      
      public function onSaveError(param1:Event) : void
      {
         this._projectSaver.removeEventListener(Event.COMPLETE,this.saveResult);
         this._projectSaver.removeEventListener(IOErrorEvent.IO_ERROR,this.onSaveError);
         this._creator.uiController.alert("There was an error saving your project. It has been saved to memory.  Please try again later.");
         this._transferring = false;
         this.saveLocalProject();
      }
      
      public function saveResult(param1:Event) : void
      {
         var result:XML = null;
         var newID:String = null;
         var e:Event = param1;
         this._projectSaver.removeEventListener(Event.COMPLETE,this.saveResult);
         this._projectSaver.removeEventListener(IOErrorEvent.IO_ERROR,CreatorMain.dataLoader.onXMLDataError);
         try
         {
            result = new XML(e.target.data);
         }
         catch(err:Error)
         {
            _creator.ui.ddServer.alert("There was a problem saving your project.");
            _creator.uiController.notice(e.target.data);
            return;
         }
         this._creator.ui.ddServer.hide();
         if(result.@result == "success")
         {
            newID = result.@id;
            if(newID != null && newID.length > 0)
            {
               this.projID = this._xml.firstChild.attributes.id = newID;
            }
            this.generateThumbnails();
            this.saveThumbnails();
            if(this.pubkey != null && this.pubkey.length > 0)
            {
               this._creator.uiController.alert("Your game was successfully saved.");
            }
            else
            {
               this._creator.uiController.alert("Your game was successfully saved.  When you are done, don\'t forget to publish!");
            }
            this.clearLocalProject();
         }
         else
         {
            this._creator.uiController.alert("Sorry! save failed. Please try again in a few seconds.");
            this._creator.uiController.notice(result.@message);
            delete this._xml.firstChild.attributes.id;
         }
         if(this._xml.firstChild.attributes.id == "noid_unsaved_project")
         {
            delete this._xml.firstChild.attributes.id;
         }
         this._transferring = false;
      }
      
      public function publishGame() : void
      {
         if(this._creator.model.objects.length > 0 && !this._creator.demo && this._xml.firstChild.attributes.id != "noid-unsaved-project" && this._xml.firstChild.attributes.id != undefined)
         {
            this._creator.ui.ddPublish.show();
         }
         else if(this._creator.demo)
         {
            this.saveLocalProject();
            this._creator.uiController.alert(CreatorUIStates.MESSAGE_GAME_DEMO);
         }
         else if(this._xml.firstChild.attributes.id == "noid-unsaved-project" || this._xml.firstChild.attributes.id == undefined)
         {
            this._creator.uiController.alert("You must save your project before you publish it. Click \'Save\' to save your work.");
         }
         else if(this._creator.model.objects.length < 1)
         {
            this._creator.uiController.alert("You must have objects on the playfield to publish your game.  Drag some objects onto the playfield.");
         }
      }
      
      public function publishProject() : void
      {
         this.buildDocument(false,true);
         this.gameXML = new XMLDocument(this._xml.toString());
         this._gameVars = new URLVariables();
         if(this._xml.firstChild.attributes.id == undefined || this._xml.firstChild.attributes.id.length < 3)
         {
            this._gameRequest = new URLRequest(CreatorMain.dataLoader.baseURL + this._publishURL + CreatorMain.dataLoader.getCacheString("projid=temp"));
         }
         else
         {
            this._gameRequest = new URLRequest(CreatorMain.dataLoader.baseURL + this._publishURL + CreatorMain.dataLoader.getCacheString("projid=" + this._xml.firstChild.attributes.id + "&comments=" + (this.comments ? "1" : "0") + "&private=" + (this.isprivate ? "1" : "0")));
         }
         this._gameVars.xml = this.gameXML.toString();
         this._creator.ui.ddServer.alert("Publishing Game ...");
         this._gameRequest.method = URLRequestMethod.POST;
         this._gameRequest.data = this._gameVars;
         this._gameSaver = new URLLoader();
         this._gameSaver.addEventListener(Event.COMPLETE,this.publishResult);
         this._gameSaver.addEventListener(IOErrorEvent.IO_ERROR,CreatorMain.dataLoader.onXMLDataError);
         this._gameSaver.load(this._gameRequest);
         this._transferring = true;
      }
      
      public function publishResult(param1:Event) : void
      {
         var result:XML = null;
         var e:Event = param1;
         this._gameSaver.removeEventListener(Event.COMPLETE,this.publishResult);
         this._gameSaver.removeEventListener(IOErrorEvent.IO_ERROR,CreatorMain.dataLoader.onXMLDataError);
         try
         {
            result = new XML(e.target.data);
         }
         catch(err:Error)
         {
            _creator.ui.ddServer.alert("There was a problem publishing your game.");
            _creator.uiController.notice(e.target.data);
            return;
         }
         this._creator.ui.ddServer.hide();
         if(result.@result == "success")
         {
            this.pubkey = result.@pubkey;
            this._creator.ui.ddPublishComplete.alert("Playing published game.  If you are blocking pop-ups, click \'PLAY AGAIN\'.");
            navigateToURL(new URLRequest("javascript: playPubMovie(\'" + this.pubkey + "\',480);"),"_self");
         }
         else
         {
            this._creator.uiController.alert("Sorry! Publish failed. Please try again in a few seconds.");
            this._creator.uiController.notice(result.@message);
         }
         this._transferring = false;
      }
      
      public function playPubMovie(param1:MouseEvent = null) : void
      {
         if(this.pubkey != null && this.pubkey.length > 0)
         {
            navigateToURL(new URLRequest("javascript: playPubMovie(\'" + this.pubkey + "\',480);"),"_self");
         }
      }
      
      public function generateThumbnails() : void
      {
         var _loc1_:Sprite = new Sprite();
         CreatorMain.mainStage.addChild(_loc1_);
         var _loc2_:int = int(this._creator.environment.size);
         if(this._creator.environment.size == Environment.SIZE_FOLLOW)
         {
            this._creator.environment.size = Environment.SIZE_DOUBLE;
         }
         CreatorMain.mainStage.quality = StageQuality.BEST;
         SoundManager.hasSound = false;
         var _loc3_:Simulation = new Simulation(_loc1_,this._creator.model,this._creator.environment,false);
         _loc3_.build();
         _loc3_.start();
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            _loc3_.stepDouble();
            _loc4_++;
         }
         var _loc5_:MovieClip = CreatorUI.library.getDisplayObject(CreatorUIStates.ICON_NUMLEVELS) as MovieClip;
         _loc5_.gotoAndStop(this._creator.levels.totalLevels);
         var _loc6_:BitmapData = new BitmapData(220,220,false,0);
         var _loc7_:Matrix = new Matrix();
         _loc7_.createBox(220 / 640,220 / 640,0,0,80 * (220 / 640));
         _loc6_.draw(_loc1_,_loc7_,null,null,null,true);
         _loc7_.createBox(1,1,0,140,140);
         _loc6_.draw(_loc5_);
         this._bigThumb = PNGEncoder.encode(_loc6_);
         var _loc8_:BitmapData = new BitmapData(80,80,false,0);
         var _loc9_:Matrix = new Matrix();
         _loc9_.createBox(80 / 480,80 / 480,0,-80 * (80 / 480),0);
         _loc8_.draw(_loc1_,_loc9_,null,null,null,true);
         _loc8_.draw(_loc5_);
         this._smallThumb = PNGEncoder.encode(_loc8_);
         _loc3_.stop();
         if(_loc1_.parent)
         {
            _loc1_.parent.removeChild(_loc1_);
         }
         _loc3_.end();
         SoundManager.hasSound = true;
         this._creator.environment.size = _loc2_;
         CreatorMain.mainStage.quality = StageQuality.HIGH;
      }
      
      protected function saveThumbnails() : void
      {
         this._smallThumbRequest = new URLRequest(CreatorMain.dataLoader.baseURL + this._thumbPostURL + CreatorMain.dataLoader.getCacheString("projid=" + this._xml.firstChild.attributes.id + "&size=small"));
         this._smallThumbRequest.method = URLRequestMethod.POST;
         this._smallThumbRequest.contentType = "application/octet-stream";
         this._smallThumbRequest.data = this._smallThumb;
         this._smallThumbSaver = new URLLoader();
         this._smallThumbSaver.addEventListener(IOErrorEvent.IO_ERROR,this.onSmallThumbError);
         this._smallThumbSaver.addEventListener(Event.COMPLETE,this.onSmallThumbSaved);
         this._smallThumbSaver.load(this._smallThumbRequest);
      }
      
      protected function onSmallThumbError(param1:IOErrorEvent) : void
      {
         this._smallThumbSaver.removeEventListener(IOErrorEvent.IO_ERROR,this.onSmallThumbError);
         this._smallThumbSaver.removeEventListener(Event.COMPLETE,this.onSmallThumbSaved);
         this._creator.uiController.alert("There was a problem saving your game thumbnail.");
      }
      
      protected function onSmallThumbSaved(param1:Event) : void
      {
         this._smallThumbSaver.removeEventListener(IOErrorEvent.IO_ERROR,this.onSmallThumbError);
         this._smallThumbSaver.removeEventListener(Event.COMPLETE,this.onSmallThumbSaved);
         this._bigThumbRequest = new URLRequest(CreatorMain.dataLoader.baseURL + this._thumbPostURL + CreatorMain.dataLoader.getCacheString("projid=" + this._xml.firstChild.attributes.id + "&size=big"));
         this._bigThumbRequest.method = URLRequestMethod.POST;
         this._bigThumbRequest.contentType = "application/octet-stream";
         this._bigThumbRequest.data = this._bigThumb;
         this._bigThumbSaver = new URLLoader();
         this._bigThumbSaver.addEventListener(IOErrorEvent.IO_ERROR,this.onBigThumbError);
         this._bigThumbSaver.addEventListener(Event.COMPLETE,this.onBigThumbSaved);
         this._bigThumbSaver.load(this._bigThumbRequest);
      }
      
      protected function onBigThumbError(param1:IOErrorEvent) : void
      {
         this._bigThumbSaver.removeEventListener(IOErrorEvent.IO_ERROR,this.onBigThumbError);
         this._bigThumbSaver.removeEventListener(Event.COMPLETE,this.onBigThumbSaved);
         this._creator.uiController.alert("There was a problem saving your game thumbnail.");
      }
      
      protected function onBigThumbSaved(param1:Event) : void
      {
         this._bigThumbSaver.removeEventListener(IOErrorEvent.IO_ERROR,this.onBigThumbError);
         this._bigThumbSaver.removeEventListener(Event.COMPLETE,this.onBigThumbSaved);
      }
   }
}

