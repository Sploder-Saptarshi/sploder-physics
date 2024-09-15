package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class Cell extends Component
   {
      private static var _focused:Cell;
      
      protected var _background:Boolean = true;
      
      protected var _border:Boolean = true;
      
      protected var _round:Number = 0;
      
      protected var _bkgd:Sprite;
      
      protected var _childrenContainer:Sprite;
      
      protected var _mask:Sprite;
      
      protected var _maskContent:Boolean = false;
      
      public var fixedContentSize:Boolean = false;
      
      protected var _wrap:Boolean = true;
      
      protected var _collapse:Boolean = false;
      
      protected var _scrollable:Boolean = false;
      
      protected var _childNodes:Array;
      
      protected var _sortChildNodes:Boolean = false;
      
      protected var _mouseWentOver:Boolean = false;
      
      public var hideOnlyAfterMouseOver:Boolean = false;
      
      protected var _hideOnMouseOut:Boolean = false;
      
      public var lastArrangedChildIndex:Number = -1;
      
      public var lastArrangedChildX:Number = 0;
      
      public var lastArrangedChildY:Number = 0;
      
      protected var _title_tf:TextField;
      
      public function Cell(param1:Sprite = null, param2:Number = NaN, param3:Number = NaN, param4:Boolean = false, param5:Boolean = false, param6:Number = 0, param7:Position = null, param8:Style = null)
      {
         super();
         this.init_Cell(param1,param2,param3,param4,param5,param6,param7,param8);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public static function get focused() : Cell
      {
         return _focused;
      }
      
      public static function set focused(param1:Cell) : void
      {
         if(Boolean(_focused) && param1 != _focused)
         {
            _focused.onBlur();
         }
         _focused = param1;
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set background(param1:Boolean) : void
      {
         this._background = param1;
         this.redraw(true);
      }
      
      public function get bkgd() : Sprite
      {
         return this._bkgd;
      }
      
      public function set bkgd(param1:Sprite) : void
      {
         if(this._bkgd != null && this._bkgd.parent == _mc)
         {
            _mc.removeChild(this._bkgd);
         }
         this._bkgd = param1;
         if(this._bkgd != null)
         {
            _mc.addChildAt(this._bkgd,0);
         }
      }
      
      public function set mouseChildren(param1:Boolean) : void
      {
         this._childrenContainer.mouseChildren = param1;
      }
      
      public function get maskContent() : Boolean
      {
         return this._maskContent;
      }
      
      public function set maskContent(param1:Boolean) : void
      {
         this._maskContent = param1;
         if(this._maskContent && _created)
         {
            this.createMask();
         }
         else if(_created)
         {
            this._childrenContainer.mask = null;
         }
      }
      
      override public function get width() : uint
      {
         if(_width == 0)
         {
            return _mc.width;
         }
         return _width;
      }
      
      override public function get height() : uint
      {
         if(_height == 0)
         {
            return _mc.height;
         }
         return _height;
      }
      
      public function get contentWidth() : Number
      {
         if(this.fixedContentSize)
         {
            return _width;
         }
         return Position.getCellContentWidth(this);
      }
      
      public function get contentHeight() : Number
      {
         if(this.fixedContentSize)
         {
            return _height;
         }
         return Position.getCellContentHeight(this);
      }
      
      public function get contentX() : Number
      {
         return this._childrenContainer.x;
      }
      
      public function set contentX(param1:Number) : void
      {
         if(!isNaN(param1))
         {
            this._childrenContainer.x = Math.min(0,Math.max(param1,0 - Position.getCellContentWidth(this) + _width));
         }
      }
      
      public function get contentY() : Number
      {
         return this._childrenContainer.y;
      }
      
      public function set contentY(param1:Number) : void
      {
         if(!isNaN(param1))
         {
            this._childrenContainer.y = Math.min(0,Math.max(param1,0 - Position.getCellContentHeight(this) + _height));
         }
      }
      
      public function get wrap() : Boolean
      {
         return this._wrap;
      }
      
      public function set wrap(param1:Boolean) : void
      {
         this._wrap = param1;
         Position.arrangeContent(this,true);
      }
      
      public function get collapse() : Boolean
      {
         return this._collapse;
      }
      
      public function set collapse(param1:Boolean) : void
      {
         this._collapse = param1;
      }
      
      public function get scrollable() : Boolean
      {
         return this._scrollable;
      }
      
      public function set scrollable(param1:Boolean) : void
      {
         this._scrollable = param1;
      }
      
      public function get trapMouse() : Boolean
      {
         return this._bkgd.mouseEnabled;
      }
      
      public function set trapMouse(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._background == false)
            {
               DrawingMethods.rect(this._bkgd,true,0,0,_width,_height,0,0);
            }
            this._bkgd.useHandCursor = false;
            this._bkgd.mouseEnabled = true;
         }
         else
         {
            this._bkgd.mouseEnabled = false;
            this._bkgd.useHandCursor = true;
         }
      }
      
      public function get childNodes() : Array
      {
         return this._childNodes;
      }
      
      public function get sortChildNodes() : Boolean
      {
         return this._sortChildNodes;
      }
      
      public function get hideOnMouseOut() : Boolean
      {
         return this._hideOnMouseOut;
      }
      
      public function set hideOnMouseOut(param1:Boolean) : void
      {
         if(this._hideOnMouseOut)
         {
            if(_mc)
            {
               _mc.removeEventListener(MouseEvent.MOUSE_OVER,this.markMouseOver);
            }
            Component.mainStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.checkMouseForHide);
         }
         this._hideOnMouseOut = param1;
         if(this._hideOnMouseOut)
         {
            if(_mc)
            {
               _mc.addEventListener(MouseEvent.MOUSE_OVER,this.markMouseOver);
            }
            Component.mainStage.addEventListener(MouseEvent.MOUSE_MOVE,this.checkMouseForHide);
         }
      }
      
      public function get contents() : Sprite
      {
         return this._childrenContainer;
      }
      
      protected function init_Cell(param1:Sprite, param2:Number = NaN, param3:Number = NaN, param4:Boolean = false, param5:Boolean = false, param6:Number = 0, param7:Position = null, param8:Style = null) : void
      {
         super.init(param1,param7,param8);
         _type = "cell";
         _width = !isNaN(param2) ? param2 : _width;
         _height = !isNaN(param3) ? param3 : _height;
         this._background = param4;
         this._border = param5;
         this._round = param6 > 0 ? param6 : 0;
         this._childNodes = [];
      }
      
      override public function create() : void
      {
         super.create();
         if(_parentCell != null)
         {
            if(_width == 0)
            {
               _width = _parentCell.width - _position.margin_left - _position.margin_right;
            }
            if(_height == 0 && !_position.collapse)
            {
               _height = _parentCell.height - _position.margin_top - _position.margin_bottom;
            }
            _parentCell.addEventListener(EVENT_BLUR,this.onBlur);
         }
         this._bkgd = Sprite(_mc.addChild(new Sprite()));
         this.drawBackground();
         this._childrenContainer = Sprite(_mc.addChild(new Sprite()));
         this._childrenContainer.name = _mc.name + "_childContainer";
         if(this._maskContent)
         {
            this.createMask();
         }
         _mc.x = _position.margin_top;
         _mc.y = _position.margin_left;
         var _loc1_:int = 0;
         while(_loc1_ < this._childNodes.length)
         {
            Component(this.childNodes[_loc1_]).parentCell = this;
            _loc1_++;
         }
      }
      
      protected function drawBackground() : void
      {
         this._bkgd.graphics.clear();
         if(this._background && this._round > 0)
         {
            Create.background(this._bkgd,_width,_height,_style,this._border,this._round);
         }
         else if(this._border && !this._background)
         {
            DrawingMethods.emptyRect(this._bkgd,false,0,0,_width,_height,_style.borderWidth,_style.borderColor,_style.borderAlpha);
         }
         else if(this._background)
         {
            Create.background(this._bkgd,_width,_height,_style,this._border,this._round);
         }
      }
      
      private function createMask() : void
      {
         if(this._mask == null)
         {
            this._mask = Sprite(_mc.addChild(new Sprite()));
         }
         this._mask.graphics.clear();
         if(this._border)
         {
            DrawingMethods.rect(this._mask,false,_style.borderWidth,_style.borderWidth,_width - _style.borderWidth * 2,_height - _style.borderWidth * 2,_style.backgroundColor);
         }
         else
         {
            DrawingMethods.rect(this._mask,false,0,0,_width,_height);
         }
         this._mask.visible = false;
         this._childrenContainer.mask = this._mask;
      }
      
      public function resizeCell(param1:uint, param2:uint) : void
      {
         _width = param1;
         _height = param2;
         if(this._maskContent)
         {
            this.createMask();
         }
         this.drawBackground();
      }
      
      private function redraw(param1:Boolean = false) : void
      {
         if(_container != null && (param1 || this._collapse || _position.collapse))
         {
            if(!this.fixedContentSize && (this._collapse || _position.collapse))
            {
               if(isNaN(_width))
               {
                  _width = 0;
               }
               _width = Math.max(_width,Position.getCellContentWidth(this) + _style.borderWidth * 2);
               _height = Position.getCellContentHeight(this) + _style.borderWidth * 2 + _style.padding;
               if(this._maskContent)
               {
                  this.createMask();
               }
            }
            this.drawBackground();
         }
      }
      
      public function update(param1:Boolean = false) : void
      {
         _height = Position.getCellContentHeight(this);
         if(param1)
         {
            _width = Position.getCellContentWidth(this);
         }
         this.redraw();
      }
      
      public function addChild(param1:Component) : Component
      {
         if(param1.created)
         {
            if(param1.mc.parent == null)
            {
               this._childrenContainer.addChild(param1.mc);
               return param1;
            }
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._childNodes.length)
         {
            if(this._childNodes[_loc2_] == param1)
            {
               return param1;
            }
            _loc2_++;
         }
         this._childNodes.push(param1);
         param1.parentCell = this;
         param1.addEventListener(EVENT_FOCUS,this.onChildFocus);
         param1.addEventListener(EVENT_CHANGE,this.onChildChange);
         param1.addEventListener(EVENT_CLICK,this.onChildClick);
         if(param1.position.zindex != 1)
         {
            this._sortChildNodes = true;
         }
         Position.arrangeContent(this);
         this.redraw();
         dispatchEvent(new Event(EVENT_CHANGE));
         return param1;
      }
      
      public function removeChild(param1:Component, param2:Boolean = true) : Boolean
      {
         var _loc3_:int = int(this._childNodes.length - 1);
         while(_loc3_ >= 0)
         {
            if(this._childNodes[_loc3_] == param1)
            {
               this._childNodes.splice(_loc3_,1);
               Position.arrangeContent(this);
               dispatchEvent(new Event(EVENT_CHANGE));
               if(param2)
               {
                  return param1.destroy();
               }
               if(param1.mc.parent == this._childrenContainer)
               {
                  this._childrenContainer.removeChild(param1.mc);
               }
               else if(param1.parentCell == this && param1.mc.parent != null)
               {
                  param1.mc.parent.removeChild(param1.mc);
               }
               return true;
            }
            _loc3_--;
         }
         return false;
      }
      
      public function clear() : void
      {
         var _loc1_:int = int(this._childNodes.length - 1);
         while(_loc1_ >= 0)
         {
            this.removeChild(Component(this._childNodes[_loc1_]),true);
            _loc1_--;
         }
         this.lastArrangedChildIndex = -1;
         this.lastArrangedChildX = this.lastArrangedChildY = 0;
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      public function onChildFocus(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._childNodes.length)
         {
            if(this._childNodes[_loc2_] != param1.target)
            {
               if(this._childNodes[_loc2_] is Cell)
               {
                  Cell(this._childNodes[_loc2_]).onBlur();
               }
            }
            _loc2_++;
         }
      }
      
      public function onChildChange(param1:Event) : void
      {
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      public function onChildClick(param1:Event) : void
      {
         dispatchEvent(new Event(EVENT_CLICK));
      }
      
      override public function enable(param1:Event = null) : void
      {
         super.enable();
         var _loc2_:int = int(this._childNodes.length - 1);
         while(_loc2_ >= 0)
         {
            Component(this._childNodes[_loc2_]).enable();
            _loc2_--;
         }
      }
      
      override public function disable(param1:Event = null) : void
      {
         super.disable();
         var _loc2_:int = int(this._childNodes.length - 1);
         while(_loc2_ >= 0)
         {
            Component(this._childNodes[_loc2_]).disable();
            _loc2_--;
         }
      }
      
      override public function show(param1:Event = null) : void
      {
         super.show(param1);
         this._mouseWentOver = false;
      }
      
      override public function hide(param1:Event = null) : void
      {
         this._mouseWentOver = false;
         if(_mc != null)
         {
            _mc.visible = false;
         }
         dispatchEvent(new Event(EVENT_BLUR));
         var _loc2_:int = int(this._childNodes.length - 1);
         while(_loc2_ >= 0)
         {
            Component(this._childNodes[_loc2_]).dispatchEvent(new Event(EVENT_BLUR));
            _loc2_--;
         }
      }
      
      public function onBlur(param1:Event = null) : void
      {
         if(_mc != null && !_mc.visible)
         {
            return;
         }
         dispatchEvent(new Event(EVENT_BLUR));
      }
      
      protected function markMouseOver(param1:MouseEvent) : void
      {
         this._mouseWentOver = true;
      }
      
      protected function checkMouseForHide(param1:MouseEvent) : void
      {
         if(!visible)
         {
            return;
         }
         if(this.hideOnlyAfterMouseOver && !this._mouseWentOver)
         {
            return;
         }
         var _loc2_:Number = -40;
         var _loc3_:Number = 40 + _width;
         var _loc4_:Number = -40;
         var _loc5_:Number = 40 + _height;
         if(_mc.mouseX < _loc2_ || _mc.mouseX > _loc3_ || _mc.mouseY < _loc4_ || _mc.mouseY > _loc5_)
         {
            this.hide();
         }
      }
      
      public function allowCellDrag(param1:Boolean = true, param2:Boolean = false) : void
      {
         var _loc3_:Sprite = null;
         if(!_draggable)
         {
            _draggable = true;
            if(this._background == false)
            {
               this._bkgd.graphics.lineStyle(0,0,0);
               this._bkgd.graphics.beginFill(_style.borderColor,0.75);
               this._bkgd.graphics.drawCircle(_style.round + _style.borderWidth,_style.round + _style.borderWidth,3);
            }
            _mc.addEventListener(MouseEvent.MOUSE_DOWN,this.startDrag);
            _mc.addEventListener(MouseEvent.MOUSE_UP,this.stopDrag);
            if(param1)
            {
               _mc.addEventListener(MouseEvent.MOUSE_OUT,this.stopDrag);
            }
            if(param2)
            {
               _loc3_ = new Sprite();
               this._bkgd.addChild(_loc3_);
               Create.dragArea(_loc3_,_width - 12,24,_style);
               _loc3_.x = 6;
               _loc3_.y = _height - 30;
               _loc3_.mouseEnabled = false;
            }
         }
      }
      
      protected function startDrag(param1:Event) : void
      {
         if(param1.target == this._bkgd)
         {
            _mc.startDrag();
         }
      }
      
      protected function stopDrag(param1:Event) : void
      {
         _mc.stopDrag();
      }
   }
}

