package com.sploder.asui
{
   import flash.display.Sprite;
   
   public class Divider extends Component
   {
      protected var _vertical:Boolean = true;
      
      public function Divider(param1:Sprite = null, param2:Number = NaN, param3:Number = NaN, param4:Boolean = true, param5:Position = null, param6:Style = null)
      {
         super();
         this.init_Divider(param1,param2,param3,param4,param5,param6);
         if(_container != null)
         {
            this.create();
         }
      }
      
      private function init_Divider(param1:Sprite = null, param2:Number = NaN, param3:Number = NaN, param4:Boolean = true, param5:Position = null, param6:Style = null) : void
      {
         super.init(param1,param5,param6);
         _type = "divider";
         this._vertical = param4;
         if(this._vertical)
         {
            _width = Math.max(2,Math.floor(_style.borderWidth));
            _height = param3;
            if(_position != null && _position.placement == Position.PLACEMENT_NORMAL)
            {
               _position = _position.clone({
                  "placement":Position.PLACEMENT_FLOAT,
                  "clear":Position.CLEAR_NONE
               });
            }
            else if(_position == null)
            {
               _position = new Position(null,-1,Position.PLACEMENT_FLOAT,Position.CLEAR_NONE);
            }
         }
         else
         {
            _width = param2;
            _height = Math.max(2,Math.floor(_style.borderWidth));
            if(_position != null && _position.clear != Position.CLEAR_BOTH)
            {
               _position = _position.clone({"clear":Position.CLEAR_BOTH});
            }
            else if(_position == null)
            {
               _position = new Position(null,-1,Position.PLACEMENT_NORMAL,Position.CLEAR_BOTH);
            }
         }
      }
      
      override public function create() : void
      {
         super.create();
         if(isNaN(_height) || _height == 0)
         {
            _height = _parentCell.height - _position.margin_top - _position.margin_bottom;
         }
         if(_style.borderWidth == 0)
         {
            DrawingMethods.rect(_mc,true,0,0,_width / 2,_height,0,0.4);
            DrawingMethods.rect(_mc,false,_width / 2,0,_width / 2,_height,16777215,0.4);
         }
         else
         {
            DrawingMethods.rect(_mc,true,0,0,_width,_height,ColorTools.getTintedColor(_style.borderColor,_style.backgroundColor,0.5));
         }
      }
   }
}

