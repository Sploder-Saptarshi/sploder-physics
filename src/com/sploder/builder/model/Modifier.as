package com.sploder.builder.model
{
   import com.sploder.builder.CreatorUIStates;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Modifier extends EventDispatcher
   {
      public static const STATE_IDLE:int = 1;
      
      public static const STATE_SELECTED:int = 2;
      
      protected var _props:ModifierProperties;
      
      protected var _deleted:Boolean = false;
      
      protected var _state:int = 1;
      
      public var container:ModifierContainer;
      
      protected var _clip:ModifierSprite;
      
      public function Modifier(param1:Modifier = null, param2:Boolean = true)
      {
         super();
         this.init(param1,param2);
      }
      
      public function get props() : ModifierProperties
      {
         return this._props;
      }
      
      public function get deleted() : Boolean
      {
         return this._deleted;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(param1:int) : void
      {
         this._state = param1;
         this.update();
      }
      
      public function get clip() : ModifierSprite
      {
         return this._clip;
      }
      
      protected function init(param1:Modifier = null, param2:Boolean = true) : void
      {
         if(param1)
         {
            this._props = param1.props.clone();
         }
         else
         {
            this._props = new ModifierProperties();
         }
         if(param2)
         {
            this._clip = new ModifierSprite(this);
         }
         this._props.addEventListener(Event.CHANGE,this.onChangeProps);
      }
      
      protected function update() : void
      {
         if(this._clip)
         {
            this._clip.draw();
         }
         if(this._props && (this._props.type == CreatorUIStates.MODIFIER_ADDER || this._props.type == CreatorUIStates.MODIFIER_SPAWNER) && this._props.parent && Boolean(this._props.parent.clip))
         {
            this._props.parent.clip.alpha = 0.75;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function onChangeProps(param1:Event) : void
      {
         if(this._deleted)
         {
            return;
         }
         if(this._props.type == CreatorUIStates.MODIFIER_FACTORY && this._props.parent && this._props.parent.group == null)
         {
            this.destroy();
            return;
         }
         if(this._props.parent)
         {
            if(this._props.parent.deleted)
            {
               this.destroy();
               return;
            }
            if(Boolean(this._props.child) && this._props.child.deleted)
            {
               this._props.child = null;
            }
            if(this._props.parent.state == STATE_SELECTED && this.container && this.container.focusObject == this)
            {
               this.container.focusObject = null;
            }
            switch(this._props.type)
            {
               case CreatorUIStates.MODIFIER_PUSHER:
               case CreatorUIStates.MODIFIER_LAUNCHER:
                  if(this._props.parent.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
                  {
                     this._props.parent.props.constraint = CreatorUIStates.MOVEMENT_FREE;
                  }
                  if(!this._props.parent.props.locked)
                  {
                     this._props.parent.props.locked = true;
                  }
                  break;
               case CreatorUIStates.MODIFIER_MOTOR:
                  if(this._props.parent.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
                  {
                     this._props.parent.props.constraint = CreatorUIStates.MOVEMENT_PIN;
                  }
            }
         }
         this.update();
      }
      
      override public function toString() : String
      {
         if(this._deleted)
         {
            return "";
         }
         return this._props.toString();
      }
      
      public function fromString(param1:String) : void
      {
         if(this._clip)
         {
            this._clip.suspend();
         }
         this._props.fromString(param1);
         if(this._clip)
         {
            this._clip.release();
         }
         this.update();
      }
      
      public function clone() : Modifier
      {
         return new Modifier(this);
      }
      
      public function destroy() : void
      {
         if(!this._deleted)
         {
            this._deleted = true;
            if(this._props)
            {
               if(Boolean(this._props.parent) && Boolean(this._props.parent.clip))
               {
                  this._props.parent.clip.alpha = 1;
               }
               this._props.parent = null;
               this._props.child = null;
               this._props = null;
            }
            if(Boolean(this._clip) && Boolean(this._clip.parent))
            {
               this._clip.parent.removeChild(this._clip);
            }
            this._clip = null;
            dispatchEvent(new Event(Event.CLEAR));
         }
      }
   }
}

