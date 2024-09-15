package com.sploder.game.sound
{
   public class SfxrParams
   {
      public var paramsDirty:Boolean;
      
      private var _waveType:uint = 0;
      
      private var _masterVolume:Number = 0.5;
      
      private var _attackTime:Number = 0;
      
      private var _sustainTime:Number = 0;
      
      private var _sustainPunch:Number = 0;
      
      private var _decayTime:Number = 0;
      
      private var _startFrequency:Number = 0;
      
      private var _minFrequency:Number = 0;
      
      private var _slide:Number = 0;
      
      private var _deltaSlide:Number = 0;
      
      private var _vibratoDepth:Number = 0;
      
      private var _vibratoSpeed:Number = 0;
      
      private var _changeAmount:Number = 0;
      
      private var _changeSpeed:Number = 0;
      
      private var _squareDuty:Number = 0;
      
      private var _dutySweep:Number = 0;
      
      private var _repeatSpeed:Number = 0;
      
      private var _phaserOffset:Number = 0;
      
      private var _phaserSweep:Number = 0;
      
      private var _lpFilterCutoff:Number = 0;
      
      private var _lpFilterCutoffSweep:Number = 0;
      
      private var _lpFilterResonance:Number = 0;
      
      private var _hpFilterCutoff:Number = 0;
      
      private var _hpFilterCutoffSweep:Number = 0;
      
      public function SfxrParams()
      {
         super();
      }
      
      public function get waveType() : uint
      {
         return this._waveType;
      }
      
      public function set waveType(param1:uint) : void
      {
         this._waveType = param1 > 3 ? 0 : param1;
         this.paramsDirty = true;
      }
      
      public function get masterVolume() : Number
      {
         return this._masterVolume;
      }
      
      public function set masterVolume(param1:Number) : void
      {
         this._masterVolume = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get attackTime() : Number
      {
         return this._attackTime;
      }
      
      public function set attackTime(param1:Number) : void
      {
         this._attackTime = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get sustainTime() : Number
      {
         return this._sustainTime;
      }
      
      public function set sustainTime(param1:Number) : void
      {
         this._sustainTime = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get sustainPunch() : Number
      {
         return this._sustainPunch;
      }
      
      public function set sustainPunch(param1:Number) : void
      {
         this._sustainPunch = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get decayTime() : Number
      {
         return this._decayTime;
      }
      
      public function set decayTime(param1:Number) : void
      {
         this._decayTime = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get startFrequency() : Number
      {
         return this._startFrequency;
      }
      
      public function set startFrequency(param1:Number) : void
      {
         this._startFrequency = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get minFrequency() : Number
      {
         return this._minFrequency;
      }
      
      public function set minFrequency(param1:Number) : void
      {
         this._minFrequency = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get slide() : Number
      {
         return this._slide;
      }
      
      public function set slide(param1:Number) : void
      {
         this._slide = this.clamp2(param1);
         this.paramsDirty = true;
      }
      
      public function get deltaSlide() : Number
      {
         return this._deltaSlide;
      }
      
      public function set deltaSlide(param1:Number) : void
      {
         this._deltaSlide = this.clamp2(param1);
         this.paramsDirty = true;
      }
      
      public function get vibratoDepth() : Number
      {
         return this._vibratoDepth;
      }
      
      public function set vibratoDepth(param1:Number) : void
      {
         this._vibratoDepth = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get vibratoSpeed() : Number
      {
         return this._vibratoSpeed;
      }
      
      public function set vibratoSpeed(param1:Number) : void
      {
         this._vibratoSpeed = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get changeAmount() : Number
      {
         return this._changeAmount;
      }
      
      public function set changeAmount(param1:Number) : void
      {
         this._changeAmount = this.clamp2(param1);
         this.paramsDirty = true;
      }
      
      public function get changeSpeed() : Number
      {
         return this._changeSpeed;
      }
      
      public function set changeSpeed(param1:Number) : void
      {
         this._changeSpeed = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get squareDuty() : Number
      {
         return this._squareDuty;
      }
      
      public function set squareDuty(param1:Number) : void
      {
         this._squareDuty = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get dutySweep() : Number
      {
         return this._dutySweep;
      }
      
      public function set dutySweep(param1:Number) : void
      {
         this._dutySweep = this.clamp2(param1);
         this.paramsDirty = true;
      }
      
      public function get repeatSpeed() : Number
      {
         return this._repeatSpeed;
      }
      
      public function set repeatSpeed(param1:Number) : void
      {
         this._repeatSpeed = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get phaserOffset() : Number
      {
         return this._phaserOffset;
      }
      
      public function set phaserOffset(param1:Number) : void
      {
         this._phaserOffset = this.clamp2(param1);
         this.paramsDirty = true;
      }
      
      public function get phaserSweep() : Number
      {
         return this._phaserSweep;
      }
      
      public function set phaserSweep(param1:Number) : void
      {
         this._phaserSweep = this.clamp2(param1);
         this.paramsDirty = true;
      }
      
      public function get lpFilterCutoff() : Number
      {
         return this._lpFilterCutoff;
      }
      
      public function set lpFilterCutoff(param1:Number) : void
      {
         this._lpFilterCutoff = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get lpFilterCutoffSweep() : Number
      {
         return this._lpFilterCutoffSweep;
      }
      
      public function set lpFilterCutoffSweep(param1:Number) : void
      {
         this._lpFilterCutoffSweep = this.clamp2(param1);
         this.paramsDirty = true;
      }
      
      public function get lpFilterResonance() : Number
      {
         return this._lpFilterResonance;
      }
      
      public function set lpFilterResonance(param1:Number) : void
      {
         this._lpFilterResonance = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get hpFilterCutoff() : Number
      {
         return this._hpFilterCutoff;
      }
      
      public function set hpFilterCutoff(param1:Number) : void
      {
         this._hpFilterCutoff = this.clamp1(param1);
         this.paramsDirty = true;
      }
      
      public function get hpFilterCutoffSweep() : Number
      {
         return this._hpFilterCutoffSweep;
      }
      
      public function set hpFilterCutoffSweep(param1:Number) : void
      {
         this._hpFilterCutoffSweep = this.clamp2(param1);
         this.paramsDirty = true;
      }
      
      public function generatePickupCoin() : void
      {
         this.resetParams();
         this._startFrequency = 0.4 + Math.random() * 0.5;
         this._sustainTime = Math.random() * 0.1;
         this._decayTime = 0.1 + Math.random() * 0.4;
         this._sustainPunch = 0.3 + Math.random() * 0.3;
         if(Math.random() < 0.5)
         {
            this._changeSpeed = 0.5 + Math.random() * 0.2;
            this._changeAmount = 0.2 + Math.random() * 0.4;
         }
      }
      
      public function generateLaserShoot() : void
      {
         this.resetParams();
         this._waveType = uint(Math.random() * 3);
         if(this._waveType == 2 && Math.random() < 0.5)
         {
            this._waveType = uint(Math.random() * 2);
         }
         this._startFrequency = 0.5 + Math.random() * 0.5;
         this._minFrequency = this._startFrequency - 0.2 - Math.random() * 0.6;
         if(this._minFrequency < 0.2)
         {
            this._minFrequency = 0.2;
         }
         this._slide = -0.15 - Math.random() * 0.2;
         if(Math.random() < 0.33)
         {
            this._startFrequency = 0.3 + Math.random() * 0.6;
            this._minFrequency = Math.random() * 0.1;
            this._slide = -0.35 - Math.random() * 0.3;
         }
         if(Math.random() < 0.5)
         {
            this._squareDuty = Math.random() * 0.5;
            this._dutySweep = Math.random() * 0.2;
         }
         else
         {
            this._squareDuty = 0.4 + Math.random() * 0.5;
            this._dutySweep = -Math.random() * 0.7;
         }
         this._sustainTime = 0.1 + Math.random() * 0.2;
         this._decayTime = Math.random() * 0.4;
         if(Math.random() < 0.5)
         {
            this._sustainPunch = Math.random() * 0.3;
         }
         if(Math.random() < 0.33)
         {
            this._phaserOffset = Math.random() * 0.2;
            this._phaserSweep = -Math.random() * 0.2;
         }
         if(Math.random() < 0.5)
         {
            this._hpFilterCutoff = Math.random() * 0.3;
         }
      }
      
      public function generateExplosion() : void
      {
         this.resetParams();
         this._waveType = 3;
         if(Math.random() < 0.5)
         {
            this._startFrequency = 0.1 + Math.random() * 0.4;
            this._slide = -0.1 + Math.random() * 0.4;
         }
         else
         {
            this._startFrequency = 0.2 + Math.random() * 0.7;
            this._slide = -0.2 - Math.random() * 0.2;
         }
         this._startFrequency *= this._startFrequency;
         if(Math.random() < 0.2)
         {
            this._slide = 0;
         }
         if(Math.random() < 0.33)
         {
            this._repeatSpeed = 0.3 + Math.random() * 0.5;
         }
         this._sustainTime = 0.1 + Math.random() * 0.3;
         this._decayTime = Math.random() * 0.5;
         this._sustainPunch = 0.2 + Math.random() * 0.6;
         if(Math.random() < 0.5)
         {
            this._phaserOffset = -0.3 + Math.random() * 0.9;
            this._phaserSweep = -Math.random() * 0.3;
         }
         if(Math.random() < 0.33)
         {
            this._changeSpeed = 0.6 + Math.random() * 0.3;
            this._changeAmount = 0.8 - Math.random() * 1.6;
         }
      }
      
      public function generatePowerup() : void
      {
         this.resetParams();
         if(Math.random() < 0.5)
         {
            this._waveType = 1;
         }
         else
         {
            this._squareDuty = Math.random() * 0.6;
         }
         if(Math.random() < 0.5)
         {
            this._startFrequency = 0.2 + Math.random() * 0.3;
            this._slide = 0.1 + Math.random() * 0.4;
            this._repeatSpeed = 0.4 + Math.random() * 0.4;
         }
         else
         {
            this._startFrequency = 0.2 + Math.random() * 0.3;
            this._slide = 0.05 + Math.random() * 0.2;
            if(Math.random() < 0.5)
            {
               this._vibratoDepth = Math.random() * 0.7;
               this._vibratoSpeed = Math.random() * 0.6;
            }
         }
         this._sustainTime = Math.random() * 0.4;
         this._decayTime = 0.1 + Math.random() * 0.4;
      }
      
      public function generateHitHurt() : void
      {
         this.resetParams();
         this._waveType = uint(Math.random() * 3);
         if(this._waveType == 2)
         {
            this._waveType = 3;
         }
         else if(this._waveType == 0)
         {
            this._squareDuty = Math.random() * 0.6;
         }
         this._startFrequency = 0.2 + Math.random() * 0.6;
         this._slide = -0.3 - Math.random() * 0.4;
         this._sustainTime = Math.random() * 0.1;
         this._decayTime = 0.1 + Math.random() * 0.2;
         if(Math.random() < 0.5)
         {
            this._hpFilterCutoff = Math.random() * 0.3;
         }
      }
      
      public function generateJump() : void
      {
         this.resetParams();
         this._waveType = 0;
         this._squareDuty = Math.random() * 0.6;
         this._startFrequency = 0.3 + Math.random() * 0.3;
         this._slide = 0.1 + Math.random() * 0.2;
         this._sustainTime = 0.1 + Math.random() * 0.3;
         this._decayTime = 0.1 + Math.random() * 0.2;
         if(Math.random() < 0.5)
         {
            this._hpFilterCutoff = Math.random() * 0.3;
         }
         if(Math.random() < 0.5)
         {
            this._lpFilterCutoff = 1 - Math.random() * 0.6;
         }
      }
      
      public function generateBlipSelect() : void
      {
         this.resetParams();
         this._waveType = uint(Math.random() * 2);
         if(this._waveType == 0)
         {
            this._squareDuty = Math.random() * 0.6;
         }
         this._startFrequency = 0.2 + Math.random() * 0.4;
         this._sustainTime = 0.1 + Math.random() * 0.1;
         this._decayTime = Math.random() * 0.2;
         this._hpFilterCutoff = 0.1;
      }
      
      protected function resetParams() : void
      {
         this.paramsDirty = true;
         this._waveType = 0;
         this._startFrequency = 0.3;
         this._minFrequency = 0;
         this._slide = 0;
         this._deltaSlide = 0;
         this._squareDuty = 0;
         this._dutySweep = 0;
         this._vibratoDepth = 0;
         this._vibratoSpeed = 0;
         this._attackTime = 0;
         this._sustainTime = 0.3;
         this._decayTime = 0.4;
         this._sustainPunch = 0;
         this._lpFilterResonance = 0;
         this._lpFilterCutoff = 1;
         this._lpFilterCutoffSweep = 0;
         this._hpFilterCutoff = 0;
         this._hpFilterCutoffSweep = 0;
         this._phaserOffset = 0;
         this._phaserSweep = 0;
         this._repeatSpeed = 0;
         this._changeSpeed = 0;
         this._changeAmount = 0;
      }
      
      public function mutate(param1:Number = 0.05) : void
      {
         if(Math.random() < 0.5)
         {
            this.startFrequency += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.minFrequency += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.slide += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.deltaSlide += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.squareDuty += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.dutySweep += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.vibratoDepth += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.vibratoSpeed += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.attackTime += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.sustainTime += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.decayTime += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.sustainPunch += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.lpFilterCutoff += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.lpFilterCutoffSweep += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.lpFilterResonance += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.hpFilterCutoff += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.hpFilterCutoffSweep += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.phaserOffset += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.phaserSweep += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.repeatSpeed += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.changeSpeed += Math.random() * param1 * 2 - param1;
         }
         if(Math.random() < 0.5)
         {
            this.changeAmount += Math.random() * param1 * 2 - param1;
         }
      }
      
      public function randomize() : void
      {
         this.paramsDirty = true;
         this._waveType = uint(Math.random() * 4);
         this._attackTime = this.pow(Math.random() * 2 - 1,4);
         this._sustainTime = this.pow(Math.random() * 2 - 1,2);
         this._sustainPunch = this.pow(Math.random() * 0.8,2);
         this._decayTime = Math.random();
         this._startFrequency = Math.random() < 0.5 ? this.pow(Math.random() * 2 - 1,2) : this.pow(Math.random() * 0.5,3) + 0.5;
         this._minFrequency = 0;
         this._slide = this.pow(Math.random() * 2 - 1,5);
         this._deltaSlide = this.pow(Math.random() * 2 - 1,3);
         this._vibratoDepth = this.pow(Math.random() * 2 - 1,3);
         this._vibratoSpeed = Math.random() * 2 - 1;
         this._changeAmount = Math.random() * 2 - 1;
         this._changeSpeed = Math.random() * 2 - 1;
         this._squareDuty = Math.random() * 2 - 1;
         this._dutySweep = this.pow(Math.random() * 2 - 1,3);
         this._repeatSpeed = Math.random() * 2 - 1;
         this._phaserOffset = this.pow(Math.random() * 2 - 1,3);
         this._phaserSweep = this.pow(Math.random() * 2 - 1,3);
         this._lpFilterCutoff = 1 - this.pow(Math.random(),3);
         this._lpFilterCutoffSweep = this.pow(Math.random() * 2 - 1,3);
         this._lpFilterResonance = Math.random() * 2 - 1;
         this._hpFilterCutoff = this.pow(Math.random(),5);
         this._hpFilterCutoffSweep = this.pow(Math.random() * 2 - 1,5);
         if(this._attackTime + this._sustainTime + this._decayTime < 0.2)
         {
            this._sustainTime = 0.2 + Math.random() * 0.3;
            this._decayTime = 0.2 + Math.random() * 0.3;
         }
         if(this._startFrequency > 0.7 && this._slide > 0.2 || this._startFrequency < 0.2 && this._slide < -0.05)
         {
            this._slide = -this._slide;
         }
         if(this._lpFilterCutoff < 0.1 && this._lpFilterCutoffSweep < -0.05)
         {
            this._lpFilterCutoffSweep = -this._lpFilterCutoffSweep;
         }
      }
      
      public function getSettingsString() : String
      {
         var _loc1_:String = String(this.waveType);
         return _loc1_ + ("," + this.to4DP(this._attackTime) + "," + this.to4DP(this._sustainTime) + "," + this.to4DP(this._sustainPunch) + "," + this.to4DP(this._decayTime) + "," + this.to4DP(this._startFrequency) + "," + this.to4DP(this._minFrequency) + "," + this.to4DP(this._slide) + "," + this.to4DP(this._deltaSlide) + "," + this.to4DP(this._vibratoDepth) + "," + this.to4DP(this._vibratoSpeed) + "," + this.to4DP(this._changeAmount) + "," + this.to4DP(this._changeSpeed) + "," + this.to4DP(this._squareDuty) + "," + this.to4DP(this._dutySweep) + "," + this.to4DP(this._repeatSpeed) + "," + this.to4DP(this._phaserOffset) + "," + this.to4DP(this._phaserSweep) + "," + this.to4DP(this._lpFilterCutoff) + "," + this.to4DP(this._lpFilterCutoffSweep) + "," + this.to4DP(this._lpFilterResonance) + "," + this.to4DP(this._hpFilterCutoff) + "," + this.to4DP(this._hpFilterCutoffSweep) + "," + this.to4DP(this._masterVolume));
      }
      
      public function setSettingsString(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split(",");
         if(_loc2_.length != 24)
         {
            return false;
         }
         this.waveType = uint(_loc2_[0]) || 0;
         this.attackTime = Number(_loc2_[1]) || 0;
         this.sustainTime = Number(_loc2_[2]) || 0;
         this.sustainPunch = Number(_loc2_[3]) || 0;
         this.decayTime = Number(_loc2_[4]) || 0;
         this.startFrequency = Number(_loc2_[5]) || 0;
         this.minFrequency = Number(_loc2_[6]) || 0;
         this.slide = Number(_loc2_[7]) || 0;
         this.deltaSlide = Number(_loc2_[8]) || 0;
         this.vibratoDepth = Number(_loc2_[9]) || 0;
         this.vibratoSpeed = Number(_loc2_[10]) || 0;
         this.changeAmount = Number(_loc2_[11]) || 0;
         this.changeSpeed = Number(_loc2_[12]) || 0;
         this.squareDuty = Number(_loc2_[13]) || 0;
         this.dutySweep = Number(_loc2_[14]) || 0;
         this.repeatSpeed = Number(_loc2_[15]) || 0;
         this.phaserOffset = Number(_loc2_[16]) || 0;
         this.phaserSweep = Number(_loc2_[17]) || 0;
         this.lpFilterCutoff = Number(_loc2_[18]) || 0;
         this.lpFilterCutoffSweep = Number(_loc2_[19]) || 0;
         this.lpFilterResonance = Number(_loc2_[20]) || 0;
         this.hpFilterCutoff = Number(_loc2_[21]) || 0;
         this.hpFilterCutoffSweep = Number(_loc2_[22]) || 0;
         this.masterVolume = Number(_loc2_[23]) || 0;
         return true;
      }
      
      public function clone() : SfxrParams
      {
         var _loc1_:SfxrParams = new SfxrParams();
         _loc1_.copyFrom(this);
         return _loc1_;
      }
      
      public function copyFrom(param1:SfxrParams, param2:Boolean = false) : void
      {
         this._waveType = param1.waveType;
         this._attackTime = param1.attackTime;
         this._sustainTime = param1.sustainTime;
         this._sustainPunch = param1.sustainPunch;
         this._decayTime = param1.decayTime;
         this._startFrequency = param1.startFrequency;
         this._minFrequency = param1.minFrequency;
         this._slide = param1.slide;
         this._deltaSlide = param1.deltaSlide;
         this._vibratoDepth = param1.vibratoDepth;
         this._vibratoSpeed = param1.vibratoSpeed;
         this._changeAmount = param1.changeAmount;
         this._changeSpeed = param1.changeSpeed;
         this._squareDuty = param1.squareDuty;
         this._dutySweep = param1.dutySweep;
         this._repeatSpeed = param1.repeatSpeed;
         this._phaserOffset = param1.phaserOffset;
         this._phaserSweep = param1.phaserSweep;
         this._lpFilterCutoff = param1.lpFilterCutoff;
         this._lpFilterCutoffSweep = param1.lpFilterCutoffSweep;
         this._lpFilterResonance = param1.lpFilterResonance;
         this._hpFilterCutoff = param1.hpFilterCutoff;
         this._hpFilterCutoffSweep = param1.hpFilterCutoffSweep;
         this._masterVolume = param1.masterVolume;
         if(param2)
         {
            this.paramsDirty = true;
         }
      }
      
      private function clamp1(param1:Number) : Number
      {
         return param1 > 1 ? 1 : (param1 < 0 ? 0 : param1);
      }
      
      private function clamp2(param1:Number) : Number
      {
         return param1 > 1 ? 1 : (param1 < -1 ? -1 : param1);
      }
      
      private function pow(param1:Number, param2:int) : Number
      {
         switch(param2)
         {
            case 2:
               return param1 * param1;
            case 3:
               return param1 * param1 * param1;
            case 4:
               return param1 * param1 * param1 * param1;
            case 5:
               return param1 * param1 * param1 * param1 * param1;
            default:
               return 1;
         }
      }
      
      private function to4DP(param1:Number) : String
      {
         var _loc4_:String = null;
         if(param1 < 0.0001 && param1 > -0.0001)
         {
            return "";
         }
         var _loc2_:String = String(param1);
         var _loc3_:Array = _loc2_.split(".");
         if(_loc3_.length == 1)
         {
            return _loc2_;
         }
         _loc4_ = _loc3_[0] + "." + _loc3_[1].substr(0,4);
         while(_loc4_.substr(_loc4_.length - 1,1) == "0")
         {
            _loc4_ = _loc4_.substr(0,_loc4_.length - 1);
         }
         return _loc4_;
      }
   }
}

