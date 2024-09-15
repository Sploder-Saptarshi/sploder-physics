package com.sploder.asui
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Matrix;
   
   public class ProgressBar extends Component
   {
      protected var _stage:Stage;
      
      protected var _bar:Sprite;
      
      protected var _barTexture:Sprite;
      
      protected var _percent:Number = 0;
      
      private var _texture:BitmapData;
      
      private var _m:Matrix;
      
      public function ProgressBar(param1:Sprite = null, param2:Number = NaN, param3:Number = NaN, param4:Position = null, param5:Style = null)
      {
         super();
         this.init_ProgressBar(param1,param2,param3,param4,param5);
         if(_container != null)
         {
            this.create();
         }
      }
      
      public function get percent() : Number
      {
         return this._percent;
      }
      
      public function set percent(param1:Number) : void
      {
         this._percent = param1;
         this._bar.scaleX = Math.max(0.1,Math.min(1,this._percent));
      }
      
      protected function init_ProgressBar(param1:Sprite = null, param2:Number = NaN, param3:Number = NaN, param4:Position = null, param5:Style = null) : void
      {
         super.init(param1,param4,param5);
         _width = param2;
         _height = param3;
         _type = "progressbar";
      }
      
      override public function create() : void
      {
         var _loc2_:int = 0;
         super.create();
         if(isNaN(_width))
         {
            _width = _parentCell.width - _parentCell.style.padding * 2;
         }
         if(isNaN(_height))
         {
            _height = 24;
         }
         DrawingMethods.emptyRect(_mc,false,0,0,_width,_height,2,ColorTools.getTintedColor(_style.borderColor,_style.backgroundColor,0.7));
         DrawingMethods.roundedRect(_mc,false,2,2,_width - 4,_height - 4,"0",[_style.inputColorA,_style.inputColorB]);
         this._bar = new Sprite();
         _mc.addChild(this._bar);
         DrawingMethods.roundedRect(this._bar,false,3,3,_width - 6,_height - 6,"0",[style.unselectedColor],[style.backgroundAlpha],[1]);
         DrawingMethods.roundedRect(this._bar,false,3,3,_width - 6,_height - 6,"0",[16777215,16777215,0,0],[0.4,0.15,0,0.1],[0,128,128,255]);
         this._texture = new BitmapData(20,20,true,0);
         var _loc1_:int = 0;
         while(_loc1_ < this._texture.height)
         {
            _loc2_ = 0;
            while(_loc2_ < this._texture.width)
            {
               this._texture.setPixel32(_loc2_,_loc1_,(Math.sin(_loc2_ / Math.PI) + 1) * 20 << 24 | 0xFFFFFF);
               _loc2_++;
            }
            _loc1_++;
         }
         this._m = new Matrix();
         this._m.createBox(1,1);
         this._barTexture = new Sprite();
         _mc.addChild(this._barTexture);
         if(_mc.stage)
         {
            this.onAdded();
         }
         else
         {
            _mc.addEventListener(Event.ADDED_TO_STAGE,this.onAdded,false,0,true);
         }
      }
      
      protected function animate(param1:Event) : void
      {
         --this._m.tx;
         this._m.tx %= 20;
         this._barTexture.graphics.clear();
         this._barTexture.graphics.beginBitmapFill(this._texture,this._m);
         this._barTexture.graphics.drawRect(3,3,this._bar.width,_height - 6);
         this._barTexture.graphics.endFill();
      }
      
      protected function onAdded(param1:Event = null) : void
      {
         if(_mc.stage)
         {
            this._stage = _mc.stage;
            this._stage.addEventListener(Event.ENTER_FRAME,this.animate,false,0,true);
            _mc.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved,false,0,true);
         }
      }
      
      protected function onRemoved(param1:Event) : void
      {
         if(this._stage)
         {
            this._stage.removeEventListener(Event.ENTER_FRAME,this.animate);
            _mc.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
            _mc.addEventListener(Event.ADDED_TO_STAGE,this.onAdded,false,0,true);
         }
      }
   }
}

