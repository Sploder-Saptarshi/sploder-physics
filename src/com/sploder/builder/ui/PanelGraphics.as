package com.sploder.builder.ui
{
   import com.sploder.asui.*;
   import com.sploder.builder.Creator;
   import com.sploder.builder.CreatorUI;
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.builder.Styles;
   import com.sploder.builder.Textures;
   import com.sploder.builder.model.ModelObject;
   import com.sploder.data.User;
   import com.sploder.util.Settings;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import org.bytearray.gif.player.GIFPlayer;
   
   public class PanelGraphics extends EventDispatcher
   {
      public static const EVENT_SELECT:String = "select";
      
      public static const EVENT_CONFIRM:String = "confirm";
      
      protected static const MINE:String = "Mine";
      
      protected static const ALL:String = "All";
      
      protected static const TAGS:String = "Tags";
      
      protected static const USERS:String = "Users";
      
      protected var _creator:Creator;
      
      protected var _contentCell:Cell;
      
      protected var _loadingPrompt:HTMLField;
      
      protected var _serverMessage:HTMLField;
      
      protected var _cancelButton:BButton;
      
      protected var _confirmButton:BButton;
      
      protected var _pageBack:BButton;
      
      protected var _pageNext:BButton;
      
      protected var _listContainer:Collection;
      
      protected var _xml:XMLDocument;
      
      protected var _listURL:String = "/graphics/getlist.php";
      
      protected var _public:Boolean = true;
      
      protected var _items:Object;
      
      protected var _totalItems:int = 0;
      
      protected var _resultStart:int = 0;
      
      protected var _resultsPerPage:int = 12;
      
      protected var _resultsNum:int = 0;
      
      protected var _resultsTotal:int = 0;
      
      protected var _totalPages:int = 0;
      
      protected var _pageNum:int = 0;
      
      protected var _selectedProject:CollectionItem;
      
      protected var _currentProjectID:uint = 0;
      
      protected var _currentProjectVersion:uint = 0;
      
      protected var _currentProjectUsername:String = "";
      
      protected var _currentSelectionLength:uint = 0;
      
      protected var _gifPlayers:Vector.<GIFPlayer>;
      
      protected var _contentCreated:Boolean = false;
      
      private var listChooser:TabGroup;
      
      private var _likeButton:BButton;
      
      private var _searchField:FormField;
      
      private var _searchButton:BButton;
      
      private var _searchMode:String = "";
      
      private var _moveButton:ToggleButton;
      
      protected var _tweener:TweenManager;
      
      private var _currentTab:String;
      
      private var _reportButton:BButton;
      
      public function PanelGraphics(param1:Creator)
      {
         super();
         this.init(param1);
      }
      
      public function get listURL() : String
      {
         return this._listURL;
      }
      
      public function get currentProjectID() : uint
      {
         return this._currentProjectID;
      }
      
      public function set currentProjectID(param1:uint) : void
      {
         this._currentProjectID = param1;
      }
      
      protected function init(param1:Creator) : void
      {
         this._creator = param1;
      }
      
      public function create(param1:Cell) : void
      {
         this._gifPlayers = new Vector.<GIFPlayer>();
         this._contentCell = new Cell(null,724,85,true,false,0,Styles.absPosition.clone({
            "top":442,
            "left":0
         }),Styles.dialogueStyle);
         param1.addChild(this._contentCell);
         this.createContent();
         this.hide();
         this._tweener = new TweenManager(true);
      }
      
      public function createContent() : void
      {
         if(this._contentCreated)
         {
            return;
         }
         var _loc1_:Style = new Style({
            "padding":10,
            "round":10,
            "highlightTextColor":16777215,
            "selectedButtonBorderColor":16777215
         });
         var _loc2_:Position = new Position({
            "margins":"4 3 3 5",
            "placement":Position.PLACEMENT_FLOAT
         });
         var _loc3_:Position = new Position({
            "margins":"4 3 3 3",
            "placement":Position.PLACEMENT_FLOAT
         });
         var _loc4_:Style;
         (_loc4_ = Styles.dialogueStyle.clone()).buttonColor = 0;
         _loc4_.padding = 0;
         this._pageBack = new BButton(null,Create.ICON_ARROW_RIGHT,-1,24,50,false,false,false,_loc2_,_loc4_);
         this._contentCell.addChild(this._pageBack);
         this._pageBack.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._listContainer = new Collection(null,660,48,48,48,0,Styles.floatPosition.clone({"margin_top":5}),_loc1_);
         this._listContainer.allowDrag = false;
         this._listContainer.allowRearrange = false;
         this._listContainer.defaultItemStyle = new Style({
            "padding":12,
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
         this._listContainer.allowDrag = true;
         this._contentCell.addChild(this._listContainer);
         this._pageNext = new BButton(null,Create.ICON_ARROW_LEFT,-1,24,50,false,false,false,_loc3_,_loc4_);
         this._contentCell.addChild(this._pageNext);
         this._pageNext.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._listContainer.addEventListener(Component.EVENT_SELECT,this.onProjectSelect);
         var _loc5_:Position = Styles.floatPosition.clone({
            "margin_top":4,
            "margin_left":62
         });
         var _loc6_:Position = Styles.floatPosition.clone({
            "margin_top":4,
            "margin_left":4
         });
         this._loadingPrompt = new HTMLField(null,"<br /><p align=\"center\">Loading...</p>",724,true,Styles.absPosition,Styles.dialogueStyle);
         this._contentCell.addChild(this._loadingPrompt);
         this._serverMessage = new HTMLField(null,"<br /><p align=\"center\"><b>Server message</b></p>",724,true,Styles.absPosition,Styles.dialogueStyle);
         this._contentCell.addChild(this._serverMessage);
         var _loc7_:Cell = new Cell(null,NaN,34,false,false,0);
         this._contentCell.addChild(_loc7_);
         var _loc8_:Position = Styles.floatPosition.clone({"margins":"1 0 0 6"});
         var _loc9_:Style;
         (_loc9_ = Styles.dialogueStyle.clone({"round":0})).buttonColor = 3355443;
         _loc9_.selectedButtonBorderColor = 6710886;
         _loc9_.unselectedTextColor = 13421772;
         _loc9_.unselectedColor = 0;
         _loc9_.unselectedBorderColor = 3355443;
         _loc9_.inactiveColor = 0;
         _loc9_.inactiveTextColor = 6710886;
         _loc9_.border = false;
         _loc9_.padding = 3;
         var _loc10_:Style;
         (_loc10_ = Styles.dialogueStyle.clone()).padding = 2;
         this.listChooser = new TabGroup(null,[MINE,ALL,TAGS,USERS],["Choose from my graphics only","Choose from everyone\'s public graphics","Search within tagged graphics","Search for graphics by a single user"],this._creator.demo ? 1 : 0,22,false,_loc8_,_loc9_);
         this.listChooser.textAlign = Position.ALIGN_CENTER;
         this._public = this._creator.demo;
         _loc7_.addChild(this.listChooser);
         this.listChooser.addEventListener(Component.EVENT_CLICK,this.onTabClick);
         if(this._creator.demo)
         {
            this.listChooser.tabs["mine"].disable();
         }
         this._searchField = new FormField(null,"Enter search term...",145,22,false,_loc6_);
         _loc7_.addChild(this._searchField);
         this._searchField.selectable = this._searchField.editable = true;
         this._searchField.restrict = "abcdefghijklmnopqrstuvwxyz0123456789 ";
         this._searchField.hide();
         this._searchButton = new BButton(null,"Go",-1,35,22,false,false,false,_loc6_,_loc10_);
         _loc7_.addChild(this._searchButton);
         this._searchButton.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._searchButton.hide();
         _loc7_.addChild(new Cell(null,25,24,false,false,0,Styles.floatPosition));
         this._reportButton = new BButton(null,"Report",-1,60,22,false,false,false,_loc5_,_loc10_);
         _loc7_.addChild(this._reportButton);
         this._reportButton.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._reportButton.alt = "Click to report this graphic as inappropriate.";
         this._likeButton = new BButton(null,"Like",-1,50,22,false,false,false,_loc6_,_loc10_);
         _loc7_.addChild(this._likeButton);
         this._likeButton.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._likeButton.alt = "Click if you really like this graphic.";
         this._confirmButton = new BButton(null,"Add",-1,50,22,false,false,false,_loc6_,_loc10_);
         _loc7_.addChild(this._confirmButton);
         this._confirmButton.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._confirmButton.alt = "Click to add this graphic as a texture for your selected objects";
         this._moveButton = new ToggleButton(this._contentCell.mc,Create.ICON_ARROW_UP,Create.ICON_ARROW_DOWN,false,-1,22,22,null,_loc9_);
         this._moveButton.x = 680;
         this._moveButton.y = -22;
         this._moveButton.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._moveButton.alt = "Click to move this panel to the top of the canvas";
         this._moveButton.toggledAlt = "Click to move this panel to the bottom of the canvas";
         this._cancelButton = new BButton(this._contentCell.mc,Create.ICON_CLOSE,-1,22,22,false,false,false,null,_loc9_);
         this._cancelButton.x = 702;
         this._cancelButton.y = -22;
         this._cancelButton.alt = "Close this panel";
         this._cancelButton.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._contentCreated = true;
      }
      
      public function connect() : void
      {
         addEventListener(EVENT_CONFIRM,this._creator.project.onManagerConfirm);
         this._creator.modelController.selection.addEventListener(Event.CHANGE,this.onModelSelectionChange);
         this._listContainer.addEventListener(Component.EVENT_DROP,this.onDragFromTray);
         this._listContainer.addEventListener(Component.EVENT_MOVE,this.onDragFromTrayMove);
         this._listContainer.addEventListener(Component.EVENT_DROP,this.onDropFromTray);
      }
      
      protected function onModelSelectionChange(param1:Event) : void
      {
         this._currentSelectionLength = this._creator.modelController.selection.length;
         if(this._currentSelectionLength == 0)
         {
            this.toggleConfirmButton(false);
         }
         else if(this._listContainer.selectedMembers.length > 0)
         {
            this.toggleConfirmButton(true);
         }
      }
      
      protected function onClick(param1:Event) : void
      {
         switch(param1.target)
         {
            case this._pageBack:
               this._resultStart -= this._resultsPerPage;
               this._resultStart = Math.max(0,this._resultStart);
               this.loadList();
               break;
            case this._pageNext:
               this._resultStart += this._resultsPerPage;
               this._resultStart = Math.min(this._resultsTotal,this._resultStart);
               this.loadList();
               break;
            case this._cancelButton:
               this.hide();
               break;
            case this._confirmButton:
               this.confirm();
               break;
            case this._likeButton:
               if(this._currentProjectID)
               {
                  this.like(this._currentProjectID);
               }
               break;
            case this._reportButton:
               if(this._currentProjectID)
               {
                  this.report(this._currentProjectID);
               }
               break;
            case this._searchButton:
               if(this._searchField.value.indexOf("...") == -1 && this._searchField.value.length > 2)
               {
                  this.search();
               }
               break;
            case this._moveButton:
               if(!this._moveButton.toggled)
               {
                  this._tweener.createTween(this._contentCell,"y",this._contentCell.y,442,0.5,false,false,0,0,Tween.EASE_OUT,Tween.STYLE_QUAD);
                  this._moveButton.y = this._cancelButton.y = -22;
               }
               else
               {
                  this._tweener.createTween(this._contentCell,"y",this._contentCell.y,47,0.5,false,false,0,0,Tween.EASE_OUT,Tween.STYLE_QUAD);
                  this._moveButton.y = this._cancelButton.y = 85;
               }
               break;
            case this._cancelButton:
               this.clearSelectedProject();
               this.hide();
         }
      }
      
      protected function onTabClick(param1:Event) : void
      {
         if(this._currentTab == this.listChooser.value)
         {
            return;
         }
         this._currentTab = this.listChooser.value;
         this._searchField.hide();
         this._searchButton.hide();
         this._searchMode = "";
         switch(this.listChooser.value)
         {
            case MINE:
               this._public = false;
               this.loadList();
               break;
            case ALL:
               this._public = true;
               this.loadList();
               break;
            case TAGS:
            case USERS:
               this._searchMode = this.listChooser.value;
               this._searchField.show();
               this._searchField.text = "";
               this._searchField.onBlur();
               this._searchButton.show();
         }
      }
      
      protected function onDragFromTray(param1:Event) : void
      {
         this._creator.modelController.focusObject = null;
      }
      
      protected function onDragFromTrayMove(param1:Event) : void
      {
         var _loc2_:Point = Collection(param1.target).dropPoint;
         this._creator.modelController.focusObject = this._creator.model.objectAtPoint(_loc2_);
      }
      
      protected function onDropFromTray(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Point = Collection(param1.target).dropPoint;
         this._creator.modelController.focusObject = this._creator.model.objectAtPoint(_loc3_);
         if(this._creator.modelController.focusObject == null && this._creator.ui.stage.mouseX > 90)
         {
            this._creator.uiController.notice("You can only drop graphics onto objects you\'ve created with the drawing tool!");
            return;
         }
         this._creator.modelController.history.record();
         if(this._creator.modelController.focusObject)
         {
            if(this._creator.modelController.focusObject != null && this._creator.modelController.selection.objects.indexOf(this._creator.modelController.focusObject) == -1)
            {
               this.addGraphic(this._creator.modelController.focusObject);
            }
            else if(this._creator.modelController.selection.length <= 1)
            {
               this.addGraphic();
            }
            else
            {
               this._creator.uiController.confirm(this,this.addGraphic,null,"Do you really want to add this graphic as a texture for " + this._creator.modelController.selection.length + " objects?");
            }
         }
         CreatorUI.stage.focus = Component.mainStage;
      }
      
      public function addGraphic(param1:ModelObject = null) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(this._currentProjectID > 0)
         {
            _loc2_ = Textures.getOriginal(this._currentProjectID + "_" + this._currentProjectVersion);
            _loc3_ = Boolean(_loc2_) && _loc2_.width > _loc2_.height;
            if(param1)
            {
               param1.props.graphic = this._currentProjectID;
               param1.props.graphic_version = this._currentProjectVersion;
               param1.props.animation = _loc3_ ? 1 : 0;
               param1.props.texture = 0;
               param1.props.line = -1;
               param1.props.color = -1;
               this._creator.graphics.assignGraphicToObject(this._currentProjectID,this._currentProjectVersion,param1.clip);
            }
            else
            {
               _loc4_ = 0;
               while(_loc4_ < this._creator.modelController.selection.length)
               {
                  param1 = this._creator.modelController.selection.objects[_loc4_];
                  param1.props.graphic = this._currentProjectID;
                  param1.props.graphic_version = this._currentProjectVersion;
                  param1.props.animation = _loc3_ ? 1 : 0;
                  param1.props.texture = 0;
                  param1.props.line = -1;
                  param1.props.color = -1;
                  this._creator.graphics.assignGraphicToObject(this._currentProjectID,this._currentProjectVersion,param1.clip);
                  _loc4_++;
               }
               if(this._creator.modelController.selection.length == 1)
               {
                  this._creator.ui.animationToggle.enable();
               }
            }
         }
      }
      
      protected function getSettings() : void
      {
         this.loadList();
      }
      
      protected function search() : void
      {
         this.loadList();
      }
      
      protected function confirm() : void
      {
         this.addGraphic();
      }
      
      protected function getList() : void
      {
         var _loc1_:String = "";
         if(this._searchMode != "" && this._searchField.value.length > 0 && this._searchField.value.indexOf("...") == -1)
         {
            _loc1_ = "&searchterm=" + escape(this._searchField.value) + "&searchmode=" + this._searchMode.toLowerCase();
         }
         CreatorMain.dataLoader.loadXMLData(this._listURL + CreatorMain.dataLoader.getCacheString("published=1&num=" + this._resultsPerPage + "&start=" + this._resultStart + "&userid=" + (this._public || this._creator.demo ? "0" : User.u.toString()) + _loc1_),true,this.onListLoaded);
         this._loadingPrompt.show();
      }
      
      protected function onListLoaded(param1:Event) : void
      {
         this._loadingPrompt.hide();
         this._xml = new XMLDocument();
         this._xml.ignoreWhite = true;
         this._xml.parseXML(param1.target.data);
         this.populate();
      }
      
      public function loadList(param1:Event = null) : void
      {
         if(!this._contentCreated)
         {
            this.createContent();
         }
         if(param1 == null || param1.type == EVENT_CONFIRM)
         {
            this.clearGIFs();
            this.clearSelectedProject();
            this._listContainer.deselectObjects();
            this._listContainer.clear();
            this._serverMessage.hide();
            if(!this._contentCell.visible)
            {
               this.show();
            }
            this.getList();
         }
      }
      
      protected function addItem(param1:XMLNode, param2:String, param3:int) : CollectionItem
      {
         var _loc7_:String = null;
         var _loc4_:String = param1.attributes.id;
         var _loc5_:String = param1.attributes.version;
         var _loc6_:String = !!param1.attributes.username ? param1.attributes.username : User.name;
         if(CreatorMain.preloader.loaderInfo.url.indexOf("sploder") == -1 || CreatorMain.preloader.loaderInfo.url.indexOf("file") != -1)
         {
            _loc7_ = "http://sploder_dev.s3.amazonaws.com/gfx/gif/";
         }
         else
         {
            _loc7_ = "http://sploder.s3.amazonaws.com/gfx/gif/";
         }
         var _loc8_:String = _loc7_ + _loc4_ + ".gif" + CreatorMain.dataLoader.getCacheString();
         var _loc9_:Array = this._listContainer.addMembers([{
            "icon":_loc8_,
            "version":_loc5_,
            "username":_loc6_,
            "id":_loc4_
         }]);
         var _loc10_:CollectionItem = this._listContainer.members[this._listContainer.members.length - 1];
         _loc10_.addEventListener(Component.EVENT_M_OVER,this.onItemRollover);
         _loc10_.addEventListener(Component.EVENT_M_OUT,this.onItemRollout);
         var _loc11_:GIFPlayer = new GIFPlayer();
         _loc10_.clip = _loc11_;
         _loc10_.clip.parent.parent.mouseEnabled = _loc10_.clip.parent.parent.mouseChildren = false;
         if(param1.attributes["username"])
         {
            _loc10_.alt = "created by " + param1.attributes.username;
         }
         _loc11_.x = _loc11_.y = 4;
         _loc11_.scaleX = _loc11_.scaleY = 0.5;
         _loc11_.load(new URLRequest(_loc8_));
         this._gifPlayers.push(_loc11_);
         var _loc12_:Sprite = Component.library.getDisplayObject(CreatorUIStates.ICON_LOADING) as Sprite;
         _loc11_.parent.addChild(_loc12_);
         _loc12_.x = _loc12_.y = 24;
         _loc12_.scaleX = _loc12_.scaleY = 0.5;
         _loc11_.parent.setChildIndex(_loc12_,0);
         return _loc9_[0];
      }
      
      protected function onItemRollover(param1:Event) : void
      {
         this._creator.ui.prompt.show("To use this graphic, drag it onto an object on the canvas.");
      }
      
      protected function onItemRollout(param1:Event) : void
      {
         this._creator.ui.prompt.hide();
      }
      
      protected function onGIFLoaded(param1:Event) : void
      {
         var _loc2_:Sprite = null;
         if(Boolean(param1.target) && Boolean(param1.target["parent"]))
         {
            _loc2_ = DisplayObject(param1.target).parent.getChildByName("loading") as Sprite;
            if(Boolean(_loc2_) && Boolean(_loc2_.parent))
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      public function populate() : void
      {
         var _loc1_:XMLNode = null;
         var _loc2_:String = null;
         this._items = {};
         if(this._xml != null && this._xml.firstChild != null)
         {
            this._resultsTotal = parseInt(this._xml.firstChild.attributes.total);
            if(this._xml.firstChild.attributes.start != undefined)
            {
               this._resultStart = parseInt(this._xml.firstChild.attributes.start);
            }
            else
            {
               this._resultStart = 0;
            }
            if(this._xml.firstChild.attributes.num != undefined)
            {
               this._resultsNum = parseInt(this._xml.firstChild.attributes.num);
               this._totalPages = Math.ceil(this._resultsTotal / this._resultsNum);
            }
            else
            {
               this._resultsNum = this._resultsTotal;
               this._pageNum = this._totalPages = 1;
            }
            if(this._resultStart == 0)
            {
               this._pageNum = 1;
               this._pageBack.disable();
            }
            else
            {
               this._pageNum = Math.ceil(this._resultStart / this._resultsNum) + 1;
               this._pageBack.enable();
            }
            if(this._resultStart + this._resultsNum >= this._resultsTotal)
            {
               this._pageNext.disable();
            }
            else
            {
               this._pageNext.enable();
            }
            _loc1_ = this._xml.firstChild.firstChild;
         }
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.nodeName;
            this._totalItems = 0;
            while(_loc1_ != null)
            {
               this._items[_loc1_.attributes.id] = this.addItem(_loc1_,_loc2_,this._totalItems);
               ++this._totalItems;
               _loc1_ = _loc1_.nextSibling;
               if(this._currentProjectID > 0 && _loc1_ != null && _loc1_.attributes.id == this._currentProjectID.toString())
               {
                  this.selectProject(_loc1_.attributes.id);
               }
            }
         }
         else
         {
            this.showServerMessage("No graphics found. Choose the \'All\' tab below, or <a href=\"/free-graphics-editor.php\" target=\"_blank\">make your own graphics!</a>");
            this._serverMessage.show();
            if(this._resultStart == 0)
            {
               this._pageBack.disable();
            }
            else
            {
               this._pageBack.enable();
            }
            this._pageNext.disable();
         }
      }
      
      protected function onThumbError(param1:IOErrorEvent) : void
      {
         var _loc2_:String = String(param1.toString()).split("thumbs/")[1].split(".png")[0];
         var _loc3_:Container = this._items[_loc2_];
      }
      
      protected function onProjectSelect(param1:Event) : void
      {
         this.selectProject();
      }
      
      protected function selectProject(param1:String = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = false;
         var _loc4_:* = false;
         if(param1 != null || this._listContainer.selectedMembers.length > 0)
         {
            this._selectedProject = param1 != null ? this._items[param1] : this._listContainer.selectedMembers[0];
            _loc2_ = this._selectedProject.reference;
            this._currentProjectID = _loc2_.id;
            this._currentProjectVersion = _loc2_.version;
            this._currentProjectUsername = _loc2_.username;
            if(this._currentSelectionLength > 0)
            {
               this.toggleConfirmButton(true);
            }
            _loc3_ = Settings.loadSetting("lk_g_" + this._currentProjectID) != null;
            if(!_loc3_)
            {
               this.toggleLikeButton(true);
            }
            _loc4_ = Settings.loadSetting("rp_g_" + this._currentProjectID) != null;
            if(!_loc4_)
            {
               this.toggleReportButton(true);
            }
         }
         else
         {
            this.clearSelectedProject();
         }
      }
      
      protected function clearSelectedProject() : void
      {
         this._selectedProject = null;
         this._currentProjectID = 0;
         this._currentProjectVersion = 0;
         this._currentProjectUsername = "";
         this.toggleConfirmButton(false);
         this.toggleLikeButton(false);
         this.toggleReportButton(false);
      }
      
      protected function like(param1:uint) : void
      {
         var _loc2_:URLLoader = null;
         if(param1)
         {
            Settings.saveSetting("lk_g_" + param1,true);
            this.toggleLikeButton(false);
            _loc2_ = new URLLoader();
            CreatorMain.dataLoader.send("/graphics/feedback.php","projid=" + param1 + "&action=like",true);
         }
      }
      
      protected function report(param1:uint) : void
      {
         if(param1)
         {
            Settings.saveSetting("rp_g_" + param1,true);
            this.toggleReportButton(false);
            CreatorMain.dataLoader.send("/graphics/feedback.php","projid=" + param1 + "&action=report",true);
         }
      }
      
      protected function toggleLikeButton(param1:Boolean = false) : void
      {
         if(param1 && this._public)
         {
            this._likeButton.enable();
         }
         else
         {
            this._likeButton.disable();
         }
      }
      
      protected function toggleReportButton(param1:Boolean = false) : void
      {
         if(param1 && this._public)
         {
            this._reportButton.enable();
         }
         else
         {
            this._reportButton.disable();
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
         this._serverMessage.value = "<br /><p align=\"center\"><b>" + param1 + "</b></p>";
         this._serverMessage.show();
      }
      
      public function show() : void
      {
         if(!this._contentCreated)
         {
            this.createContent();
         }
         this._contentCell.show();
         if(this._creator.uiController)
         {
            this._creator.uiController.keyboardEnabled = false;
         }
         this._resultStart = 0;
         this.clearSelectedProject();
         this._loadingPrompt.hide();
         this._serverMessage.hide();
         this.getSettings();
         if(this._listContainer)
         {
            this._listContainer.allowKeyboardEvents = false;
         }
      }
      
      protected function clearGIFs() : void
      {
         var _loc2_:GIFPlayer = null;
         var _loc1_:int = int(this._gifPlayers.length);
         while(_loc1_--)
         {
            _loc2_ = this._gifPlayers.pop();
            _loc2_.stop();
            _loc2_.dispose();
            if(_loc2_.parent)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      public function hide() : void
      {
         this._contentCell.hide();
         if(this._creator.uiController)
         {
            this._creator.uiController.keyboardEnabled = true;
         }
         CreatorUI.stage.focus = Component.mainStage;
         this.clearGIFs();
         if(this._listContainer)
         {
            this._listContainer.allowKeyboardEvents = false;
         }
         if(Boolean(this._creator.ui.graphicsPanelToggle) && this._creator.ui.graphicsPanelToggle.toggled)
         {
            this._creator.ui.graphicsPanelToggle.toggle();
         }
      }
   }
}

