package com.sploder.builder
{
   import com.sploder.asui.ClipButton;
   import com.sploder.asui.Collection;
   import com.sploder.asui.Component;
   import com.sploder.asui.Prompt;
   import com.sploder.asui.Tagtip;
   import com.sploder.asui.ToggleButton;
   import com.sploder.asui.TweenManager;
   import com.sploder.builder.model.Environment;
   import com.sploder.builder.model.ModelController;
   import com.sploder.builder.model.ModelObject;
   import com.sploder.builder.model.ModelObjectProperties;
   import com.sploder.builder.model.ModelObjectSprite;
   import com.sploder.builder.model.ModelSelection;
   import com.sploder.builder.model.Modifier;
   import com.sploder.game.effect.BackgroundEffect;
   import com.sploder.util.Geom2d;
   import com.sploder.util.Key;
   import com.sploder.util.ScrollHelper;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   import flash.ui.Keyboard;
   
   public class CreatorUIController
   {
      protected var _creator:Creator;
      
      protected var _currentToolState:String = "icon_tool_select";
      
      protected var _currentTray:Collection;
      
      protected var _m:Matrix;
      
      public var scrollHelper:ScrollHelper;
      
      protected var _tweener:TweenManager;
      
      public var keyboardEnabled:Boolean = true;
      
      private var _prefabAppearanceNoticeSent:Boolean = false;
      
      private var _ui:CreatorUI;
      
      private var _mc:ModelController;
      
      public function CreatorUIController(param1:Creator)
      {
         super();
         this.init(param1);
      }
      
      public function get currentToolState() : String
      {
         return this._currentToolState;
      }
      
      public function get tweener() : TweenManager
      {
         return this._tweener;
      }
      
      public function get isZoomedOut() : Boolean
      {
         return this._creator.model.container.scaleX < 1;
      }
      
      protected function init(param1:Creator) : void
      {
         this._creator = param1;
         this._m = new Matrix();
         this._tweener = new TweenManager(true);
      }
      
      public function connect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         this._ui = this._creator.ui;
         this._mc = this._creator.modelController;
         this._ui.trayButtons.addEventListener(Component.EVENT_CHANGE,this.onTrayMenuChange);
         for(_loc2_ in this._ui.trays)
         {
            if(_loc2_ != CreatorUIStates.TRAY_PREFABS)
            {
               this._ui.trays[_loc2_].addEventListener(Component.EVENT_DROP,this.onDragFromTray);
            }
            if(_loc2_ != CreatorUIStates.TRAY_PREFABS)
            {
               this._ui.trays[_loc2_].addEventListener(Component.EVENT_MOVE,this.onDragFromTrayMove);
            }
            this._ui.trays[_loc2_].addEventListener(Component.EVENT_DROP,this.onDropFromTray);
         }
         this._currentTray = this._ui.trays[CreatorUIStates.TRAY_PREFABS];
         this._ui.trayPager.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.tools.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.shapes.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.constraints.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.materials.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.strengths.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.moveLock.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.layersButton.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.actionsButton.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.layersButtons.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.moveGroup.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.delSelection.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.fills.addEventListener(Component.EVENT_SELECT,this.onClick);
         this._ui.lines.addEventListener(Component.EVENT_SELECT,this.onClick);
         this._ui.textures.addEventListener(Component.EVENT_SELECT,this.onClick);
         this._ui.zlayers.addEventListener(Component.EVENT_SELECT,this.onClick);
         this._ui.opaque.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.scribble.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.graphicsPanelToggle.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.animationToggle.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.ddAnimation.addEventListener(Component.EVENT_BLUR,this.onBlur);
         this._ui.animNormal.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.animFlip.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.animWalk.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.animRotate.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.animRotateWalk.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.advancedTextureToggle.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.layerViewToggle.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.ddLayerView.addEventListener(Component.EVENT_BLUR,this.onBlur);
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            this._ui.layerViewButtons[_loc1_].addEventListener(Component.EVENT_CLICK,this.onClick);
            _loc1_++;
         }
         this._ui.layerDefaultButtons.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.updateLayerViewDisplay();
         this._mc.selection.addEventListener(Event.CHANGE,this.onChange);
         this._creator.model.modifiers.addEventListener(Event.SELECT,this.onModifierSelect);
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            ToggleButton(this._ui.layers["p_" + _loc1_]).addEventListener(Component.EVENT_CLICK,this.onPassthruButtonClick);
            _loc1_++;
         }
         this._ui.world.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.bkgd.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.goals.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.music.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.clipboard.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._creator.environment.addEventListener(Event.CHANGE,this.onEnvironmentChange);
         this._ui.testEndButton.addEventListener(Component.EVENT_CLICK,this.onClick);
         this._ui.undoButton.addEventListener(MouseEvent.CLICK,this.undo);
         Tagtip.connectButton(this._ui.undoButton,"Undo last edit (CTRL-Z)");
         this._ui.redoButton.addEventListener(MouseEvent.CLICK,this.redo);
         Tagtip.connectButton(this._ui.redoButton,"Redo last undo (CTRL-Y)");
         this._ui.helpButton.addEventListener(MouseEvent.CLICK,this.showHelp);
         this._creator.project.addEventListener(CreatorProject.EVENT_NEW,this.onProjectChange);
         this._creator.project.addEventListener(CreatorProject.EVENT_LOAD,this.onProjectChange);
         this.drawBackground();
         this.scrollHelper = new ScrollHelper();
         this.scrollHelper.hScroller = this._ui.hScroll;
         this.scrollHelper.vScroller = this._ui.vScroll;
         this._ui.zoomToggle.addEventListener(Component.EVENT_CLICK,this.onClick);
         Component.mainStage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
         Component.mainStage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,0,true);
         this._creator.model.modifiers.addEventListener(Event.CLEAR,this.onModifierDelete,false,0,true);
         this._mc.history.addEventListener(Event.CHANGE,this.onHistoryChange);
         this.onHistoryChange();
         if(this._ui.stage.stageWidth < 720)
         {
            this.notice("<font color=\"#FFFFFF\">Yikes! Your screen is too small!</font> Your browser may not have it\'s zoom settings set at 100%. Try changing your browser settings and start again.");
         }
         this._ui.ddGraphics.connect();
      }
      
      protected function zoomIn() : void
      {
         if(this.isZoomedOut)
         {
            if(this._ui.zoomToggle.toggled)
            {
               this._ui.zoomToggle.toggle();
            }
            this._creator.model.container.scaleX = this._creator.model.container.scaleY = 1;
            this._ui.playfieldContainer.x = 136;
            this._ui.playfieldContainer.contentX = 0;
            this._ui.playfieldContainer.contentY = 0;
            this._ui.vScroll.reset();
            this._ui.hScroll.reset();
            this._ui.vScroll.show();
            this._ui.hScroll.show();
         }
      }
      
      protected function zoomOut() : void
      {
         if(!this.isZoomedOut && this._creator.environment.size != Environment.SIZE_NORMAL)
         {
            if(!this._ui.zoomToggle.toggled)
            {
               this._ui.zoomToggle.toggle();
            }
            this._creator.model.container.scaleX = this._creator.model.container.scaleY = 0.5;
            this._ui.playfieldContainer.x = 180;
            this._ui.playfieldContainer.contentX = 0;
            this._ui.playfieldContainer.contentY = 0;
            this._ui.vScroll.hide();
            this._ui.hScroll.hide();
         }
      }
      
      public function confirm(param1:Object, param2:Function, param3:Array = null, param4:String = "") : void
      {
         this._ui.ddConfirm.confirm(param1,param2,param3,param4);
      }
      
      public function alert(param1:String = "") : void
      {
         if(param1.length)
         {
            this._ui.ddAlert.alert(param1);
         }
      }
      
      public function notice(param1:String = "") : void
      {
         if(param1.length)
         {
            this._ui.notice.show(param1);
         }
      }
      
      protected function onModifierSelect(param1:Event) : void
      {
         var _loc2_:Modifier = null;
         if(this._creator.model.modifiers.focusObject != null)
         {
            _loc2_ = this._creator.model.modifiers.focusObject;
            switch(_loc2_.props.type)
            {
               case CreatorUIStates.MODIFIER_THRUSTER:
               case CreatorUIStates.MODIFIER_ADDER:
               case CreatorUIStates.MODIFIER_SPAWNER:
               case CreatorUIStates.MODIFIER_FACTORY:
               case CreatorUIStates.MODIFIER_MOVER:
               case CreatorUIStates.MODIFIER_ARCADEMOVER:
               case CreatorUIStates.MODIFIER_JUMPER:
               case CreatorUIStates.MODIFIER_SLIDER:
                  this._ui.modifierPropertiesEditor.show(_loc2_);
                  return;
            }
         }
         if(this._ui.modifierPropertiesEditor.showing)
         {
            this._ui.modifierPropertiesEditor.hide();
         }
      }
      
      protected function onModifierDelete(param1:Event) : void
      {
         if(this._ui.modifierPropertiesEditor.showing)
         {
            this._ui.modifierPropertiesEditor.hide();
         }
      }
      
      protected function onChange(param1:Event) : void
      {
         switch(param1.target)
         {
            case this._mc.selection:
               this.updateSubToolsDisplay();
         }
      }
      
      protected function onEnvironmentChange(param1:Event = null) : void
      {
         var _loc2_:Graphics = null;
         if(this._creator.environment.size == Environment.SIZE_NORMAL)
         {
            if(this._creator.model.width != 640)
            {
               if(param1)
               {
                  this.zoomIn();
               }
               Styles.playfieldStyle.bgGradientRatios = [0,100,200];
               this._ui.playfieldContainer.x = 180;
               this._ui.playfieldContainer.resizeCell(640,480);
               this._ui.playfield.resizeCell(640,480);
               this._ui.vScroll.reset();
               this._ui.hScroll.reset();
               this._ui.vScroll.hide();
               this._ui.hScroll.hide();
               this._ui.zoomToggle.hide();
               this._creator.model.resize(640,480);
            }
         }
         else if(this._creator.model.width != 1280)
         {
            if(param1)
            {
               this.zoomIn();
            }
            this._ui.playfieldContainer.x = 136;
            Styles.playfieldStyle.bgGradientRatios = [0,180,255];
            this._ui.playfieldContainer.resizeCell(720,480);
            this._ui.playfield.resizeCell(1304,984);
            this._ui.vScroll.onTargetCellChange();
            this._ui.hScroll.onTargetCellChange();
            this._ui.vScroll.show();
            this._ui.hScroll.show();
            this._ui.vScroll.x = 838;
            this._ui.vScroll.y = 92;
            this._ui.hScroll.x = 138;
            this._ui.hScroll.y = 548;
            this._ui.zoomToggle.show();
            _loc2_ = this._ui.playfield.bkgd.graphics;
            _loc2_.beginFill(13158,1);
            _loc2_.drawRect(0,960,1304,24);
            _loc2_.drawRect(1280,0,24,960);
            _loc2_.endFill();
            this._creator.model.resize(1280,960);
         }
         this.drawBackground();
      }
      
      protected function onHistoryChange(param1:Event = null) : void
      {
         this._ui.undoButton.enabled = this._mc.history.hasUndo;
         this._ui.undoButton.alpha = this._mc.history.hasUndo ? 1 : 0.5;
         this._ui.redoButton.enabled = this._mc.history.hasRedo;
         this._ui.redoButton.alpha = this._mc.history.hasRedo ? 1 : 0.5;
      }
      
      protected function drawBackground() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:BackgroundEffect = this._creator.model.backgroundEffect;
         _loc3_.type = this._creator.environment.bgEffect;
         switch(this._creator.environment.size)
         {
            case Environment.SIZE_NORMAL:
               _loc1_ = 640;
               _loc2_ = 480;
               _loc3_.setSize(320,240);
               _loc3_.scaleX = _loc3_.scaleY = 2;
               this._m.createGradientBox(640,480,Geom2d.dtr * 90);
               break;
            case Environment.SIZE_DOUBLE:
               _loc1_ = 1280;
               _loc2_ = 960;
               _loc3_.setSize(640,480);
               _loc3_.scaleX = _loc3_.scaleY = 2;
               this._m.createGradientBox(1280,960,Geom2d.dtr * 90);
               break;
            case Environment.SIZE_FOLLOW:
               _loc1_ = 1280;
               _loc2_ = 960;
               _loc3_.setSize(640,480);
               _loc3_.scaleX = _loc3_.scaleY = 2;
               this._m.createGradientBox(1280,960,Geom2d.dtr * 90);
         }
         var _loc4_:Graphics = this._creator.model.background.graphics;
         _loc4_.clear();
         _loc4_.beginGradientFill(GradientType.LINEAR,[this._creator.environment.bgColorTop,this._creator.environment.bgColorBottom],[1,1],[0,255],this._m);
         _loc4_.drawRect(0,0,_loc1_,_loc2_);
         _loc4_.endFill();
      }
      
      private function onProjectChange(param1:Event) : void
      {
         this._mc.selection.clear();
         if(param1.type == CreatorProject.EVENT_NEW)
         {
            this._mc.history.clear();
         }
         else if(param1.type == CreatorProject.EVENT_LOAD)
         {
            this._mc.history.clear();
            this._mc.history.record();
         }
      }
      
      protected function onTrayMenuChange(param1:Event) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in this._ui.trays)
         {
            this._ui.trays[_loc2_].hide();
         }
         this._currentTray = this._ui.trays[this._ui.trayButtons.value];
         this._ui.trays[this._ui.trayButtons.value].show();
         if(this._ui.trayPager.toggled)
         {
            this._ui.trayPager.toggle();
         }
         this._tweener.removeTweensOnObject(this._currentTray);
         this._currentTray.contentY = 0;
      }
      
      protected function onMouseOut(param1:Event) : void
      {
         switch(param1.target)
         {
            case this._ui.layersMenu:
               this._ui.layersMenu.hide();
         }
      }
      
      protected function onClick(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc5_:ModelObject = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ClipButton = null;
         var _loc9_:int = 0;
         var _loc4_:int = int(this._mc.selection.length);
         if(this._mc.selection.length > 0)
         {
            _loc5_ = this._mc.selection.objects[0];
         }
         switch(param1.target)
         {
            case this._ui.menuItems.test:
               this._creator.model.modifiers.focusObject = null;
               this._mc.selection.clear();
               this._creator.test();
               break;
            case this._ui.trayPager:
               if(this._ui.trayPager.toggled)
               {
                  this._tweener.createTween(this._currentTray,"contentY",this._currentTray.contentY,0 - (this._currentTray.contentHeight - this._currentTray.height) - 3,0.25);
               }
               else
               {
                  this._tweener.createTween(this._currentTray,"contentY",this._currentTray.contentY,0,0.25);
               }
               break;
            case this._ui.tools:
               this._currentToolState = Component(param1.target).value;
               this._ui.ddGraphics.hide();
               this.updateSubToolsDisplay();
               break;
            case this._ui.constraints:
            case this._ui.materials:
            case this._ui.strengths:
               if(_loc4_ > 0)
               {
                  this._mc.updateSelection(param1.target.name);
                  if(_loc5_ && _loc5_.props && _loc5_.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
                  {
                     this._ui.moveLock.disable();
                  }
                  else
                  {
                     this._ui.moveLock.enable();
                  }
               }
               break;
            case this._ui.moveLock:
               if(this._ui.moveLock.toggled)
               {
                  this._mc.lockSelectedObjects();
               }
               else
               {
                  this._mc.unlockSelectedObjects();
               }
               break;
            case this._ui.layersButton:
               if(this._ui.layersMenu.visible)
               {
                  this._ui.layersMenu.hide();
               }
               else
               {
                  this._ui.layersMenu.show();
               }
               break;
            case this._ui.actionsButton:
               this._ui.ddActionMatrix.show();
               break;
            case this._ui.layersButtons:
               this._mc.updateLayersForSelection();
               break;
            case this._ui.moveGroup:
               if(_loc4_ > 1)
               {
                  if(this._mc.selection.selectionIsSingleGroup())
                  {
                     this._mc.ungroupSelectedObjects();
                  }
                  else
                  {
                     this._mc.groupSelectedObjects();
                  }
               }
               break;
            case this._ui.delSelection:
               _loc6_ = int(this._mc.selection.length);
               if(_loc6_ > 0)
               {
                  this.confirm(this._mc.selection,this._mc.selection.destroyObjects,null,_loc6_ == 1 ? "Do you really want to delete this object?" : "Do you really want to delete these " + _loc6_ + " objects?");
               }
               break;
            case this._ui.fills:
               if(this._ui.fills.value == CreatorUIStates.NONE)
               {
                  this._mc.paintFillColor = -1;
               }
               else
               {
                  this._mc.paintFillColor = parseInt(this._ui.fills.value);
               }
               this._mc.updateSelection(CreatorUIStates.DECORATE_FILL);
               break;
            case this._ui.lines:
               if(this._ui.lines.value == CreatorUIStates.NONE)
               {
                  this._mc.paintLineColor = -1;
               }
               else if(this._ui.lines.value == CreatorUIStates.GLOW)
               {
                  this._mc.paintLineColor = -2;
               }
               else
               {
                  this._mc.paintLineColor = parseInt(this._ui.lines.value);
               }
               this._mc.updateSelection(CreatorUIStates.DECORATE_LINE);
               break;
            case this._ui.textures:
               this._mc.paintTexture = CreatorUIStates.textures_iconmap.indexOf(this._ui.textures.value);
               this._mc.updateSelection(CreatorUIStates.TEXTURE);
               this._ui.animationToggle.disable();
               break;
            case this._ui.zlayers:
               this._mc.paintLayer = parseInt(this._ui.zlayers.value.split("icon_layer_").join(""));
               this._mc.updateSelection(CreatorUIStates.DECORATE_ZLAYER);
               break;
            case this._ui.opaque:
               this._mc.paintOpaque = this._ui.opaque.toggled ? 0 : 1;
               this._mc.updateSelection(CreatorUIStates.OPAQUE);
               break;
            case this._ui.scribble:
               this._mc.paintScribble = this._ui.scribble.toggled ? 1 : 0;
               this._mc.updateSelection(CreatorUIStates.SCRIBBLE);
               break;
            case this._ui.graphicsPanelToggle:
               if(this._ui.graphicsPanelToggle.toggled)
               {
                  this._ui.ddGraphics.show();
               }
               else
               {
                  this._ui.ddGraphics.hide();
               }
               break;
            case this._ui.animationToggle:
               if(this._ui.animationToggle.toggled)
               {
                  this._ui.ddAnimation.show();
                  this.updateAnimationDisplay();
               }
               else
               {
                  this._ui.ddAnimation.hide();
               }
               break;
            case this._ui.advancedTextureToggle:
               if(this._ui.advancedTextureToggle.toggled)
               {
                  this._ui.ddTextureGen.show();
               }
               else
               {
                  this._ui.ddTextureGen.hide();
               }
               break;
            case this._ui.layerViewToggle:
               if(this._ui.layerViewToggle.toggled)
               {
                  this._ui.ddLayerView.show();
                  this.updateLayerViewDisplay();
               }
               else
               {
                  this._ui.ddLayerView.hide();
               }
               break;
            case this._ui.layerDefaultButtons:
               if(this._ui.layerDefaultButtons.value != null)
               {
                  _loc7_ = parseInt(this._ui.layerDefaultButtons.value.split(" ")[1]);
                  this._mc.paintLayer = _loc7_;
               }
               break;
            case this._ui.animNormal:
               if(Boolean(_loc5_) && _loc5_.props.graphic > 0)
               {
                  if(_loc5_.props.animation > 1)
                  {
                     _loc5_.props.animation = 1;
                  }
                  _loc5_.props.graphic_flip = 0;
               }
               break;
            case this._ui.animFlip:
               if(Boolean(_loc5_) && _loc5_.props.graphic > 0)
               {
                  if(_loc5_.props.animation > 1)
                  {
                     _loc5_.props.animation = 1;
                  }
                  _loc5_.props.graphic_flip = 1;
               }
               break;
            case this._ui.animWalk:
               if(Boolean(_loc5_) && _loc5_.props.graphic > 0)
               {
                  _loc5_.props.animation = 2;
                  _loc5_.props.graphic_flip = 1;
               }
               break;
            case this._ui.animRotate:
               if(Boolean(_loc5_) && _loc5_.props.graphic > 0)
               {
                  _loc5_.props.animation = 3;
                  _loc5_.props.graphic_flip = 0;
                  _loc5_.props.constraint = CreatorUIStates.MOVEMENT_SLIDE;
               }
               break;
            case this._ui.animRotateWalk:
               if(Boolean(_loc5_) && _loc5_.props.graphic > 0)
               {
                  _loc5_.props.animation = 4;
                  _loc5_.props.graphic_flip = 0;
                  _loc5_.props.constraint = CreatorUIStates.MOVEMENT_SLIDE;
               }
               break;
            case this._ui.world:
               this._ui.ddEnvironment.show();
               break;
            case this._ui.bkgd:
               this._ui.ddBackground.show();
               break;
            case this._ui.zoomToggle:
               if(this.isZoomedOut)
               {
                  this.zoomIn();
               }
               else
               {
                  this.zoomOut();
               }
               break;
            case this._ui.goals:
               this._ui.ddGoals.show();
               break;
            case this._ui.music:
               this._ui.ddMusic.show();
               break;
            case this._ui.clipboard:
               if(Boolean(this._mc.selection) && Boolean(this._mc.selection.length))
               {
                  this.copy();
               }
               this._ui.ddClipboard.show();
               break;
            case this._ui.testEndButton:
               this._creator.testEnd();
         }
         if(param1.target.name != null && param1.target.name.indexOf("layerview_") == 0)
         {
            _loc8_ = param1.target as ClipButton;
            _loc9_ = parseInt(_loc8_.name.charAt(10));
            this._creator.model.setLayerView(_loc9_,_loc8_.toggled);
         }
      }
      
      protected function onBlur(param1:Event) : void
      {
         switch(param1.target)
         {
            case this._ui.ddAnimation:
               if(this._ui.animationToggle.toggled)
               {
                  this._ui.animationToggle.toggle();
               }
               break;
            case this._ui.ddLayerView:
               if(this._ui.layerViewToggle.toggled)
               {
                  this._ui.layerViewToggle.toggle();
               }
         }
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         if(!this.keyboardEnabled)
         {
            return;
         }
         var _loc2_:ModelSelection = this._mc.selection;
         switch(param1.keyCode)
         {
            case Keyboard.UP:
               _loc2_.moveSelection(0,-10);
               break;
            case Keyboard.DOWN:
               _loc2_.moveSelection(0,10);
               break;
            case Keyboard.LEFT:
               _loc2_.moveSelection(-10,0);
               break;
            case Keyboard.RIGHT:
               _loc2_.moveSelection(10,0);
         }
      }
      
      protected function onKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:ModelSelection = null;
         var _loc3_:int = 0;
         if(!this.keyboardEnabled)
         {
            return;
         }
         _loc2_ = this._mc.selection;
         switch(param1.keyCode)
         {
            case Keyboard.DELETE:
               _loc3_ = int(_loc2_.length);
               if(_loc3_ > 0)
               {
                  this.confirm(_loc2_,_loc2_.destroyObjects,null,_loc3_ == 1 ? "Do you really want to delete this object?" : "Do you really want to delete these " + _loc3_ + " objects?");
               }
               break;
            case Key.char("a"):
               if(param1.ctrlKey)
               {
                  _loc2_.clear();
                  _loc2_.addObjects(this._creator.model.objects);
               }
               break;
            case Key.char("d"):
               if(param1.ctrlKey)
               {
                  _loc2_.clear();
               }
               break;
            case Key.char("c"):
               if(param1.ctrlKey)
               {
                  this.copy();
               }
               break;
            case Key.char("x"):
               if(param1.ctrlKey)
               {
                  this.cut();
               }
               break;
            case Key.char("v"):
               if(param1.ctrlKey)
               {
                  this.paste();
               }
               break;
            case Key.char("z"):
               if(param1.ctrlKey)
               {
                  this.undo();
               }
               break;
            case Key.char("y"):
               if(param1.ctrlKey)
               {
                  this.redo();
               }
         }
      }
      
      public function copy() : void
      {
         var _loc1_:ModelSelection = this._mc.selection;
         if(_loc1_.length > 0)
         {
            this._mc.clipboard = this._creator.model.selectionToString(_loc1_.objects);
            System.setClipboard(this._mc.clipboard);
         }
         CreatorUI.stage.focus = Component.mainStage;
      }
      
      public function cut() : void
      {
         var _loc1_:ModelSelection = this._mc.selection;
         if(_loc1_.length > 0)
         {
            this._mc.history.record();
            this._mc.clipboard = this._creator.model.selectionToString(_loc1_.objects);
            System.setClipboard(this._mc.clipboard);
            _loc1_.destroyObjects();
            this.notice("Your selection was cut from the game level and placed in the clipboard. Hit CTRL-V to paste it back into the scene.");
         }
         CreatorUI.stage.focus = Component.mainStage;
      }
      
      public function undo(param1:MouseEvent = null) : void
      {
         this._mc.history.stepBack();
         CreatorUI.stage.focus = Component.mainStage;
      }
      
      public function redo(param1:MouseEvent = null) : void
      {
         this._mc.history.stepForward();
         CreatorUI.stage.focus = Component.mainStage;
      }
      
      public function paste(param1:Boolean = false, param2:String = "", param3:Boolean = false) : void
      {
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Vector.<ModelObject> = null;
         var _loc10_:int = 0;
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         var _loc4_:ModelSelection = this._mc.selection;
         var _loc5_:* = this._creator.model.objects.length == 0;
         var _loc6_:String = !!param2.length ? param2 : this._mc.clipboard;
         if(_loc6_.length)
         {
            _loc7_ = this._creator.model.fromString(_loc6_);
            if((Boolean(_loc8_ = _loc7_[0])) && _loc8_.length > 0)
            {
               this._mc.history.record();
               _loc9_ = new Vector.<ModelObject>();
               _loc10_ = int(_loc8_.length);
               while(_loc10_--)
               {
                  _loc9_.unshift(_loc8_[_loc10_]);
               }
               _loc4_.clear();
               _loc4_.addObjects(_loc9_);
               if(this._creator.environment.size == Environment.SIZE_NORMAL)
               {
                  _loc10_ = int(_loc9_.length);
                  while(_loc10_--)
                  {
                     if(_loc9_[_loc10_].origin.x > 640 || _loc9_[_loc10_].origin.y > 480)
                     {
                        this._creator.environment.size = Environment.SIZE_DOUBLE;
                        break;
                     }
                  }
               }
               if(!param3)
               {
                  _loc10_ = int(_loc9_.length);
                  while(_loc10_--)
                  {
                     if(_loc9_[_loc10_] != null && _loc9_[_loc10_].props != null)
                     {
                        _loc9_[_loc10_].props.zlayer = this._mc.paintLayer;
                     }
                  }
               }
               if(param1)
               {
                  (_loc11_ = new Point()).x = Math.round(this._ui.playfield.mc.mouseX / 10) * 10;
                  _loc11_.y = Math.round(this._ui.playfield.mc.mouseY / 10) * 10;
                  _loc12_ = _loc4_.objects[0].origin.clone();
                  _loc11_ = _loc11_.subtract(_loc12_);
                  _loc4_.moveSelection(_loc11_.x,_loc11_.y);
               }
               else if(!_loc5_)
               {
                  _loc4_.moveSelection(10,10);
               }
            }
         }
         CreatorUI.stage.focus = Component.mainStage;
      }
      
      protected function showHelp(param1:Event) : void
      {
         navigateToURL(new URLRequest("javascript: launchHelp()"),"_self");
      }
      
      protected function onPassthruButtonClick(param1:Event) : void
      {
         var _loc3_:ToggleButton = null;
         var _loc4_:ToggleButton = null;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = param1.target as ToggleButton;
            _loc4_ = this._ui.layers["p_" + _loc2_];
            if(_loc3_ != _loc4_ && _loc4_.toggled)
            {
               _loc4_.toggle();
            }
            _loc2_++;
         }
         this._mc.updateLayersForSelection();
      }
      
      protected function onDragFromTray(param1:Event) : void
      {
         if(this._ui.tools.value != CreatorUIStates.TOOL_SELECT && this._ui.tools.value != CreatorUIStates.TOOL_WINDOW)
         {
            this._ui.tools.value = CreatorUIStates.TOOL_SELECT;
         }
      }
      
      protected function onDragFromTrayMove(param1:Event) : void
      {
         var _loc2_:String = Collection(param1.target).selectedMembers[0].value;
         var _loc3_:Point = Collection(param1.target).dropPoint;
         this._mc.focusObject = this._creator.model.objectAtPoint(_loc3_);
         if(_loc2_ == CreatorUIStates.MODIFIER_FACTORY)
         {
            if(Boolean(this._mc.focusObject) && Boolean(this._mc.focusObject.group))
            {
               this._mc.selection.clear();
               this._mc.selection.addObjects(this._mc.focusObject.group.objects);
            }
         }
      }
      
      protected function onDropFromTray(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = Collection(param1.target).selectedMembers[0].value;
         if(_loc3_.indexOf("prefab") != -1)
         {
            this.onDropPrefab(param1);
            return;
         }
         var _loc4_:Point = Collection(param1.target).dropPoint;
         this._mc.focusObject = this._creator.model.objectAtPoint(_loc4_);
         if(this._mc.focusObject == null && this._ui.stage.mouseX > 90)
         {
            this.notice("You can only drop these onto objects you\'ve created with the drawing tool!");
            return;
         }
         this._mc.history.record();
         switch(_loc3_)
         {
            case CreatorUIStates.MODIFIER_MOTOR:
            case CreatorUIStates.MODIFIER_PUSHER:
            case CreatorUIStates.MODIFIER_ROTATOR:
            case CreatorUIStates.MODIFIER_MOVER:
            case CreatorUIStates.MODIFIER_SLIDER:
            case CreatorUIStates.MODIFIER_JUMPER:
            case CreatorUIStates.MODIFIER_THRUSTER:
            case CreatorUIStates.MODIFIER_PROPELLER:
            case CreatorUIStates.MODIFIER_LAUNCHER:
            case CreatorUIStates.MODIFIER_SELECTOR:
            case CreatorUIStates.MODIFIER_AIMER:
            case CreatorUIStates.MODIFIER_DRAGGER:
            case CreatorUIStates.MODIFIER_POINTER:
            case CreatorUIStates.MODIFIER_ADDER:
            case CreatorUIStates.MODIFIER_SPAWNER:
            case CreatorUIStates.MODIFIER_GROOVEJOINT:
            case CreatorUIStates.MODIFIER_ELEVATOR:
            case CreatorUIStates.MODIFIER_SWITCHER:
            case CreatorUIStates.MODIFIER_CLICKER:
            case CreatorUIStates.MODIFIER_ARCADEMOVER:
               if(this._mc.focusObject)
               {
                  if(this._mc.selection.length <= 1)
                  {
                     this._mc.createNewModifier(_loc3_,this._mc.focusObject);
                  }
                  else
                  {
                     this.confirm(this._creator.modelController,this._mc.addModifiersParentOnly,[_loc3_],"Do you really want to add this to " + this._mc.selection.length + " objects?");
                  }
               }
               break;
            case CreatorUIStates.MODIFIER_PINJOINT:
            case CreatorUIStates.MODIFIER_DAMPEDSPRING:
            case CreatorUIStates.MODIFIER_LOOSESPRING:
            case CreatorUIStates.MODIFIER_GEARJOINT:
               if(this._mc.focusObject)
               {
                  if(this._mc.selection.length <= 2)
                  {
                     this._mc.createNewModifier(_loc3_,this._mc.focusObject);
                  }
                  else
                  {
                     this.confirm(this._creator.modelController,this._mc.addModifiersParentChildStep,[_loc3_],"Do you really want to add this to " + this._mc.selection.length + " objects?");
                  }
               }
               break;
            case CreatorUIStates.MODIFIER_CONNECTOR:
               if(this._mc.focusObject)
               {
                  if(this._mc.selection.length == 2)
                  {
                     this._mc.createNewModifier(_loc3_,this._mc.focusObject,this._mc.focusObject == this._mc.selection.objects[0] ? this._mc.selection.objects[1] : this._mc.selection.objects[0]);
                  }
                  else
                  {
                     this.notice("You must select exactly 2 objects to connect, then drag the connector onto the parent object.");
                  }
               }
               break;
            case CreatorUIStates.MODIFIER_FACTORY:
               if(Boolean(this._mc.focusObject) && Boolean(this._mc.focusObject.group))
               {
                  this._mc.createNewModifier(_loc3_,this._mc.focusObject);
               }
               else if(this._mc.focusObject && this._mc.selection.length > 1 && !this._mc.selection.selectionContainsGroup())
               {
                  this._mc.groupSelectedObjects();
                  this._mc.createNewModifier(_loc3_,this._mc.focusObject);
               }
               else
               {
                  this.notice("You can only add factory modifiers to grouped objects or a selection of multiple objects");
               }
               break;
            case CreatorUIStates.MODIFIER_UNLOCKER:
               if(this._mc.focusObject)
               {
                  if(this._mc.selection.length <= 1)
                  {
                     this._mc.createNewModifier(_loc3_,this._mc.focusObject);
                     if(this._mc.focusObject.props.sensor_group == 0)
                     {
                        this.notice("Don\'t forget to select at least one sensor layer for this object and any trigger objects.");
                     }
                  }
                  else
                  {
                     this.confirm(this._creator.modelController,this._mc.addModifiersParentChildSpoke,[_loc3_],"Do you really want to add this to " + this._mc.selection.length + " objects?");
                  }
               }
               break;
            case CreatorUIStates.MODIFIER_EMAGNET:
               if(this._mc.focusObject)
               {
                  if(this._mc.focusObject.props.material != CreatorUIStates.MATERIAL_MAGNET)
                  {
                     this._mc.createNewModifier(_loc3_,this._mc.focusObject);
                  }
                  else
                  {
                     this.notice("You can\'t add an electromagnet widget to a permanent magnet. Try another material!");
                  }
               }
         }
         CreatorUI.stage.focus = Component.mainStage;
      }
      
      protected function onDropPrefab(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Point = null;
         var _loc5_:String = null;
         if(this._ui.stage.mouseX > 90)
         {
            this._mc.history.record();
            _loc3_ = Collection(param1.target).selectedMembers[0].value;
            _loc4_ = Collection(param1.target).dropPoint;
            this._mc.focusObject = this._creator.model.objectAtPoint(_loc4_);
            if(this._mc.focusObject != null)
            {
               this.notice("You probably don\'t want to drag prefabs onto existing objects, since that will make a mess! Try dragging onto an empty area of the canvas!");
               return;
            }
            switch(_loc3_)
            {
               case CreatorUIStates.PREFAB_BADDIE:
                  this.paste(true,CreatorUIStates.PREFAB_BADDIE_DATA);
                  break;
               case CreatorUIStates.PREFAB_BALLOON:
                  this.paste(true,CreatorUIStates.PREFAB_BALLOON_DATA);
                  break;
               case CreatorUIStates.PREFAB_CAR:
                  this.paste(true,CreatorUIStates.PREFAB_CAR_DATA);
                  break;
               case CreatorUIStates.PREFAB_COIN:
                  this.paste(true,CreatorUIStates.PREFAB_COIN_DATA);
                  break;
               case CreatorUIStates.PREFAB_EXTRALIFE:
                  this.paste(true,CreatorUIStates.PREFAB_EXTRALIFE_DATA);
                  break;
               case CreatorUIStates.PREFAB_KEYDOOR:
                  this.paste(true,CreatorUIStates.PREFAB_KEYDOOR_DATA);
                  break;
               case CreatorUIStates.PREFAB_PLATFORM:
                  this.paste(true,CreatorUIStates.PREFAB_PLATFORM_DATA);
                  break;
               case CreatorUIStates.PREFAB_PLAYER:
                  this.paste(true,CreatorUIStates.PREFAB_PLAYER_DATA);
                  break;
               case CreatorUIStates.PREFAB_ROBOT:
                  this.paste(true,CreatorUIStates.PREFAB_ROBOT_DATA);
                  break;
               case CreatorUIStates.PREFAB_SHIP:
                  this.paste(true,CreatorUIStates.PREFAB_SHIP_DATA);
                  break;
               case CreatorUIStates.PREFAB_SPIKES:
                  this.paste(true,CreatorUIStates.PREFAB_SPIKES_DATA);
                  break;
               case CreatorUIStates.PREFAB_TURRET:
                  this.paste(true,CreatorUIStates.PREFAB_TURRET_DATA);
            }
            if(this._currentToolState == CreatorUIStates.TOOL_DRAW)
            {
               this._ui.tools.activateTab(null,this._ui.tools.tabs[CreatorUIStates.TOOL_SELECT]);
            }
            if(this._currentToolState != CreatorUIStates.TOOL_PAINT && this._currentToolState != CreatorUIStates.TOOL_PICK)
            {
               _loc5_ = "You just added a ready-made object!  To see what it will look like in the game, choose the <font color=\"#FFFFFF\">paint</font> or <font color=\"#FFFFFF\">pick</font> tool.";
               if(!this._prefabAppearanceNoticeSent)
               {
                  this.notice(_loc5_);
                  this._prefabAppearanceNoticeSent = true;
               }
               else
               {
                  Prompt.prompt(_loc5_);
               }
            }
         }
         CreatorUI.stage.focus = Component.mainStage;
      }
      
      protected function updateSubToolsDisplay() : void
      {
         var _loc2_:ModelObject = null;
         this._ui.moveGroup.disable();
         this._ui.moveLock.disable();
         this._ui.shapes.disable();
         this._ui.constraints.disable();
         this._ui.materials.disable();
         this._ui.strengths.disable();
         this._ui.moveLock.disable();
         this._ui.layersButton.disable();
         this._ui.layersMenu.hide();
         this._ui.moveGroup.disable();
         this._ui.delSelection.disable();
         this._ui.editProps.hide();
         this._ui.drawProps.hide();
         this._ui.paintProps.hide();
         this._ui.gameProps.hide();
         this._ui.actionsButton.disable();
         this._ui.animationToggle.disable();
         this._ui.advancedTextureToggle.disable();
         this._creator.model.background.visible = false;
         this._creator.model.backgroundEffect.visible = false;
         var _loc1_:int = int(this._mc.selection.length);
         if(this._mc.selection.length > 0)
         {
            _loc2_ = this._mc.selection.objects[0];
         }
         switch(this._currentToolState)
         {
            case CreatorUIStates.TOOL_DRAW:
               this._ui.drawProps.show();
               this._ui.gameProps.hide();
               this._ui.shapes.enable();
               this._ui.constraints.enable();
               this._ui.materials.enable();
               this._ui.strengths.enable();
               if(this._ui.moveLock.toggled)
               {
                  this._ui.moveLock.enable();
                  this._ui.moveLock.toggle();
                  this._ui.moveLock.disable();
               }
               if(this._ui.moveGroup.toggled)
               {
                  this._ui.moveGroup.enable();
                  this._ui.moveGroup.toggle();
                  this._ui.moveGroup.disable();
               }
               this._creator.model.setViewMode(ModelObjectSprite.VIEW_CONSTRUCT);
               Prompt.prompt("Click and drag on the game area to draw new objects.");
               break;
            case CreatorUIStates.TOOL_SELECT:
               Prompt.prompt("Click or drag objects or modifiers to edit them.");
            case CreatorUIStates.TOOL_WINDOW:
               if(_loc1_ > 0)
               {
                  this._ui.drawProps.show();
                  this._ui.gameProps.hide();
                  this._ui.editProps.show();
                  if(_loc2_ && _loc2_.props && _loc2_.props.constraint == CreatorUIStates.MOVEMENT_STATIC)
                  {
                     this._ui.moveLock.disable();
                  }
                  else
                  {
                     this._ui.moveLock.enable();
                  }
                  this._ui.constraints.enable();
                  this._ui.materials.enable();
                  this._ui.strengths.enable();
                  this._ui.layersButton.enable();
                  this._ui.actionsButton.enable();
                  if(_loc1_ > 1)
                  {
                     this._ui.moveGroup.enable();
                  }
                  this.updateAttribsDisplay();
               }
               else
               {
                  this._ui.drawProps.hide();
                  this._ui.gameProps.show();
               }
               if(_loc1_ > 0)
               {
                  Prompt.prompt("Drag objects to move them, press CTRL-C to copy, CTRL-V to paste objects.");
               }
               else if(this._currentToolState != CreatorUIStates.TOOL_SELECT)
               {
                  Prompt.prompt("Drag a window along the game background to select multiple objects.");
               }
               this._creator.model.setViewMode(ModelObjectSprite.VIEW_CONSTRUCT);
               break;
            case CreatorUIStates.TOOL_PAINT:
            case CreatorUIStates.TOOL_PICK:
               this._ui.paintProps.show();
               this._creator.model.background.visible = true;
               this._creator.model.backgroundEffect.visible = true;
               this._creator.model.setViewMode(ModelObjectSprite.VIEW_DECORATE);
               if(_loc1_ == 1 && _loc2_.props.graphic > 0)
               {
                  if(_loc2_.props.shape != CreatorUIStates.SHAPE_POLY && _loc2_.props.shape != CreatorUIStates.SHAPE_RAMP)
                  {
                     this._ui.animationToggle.enable();
                  }
               }
               if(_loc1_ > 0)
               {
                  this._ui.advancedTextureToggle.enable();
               }
               if(_loc1_ == 1 && this._currentToolState == CreatorUIStates.TOOL_PAINT)
               {
                  this._ui.zlayers.select(_loc2_.props.zlayer - 1);
               }
               if(this._currentToolState == CreatorUIStates.TOOL_PAINT)
               {
                  Prompt.prompt("Select objects and use the menus to change the color, line, texture and layer. Double-click to apply current colors.");
               }
               else
               {
                  Prompt.prompt("Click on an object to copy its color, line, texture and layer.");
               }
         }
      }
      
      protected function updateAttribsDisplay() : void
      {
         var _loc2_:ModelObject = null;
         var _loc3_:Boolean = false;
         var _loc1_:int = int(this._mc.selection.length);
         if(this._mc.selection.length > 0)
         {
            _loc2_ = this._mc.selection.objects[0];
         }
         if(_loc2_)
         {
            if(_loc1_ == 1)
            {
               this._ui.shapes.value = _loc2_.props.shape;
               this._ui.constraints.value = _loc2_.props.constraint;
               this._ui.materials.value = _loc2_.props.material;
               this._ui.strengths.value = _loc2_.props.strength;
            }
            if(_loc1_ == 1)
            {
               this._ui.moveLock.toggled = _loc2_.props.locked;
            }
            else
            {
               _loc3_ = true;
               while(_loc1_--)
               {
                  if(this._mc.selection.objects[_loc1_].props.locked == false)
                  {
                     _loc3_ = false;
                     break;
                  }
               }
               this._ui.moveLock.toggled = _loc3_;
            }
            this._ui.moveGroup.toggled = this._mc.selection.selectionIsSingleGroup();
            this._ui.delSelection.enable();
            this.updateLayersDisplay();
         }
         else
         {
            this._ui.moveLock.toggled = this._ui.moveGroup.toggled = false;
            this._ui.delSelection.disable();
         }
      }
      
      protected function updateLayersDisplay() : void
      {
         var _loc3_:ModelObject = null;
         var _loc4_:int = 0;
         var _loc5_:ToggleButton = null;
         var _loc6_:ClipButton = null;
         var _loc1_:ModelSelection = this._mc.selection;
         var _loc2_:int = int(_loc1_.length);
         if(_loc2_ > 0)
         {
            _loc3_ = _loc1_.objects[0];
         }
         if(_loc2_ == 1 && Boolean(_loc3_))
         {
            _loc4_ = 0;
            while(_loc4_ < 5)
            {
               _loc5_ = ToggleButton(this._ui.layers["c_" + _loc4_]);
               if(this._mc.getLayerState(_loc3_,_loc4_,ModelObjectProperties.LAYER_COLLISION) != _loc5_.toggled)
               {
                  _loc5_.toggle();
               }
               _loc5_ = ToggleButton(this._ui.layers["p_" + _loc4_]);
               if(this._mc.getLayerState(_loc3_,_loc4_,ModelObjectProperties.LAYER_PASSTHRU) != _loc5_.toggled)
               {
                  _loc5_.toggle();
               }
               _loc6_ = ClipButton(this._ui.layers["s_" + _loc4_]);
               if(this._mc.getLayerState(_loc3_,_loc4_,ModelObjectProperties.LAYER_SENSOR) != _loc6_.toggled)
               {
                  _loc6_.toggle();
               }
               _loc4_++;
            }
         }
      }
      
      public function updateAnimationDisplay() : void
      {
         var _loc3_:ModelObject = null;
         var _loc1_:ModelSelection = this._mc.selection;
         var _loc2_:int = int(_loc1_.length);
         if(_loc2_ > 0)
         {
            _loc3_ = _loc1_.objects[0];
         }
         if(_loc3_.props.animation == 0)
         {
            this._ui.animWalk.disable();
         }
         else
         {
            this._ui.animWalk.enable();
         }
         if(_loc3_.props.graphic_flip == 0 && _loc3_.props.animation <= 1)
         {
            this._ui.animNormal.checked = true;
         }
         else if(_loc3_.props.graphic_flip == 1 && _loc3_.props.animation <= 1)
         {
            this._ui.animFlip.checked = true;
         }
         else if(_loc3_.props.animation == 2)
         {
            this._ui.animWalk.checked = true;
         }
         else if(_loc3_.props.animation == 3)
         {
            this._ui.animRotate.checked = true;
         }
         else if(_loc3_.props.animation == 4)
         {
            this._ui.animRotateWalk.checked = true;
         }
      }
      
      public function updateLayerViewDisplay() : void
      {
         var _loc1_:int = 0;
         var _loc4_:ClipButton = null;
         var _loc5_:Boolean = false;
         var _loc6_:ModelObject = null;
         var _loc2_:ModelSelection = this._mc.selection;
         var _loc3_:Array = this._ui.ddLayerSelectionIndicators;
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            _loc4_ = this._ui.layerViewButtons[_loc1_];
            _loc5_ = this._creator.model.getLayerView(_loc1_);
            if(_loc5_ != _loc4_.toggled)
            {
               _loc4_.toggle();
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            _loc3_[_loc1_].visible = false;
            _loc1_++;
         }
         _loc1_ = int(_loc2_.length);
         while(_loc1_--)
         {
            _loc6_ = _loc2_.objects[_loc1_];
            if(_loc6_ != null && _loc6_.props != null && _loc6_.props.zlayer <= 5)
            {
               if(_loc3_[_loc6_.props.zlayer - 1] != null)
               {
                  _loc3_[_loc6_.props.zlayer - 1].visible = true;
               }
            }
         }
      }
      
      public function getLayersState() : Array
      {
         var _loc4_:int = 0;
         var _loc5_:ToggleButton = null;
         var _loc6_:ClipButton = null;
         var _loc1_:String = "";
         var _loc2_:int = -1;
         var _loc3_:String = "";
         _loc4_ = 0;
         while(_loc4_ < 5)
         {
            _loc5_ = ToggleButton(this._ui.layers["c_" + _loc4_]);
            _loc1_ += _loc5_.toggled ? "1" : "0";
            _loc5_ = ToggleButton(this._ui.layers["p_" + _loc4_]);
            _loc2_ = _loc5_.toggled ? _loc4_ : _loc2_;
            _loc6_ = ClipButton(this._ui.layers["s_" + _loc4_]);
            _loc3_ += _loc6_.toggled ? "1" : "0";
            _loc4_++;
         }
         return [_loc1_,_loc2_.toString(10),_loc3_];
      }
      
      public function getPaintState() : void
      {
         var _loc1_:ModelController = this._creator.modelController;
         var _loc2_:int = _loc1_.paintFillColor;
         var _loc3_:int = _loc1_.paintLineColor;
         var _loc4_:int = _loc1_.paintTexture;
         var _loc5_:int = _loc1_.paintLayer;
         var _loc6_:int = _loc1_.paintOpaque;
         var _loc7_:int = _loc1_.paintScribble;
         this._ui.fills.value = _loc2_ >= 0 ? _loc2_.toString() : CreatorUIStates.NONE;
         this._ui.lines.value = _loc3_ >= 0 ? _loc3_.toString() : (_loc3_ >= -1 ? CreatorUIStates.NONE : CreatorUIStates.GLOW);
         this._ui.textures.value = CreatorUIStates.textures[_loc4_];
         this._ui.zlayers.value = "icon_layer_" + _loc5_;
         if(this._ui.opaque.toggled != (_loc6_ == 0))
         {
            this._ui.opaque.toggle();
         }
         if(this._ui.scribble.toggled != (_loc7_ == 1))
         {
            this._ui.scribble.toggle();
         }
      }
   }
}

