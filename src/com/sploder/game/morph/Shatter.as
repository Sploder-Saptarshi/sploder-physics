package com.sploder.game.morph
{
   import com.sploder.game.ViewSprite;
   import com.sploder.util.Geom2d;
   import com.sploder.util.delaunay.Delaunay;
   import com.sploder.util.delaunay.XYZ;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class Shatter extends Morph
   {
      public static var gravPull:int = 2;
      
      public var fragments:Array;
      
      protected var force:Point;
      
      protected var contact:Point;
      
      protected var explosionScale:Number;
      
      protected var vectors:Dictionary;
      
      protected var hullOffset:int = 0;
      
      protected var gravPt:Point;
      
      protected var turbo:Boolean = false;
      
      public function Shatter(param1:ViewSprite, param2:Vector.<Point>, param3:Number = 40, param4:Boolean = true, param5:Number = 1, param6:Point = null, param7:Point = null, param8:uint = 0, param9:Boolean = false)
      {
         super(param1,990,false);
         this.vectors = new Dictionary();
         if(!param4)
         {
            this.hullOffset = Math.max(param1.width,param1.height) / 10;
         }
         if(param6 != null)
         {
            this.force = param6;
         }
         else
         {
            this.force = new Point(0,0);
         }
         this.gravPt = new Point(0,gravPull);
         this.turbo = param9;
         this.doShatter(param2,param3,param8);
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         if(param4)
         {
            this.explosionScale = 100 / Math.max(param1.width,param1.height);
            this.explosionScale *= param5;
         }
         if(param4)
         {
            if(stage)
            {
               this.startMorph();
            }
            else
            {
               addEventListener(Event.ADDED_TO_STAGE,this.startMorph);
            }
         }
      }
      
      override public function startMorph(param1:Event = null) : void
      {
         var _loc3_:Shape = null;
         var _loc2_:Point = new Point();
         for each(_loc3_ in this.fragments)
         {
            _loc2_.x = this.contact != null ? 0 - this.contact.x * 0.5 + _loc3_.x : _loc3_.x;
            _loc2_.y = this.contact != null ? 0 - this.contact.y * 0.5 + _loc3_.y : _loc3_.y;
            _loc3_.alpha = 2;
            this.vectors[_loc3_] = new Point((_loc2_.x / 4 + this.force.x) * this.explosionScale * (Math.random() + 0.5),(_loc2_.y / 4 + this.force.y) * this.explosionScale * (Math.random() + 0.5));
         }
         super.startMorph();
      }
      
      public function scaleFragments(param1:Number = 1) : void
      {
         var _loc2_:Shape = null;
         for each(_loc2_ in this.fragments)
         {
            _loc2_.scaleX = _loc2_.scaleY = param1;
         }
      }
      
      override protected function doMorph(param1:Event) : void
      {
         var _loc2_:Shape = null;
         if(_clip == null)
         {
            return;
         }
         if(this.fragments == null)
         {
            return;
         }
         for each(_loc2_ in this.fragments)
         {
            try
            {
               if(Boolean(_loc2_) && Boolean(this.vectors[_loc2_]))
               {
                  _loc2_.x += this.vectors[_loc2_].x;
                  _loc2_.y += this.vectors[_loc2_].y;
                  this.vectors[_loc2_].x += this.gravPt.x;
                  this.vectors[_loc2_].y += this.gravPt.y;
                  this.vectors[_loc2_].x *= 0.95;
                  this.vectors[_loc2_].y *= 0.95;
                  _loc2_.scaleX *= 0.98;
                  _loc2_.scaleY *= 0.98;
                  _loc2_.rotation += this.vectors[_loc2_].x + this.vectors[_loc2_].y;
                  _loc2_.alpha *= 0.95;
               }
            }
            catch(e:Error)
            {
            }
         }
         super.doMorph(param1);
      }
      
      override protected function completeMorph() : void
      {
         super.completeMorph();
         this.vectors = null;
      }
      
      protected function pointsClone(param1:Vector.<Point>) : Vector.<Point>
      {
         var _loc2_:Vector.<Point> = null;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc2_ = new Vector.<Point>();
            _loc3_ = int(param1.length);
            while(_loc3_--)
            {
               _loc2_.unshift(param1[_loc3_].clone());
            }
            return _loc2_;
         }
         return null;
      }
      
      protected function doShatter(param1:Vector.<Point>, param2:Number = 40, param3:uint = 16777215) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc9_:Number = _clip.rotation;
         _clip.rotation = 0;
         _loc4_ = getTimer();
         param1 = this.pointsClone(param1);
         while(Math.min(_clip.width,_clip.height) < param2 * 2)
         {
            param2 /= 2;
         }
         _loc6_ = 0 - _clip.height / 2;
         while(_loc6_ < _clip.height / 2)
         {
            _loc5_ = 0 - _clip.width / 2;
            while(_loc5_ < _clip.width / 2)
            {
               if(Boolean(parent) && hitTestPoint(x + parent.x + _loc5_,y + parent.y + _loc6_,true))
               {
                  _loc7_ = _loc5_;
                  _loc8_ = _loc6_;
                  if(_loc5_ > 0 - _clip.width / 2 + 10 && _loc5_ < _clip.width / 2 - 10)
                  {
                     _loc7_ += Math.random() * param2 / 2 - param2 / 4;
                  }
                  if(_loc6_ > 0 - _clip.height / 2 + 10 && _loc6_ < _clip.height / 2 - 10)
                  {
                     _loc8_ += Math.random() * param2 / 2 - param2 / 4;
                  }
                  if(Math.random() > 0.3)
                  {
                     param1.push(new Point(_loc7_,_loc8_));
                  }
               }
               _loc5_ += param2;
            }
            _loc6_ += param2;
         }
         if(_loc9_ != 0)
         {
            _loc5_ = int(param1.length);
            _loc10_ = _loc9_ * Geom2d.dtr;
            while(_loc5_--)
            {
               Geom2d.rotate(param1[_loc5_],_loc10_);
            }
         }
         if(param1.length > 2)
         {
            _loc11_ = [];
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc11_.push(new XYZ(param1[_loc5_].x,param1[_loc5_].y));
               _loc5_++;
            }
            _loc12_ = Delaunay.triangulate(_loc11_);
            this.fragments = Delaunay.drawDelaunay(_loc12_,_loc11_,this,param3,1,this.turbo);
         }
      }
   }
}

