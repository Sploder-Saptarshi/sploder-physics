package com.sploder.builder.ui
{
   import com.sploder.asui.Cell;
   import com.sploder.asui.CheckBox;
   import com.sploder.asui.Clip;
   import com.sploder.asui.Component;
   import com.sploder.asui.HRule;
   import com.sploder.asui.HTMLField;
   import com.sploder.asui.Position;
   import com.sploder.asui.RadioButton;
   import com.sploder.builder.Creator;
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.builder.Styles;
   import com.sploder.builder.model.Environment;
   import flash.events.Event;
   
   public class DialogueEnvironment extends Dialogue
   {
      private var sizeNormal:RadioButton;
      
      private var sizeDouble:RadioButton;
      
      private var sizeFollow:RadioButton;
      
      private var gravity:CheckBox;
      
      private var resistance:CheckBox;
      
      private var p_enclose:RadioButton;
      
      private var p_ground:RadioButton;
      
      private var p_open:RadioButton;
      
      private var sizeNormalc:Clip;
      
      private var sizeDoublec:Clip;
      
      private var sizeFollowc:Clip;
      
      public function DialogueEnvironment(param1:Creator, param2:int = 300, param3:int = 300, param4:String = "Title", param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function create() : void
      {
         _buttons = ["Cancel","Reset","Apply"];
         super.create();
         dbox.contentPadding = 55;
         _creator.ui.uiContainer.addChild(dbox);
         dbox.addButtonListener(Component.EVENT_CLICK,this.onClick);
         hide();
      }
      
      public function createContent() : void
      {
         if(_contentCreated)
         {
            return;
         }
         var _loc1_:String = "Game area is the same size as it appears in the creator, and the game is not scaled";
         var _loc2_:String = "Game area is double size as the creator window, and the game is scaled to half-size in order to show the whole area";
         var _loc3_:String = "Game area is double size as the creator window, and the game is not scaled, but follows your controlled object like a camera";
         dbox.contentCell.addChild(new Cell(null,NaN,10));
         dbox.contentCell.addChild(new HTMLField(null,"Playfield Size and View:",NaN,false,null,Styles.dialogueStyle));
         dbox.contentCell.addChild(new Cell(null,NaN,10));
         this.sizeNormalc = new Clip(null,CreatorUIStates.PLAYFIELD_SIZE_NORMAL,Clip.EMBED_LOCAL,120,60,Clip.SCALEMODE_NOSCALE,"",false,_loc1_,Styles.floatPosition.clone({"margin_left":5}));
         this.sizeNormalc.showAltImmediate = true;
         dbox.contentCell.addChild(this.sizeNormalc);
         this.sizeNormalc.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.sizeDoublec = new Clip(null,CreatorUIStates.PLAYFIELD_SIZE_DOUBLE,Clip.EMBED_LOCAL,120,60,Clip.SCALEMODE_NOSCALE,"",false,_loc2_,Styles.floatPosition);
         this.sizeDoublec.showAltImmediate = true;
         dbox.contentCell.addChild(this.sizeDoublec);
         this.sizeDoublec.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.sizeFollowc = new Clip(null,CreatorUIStates.PLAYFIELD_SIZE_FOLLOW,Clip.EMBED_LOCAL,80,60,Clip.SCALEMODE_NOSCALE,"",false,_loc3_,Styles.floatPosition.clone({"clear":Position.CLEAR_RIGHT}));
         this.sizeFollowc.showAltImmediate = true;
         dbox.contentCell.addChild(this.sizeFollowc);
         this.sizeFollowc.addEventListener(Component.EVENT_CLICK,this.onClick);
         dbox.contentCell.addChild(new Cell(null,NaN,10));
         this.sizeNormal = new RadioButton(null,"Normal Size",Environment.SIZE_NORMAL + "","psize",true,120,30,_loc1_,Styles.floatPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this.sizeNormal);
         this.sizeDouble = new RadioButton(null,"Double Size",Environment.SIZE_DOUBLE + "","psize",false,120,30,_loc2_,Styles.floatPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this.sizeDouble);
         this.sizeFollow = new RadioButton(null,"Zoomed",Environment.SIZE_FOLLOW + "","psize",false,120,30,_loc3_,Styles.floatPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this.sizeFollow);
         dbox.contentCell.addChild(new HRule(null,320,null,Styles.dialogueStyle.clone({
            "border":true,
            "borderWidth":4,
            "borderColor":16777215,
            "borderAlpha":1
         })));
         dbox.contentCell.addChild(new Cell(null,NaN,10));
         dbox.contentCell.addChild(new HTMLField(null,"Playfield Physics:",NaN,false,null,Styles.dialogueStyle));
         dbox.contentCell.addChild(new Cell(null,NaN,10));
         this.gravity = new CheckBox(null,"Gravity","true",true,120,30,"Check to simulate gravity by pulling objects down toward the bottom of the screen",Styles.floatPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this.gravity);
         this.resistance = new CheckBox(null,"Motion Resistance","true",false,240,30,"Check to slow down objects as they move and turn. Good for top-down games.",Styles.floatPosition,Styles.dialogueStyle);
         dbox.contentCell.addChild(this.resistance);
         dbox.contentCell.addChild(new HRule(null,320,null,Styles.dialogueStyle.clone({
            "border":true,
            "borderWidth":4,
            "borderColor":16777215,
            "borderAlpha":1
         })));
         dbox.contentCell.addChild(new Cell(null,NaN,10));
         dbox.contentCell.addChild(new HTMLField(null,"Playfield Boundaries:",NaN,false,null,Styles.dialogueStyle));
         dbox.contentCell.addChild(new Cell(null,NaN,10));
         this.p_enclose = new RadioButton(null,"Enclosed",Environment.EXTENTS_ENCLOSED + "","pextents",true,118,30,"Completely enclose the playfield and do not allow objects to escape",Styles.floatPosition,Styles.dialogueStyle);
         this.p_enclose.radioSymbolName = CreatorUIStates.PLAYFIELD_EXTENTS_ENCLOSED;
         dbox.contentCell.addChild(this.p_enclose);
         this.p_ground = new RadioButton(null,"Ground Only",Environment.EXTENTS_GROUND + "","pextents",false,118,30,"Allow objects to escape the playfield, but not go below the bottom",Styles.floatPosition,Styles.dialogueStyle);
         this.p_ground.radioSymbolName = CreatorUIStates.PLAYFIELD_EXTENTS_GROUND;
         dbox.contentCell.addChild(this.p_ground);
         this.p_open = new RadioButton(null,"Open",Environment.EXTENTS_OPEN + "","pextents",false,120,30,"Allow objects to escape the playfield, and do not stop any of them",Styles.floatPosition,Styles.dialogueStyle);
         this.p_open.radioSymbolName = CreatorUIStates.PLAYFIELD_EXTENTS_OPEN;
         dbox.contentCell.addChild(this.p_open);
         _contentCreated = true;
      }
      
      override protected function onClick(param1:Event) : void
      {
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
               this.applyChanges();
               hide();
               break;
            case this.sizeNormalc:
               this.sizeNormal.checked = true;
               break;
            case this.sizeDoublec:
               this.sizeDouble.checked = true;
               break;
            case this.sizeFollowc:
               this.sizeFollow.checked = true;
         }
      }
      
      override protected function getSettings() : void
      {
         RadioButton(RadioButton.groups["psize"].buttons[_creator.environment.size]).checked = true;
         this.gravity.checked = _creator.environment.gravity == 1;
         this.resistance.checked = _creator.environment.resistance == 1;
         RadioButton(RadioButton.groups["pextents"].buttons[_creator.environment.extents]).checked = true;
      }
      
      override protected function applyChanges() : void
      {
         _creator.environment.size = parseInt(RadioButton.groups["psize"].value);
         _creator.environment.gravity = this.gravity.checked ? 1 : 0;
         _creator.environment.resistance = this.resistance.checked ? 1 : 0;
         _creator.environment.extents = parseInt(RadioButton.groups["pextents"].value);
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

