package com.sploder.asui
{
   import flash.display.Sprite;
   
   public class Position
   {
      public static const ALIGN_LEFT:int = 1;
      
      public static const ALIGN_CENTER:int = 2;
      
      public static const ALIGN_RIGHT:int = 3;
      
      public static const PLACEMENT_NORMAL:int = 4;
      
      public static const PLACEMENT_FLOAT:int = 5;
      
      public static const PLACEMENT_FLOAT_RIGHT:int = 6;
      
      public static const PLACEMENT_ABSOLUTE:int = 7;
      
      public static const CLEAR_NONE:int = 8;
      
      public static const CLEAR_LEFT:int = 9;
      
      public static const CLEAR_RIGHT:int = 10;
      
      public static const CLEAR_BOTH:int = 11;
      
      public static const ORIENTATION_HORIZONTAL:int = 12;
      
      public static const ORIENTATION_VERTICAL:int = 13;
      
      public static const POSITION_ABOVE:int = 14;
      
      public static const POSITION_BELOW:int = 15;
      
      public static const POSITION_RIGHT:int = 16;
      
      public static const POSITION_LEFT:int = 17;
      
      public static var defaultMarginTop:int = 0;
      
      public static var defaultMarginRight:int = 0;
      
      public static var defaultMarginBottom:int = 0;
      
      public static var defaultMarginLeft:int = 0;
      
      private var cloneParams:Array;
      
      private var _align:int;
      
      private var _placement:int;
      
      private var _clear:int;
      
      private var _overflow:String;
      
      public var defaultPlacement:int = 4;
      
      private var _margin:int;
      
      private var _margin_top:int;
      
      private var _margin_right:int;
      
      private var _margin_bottom:int;
      
      private var _margin_left:int;
      
      private var _top:int = 0;
      
      private var _left:int = 0;
      
      private var _zindex:int = 1;
      
      private var _collapse:Boolean = false;
      
      private var _ignoreContentPadding:Boolean = false;
      
      private var _options:Object;
      
      public function Position(param1:Object = null, param2:int = -1, param3:int = -1, param4:int = -1, param5:Object = null, param6:Number = NaN, param7:Number = NaN, param8:Number = NaN, param9:Boolean = false)
      {
         var _loc10_:Array = null;
         this.cloneParams = ["_align","_placement","_clear","margin","_margin_top","_margin_right","_margin_bottom","_margin_left","_top","_left","_zindex","_collapse","_ignoreContentPadding","_overflow"];
         super();
         this._options = param1;
         this._align = param1 != null && !isNaN(param1.align) && param1.align > 0 ? int(param1.align) : (param2 > 0 ? param2 : ALIGN_LEFT);
         this._placement = param1 != null && !isNaN(param1.placement) && param1.placement > 0 ? int(param1.placement) : (param3 > 0 ? param3 : this.defaultPlacement);
         this._clear = param1 != null && !isNaN(param1.clear) && param1.clear > 0 ? int(param1.clear) : (param4 > 0 ? param4 : (this._placement == PLACEMENT_FLOAT || this._placement == PLACEMENT_FLOAT_RIGHT ? CLEAR_NONE : CLEAR_BOTH));
         this._top = param1 != null && !isNaN(param1.top) ? int(param1.top) : (!isNaN(param6) ? int(param6) : this._top);
         this._left = param1 != null && !isNaN(param1.left) ? int(param1.left) : (!isNaN(param7) ? int(param7) : this._left);
         this._zindex = param1 != null && !isNaN(param1.zindex) ? int(param1.zindex) : (!isNaN(param8) ? int(param8) : this._zindex);
         this._collapse = param1 != null && param1.collapse == true || param9 == true;
         this._overflow = param1 != null && param1.overflow != undefined ? param1.overflow : "";
         this._ignoreContentPadding = param1 != null && Boolean(param1.ignoreContentPadding) ? true : false;
         if(param1 != null && param1.margins != undefined)
         {
            param5 = param1.margins;
         }
         if(param5 != null)
         {
            if(typeof param5 == "number")
            {
               this._margin = this._margin_top = this._margin_right = this._margin_bottom = this._margin_left = Number(param5);
            }
            else
            {
               if(typeof param5 == "string")
               {
                  _loc10_ = String(param5).split(" ");
               }
               else
               {
                  _loc10_ = param5 as Array;
               }
               this._margin_top = !isNaN(_loc10_[0]) ? int(parseInt(_loc10_[0])) : 0;
               this._margin_right = !isNaN(_loc10_[1]) ? int(parseInt(_loc10_[1])) : 0;
               this._margin_bottom = !isNaN(_loc10_[2]) ? int(parseInt(_loc10_[2])) : 0;
               this._margin_left = !isNaN(_loc10_[3]) ? int(parseInt(_loc10_[3])) : 0;
            }
         }
         else
         {
            this._margin_top = defaultMarginTop;
            this._margin_right = defaultMarginRight;
            this._margin_bottom = defaultMarginBottom;
            this._margin_left = defaultMarginLeft;
         }
         if(param1 != null && param1.margin_top != undefined)
         {
            this._margin_top = param1.margin_top;
         }
         if(param1 != null && param1.margin_right != undefined)
         {
            this._margin_right = param1.margin_right;
         }
         if(param1 != null && param1.margin_bottom != undefined)
         {
            this._margin_bottom = param1.margin_bottom;
         }
         if(param1 != null && param1.margin_left != undefined)
         {
            this._margin_left = param1.margin_left;
         }
      }
      
      public static function arrangeContent(param1:Cell, param2:Boolean = false) : void
      {
         var _loc3_:Component = null;
         var _loc4_:Component = null;
         if(!param1.position.ignoreContentPadding && param1.collapse && param1.lastArrangedChildIndex == -1)
         {
            param1.lastArrangedChildY = param1.style.padding;
         }
         if(param2)
         {
            param1.lastArrangedChildIndex = -1;
            param1.lastArrangedChildX = 0;
            param1.lastArrangedChildY = 0;
         }
         var _loc5_:Number = param1.lastArrangedChildY;
         var _loc6_:Array = [];
         var _loc7_:int = param1.lastArrangedChildIndex + 1;
         while(_loc7_ < param1.childNodes.length)
         {
            _loc4_ = param1.childNodes[_loc7_];
            if(_loc3_ == null || _loc4_.position.placement != _loc3_.position.placement || _loc4_.position.clear == CLEAR_LEFT || _loc4_.position.clear == CLEAR_BOTH || _loc3_.position.clear == CLEAR_RIGHT || _loc3_.position.clear == CLEAR_BOTH)
            {
               if(_loc6_.length > 0)
               {
                  if((_loc4_.position.clear == CLEAR_NONE || _loc4_.position.clear == CLEAR_RIGHT) && (_loc3_.position.clear == CLEAR_NONE || _loc3_.position.clear == CLEAR_LEFT))
                  {
                     alignRow(param1,_loc6_,param1.position.align);
                  }
                  else
                  {
                     _loc5_ += alignRow(param1,_loc6_,param1.position.align);
                     param1.lastArrangedChildY = _loc5_;
                     param1.lastArrangedChildIndex = _loc7_ - 1;
                  }
                  _loc6_ = [];
               }
            }
            switch(_loc4_.position.placement)
            {
               case PLACEMENT_FLOAT:
                  _loc4_.x = _loc4_.position.margin_left;
                  _loc4_.y = _loc4_.position.margin_top + _loc5_;
                  _loc6_.push(_loc4_);
                  break;
               case PLACEMENT_FLOAT_RIGHT:
                  _loc4_.x = param1.width - _loc4_.width - param1.position.margin_right;
                  _loc4_.y = _loc4_.position.margin_top + _loc5_;
                  _loc6_.push(_loc4_);
                  break;
               case PLACEMENT_ABSOLUTE:
                  _loc4_.x = _loc4_.position.left;
                  _loc4_.y = _loc4_.position.top;
                  break;
               case PLACEMENT_NORMAL:
                  switch(param1.position.align)
                  {
                     case Position.ALIGN_LEFT:
                        _loc4_.x = _loc4_.position.margin_left;
                        break;
                     case Position.ALIGN_CENTER:
                        _loc4_.x = Math.floor(param1.width * 0.5 - _loc4_.width * 0.5);
                        break;
                     case Position.ALIGN_RIGHT:
                        _loc4_.x = param1.width - _loc4_.width;
                  }
                  _loc4_.y = _loc4_.position.margin_top + _loc5_;
                  _loc5_ += _loc4_.position.margin_top + _loc4_.height + _loc4_.position.margin_bottom;
                  param1.lastArrangedChildY = _loc5_;
                  param1.lastArrangedChildIndex = _loc7_;
                  break;
            }
            _loc3_ = _loc4_;
            _loc7_++;
         }
         if(_loc6_.length > 0)
         {
            alignRow(param1,_loc6_,param1.position.align);
         }
         if(param1.sortChildNodes)
         {
            zSort(param1);
         }
      }
      
      private static function alignRow(param1:Cell, param2:Array, param3:Number) : Number
      {
         var _loc4_:Component = null;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc5_:Number = param1.lastArrangedChildX;
         var _loc6_:Number = 0;
         var _loc7_:Number = -20;
         var _loc8_:Number = 0;
         if(param2[0].position.placement == PLACEMENT_FLOAT_RIGHT)
         {
            param3 = ALIGN_RIGHT;
         }
         switch(param3)
         {
            case ALIGN_CENTER:
               _loc10_ = 0;
               _loc9_ = int(param2.length - 1);
               while(_loc9_ >= 0)
               {
                  _loc4_ = param2[_loc9_];
                  _loc10_ += _loc4_.width + Math.max(_loc4_.position.margin_right,_loc4_.position.margin_left);
                  _loc9_--;
               }
               _loc10_ -= Math.max(_loc4_.position.margin_right,_loc4_.position.margin_left);
               _loc5_ = Math.floor(param1.width * 0.5 - _loc10_ * 0.5);
            case ALIGN_LEFT:
            default:
               _loc9_ = 0;
               while(_loc9_ < param2.length)
               {
                  _loc4_ = param2[_loc9_];
                  _loc4_.x = _loc4_.position.margin_left + _loc5_;
                  _loc4_.y += _loc8_;
                  _loc5_ += _loc4_.position.margin_left + _loc4_.width + _loc4_.position.margin_right;
                  if(param1.wrap && _loc4_.x + _loc4_.width > _loc4_.parentCell.width)
                  {
                     _loc4_.x = _loc4_.position.margin_left;
                     _loc5_ = _loc4_.position.margin_left + _loc4_.width + _loc4_.position.margin_right;
                     _loc4_.y += _loc4_.height + _loc4_.position.margin_bottom + _loc4_.position.margin_top;
                     _loc8_ += _loc4_.height + _loc4_.position.margin_bottom + _loc4_.position.margin_top;
                  }
                  _loc6_ = Math.max(_loc8_ + _loc4_.height,_loc6_);
                  _loc7_ = Math.max(_loc4_.position.margin_bottom,_loc7_);
                  _loc9_++;
               }
               break;
            case ALIGN_RIGHT:
               _loc5_ = param1.width;
               _loc9_ = int(param2.length - 1);
               while(_loc9_ >= 0)
               {
                  (_loc4_ = param2[_loc9_]).x = _loc5_ - _loc4_.width - _loc4_.position.margin_right;
                  _loc5_ -= _loc4_.position.margin_left + _loc4_.width + _loc4_.position.margin_right;
                  _loc6_ = Math.max(_loc4_.height,_loc6_);
                  _loc7_ = Math.max(_loc4_.position.margin_bottom,_loc7_);
                  _loc9_--;
               }
         }
         return _loc6_ + _loc7_;
      }
      
      private static function zSort(param1:Cell) : void
      {
         var i:int;
         var cclip:Sprite = null;
         var pclip:Sprite = null;
         var cell:Cell = param1;
         var zChildren:Array = cell.childNodes.concat();
         zChildren.sort(function(param1:Component, param2:Component):Number
         {
            if(param1.zindex < param2.zindex)
            {
               return -1;
            }
            if(param1.zindex > param2.zindex)
            {
               return 1;
            }
            return 0;
         });
         i = int(zChildren.length - 1);
         while(i > 0)
         {
            cclip = Sprite(zChildren[i].mc);
            pclip = Sprite(zChildren[i - 1].mc);
            cclip.parent.setChildIndex(cclip,i);
            i--;
         }
      }
      
      public static function getCellContentWidth(param1:Cell) : Number
      {
         var _loc2_:Number = 0;
         var _loc3_:int = int(param1.childNodes.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = Math.floor(Math.max(_loc2_,Component(param1.childNodes[_loc3_]).x + Component(param1.childNodes[_loc3_]).width));
            _loc3_--;
         }
         return _loc2_;
      }
      
      public static function getCellContentHeight(param1:Cell) : Number
      {
         if(param1.childNodes.length == 0)
         {
            return 0;
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = param1.childNodes.length - 1;
         var _loc4_:Component = param1.childNodes[_loc3_];
         while(_loc4_.position.placement == Position.PLACEMENT_ABSOLUTE && _loc3_ > 0)
         {
            _loc3_--;
            _loc4_ = param1.childNodes[_loc3_];
         }
         if(_loc4_ != null)
         {
            _loc2_ = Math.floor(_loc4_.y + _loc4_.height + _loc4_.position.margin_bottom);
            if(param1.collapse)
            {
               if(param1.position.ignoreContentPadding)
               {
                  _loc2_ = param1.contents.height - param1.style.padding - param1.style.borderWidth * 2;
               }
               else
               {
                  _loc2_ += _loc4_.style.padding;
               }
            }
         }
         if(isNaN(_loc2_))
         {
            _loc2_ = 0;
         }
         return _loc2_;
      }
      
      public function set defaultMargins(param1:int) : void
      {
         if(!isNaN(param1))
         {
            defaultMarginTop = defaultMarginRight = defaultMarginBottom = defaultMarginLeft = param1;
         }
      }
      
      public function get align() : int
      {
         return this._align;
      }
      
      public function set align(param1:int) : void
      {
         this._align = param1;
      }
      
      public function get placement() : int
      {
         return this._placement;
      }
      
      public function set placement(param1:int) : void
      {
         this._placement = param1;
      }
      
      public function get clear() : int
      {
         return this._clear;
      }
      
      public function set clear(param1:int) : void
      {
         this._clear = param1;
      }
      
      public function get overflow() : String
      {
         return this._overflow;
      }
      
      public function set overflow(param1:String) : void
      {
         this._overflow = param1;
      }
      
      public function get margin() : int
      {
         return this._margin;
      }
      
      public function set margin(param1:int) : void
      {
         this._margin = param1;
      }
      
      public function get margin_top() : int
      {
         return this._margin_top;
      }
      
      public function set margin_top(param1:int) : void
      {
         this._margin_top = param1;
      }
      
      public function get margin_right() : int
      {
         return this._margin_right;
      }
      
      public function set margin_right(param1:int) : void
      {
         this._margin_right = param1;
      }
      
      public function get margin_bottom() : int
      {
         return this._margin_bottom;
      }
      
      public function set margin_bottom(param1:int) : void
      {
         this._margin_bottom = param1;
      }
      
      public function get margin_left() : int
      {
         return this._margin_left;
      }
      
      public function set margin_left(param1:int) : void
      {
         this._margin_left = param1;
      }
      
      public function get top() : int
      {
         return this._top;
      }
      
      public function set top(param1:int) : void
      {
         this._top = param1;
      }
      
      public function get left() : int
      {
         return this._left;
      }
      
      public function set left(param1:int) : void
      {
         this._left = param1;
      }
      
      public function get zindex() : int
      {
         return this._zindex;
      }
      
      public function set zindex(param1:int) : void
      {
         this._zindex = param1;
      }
      
      public function get collapse() : Boolean
      {
         return this._collapse;
      }
      
      public function set collapse(param1:Boolean) : void
      {
         this._collapse = param1;
      }
      
      public function get ignoreContentPadding() : Boolean
      {
         return this._ignoreContentPadding;
      }
      
      public function set ignoreContentPadding(param1:Boolean) : void
      {
         this._ignoreContentPadding = param1;
      }
      
      public function clone(param1:Object) : Position
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc2_:Object = {};
         for(_loc3_ in this._options)
         {
            _loc2_[_loc3_] = this._options[_loc3_];
         }
         _loc4_ = 0;
         while(_loc4_ < this.cloneParams.length)
         {
            _loc3_ = this.cloneParams[_loc4_];
            if(_loc3_.indexOf("_") == 0)
            {
               if(this[_loc3_] is Array)
               {
                  _loc2_[_loc3_.split("_").join("")] = this[_loc3_].concat();
               }
               else
               {
                  _loc2_[_loc3_.split("_").join("")] = this[_loc3_];
               }
            }
            _loc4_++;
         }
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return new Position(_loc2_);
      }
   }
}

