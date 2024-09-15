package com.sploder.builder.ui
{
   import com.sploder.asui.Cell;
   import com.sploder.asui.Component;
   import com.sploder.asui.FormField;
   import com.sploder.asui.HTMLField;
   import com.sploder.asui.Position;
   import com.sploder.asui.Style;
   import com.sploder.builder.Creator;
   import com.sploder.builder.Styles;
   import com.sploder.util.Cleanser;
   import flash.events.Event;
   
   public class DialogueGoals extends Dialogue
   {
      protected var _instructionsField:FormField;
      
      protected var _totalLives:FormField;
      
      protected var _totalPenalties:FormField;
      
      protected var _totalScore:FormField;
      
      protected var _totalTime:FormField;
      
      public function DialogueGoals(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["Cancel","Reset","Guess How to Play","Apply"];
         super.create();
         dbox.contentPadding = 40;
         _creator.ui.uiContainer.addChild(dbox);
         dbox.addButtonListener(Component.EVENT_CLICK,this.onClick);
         hide();
      }
      
      public function createContent() : void
      {
         var _loc6_:HTMLField = null;
         var _loc9_:FormField = null;
         if(_contentCreated)
         {
            return;
         }
         var _loc1_:HTMLField = new HTMLField(null,"How to Play  <a class=\"litelink\" href=\"event:showtag\">(?)</a>:",NaN,false,null,Styles.dialogueStyle);
         _loc1_.alt = "It\'s a good idea to type some instructions so players know to complete your game level!";
         dbox.contentCell.addChild(_loc1_);
         var _loc2_:Style = Styles.dialogueStyle.clone();
         _loc2_.font = "_sans";
         _loc2_.fontSize = 11;
         _loc2_.textColor = 65535;
         _loc2_.embedFonts = false;
         this._instructionsField = new FormField(null,"",420,100,true,null,_loc2_);
         this._instructionsField.selectable = this._instructionsField.editable = true;
         dbox.contentCell.addChild(this._instructionsField);
         this._instructionsField.restrict = "A-Za-z0-9 .,!()";
         this._instructionsField.maxChars = 200;
         var _loc3_:Style = Styles.dialogueStyle.clone();
         _loc3_.fontSize = 13;
         _loc3_.textColor = 13421772;
         var _loc4_:Style;
         (_loc4_ = _loc3_.clone()).embedFonts = false;
         _loc4_.font = "_sans";
         var _loc5_:Position = Styles.floatPosition.clone({"margins":"-4 10 5 10"});
         var _loc7_:String = "";
         var _loc8_:String = "";
         dbox.contentCell.addChild(new Cell(null,NaN,20));
         _loc7_ = "<p align=\"right\">Number of lives at start of level <a class=\"litelink\" href=\"event:showtag\">(?)</a></p>";
         _loc8_ = "This is the starting count for \'Lose Life\' and \'Add Life\' actions. Once you reach 0 lives in the game, you will lose the game.";
         (_loc6_ = new HTMLField(null,_loc7_,120,true,_loc5_,_loc3_)).alt = _loc8_;
         dbox.contentCell.addChild(_loc6_);
         _loc9_ = new FormField(null,"000",60,30,true,Styles.floatPosition,_loc4_);
         dbox.contentCell.addChild(_loc9_);
         _loc9_.restrict = "0123456789";
         this._totalLives = _loc9_;
         _loc7_ = "<p align=\"right\">Number of penalties to allow <a class=\"litelink\" href=\"event:showtag\">(?)</a></p>";
         _loc8_ = "A life is lost when the number of penalties are reached. Leave at 0 for no penalty counting.";
         (_loc6_ = new HTMLField(null,_loc7_,120,true,_loc5_,_loc3_)).alt = _loc8_;
         dbox.contentCell.addChild(_loc6_);
         _loc9_ = new FormField(null,"000",60,30,true,Styles.floatPosition,_loc4_);
         dbox.contentCell.addChild(_loc9_);
         _loc9_.restrict = "0123456789";
         this._totalPenalties = _loc9_;
         dbox.contentCell.addChild(new Cell(null,NaN,10));
         _loc7_ = "<p align=\"right\">Top score to win level <a class=\"litelink\" href=\"event:showtag\">(?)</a></p>";
         _loc8_ = "The level completes if you reach this score. Leave at 0 for no score counting.";
         (_loc6_ = new HTMLField(null,_loc7_,120,true,_loc5_,_loc3_)).alt = _loc8_;
         dbox.contentCell.addChild(_loc6_);
         _loc9_ = new FormField(null,"000",60,30,true,Styles.floatPosition,_loc4_);
         dbox.contentCell.addChild(_loc9_);
         _loc9_.restrict = "0123456789";
         this._totalScore = _loc9_;
         _loc7_ = "<p align=\"right\">Time limit for level in secs <a class=\"litelink\" href=\"event:showtag\">(?)</a></p>";
         _loc8_ = "The game ends if the timer reaches the time limit (in seconds) before the other goals are reached. Leave at 0 for no time limit.";
         (_loc6_ = new HTMLField(null,_loc7_,120,true,_loc5_,_loc3_)).alt = _loc8_;
         dbox.contentCell.addChild(_loc6_);
         _loc9_ = new FormField(null,"000",60,30,true,Styles.floatPosition,_loc4_);
         dbox.contentCell.addChild(_loc9_);
         _loc9_.restrict = "0123456789";
         this._totalTime = _loc9_;
         _contentCreated = true;
      }
      
      override protected function onClick(param1:Event) : void
      {
         var _loc2_:String = null;
         super.onClick(param1);
         switch(param1.target)
         {
            case dbox.buttons[0]:
               hide();
               break;
            case dbox.buttons[1]:
               this.getSettings();
               break;
            case dbox.buttons[2]:
               _loc2_ = this._instructionsField.value;
               this._instructionsField.value = _loc2_ + " " + _creator.model.modifiers.guessInstructions();
               this._instructionsField.focus();
               break;
            case dbox.buttons[3]:
               this.applyChanges();
               hide();
         }
      }
      
      override protected function getSettings() : void
      {
         this._totalLives.value = _creator.environment.total_lives.toString();
         this._totalPenalties.value = _creator.environment.total_penalties.toString();
         this._totalScore.value = _creator.environment.total_score.toString();
         this._totalTime.value = _creator.environment.total_time.toString();
         this._instructionsField.value = _creator.environment.vInstructions;
      }
      
      override protected function applyChanges() : void
      {
         if(!isNaN(parseInt(this._totalLives.value)))
         {
            _creator.environment.total_lives = parseInt(this._totalLives.value);
         }
         if(!isNaN(parseInt(this._totalPenalties.value)))
         {
            _creator.environment.total_penalties = parseInt(this._totalPenalties.value);
         }
         if(!isNaN(parseInt(this._totalScore.value)))
         {
            _creator.environment.total_score = parseInt(this._totalScore.value);
         }
         if(!isNaN(parseInt(this._totalTime.value)))
         {
            _creator.environment.total_time = parseInt(this._totalTime.value);
         }
         _creator.environment.vInstructions = Cleanser.cleanse(this._instructionsField.value.substring(0,200));
      }
      
      override public function show() : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         this._instructionsField.focus();
         super.show();
      }
   }
}

