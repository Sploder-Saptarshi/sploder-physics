package com.sploder.asui
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.JointStyle;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ClipButton extends BButton
   {
      protected var _symbolName:String = "";
      
      protected var _toggleSymbolName:String = "";
      
      protected var _toggleMode:Boolean = false;
      
      protected var _cancelToggleMode:Boolean = false;
      
      protected var _clip:DisplayObject;
      
      protected var _toggleClip:DisplayObject;
      
      protected var _clipScale:Number = -1;
      
      protected var _toggled:Boolean = false;
      
      protected var _toggledAlt:String = "";
      
      protected var _minPadding:int = 10;
      
      protected var _lineMode:Boolean = false;
      
      public function ClipButton(param1:Sprite = null, param2:String = "", param3:String = "", param4:Number = -1, param5:Number = NaN, param6:Number = NaN, param7:int = 10, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Position = null, param13:Style = null, param14:Boolean = false)
      {
         super();
         this.init_ClipButton(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get toggledAlt() : String
      {
         return this._toggledAlt;
      }
      
      public function set toggledAlt(param1:String) : void
      {
         this._toggledAlt = param1;
      }
      
      protected function init_ClipButton(param1:Sprite = null, param2:String = "", param3:String = "", param4:Number = -1, param5:Number = NaN, param6:Number = NaN, param7:int = 10, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Position = null, param13:Style = null, param14:Boolean = false) : void
      {
         super.init_BButton(param1,"",-1,param5,param6,param8,param9,param10,param12,param13,param14);
         _type = "clipbutton";
         this._symbolName = _value = param2;
         this._toggleSymbolName = param3;
         this._clipScale = param4;
         this._minPadding = param7;
         this._lineMode = param11;
         if(Boolean(this._toggleSymbolName) && Boolean(this._toggleSymbolName.length))
         {
            this._toggleMode = true;
         }
         if(this._symbolName)
         {
            this.getSymbol();
         }
      }
      
      protected function getSymbol() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(Boolean(this._clip) && Boolean(this._clip.parent))
         {
            this._clip.parent.removeChild(this._clip);
         }
         if(Boolean(this._toggleClip) && Boolean(this._toggleClip.parent))
         {
            this._toggleClip.parent.removeChild(this._toggleClip);
         }
         if(library == null)
         {
            throw new Error("Register a library with Component in order to embed clips!");
         }
         if(!isNaN(parseInt(this._symbolName)))
         {
            _loc2_ = parseInt(this._symbolName);
            this._clip = new Sprite();
            _loc1_ = Sprite(this._clip).graphics;
            if(!this._lineMode)
            {
               _loc1_.beginFill(_loc2_,1);
               _loc1_.lineStyle(1,0,1,true);
               _loc1_.drawRect(0 - _width / 2 + 1,0 - _height / 2 + 1,_width - 2,_height - 2);
               _loc1_.endFill();
            }
            else
            {
               _loc1_.beginFill(0,0);
               _loc1_.lineStyle(4,_loc2_,1,true,"normal",null,JointStyle.MITER);
               _loc1_.drawRect(0 - _width / 2 + 2,0 - _height / 2 + 2,_width - 4,_height - 4);
               _loc1_.endFill();
            }
            if(!this._cancelToggleMode)
            {
               this._toggleMode = true;
            }
            if(this._toggleMode)
            {
               this._toggleClip = new Sprite();
               _loc1_ = Sprite(this._toggleClip).graphics;
               if(!this._lineMode)
               {
                  _loc1_.beginFill(_loc2_,1);
                  _loc1_.lineStyle(1,16777215,1,true);
                  _loc1_.drawRect(0 - _width / 2 + 1,0 - _height / 2 + 1,_width - 2,_height - 2);
                  _loc1_.endFill();
               }
               else
               {
                  _loc1_.beginFill(0,0);
                  _loc1_.lineStyle(4,_loc2_,1,true,"normal",null,JointStyle.MITER);
                  _loc1_.drawRect(0 - _width / 2 + 2,0 - _height / 2 + 2,_width - 4,_height - 4);
                  _loc1_.endFill();
               }
            }
         }
         else
         {
            this._toggleMode = Boolean(this._toggleSymbolName) && Boolean(this._toggleSymbolName.length);
            this._clip = library.getDisplayObject(this._symbolName);
            if(this._toggleMode && Boolean(this._toggleSymbolName))
            {
               this._toggleClip = library.getDisplayObject(this._toggleSymbolName);
            }
         }
         if(this._clipScale > 0)
         {
            this._clip.scaleX = this._clip.scaleY = this._clipScale;
            if(this._toggleClip)
            {
               this._toggleClip.scaleX = this._toggleClip.scaleY = this._clipScale;
            }
         }
         else
         {
            _loc3_ = Math.max(this._minPadding,_style.borderWidth * 2 + (_style.round - _style.borderWidth) * 2);
            _loc3_ = Math.max(_style.padding * 2,_loc3_);
            if(isNaN(_width) || _width == 0)
            {
               _width = this._clip.width + _loc3_;
            }
            if(isNaN(_height) || _height == 0)
            {
               _height = this._clip.height + _loc3_;
            }
            _loc4_ = this._clip.width / this._clip.height;
            _loc5_ = _width / _height;
            if(_loc4_ < _loc5_)
            {
               this._clip.height = _height - _loc3_;
               this._clip.width = this._clip.height * _loc4_;
            }
            else
            {
               this._clip.width = _width - _loc3_;
               this._clip.height = this._clip.width / _loc4_;
            }
            if(this._toggleClip)
            {
               this._toggleClip.width = this._clip.width;
               this._toggleClip.height = this._clip.height;
            }
         }
         if(this._clip is DisplayObjectContainer)
         {
            DisplayObjectContainer(this._clip).mouseEnabled = false;
         }
         if(this._toggleClip is DisplayObjectContainer)
         {
            DisplayObjectContainer(this._toggleClip).mouseEnabled = false;
         }
      }
      
      public function setSymbol(param1:String) : void
      {
         if(this._clip)
         {
            if(this._clip.parent != null)
            {
               this._clip.parent.removeChild(this._clip);
            }
            this._clip = null;
         }
         this._symbolName = _value = param1;
         this.getSymbol();
         this.addClip();
      }
      
      protected function addClip() : void
      {
         if(this._clip == null)
         {
            return;
         }
         this._clip.x = _width / 2;
         this._clip.y = _height / 2;
         this._clip.alpha = _enabled ? 1 : 0.5;
         _button_mc.addChild(this._clip);
         _button_mc.setChildIndex(_btn,_button_mc.getChildIndex(this._clip));
         if(this._toggleMode && Boolean(this._toggleClip))
         {
            this._toggleClip.x = this._clip.x;
            this._toggleClip.y = this._clip.y;
            this._toggleClip.alpha = _enabled ? 1 : 0.5;
            _button_mc.addChild(this._toggleClip);
            _button_mc.setChildIndex(_btn,_button_mc.getChildIndex(this._toggleClip));
            this._toggleClip.visible = false;
         }
      }
      
      override public function create() : void
      {
         super.create();
         this.addClip();
      }
      
      override public function disable(param1:Event = null) : void
      {
         super.disable(param1);
         this._clip.alpha = 0.5;
         if(this._toggleClip)
         {
            this._toggleClip.alpha = 0.5;
         }
      }
      
      override public function enable(param1:Event = null) : void
      {
         super.enable(param1);
         this._clip.alpha = 1;
         if(this._toggleClip)
         {
            this._toggleClip.alpha = 1;
         }
      }
      
      public function get symbolName() : String
      {
         return this._symbolName;
      }
      
      public function get toggleSymbolName() : String
      {
         return this._toggleSymbolName;
      }
      
      public function get toggled() : Boolean
      {
         return this._toggled;
      }
      
      public function set toggled(param1:Boolean) : void
      {
         if(this._toggled == param1)
         {
            if(param1)
            {
               this.select();
            }
            else
            {
               this.deselect();
            }
            return;
         }
         this.toggle();
      }
      
      public function get toggleMode() : Boolean
      {
         return this._toggleMode;
      }
      
      public function set toggleMode(param1:Boolean) : void
      {
         if(!param1)
         {
            this._toggleMode = param1;
            this._cancelToggleMode = !param1;
         }
      }
      
      override public function toggle(param1:Event = null) : void
      {
         if(this._toggled)
         {
            this.deselect();
         }
         else
         {
            this.select();
         }
         dispatchEvent(new Event(EVENT_CHANGE));
      }
      
      override protected function onClick(param1:MouseEvent = null) : void
      {
         if(this._toggleMode)
         {
            if(this._toggled)
            {
               this.deselect();
            }
            else
            {
               this.select();
            }
            dispatchEvent(new Event(EVENT_CLICK));
         }
         else
         {
            super.onClick(param1);
         }
      }
      
      override public function select() : void
      {
         if(_enabled && this._toggleMode)
         {
            if(this._toggleClip)
            {
               this._clip.visible = false;
               this._toggleClip.visible = true;
               _value = this._toggleSymbolName;
            }
            this._toggled = true;
         }
         super.select();
         if(this._toggleMode || reselectable)
         {
            _btn.visible = true;
         }
      }
      
      override public function deselect() : void
      {
         if(_enabled && this._toggleMode)
         {
            if(this._toggleClip)
            {
               this._clip.visible = true;
               this._toggleClip.visible = false;
               _value = this._symbolName;
            }
            this._toggled = false;
         }
         super.deselect();
         if(this._toggleMode)
         {
            _btn.visible = true;
         }
      }
      
      override protected function onRollOver(param1:MouseEvent = null) : void
      {
         if(_alt == null || this._toggledAlt == null)
         {
            return;
         }
         if(_alt.length > 0 || this._toggledAlt.length > 0)
         {
            if(this.toggled && this._toggledAlt.length > 0)
            {
               Tagtip.showTag(this._toggledAlt);
            }
            else
            {
               Tagtip.showTag(_alt);
            }
         }
      }
   }
}

