package com.sploder.game
{
   public class States
   {
      public static const ACTION_SCORE:String = "action_score";
      
      public static const ACTION_PENALTY:String = "action_penalty";
      
      public static const ACTION_LOSELIFE:String = "action_lose_life";
      
      public static const ACTION_ADDLIFE:String = "action_add_life";
      
      public static const ACTION_UNLOCK:String = "action_unlock";
      
      public static const ACTION_REMOVE:String = "action_remove";
      
      public static const ACTION_EXPLODE:String = "action_explode";
      
      public static const ACTION_ENDGAME:String = "action_end_game";
      
      public static const ACTIONS:Array = [ACTION_SCORE,ACTION_PENALTY,ACTION_LOSELIFE,ACTION_ADDLIFE,ACTION_UNLOCK,ACTION_REMOVE,ACTION_EXPLODE,ACTION_ENDGAME];
      
      public static const EVENT_SENSOR:String = "ingame_event_sensor";
      
      public static const EVENT_CRUSH:String = "ingame_event_crush";
      
      public static const EVENT_EMPTY:String = "ingame_event_empty";
      
      public static const EVENT_BOUNDS:String = "ingame_event_out_of_bounds";
      
      public static const EVENT_AMMOLOW:String = "ingame_event_ammolow";
      
      public static const EVENTS:Array = [EVENT_SENSOR,EVENT_CRUSH,EVENT_EMPTY,EVENT_BOUNDS];
      
      public static const CONTROLS_MOUSE:String = "mouse";
      
      public static const CONTROLS_SPACEBAR:String = "spacebar";
      
      public static const CONTROLS_UPDOWN:String = "updown";
      
      public static const CONTROLS_LEFTRIGHT:String = "leftright";
      
      public function States()
      {
         super();
      }
   }
}

