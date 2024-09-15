package com.sploder.builder.ui
{
   import com.sploder.asui.Cell;
   import com.sploder.asui.CheckBox;
   import com.sploder.asui.Component;
   import com.sploder.asui.HTMLField;
   import com.sploder.asui.Position;
   import com.sploder.asui.Style;
   import com.sploder.builder.Creator;
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.builder.Styles;
   import com.sploder.builder.model.Environment;
   import com.sploder.game.States;
   import flash.events.Event;
   
   public class DialogueActionMatrix extends Dialogue
   {
      protected var _checkboxes:Object;
      
      protected var _actionTitles:Object;
      
      protected var _eventTitles:Object;
      
      public function DialogueActionMatrix(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["Cancel","Clear All","Reset","Apply"];
         super.create();
         dbox.contentPadding = 20;
         _creator.ui.uiContainer.addChild(dbox);
         dbox.addButtonListener(Component.EVENT_CLICK,this.onClick);
         hide();
      }
      
      public function createContent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:* = null;
         var _loc5_:CheckBox = null;
         var _loc8_:HTMLField = null;
         if(_contentCreated)
         {
            return;
         }
         this._checkboxes = {};
         this._actionTitles = {};
         this._eventTitles = {};
         var _loc6_:Position = Styles.floatPosition.clone({"margins":5});
         var _loc7_:Cell = new Cell(null,540,200);
         var _loc9_:Position = Styles.floatPosition.clone({"margin_right":10});
         var _loc10_:Style;
         (_loc10_ = Styles.dialogueStyle.clone()).fontSize = 12;
         _loc10_.textColor = 16777215;
         _loc10_.font = "Myriad Web Bold";
         dbox.contentCell.addChild(new Cell(null,NaN,20));
         dbox.contentCell.addChild(_loc7_);
         var _loc11_:Array = ["Score","Penalty","Lose Life","Add Life","Unlock","Remove","Explode","End Game"];
         var _loc12_:Array = ["Add a point to the score","Add a penalty to the penalty score","Lose a life in the game","Add a life to the game","Unlock this object","Quietly remove this object from the game","Make this object explode and push surrounding objects","End the game with a losing result"];
         _loc8_ = new HTMLField(null," ",116,true,_loc9_,_loc10_);
         _loc7_.addChild(_loc8_);
         _loc1_ = 0;
         while(_loc1_ < _loc11_.length)
         {
            (_loc8_ = new HTMLField(null,"<p align=\"left\"><a class=\"litelink\" href=\"event:showtag\">(?)</a> " + _loc11_[_loc1_] + "</p>",160,true,_loc9_,_loc10_)).alt = _loc12_[_loc1_];
            _loc7_.addChild(_loc8_);
            _loc8_.boundsWidth = 40;
            _loc8_.boundsHeight = 20;
            _loc8_.rotation = -45;
            _loc8_.innerY = 35;
            _loc8_.mc.alpha = 0.5;
            this._actionTitles[_loc1_] = _loc8_;
            _loc1_++;
         }
         var _loc13_:Array = ["On Sensor","On Crush","On Adder, Factory, Spawner Empty","On Out of<br>Bounds"];
         var _loc14_:Array = ["When this object (or parent sensor link) touches an object on the same sensor layer","When this object is crushed by crushing collision forces","When this object (or parent sensor link) finishes spawning and the last object expires","When this object falls out of the game bounds"];
         _loc2_ = 0;
         while(_loc2_ < States.EVENTS.length)
         {
            (_loc8_ = new HTMLField(null,"<p align=\"right\">" + _loc13_[_loc2_] + " <a class=\"litelink\" href=\"event:showtag\">(?)</a></p>",110,true,_loc9_,_loc10_)).alt = _loc14_[_loc2_];
            _loc7_.addChild(_loc8_);
            _loc8_.outerHeight = 50;
            _loc8_.mc.alpha = 0.5;
            this._eventTitles[_loc2_] = _loc8_;
            _loc1_ = 0;
            while(_loc1_ < States.ACTIONS.length)
            {
               _loc3_ = _loc2_ + "_" + _loc1_;
               _loc4_ = _loc14_[_loc2_] + ", " + _loc12_[_loc1_].toLowerCase() + ".";
               _loc5_ = new CheckBox(null,"",_loc3_,false,40,40,_loc4_,_loc6_,Styles.dialogueStyle);
               _loc7_.addChild(_loc5_);
               _loc5_.name = _loc3_;
               _loc5_.mc.scaleX = _loc5_.mc.scaleY = 2;
               this._checkboxes[_loc3_] = _loc5_;
               _loc5_.addEventListener(Component.EVENT_HOVER_START,this.onHover);
               _loc5_.addEventListener(Component.EVENT_HOVER_END,this.onHoverEnd);
               _loc1_++;
            }
            _loc2_++;
         }
         var _loc15_:Style = _loc10_.clone({"textColor":10066329});
         dbox.contentCell.addChild(new Cell(null,NaN,60));
         var _loc16_:String = "To create game behaviors, match the actions in each column to the event you wish to link. Keep in mind that sensor events between two of the same objects only occur once in the game.";
         _loc8_ = new HTMLField(null,"<p>" + _loc16_ + "</p>",NaN,true,new Position({
            "margin_right":20,
            "margin_left":120
         }),_loc15_);
         dbox.contentCell.addChild(_loc8_);
         _contentCreated = true;
      }
      
      protected function onHover(param1:Event) : void
      {
         var _loc2_:Array = String(param1.target.name).split("_");
         this._actionTitles[_loc2_[1]].mc.alpha = 1;
         this._eventTitles[_loc2_[0]].mc.alpha = 1;
      }
      
      protected function onHoverEnd(param1:Event) : void
      {
         var _loc2_:Array = String(param1.target.name).split("_");
         this._actionTitles[_loc2_[1]].mc.alpha = 0.5;
         this._eventTitles[_loc2_[0]].mc.alpha = 0.5;
      }
      
      override protected function onClick(param1:Event) : void
      {
         super.onClick(param1);
         switch(param1.target)
         {
            case dbox.buttons[0]:
               this.getSettings();
               hide();
               break;
            case dbox.buttons[1]:
               this.clear();
               break;
            case dbox.buttons[2]:
               this.getSettings();
               break;
            case dbox.buttons[3]:
               this.applyChanges();
               hide();
         }
      }
      
      protected function clear() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               CheckBox(this._checkboxes[_loc2_ + "_" + _loc1_]).checked = false;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      override protected function getSettings() : void
      {
         var _loc5_:int = 0;
         var _loc1_:uint = _creator.modelController.getActionsState();
         var _loc2_:String = _loc1_.toString(16);
         while(_loc2_.length < 8)
         {
            _loc2_ = "0" + _loc2_;
         }
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < 8)
         {
            _loc3_ = parseInt(_loc2_.charAt(_loc4_),16).toString(2);
            while(_loc3_.length < 4)
            {
               _loc3_ = "0" + _loc3_;
            }
            _loc5_ = 0;
            while(_loc5_ < 4)
            {
               if(CheckBox(this._checkboxes[_loc5_ + "_" + _loc4_]).enabled)
               {
                  CheckBox(this._checkboxes[_loc5_ + "_" + _loc4_]).checked = _loc3_.charAt(_loc5_) == "1";
               }
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      override protected function applyChanges() : void
      {
         var _loc8_:int = 0;
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         while(_loc7_ < 8)
         {
            _loc2_ = "";
            _loc8_ = 0;
            while(_loc8_ < 4)
            {
               _loc2_ += CheckBox(this._checkboxes[_loc8_ + "_" + _loc7_]).checked ? "1" : "0";
               if(!_loc3_ && _loc8_ == 0 && CheckBox(this._checkboxes[_loc8_ + "_" + _loc7_]).checked)
               {
                  _loc3_ = true;
               }
               if(!_loc4_ && _loc8_ == 1 && CheckBox(this._checkboxes[_loc8_ + "_" + _loc7_]).checked)
               {
                  _loc4_ = true;
               }
               if(!_loc5_ && _loc8_ == 2 && CheckBox(this._checkboxes[_loc8_ + "_" + _loc7_]).checked)
               {
                  _loc5_ = true;
               }
               if(!_loc6_ && _loc8_ == 3 && CheckBox(this._checkboxes[_loc8_ + "_" + _loc7_]).checked)
               {
                  _loc6_ = true;
               }
               _loc8_++;
            }
            _loc1_ += parseInt(_loc2_,2).toString(16);
            _loc7_++;
         }
         _creator.modelController.setActions(parseInt(_loc1_,16));
         if(_creator.modelController.selection.length > 0)
         {
            if(_loc3_ && _creator.modelController.selection.objects[0].props.sensor_group == 0)
            {
               if(_creator.modelController.selection.length > 1)
               {
                  _creator.uiController.notice("Your objects have actions applied to their Sensor events. Make sure you put them on at least one sensor layer in the panel above!");
               }
               else
               {
                  _creator.uiController.notice("Your object has actions applied to its Sensor event. Make sure you put it on at least one sensor layer in the panel above!");
               }
               _creator.ui.layersMenu.show();
               _creator.uiController.tweener.createTween(_creator.ui.sensorLayersTitle.mc,"alpha",1,0.5,0.5,true,true,12);
            }
            else if(_loc4_ && _creator.modelController.selection.objects[0].props.strength == CreatorUIStates.STRENGTH_PERM)
            {
               if(_creator.modelController.selection.length > 1)
               {
                  _creator.uiController.notice("Your objects have actions applied to their Crush events. Make sure you choose a crushable strength from the menu above!");
               }
               else
               {
                  _creator.uiController.notice("Your object has actions applied to its Crush event. Make sure you choose a crushable strength from the menu above!");
               }
               _creator.ui.strengths.toggle();
            }
            else if(_loc5_ && !(_creator.model.modifiers.containsType(CreatorUIStates.MODIFIER_ADDER) || _creator.model.modifiers.containsType(CreatorUIStates.MODIFIER_SPAWNER) || _creator.model.modifiers.containsType(CreatorUIStates.MODIFIER_FACTORY)))
            {
               _creator.uiController.notice("You have actions applied to the Empty event. Make sure you place an Adder, Spawner or Factory modifer, or sensor link this to one!");
            }
            else if(_loc6_ && _creator.environment.extents == Environment.EXTENTS_ENCLOSED)
            {
               _creator.uiController.notice("You have actions applied to the Out of Bounds event, but your Playfield Boundaries are enclosed. Click \'Playfield\' above and choose another option!");
               _creator.modelController.selection.clear();
               _creator.uiController.tweener.createTween(_creator.ui.world.mc,"alpha",1,0.5,0.5,true,true,12);
            }
         }
      }
      
      override public function show() : void
      {
         if(!_contentCreated)
         {
            this.createContent();
         }
         super.show();
      }
   }
}

