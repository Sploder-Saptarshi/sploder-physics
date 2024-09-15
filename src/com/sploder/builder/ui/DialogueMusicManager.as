package com.sploder.builder.ui
{
   import com.sploder.asui.*;
   import com.sploder.builder.Creator;
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.builder.Styles;
   import com.sploder.util.SignString;
   import com.sploder.util.StringUtils;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import neoart.flectrum.Flectrum;
   import neoart.flectrum.SoundEx;
   import neoart.flod.ModProcessor;
   
   public class DialogueMusicManager extends Dialogue
   {
      public static const EVENT_SELECT:String = "select";
      
      public static const EVENT_REMOVE:String = "remove";
      
      public static const EVENT_CONFIRM:String = "confirm";
      
      protected var _nameFieldSelectable:Boolean = false;
      
      protected var _loadingPrompt:HTMLField;
      
      protected var _serverMessage:HTMLField;
      
      protected var _cancelButton:BButton;
      
      protected var _removeButton:BButton;
      
      protected var _confirmButton:BButton;
      
      protected var _pageBack:BButton;
      
      protected var _pageNext:BButton;
      
      protected var _listContainer:Collection;
      
      protected var _nameField:FormField;
      
      protected var _xml:XMLDocument;
      
      protected var _xmlFeatured:XMLDocument;
      
      protected var _listURL:String = "";
      
      protected var _listParamString:String = "";
      
      protected var _groupType:String = "";
      
      protected var _items:Object;
      
      protected var _totalItems:int = 0;
      
      protected var _resultStart:int = 0;
      
      protected var _resultsPerPage:int = 7;
      
      protected var _resultsNum:int = 0;
      
      protected var _resultsTotal:int = 0;
      
      protected var _featuredTotal:int = 0;
      
      protected var _selectedTrack:CollectionItem;
      
      protected var _currentMusicTrack:String = "";
      
      private var _nameFieldTitle:HTMLField;
      
      public var currentTrackURL:String = "";
      
      private var stream:ByteArray;
      
      private var processor:ModProcessor;
      
      private var songLoader:URLLoader;
      
      private var songInterval:int;
      
      private var _populating:Boolean;
      
      private var sound:SoundEx;
      
      private var flectrum:Flectrum;
      
      private var tabs:TabGroup;
      
      private var featured:Boolean = true;
      
      public function DialogueMusicManager(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      public function get title() : String
      {
         if(Boolean(dbox) && Boolean(dbox.titleField))
         {
            return dbox.titleField.value;
         }
         return "";
      }
      
      public function set title(param1:String) : void
      {
         if(Boolean(dbox) && Boolean(dbox.titleField))
         {
            dbox.titleField.value = "<p align=\"center\"><h3>" + param1 + "</h3></p>";
         }
      }
      
      public function get listURL() : String
      {
         return this._listURL;
      }
      
      public function set listURL(param1:String) : void
      {
         this._listURL = param1;
      }
      
      public function get listParamString() : String
      {
         return this._listParamString;
      }
      
      public function set listParamString(param1:String) : void
      {
         this._listParamString = param1;
      }
      
      public function get currentMusicTrack() : String
      {
         return this._currentMusicTrack;
      }
      
      public function set currentMusicTrack(param1:String) : void
      {
         this._currentMusicTrack = param1;
      }
      
      override public function create() : void
      {
         scroll = false;
         super.create();
         dbox.contentPadding = 18;
         dbox.contentBottomMargin = 115;
         dbox.contentHasBackground = true;
         dbox.contentHasBorder = true;
         _creator.ui.uiContainer.addChild(dbox);
         dbox.addButtonListener(Component.EVENT_CLICK,this.onClick);
         this.hide();
      }
      
      public function createContent() : void
      {
         if(_contentCreated)
         {
            return;
         }
         dbox.contentCell.y += 30;
         var _loc1_:Style = new Style({
            "padding":10,
            "round":10,
            "highlightTextColor":16777215,
            "selectedButtonBorderColor":16777215
         });
         this._listContainer = new Collection(null,267,NaN,287,34,2,new Position({
            "placement":Position.PLACEMENT_ABSOLUTE,
            "margin_left":3,
            "margin_bottom":0
         }),_loc1_);
         this._listContainer.allowDrag = false;
         this._listContainer.allowRearrange = false;
         this._listContainer.defaultItemComponent = "Clip";
         this._listContainer.defaultItemStyle = new Style({
            "padding":5,
            "round":5,
            "background":true,
            "bgGradient":true,
            "bgGradientColors":[5592405,2236962],
            "highlightTextColor":16777215,
            "htmlFont":"Myriad Web",
            "font":"Myriad Web",
            "fontSize":13,
            "embedFonts":true,
            "borderWidth":2,
            "borderColor":0
         });
         this._listContainer.useSnap = true;
         dbox.contentCell.addChild(this._listContainer);
         this._listContainer.x = 3;
         this._listContainer.addEventListener(Component.EVENT_SELECT,this.onTrackSelect);
         var _loc2_:Cell = new Cell(null,_width - 35,50,false,false,0,new Position({
            "margin_left":20,
            "margin_top":25
         }));
         dbox.addChild(_loc2_);
         this._nameFieldTitle = new HTMLField(null,"<h3>SELECTED MUSIC:</h3>",160,false,Styles.floatPosition.clone({"margin_top":30}),Styles.dialogueStyle.clone({
            "titleFontSize":11,
            "titleColor":16772096
         }));
         _loc2_.addChild(this._nameFieldTitle);
         var _loc3_:Position = new Position(null,Position.ALIGN_RIGHT,Position.PLACEMENT_FLOAT_RIGHT,Position.CLEAR_NONE,"10 0 10 0");
         var _loc4_:Style;
         (_loc4_ = Styles.dialogueStyle.clone()).buttonColor = 0;
         _loc4_.padding = 0;
         _loc4_.inactiveColor = 0;
         _loc4_.unselectedColor = 0;
         this._pageBack = new BButton(null,{
            "icon":Create.ICON_ARROW_RIGHT,
            "text":"BACK"
         },-1,70,26,false,false,false,_loc3_,_loc4_);
         _loc2_.addChild(this._pageBack);
         this._pageBack.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._pageNext = new BButton(null,{
            "icon":Create.ICON_ARROW_LEFT,
            "text":"NEXT",
            "first":"false"
         },-1,70,26,false,false,false,_loc3_,_loc4_);
         _loc2_.addChild(this._pageNext);
         this._pageNext.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._nameField = new FormField(null,"None selected...",225,30,true,new Position({"margin_top":10}));
         this._nameField.x = 20;
         this._nameField.y = 285;
         this._nameField.restrict = "a-z A-Z 0-9";
         this._nameField.maxChars = 35;
         _loc2_.addChild(this._nameField);
         this._loadingPrompt = new HTMLField(null,"<br><br><br><p align=\"center\"><h1>Loading...</h1></p>",267,true,null,Styles.dialogueStyle);
         dbox.addChild(this._loadingPrompt);
         this._loadingPrompt.x = 20;
         this._loadingPrompt.y = 60;
         this._serverMessage = new HTMLField(null,"<p align=\"center\"><h1>Server message</h1></p>",267,true,null,Styles.dialogueStyle);
         dbox.addChild(this._serverMessage);
         this._serverMessage.x = 20;
         this._serverMessage.y = 100;
         var _loc5_:Style;
         (_loc5_ = Styles.dialogueStyle.clone()).unselectedTextColor = 13421772;
         this.tabs = new TabGroup(dbox.mc,["Featured","All"],null,0,30,false,Styles.absPosition,_loc5_);
         this.tabs.x = 18;
         this.tabs.y = 42;
         this.tabs.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.sound = new SoundEx();
         this.flectrum = new Flectrum(this.sound,8);
         this.flectrum.rowSpacing = 0;
         this.flectrum.columnSpacing = 2;
         this.flectrum.showBackground = true;
         this.flectrum.backgroundBeat = false;
         this.flectrum.x = 258;
         this.flectrum.y = 376;
         this.flectrum.width = 55;
         this.flectrum.height = 30;
         dbox.mc.addChild(this.flectrum);
         _contentCreated = true;
         this.connect();
      }
      
      protected function connect() : void
      {
         this._cancelButton = dbox.buttons[0];
         this._removeButton = dbox.buttons[1];
         this._confirmButton = dbox.buttons[2];
         dbox.addEventListener(Component.EVENT_BLUR,this.onBlur);
      }
      
      protected function onBlur(param1:Event) : void
      {
         if(this.processor)
         {
            this.processor.stop();
            this.processor = null;
         }
      }
      
      override protected function onClick(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         switch(param1.target)
         {
            case this.tabs:
               _loc2_ = this.featured;
               this.featured = this.tabs.value == "Featured";
               if(_loc2_ != this.featured)
               {
                  this._resultStart = 0;
                  this.loadList();
               }
               break;
            case this._pageBack:
               this._resultStart -= this._resultsPerPage;
               this._resultStart = Math.max(0,this._resultStart);
               this.loadList();
               break;
            case this._pageNext:
               this._resultStart += this._resultsPerPage;
               this._resultStart = Math.min(this._resultsNum - this._resultsPerPage,this._resultStart);
               this.loadList();
               break;
            case this._cancelButton:
               this.hide();
               break;
            case this._removeButton:
               this.removeMusic();
               break;
            case this._confirmButton:
               this.confirm();
         }
      }
      
      protected function removeMusic() : void
      {
         _creator.environment.vMusic = "";
         this._currentMusicTrack = "";
         this.currentTrackURL = "";
         this._nameField.value = "None selected...";
         this.hide();
      }
      
      protected function confirm() : void
      {
         _creator.environment.vMusic = this.currentTrackURL;
         this.hide();
      }
      
      protected function getList() : void
      {
         CreatorMain.dataLoader.loadXMLData(this._listURL + CreatorMain.dataLoader.getCacheString(),true,this.onListLoaded);
         this._loadingPrompt.show();
      }
      
      protected function onListLoaded(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         this._loadingPrompt.hide();
         param1.target.data = String(param1.target.data).split("\r").join("");
         var _loc2_:Array = String(param1.target.data).split("\n");
         var _loc3_:Object = {};
         _loc4_ = int(_loc2_.length);
         while(_loc4_--)
         {
            if(String(_loc2_[_loc4_]).indexOf("http://") != -1)
            {
               _loc5_ = String(_loc2_[_loc4_]).split("\\");
               _loc3_[_loc5_[0]] = _loc5_[1];
               _loc2_.splice(_loc4_,1);
            }
         }
         var _loc7_:* = "<tracks total=\"" + _loc2_.length + "\">\n";
         var _loc8_:* = "<tracks total=\"$total\">\n";
         var _loc9_:Array = [];
         var _loc10_:Array = [];
         var _loc11_:String = "";
         var _loc12_:String = "";
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = String(_loc2_[_loc4_]).split("\\");
            _loc12_ = String(_loc2_[_loc4_]).split("\\").join("/").split("?featured=1").join("");
            _loc6_ = SignString.sign(_loc12_);
            _loc11_ = String(_loc5_[1]).split("?")[0];
            if(Boolean(_loc5_) && _loc5_.length > 1)
            {
               _loc9_.push("\t" + "<track title=\"" + _loc11_ + "\" author=\"" + _loc5_[0] + "\" url=\"" + _loc12_ + "\" author_url=\"" + _loc3_[_loc5_[0]] + "\" id=\"" + _loc6_ + "\" />" + "\n");
               if(String(_loc2_[_loc4_]).indexOf("?featured=1") != -1)
               {
                  _loc10_.push("\t" + "<track title=\"" + _loc11_ + "\" author=\"" + _loc5_[0] + "\" url=\"" + _loc12_ + "\" author_url=\"" + _loc3_[_loc5_[0]] + "\" id=\"" + _loc6_ + "\" />" + "\n");
               }
            }
            _loc4_++;
         }
         _loc9_.sort();
         _loc10_.sort();
         _loc7_ += _loc9_.join("");
         _loc7_ = _loc7_ += _loc9_.join("") + "</tracks>";
         _loc8_ += _loc10_.join("");
         _loc8_ = _loc8_ += _loc10_.join("") + "</tracks>";
         this._xml = new XMLDocument();
         this._xml.ignoreWhite = true;
         this._xml.parseXML(_loc7_);
         this._xmlFeatured = new XMLDocument();
         this._xmlFeatured.ignoreWhite = true;
         this._xmlFeatured.parseXML(_loc8_);
         this._resultsTotal = _loc9_.length;
         this._resultsNum = this._featuredTotal = _loc10_.length;
         this.populate();
      }
      
      protected function onTitleChanged(param1:Event = null) : void
      {
         if(this._nameField.value.length > 3 && this._nameField.value.indexOf("...") == -1)
         {
            this.toggleConfirmButton(true);
         }
         else
         {
            this.toggleConfirmButton(false);
         }
      }
      
      protected function onTitleFocus(param1:Event = null) : void
      {
         this._currentMusicTrack = "";
      }
      
      public function loadList(param1:Event = null) : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         this.currentTrackURL = _creator.environment.vMusic;
         if(this.currentTrackURL)
         {
            this._currentMusicTrack = SignString.sign(this.currentTrackURL);
            this._nameField.value = this.currentTrackURL.split("/")[1];
         }
         else
         {
            this._currentMusicTrack = "";
            this._nameField.value = "None selected...";
         }
         if(param1 == null || param1.type == EVENT_CONFIRM)
         {
            if(this._xml == null)
            {
               this._listContainer.clear();
               this._selectedTrack = null;
               this.getList();
            }
            else
            {
               this._listContainer.clear();
               this.populate();
            }
         }
      }
      
      protected function addItem(param1:XMLNode, param2:String, param3:int) : CollectionItem
      {
         var _loc4_:String = com.sploder.util.StringUtils.titleCase(unescape(param1.attributes.title).split(".mp3").join("").split("-").join(" "));
         var _loc5_:String = param1.attributes.author;
         var _loc6_:String = param1.attributes.url;
         var _loc7_:String = param1.attributes.author_url;
         var _loc8_:Array = this._listContainer.addMembers([{
            "id":param1.attributes.id,
            "title":"<p><font face=\"Myriad Web Bold\">" + _loc4_ + "</font></p>",
            "raw_title":_loc4_,
            "url":_loc6_,
            "icon":CreatorUIStates.ICON_MUSICTRACK,
            "link":_loc7_,
            "credit":_loc5_
         }]);
         return _loc8_[0];
      }
      
      public function populate() : void
      {
         var _loc1_:XMLNode = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         this._pageBack.disable();
         this._pageNext.disable();
         this._populating = true;
         this._items = {};
         if(this._xml != null && this._xml.firstChild != null && this._xmlFeatured != null && this._xmlFeatured.firstChild != null)
         {
            this._groupType = "music tracks";
            this._resultsNum = this.featured ? this._featuredTotal : this._resultsTotal;
            _loc1_ = this.featured ? this._xmlFeatured.firstChild.firstChild : this._xml.firstChild.firstChild;
         }
         if(this._resultStart > 0)
         {
            this._pageBack.enable();
         }
         if(this._resultStart < this._resultsNum - this._resultsPerPage)
         {
            this._pageNext.enable();
         }
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.nodeName;
            _loc3_ = 0;
            this._totalItems = 0;
            while(_loc1_ != null)
            {
               if(_loc3_ >= this._resultStart)
               {
                  this._items[_loc1_.attributes.id] = this.addItem(_loc1_,_loc2_,this._totalItems);
                  ++this._totalItems;
               }
               _loc1_ = _loc1_.nextSibling;
               _loc3_++;
               if(_loc3_ >= this._resultStart + this._resultsPerPage)
               {
                  break;
               }
            }
            if(this._currentMusicTrack != null && Boolean(this._items[this._currentMusicTrack]))
            {
               this._listContainer.selectObject(this._items[this._currentMusicTrack]);
            }
         }
         else
         {
            _loc4_ = "No music tracks found.";
            this.showServerMessage(_loc4_);
            this._serverMessage.show();
         }
         this._listContainer.contents.y = 3;
         this._populating = false;
      }
      
      protected function onTrackSelect(param1:Event) : void
      {
         if(!this._populating)
         {
            this.selectTrack();
         }
      }
      
      protected function selectTrack(param1:String = null) : void
      {
         var _loc2_:Object = null;
         if(param1 != null || this._listContainer.selectedMembers.length > 0)
         {
            this._selectedTrack = param1 != null ? this._items[param1] : this._listContainer.selectedMembers[0];
            _loc2_ = this._selectedTrack.reference;
            this._currentMusicTrack = _loc2_.id;
            this.currentTrackURL = _loc2_.url;
            if(this._xml.idMap[this._currentMusicTrack])
            {
               this._nameField.value = "Loading...";
               if(this.songLoader)
               {
                  try
                  {
                     this.songLoader.close();
                  }
                  catch(e:Error)
                  {
                  }
                  this.songLoader = null;
                  if(this.processor)
                  {
                     this.processor.stop();
                     this.processor = null;
                  }
               }
               clearInterval(this.songInterval);
               this.songInterval = setInterval(this.loadSongReady,100);
            }
            this.toggleConfirmButton(true);
         }
         else
         {
            if(this.songLoader)
            {
               try
               {
                  this.songLoader.close();
               }
               catch(e:Error)
               {
               }
               this.songLoader = null;
               clearInterval(this.songInterval);
            }
            if(this.processor)
            {
               this.processor.stop();
            }
            this._selectedTrack = null;
            this._currentMusicTrack = "";
            this.setNameFieldDefault();
            this.toggleConfirmButton(false);
         }
      }
      
      protected function loadSongReady() : void
      {
         clearInterval(this.songInterval);
         if(!dbox.visible)
         {
            return;
         }
         if(CreatorMain.dataLoader && this._currentMusicTrack && Boolean(this._items[this._currentMusicTrack]))
         {
            this.songLoader = new URLLoader();
            this.songLoader.addEventListener(Event.COMPLETE,this.onSongLoaded,false,0,true);
            this.songLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onSongError,false,0,true);
            this.songLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSongError,false,0,true);
            this.songLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this.songLoader.load(new URLRequest(CreatorMain.dataLoader.baseURL + "/music/modules/" + this._items[this._currentMusicTrack].reference.url));
         }
      }
      
      protected function onSongLoaded(param1:Event) : void
      {
         if(Boolean(this._xml.idMap) && Boolean(this._xml.idMap[this._currentMusicTrack]))
         {
            this._nameField.value = unescape(this._xml.idMap[this._currentMusicTrack].attributes.title);
         }
         if(this.processor)
         {
            this.processor.stop();
         }
         if(!dbox.visible)
         {
            return;
         }
         this.processor = new ModProcessor();
         if(this.songLoader.data)
         {
            this.processor.load(this.songLoader.data);
            this.processor.loopSong = true;
            this.processor.stereo = 0.2;
            this.processor.play(this.sound);
            this.processor.externalReplay;
         }
      }
      
      protected function onSongError(param1:Event) : void
      {
         this._nameField.value = "Error loading track...";
      }
      
      protected function setNameFieldDefault() : void
      {
         if(this._selectedTrack == null)
         {
            this._nameField.value = "None selected...";
         }
      }
      
      protected function toggleConfirmButton(param1:Boolean = false) : void
      {
         if(param1)
         {
            this._confirmButton.enable();
         }
         else
         {
            this._confirmButton.disable();
         }
      }
      
      protected function showServerMessage(param1:String = "") : void
      {
         this._serverMessage.value = "<p align=\"center\"><h1>" + param1 + "</h1></p>";
         this._serverMessage.show();
      }
      
      override public function show() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         if(!_contentCreated)
         {
            this.createContent();
         }
         super.show();
         if(this._listContainer)
         {
            this._listContainer.deselectObjects();
         }
         this._selectedTrack = null;
         this._currentMusicTrack = null;
         this.currentTrackURL = _creator.environment.vMusic;
         this._resultStart = 0;
         this._loadingPrompt.hide();
         this._serverMessage.hide();
         this._nameField.selectable = this._nameFieldSelectable;
         this.onTitleChanged();
         if(this._xml == null)
         {
            this.loadList();
         }
         else if(this.currentTrackURL)
         {
            _loc2_ = false;
            _loc1_ = 0;
            while(_loc1_ < this._xmlFeatured.firstChild.childNodes.length)
            {
               if(this.currentTrackURL == this._xmlFeatured.firstChild.childNodes[_loc1_].attributes.url)
               {
                  this._resultStart = Math.floor(_loc1_ / this._resultsPerPage) * this._resultsPerPage;
                  _loc2_ = true;
                  this.featured = true;
                  break;
               }
               _loc1_++;
            }
            if(!_loc2_)
            {
               _loc1_ = 0;
               while(_loc1_ < this._xml.firstChild.childNodes.length)
               {
                  if(this.currentTrackURL == this._xml.firstChild.childNodes[_loc1_].attributes.url)
                  {
                     this._resultStart = Math.floor(_loc1_ / this._resultsPerPage) * this._resultsPerPage;
                     this.featured = false;
                     break;
                  }
                  _loc1_++;
               }
            }
            if(this.featured)
            {
               this.tabs.select("featured");
            }
            else
            {
               this.tabs.select("all");
            }
            this.loadList();
            this.loadSongReady();
         }
         this.setNameFieldDefault();
         if(this._listContainer)
         {
            this._listContainer.allowKeyboardEvents = true;
         }
         if(Boolean(_creator.uiController) && Boolean(_creator.uiController.scrollHelper))
         {
            _creator.uiController.scrollHelper.hScroller = null;
            _creator.uiController.scrollHelper.vScroller = dbox.scrollbar;
            _creator.uiController.scrollHelper.multiplier = 5;
         }
      }
      
      override public function hide() : void
      {
         super.hide();
         if(this.processor)
         {
            this.processor.stop();
            this.processor = null;
         }
         if(this._listContainer)
         {
            this._listContainer.allowKeyboardEvents = false;
         }
         if(Boolean(_creator.uiController) && Boolean(_creator.uiController.scrollHelper))
         {
            _creator.uiController.scrollHelper.hScroller = _creator.ui.hScroll;
            _creator.uiController.scrollHelper.vScroller = _creator.ui.vScroll;
            _creator.uiController.scrollHelper.multiplier = 1;
         }
      }
   }
}

