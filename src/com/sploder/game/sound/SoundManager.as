package com.sploder.game.sound
{
   import com.sploder.game.Simulation;
   import com.sploder.util.Geom2d;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import nape.phys.PhysObj;
   import neoart.flod.ModProcessor;
   
   public class SoundManager
   {
      public static var mainInstance:SoundManager;
      
      protected static var _synths:Dictionary;
      
      public static var baseURL:String = "http://sploder.s3.amazonaws.com/";
      
      private static var _hasSound:Boolean = true;
      
      protected static var _soundIDs:Array = [Sounds.FRICTION,Sounds.TOUCH,Sounds.BUMP,Sounds.BUMP_BIG,Sounds.SELF_BUMP,Sounds.SPAWN,Sounds.JUMP,Sounds.CLANG,Sounds.TINK,Sounds.TINK_BIG,Sounds.CRASH,Sounds.EXPLODE,Sounds.SCORE,Sounds.PENALTY,Sounds.UNLOCK,Sounds.SENSOR,Sounds.LOSELIFE,Sounds.ADDLIFE,Sounds.RESONATE,Sounds.RESONATE_LONG,Sounds.EXPLODE_HUGE,Sounds.TICK,Sounds.SWOOSH,Sounds.LEVEL_COMPLETE,Sounds.EMPTY,Sounds.WINLEVEL,Sounds.LOSEGAME];
      
      protected static var _soundsGenerated:Boolean = false;
      
      protected static var _soundGenerationPercent:Number = 0;
      
      protected static var _soundToGenerate:int = 0;
      
      protected static var _genStarted:Boolean = false;
      
      protected var _simulation:Simulation;
      
      protected var _initialized:Boolean = false;
      
      protected var _ptA:Point;
      
      protected var _ptB:Point;
      
      protected var _noiseChannel:SoundChannel;
      
      protected var _noisePlaying:Boolean = false;
      
      protected var _noiseVolume:Number = 0;
      
      private var music:Sound;
      
      private var stream:ByteArray;
      
      private var processor:ModProcessor;
      
      private var songLoader:URLLoader;
      
      public function SoundManager()
      {
         var _loc1_:SfxrSynth = null;
         super();
         mainInstance = this;
         this._ptA = new Point();
         this._ptB = new Point();
         if(!soundsGenerated && !_genStarted)
         {
            generateSounds();
         }
      }
      
      public static function get hasSound() : Boolean
      {
         return _hasSound;
      }
      
      public static function set hasSound(param1:Boolean) : void
      {
         _hasSound = param1;
         if(!_hasSound)
         {
            stopAll();
         }
      }
      
      public static function get soundsGenerated() : Boolean
      {
         return _soundsGenerated;
      }
      
      public static function get soundGenerationPercent() : Number
      {
         return _soundGenerationPercent;
      }
      
      public static function generateSounds() : void
      {
         if(_genStarted)
         {
            return;
         }
         _genStarted = true;
         _synths = new Dictionary();
         generateNextSound();
      }
      
      protected static function generateNextSound() : void
      {
         var _loc1_:SfxrSynth = null;
         if(_soundToGenerate < _soundIDs.length)
         {
            if(_soundIDs[_soundToGenerate])
            {
               _loc1_ = _synths[_soundIDs[_soundToGenerate]] = new SfxrSynth();
               _loc1_.params.setSettingsString(_soundIDs[_soundToGenerate]);
               _loc1_.cacheSound(generateNextSound,10);
            }
            ++_soundToGenerate;
            _soundGenerationPercent = _soundToGenerate / _soundIDs.length;
            if(_soundGenerationPercent >= 1)
            {
               _soundsGenerated = true;
            }
         }
      }
      
      public static function stopAll() : void
      {
         if(mainInstance)
         {
            mainInstance.noisePlaying = false;
         }
         SoundMixer.stopAll();
      }
      
      public function initialize(param1:Stage) : void
      {
         if(param1)
         {
            param1.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            param1.addEventListener(Event.ENTER_FRAME,this.onEnterFrame,false,0,true);
         }
      }
      
      public function unregisterStage(param1:Stage) : void
      {
         if(param1)
         {
            param1.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      public function get noiseVolume() : Number
      {
         return this._noiseVolume;
      }
      
      public function set noiseVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         if(!_hasSound)
         {
            param1 = 0;
         }
         this._noiseVolume = param1;
         if(this._noiseChannel)
         {
            _loc2_ = this._noiseChannel.soundTransform;
            _loc2_.volume = this._noiseVolume;
            this._noiseChannel.soundTransform = _loc2_;
         }
      }
      
      public function get noisePlaying() : Boolean
      {
         return this._noisePlaying;
      }
      
      public function set noisePlaying(param1:Boolean) : void
      {
         this._noisePlaying = param1;
         if(!this._noisePlaying && Boolean(this._noiseChannel))
         {
            this._noiseChannel.stop();
         }
      }
      
      public function get simulation() : Simulation
      {
         return this._simulation;
      }
      
      public function set simulation(param1:Simulation) : void
      {
         this._simulation = param1;
      }
      
      public function addSound(param1:PhysObj = null, param2:String = null, param3:Boolean = true, param4:Number = 1) : void
      {
         var _loc7_:SoundTransform = null;
         if(this._initialized)
         {
            return;
         }
         if(!_hasSound)
         {
            return;
         }
         if(param2 == Sounds.FRICTION && this._noisePlaying)
         {
            this.noiseVolume = param4;
            return;
         }
         if(param4 == 0)
         {
            return;
         }
         var _loc5_:Number = 100;
         var _loc6_:SfxrSynth = _synths[param2];
         if(_loc6_ == null || _loc6_.busy || !_loc6_.ready)
         {
            return;
         }
         if(param3 && (this._simulation.view == null || this._simulation.view.camera == null))
         {
            return;
         }
         if(param3 && param1 != null && this._simulation.view.camera.watchObject && param1 != this._simulation.view.camera.watchObject)
         {
            this._ptA.x = param1.px;
            this._ptA.y = param1.py;
            this._ptB.x = this._simulation.view.camera.watchObject.px;
            this._ptB.y = this._simulation.view.camera.watchObject.py;
            _loc5_ = Math.floor(Math.min(100,5000 / Math.max(1,Geom2d.distanceBetween(this._ptA,this._ptB) - 20)));
         }
         _loc6_.play();
         _loc6_.busy = true;
         if(_loc6_.channel)
         {
            (_loc7_ = _loc6_.channel.soundTransform).volume = _loc5_ / 100 * Math.max(0,Math.min(1,param4));
            _loc6_.channel.soundTransform = _loc7_;
         }
         if(param2 == Sounds.FRICTION)
         {
            this._noiseChannel = _loc6_.channel;
            if(this._noiseChannel)
            {
               this._noiseVolume = param4;
               this._noiseChannel.addEventListener(Event.SOUND_COMPLETE,this.onNoiseComplete,false,0,true);
               this._noisePlaying = true;
            }
         }
      }
      
      public function onNoiseComplete(param1:Event) : void
      {
         this._noiseChannel.removeEventListener(Event.SOUND_COMPLETE,this.onNoiseComplete);
         this._noisePlaying = false;
         this.addSound(this._simulation.focusBody,Sounds.FRICTION,false,this._noiseVolume);
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in _synths)
         {
            SfxrSynth(_loc2_).busy = false;
         }
      }
      
      public function loadSong(param1:String) : void
      {
         this.unloadSong();
         this.songLoader = new URLLoader();
         this.songLoader.addEventListener(Event.COMPLETE,this.onSongLoaded,false,0,true);
         this.songLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onSongError,false,0,true);
         this.songLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSongError,false,0,true);
         this.songLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.songLoader.load(new URLRequest(baseURL + "music/modules/" + param1));
      }
      
      public function pauseSong() : void
      {
         if(Boolean(this.processor) && this.processor.isPlaying)
         {
            this.processor.pause();
         }
      }
      
      public function resumeSong() : void
      {
         var _loc1_:SoundTransform = null;
         if(Boolean(this.processor) && !this.processor.isPlaying)
         {
            this.processor.play(this.music);
            _loc1_ = this.processor.soundChannel.soundTransform;
            _loc1_.volume = 0.5;
            this.processor.soundChannel.soundTransform = _loc1_;
         }
      }
      
      public function unloadSong() : void
      {
         if(this.songLoader)
         {
            try
            {
               this.songLoader.close();
            }
            catch(e:Error)
            {
            }
            this.songLoader = null;
         }
         if(this.processor)
         {
            this.processor.stop();
            this.processor = null;
         }
         if(this.music)
         {
            this.music = null;
         }
      }
      
      protected function onSongLoaded(param1:Event) : void
      {
         var _loc2_:SoundTransform = null;
         this.songLoader.removeEventListener(Event.COMPLETE,this.onSongLoaded);
         this.songLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onSongError);
         this.songLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSongError);
         if(this.processor)
         {
            this.processor.stop();
         }
         this.processor = new ModProcessor();
         if(this.songLoader.data)
         {
            this.processor.load(this.songLoader.data);
            this.processor.loopSong = true;
            this.processor.stereo = 0.2;
            this.music = new Sound();
            this.processor.play(this.music);
            _loc2_ = this.processor.soundChannel.soundTransform;
            _loc2_.volume = 0.5;
            this.processor.soundChannel.soundTransform = _loc2_;
         }
      }
      
      protected function onSongError(param1:Event) : void
      {
      }
   }
}

