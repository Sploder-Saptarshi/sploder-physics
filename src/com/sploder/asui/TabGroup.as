package com.sploder.asui
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class TabGroup extends Cell
   {
      private var _textLabels:Array;
      
      private var _tabs:Object;
      
      private var _alts:Array;
      
      private var _buttonSize:Number;
      
      private var _vertical:Boolean = false;
      
      private var _defaultTabIndex:Number;
      
      private var _activeTab:BButton;
      
      public var clipMode:Boolean = false;
      
      public var clipScale:Number = -1;
      
      public var textAlign:int = 1;
      
      public var droop:Boolean = false;
      
      public function TabGroup(param1:Sprite, param2:Array, param3:Array, param4:Number = 0, param5:Number = NaN, param6:Boolean = false, param7:Position = null, param8:Style = null)
      {
         super();
         this.init_TabGroup(param1,param2,param3,param4,param5,param6,param7,param8);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get activeTab() : BButton
      {
         return this._activeTab;
      }
      
      public function get tabs() : Object
      {
         return this._tabs;
      }
      
      override public function set value(param1:String) : void
      {
         if(this._tabs[StringUtils.clean(param1)])
         {
            this.activateTab(null,BButton(this._tabs[StringUtils.clean(param1)]));
         }
      }
      
      private function init_TabGroup(param1:Sprite, param2:Array, param3:Array, param4:Number = 0, param5:Number = NaN, param6:Boolean = false, param7:Position = null, param8:Style = null) : void
      {
         super.init_Cell(param1,0,0,false,false,0,param7,param8);
         _type = "tabgroup";
         _style = _style.clone({"buttonDropShadow":false});
         this._textLabels = param2;
         this._alts = param3;
         this._defaultTabIndex = param4;
         this._buttonSize = param5;
         this._vertical = param6;
         this._tabs = [];
      }
      
      override public function create() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Position = null;
         var _loc3_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:BButton = null;
         super.create();
         if(_parentCell != null)
         {
            _width = _parentCell.width;
         }
         var _loc4_:int = Position.ALIGN_CENTER;
         if(!this._vertical)
         {
            _loc2_ = new Position(null,Position.ALIGN_LEFT,Position.PLACEMENT_FLOAT,Position.CLEAR_NONE,0);
            _loc3_ = true;
         }
         else
         {
            _loc2_ = new Position({"margin_bottom":_position.margin_bottom / 2},Position.ALIGN_CENTER,Position.PLACEMENT_NORMAL,Position.CLEAR_BOTH);
            _position = _position.clone({"align":Position.ALIGN_CENTER});
            _loc3_ = false;
            _loc4_ = Position.ALIGN_LEFT;
         }
         if(!this._vertical)
         {
            _loc6_ = NaN;
            _loc5_ = this._buttonSize;
         }
         else
         {
            _loc6_ = this._buttonSize;
            _loc5_ = NaN;
         }
         _loc1_ = 0;
         while(_loc1_ < this._textLabels.length)
         {
            if(!this.clipMode)
            {
               _loc7_ = new BButton(null,this._textLabels[_loc1_],this.textAlign,_loc6_,_loc5_,_loc3_,true,false,_loc2_,_style,this.droop);
            }
            else
            {
               _loc7_ = new ClipButton(null,this._textLabels[_loc1_],"",this.clipScale,this._buttonSize,this._buttonSize,10,_loc3_,true,false,false,_loc2_,_style,this.droop);
               if(_loc1_ > 0)
               {
                  addChild(new Divider(null,this._vertical ? this._buttonSize : 1,this._vertical ? 1 : this._buttonSize,!this._vertical,_loc2_,_style));
               }
            }
            if(Boolean(this._alts) && Boolean(this._alts[_loc1_]))
            {
               _loc7_.alt = this._alts[_loc1_];
            }
            this._tabs.push(_loc7_);
            this._tabs[StringUtils.clean(this._textLabels[_loc1_])] = _loc7_;
            _loc7_.forceWidth = this._vertical;
            addChild(_loc7_);
            _loc1_++;
         }
         _height = 0;
         _loc1_ = 0;
         while(_loc1_ < this._tabs.length)
         {
            BButton(this._tabs[_loc1_]).addEventListener(EVENT_CLICK,this.activateTab);
            _height = Math.max(_height,BButton(this._tabs[_loc1_]).height);
            _loc1_++;
         }
         if(_parentCell != null)
         {
            _width = _parentCell.width - _position.margin_left - _position.margin_right;
            _height = _parentCell.height - _position.margin_top - _position.margin_bottom;
         }
         else
         {
            _width = mainStage.stageWidth;
            _height = 0;
         }
         collapse = true;
         Position.arrangeContent(this);
         if(this.clipMode)
         {
            _width = Position.getCellContentWidth(this);
            _height = this._buttonSize;
         }
         else
         {
            _width = Position.getCellContentWidth(this);
            _height = Position.getCellContentHeight(this);
         }
         if(this._defaultTabIndex >= 0 && this._defaultTabIndex < this._textLabels.length)
         {
            BButton(this._tabs[this._defaultTabIndex]).select();
            this._activeTab = BButton(this._tabs[this._defaultTabIndex]);
         }
      }
      
      public function activateTab(param1:Event = null, param2:BButton = null) : void
      {
         var _loc3_:BButton = null;
         if(Boolean(param1) && Boolean(param1.target))
         {
            _loc3_ = BButton(param1.target);
         }
         else
         {
            if(!param2)
            {
               return;
            }
            _loc3_ = param2;
         }
         var _loc4_:* = this._activeTab != _loc3_;
         var _loc5_:int = 0;
         while(_loc5_ < this._tabs.length)
         {
            if(this._tabs[_loc5_] != _loc3_)
            {
               BButton(this._tabs[_loc5_]).deselect();
            }
            _loc5_++;
         }
         this._activeTab = _loc3_;
         this._activeTab.select();
         _value = this._activeTab.value;
         dispatchEvent(new Event(EVENT_CLICK));
         if(_loc4_)
         {
            dispatchEvent(new Event(EVENT_CHANGE));
         }
      }
      
      public function getTabByLabel(param1:String) : BButton
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._tabs.length)
         {
            if(BButton(this._tabs[_loc2_]).textLabel == param1)
            {
               return BButton(this._tabs[_loc2_]);
            }
            _loc2_++;
         }
         return null;
      }
      
      public function select(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1)
         {
            _loc2_ = String(param1);
            for(_loc3_ in this._tabs)
            {
               if(_loc3_ != _loc2_)
               {
                  BButton(this._tabs[_loc3_]).deselect();
               }
            }
            this._activeTab = BButton(this._tabs[_loc2_]);
            this._activeTab.select();
            this.value = this._activeTab.value;
            dispatchEvent(new Event(EVENT_CLICK));
         }
      }
   }
}

