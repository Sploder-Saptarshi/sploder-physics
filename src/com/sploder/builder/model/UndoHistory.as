package com.sploder.builder.model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class UndoHistory extends EventDispatcher
   {
      protected var _model:Model;
      
      protected var _modelController:ModelController;
      
      protected var _history:Vector.<String>;
      
      protected var _marker:int = -1;
      
      public function UndoHistory(param1:Model, param2:ModelController)
      {
         super();
         this.init(param1,param2);
      }
      
      public function get length() : int
      {
         return this._history.length;
      }
      
      public function get hasRedo() : Boolean
      {
         return this._marker < this._history.length - 1;
      }
      
      public function get hasUndo() : Boolean
      {
         return this._history.length > 0 && this._marker > 0;
      }
      
      protected function init(param1:Model, param2:ModelController) : void
      {
         this._model = param1;
         this._modelController = param2;
         this.clear();
      }
      
      protected function setModel() : void
      {
         if(this._marker >= 0 && this._history.length > this._marker && this._history[this._marker] != null)
         {
            this._model.clear();
            this._model.fromString(this._history[this._marker]);
         }
      }
      
      public function record() : void
      {
         if(this._marker <= this._history.length - 1)
         {
            while(this._history.length - 1 > this._marker)
            {
               this._history.pop();
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
         var _loc1_:String = this._model.toString();
         if(_loc1_.length > 0 && (this._history.length == 0 || _loc1_ != this._history[this._history.length - 1]))
         {
            this._history.push(_loc1_);
            this._marker = this._history.length - 1;
            if(this._history.length > 25)
            {
               this._history.shift();
               --this._marker;
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function stepBack() : void
      {
         if(this._marker > 0 || this._marker == 0 && this._marker == this._history.length - 1)
         {
            this._modelController.selection.clear();
            if(this._marker == this._history.length - 1)
            {
               this.record();
            }
            --this._marker;
            this.setModel();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function stepForward() : void
      {
         if(this._marker < this._history.length - 1)
         {
            this._modelController.selection.clear();
            ++this._marker;
            this.setModel();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function clear() : void
      {
         this._history = new Vector.<String>();
         this._marker = -1;
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}

