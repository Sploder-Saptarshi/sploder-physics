package com.sploder.game.sound
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.SampleDataEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.getTimer;
   
   public class SfxrSynth
   {
      public var busy:Boolean = false;
      
      private var _ready:Boolean = false;
      
      private var _params:SfxrParams;
      
      private var _sound:Sound;
      
      private var _channel:SoundChannel;
      
      private var _mutation:Boolean;
      
      private var _cachedWave:ByteArray;
      
      private var _cachingNormal:Boolean;
      
      private var _cachingMutation:int;
      
      private var _cachedMutation:ByteArray;
      
      private var _cachedMutations:Vector.<ByteArray>;
      
      private var _cachedMutationsNum:uint;
      
      private var _cachedMutationAmount:Number;
      
      private var _cachingAsync:Boolean;
      
      private var _cacheTimePerFrame:uint;
      
      private var _cachedCallback:Function;
      
      private var _cacheTicker:Shape;
      
      private var _waveData:ByteArray;
      
      private var _waveDataPos:uint;
      
      private var _waveDataLength:uint;
      
      private var _waveDataBytes:uint;
      
      private var _original:SfxrParams;
      
      private var _finished:Boolean;
      
      private var _masterVolume:Number;
      
      private var _waveType:uint;
      
      private var _envelopeVolume:Number;
      
      private var _envelopeStage:int;
      
      private var _envelopeTime:Number;
      
      private var _envelopeLength:Number;
      
      private var _envelopeLength0:Number;
      
      private var _envelopeLength1:Number;
      
      private var _envelopeLength2:Number;
      
      private var _envelopeOverLength0:Number;
      
      private var _envelopeOverLength1:Number;
      
      private var _envelopeOverLength2:Number;
      
      private var _envelopeFullLength:Number;
      
      private var _sustainPunch:Number;
      
      private var _phase:int;
      
      private var _pos:Number;
      
      private var _period:Number;
      
      private var _periodTemp:Number;
      
      private var _maxPeriod:Number;
      
      private var _slide:Number;
      
      private var _deltaSlide:Number;
      
      private var _minFreqency:Number;
      
      private var _vibratoPhase:Number;
      
      private var _vibratoSpeed:Number;
      
      private var _vibratoAmplitude:Number;
      
      private var _changeAmount:Number;
      
      private var _changeTime:int;
      
      private var _changeLimit:int;
      
      private var _squareDuty:Number;
      
      private var _dutySweep:Number;
      
      private var _repeatTime:int;
      
      private var _repeatLimit:int;
      
      private var _phaser:Boolean;
      
      private var _phaserOffset:Number;
      
      private var _phaserDeltaOffset:Number;
      
      private var _phaserInt:int;
      
      private var _phaserPos:int;
      
      private var _phaserBuffer:Vector.<Number>;
      
      private var _filters:Boolean;
      
      private var _lpFilterPos:Number;
      
      private var _lpFilterOldPos:Number;
      
      private var _lpFilterDeltaPos:Number;
      
      private var _lpFilterCutoff:Number;
      
      private var _lpFilterDeltaCutoff:Number;
      
      private var _lpFilterDamping:Number;
      
      private var _lpFilterOn:Boolean;
      
      private var _hpFilterPos:Number;
      
      private var _hpFilterCutoff:Number;
      
      private var _hpFilterDeltaCutoff:Number;
      
      private var _noiseBuffer:Vector.<Number>;
      
      private var _superSample:Number;
      
      private var _sample:Number;
      
      private var _sampleCount:uint;
      
      private var _bufferSample:Number;
      
      public function SfxrSynth()
      {
         this._params = new SfxrParams();
         super();
      }
      
      public function get params() : SfxrParams
      {
         return this._params;
      }
      
      public function set params(param1:SfxrParams) : void
      {
         this._params = param1;
         this._params.paramsDirty = true;
      }
      
      public function get channel() : SoundChannel
      {
         return this._channel;
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      public function play() : void
      {
         if(this._cachingAsync)
         {
            return;
         }
         this.stop();
         this._mutation = false;
         if(this._params.paramsDirty || this._cachingNormal || !this._cachedWave)
         {
            this._cachedWave = new ByteArray();
            this._cachingNormal = true;
            this._waveData = null;
            this.reset(true);
         }
         else
         {
            this._waveData = this._cachedWave;
            this._waveData.position = 0;
            this._waveDataLength = this._waveData.length;
            this._waveDataBytes = 24576;
            this._waveDataPos = 0;
         }
         if(!this._sound)
         {
            (this._sound = new Sound()).addEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
         }
         this._channel = this._sound.play();
      }
      
      public function playMutated(param1:Number = 0.05, param2:uint = 15) : void
      {
         this.stop();
         if(this._cachingAsync)
         {
            return;
         }
         this._mutation = true;
         this._cachedMutationsNum = param2;
         if(this._params.paramsDirty || !this._cachedMutations)
         {
            this._cachedMutations = new Vector.<ByteArray>();
            this._cachingMutation = 0;
         }
         if(this._cachingMutation != -1)
         {
            this._cachedMutation = new ByteArray();
            this._cachedMutations[this._cachingMutation] = this._cachedMutation;
            this._waveData = null;
            this._original = this._params.clone();
            this._params.mutate(param1);
            this.reset(true);
         }
         else
         {
            this._waveData = this._cachedMutations[uint(this._cachedMutations.length * Math.random())];
            this._waveData.position = 0;
            this._waveDataLength = this._waveData.length;
            this._waveDataBytes = 24576;
            this._waveDataPos = 0;
         }
         if(!this._sound)
         {
            (this._sound = new Sound()).addEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
         }
         this._channel = this._sound.play();
      }
      
      public function stop() : void
      {
         if(this._channel)
         {
            this._channel.stop();
            this._channel = null;
         }
         if(this._original)
         {
            this._params.copyFrom(this._original);
            this._original = null;
         }
      }
      
      private function onSampleData(param1:SampleDataEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(this._waveData)
         {
            if(this._waveDataPos + this._waveDataBytes > this._waveDataLength)
            {
               this._waveDataBytes = this._waveDataLength - this._waveDataPos;
            }
            if(this._waveDataBytes > 0)
            {
               param1.data.writeBytes(this._waveData,this._waveDataPos,this._waveDataBytes);
            }
            this._waveDataPos += this._waveDataBytes;
         }
         else if(this._mutation)
         {
            if(this._original)
            {
               this._waveDataPos = this._cachedMutation.position;
               if(this.synthWave(this._cachedMutation,3072,true))
               {
                  this._params.copyFrom(this._original);
                  this._original = null;
                  ++this._cachingMutation;
                  _loc2_ = this._cachedMutation.length;
                  if(_loc2_ < 24576)
                  {
                     this._cachedMutation.position = _loc2_;
                     _loc3_ = 0;
                     _loc4_ = uint(24576 - _loc2_);
                     while(_loc3_ < _loc4_)
                     {
                        this._cachedMutation.writeFloat(0);
                        _loc3_++;
                     }
                  }
                  if(this._cachingMutation >= this._cachedMutationsNum)
                  {
                     this._cachingMutation = -1;
                  }
               }
               this._waveDataBytes = this._cachedMutation.length - this._waveDataPos;
               param1.data.writeBytes(this._cachedMutation,this._waveDataPos,this._waveDataBytes);
            }
         }
         else if(this._cachingNormal)
         {
            this._waveDataPos = this._cachedWave.position;
            if(this.synthWave(this._cachedWave,3072,true))
            {
               _loc2_ = this._cachedWave.length;
               if(_loc2_ < 24576)
               {
                  this._cachedWave.position = _loc2_;
                  _loc3_ = 0;
                  _loc4_ = uint(24576 - _loc2_);
                  while(_loc3_ < _loc4_)
                  {
                     this._cachedWave.writeFloat(0);
                     _loc3_++;
                  }
               }
               this._cachingNormal = false;
            }
            this._waveDataBytes = this._cachedWave.length - this._waveDataPos;
            param1.data.writeBytes(this._cachedWave,this._waveDataPos,this._waveDataBytes);
         }
      }
      
      public function cacheSound(param1:Function = null, param2:uint = 5) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.stop();
         if(this._cachingAsync)
         {
            return;
         }
         this.reset(true);
         this._cachedWave = new ByteArray();
         if(Boolean(param1))
         {
            this._mutation = false;
            this._cachingNormal = true;
            this._cachingAsync = true;
            this._cacheTimePerFrame = param2;
            this._cachedCallback = param1;
            if(!this._cacheTicker)
            {
               this._cacheTicker = new Shape();
            }
            this._cacheTicker.addEventListener(Event.ENTER_FRAME,this.cacheSection);
         }
         else
         {
            this._cachingNormal = false;
            this._cachingAsync = false;
            this.synthWave(this._cachedWave,this._envelopeFullLength,true);
            _loc3_ = this._cachedWave.length;
            if(_loc3_ < 24576)
            {
               this._cachedWave.position = _loc3_;
               _loc4_ = 0;
               _loc5_ = uint(24576 - _loc3_);
               while(_loc4_ < _loc5_)
               {
                  this._cachedWave.writeFloat(0);
                  _loc4_++;
               }
            }
         }
      }
      
      public function cacheMutations(param1:uint, param2:Number = 0.05, param3:Function = null, param4:uint = 5) : void
      {
         var _loc5_:SfxrParams = null;
         var _loc6_:uint = 0;
         this.stop();
         if(this._cachingAsync)
         {
            return;
         }
         this._cachedMutationsNum = param1;
         this._cachedMutations = new Vector.<ByteArray>();
         if(Boolean(param3))
         {
            this._mutation = true;
            this._cachingMutation = 0;
            this._cachedMutation = new ByteArray();
            this._cachedMutations[0] = this._cachedMutation;
            this._cachedMutationAmount = param2;
            this._original = this._params.clone();
            this._params.mutate(param2);
            this.reset(true);
            this._cachingAsync = true;
            this._cacheTimePerFrame = param4;
            this._cachedCallback = param3;
            if(!this._cacheTicker)
            {
               this._cacheTicker = new Shape();
            }
            this._cacheTicker.addEventListener(Event.ENTER_FRAME,this.cacheSection);
         }
         else
         {
            _loc5_ = this._params.clone();
            _loc6_ = 0;
            while(_loc6_ < this._cachedMutationsNum)
            {
               this._params.mutate(param2);
               this.cacheSound();
               this._cachedMutations[_loc6_] = this._cachedWave;
               this._params.copyFrom(_loc5_);
               _loc6_++;
            }
            this._cachingMutation = -1;
         }
      }
      
      private function cacheSection(param1:Event) : void
      {
         var _loc2_:uint = uint(getTimer());
         while(getTimer() - _loc2_ < this._cacheTimePerFrame)
         {
            if(this._mutation)
            {
               this._waveDataPos = this._cachedMutation.position;
               if(this.synthWave(this._cachedMutation,500,true))
               {
                  this._params.copyFrom(this._original);
                  this._params.mutate(this._cachedMutationAmount);
                  this.reset(true);
                  ++this._cachingMutation;
                  this._cachedMutation = new ByteArray();
                  this._cachedMutations[this._cachingMutation] = this._cachedMutation;
                  if(this._cachingMutation >= this._cachedMutationsNum)
                  {
                     this._cachingMutation = -1;
                     this._cachingAsync = false;
                     this._params.paramsDirty = false;
                     this._cachedCallback();
                     this._cachedCallback = null;
                     this._cacheTicker.removeEventListener(Event.ENTER_FRAME,this.cacheSection);
                     return;
                  }
               }
            }
            else
            {
               this._waveDataPos = this._cachedWave.position;
               if(this.synthWave(this._cachedWave,500,true))
               {
                  this._cachingNormal = false;
                  this._cachingAsync = false;
                  this._ready = true;
                  this._cachedCallback();
                  this._cachedCallback = null;
                  this._cacheTicker.removeEventListener(Event.ENTER_FRAME,this.cacheSection);
                  return;
               }
            }
         }
      }
      
      private function reset(param1:Boolean) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc2_:SfxrParams = this._params;
         this._period = 100 / (_loc2_.startFrequency * _loc2_.startFrequency + 0.001);
         this._maxPeriod = 100 / (_loc2_.minFrequency * _loc2_.minFrequency + 0.001);
         this._slide = 1 - _loc2_.slide * _loc2_.slide * _loc2_.slide * 0.01;
         this._deltaSlide = -_loc2_.deltaSlide * _loc2_.deltaSlide * _loc2_.deltaSlide * 0.000001;
         if(_loc2_.waveType == 0)
         {
            this._squareDuty = 0.5 - _loc2_.squareDuty * 0.5;
            this._dutySweep = -_loc2_.dutySweep * 0.00005;
         }
         if(_loc2_.changeAmount > 0)
         {
            this._changeAmount = 1 - _loc2_.changeAmount * _loc2_.changeAmount * 0.9;
         }
         else
         {
            this._changeAmount = 1 + _loc2_.changeAmount * _loc2_.changeAmount * 10;
         }
         this._changeTime = 0;
         if(_loc2_.changeSpeed == 1)
         {
            this._changeLimit = 0;
         }
         else
         {
            this._changeLimit = (1 - _loc2_.changeSpeed) * (1 - _loc2_.changeSpeed) * 20000 + 32;
         }
         if(param1)
         {
            _loc2_.paramsDirty = false;
            this._masterVolume = _loc2_.masterVolume * _loc2_.masterVolume;
            this._waveType = _loc2_.waveType;
            if(_loc2_.sustainTime < 0.01)
            {
               _loc2_.sustainTime = 0.01;
            }
            _loc3_ = _loc2_.attackTime + _loc2_.sustainTime + _loc2_.decayTime;
            if(_loc3_ < 0.18)
            {
               _loc5_ = 0.18 / _loc3_;
               _loc2_.attackTime *= _loc5_;
               _loc2_.sustainTime *= _loc5_;
               _loc2_.decayTime *= _loc5_;
            }
            this._sustainPunch = _loc2_.sustainPunch;
            this._phase = 0;
            this._minFreqency = _loc2_.minFrequency;
            this._filters = _loc2_.lpFilterCutoff != 1 || _loc2_.hpFilterCutoff != 0;
            this._lpFilterPos = 0;
            this._lpFilterDeltaPos = 0;
            this._lpFilterCutoff = _loc2_.lpFilterCutoff * _loc2_.lpFilterCutoff * _loc2_.lpFilterCutoff * 0.1;
            this._lpFilterDeltaCutoff = 1 + _loc2_.lpFilterCutoffSweep * 0.0001;
            this._lpFilterDamping = 5 / (1 + _loc2_.lpFilterResonance * _loc2_.lpFilterResonance * 20) * (0.01 + this._lpFilterCutoff);
            if(this._lpFilterDamping > 0.8)
            {
               this._lpFilterDamping = 0.8;
            }
            this._lpFilterDamping = 1 - this._lpFilterDamping;
            this._lpFilterOn = _loc2_.lpFilterCutoff != 1;
            this._hpFilterPos = 0;
            this._hpFilterCutoff = _loc2_.hpFilterCutoff * _loc2_.hpFilterCutoff * 0.1;
            this._hpFilterDeltaCutoff = 1 + _loc2_.hpFilterCutoffSweep * 0.0003;
            this._vibratoPhase = 0;
            this._vibratoSpeed = _loc2_.vibratoSpeed * _loc2_.vibratoSpeed * 0.01;
            this._vibratoAmplitude = _loc2_.vibratoDepth * 0.5;
            this._envelopeVolume = 0;
            this._envelopeStage = 0;
            this._envelopeTime = 0;
            this._envelopeLength0 = _loc2_.attackTime * _loc2_.attackTime * 100000;
            this._envelopeLength1 = _loc2_.sustainTime * _loc2_.sustainTime * 100000;
            this._envelopeLength2 = _loc2_.decayTime * _loc2_.decayTime * 100000 + 10;
            this._envelopeLength = this._envelopeLength0;
            this._envelopeFullLength = this._envelopeLength0 + this._envelopeLength1 + this._envelopeLength2;
            this._envelopeOverLength0 = 1 / this._envelopeLength0;
            this._envelopeOverLength1 = 1 / this._envelopeLength1;
            this._envelopeOverLength2 = 1 / this._envelopeLength2;
            this._phaser = _loc2_.phaserOffset != 0 || _loc2_.phaserSweep != 0;
            this._phaserOffset = _loc2_.phaserOffset * _loc2_.phaserOffset * 1020;
            if(_loc2_.phaserOffset < 0)
            {
               this._phaserOffset = -this._phaserOffset;
            }
            this._phaserDeltaOffset = _loc2_.phaserSweep * _loc2_.phaserSweep * _loc2_.phaserSweep * 0.2;
            this._phaserPos = 0;
            if(!this._phaserBuffer)
            {
               this._phaserBuffer = new Vector.<Number>(1024,true);
            }
            if(!this._noiseBuffer)
            {
               this._noiseBuffer = new Vector.<Number>(32,true);
            }
            _loc4_ = 0;
            while(_loc4_ < 1024)
            {
               this._phaserBuffer[_loc4_] = 0;
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < 32)
            {
               this._noiseBuffer[_loc4_] = Math.random() * 2 - 1;
               _loc4_++;
            }
            this._repeatTime = 0;
            if(_loc2_.repeatSpeed == 0)
            {
               this._repeatLimit = 0;
            }
            else
            {
               this._repeatLimit = int((1 - _loc2_.repeatSpeed) * (1 - _loc2_.repeatSpeed) * 20000) + 32;
            }
         }
      }
      
      private function synthWave(param1:ByteArray, param2:uint, param3:Boolean = false, param4:uint = 44100, param5:uint = 16) : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         this._finished = false;
         this._sampleCount = 0;
         this._bufferSample = 0;
         var _loc6_:uint = 0;
         while(_loc6_ < param2)
         {
            if(this._finished)
            {
               return true;
            }
            if(this._repeatLimit != 0)
            {
               if(++this._repeatTime >= this._repeatLimit)
               {
                  this._repeatTime = 0;
                  this.reset(false);
               }
            }
            if(this._changeLimit != 0)
            {
               if(++this._changeTime >= this._changeLimit)
               {
                  this._changeLimit = 0;
                  this._period *= this._changeAmount;
               }
            }
            this._slide += this._deltaSlide;
            this._period *= this._slide;
            if(this._period > this._maxPeriod)
            {
               this._period = this._maxPeriod;
               if(this._minFreqency > 0)
               {
                  this._finished = true;
               }
            }
            this._periodTemp = this._period;
            if(this._vibratoAmplitude > 0)
            {
               this._vibratoPhase += this._vibratoSpeed;
               this._periodTemp = this._period * (1 + Math.sin(this._vibratoPhase) * this._vibratoAmplitude);
            }
            this._periodTemp = int(this._periodTemp);
            if(this._periodTemp < 8)
            {
               this._periodTemp = 8;
            }
            if(this._waveType == 0)
            {
               this._squareDuty += this._dutySweep;
               if(this._squareDuty < 0)
               {
                  this._squareDuty = 0;
               }
               else if(this._squareDuty > 0.5)
               {
                  this._squareDuty = 0.5;
               }
            }
            if(++this._envelopeTime > this._envelopeLength)
            {
               this._envelopeTime = 0;
               switch(++this._envelopeStage)
               {
                  case 1:
                     this._envelopeLength = this._envelopeLength1;
                     break;
                  case 2:
                     this._envelopeLength = this._envelopeLength2;
               }
            }
            switch(this._envelopeStage)
            {
               case 0:
                  this._envelopeVolume = this._envelopeTime * this._envelopeOverLength0;
                  break;
               case 1:
                  this._envelopeVolume = 1 + (1 - this._envelopeTime * this._envelopeOverLength1) * 2 * this._sustainPunch;
                  break;
               case 2:
                  this._envelopeVolume = 1 - this._envelopeTime * this._envelopeOverLength2;
                  break;
               case 3:
                  this._envelopeVolume = 0;
                  this._finished = true;
            }
            if(this._phaser)
            {
               this._phaserOffset += this._phaserDeltaOffset;
               this._phaserInt = int(this._phaserOffset);
               if(this._phaserInt < 0)
               {
                  this._phaserInt = -this._phaserInt;
               }
               else if(this._phaserInt > 1023)
               {
                  this._phaserInt = 1023;
               }
            }
            if(this._filters && this._hpFilterDeltaCutoff != 0)
            {
               this._hpFilterCutoff *= this._hpFilterDeltaCutoff;
               if(this._hpFilterCutoff < 0.00001)
               {
                  this._hpFilterCutoff = 0.00001;
               }
               else if(this._hpFilterCutoff > 0.1)
               {
                  this._hpFilterCutoff = 0.1;
               }
            }
            this._superSample = 0;
            _loc7_ = 0;
            while(_loc7_ < 8)
            {
               ++this._phase;
               if(this._phase >= this._periodTemp)
               {
                  this._phase -= this._periodTemp;
                  if(this._waveType == 3)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < 32)
                     {
                        this._noiseBuffer[_loc8_] = Math.random() * 2 - 1;
                        _loc8_++;
                     }
                  }
               }
               switch(this._waveType)
               {
                  case 0:
                     this._sample = this._phase / this._periodTemp < this._squareDuty ? 0.5 : -0.5;
                     break;
                  case 1:
                     this._sample = 1 - this._phase / this._periodTemp * 2;
                     break;
                  case 2:
                     this._pos = this._phase / this._periodTemp;
                     this._pos = this._pos > 0.5 ? (this._pos - 1) * 6.28318531 : this._pos * 6.28318531;
                     this._sample = this._pos < 0 ? 1.27323954 * this._pos + 0.405284735 * this._pos * this._pos : 1.27323954 * this._pos - 0.405284735 * this._pos * this._pos;
                     this._sample = this._sample < 0 ? 0.225 * (this._sample * -this._sample - this._sample) + this._sample : 0.225 * (this._sample * this._sample - this._sample) + this._sample;
                     break;
                  case 3:
                     this._sample = this._noiseBuffer[uint(this._phase * 32 / int(this._periodTemp))];
               }
               if(this._filters)
               {
                  this._lpFilterOldPos = this._lpFilterPos;
                  this._lpFilterCutoff *= this._lpFilterDeltaCutoff;
                  if(this._lpFilterCutoff < 0)
                  {
                     this._lpFilterCutoff = 0;
                  }
                  else if(this._lpFilterCutoff > 0.1)
                  {
                     this._lpFilterCutoff = 0.1;
                  }
                  if(this._lpFilterOn)
                  {
                     this._lpFilterDeltaPos += (this._sample - this._lpFilterPos) * this._lpFilterCutoff;
                     this._lpFilterDeltaPos *= this._lpFilterDamping;
                  }
                  else
                  {
                     this._lpFilterPos = this._sample;
                     this._lpFilterDeltaPos = 0;
                  }
                  this._lpFilterPos += this._lpFilterDeltaPos;
                  this._hpFilterPos += this._lpFilterPos - this._lpFilterOldPos;
                  this._hpFilterPos *= 1 - this._hpFilterCutoff;
                  this._sample = this._hpFilterPos;
               }
               if(this._phaser)
               {
                  this._phaserBuffer[this._phaserPos & 0x03FF] = this._sample;
                  this._sample += this._phaserBuffer[this._phaserPos - this._phaserInt + 1024 & 0x03FF];
                  this._phaserPos = this._phaserPos + 1 & 0x03FF;
               }
               this._superSample += this._sample;
               _loc7_++;
            }
            this._superSample = this._masterVolume * this._envelopeVolume * this._superSample * 0.125;
            if(this._superSample > 1)
            {
               this._superSample = 1;
            }
            else if(this._superSample < -1)
            {
               this._superSample = -1;
            }
            if(param3)
            {
               param1.writeFloat(this._superSample);
               param1.writeFloat(this._superSample);
            }
            else
            {
               this._bufferSample += this._superSample;
               ++this._sampleCount;
               if(param4 == 44100 || this._sampleCount == 2)
               {
                  this._bufferSample /= this._sampleCount;
                  this._sampleCount = 0;
                  if(param5 == 16)
                  {
                     param1.writeShort(int(32000 * this._bufferSample));
                  }
                  else
                  {
                     param1.writeByte(this._bufferSample * 127 + 128);
                  }
                  this._bufferSample = 0;
               }
            }
            _loc6_++;
         }
         return false;
      }
      
      public function getWavFile(param1:uint = 44100, param2:uint = 16) : ByteArray
      {
         this.stop();
         this.reset(true);
         if(param1 != 44100)
         {
            param1 = 22050;
         }
         if(param2 != 16)
         {
            param2 = 8;
         }
         var _loc3_:uint = this._envelopeFullLength;
         if(param2 == 16)
         {
            _loc3_ *= 2;
         }
         if(param1 == 22050)
         {
            _loc3_ /= 2;
         }
         var _loc4_:int = 36 + _loc3_;
         var _loc5_:int = param2 / 8;
         var _loc6_:int = param1 * _loc5_;
         var _loc7_:ByteArray;
         (_loc7_ = new ByteArray()).endian = Endian.BIG_ENDIAN;
         _loc7_.writeUnsignedInt(1380533830);
         _loc7_.endian = Endian.LITTLE_ENDIAN;
         _loc7_.writeUnsignedInt(_loc4_);
         _loc7_.endian = Endian.BIG_ENDIAN;
         _loc7_.writeUnsignedInt(1463899717);
         _loc7_.endian = Endian.BIG_ENDIAN;
         _loc7_.writeUnsignedInt(1718449184);
         _loc7_.endian = Endian.LITTLE_ENDIAN;
         _loc7_.writeUnsignedInt(16);
         _loc7_.writeShort(1);
         _loc7_.writeShort(1);
         _loc7_.writeUnsignedInt(param1);
         _loc7_.writeUnsignedInt(_loc6_);
         _loc7_.writeShort(_loc5_);
         _loc7_.writeShort(param2);
         _loc7_.endian = Endian.BIG_ENDIAN;
         _loc7_.writeUnsignedInt(1684108385);
         _loc7_.endian = Endian.LITTLE_ENDIAN;
         _loc7_.writeUnsignedInt(_loc3_);
         this.synthWave(_loc7_,this._envelopeFullLength,false,param1,param2);
         _loc7_.position = 0;
         return _loc7_;
      }
   }
}

