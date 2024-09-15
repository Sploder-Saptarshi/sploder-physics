package com.sploder.asui
{
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class CollectionItem extends Cell
   {
      protected var _oldx:Number = 0;
      
      protected var _oldy:Number = 0;
      
      protected var _oldz:Number = 0;
      
      protected var _oldr:Number = 0;
      
      protected var _newx:Number = 0;
      
      protected var _newy:Number = 0;
      
      protected var _newz:Number = 0;
      
      protected var _newr:Number = 0;
      
      protected var _dragx:Number = 0;
      
      protected var _dragy:Number = 0;
      
      private var _alt:String = "";
      
      protected var _collection:Collection;
      
      protected var _selected:Boolean = false;
      
      protected var _justSelected:Boolean = false;
      
      protected var _backing:Sprite;
      
      protected var _highlight:Sprite;
      
      protected var _altTimes:int = 0;
      
      protected var _pressX:Number = 0;
      
      protected var _pressY:Number = 0;
      
      protected var _isDragging:Boolean = false;
      
      protected var _isTweening:Boolean = false;
      
      protected var _tweenRate:Number = 3;
      
      protected var _clipContainer:Container;
      
      public var selectCallback:Function;
      
      public var activateCallback:Function;
      
      protected var _reference:Object;
      
      public var idx:int = 0;
      
      public function CollectionItem(param1:Collection, param2:Object, param3:Number, param4:Number, param5:Position = null, param6:Style = null)
      {
         super();
         this.init_CollectionItem(param1,param2,param3,param4,param5,param6);
         if(_container != null)
         {
            this.create();
         }
      }
      
      override public function get x() : Number
      {
         return this._isDragging && this._collection.allowRemoveOnDrag ? this._dragx : this._newx;
      }
      
      override public function set x(param1:Number) : void
      {
         if(!_deleted)
         {
            this._oldx = _mc.x;
            this._newx = param1;
            this.startTween();
         }
      }
      
      override public function get y() : Number
      {
         return this._isDragging && this._collection.allowRemoveOnDrag ? this._dragy : this._newy;
      }
      
      override public function set y(param1:Number) : void
      {
         if(!_deleted)
         {
            this._oldy = _mc.y;
            this._newy = param1;
            this.startTween();
         }
      }
      
      override public function get rotation() : Number
      {
         return this._newr;
      }
      
      override public function set rotation(param1:Number) : void
      {
         if(!_deleted)
         {
            this._oldr = _mc.rotation;
            this._newr = param1;
            this.startTween();
         }
      }
      
      public function get alt() : String
      {
         return this._alt;
      }
      
      public function set alt(param1:String) : void
      {
         this._alt = param1;
      }
      
      public function get collection() : Collection
      {
         return this._collection;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this.updateClip();
      }
      
      public function get isDragging() : Boolean
      {
         return this._isDragging;
      }
      
      public function set isDragging(param1:Boolean) : void
      {
         this._isDragging = param1;
         if(this._isDragging)
         {
            this._dragx = _mc.x;
            this._dragy = _mc.y;
         }
      }
      
      public function get clip() : DisplayObject
      {
         return this._clipContainer.clip;
      }
      
      public function set clip(param1:DisplayObject) : void
      {
         var obj:DisplayObject = param1;
         this._clipContainer.clip = obj;
         if(this._clipContainer.clip != null)
         {
            try
            {
               if(this._clipContainer.clip["btn"] is SimpleButton)
               {
                  connectSimpleButton(this._clipContainer.clip["btn"],true,true);
                  if(this._backing != null)
                  {
                     this._backing.parent.removeChild(this._backing);
                     this._backing = null;
                  }
               }
               if(this._clipContainer.clip["highlight"] != null)
               {
                  if(this._highlight != null && this._highlight.parent != null)
                  {
                     this._highlight.parent.removeChild(this._highlight);
                  }
                  this._highlight = this._clipContainer.clip["highlight"];
                  this._highlight.alpha = 0;
               }
            }
            catch(e:Error)
            {
               if(_clipContainer.clip is Sprite)
               {
                  Sprite(_clipContainer.clip).mouseEnabled = false;
                  Sprite(_clipContainer.clip).mouseChildren = false;
               }
            }
         }
         if(this._clipContainer.clip.width < _width)
         {
            this._clipContainer.clip.x = Math.floor((_width - this._clipContainer.clip.width) / 2);
         }
         if(this._clipContainer.clip.height < _height)
         {
            this._clipContainer.clip.y = Math.floor((_height - this._clipContainer.clip.height) / 2);
         }
      }
      
      public function get reference() : Object
      {
         return this._reference;
      }
      
      public function set reference(param1:Object) : void
      {
         this._reference = param1;
      }
      
      protected function init_CollectionItem(param1:Collection, param2:Object, param3:Number, param4:Number, param5:Position = null, param6:Style = null) : void
      {
         super.init_Cell(null,param3,param4,false,false,0,param5,param6);
         this._collection = param1;
         this._reference = param2;
         _width = !isNaN(param3) ? param3 : this.clip.width;
         _height = !isNaN(param4) ? param4 : this.clip.height;
         _type = "collectionitem";
      }
      
      override public function create() : void
      {
         var backingStyle:Style;
         var bw:Number;
         var bgc:Array = null;
         var bga:Array = null;
         var bgr:Array = null;
         var ref:String = null;
         var icon:String = null;
         var link:String = null;
         var hh:HTMLField = null;
         var bb:BButton = null;
         var cc:Clip = null;
         var hh2:HTMLField = null;
         var lb:BButton = null;
         super.create();
         this._clipContainer = new Container(null);
         addChild(this._clipContainer);
         backingStyle = _style.clone();
         backingStyle.border = false;
         backingStyle.background = false;
         backingStyle.round = 0;
         this._backing = new Sprite();
         if(_style.background)
         {
            if(_style.bgGradient)
            {
               bgc = _style.bgGradientColors;
               bgr = _style.bgGradientRatios;
            }
            else
            {
               bgc = [_style.backgroundColor];
               bga = [_style.backgroundAlpha];
            }
         }
         else
         {
            bgc = [16777215];
            bga = [0.2];
         }
         DrawingMethods.roundedRect(this._backing,true,0,0,_width,_height,"" + _style.round,bgc,bga,bgr,null);
         bw = Math.max(2,Math.floor(_style.borderWidth / 2));
         if(_style.border && _style.borderWidth > 0)
         {
            DrawingMethods.roundedRect(this._backing,false,bw / 2,bw / 2,_width - bw,_height - bw,"" + (_style.round - 1),[0],[0],null,null,_style.borderWidth,_style.borderColor,0.5);
         }
         connectButton(this._backing,true);
         _mc.addChild(this._backing);
         _mc.setChildIndex(this._backing,0);
         if(this._collection.showHighlight)
         {
            this._highlight = new Sprite();
            DrawingMethods.roundedRect(this._highlight,true,bw / 2,bw / 2,_width - bw,_height - bw,"" + (_style.round - 1),[0],[0],null,null,_style.borderWidth,this._collection.useBorderColorOnHighlight ? _style.borderColor : _style.highlightTextColor,1);
            this._highlight.alpha = 0;
            this._highlight.mouseEnabled = false;
            _mc.addChild(this._highlight);
         }
         if(this._reference is DisplayObject)
         {
            this.clip = DisplayObject(this._reference);
         }
         else if(this._collection.defaultItemComponent)
         {
            _childrenContainer.mouseEnabled = false;
            ref = "";
            icon = "";
            link = "";
            if(this._reference is String)
            {
               ref = icon = String(this._reference);
            }
            else if(Boolean(this._reference) && Boolean(this._reference.title))
            {
               ref = this._reference.title;
            }
            _value = ref.toLowerCase().split(" ").join("_");
            if(this._reference.value)
            {
               _value = this._reference.value;
            }
            if(Boolean(this._reference) && Boolean(this._reference.icon))
            {
               icon = this._reference.icon;
            }
            if(Boolean(this._reference) && Boolean(this._reference.link))
            {
               link = this._reference.link;
            }
            switch(this._collection.defaultItemComponent)
            {
               case "HTMLField":
                  hh = new HTMLField(null,"<p>" + ref + "</p>",_width - _style.padding * 2,false,null,_style);
                  addChild(hh);
                  hh.x = _style.padding;
                  hh.y = _style.padding;
                  hh.mouseEnabled = false;
                  break;
               case "BButton":
                  bb = new BButton(null,ref,Position.ALIGN_LEFT,_width,_height,false,false,false,null,_style);
                  addChild(bb);
                  bb.mouseEnabled = false;
                  break;
               case "Clip":
                  if(_height < _width * 0.75)
                  {
                     cc = new Clip(null,icon,Clip.EMBED_SMART,Math.min(_width,_height) - _style.padding * 2,Math.min(_width,_height) - _style.padding * 2,Clip.SCALEMODE_FIT,"",false,"",null,_style);
                     cc.forceCentered = true;
                     if(icon.indexOf("/") != -1)
                     {
                        cc.forceBorder = true;
                     }
                     addChild(cc);
                     cc.x = Math.min(_width,_height) / 2;
                     cc.y = _height / 2;
                     cc.mouseEnabled = false;
                     if(ref != icon)
                     {
                        hh2 = new HTMLField(null,"<p>" + ref + "</p>",_width - _style.padding * 2 - cc.width,true,null,_style);
                        addChild(hh2);
                        hh2.x = _style.padding + cc.width / 2 + cc.x;
                        hh2.y = cc.y - hh2.height / 2;
                        hh2.mouseEnabled = false;
                     }
                     if(Boolean(link) && link.length > 0)
                     {
                        lb = new BButton(null,!!this._reference.credit ? {
                           "text":this._reference.credit,
                           "icon":Create.ICON_LAUNCH,
                           "first":"false"
                        } : Create.ICON_LAUNCH,-1,NaN,20,false,false,false,new Position({"placement":Position.PLACEMENT_ABSOLUTE}),_style.clone({
                           "background":false,
                           "border":0
                        }));
                        if(this._reference.credit)
                        {
                           lb.extraWidth = 5;
                        }
                        addChild(lb);
                        lb.x = _width - _style.padding - lb.width - _style.borderWidth;
                        lb.y = _height / 2 - lb.mc.height / 2;
                        lb.addEventListener(Component.EVENT_CLICK,function(param1:Event):void
                        {
                           var _loc2_:URLRequest = new URLRequest(link);
                           navigateToURL(_loc2_,"_blank");
                        });
                     }
                  }
                  else
                  {
                     cc = new Clip(null,icon,Clip.EMBED_SMART,_height - _style.padding * 2 - 20,_height - _style.padding * 2 - 20,Clip.SCALEMODE_FIT,"",false,"",null,_style);
                     addChild(cc);
                     cc.x = _width / 2;
                     cc.y = _height / 2 - 8;
                     cc.mouseEnabled = false;
                     if(ref != icon)
                     {
                        hh2 = new HTMLField(null,"<p align=\"center\">" + ref + "</p>",_width,false,null,_style);
                        addChild(hh2);
                        hh2.x = 0;
                        hh2.y = 6 + _height - hh2.height - _style.padding;
                        hh2.mouseEnabled = false;
                     }
                  }
            }
         }
         dispatchEvent(new Event(EVENT_CREATE));
      }
      
      protected function updateClip() : void
      {
         if(this._highlight != null)
         {
            this._highlight.alpha = this.selected ? 1 : 0;
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
         _mc.x += (this._newx - _mc.x) / this._tweenRate;
         _mc.y += (this._newy - _mc.y) / this._tweenRate;
         _mc.rotation += (this._newr - _mc.rotation) / this._tweenRate;
         if(Math.abs(this._newx - _mc.x) < 1 && Math.abs(this._newy - _mc.y) < 1)
         {
            _mc.x = this._newx;
            _mc.y = this._newy;
            _mc.rotation = this._newr;
            this.stopTween();
         }
      }
      
      protected function stopTween() : void
      {
         mainStage.removeEventListener(Event.ENTER_FRAME,this.tween);
         this._isTweening = false;
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function snapToPosition() : void
      {
         _mc.x = this._newx;
         _mc.y = this._newy;
         _mc.rotation = this._newr;
      }
      
      public function select() : void
      {
         this.selected = true;
         if(this._highlight != null)
         {
            this._highlight.alpha = 1;
         }
         active = true;
         if(this.selectCallback != null)
         {
            this.selectCallback.call();
         }
         this._tweenRate = 1.5;
      }
      
      public function deselect() : void
      {
         this.selected = false;
         if(this._highlight != null)
         {
            this._highlight.alpha = 0;
         }
         active = false;
         this._tweenRate = 3;
      }
      
      override protected function onPress(param1:MouseEvent = null) : void
      {
         this._pressX = _mc.mouseX;
         this._pressY = _mc.mouseY;
         if(!deleted && !this.selected)
         {
            this._collection.selectObject(this);
            this._justSelected = true;
         }
         _mc.focusRect = false;
         mainStage.focus = _mc;
         mainStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDrag,false,0,true);
         mainStage.addEventListener(MouseEvent.MOUSE_UP,this.onRelease,false,0,true);
      }
      
      protected function onDrag(param1:Event) : void
      {
         if(this._collection.allowDrag)
         {
            if(Math.abs(_mc.mouseX - this._pressX) > 10 || Math.abs(_mc.mouseY - this._pressY) > 10)
            {
               mainStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDrag);
               Collection.sourceCollection = this._collection;
               dispatchEvent(new Event(EVENT_DRAG));
               this._isDragging = true;
               if(this._collection.allowRemoveOnDrag)
               {
                  _mc.startDrag();
               }
            }
         }
      }
      
      override protected function onRelease(param1:MouseEvent = null) : void
      {
         mainStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDrag);
         mainStage.removeEventListener(MouseEvent.MOUSE_UP,this.onRelease);
         if(!deleted)
         {
            if(!this._isDragging && !this._justSelected)
            {
               this._collection.selectObject(this);
            }
            this._justSelected = false;
         }
         if(this._isDragging)
         {
            if(this._collection.allowRemoveOnDrag)
            {
               _mc.stopDrag();
            }
            this._isDragging = false;
            dispatchEvent(new Event(EVENT_DROP));
            dispatchEvent(new Event(EVENT_CHANGE));
         }
         dispatchEvent(new Event(EVENT_RELEASE));
      }
      
      protected function onItemClick(param1:Event) : void
      {
         dispatchEvent(new Event(EVENT_CLICK));
      }
      
      override protected function onRollOver(param1:MouseEvent = null) : void
      {
         super.onRollOver(param1);
         ++this._altTimes;
         if(!this.selected && this._highlight != null)
         {
            this._highlight.alpha = 0.4;
         }
         if(this._alt.length > 0 && this._altTimes <= 7)
         {
            Tagtip.showTag(this._alt);
         }
      }
      
      override protected function onRollOut(param1:MouseEvent = null) : void
      {
         super.onRollOut(param1);
         if(!this.selected && this._highlight != null)
         {
            this._highlight.alpha = 0;
         }
         Tagtip.hideTag();
      }
   }
}

