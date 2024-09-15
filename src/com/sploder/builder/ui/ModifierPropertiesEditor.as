package com.sploder.builder.ui
{
   import com.sploder.asui.Cell;
   import com.sploder.asui.CheckBox;
   import com.sploder.asui.Component;
   import com.sploder.asui.FormField;
   import com.sploder.asui.HTMLField;
   import com.sploder.asui.Position;
   import com.sploder.asui.Style;
   import com.sploder.builder.CreatorUI;
   import com.sploder.builder.CreatorUIStates;
   import com.sploder.builder.Styles;
   import com.sploder.builder.model.Modifier;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ModifierPropertiesEditor
   {
      protected var _ui:CreatorUI;
      
      protected var _modifier:Modifier;
      
      protected var _cell:Cell;
      
      protected var _container:Sprite;
      
      protected var _showing:Boolean = false;
      
      protected var box:Cell;
      
      protected var amt1:FormField;
      
      protected var amt2:FormField;
      
      protected var amt3:FormField;
      
      protected var optA:CheckBox;
      
      protected var optB:CheckBox;
      
      protected var optC:CheckBox;
      
      public function ModifierPropertiesEditor(param1:CreatorUI)
      {
         super();
         this.init(param1);
      }
      
      public function get showing() : Boolean
      {
         return this._showing;
      }
      
      public function get modifier() : Modifier
      {
         return this._modifier;
      }
      
      protected function init(param1:CreatorUI) : void
      {
         this._ui = param1;
         this._container = new Sprite();
         this._container.x = 80;
         this._container.y = 90;
         CreatorUI.stage.addChild(this._container);
         this._cell = new Cell(this._container,640,480,false,false);
      }
      
      protected function onChange(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.amt1)
         {
            switch(this._modifier.props.type)
            {
               case CreatorUIStates.MODIFIER_THRUSTER:
                  this.amt1.maxChars = 1;
                  if(this.amt1.value.length > 0)
                  {
                     _loc3_ = Number(this.amt1.value.charCodeAt(0));
                     if(!isNaN(_loc3_) && _loc3_ >= 65 && _loc3_ <= 122)
                     {
                        if(_loc3_ > 90)
                        {
                           _loc3_ -= 32;
                        }
                        this._modifier.props.amount = _loc3_;
                     }
                  }
                  break;
               case CreatorUIStates.MODIFIER_ARCADEMOVER:
                  if(this.amt1.value.length > 0)
                  {
                     _loc4_ = Math.floor(Math.max(0,Math.min(20,parseInt(this.amt1.value))));
                     if(!isNaN(_loc4_))
                     {
                        this._modifier.props.amount = _loc4_;
                     }
                  }
                  break;
               default:
                  _loc2_ = parseFloat(this.amt1.value);
                  if(!isNaN(_loc2_))
                  {
                     this._modifier.props.amount = _loc2_ * 1000;
                  }
            }
         }
         if(this.amt2)
         {
            _loc5_ = parseInt(this.amt2.value,10);
            if(!isNaN(_loc5_))
            {
               this._modifier.props.amount2 = _loc5_;
            }
         }
         if(this.amt3)
         {
            _loc6_ = parseInt(this.amt3.value,10);
            if(!isNaN(_loc6_))
            {
               this._modifier.props.amount3 = _loc6_;
            }
         }
         if(this.optA)
         {
            this._modifier.props.optionA = this.optA.checked;
            if(param1.target == this.optA && this.optA.checked && this.optB && this.optB.checked && (this._modifier.props.type == CreatorUIStates.MODIFIER_SLIDER || this._modifier.props.type == CreatorUIStates.MODIFIER_MOVER || this._modifier.props.type == CreatorUIStates.MODIFIER_ARCADEMOVER || this._modifier.props.type == CreatorUIStates.MODIFIER_JUMPER))
            {
               this._modifier.props.optionB = this.optB.checked = false;
            }
         }
         if(this.optB)
         {
            this._modifier.props.optionB = this.optB.checked;
            if(param1.target == this.optB && this.optB.checked && this.optA && this.optA.checked && (this._modifier.props.type == CreatorUIStates.MODIFIER_SLIDER || this._modifier.props.type == CreatorUIStates.MODIFIER_MOVER || this._modifier.props.type == CreatorUIStates.MODIFIER_ARCADEMOVER || this._modifier.props.type == CreatorUIStates.MODIFIER_JUMPER))
            {
               this._modifier.props.optionA = this.optA.checked = false;
            }
         }
         if(this.optC)
         {
            this._modifier.props.optionC = this.optC.checked;
         }
      }
      
      protected function build() : void
      {
         var _loc24_:HTMLField = null;
         var _loc28_:Rectangle = null;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:String = "";
         var _loc8_:String = "";
         var _loc9_:String = "";
         var _loc10_:String = "";
         var _loc11_:String = "";
         var _loc12_:String = "";
         var _loc13_:String = "";
         var _loc14_:String = "";
         var _loc15_:String = "";
         var _loc16_:String = "";
         var _loc17_:String = "";
         var _loc18_:String = "";
         var _loc19_:Number = 0;
         var _loc20_:String = "0123456789.";
         var _loc21_:int = 75;
         switch(this._modifier.props.type)
         {
            case CreatorUIStates.MODIFIER_ADDER:
               _loc7_ = "<p align=\"right\">Key down speed <a class=\"litelink\" href=\"event:showtag\">(?)</a> (secs)</p>";
               _loc13_ = "Speed at which objects are added while the spacebar is pushed down";
               _loc8_ = "<p align=\"right\">Total Adds <a class=\"litelink\" href=\"event:showtag\">(?)</a> (0 for infinity)</p>";
               _loc9_ = "<p align=\"right\">Added Lifespan <a class=\"litelink\" href=\"event:showtag\">(?)</a> (secs)</p>";
               _loc4_ = true;
               _loc10_ = "use mouse click";
               _loc16_ = "Check this if you want to use a mouse click instead of the spacebar";
            case CreatorUIStates.MODIFIER_SPAWNER:
            case CreatorUIStates.MODIFIER_FACTORY:
               _loc1_ = true;
               if(_loc7_ == "")
               {
                  _loc7_ = "<p align=\"right\">Spawn Interval <a class=\"litelink\" href=\"event:showtag\">(?)</a> (secs)</p>";
               }
               if(_loc13_ == "")
               {
                  _loc13_ = "Speed (in seconds) at which new objects are added to the game";
               }
               _loc2_ = true;
               if(_loc8_ == "")
               {
                  _loc8_ = "<p align=\"right\">Total Spawns <a class=\"litelink\" href=\"event:showtag\">(?)</a> (0 for infinity)</p>";
               }
               if(_loc14_ == "")
               {
                  _loc14_ = "Total number of objects this widget will add to the game";
               }
               _loc3_ = true;
               if(_loc9_ == "")
               {
                  _loc9_ = "<p align=\"right\">Spawned Lifespan <a class=\"litelink\" href=\"event:showtag\">(?)</a> (secs)</p>";
               }
               if(_loc15_ == "")
               {
                  _loc15_ = "How long each spawned object will live in the game. Enter 0 for forever.";
               }
               if(!_loc4_)
               {
                  _loc19_ = 130;
               }
               else
               {
                  _loc19_ = 160;
               }
               _loc5_ = true;
               _loc11_ = "explode on expire";
               _loc17_ = "Check this if you want spawned objects to explode at end of lifespan";
               break;
            case CreatorUIStates.MODIFIER_THRUSTER:
               _loc1_ = true;
               if(_loc7_ == "")
               {
                  _loc7_ = "<p align=\"right\">Keyboard letter to press <a class=\"litelink\" href=\"event:showtag\">(?)</a></p>";
               }
               if(_loc13_ == "")
               {
                  _loc13_ = "Enter a letter for which key to press to activate this thruster";
               }
               _loc4_ = true;
               _loc10_ = "don\'t rotate with object";
               _loc16_ = "Check this if you want the thruster to always point in the same direction regardless of object orientation";
               _loc19_ = 75;
               _loc20_ = "a-zA-Z";
               _loc21_ = 33;
               break;
            case CreatorUIStates.MODIFIER_SLIDER:
               _loc4_ = true;
               _loc10_ = "only use LEFT and RIGHT arrows";
               _loc16_ = "Check this if you want to only use the LEFT and RIGHT arrows and not the A and D keys";
               _loc5_ = true;
               _loc11_ = "only use A and D keys";
               _loc17_ = "Check this if you want to only use the A and D keys and not the LEFT and RIGHT arrow keys";
               _loc21_ = 33;
               _loc19_ = 75;
               break;
            case CreatorUIStates.MODIFIER_MOVER:
               _loc4_ = true;
               _loc10_ = "only use UP and DOWN arrows";
               _loc16_ = "Check this if you want to only use the UP and DOWN arrows and not the W and S keys";
               _loc5_ = true;
               _loc11_ = "only use W and S keys";
               _loc17_ = "Check this if you want to only use the W and S keys and not the UP and DOWN arrow keys";
               _loc21_ = 33;
               _loc19_ = 75;
               break;
            case CreatorUIStates.MODIFIER_ARCADEMOVER:
               _loc1_ = true;
               if(_loc7_ == "")
               {
                  _loc7_ = "<p align=\"right\">Movement <a class=\"litelink\" href=\"event:showtag\">(?)</a> (pixels)</p>";
               }
               if(_loc13_ == "")
               {
                  _loc13_ = "Speed (in pixels per frame) at which the object moves when a direction arrow is pressed";
               }
               _loc4_ = true;
               _loc10_ = "only use arrow keys";
               _loc16_ = "Check this if you want to only use the arrow keys and not the WASD keys";
               _loc5_ = true;
               _loc11_ = "only use WASD keys";
               _loc17_ = "Check this if you want to only use the WASD keys and not the arrow keys";
               _loc21_ = 33;
               _loc19_ = 110;
               break;
            case CreatorUIStates.MODIFIER_JUMPER:
               _loc4_ = true;
               _loc10_ = "only use UP arrow";
               _loc16_ = "Check this if you want to only use the UP arrow and not the W key";
               _loc5_ = true;
               _loc11_ = "only use W key";
               _loc17_ = "Check this if you want to only use the W key and not the arrow key";
               _loc6_ = true;
               _loc12_ = "Allow air-jumping";
               _loc18_ = "Check this if you want to be able to jump repeatedly in mid air";
               _loc21_ = 33;
               _loc19_ = 100;
         }
         var _loc22_:Point = new Point(0,0);
         var _loc23_:Point = new Point();
         if(this._modifier.props.type == CreatorUIStates.MODIFIER_FACTORY && this._modifier.clip && Boolean(this._modifier.clip.parent))
         {
            _loc28_ = this._modifier.clip.getBounds(this._container);
            _loc22_.x = _loc28_.x + _loc28_.width * 0.5;
            _loc22_.y = _loc28_.y + _loc28_.height * 0.5;
            _loc23_.x = _loc28_.width * 0.5;
            _loc23_.y = 0 - _loc28_.height * 0.5;
         }
         else
         {
            _loc22_ = this._modifier.props.parent.clip.localToGlobal(_loc22_);
            _loc22_ = this._container.globalToLocal(_loc22_);
            _loc23_.x = this._modifier.props.parent.props.width * 0.5;
            _loc23_.y = 0 - _loc19_ * 0.5;
         }
         this.box = new Cell(null,250,_loc19_,true,true,10);
         this._cell.addChild(this.box);
         this.box.x = _loc22_.x + _loc23_.x + 20;
         this.box.y = _loc22_.y + _loc23_.y;
         if(this.box.x > 640 - 250)
         {
            this.box.x = _loc22_.x - _loc23_.x - 20 - 250;
         }
         if(this.box.y > 480 - 150)
         {
            this.box.y = 480 - 150;
         }
         this.box.x = Math.floor(this.box.x);
         this.box.y = Math.floor(this.box.y);
         this.box.addChild(new Cell(null,250,10));
         this.box.allowCellDrag();
         var _loc25_:Style;
         (_loc25_ = Styles.dialogueStyle.clone()).fontSize = 11;
         _loc25_.textColor = 13421772;
         var _loc26_:Style;
         (_loc26_ = _loc25_.clone()).embedFonts = false;
         _loc26_.font = "_sans";
         var _loc27_:Position = Styles.floatPosition.clone({"margins":"5 10 5 10"});
         if(_loc1_)
         {
            (_loc24_ = new HTMLField(null,_loc7_,150,false,_loc27_,_loc25_)).alt = _loc13_;
            this.box.addChild(_loc24_);
            this.amt1 = new FormField(null,"000",60,25,true,Styles.floatPosition,_loc26_);
            this.box.addChild(this.amt1);
            this.amt1.restrict = _loc20_;
            if(this._modifier.props.type == CreatorUIStates.MODIFIER_THRUSTER)
            {
               this.amt1.text = String.fromCharCode(this._modifier.props.amount);
            }
            else if(this._modifier.props.type == CreatorUIStates.MODIFIER_ARCADEMOVER)
            {
               this.amt1.text = this._modifier.props.amount + "";
            }
            else
            {
               this.amt1.text = this._modifier.props.amount / 1000 + "";
            }
            this.amt1.addEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         if(_loc2_)
         {
            (_loc24_ = new HTMLField(null,_loc8_,150,false,_loc27_,_loc25_)).alt = _loc14_;
            this.box.addChild(_loc24_);
            this.amt2 = new FormField(null,"000",60,25,true,Styles.floatPosition,_loc26_);
            this.box.addChild(this.amt2);
            this.amt2.restrict = "0123456789";
            this.amt2.text = this._modifier.props.amount2.toString();
            this.amt2.addEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         if(_loc3_)
         {
            (_loc24_ = new HTMLField(null,_loc9_,150,false,_loc27_,_loc25_)).alt = _loc15_;
            this.box.addChild(_loc24_);
            this.amt3 = new FormField(null,"000",60,25,true,Styles.floatPosition,_loc26_);
            this.box.addChild(this.amt3);
            this.amt3.restrict = "0123456789";
            this.amt3.text = this._modifier.props.amount3.toString();
            this.amt3.addEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         if(_loc4_)
         {
            this.optA = new CheckBox(null,_loc10_,"mouse",this._modifier.props.optionA,200,20,_loc16_,_loc27_.clone({"margin_left":_loc21_}),_loc25_);
            this.box.addChild(this.optA);
            this.optA.addEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         if(_loc5_)
         {
            this.optB = new CheckBox(null,_loc11_,"splode",this._modifier.props.optionB,200,25,_loc17_,_loc27_.clone({
               "margin_left":_loc21_,
               "margin_top":0
            }),_loc25_);
            this.box.addChild(this.optB);
            this.optB.addEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         if(_loc6_)
         {
            this.optC = new CheckBox(null,_loc12_,"flapp",this._modifier.props.optionC,200,20,_loc18_,_loc27_.clone({
               "margin_left":_loc21_,
               "margin_top":0
            }),_loc25_);
            this.box.addChild(this.optC);
            this.optC.addEventListener(Component.EVENT_CHANGE,this.onChange);
         }
      }
      
      protected function unbuild() : void
      {
         if(this.amt1)
         {
            this.amt1.removeEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         if(this.amt2)
         {
            this.amt2.removeEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         if(this.amt3)
         {
            this.amt3.removeEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         if(this.optA)
         {
            this.optA.removeEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         if(this.optB)
         {
            this.optB.removeEventListener(Component.EVENT_CHANGE,this.onChange);
         }
         this.amt1 = this.amt2 = this.amt3 = null;
         this.optA = null;
         this.optB = null;
         this._cell.clear();
      }
      
      public function show(param1:Modifier) : void
      {
         if(this._modifier != param1)
         {
            this.hide();
         }
         if(!this._showing)
         {
            this._modifier = param1;
            this._showing = true;
            this.build();
         }
      }
      
      public function hide() : void
      {
         if(this._showing)
         {
            this.unbuild();
            this._showing = false;
         }
      }
   }
}

