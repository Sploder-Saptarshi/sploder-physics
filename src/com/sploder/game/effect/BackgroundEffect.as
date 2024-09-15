package com.sploder.game.effect
{
   import com.sploder.builder.model.Environment;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BackgroundEffect extends Shape
   {
      public static var skip:int = 1;
      
      protected var _width:uint = 0;
      
      protected var _height:uint = 0;
      
      protected var _built:Boolean = false;
      
      protected var bd:BitmapData;
      
      protected var bd2:BitmapData;
      
      protected var r:Rectangle;
      
      private var m:Matrix;
      
      private var m2:Matrix;
      
      protected var bdSize:uint = 200;
      
      protected var bdScale:Number = 2;
      
      protected var bdScale2:Number = 2;
      
      protected var bdSmooth:Boolean = true;
      
      protected var tx1:Number = 0;
      
      protected var ty1:Number = 0;
      
      protected var tx2:Number = 0;
      
      protected var ty2:Number = 0;
      
      protected var _cameraPX:int = 0;
      
      protected var _cameraPY:int = 0;
      
      public var cameraX:int = 0;
      
      public var cameraY:int = 0;
      
      public var animate:Boolean = true;
      
      protected var _isStatic:Boolean = false;
      
      protected var _fm:int = 0;
      
      protected var _type:String = "None";
      
      public function BackgroundEffect(param1:uint, param2:uint)
      {
         super();
         this.init(param1,param2);
      }
      
      protected function init(param1:uint, param2:uint) : void
      {
         this._width = param1;
         this._height = param2;
         if(stage)
         {
            this.build();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.build);
         }
      }
      
      protected function build(param1:Event = null) : void
      {
         if(param1)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.build);
         }
         if(this._built)
         {
            return;
         }
         this.r = new Rectangle(0,0,this.bdSize,this.bdSize);
         this.bd = new BitmapData(this.bdSize,this.bdSize,true,0);
         this.draw(this.bd);
         this.bd2 = new BitmapData(this.bdSize,this.bdSize,true,0);
         this.draw(this.bd2);
         this.m = new Matrix();
         this.m.createBox(this.bdScale,this.bdScale,0,0,0);
         this.m2 = new Matrix();
         this.m2.createBox(this.bdScale2,this.bdScale2,0,0,0);
         if(!this.animate)
         {
            this.update();
            this._isStatic = true;
         }
         else if(this.tx1 == 0 && this.tx2 == 0 && this.ty1 == 0 && this.ty2 == 0)
         {
            this.update();
            this._isStatic = true;
         }
         else
         {
            if(Boolean(stage) && this.animate)
            {
               stage.addEventListener(Event.ENTER_FRAME,this.update);
            }
            this._isStatic = false;
         }
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemove);
         this._built = true;
      }
      
      public function setSize(param1:uint, param2:uint) : void
      {
         if(this._width != param1 || this._height != param2)
         {
            this._width = param1;
            this._height = param2;
            this.rebuild();
         }
      }
      
      public function rebuild() : void
      {
         this.onRemove();
         this.build();
      }
      
      protected function draw(param1:BitmapData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = false;
         var _loc5_:uint = 0;
         var _loc6_:BitmapData = null;
         switch(this._type)
         {
            case Environment.EFFECT_NONE:
               this.tx1 = 0;
               this.ty1 = 0;
               this.tx2 = 0;
               this.ty2 = 0;
               alpha = 1;
               break;
            case Environment.EFFECT_SNOW:
               this.bdScale = 2;
               this.bdScale2 = 1.5;
               this.tx1 = 0.0625;
               this.ty1 = 0.5;
               this.tx2 = 0.125;
               this.ty2 = 0.5;
               _loc3_ = 0;
               while(_loc3_ < this.bdSize)
               {
                  _loc2_ = 0;
                  while(_loc2_ < this.bdSize)
                  {
                     if(Math.random() > 0.995)
                     {
                        param1.setPixel32(_loc2_,_loc3_,4294967295);
                     }
                     _loc2_++;
                  }
                  _loc3_++;
               }
               param1.applyFilter(param1,this.r,new Point(0,0),new BlurFilter(1,1,3));
               param1.applyFilter(param1,this.r,new Point(0,0),new GlowFilter(16777215,1,2,2,3,3));
               param1.applyFilter(param1,this.r,new Point(0,0),new BlurFilter(1,1,3));
               alpha = 1;
               this.bdSmooth = true;
               break;
            case Environment.EFFECT_RAIN:
               this.bdScale = 1;
               this.bdScale2 = 1;
               this.bdSmooth = false;
               this.tx1 = 0.125;
               this.ty1 = 1;
               this.tx2 = 1;
               this.ty2 = 2;
               _loc4_ = true;
               _loc2_ = -100;
               while(_loc2_ < this.bdSize)
               {
                  _loc3_ = -30;
                  while(_loc3_ < this.bdSize)
                  {
                     if(_loc3_ % 5 == 0 && Math.random() > 0.5)
                     {
                        _loc4_ = !_loc4_;
                     }
                     if(Math.floor(_loc2_) % 5 == 0 && _loc4_)
                     {
                        param1.setPixel32(_loc2_ + _loc3_ * 0.5,_loc3_,369098751);
                     }
                     _loc3_++;
                  }
                  _loc2_++;
               }
               alpha = 1;
               break;
            case Environment.EFFECT_CLOUDS:
               this.bdScale = 2;
               this.bdSmooth = false;
               this.tx1 = 1;
               this.ty1 = 0;
               this.tx2 = 0.5;
               this.ty2 = 0;
               param1.perlinNoise(200,20,2,3049 + Math.random() * 1000,true,true,BitmapDataChannel.ALPHA,true);
               alpha = 0.25;
               break;
            case Environment.EFFECT_STARS:
               this.bdScale = 1;
               this.tx1 = 0;
               this.ty1 = 0;
               this.tx2 = 0;
               this.ty2 = 0;
               this.bdSmooth = false;
               param1.perlinNoise(200,200,5,3049 + Math.random() * 1000,true,true,8,true);
               param1.merge(new BitmapData(this.bdSize,this.bdSize,true,0),this.r,new Point(0,0),0,0,0,200);
               _loc5_ = 4294967295;
               _loc3_ = 0;
               while(_loc3_ < this.bdSize)
               {
                  _loc2_ = 0;
                  while(_loc2_ < this.bdSize)
                  {
                     if(Math.random() > 0.5)
                     {
                        _loc5_ = 4294954239;
                     }
                     if(Math.random() > 0.5)
                     {
                        _loc5_ = 4294954188;
                     }
                     if(Math.random() > 0.5)
                     {
                        _loc5_ = 4294967193;
                     }
                     if(Math.random() > 0.95)
                     {
                        _loc5_ = 4291611903;
                     }
                     if(Math.random() > 0.9995)
                     {
                        param1.setPixel32(_loc2_,_loc3_,_loc5_);
                        if(Math.random() > 0.85)
                        {
                           _loc5_ -= 1711276032;
                           param1.setPixel32(_loc2_ - 1,_loc3_,_loc5_);
                           param1.setPixel32(_loc2_ + 1,_loc3_,_loc5_);
                           param1.setPixel32(_loc2_,_loc3_ - 1,_loc5_);
                           param1.setPixel32(_loc2_,_loc3_ + 1,_loc5_);
                           _loc5_ -= 855638016;
                           param1.setPixel32(_loc2_ - 2,_loc3_,_loc5_);
                           param1.setPixel32(_loc2_ + 2,_loc3_,_loc5_);
                           param1.setPixel32(_loc2_,_loc3_ - 2,_loc5_);
                           param1.setPixel32(_loc2_,_loc3_ + 2,_loc5_);
                        }
                     }
                     _loc2_++;
                  }
                  _loc3_++;
               }
               alpha = 1;
               break;
            case Environment.EFFECT_SILK:
               this.tx1 = 0;
               this.ty1 = 0;
               this.tx2 = 0;
               this.ty2 = 0;
               this.bdScale = 2;
               this.bdScale2 = 2;
               this.bdSmooth = false;
               param1.perlinNoise(60,60,1,3049 + Math.random() * 1000,true,false,BitmapDataChannel.ALPHA,true);
               alpha = 0.5;
               this.bdSmooth = false;
               break;
            case Environment.EFFECT_LEAFY:
               this.tx1 = 0;
               this.ty1 = 0;
               this.tx2 = 0;
               this.ty2 = 0;
               this.bdScale = 1;
               this.bdScale2 = 1;
               this.bdSmooth = false;
               param1.perlinNoise(60,60,1,3049 + Math.random() * 1000,true,false,BitmapDataChannel.ALPHA,true);
               ReduceColors.toEGA(param1);
               alpha = 0.25;
               break;
            case Environment.EFFECT_SMOKE:
               this.tx1 = 0.5;
               this.ty1 = 0;
               this.tx2 = 0.25;
               this.ty2 = 0;
               this.bdScale = 2;
               this.bdScale2 = 1;
               this.bdSmooth = false;
               param1.perlinNoise(200,100,2,3049 + Math.random() * 1000,true,false,BitmapDataChannel.ALPHA,true);
               _loc6_ = new BitmapData(this.bdSize,this.bdSize,true,4294967295);
               param1.copyChannel(_loc6_,this.r,new Point(0,0),1,1);
               param1.copyChannel(_loc6_,this.r,new Point(0,0),2,2);
               param1.copyChannel(_loc6_,this.r,new Point(0,0),4,4);
               ReduceColors.toVGA(param1,false,true);
               alpha = 0.5;
               break;
            case Environment.EFFECT_GRID:
               this.tx1 = 0;
               this.ty1 = 0;
               this.tx2 = 0;
               this.ty2 = 0;
               this.bdScale = 1;
               this.bdScale2 = 1;
               this.bdSmooth = false;
               _loc2_ = 0;
               while(_loc2_ < this.bdSize)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.bdSize)
                  {
                     if((_loc2_ + 10) % 20 == 0 && (_loc3_ + 10) % 20 == 0)
                     {
                        param1.setPixel32(_loc2_,_loc3_,872415231);
                     }
                     _loc3_++;
                  }
                  _loc2_++;
               }
               alpha = 1;
         }
         this.tx1 *= skip;
         this.ty1 *= skip;
      }
      
      public function update(param1:Event = null) : void
      {
         if(skip > 1)
         {
            ++this._fm;
            if(this._fm % skip != 0)
            {
               return;
            }
            this._fm = 0;
         }
         var _loc2_:Graphics = graphics;
         _loc2_.clear();
         this.m.tx += this.tx1;
         this.m.ty += this.ty1;
         this.m.ty %= this.bdSize * this.bdScale;
         this.m.tx %= this.bdSize * this.bdScale;
         this.m.tx -= this.cameraX - this._cameraPX;
         this.m.ty -= this.cameraY - this._cameraPY;
         _loc2_.beginBitmapFill(this.bd,this.m,true,this.bdSmooth);
         _loc2_.drawRect(0,0,this._width,this._height);
         _loc2_.endFill();
         this.m2.tx += this.tx2;
         this.m2.ty += this.ty2;
         this.m2.ty %= this.bdSize * this.bdScale2;
         this.m2.tx %= this.bdSize * this.bdScale2;
         this.m2.tx -= this.cameraX - this._cameraPX;
         this.m2.ty -= this.cameraY - this._cameraPY;
         _loc2_.beginBitmapFill(this.bd2,this.m2,true,this.bdSmooth);
         _loc2_.drawRect(0,0,this._width,this._height);
         _loc2_.endFill();
         this._cameraPX = this.cameraX;
         this._cameraPY = this.cameraY;
      }
      
      protected function onRemove(param1:Event = null) : void
      {
         if(!this._built)
         {
            return;
         }
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemove);
         stage.removeEventListener(Event.ENTER_FRAME,this.update);
         if(this.bd)
         {
            this.bd.dispose();
         }
         if(this.bd2)
         {
            this.bd2.dispose();
         }
         graphics.clear();
         this._built = false;
         if(param1)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.build);
         }
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         if(param1 != this._type)
         {
            this._type = param1;
            this.rebuild();
         }
      }
      
      public function get isStatic() : Boolean
      {
         return this._isStatic;
      }
      
      public function end() : void
      {
         if(stage)
         {
            stage.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemove);
         }
         if(stage)
         {
            stage.removeEventListener(Event.ENTER_FRAME,this.update);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this.bd)
         {
            this.bd.dispose();
         }
         if(this.bd2)
         {
            this.bd2.dispose();
         }
         graphics.clear();
         this._built = false;
      }
   }
}

