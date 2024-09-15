package com.sploder.builder.ui
{
   import com.sploder.asui.Component;
   import com.sploder.builder.Creator;
   import com.sploder.builder.model.ModelObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class DialogueTextureGen extends Dialogue
   {
      public var TextureGenSWF:Class;
      
      protected var _loaded:Boolean = false;
      
      protected var _loader:Loader;
      
      public var textureData:String;
      
      public function DialogueTextureGen(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         this.TextureGenSWF = DialogueTextureGen_TextureGenSWF;
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         super.create();
         dbox.contentPadding = 18;
         dbox.contentBottomMargin = 115;
         dbox.contentHasBackground = false;
         _creator.ui.uiContainer.addChild(dbox);
         dbox.addButtonListener(Component.EVENT_CLICK,onClick);
         this.textureData = "";
         this.createContent();
         this.hide();
      }
      
      public function createContent() : void
      {
         var _loc1_:LoaderContext = null;
         if(_contentCreated)
         {
            return;
         }
         if(this._loader == null)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            _loc1_ = new LoaderContext();
            _loc1_.allowCodeImport = true;
            _loc1_.applicationDomain = new ApplicationDomain();
            _loc1_.parameters = {"textureData":this.textureData};
            this._loader.loadBytes(new this.TextureGenSWF(),_loc1_);
         }
         _contentCreated = true;
      }
      
      private function completeHandler(param1:Event) : void
      {
         this._loaded = true;
         if(_creator != null && _creator.stage != null)
         {
            _creator.stage.addEventListener(Event.ENTER_FRAME,this.onLoadWait);
         }
      }
      
      private function onLoadWait(param1:Event) : void
      {
         if(_creator != null && _creator.stage != null)
         {
            _creator.stage.removeEventListener(Event.ENTER_FRAME,this.onLoadWait);
         }
         this._loader.x = 0;
         this._loader.y = 40;
         dbox.mc.addChild(this._loader);
         this._loader.addEventListener(Event.CANCEL,this.onCancel);
         this._loader.addEventListener(Event.COMPLETE,this.onComplete);
      }
      
      private function ioErrorHandler(param1:Event) : void
      {
         this._loaded = false;
         this._loader = null;
      }
      
      private function securityErrorHandler(param1:Event) : void
      {
         this._loaded = false;
         this._loader = null;
      }
      
      private function onCancel(param1:Event) : void
      {
         this.hide();
      }
      
      private function onComplete(param1:*) : void
      {
         this.textureData = param1.relatedObject + "";
         this.applyChanges();
         this.hide();
      }
      
      override protected function getSettings() : void
      {
         var i:int = 0;
         var obj:ModelObject = null;
         var objEventClass:Class = null;
         if(_creator.modelController.selection.length > 0)
         {
            i = 0;
            while(i < _creator.modelController.selection.length)
            {
               obj = _creator.modelController.selection.objects[i];
               if(obj != null && obj.props != null && obj.props.custom_texture != null && obj.props.custom_texture.length > 0)
               {
                  this.textureData = obj.props.custom_texture;
                  break;
               }
               i++;
            }
            if(this.textureData.length > 0)
            {
               try
               {
                  objEventClass = this._loader.contentLoaderInfo.applicationDomain.getDefinition("com.sploder.util.ObjectEvent") as Class;
                  if(objEventClass != null)
                  {
                     this._loader.content.dispatchEvent(new objEventClass("texture_change",false,false,this.textureData));
                  }
               }
               catch(e:Error)
               {
               }
            }
         }
      }
      
      override protected function applyChanges() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ModelObject = null;
         if(_creator.modelController.selection.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < _creator.modelController.selection.length)
            {
               _loc2_ = _creator.modelController.selection.objects[_loc1_];
               if(_loc2_ != null && _loc2_.props != null)
               {
                  _loc2_.props.custom_texture = this.textureData;
               }
               _loc1_++;
            }
         }
      }
      
      override public function show() : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         else
         {
            this.getSettings();
         }
         super.show();
      }
      
      override public function hide() : void
      {
         super.hide();
         if(_creator.ui.advancedTextureToggle.toggled)
         {
            _creator.ui.advancedTextureToggle.toggle();
         }
      }
   }
}

