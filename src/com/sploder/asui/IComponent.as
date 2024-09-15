package com.sploder.asui
{
   import flash.events.Event;
   
   public interface IComponent
   {
      function create() : void;
      
      function enable(param1:Event = null) : void;
      
      function disable(param1:Event = null) : void;
      
      function show(param1:Event = null) : void;
      
      function hide(param1:Event = null) : void;
      
      function destroy() : Boolean;
   }
}

