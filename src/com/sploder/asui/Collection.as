package com.sploder.asui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class Collection extends Cell
   {
      public static var selectedCollection:Collection;
      
      public static var sourceCollection:Collection;
      
      public static var destCollection:Collection;
      
      public static var destIndex:int;
      
      protected static var selectBox:Sprite;
      
      protected static var dragContainer:Sprite;
      
      protected static var dragGhost:Sprite;
      
      protected static var dragGhostSnapshot:Bitmap;
      
      public static const EVENT_ADD_MEMBER:String = "add_member";
      
      public static const EVENT_ADD_START:String = "add_complete";
      
      public static const EVENT_ADD_COMPLETE:String = "add_complete";
      
      public static const EVENT_DELETE:String = "delete";
      
      public static const EVENT_RESTORE:String = "restore";
      
      public static const EVENT_LIST_CHANGE:String = "list_change";
      
      public static const EVENT_CLEAR:String = "list_clear";
      
      public var allowRemoveOnDrag:Boolean = false;
      
      public var useRotateEffectOnDrag:Boolean = false;
      
      public var useBorderColorOnHighlight:Boolean = false;
      
      public var allowDrag:Boolean = false;
      
      public var allowRearrange:Boolean = false;
      
      public var allowDelete:Boolean = true;
      
      public var allowMultiSelect:Boolean = false;
      
      public var usePagingDisplay:Boolean = false;
      
      public var useBorderWidthInBlanks:Boolean = true;
      
      public var useCircularBlanks:Boolean = false;
      
      public var autoResize:Boolean = false;
      
      public var resizeScale:Number = 1;
      
      public var showHighlight:Boolean = true;
      
      public var useSnap:Boolean = false;
      
      public var ignoreVisibility:Boolean = false;
      
      public var allowKeyboardEvents:Boolean = true;
      
      protected var _currentPage:int = 1;
      
      protected var _pageWidth:int;
      
      protected var _pageX:int = 0;
      
      protected var _itemsPerPage:int = 0;
      
      protected var _itemsPerRow:int = 0;
      
      protected var _members:Array;
      
      protected var _masterCollection:Collection;
      
      protected var clipboard:Array;
      
      protected var _memberRefs:Dictionary;
      
      protected var _newItems:Array;
      
      protected var _populating:Boolean = false;
      
      protected var _selectedMembers:Array;
      
      protected var _selectionIndex:int = -1;
      
      protected var _memberPosition:Position;
      
      protected var _selectDrag:Boolean = false;
      
      protected var _isDragging:Boolean = false;
      
      protected var _isSelecting:Boolean = false;
      
      protected var _isTweening:Boolean = false;
      
      protected var _tweenRate:Number = 3;
      
      public var dropPoint:Point;
      
      protected var markerContainer:Sprite;
      
      protected var _backgroundButton:Sprite;
      
      protected var _memberWidth:int = 100;
      
      protected var _memberHeight:int = 100;
      
      protected var _rowLength:int = 5;
      
      protected var _spacing:int = 20;
      
      protected var _startWidth:Number;
      
      protected var _startHeight:Number;
      
      protected var _totalWidth:Number;
      
      protected var _totalHeight:Number;
      
      protected var _newScale:Number;
      
      protected var _rescaling:Boolean = false;
      
      protected var _mouseXold:Number = 0;
      
      protected var _mouseYold:Number = 0;
      
      public var itemScale:Number = 1;
      
      public var itemListener:Function;
      
      public var defaultItemComponent:String;
      
      public var defaultItemStyle:Style;
      
      public function Collection(param1:Sprite = null, param2:Number = NaN, param3:Number = NaN, param4:Number = 100, param5:Number = 100, param6:int = 10, param7:Position = null, param8:Style = null)
      {
         super();
         this.init_Collection(param1,param2,param3,param4,param5,param6,param7,param8);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function get totalPages() : int
      {
         return Math.ceil(this._members.length / this._itemsPerPage);
      }
      
      public function get members() : Array
      {
         return this._members;
      }
      
      public function get masterCollection() : Collection
      {
         return this._masterCollection;
      }
      
      public function set masterCollection(param1:Collection) : void
      {
         if(this._masterCollection != null)
         {
            this._masterCollection.removeEventListener(EVENT_ADD_MEMBER,this.onMasterAdd);
            this._masterCollection.removeEventListener(EVENT_LIST_CHANGE,this.onMasterChange);
            this._masterCollection.removeEventListener(EVENT_DELETE,this.onMasterDelete);
            this._masterCollection.removeEventListener(EVENT_RESTORE,this.onMasterRestore);
            this._masterCollection.removeEventListener(EVENT_CLEAR,this.onMasterClear);
         }
         this._masterCollection = param1;
         if(this._masterCollection != null)
         {
            this._masterCollection.addEventListener(EVENT_ADD_MEMBER,this.onMasterAdd);
            this._masterCollection.addEventListener(EVENT_LIST_CHANGE,this.onMasterChange);
            this._masterCollection.addEventListener(EVENT_DELETE,this.onMasterDelete);
            this._masterCollection.addEventListener(EVENT_RESTORE,this.onMasterRestore);
            this._masterCollection.addEventListener(EVENT_CLEAR,this.onMasterClear);
            this.onMasterChange();
         }
         else
         {
            this.clear();
         }
      }
      
      public function set membersMouseEnabled(param1:Boolean) : void
      {
         var _loc2_:Component = null;
         for each(_loc2_ in childNodes)
         {
            _loc2_.mouseEnabled = param1;
         }
      }
      
      public function get selectedMembers() : Array
      {
         return this._selectedMembers;
      }
      
      public function get selectionIndex() : int
      {
         return this._selectionIndex;
      }
      
      override public function get contentWidth() : Number
      {
         return super.contentWidth + this._spacing;
      }
      
      override public function get width() : uint
      {
         if(_width == 0)
         {
            return _mc.width;
         }
         return Math.max(this._startWidth,_width + this._spacing);
      }
      
      override public function get height() : uint
      {
         if(_height == 0)
         {
            return _mc.height;
         }
         return Math.max(this._startHeight,_height + this._spacing);
      }
      
      public function get memberWidth() : int
      {
         return this._memberWidth;
      }
      
      public function get memberHeight() : int
      {
         return this._memberHeight;
      }
      
      protected function init_Collection(param1:Sprite, param2:Number = NaN, param3:Number = NaN, param4:Number = 100, param5:Number = 100, param6:int = 10, param7:Position = null, param8:Style = null) : void
      {
         super.init_Cell(param1,param2,param3,false,false,0,param7,param8);
         _type = "collection";
         this.dropPoint = new Point();
         if(isNaN(param3))
         {
            _collapse = true;
         }
         this._memberWidth = param4;
         this._memberHeight = param5;
         this._spacing = param6;
         this._memberPosition = new Position(null,Position.ALIGN_LEFT,Position.PLACEMENT_FLOAT,Position.CLEAR_NONE,this._spacing / 2);
         this._rowLength = Math.max(1,Math.floor(_width / (this._memberWidth + this._spacing * 2)));
         this._pageWidth = _width;
         this._itemsPerPage = Math.floor(_width / (this._memberWidth + this._spacing)) * Math.floor(_height / (this._memberHeight + this._spacing));
         this._itemsPerRow = Math.floor(this._pageWidth / (this._memberWidth + this._spacing));
         this._members = [];
         this._selectedMembers = [];
         this._memberRefs = new Dictionary(true);
         this._newItems = [];
         this.clipboard = [];
         Key.initialize(mainStage);
         mainStage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
         mainStage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,0,true);
      }
      
      override public function create() : void
      {
         var _loc1_:Graphics = null;
         super.create();
         this._startWidth = _width;
         this._startHeight = _height;
         if(selectBox == null)
         {
            selectBox = new Sprite();
            selectBox.visible = false;
            _loc1_ = selectBox.graphics;
            _loc1_.lineStyle(1,_style.highlightTextColor,1,true,LineScaleMode.NONE);
            _loc1_.beginFill(_style.highlightTextColor,0.25);
            _loc1_.drawRect(0,0,100,100);
            Component.mainStage.addChild(selectBox);
         }
         if(dragContainer == null)
         {
            dragContainer = new Sprite();
            dragContainer.name = "_collection_dragcontainer";
            Component.mainStage.addChild(dragContainer);
            dragGhost = new Sprite();
            dragContainer.addChild(dragGhost);
            dragGhostSnapshot = new Bitmap();
            dragGhost.addChild(dragGhostSnapshot);
         }
         this._backgroundButton = new Sprite();
         this._backgroundButton.graphics.beginFill(0,0);
         this._backgroundButton.graphics.drawRect(0,0,_width,_height);
         this._backgroundButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onSelectWindowStart);
         _mc.addChild(this._backgroundButton);
         _mc.setChildIndex(this._backgroundButton,0);
         this.markerContainer = new Sprite();
         _mc.addChild(this.markerContainer);
         _bkgd.mouseEnabled = false;
      }
      
      public function getItem(param1:Object) : CollectionItem
      {
         if(this._memberRefs[param1] is CollectionItem)
         {
            return this._memberRefs[param1] as CollectionItem;
         }
         if(this._memberRefs[param1] is Array)
         {
            return this._memberRefs[param1][0];
         }
         return null;
      }
      
      protected function saveMembers(param1:Array) : void
      {
         var _loc2_:CollectionItem = null;
         this.clipboard = [];
         for each(_loc2_ in param1)
         {
            if(this._members.indexOf(_loc2_) >= 0)
            {
               this.clipboard.unshift({
                  "member":_loc2_,
                  "index":this._members.indexOf(_loc2_)
               });
            }
         }
         this.clipboard.sortOn("index");
      }
      
      protected function restoreMembers() : void
      {
         var _loc1_:Object = null;
         var _loc2_:CollectionItem = null;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         while(this.clipboard.length > 0)
         {
            _loc1_ = this.clipboard.shift();
            _loc2_ = _loc1_.member;
            _loc2_.deleted = false;
            _loc4_.push(_loc2_.reference);
            addChild(_loc2_);
            this.setItemReference(_loc2_.reference,_loc2_);
            this._members.splice(_loc1_.index,0,_loc1_.member);
            _loc3_.push(_loc2_);
         }
         dispatchEvent(new ObjectEvent(EVENT_RESTORE,false,false,_loc4_));
         this.selectMembers(_loc3_);
         this.arrange();
      }
      
      public function addMembers(param1:Array, param2:int = -1, param3:Boolean = false, param4:Boolean = false) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:Array = [];
         if(this.useSnap)
         {
            param4 = true;
         }
         if(param3)
         {
            this.clear();
            this._newItems = [];
         }
         this.deselectObjects();
         if(param1[0] is CollectionItem)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.length)
            {
               param1[_loc6_] = CollectionItem(param1[_loc6_]).reference;
               _loc6_++;
            }
         }
         this._newItems = this._newItems.concat(param1);
         if(param2 == -1 && param1.length > 500)
         {
            if(!this._populating)
            {
               dispatchEvent(new Event(EVENT_ADD_START));
               this._populating = true;
               mainStage.addEventListener(Event.ENTER_FRAME,this.populate);
            }
         }
         else
         {
            _loc7_ = param2;
            while(this._newItems.length > 0)
            {
               _loc5_.push(this.addMember(this._newItems.shift(),_loc7_,param4));
               if(_loc7_ != -1)
               {
                  _loc7_++;
               }
            }
            this.deselectObjects();
            if(param2 != -1)
            {
               this.selectObjects(param2,param2 + param1.length - 1);
            }
            dispatchEvent(new Event(EVENT_ADD_COMPLETE));
         }
         return _loc5_;
      }
      
      public function removeMembers(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:CollectionItem = null;
         var _loc4_:Array = null;
         this.deselectObjects();
         this.saveMembers(param1);
         _loc2_ = int(param1.length - 1);
         while(_loc2_ >= 0)
         {
            if(param1[_loc2_] is CollectionItem)
            {
               CollectionItem(param1[_loc2_]).deleted = true;
            }
            removeChild(CollectionItem(param1[_loc2_]),false);
            if(this._memberRefs[CollectionItem(param1[_loc2_]).reference] is CollectionItem)
            {
               this._memberRefs[CollectionItem(param1[_loc2_]).reference] = null;
            }
            else if(this._memberRefs[CollectionItem(param1[_loc2_]).reference] is Array)
            {
               _loc4_ = this._memberRefs[CollectionItem(param1[_loc2_]).reference] as Array;
               if(_loc4_.indexOf(param1[_loc2_]) != -1)
               {
                  _loc4_.splice(_loc4_.indexOf(param1[_loc2_]),1);
               }
               if(_loc4_.length == 0)
               {
                  this._memberRefs[CollectionItem(param1[_loc2_]).reference] = null;
               }
               else if(_loc4_.length == 1)
               {
                  this._memberRefs[CollectionItem(param1[_loc2_]).reference] = _loc4_[0];
               }
            }
            _loc2_--;
         }
         _loc2_ = int(param1.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = param1[_loc2_];
            this.splice(this._members.indexOf(_loc3_),1,null,false);
            _loc3_.deleted = true;
            _loc2_--;
         }
      }
      
      public function addAlts(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(this._members[_loc2_])
            {
               CollectionItem(this._members[_loc2_]).alt = param1[_loc2_];
            }
            _loc2_++;
         }
      }
      
      public function selectMembers(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         this.deselectObjects();
         if(param1.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(this._members.indexOf(param1[_loc2_]) != -1)
               {
                  this._selectedMembers.push(param1[_loc2_]);
                  CollectionItem(param1[_loc2_]).selected = true;
               }
               _loc2_++;
            }
         }
         if(selectedCollection != null && selectedCollection != this)
         {
            selectedCollection.deselectObjects();
         }
         selectedCollection = this;
      }
      
      protected function populate(param1:Event) : void
      {
         if(this._newItems.length > 0)
         {
            this.addMember(this._newItems.shift());
         }
         else
         {
            this._populating = false;
            mainStage.removeEventListener(Event.ENTER_FRAME,this.populate);
            dispatchEvent(new Event(EVENT_ADD_COMPLETE));
         }
      }
      
      protected function addMember(param1:Object, param2:int = -1, param3:Boolean = false) : CollectionItem
      {
         var _loc4_:CollectionItem = null;
         var _loc5_:Style = !!this.defaultItemStyle ? this.defaultItemStyle : _style;
         _loc4_ = new CollectionItem(this,param1,this._memberWidth,this._memberHeight,this._memberPosition,_loc5_);
         if(this.itemListener != null)
         {
            _loc4_.addEventListener(EVENT_CREATE,this.itemListener);
         }
         if(this.itemListener != null)
         {
            _loc4_.addEventListener(EVENT_CHANGE,this.itemListener);
         }
         if(this.itemListener != null)
         {
            _loc4_.addEventListener(EVENT_REMOVE,this.itemListener);
         }
         addChild(_loc4_);
         _loc4_.addEventListener(Component.EVENT_CLICK,this.onMemberClick);
         _loc4_.addEventListener(Component.EVENT_DRAG,this.startDrag);
         _loc4_.addEventListener(Component.EVENT_DROP,this.stopDrag);
         this.setItemReference(param1,_loc4_);
         this._members.push(_loc4_);
         this.selectObject(_loc4_);
         if(param2 >= 0)
         {
            this.placeSelectionAt(param2,true);
         }
         this.arrange(param3);
         if(this.usePagingDisplay)
         {
         }
         dispatchEvent(new ObjectEvent(EVENT_ADD_MEMBER,false,false,_loc4_.reference));
         return _loc4_;
      }
      
      protected function setItemReference(param1:Object, param2:CollectionItem) : void
      {
         var _loc3_:Array = null;
         if(this._memberRefs[param1] == null)
         {
            this._memberRefs[param1] = param2;
         }
         else if(this._memberRefs[param1] is CollectionItem)
         {
            this._memberRefs[param1] = [this._memberRefs[param1],param2];
         }
         else
         {
            _loc3_ = this._memberRefs[param1] as Array;
            _loc3_.push(param2);
         }
      }
      
      public function updateView() : void
      {
         this.arrange();
      }
      
      protected function arrange(param1:Boolean = false) : void
      {
         var _loc2_:CollectionItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Graphics = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.useSnap)
         {
            param1 = true;
         }
         _childNodes = this._members.concat();
         if(this.autoResize)
         {
            this.resize();
            dispatchEvent(new Event(EVENT_CHANGE));
         }
         else
         {
            if(this.usePagingDisplay)
            {
               _width = this.totalPages * this._pageWidth + 10;
               _loc6_ = 0;
               while(_loc6_ < this._members.length)
               {
                  _loc2_ = this.members[_loc6_];
                  _loc3_ = Math.floor(_loc6_ / this._itemsPerPage);
                  _loc5_ = _loc6_ % this._itemsPerRow;
                  _loc4_ = Math.floor(_loc6_ % this._itemsPerPage / this._itemsPerRow);
                  _loc2_.x = this._spacing / 2 + this._pageWidth * _loc3_ + (this._memberWidth + this._spacing) * _loc5_;
                  _loc2_.y = this._spacing / 2 + (this._memberHeight + this._spacing) * _loc4_;
                  _loc6_++;
               }
               _width = Position.getCellContentWidth(this);
               _loc7_ = _childrenContainer.graphics;
               _loc7_.clear();
               if(this._members.length % this._itemsPerPage != 0)
               {
                  _loc8_ = this._itemsPerPage - this._members.length % this._itemsPerPage;
                  _loc6_ = int(this._members.length);
                  while(_loc6_ < this._members.length + _loc8_)
                  {
                     _loc2_ = this.members[_loc6_];
                     _loc3_ = Math.floor(_loc6_ / this._itemsPerPage);
                     _loc5_ = _loc6_ % this._itemsPerRow;
                     _loc4_ = Math.floor(_loc6_ % this._itemsPerPage / this._itemsPerRow);
                     _loc7_.beginFill(_style.borderColor,0.1);
                     _loc9_ = this.useBorderWidthInBlanks ? int(_style.borderWidth) : 0;
                     if(!this.useCircularBlanks)
                     {
                        _loc7_.drawRect(this._spacing / 2 + this._pageWidth * _loc3_ + (this._memberWidth + this._spacing) * _loc5_ - _loc9_ * this.itemScale,this._spacing / 2 + (this._memberHeight + this._spacing) * _loc4_ - _loc9_ * this.itemScale,this._memberWidth + _loc9_ * 2 * this.itemScale,this._memberHeight + _loc9_ * 2 * this.itemScale);
                     }
                     else
                     {
                        _loc7_.drawCircle(this._memberWidth / 2 + this._spacing / 2 + this._pageWidth * _loc3_ + (this._memberWidth + this._spacing) * _loc5_ - _loc9_ * this.itemScale,this._memberHeight / 2 + this._spacing / 2 + (this._memberHeight + this._spacing) * _loc4_ - _loc9_ * this.itemScale,(this._memberWidth - 4 + _loc9_ * 2 * this.itemScale) / 2);
                     }
                     _loc6_++;
                  }
               }
               else
               {
                  _loc7_.clear();
               }
               if(this.resizeScale != 1)
               {
                  _mc.scaleX = _mc.scaleY = this.resizeScale;
               }
            }
            else
            {
               Position.arrangeContent(this,true);
            }
            for each(_loc2_ in this._members)
            {
               if(this.useRotateEffectOnDrag)
               {
                  _loc2_.rotation = 0;
               }
               if(param1)
               {
                  _loc2_.snapToPosition();
               }
            }
            if(!_wrap)
            {
               this._rowLength = Math.max(1,this._members.length);
               _width = Position.getCellContentWidth(this);
            }
            if(_collapse)
            {
               _height = Position.getCellContentHeight(this);
            }
            if(this._selectedMembers.length > 0)
            {
               this.checkSelectionVisibility(this._selectedMembers[0]);
            }
            else
            {
               dispatchEvent(new Event(EVENT_CHANGE));
            }
         }
         dispatchEvent(new Event(EVENT_LIST_CHANGE));
      }
      
      protected function resize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:CollectionItem = null;
         if(this._members.length == 0)
         {
            return;
         }
         this._rowLength = Math.max(1,this._members.length);
         if(this._members.length > 3)
         {
            _loc2_ = Math.round(Math.sqrt(this._members.length) * _width / _height);
            if(_width / _height > 0.7 && _width / _height < 1.3 && Math.sqrt(this._members.length) % 1 == 0)
            {
               _loc2_ = Math.sqrt(this._members.length);
            }
            this._rowLength = Math.max(1,_loc2_);
         }
         this._totalWidth = (this._memberWidth + this._spacing) * (this._rowLength - 1);
         this._totalHeight = 0;
         if(this._rowLength > 0)
         {
            this._totalHeight = (this._memberHeight + this._spacing) * (Math.ceil(this._members.length / this._rowLength) - 1);
         }
         _loc1_ = 0;
         while(_loc1_ < this._members.length)
         {
            _loc3_ = this._members[_loc1_];
            if(!_loc3_.deleted)
            {
               _loc3_.x = (this._memberWidth + this._spacing) * (_loc1_ % this._rowLength) - this._totalWidth / 2 - this._memberWidth / 2;
               _loc3_.y = (this._memberHeight + this._spacing) * Math.floor(_loc1_ / this._rowLength) - this._totalHeight / 2 - this._memberHeight / 2;
               _loc3_.rotation = 0;
               if(_loc3_.mc != null && _loc3_.mc.parent != null)
               {
                  _loc3_.mc.parent.setChildIndex(_loc3_.mc,Math.min(_loc1_,_loc3_.mc.parent.numChildren - 1));
               }
            }
            _loc1_++;
         }
         _childrenContainer.x = this._startWidth / 2;
         _childrenContainer.y = this._startHeight / 2;
         this._newScale = Math.min(1,Math.min((_width - this._memberWidth - this._spacing * 2) / this._totalWidth,(_height - this._memberHeight - this._spacing * 2) / this._totalHeight));
         this._newScale *= this.resizeScale;
         if(!this._rescaling)
         {
            Component.mainStage.addEventListener(Event.ENTER_FRAME,this.zoom);
         }
      }
      
      protected function zoom(param1:Event) : void
      {
         var _loc2_:Sprite = _childrenContainer;
         _loc2_.scaleX += (this._newScale - _loc2_.scaleX) / 3;
         _loc2_.scaleY += (this._newScale - _loc2_.scaleY) / 3;
         if(Math.abs(this._newScale - _loc2_.scaleX) < 1)
         {
            _loc2_.scaleX = _loc2_.scaleY = this._newScale;
            Component.mainStage.removeEventListener(Event.ENTER_FRAME,this.zoom);
            this._rescaling = false;
         }
         dragContainer.scaleX = this.markerContainer.scaleX = _loc2_.scaleX;
         dragContainer.scaleY = this.markerContainer.scaleY = _loc2_.scaleY;
      }
      
      public function checkSelectionVisibility(param1:CollectionItem) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.ignoreVisibility)
         {
            return;
         }
         if(this._members.indexOf(param1) >= 0)
         {
            if(this.usePagingDisplay)
            {
               _loc2_ = Math.floor(this._members.indexOf(param1) / this._itemsPerPage);
               this.gotoPage(_loc2_);
            }
            else if(_wrap)
            {
               _loc3_ = Position.getCellContentHeight(this);
               _parentCell.contentY = 0 - param1.y + _height / 2 - this._memberHeight / 2;
            }
            else
            {
               _loc4_ = Position.getCellContentWidth(this);
               if(param1.x > 0 - _parentCell.contentX + this._startWidth - this._memberWidth)
               {
                  _parentCell.contentX = 0 - param1.x + this._startWidth - this._memberWidth - this._spacing;
               }
               else if(param1.x < 0 - _parentCell.contentX)
               {
                  _parentCell.contentX = 0 - param1.x + this._spacing;
               }
            }
         }
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      protected function getIndexFromPosition(param1:Number, param2:Number) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.autoResize)
         {
            _loc4_ = (this._memberWidth + this._spacing) * (this._rowLength - 1);
            _loc5_ = 0;
            if(this._rowLength > 0)
            {
               _loc5_ = (this._memberHeight + this._spacing) * (Math.ceil(this._members.length / this._rowLength) - 1);
            }
            _loc3_ = Math.round((param2 + _loc5_ / 2) / (this._memberHeight + this._spacing)) * this._rowLength;
            _loc3_ += Math.min(this._rowLength,Math.max(0,Math.ceil((param1 + _loc4_ / 2) / (this._memberWidth + this._spacing))));
         }
         else
         {
            if(this._rowLength > 1)
            {
               param1 -= this._memberWidth / 2;
               param2 -= this._memberHeight / 2;
            }
            param1 /= this._memberWidth + this._spacing * 2;
            param2 /= this._memberHeight + this._spacing * 2;
            if(this._rowLength == 1)
            {
               _loc3_ = Math.floor(param2) * this._rowLength;
            }
            else
            {
               _loc3_ = Math.round(param2) * this._rowLength;
            }
            if(!_wrap)
            {
               _loc3_ = 0;
            }
            _loc3_ += Math.min(this._rowLength,Math.ceil(param1));
         }
         return int(Math.min(this._members.length,Math.max(0,_loc3_)));
      }
      
      protected function push(param1:CollectionItem) : uint
      {
         var _loc2_:uint = uint(this._members.push(param1));
         addChild(param1);
         this.arrange();
         return _loc2_;
      }
      
      protected function unshift(param1:CollectionItem) : uint
      {
         var _loc2_:uint = uint(this._members.unshift(param1));
         addChild(param1);
         this.arrange();
         return _loc2_;
      }
      
      protected function pop(param1:Boolean) : CollectionItem
      {
         var _loc2_:CollectionItem = this._members.pop();
         if(param1 != true)
         {
            removeChild(_loc2_);
         }
         this.arrange();
         return _loc2_;
      }
      
      protected function shift(param1:Boolean) : CollectionItem
      {
         var _loc2_:CollectionItem = this._members.shift();
         if(param1 != true)
         {
            removeChild(_loc2_);
         }
         this.arrange();
         return _loc2_;
      }
      
      protected function slice(param1:Number, param2:Number) : Array
      {
         return this._members.slice(param1,param2);
      }
      
      protected function splice(param1:Number, param2:Number, param3:Object, param4:Boolean) : Array
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         if(param1 == -1)
         {
            return null;
         }
         if(param3 == null)
         {
            _loc5_ = this._members.splice(param1,param2);
         }
         else
         {
            _loc5_ = this._members.splice(param1,param2,param3[0]);
            _loc6_ = 0;
            while(_loc6_ < this._members.length)
            {
               _loc6_++;
            }
         }
         if(param4 != true && param2 > 0)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               removeChild(_loc5_[_loc6_],false);
               _loc6_++;
            }
         }
         this.arrange();
         return _loc5_;
      }
      
      protected function concat(param1:Object) : Array
      {
         return this._members.concat(param1);
      }
      
      protected function join(param1:String) : String
      {
         return this._members.join(param1);
      }
      
      override public function toString() : String
      {
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this._members.length)
         {
            if(CollectionItem(this._members[_loc2_]).reference != null)
            {
               if(CollectionItem(this._members[_loc2_]).reference is String)
               {
                  _loc1_.push(CollectionItem(this._members[_loc2_]).reference);
               }
               else if(CollectionItem(this._members[_loc2_]).reference["toString"] is Function)
               {
                  _loc1_.push(CollectionItem(this._members[_loc2_]).reference.toString());
               }
            }
            _loc2_++;
         }
         return _loc1_.toString();
      }
      
      protected function reverse() : void
      {
         this._members.reverse();
         this.arrange();
      }
      
      protected function sort(param1:Object, param2:Number) : Array
      {
         var _loc3_:Array = this._members.sort(param1,param2);
         this.arrange();
         return _loc3_;
      }
      
      protected function sortOn(param1:Object, param2:Number) : Array
      {
         var _loc3_:Array = this._members.sortOn(param1,param2);
         this.arrange();
         return _loc3_;
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:CollectionItem = null;
         if(!this.allowKeyboardEvents)
         {
            return;
         }
         if(param1.charCode == 97 && param1.ctrlKey && this.allowMultiSelect)
         {
            this.selectObjects();
         }
         if(param1.charCode == 100 && param1.ctrlKey)
         {
            this.deselectObjects();
         }
         if(this._selectedMembers.length > 0)
         {
            if(param1.keyCode == Keyboard.SPACE)
            {
               if(CollectionItem(this._selectedMembers[0]).activateCallback != null)
               {
                  CollectionItem(this._selectedMembers[0]).activateCallback();
               }
            }
            if(this.allowRearrange)
            {
               if(param1.keyCode == Keyboard.RIGHT)
               {
                  if(param1.shiftKey)
                  {
                     this.placeSelectionAt(this._members.length);
                  }
                  else
                  {
                     this.placeSelectionAt(this._members.indexOf(this._selectedMembers[this._selectedMembers.length - 1]) + 2);
                  }
               }
               if(param1.keyCode == Keyboard.LEFT)
               {
                  if(param1.shiftKey)
                  {
                     this.placeSelectionAt(0);
                  }
                  else
                  {
                     this.placeSelectionAt(this._members.indexOf(this._selectedMembers[0]) - 1);
                  }
               }
               if(param1.keyCode == Keyboard.UP)
               {
                  if(param1.shiftKey)
                  {
                     this.placeSelectionAt(0);
                  }
                  else
                  {
                     this.placeSelectionAt(this._members.indexOf(this._selectedMembers[0]) - this._rowLength);
                  }
               }
               if(param1.keyCode == Keyboard.DOWN)
               {
                  if(param1.shiftKey)
                  {
                     this.placeSelectionAt(this._members.length);
                  }
                  else
                  {
                     this.placeSelectionAt(this._members.indexOf(this._selectedMembers[this._selectedMembers.length - 1]) + this._rowLength + 1);
                  }
               }
            }
            else
            {
               if(param1.keyCode == Keyboard.RIGHT)
               {
                  if(this._members.indexOf(this._selectedMembers[0]) < this._members.length - 1)
                  {
                     _loc2_ = this._members[Math.min(this._members.length - 1,this._members.indexOf(this._selectedMembers[0]) + 1)];
                  }
               }
               if(param1.keyCode == Keyboard.LEFT)
               {
                  if(this._members.indexOf(this._selectedMembers[0]) > 0)
                  {
                     _loc2_ = this._members[Math.max(0,this._members.indexOf(this._selectedMembers[0]) - 1)];
                  }
               }
               if(param1.keyCode == Keyboard.UP)
               {
                  _loc2_ = this._members[Math.max(0,this._members.indexOf(this._selectedMembers[0]) - this._rowLength)];
               }
               if(param1.keyCode == Keyboard.DOWN)
               {
                  _loc2_ = this._members[Math.min(this._members.length - 1,this._members.indexOf(this._selectedMembers[0]) + this._rowLength)];
               }
               if(_loc2_ != null && _loc2_ != this._selectedMembers[0])
               {
                  this.selectObject(_loc2_);
                  if(_loc2_.selectCallback != null)
                  {
                     _loc2_.selectCallback();
                  }
               }
            }
         }
      }
      
      protected function onKeyUp(param1:KeyboardEvent) : void
      {
         if(!this.allowRearrange || !this.allowKeyboardEvents)
         {
            return;
         }
         if(this._selectedMembers.length > 0)
         {
            if(param1.keyCode == Keyboard.BACKSPACE)
            {
               this._selectedMembers.reverse();
               this.placeSelectionAt(this._members.indexOf(this._selectedMembers[this._selectedMembers.length - 1]) + 1);
            }
            if(param1.keyCode == Keyboard.DELETE)
            {
               this.deleteSelectedObjects();
               mainStage.focus = this.mc;
            }
         }
         if(this.clipboard != null && this.clipboard.length > 0)
         {
            if(param1.charCode == 122 && param1.ctrlKey)
            {
               this.restoreMembers();
            }
         }
      }
      
      protected function onMemberClick(param1:Event) : void
      {
         var _loc2_:CollectionItem = CollectionItem(param1.target);
         this.selectObject(_loc2_);
      }
      
      public function selectPrevious(param1:MouseEvent = null) : void
      {
         var _loc2_:CollectionItem = null;
         if(this._selectedMembers.length > 0)
         {
            _loc2_ = this._members[Math.max(0,this._members.indexOf(this._selectedMembers[0]) - 1)];
         }
         if(_loc2_ != null)
         {
            this.selectObject(_loc2_);
            if(_loc2_.selectCallback != null)
            {
               _loc2_.selectCallback();
            }
         }
      }
      
      public function selectNext(param1:MouseEvent = null) : void
      {
         var _loc2_:CollectionItem = null;
         if(this._selectedMembers.length > 0)
         {
            _loc2_ = this._members[Math.min(this._members.length - 1,this._members.indexOf(this._selectedMembers[0]) + 1)];
         }
         if(_loc2_ != null)
         {
            this.selectObject(_loc2_);
            if(_loc2_.selectCallback != null)
            {
               _loc2_.selectCallback();
            }
         }
      }
      
      public function trackDraggedItem(param1:Event) : void
      {
         this.startDrag(param1);
      }
      
      public function endTrackDraggedItem(param1:Event) : void
      {
         this.stopDrag(param1);
      }
      
      override protected function startDrag(param1:Event) : void
      {
         var _loc2_:Point = null;
         var _loc3_:CollectionItem = null;
         var _loc4_:int = 0;
         var _loc5_:Matrix = null;
         var _loc6_:Rectangle = null;
         if(this._isDragging)
         {
            return;
         }
         if(sourceCollection == this)
         {
            dispatchEvent(new Event(EVENT_DRAG));
         }
         else
         {
            this.deselectObjects();
         }
         destCollection = null;
         mainStage.addEventListener(MouseEvent.MOUSE_MOVE,this.dragFollow,false,0,true);
         if(this.allowRearrange)
         {
            mainStage.addEventListener(Event.ENTER_FRAME,this.checkHover,false,0,true);
         }
         this._isDragging = true;
         this._mouseXold = _mc.mouseX;
         this._mouseYold = _mc.mouseY;
         this.membersMouseEnabled = false;
         if(sourceCollection == this)
         {
            if(this.allowRemoveOnDrag || this.useRotateEffectOnDrag)
            {
               if(mainStage.getChildIndex(dragContainer) < mainStage.numChildren - 1)
               {
                  mainStage.setChildIndex(dragContainer,mainStage.numChildren - 1);
               }
               _loc2_ = new Point(0,0);
               _loc2_ = _childrenContainer.localToGlobal(_loc2_);
               dragContainer.x = _loc2_.x;
               dragContainer.y = _loc2_.y;
               dragContainer.scaleX = _childrenContainer.scaleX;
               dragContainer.scaleY = _childrenContainer.scaleY;
               _loc4_ = int(this._selectedMembers.length - 1);
               while(_loc4_ >= 0)
               {
                  _loc3_ = this._selectedMembers[_loc4_];
                  if(this.useRotateEffectOnDrag)
                  {
                     _loc3_.rotation = 10 - Math.random() * 20;
                  }
                  dragContainer.addChild(_loc3_.mc);
                  _loc3_.isDragging = true;
                  _loc4_--;
               }
            }
            else
            {
               for each(_loc3_ in this._members)
               {
                  _loc3_.hide();
               }
               for each(_loc3_ in this._selectedMembers)
               {
                  _loc3_.show();
               }
               if(dragGhostSnapshot != null && dragGhostSnapshot.bitmapData != null)
               {
                  dragGhostSnapshot.bitmapData.dispose();
               }
               dragGhostSnapshot.bitmapData = new BitmapData(Math.min(mainStage.stageWidth,_width),Math.min(mainStage.stageHeight,_height),true,0);
               _loc2_ = new Point(0,0);
               _loc2_ = _mc.globalToLocal(_loc2_);
               _loc2_.x = Math.max(0,_loc2_.x);
               _loc2_.y = Math.max(0,_loc2_.y);
               _loc5_ = new Matrix(1,0,0,1,0 - _loc2_.x,0 - _loc2_.y);
               _loc6_ = new Rectangle(0,0,Math.min(mainStage.stageWidth,_width),Math.min(mainStage.stageHeight,_height));
               dragGhostSnapshot.bitmapData.draw(_mc,_loc5_,new ColorTransform(),null,_loc6_);
               dragGhost.visible = true;
               dragGhost.alpha = 0.5;
               dragGhost.x = dragContainer.mouseX;
               dragGhost.y = dragContainer.mouseY;
               dragGhostSnapshot.x = 0 - _mc.mouseX + _loc2_.x;
               dragGhostSnapshot.y = 0 - _mc.mouseY + _loc2_.y;
               for each(_loc3_ in this._members)
               {
                  _loc3_.show();
               }
            }
         }
      }
      
      override protected function stopDrag(param1:Event) : void
      {
         var _loc2_:CollectionItem = null;
         var _loc3_:Number = NaN;
         this.dropPoint.x = _mc.mouseX;
         this.dropPoint.y = _mc.mouseY;
         this.dropPoint = _mc.localToGlobal(this.dropPoint);
         if(sourceCollection == this)
         {
            dispatchEvent(new Event(EVENT_DROP));
         }
         mainStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragFollow);
         mainStage.removeEventListener(Event.ENTER_FRAME,this.checkHover);
         if(this.allowRemoveOnDrag || this.useRotateEffectOnDrag)
         {
            for each(_loc2_ in this._selectedMembers)
            {
               _childrenContainer.addChild(_loc2_.mc);
               _loc2_.isDragging = false;
            }
         }
         else
         {
            if(dragGhostSnapshot != null && dragGhostSnapshot.bitmapData != null)
            {
               dragGhostSnapshot.bitmapData.dispose();
            }
            dragGhost.visible = false;
         }
         this.membersMouseEnabled = true;
         if(this._isDragging)
         {
            this._isDragging = false;
            if(this.allowRearrange && _mc.mouseX > -10 && _mc.mouseY > -10 && _mc.mouseX - 10 < this.width && _mc.mouseY - 10 < this.height)
            {
               _loc3_ = this.getIndexFromPosition(_childrenContainer.mouseX,_childrenContainer.mouseY);
               this.placeSelectionAt(_loc3_);
            }
            else
            {
               this.arrange();
            }
         }
         this.markerContainer.graphics.clear();
      }
      
      protected function dragFollow(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._selectedMembers.length > 0)
         {
            if(this.allowRemoveOnDrag || this.useRotateEffectOnDrag)
            {
               _loc2_ = 0;
               while(_loc2_ < this._selectedMembers.length)
               {
                  if(this.useRotateEffectOnDrag)
                  {
                     CollectionItem(this._selectedMembers[_loc2_]).x = dragContainer.mouseX + Math.sin(_loc2_) * ((this._selectedMembers.length - _loc2_) * 5) - this._memberWidth / 2;
                     CollectionItem(this._selectedMembers[_loc2_]).y = dragContainer.mouseY + Math.cos(_loc2_) * ((this._selectedMembers.length - _loc2_) * 5) - this._memberHeight / 2;
                  }
                  else
                  {
                     CollectionItem(this._selectedMembers[_loc2_]).x = dragContainer.mouseX + _loc2_ * 10 - this._memberWidth / 2;
                     CollectionItem(this._selectedMembers[_loc2_]).y = dragContainer.mouseY + _loc2_ * 10 - this._memberHeight / 2;
                  }
                  _loc2_++;
               }
            }
            else
            {
               dragGhost.x = dragContainer.mouseX;
               dragGhost.y = dragContainer.mouseY;
            }
         }
         if(this.allowRearrange)
         {
            this.drawPlacementMarker();
         }
         this.dropPoint.x = _mc.mouseX;
         this.dropPoint.y = _mc.mouseY;
         this.dropPoint = _mc.localToGlobal(this.dropPoint);
         dispatchEvent(new Event(Component.EVENT_MOVE));
      }
      
      protected function drawPlacementMarker() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         if(_mc.mouseX > -10 && _mc.mouseX < this.width - 10 && _mc.mouseY > -10 && _mc.mouseY - 10 < this.height)
         {
            destCollection = this;
            this.markerContainer.x = _childrenContainer.x;
            this.markerContainer.y = _childrenContainer.y;
            _loc1_ = this.markerContainer.graphics;
            _loc1_.clear();
            if(this._members.length <= 1)
            {
               return;
            }
            _loc1_.beginFill(_style.linkColor,1);
            _loc2_ = this.getIndexFromPosition(_childrenContainer.mouseX,_childrenContainer.mouseY);
            _loc3_ = 0;
            _loc4_ = 0;
            if(this.autoResize)
            {
               _loc3_ = (this._memberWidth + this._spacing) * (_loc2_ % this._rowLength) - (this._totalWidth / 2 + this._memberWidth / 2 + this._spacing / 2);
               _loc4_ = (this._memberHeight + this._spacing) * Math.floor(_loc2_ / this._rowLength) - (this._totalHeight / 2 + this._memberHeight / 2 + this._spacing);
            }
            else if(_wrap)
            {
               _loc3_ = _loc2_ % this._rowLength * (this._memberWidth + this._spacing) - 1;
               _loc4_ = Math.floor(_loc2_ / this._rowLength) * (this._memberHeight + this._spacing);
            }
            else
            {
               _loc3_ = _loc2_ * (this._memberWidth + this._spacing * 2) - 1;
            }
            if(this.autoResize || _wrap)
            {
               if(_loc4_ > _loc2_ % this._rowLength * (this._memberWidth + this._spacing * 2))
               {
                  _loc3_ += this._rowLength * (this._memberWidth + this._spacing);
                  _loc4_ -= this._memberHeight + this._spacing;
               }
               else if(_loc2_ % this._rowLength == 0 && _loc2_ > 0)
               {
                  _loc5_ = _loc3_ + this._rowLength * (this._memberWidth + this._spacing);
                  _loc6_ = _loc4_ - this._memberHeight - this._spacing;
                  _loc7_ = new Point(_loc3_ - _childrenContainer.mouseX,_loc4_ - _childrenContainer.mouseY);
                  _loc8_ = new Point(_loc5_ - _childrenContainer.mouseX,_loc6_ - _childrenContainer.mouseY);
                  if(Math.abs(_loc7_.length) > Math.abs(_loc8_.length))
                  {
                     _loc3_ = _loc5_;
                     _loc4_ = _loc6_;
                  }
               }
            }
            if(this._rowLength <= 1)
            {
               _loc3_ = 0;
               _loc4_ = _loc2_ * (this._memberHeight + this._spacing);
            }
            if(this._members.length > 0 && this._members[0] is CollectionItem)
            {
               _loc3_ += CollectionItem(this._members[0]).position.margin_left;
               if(this._rowLength > 1)
               {
                  _loc3_ -= this._spacing / 2;
               }
            }
            _loc1_.beginFill(this.useBorderColorOnHighlight ? uint(_style.borderColor) : uint(_style.highlightTextColor));
            if(this._rowLength == 1 && _wrap)
            {
               _loc1_.drawRect(_loc3_,_loc4_ - 1,this._memberWidth,2);
            }
            else
            {
               _loc1_.drawRect(_loc3_,_loc4_ + this._spacing / 2,2,this._memberHeight);
            }
            destIndex = _loc2_;
         }
         else if(destCollection == this)
         {
            destCollection = null;
            _childrenContainer.graphics.clear();
         }
      }
      
      protected function checkHover(param1:Event) : void
      {
         if(Math.abs(this._mouseXold - _mc.mouseX) + Math.abs(this._mouseYold - _mc.mouseY) < 4)
         {
            if(_wrap)
            {
               if(_mc.mouseY > -20 && _mc.mouseY < 20 && _mc.mouseX >= 0 && _mc.mouseX <= _width)
               {
                  dispatchEvent(new Event(EVENT_HOVER_START));
               }
               if(_mc.mouseY < _height + 20 && _mc.mouseY > _height - 20 && _mc.mouseX >= 0 && _mc.mouseX <= _width)
               {
                  dispatchEvent(new Event(EVENT_HOVER_END));
               }
            }
            else
            {
               if(_mc.mouseX > -20 && _mc.mouseX < 20 && _mc.mouseY >= 0 && _mc.mouseY <= _height)
               {
                  dispatchEvent(new Event(EVENT_HOVER_START));
               }
               if(_mc.mouseX < _width + 20 && _mc.mouseX > _width - 20 && _mc.mouseY >= 0 && _mc.mouseY <= _height)
               {
                  dispatchEvent(new Event(EVENT_HOVER_END));
               }
            }
         }
         this._mouseXold = _mc.mouseX;
         this._mouseYold = _mc.mouseY;
      }
      
      protected function onSelectWindowStart(param1:MouseEvent) : void
      {
         if(!this.allowMultiSelect)
         {
            return;
         }
         this.membersMouseEnabled = false;
         Component.mainStage.addEventListener(MouseEvent.MOUSE_UP,this.onSelectWindowStop);
         Component.mainStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onSelectWindow);
         selectBox.x = mainStage.mouseX;
         selectBox.y = mainStage.mouseY;
         selectBox.visible = true;
         this._isSelecting = true;
         this._selectDrag = false;
         this.onSelectWindow(param1);
      }
      
      protected function onSelectWindow(param1:MouseEvent) : void
      {
         selectBox.scaleX = (mainStage.mouseX - selectBox.x) / 100;
         selectBox.scaleY = (mainStage.mouseY - selectBox.y) / 100;
         selectBox.visible = true;
         selectBox.alpha = selectBox.alpha == 1 ? 0.75 : 1;
         this._selectDrag = true;
         this.deselectObjects();
         var _loc2_:Number = 0;
         while(_loc2_ < this._members.length)
         {
            if(CollectionItem(this._members[_loc2_]).clip != null)
            {
               if(selectBox.hitTestObject(CollectionItem(this._members[_loc2_]).clip))
               {
                  this.selectObject(this._members[_loc2_]);
               }
            }
            else if(selectBox.hitTestObject(CollectionItem(this._members[_loc2_]).mc))
            {
               this.selectObject(this._members[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      protected function onSelectWindowStop(param1:MouseEvent) : void
      {
         var _loc2_:Component = null;
         for each(_loc2_ in childNodes)
         {
            _loc2_.mouseEnabled = true;
         }
         Component.mainStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onSelectWindow);
         Component.mainStage.removeEventListener(MouseEvent.MOUSE_UP,this.onSelectWindowStop);
         selectBox.width = selectBox.height = 100;
         selectBox.visible = false;
         this._isSelecting = true;
         this._selectDrag = false;
         this.setSelectionStartIndex();
         dispatchEvent(new Event(EVENT_SELECT));
      }
      
      public function placeSelectionAt(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         if(this._selectedMembers.length == this._members.length)
         {
            this._selectedMembers.reverse();
         }
         var _loc4_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < this._selectedMembers.length)
         {
            _loc5_ = int(this._members.indexOf(this._selectedMembers[_loc3_]));
            if(_loc5_ < param1)
            {
               param1--;
            }
            _loc4_.push(this.splice(_loc5_,1,null,true));
            _loc3_++;
         }
         if(param1 > this._members.length)
         {
            param1 = this._members.length;
         }
         param1 = Math.max(param1,0);
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            this.splice(param1,0,_loc4_[_loc3_],true);
            param1++;
            _loc3_++;
         }
         this.arrange(param2);
      }
      
      protected function selectionOrder(param1:CollectionItem, param2:CollectionItem) : Number
      {
         var _loc3_:int = int(this._members.indexOf(param1));
         var _loc4_:int = int(this._members.indexOf(param2));
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public function selectObjects(param1:int = -1, param2:int = -1) : void
      {
         var _loc3_:Number = NaN;
         this.deselectObjects();
         if(this._members.length > 0)
         {
            if(param1 == -1)
            {
               param1 = 0;
               if(param2 == -1)
               {
                  param2 = int(this._members.length - 1);
               }
            }
            if(param2 == -1)
            {
               param2 = param1;
            }
            _loc3_ = param1;
            while(_loc3_ <= param2)
            {
               this._selectedMembers.push(this._members[_loc3_]);
               if(this._members[_loc3_] is CollectionItem)
               {
                  CollectionItem(this._members[_loc3_]).select();
               }
               _loc3_++;
            }
         }
         if(selectedCollection != null && selectedCollection != this)
         {
            selectedCollection.deselectObjects();
         }
         selectedCollection = this;
         this.setSelectionStartIndex();
         dispatchEvent(new Event(EVENT_SELECT));
      }
      
      public function deselectObjects(param1:int = -1, param2:int = -1) : void
      {
         var _loc3_:Number = NaN;
         if(!this.allowDelete)
         {
            return;
         }
         if(this._selectedMembers.length > 0)
         {
            if(param1 == -1)
            {
               param1 = 0;
               if(param2 == -1)
               {
                  param2 = int(this._selectedMembers.length - 1);
               }
            }
            if(param2 == -1)
            {
               param2 = param1;
            }
            _loc3_ = param1;
            while(_loc3_ <= param2)
            {
               if(this._selectedMembers[_loc3_] is CollectionItem)
               {
                  CollectionItem(this._selectedMembers[_loc3_]).deselect();
               }
               _loc3_++;
            }
            this._selectedMembers.splice(param1,param2 + 1 - param1);
         }
         this.setSelectionStartIndex();
         dispatchEvent(new Event(EVENT_SELECT));
      }
      
      public function selectObject(param1:CollectionItem) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == null && Boolean(CollectionItem(this._members[0].multiselect)))
         {
            this.selectObjects();
         }
         else if(Key.shiftKey && this.allowMultiSelect)
         {
            if(this._selectedMembers.length > 0)
            {
               _loc2_ = int(this._members.indexOf(this._selectedMembers[0]));
            }
            else
            {
               _loc2_ = int(this._members.indexOf(param1));
            }
            _loc3_ = int(this._members.indexOf(param1));
            if(_loc2_ < _loc3_)
            {
               this.selectObjects(_loc2_,_loc3_);
            }
            else
            {
               this.selectObjects(_loc3_,_loc2_);
            }
            param1.select();
         }
         else if((Key.ctrlKey || this._selectDrag) && this.allowMultiSelect)
         {
            if(param1.selected)
            {
               _loc4_ = 0;
               while(_loc4_ < this._selectedMembers.length)
               {
                  if(this._selectedMembers[_loc4_] == param1)
                  {
                     this._selectedMembers.splice(_loc4_,1);
                  }
                  _loc4_++;
               }
               param1.deselect();
            }
            else
            {
               this._selectedMembers.push(param1);
               param1.select();
            }
         }
         else if(param1.selected)
         {
            this.deselectObjects();
         }
         else
         {
            this.selectObjects(this._members.indexOf(param1));
         }
         this._selectedMembers.sort(this.selectionOrder);
         if(selectedCollection != null && selectedCollection != this)
         {
            selectedCollection.deselectObjects();
         }
         selectedCollection = this;
         this.setSelectionStartIndex();
         if(!this._isSelecting)
         {
            dispatchEvent(new Event(EVENT_SELECT));
         }
      }
      
      protected function setSelectionStartIndex() : void
      {
         this._selectionIndex = this._selectedMembers.length > 0 ? int(this._members.indexOf(this._selectedMembers[0])) : -1;
      }
      
      public function deleteSelectedObjects() : void
      {
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this._selectedMembers.length)
         {
            _loc1_.push(CollectionItem(this._selectedMembers[_loc2_]).reference);
            _loc2_++;
         }
         this.removeMembers(this._selectedMembers.concat());
         this._selectedMembers = [];
         dispatchEvent(new ObjectEvent(EVENT_DELETE,false,false,_loc1_));
         dispatchEvent(new Event(EVENT_LIST_CHANGE));
         this.setSelectionStartIndex();
         dispatchEvent(new Event(EVENT_SELECT));
      }
      
      protected function onMasterAdd(param1:ObjectEvent) : void
      {
         if(this.getItem(param1.object) == null)
         {
            this.addMembers([param1.object]);
         }
      }
      
      protected function onMasterChange(param1:Event = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:CollectionItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._masterCollection.members.length)
         {
            _loc3_ = CollectionItem(this._masterCollection.members[_loc2_]).reference;
            if(_loc3_ != null)
            {
               _loc4_ = this.getItem(_loc3_);
               if(_loc4_ != null)
               {
                  _loc4_.idx = _loc2_;
               }
               else
               {
                  (_loc4_ = this.addMember(_loc3_)).idx = _loc2_;
               }
            }
            _loc2_++;
         }
         this._members.sortOn("idx",Array.NUMERIC);
         this.arrange();
      }
      
      protected function onMasterDelete(param1:ObjectEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:CollectionItem = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1.object)
         {
            _loc4_ = this.getItem(_loc3_);
            if(_loc4_ != null)
            {
               _loc2_.push(_loc4_);
            }
         }
         if(_loc2_.length > 0)
         {
            this.removeMembers(_loc2_);
         }
      }
      
      protected function onMasterRestore(param1:ObjectEvent) : void
      {
         this.restoreMembers();
      }
      
      protected function onMasterClear(param1:Event) : void
      {
         this.clear();
      }
      
      public function prevPage(param1:Event) : void
      {
         if(this.usePagingDisplay)
         {
            if(this._currentPage > 1)
            {
               --this._currentPage;
               this._pageX = 0 - this._pageWidth * (this._currentPage - 1);
               this.startTween();
            }
         }
      }
      
      public function nextPage(param1:Event) : void
      {
         if(this.usePagingDisplay)
         {
            if(this._currentPage < this.totalPages)
            {
               ++this._currentPage;
               this._pageX = 0 - this._pageWidth * (this._currentPage - 1);
               this.startTween();
            }
         }
      }
      
      public function gotoPage(param1:int) : void
      {
         if(this.usePagingDisplay)
         {
            if(param1 > 0 && param1 <= this.totalPages)
            {
               this._currentPage = param1;
               this._pageX = 0 - this._pageWidth * (param1 - 1);
               this.startTween();
            }
         }
      }
      
      public function gotoItemPage(param1:CollectionItem) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.usePagingDisplay && param1 != null)
         {
            _loc2_ = int(this._members.indexOf(param1));
            if(_loc2_ >= 0)
            {
               _loc3_ = _loc2_ / this._itemsPerPage + 1;
               this.gotoPage(_loc3_);
            }
         }
      }
      
      protected function startTween() : void
      {
         if(!this._isTweening)
         {
            mainStage.addEventListener(Event.ENTER_FRAME,this.tween);
            this._isTweening = true;
         }
      }
      
      protected function tween(param1:Event) : void
      {
         if(_deleted)
         {
            this.stopTween();
            return;
         }
         _childrenContainer.x += (this._pageX - _childrenContainer.x) / this._tweenRate;
         if(Math.abs(this._pageX - _childrenContainer.x) < 1)
         {
            _childrenContainer.x = this._pageX;
            this.stopTween();
         }
      }
      
      protected function stopTween() : void
      {
         mainStage.removeEventListener(Event.ENTER_FRAME,this.tween);
         this._isTweening = false;
      }
      
      override public function clear() : void
      {
         super.clear();
         this._members = [];
         this._selectedMembers = [];
         this.clipboard = [];
         dispatchEvent(new Event(EVENT_CLEAR));
         dispatchEvent(new Event(EVENT_LIST_CHANGE));
      }
      
      override public function destroy() : Boolean
      {
         return super.destroy();
      }
   }
}

