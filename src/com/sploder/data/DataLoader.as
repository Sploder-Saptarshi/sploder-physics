package com.sploder.data
{
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.*;
   import flash.utils.getTimer;
   import flash.xml.*;
   
   public class DataLoader extends EventDispatcher
   {
      public static const CACHE_OK:String = "cacheok";
      
      protected var _root:DisplayObject;
      
      protected var _baseURL:String = "";
      
      protected var _embedParameters:Object;
      
      protected var _metadataLoader:URLLoader;
      
      protected var _metadataRequest:URLRequest;
      
      protected var _metadataVars:URLVariables;
      
      protected var _dataXMLLoader:URLLoader;
      
      protected var _dataXMLRequest:URLRequest;
      
      protected var _src:String;
      
      protected var _xml:XML;
      
      public function DataLoader(param1:DisplayObject, param2:String = "")
      {
         super();
         this.init(param1,param2);
      }
      
      public function get loaderInfo() : LoaderInfo
      {
         return this._root.loaderInfo;
      }
      
      public function get baseURL() : String
      {
         return this._baseURL;
      }
      
      public function set baseURL(param1:String) : void
      {
         this._baseURL = param1;
         if(this._baseURL.charAt(this._baseURL.length - 1) == "/")
         {
            this._baseURL = this._baseURL.substr(0,this._baseURL.length - 1);
         }
      }
      
      public function get embedParameters() : Object
      {
         return this._embedParameters == null ? this.parseEmbedParameters() : this._embedParameters;
      }
      
      public function get metadata() : URLVariables
      {
         return this._metadataVars;
      }
      
      public function get dataXMLLoader() : URLLoader
      {
         return this._dataXMLLoader;
      }
      
      public function get src() : String
      {
         return this._src;
      }
      
      public function get xml() : XML
      {
         return this._xml;
      }
      
      public function init(param1:DisplayObject, param2:String = "") : void
      {
         this._root = param1;
         this._baseURL = param2;
         this._metadataVars = new URLVariables();
      }
      
      protected function parseEmbedParameters() : Object
      {
         if(this._root.loaderInfo != null && LoaderInfo(this._root.loaderInfo).parameters != null)
         {
            this._embedParameters = LoaderInfo(this._root.loaderInfo).parameters;
            return this._embedParameters;
         }
         return null;
      }
      
      public function loadMetadata(param1:String, param2:Boolean = true, param3:Function = null) : void
      {
         this._metadataLoader = new URLLoader();
         if(param3 != null)
         {
            this._metadataLoader.addEventListener(Event.COMPLETE,param3);
         }
         else
         {
            this._metadataLoader.addEventListener(Event.COMPLETE,this.onMetadataLoaded);
         }
         this._metadataRequest = new URLRequest((param2 ? this.baseURL : "") + param1);
         this._metadataLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onMetadataError);
         this._metadataLoader.load(this._metadataRequest);
      }
      
      public function send(param1:String, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:URLLoader = new URLLoader();
         _loc4_.load(new URLRequest(param1 + this.getCacheString(param2,param3 ? CACHE_OK : "")));
      }
      
      public function onMetadataLoaded(param1:Event) : void
      {
         var e:Event = param1;
         var loader:URLLoader = URLLoader(e.target);
         var urlVars:String = loader.data;
         if(urlVars.charAt(0) == "&")
         {
            urlVars = urlVars.replace("&","");
         }
         this._metadataVars = new URLVariables();
         try
         {
            this._metadataVars.decode(urlVars);
         }
         catch(e:Error)
         {
         }
         dispatchEvent(new DataLoaderEvent(DataLoaderEvent.METADATA_LOADED,false,false,this._metadataVars));
      }
      
      public function onMetadataError(param1:IOErrorEvent) : void
      {
         dispatchEvent(new DataLoaderEvent(DataLoaderEvent.METADATA_ERROR,false,false));
      }
      
      public function loadXMLData(param1:String, param2:Boolean = true, param3:Function = null, param4:Function = null) : void
      {
         this._dataXMLRequest = new URLRequest((param2 ? this.baseURL : "") + param1);
         this._dataXMLLoader = new URLLoader(this._dataXMLRequest);
         if(param3 != null)
         {
            this._dataXMLLoader.addEventListener(Event.COMPLETE,param3);
         }
         else
         {
            this._dataXMLLoader.addEventListener(Event.COMPLETE,this.onXMLDataLoaded);
         }
         if(param4 != null)
         {
            this._dataXMLLoader.addEventListener(IOErrorEvent.IO_ERROR,param4);
         }
         else
         {
            this._dataXMLLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onXMLDataError);
         }
         this._dataXMLLoader.load(this._dataXMLRequest);
      }
      
      public function onXMLDataLoaded(param1:Event) : void
      {
         this._src = param1.target.data;
         this._xml = new XML(this._src);
         dispatchEvent(new DataLoaderEvent(DataLoaderEvent.DATA_LOADED,false,false,this._src));
      }
      
      public function onXMLDataError(param1:Event) : void
      {
         dispatchEvent(new DataLoaderEvent(DataLoaderEvent.DATA_ERROR,false,false));
      }
      
      public function getCacheString(param1:String = "", param2:String = "") : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param2 != "cacheok")
         {
            _loc3_ = "&nocache=" + getTimer();
         }
         else
         {
            _loc3_ = "";
         }
         if(this.embedParameters.PHPSESSID != null && this.embedParameters.PHPSESSID.length > 1)
         {
            _loc4_ = "?PHPSESSID=" + this.embedParameters.PHPSESSID;
         }
         else
         {
            _loc4_ = "?nosession=1";
         }
         if(param1.length > 0)
         {
            return _loc4_ + "&" + param1 + _loc3_;
         }
         return _loc4_ + _loc3_;
      }
   }
}

