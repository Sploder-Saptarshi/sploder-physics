package com.sploder.game
{
   import com.sploder.builder.Textures;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import nape.phys.Body;
   
   public class ViewAnimationManager
   {
      protected var _view:View;
      
      protected var _viewSprites:Vector.<ViewSprite>;
      
      protected var _bodies:Dictionary;
      
      protected var _ended:Boolean;
      
      protected var _origin:Point;
      
      protected var _lastFrame:Dictionary;
      
      protected var _frame:int = 0;
      
      public function ViewAnimationManager(param1:View)
      {
         super();
         this.init(param1);
      }
      
      protected function init(param1:View) : void
      {
         this._view = param1;
         this._viewSprites = new Vector.<ViewSprite>();
         this._origin = new Point();
         this._lastFrame = new Dictionary(true);
         this._bodies = new Dictionary(true);
         this._ended = false;
      }
      
      public function register(param1:ViewSprite, param2:Body) : void
      {
         if(this._ended)
         {
            return;
         }
         if(this._viewSprites.indexOf(param1) == -1)
         {
            this._viewSprites.push(param1);
            this._bodies[param1] = param2;
            this._lastFrame[param1] = this._frame;
         }
      }
      
      public function unregister(param1:ViewSprite) : void
      {
         if(this._ended)
         {
            return;
         }
         if(this._viewSprites.indexOf(param1) != -1)
         {
            this._viewSprites.splice(this._viewSprites.indexOf(param1),1);
            this._bodies[param1] = null;
            delete this._bodies[param1];
         }
      }
      
      public function update() : void
      {
         var _loc2_:ViewSprite = null;
         var _loc3_:Body = null;
         var _loc4_:BitmapData = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this._ended)
         {
            return;
         }
         ++this._frame;
         var _loc1_:int = int(this._viewSprites.length);
         while(_loc1_--)
         {
            _loc2_ = this._viewSprites[_loc1_];
            if(_loc2_.visible)
            {
               if(Boolean(_loc2_.modelObject) && Boolean(_loc2_.modelObject.props.graphic_flip))
               {
                  if(this._bodies[_loc2_] is Body)
                  {
                     _loc3_ = Body(this._bodies[_loc2_]);
                     if(_loc3_.vx > 2 && _loc2_.flipped)
                     {
                        _loc2_.flipped = false;
                        _loc2_.scaleX = 1;
                     }
                     if(_loc3_.vx < -2 && !_loc2_.flipped)
                     {
                        _loc2_.flipped = true;
                        _loc2_.scaleX = -1;
                     }
                  }
               }
               if(Boolean(_loc2_.modelObject) && _loc2_.modelObject.props.animation >= 3)
               {
                  if(this._bodies[_loc2_] is Body)
                  {
                     _loc3_ = Body(this._bodies[_loc2_]);
                     _loc5_ = Math.abs(_loc3_.vx);
                     _loc6_ = Math.abs(_loc3_.vy);
                     if(_loc5_ > _loc6_)
                     {
                        if(_loc3_.vx > 0.15)
                        {
                           _loc2_.rotated = true;
                           _loc2_.rotatedRotation = 90;
                        }
                        else if(_loc3_.vx < -0.15)
                        {
                           _loc2_.rotated = true;
                           _loc2_.rotatedRotation = -90;
                        }
                     }
                     else if(_loc3_.vy > 0.15)
                     {
                        _loc2_.rotated = true;
                        _loc2_.rotatedRotation = 180;
                     }
                     else if(_loc3_.vy < -0.15)
                     {
                        _loc2_.rotated = true;
                        _loc2_.rotatedRotation = 0;
                     }
                  }
                  if(!_loc2_.doCycle && _loc2_.modelObject && _loc2_.modelObject.props.animation == 4)
                  {
                     if(this._bodies[_loc2_] is Body)
                     {
                        _loc3_ = Body(this._bodies[_loc2_]);
                        if(_loc3_.vx > 10 || _loc3_.vx < -10 || _loc3_.vy > 10 || _loc3_.vy < -10)
                        {
                           _loc2_.doCycle = true;
                        }
                     }
                     if(!_loc2_.doCycle && _loc2_.frame != 0)
                     {
                        _loc2_.frame = 0;
                        _loc4_ = Textures.getScaledBitmapData(_loc2_.textureName,8,_loc2_.frame);
                        if(_loc4_)
                        {
                           _loc2_.bitmapData.copyPixels(_loc4_,_loc2_.r,this._origin);
                        }
                        this._lastFrame[_loc2_] = this._frame;
                     }
                  }
               }
               else if(!_loc2_.doCycle && _loc2_.modelObject && _loc2_.modelObject.props.animation == 2)
               {
                  if(this._bodies[_loc2_] is Body)
                  {
                     _loc3_ = Body(this._bodies[_loc2_]);
                     if(_loc3_.vx > 25 || _loc3_.vx < -25)
                     {
                        _loc2_.doCycle = true;
                     }
                     else if(_loc3_.space.gravityy == 0 && (_loc3_.vy > 25 || _loc3_.vy < -25))
                     {
                        _loc2_.doCycle = true;
                     }
                  }
                  if(!_loc2_.doCycle && _loc2_.frame != 0)
                  {
                     _loc2_.frame = 0;
                     _loc4_ = Textures.getScaledBitmapData(_loc2_.textureName,8,_loc2_.frame);
                     if(_loc4_)
                     {
                        _loc2_.bitmapData.copyPixels(_loc4_,_loc2_.r,this._origin);
                     }
                     this._lastFrame[_loc2_] = this._frame;
                  }
               }
               if(_loc2_.doCycle && this._frame - Number(this._lastFrame[_loc2_]) >= 7)
               {
                  _loc2_.frame = _loc2_.frame < _loc2_.totalFrames - 1 ? _loc2_.frame + 1 : 0;
                  _loc4_ = Textures.getScaledBitmapData(_loc2_.textureName,8,_loc2_.frame);
                  if(_loc4_)
                  {
                     _loc2_.bitmapData.copyPixels(_loc4_,_loc2_.r,this._origin);
                  }
                  this._lastFrame[_loc2_] = this._frame;
                  if(_loc2_.frame == _loc2_.totalFrames - 1 && _loc2_.modelObject && (_loc2_.modelObject.props.animation == 2 || _loc2_.modelObject.props.animation == 4))
                  {
                     _loc2_.doCycle = false;
                  }
               }
            }
         }
      }
      
      public function end() : void
      {
         this._viewSprites = null;
         this._ended = true;
      }
   }
}

