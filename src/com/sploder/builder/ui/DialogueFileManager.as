package com.sploder.builder.ui
{
   import com.sploder.asui.*;
   import com.sploder.builder.Creator;
   import com.sploder.builder.Styles;
   import com.sploder.data.User;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class DialogueFileManager extends Dialogue
   {
      public static const EVENT_SELECT:String = "select";
      
      public static const EVENT_CONFIRM:String = "confirm";
      
      public static const MODE_LOAD:int = 1;
      
      public static const MODE_SAVE:int = 2;
      
      protected var _mode:int = 1;
      
      protected var _nameFieldSelectable:Boolean = false;
      
      protected var _loadingPrompt:HTMLField;
      
      protected var _serverMessage:HTMLField;
      
      protected var _cancelButton:BButton;
      
      protected var _confirmButton:BButton;
      
      protected var _pageBack:BButton;
      
      protected var _pageNext:BButton;
      
      protected var _listContainer:Collection;
      
      protected var _nameField:FormField;
      
      protected var _xml:XMLDocument;
      
      protected var _listURL:String = "";
      
      protected var _listParamString:String = "";
      
      protected var _groupType:String = "";
      
      protected var _items:Object;
      
      protected var _totalItems:int = 0;
      
      protected var _resultStart:int = 0;
      
      protected var _resultsPerPage:int = 10;
      
      protected var _resultsNum:int = 0;
      
      protected var _resultsTotal:int = 0;
      
      protected var _totalPages:int = 0;
      
      protected var _pageNum:int = 0;
      
      protected var _selectedProject:CollectionItem;
      
      protected var _currentProjectID:String = "";
      
      private var _nameFieldTitle:HTMLField;
      
      public function DialogueFileManager(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
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
      
      public function get mode() : int
      {
         return this._mode;
      }
      
      public function set mode(param1:int) : void
      {
         this._mode = param1;
         if(this._mode == MODE_LOAD)
         {
            this._nameFieldSelectable = false;
         }
         else
         {
            this._nameFieldSelectable = true;
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
      
      public function get currentProjectID() : String
      {
         return this._currentProjectID;
      }
      
      public function set currentProjectID(param1:String) : void
      {
         this._currentProjectID = param1;
      }
      
      public function get currentProjectTitle() : String
      {
         if(this._nameField)
         {
            return this._nameField.value;
         }
         return "";
      }
      
      public function set currentProjectTitle(param1:String) : void
      {
         if(this._nameField)
         {
            this._nameField.value = param1;
         }
      }
      
      override public function create() : void
      {
         scroll = true;
         super.create();
         dbox.contentPadding = 20;
         dbox.contentBottomMargin = 80;
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
         var _loc1_:Style = new Style({
            "padding":10,
            "round":10,
            "highlightTextColor":16777215,
            "selectedButtonBorderColor":16777215
         });
         this._listContainer = new Collection(null,417,NaN,417,74,2,new Position({"margins":3}),_loc1_);
         this._listContainer.allowDrag = false;
         this._listContainer.allowRearrange = false;
         this._listContainer.defaultItemComponent = "Clip";
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
         dbox.contentCell.addChild(this._listContainer);
         this._listContainer.addEventListener(Component.EVENT_SELECT,this.onProjectSelect);
         var _loc2_:Cell = new Cell(null,_width - 54,50,false,false,0,new Position({"margin_left":20}));
         dbox.addChild(_loc2_);
         this._nameFieldTitle = new HTMLField(null,"<h3>TITLE OF YOUR GAME:</h3>",200,false,Styles.floatPosition.clone({"margin_top":20}),Styles.dialogueStyle.clone({
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
            "text":"NEWER"
         },-1,80,26,false,false,false,_loc3_,_loc4_);
         _loc2_.addChild(this._pageBack);
         this._pageBack.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._pageNext = new BButton(null,{
            "icon":Create.ICON_ARROW_LEFT,
            "text":"OLDER",
            "first":"false"
         },-1,80,26,false,false,false,_loc3_,_loc4_);
         _loc2_.addChild(this._pageNext);
         this._pageNext.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._nameField = new FormField(null,"Enter your game title here...",425,30,true,new Position({"margin_top":10}));
         this._nameField.x = 20;
         this._nameField.y = 285;
         this._nameField.restrict = "a-z A-Z 0-9";
         this._nameField.maxChars = 35;
         _loc2_.addChild(this._nameField);
         this._loadingPrompt = new HTMLField(null,"<br><br><br><p align=\"center\"><h1>Loading...</h1></p>",417,true,Styles.absPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this._loadingPrompt);
         this._loadingPrompt.x = this._loadingPrompt.y = 0;
         this._serverMessage = new HTMLField(null,"<p align=\"center\"><h1>Server message</h1></p>",317,true,Styles.absPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this._serverMessage);
         this._serverMessage.x = this._serverMessage.y = 50;
         _contentCreated = true;
         this.connect();
      }
      
      protected function connect() : void
      {
         this._cancelButton = dbox.buttons[0];
         this._confirmButton = dbox.buttons[1];
         this._nameField.addEventListener(Component.EVENT_CHANGE,this.onTitleChanged);
         this._nameField.addEventListener(Component.EVENT_FOCUS,this.onTitleFocus);
         addEventListener(EVENT_CONFIRM,_creator.project.onManagerConfirm);
      }
      
      override protected function onClick(param1:Event) : void
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
         }
      }
      
      protected function confirm() : void
      {
         dispatchEvent(new Event(EVENT_CONFIRM));
         this.hide();
      }
      
      protected function getList() : void
      {
         CreatorMain.dataLoader.loadXMLData(this._listURL + CreatorMain.dataLoader.getCacheString(this._listParamString + "&num=" + this._resultsPerPage + "&start=" + this._resultStart),true,this.onListLoaded);
         this._loadingPrompt.show();
      }
      
      protected function onListLoaded(param1:Event) : void
      {
         this._loadingPrompt.hide();
         this._xml = new XMLDocument();
         this._xml.ignoreWhite = true;
         this._xml.parseXML(param1.target.data);
         if(this._mode == MODE_SAVE)
         {
            this._nameField.selectable = true;
         }
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
         this._currentProjectID = "";
         if(this._selectedProject != null)
         {
            this._selectedProject.clip["thumbnail"].frame.gotoAndStop("inactive");
         }
      }
      
      public function loadList(param1:Event = null) : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         if(param1 == null || param1.type == EVENT_CONFIRM)
         {
            this._listContainer.clear();
            this._selectedProject = null;
            if(!dbox.visible)
            {
               this.show();
            }
            this.getList();
         }
      }
      
      protected function addItem(param1:XMLNode, param2:String, param3:int) : CollectionItem
      {
         var _loc4_:String = unescape(param1.attributes.title);
         var _loc5_:String = param1.attributes.date;
         var _loc6_:String = param1.attributes.id;
         var _loc7_:String = CreatorMain.dataLoader.baseURL;
         if(param1.attributes.archived == "1")
         {
            _loc7_ = "http://sploder.s3.amazonaws.com";
         }
         var _loc8_:String = _loc7_ + User.thumbspath + _loc6_ + ".png" + CreatorMain.dataLoader.getCacheString();
         var _loc9_:Array = this._listContainer.addMembers([{
            "title":"<h2>" + _loc4_ + "</h2><p>" + _loc5_ + "</p>",
            "raw_title":_loc4_,
            "raw_date":_loc5_,
            "icon":_loc8_,
            "id":param1.attributes.id
         }]);
         return _loc9_[0];
      }
      
      public function populate() : void
      {
         var _loc1_:XMLNode = null;
         var _loc2_:String = null;
         var _loc3_:* = null;
         this._items = {};
         if(this._xml != null && this._xml.firstChild != null)
         {
            this._groupType = this._xml.firstChild.nodeName;
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
         else
         {
            this._groupType = "projects";
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
               if(this._currentProjectID != null && _loc1_ != null && _loc1_.attributes.id == this._currentProjectID)
               {
                  this.selectProject(_loc1_.attributes.id);
               }
            }
         }
         else
         {
            if(_title == "Save Your Game")
            {
               this.showServerMessage("Enter the title of your game below.");
               this._serverMessage.show();
               this._nameField.focus();
            }
            else
            {
               _loc3_ = "No " + this._groupType + " found.";
               if(this._groupType == "projects")
               {
                  if(this._mode == MODE_LOAD)
                  {
                     _loc3_ += "\nDrag Objects onto your playfield to begin.";
                  }
                  else
                  {
                     _loc3_ += "\nEnter your game title below.";
                  }
               }
               this.showServerMessage(_loc3_);
               this._serverMessage.show();
            }
            if(this._mode == MODE_LOAD)
            {
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
            else
            {
               this._pageBack.disable();
               this._pageNext.disable();
            }
         }
         dbox.scrollbar.reset();
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
         if(param1 != null || this._listContainer.selectedMembers.length > 0)
         {
            this._selectedProject = param1 != null ? this._items[param1] : this._listContainer.selectedMembers[0];
            _loc2_ = this._selectedProject.reference;
            this._currentProjectID = _loc2_.id;
            this._nameField.value = unescape(this._xml.idMap[this._currentProjectID].attributes.title);
            this.toggleConfirmButton(true);
         }
         else
         {
            this._selectedProject = null;
            this._currentProjectID = "";
            this.setNameFieldDefault();
            this.toggleConfirmButton(false);
         }
      }
      
      protected function setNameFieldDefault() : void
      {
         if(this._selectedProject == null)
         {
            if(this._mode == MODE_LOAD)
            {
               this._nameField.value = "Select a game from the list above...";
            }
            else
            {
               this._nameField.value = "Enter your game title here...";
            }
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
         if(!_contentCreated)
         {
            this.createContent();
         }
         super.show();
         this._resultStart = 0;
         this._loadingPrompt.hide();
         this._serverMessage.hide();
         this._nameField.selectable = this._nameFieldSelectable;
         this.onTitleChanged();
         this.setNameFieldDefault();
         if(this._listContainer)
         {
            this._listContainer.allowKeyboardEvents = false;
         }
         _creator.uiController.scrollHelper.hScroller = null;
         _creator.uiController.scrollHelper.vScroller = dbox.scrollbar;
         _creator.uiController.scrollHelper.multiplier = 5;
      }
      
      override public function hide() : void
      {
         super.hide();
         if(this._listContainer)
         {
            this._listContainer.allowKeyboardEvents = false;
         }
         if(_creator.uiController)
         {
            _creator.uiController.scrollHelper.hScroller = _creator.ui.hScroll;
            _creator.uiController.scrollHelper.vScroller = _creator.ui.vScroll;
            _creator.uiController.scrollHelper.multiplier = 1;
         }
      }
   }
}

