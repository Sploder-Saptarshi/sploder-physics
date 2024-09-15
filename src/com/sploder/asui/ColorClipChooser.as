package com.sploder.asui
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ColorClipChooser extends ClipChooser
   {
      private var selector:Shape;
      
      public function ColorClipChooser(param1:Sprite, param2:String, param3:Array, param4:Array, param5:Number = 0, param6:String = "", param7:Number = NaN, param8:Number = NaN, param9:int = 16, param10:Position = null, param11:Style = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
      }
      
      override protected function createElements() : void
      {
         super.createElements();
         this.createChoices();
      }
      
      override protected function createChoices() : void
      {
         var _loc1_:int = 0;
         var _loc8_:DisplayObject = null;
         if(_choicesCreated)
         {
            return;
         }
         _choicesCreated = true;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = Math.min(_choices.length,rowLength) * (_height - choicesShrink);
         var _loc5_:Number = Math.ceil(_choices.length / rowLength) * (_height - choicesShrink);
         switch(_dropdownPosition)
         {
            case Position.POSITION_ABOVE:
               _loc2_ = 0 - _loc5_;
               _loc3_ = 0;
               break;
            case Position.POSITION_RIGHT:
               _loc2_ = 0;
               _loc3_ = _width;
               break;
            case Position.POSITION_BELOW:
               _loc2_ = _height;
               _loc3_ = 0;
               break;
            case Position.POSITION_LEFT:
               _loc2_ = 0;
               _loc3_ = 0 - _loc4_;
               _loc4_ = Math.min(_choices.length,rowLength) * _height;
         }
         _loc3_ += choicesOffsetX;
         _loc2_ += choicesOffsetY;
         _dropdown = Cell(addChild(new Cell(null,_loc4_,_loc5_,true,true,choicesPadding == 0 ? 0 : _style.round,new Position({
            "placement":Position.PLACEMENT_ABSOLUTE,
            "top":_loc2_,
            "left":_loc3_,
            "ignoreContentPadding":true
         }))));
         _dropdown.maskContent = _dropdown.trapMouse = _dropdown.collapse = true;
         _dropdown.hide();
         var _loc6_:String = "";
         _buttons = [];
         _loc1_ = 0;
         while(_loc1_ < _choices.length)
         {
            _loc6_ = "";
            if(Boolean(_alts) && Boolean(_alts[_loc1_]))
            {
               _loc6_ = _alts[_loc1_];
            }
            if(typeof _choices[_loc1_] != "number")
            {
               _loc8_ = library.getDisplayObject(_choices[_loc1_]);
               if(_loc8_ != null)
               {
                  _loc8_.width = _loc8_.height = 16;
                  _dropdown.bkgd.addChild(_loc8_);
                  _loc8_.x = 2 + 18 * (_loc1_ % 18) - _loc8_.getBounds(_loc8_.parent).x;
                  _loc8_.y = 2 + 18 * Math.floor(_loc1_ / 18) - _loc8_.getBounds(_loc8_.parent).y;
                  if(_loc8_ is Sprite)
                  {
                     Sprite(_loc8_).mouseEnabled = false;
                  }
               }
            }
            _loc1_++;
         }
         var _loc7_:Graphics = _dropdown.bkgd.graphics;
         _loc7_.clear();
         _loc7_.beginFill(0);
         _loc7_.drawRect(0,0,18 * 18 + 2,18 * 13 + 2);
         _loc7_.endFill();
         _loc1_ = 0;
         while(_loc1_ < _choices.length)
         {
            if(typeof _choices[_loc1_] == "number")
            {
               _loc7_.beginFill(_choices[_loc1_]);
               _loc7_.drawRect(2 + 18 * (_loc1_ % 18),2 + 18 * Math.floor(_loc1_ / 18),16,16);
               _loc7_.endFill();
            }
            _loc1_++;
         }
         _dropdown.trapMouse = false;
         _dropdown.mouseEnabled = true;
         _dropdown.bkgd.buttonMode = true;
         _dropdown.bkgd.useHandCursor = true;
         _dropdown.bkgd.mouseEnabled = true;
         _dropdown.bkgd.addEventListener(MouseEvent.MOUSE_UP,this.onChoice);
         this.selector = new Shape();
         _loc7_ = this.selector.graphics;
         _loc7_.lineStyle(1,16777215);
         _loc7_.drawRect(0,0,15,15);
         _dropdown.bkgd.addChild(this.selector);
         if(!isNaN(_selectionIndex))
         {
            this.selector.x = 2 + 18 * (_selectionIndex % 18);
            this.selector.y = 2 + 18 * Math.floor(_selectionIndex / 18);
         }
         else
         {
            this.selector.x = this.selector.y = 2;
         }
         addEventListener(EVENT_BLUR,_dropdown.hide);
      }
      
      override public function onChoice(param1:Event) : void
      {
         var _loc2_:MouseEvent = null;
         var _loc3_:int = 0;
         var _loc4_:* = false;
         if(param1 is MouseEvent && param1.target == _dropdown.bkgd)
         {
            _loc2_ = param1 as MouseEvent;
            _loc3_ = Math.floor((_loc2_.localY - 2) / 18) * 18 + Math.floor((_loc2_.localX - 2) / 18);
            if(_loc3_ >= 0 && _loc3_ < _choices.length)
            {
               this.selector.x = 2 + 18 * (_loc3_ % 18);
               this.selector.y = 2 + 18 * Math.floor(_loc3_ / 18);
               _loc4_ = _choiceButton.symbolName != _choices[_loc3_] + "";
               if(_loc4_)
               {
                  _choiceButton.setSymbol(_choices[_loc3_] + "");
               }
               dispatchEvent(new Event(EVENT_CLICK));
               dispatchEvent(new Event(EVENT_SELECT));
               if(_loc4_)
               {
                  dispatchEvent(new Event(EVENT_CHANGE));
               }
            }
            toggle();
         }
      }
      
      override public function set value(param1:String) : void
      {
         var _loc3_:* = null;
         if(param1 == value)
         {
            return;
         }
         if(_buttons == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _choices.length)
         {
            _loc3_ = _choices[_loc2_] + "";
            if(_loc3_ == param1)
            {
               this.selector.x = 2 + 18 * (_loc2_ % 18);
               this.selector.y = 2 + 18 * Math.floor(_loc2_ / 18);
               _choiceButton.setSymbol(_loc3_);
               dispatchEvent(new Event(EVENT_CHANGE));
               return;
            }
            _loc2_++;
         }
      }
   }
}

