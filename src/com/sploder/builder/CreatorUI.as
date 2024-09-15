package com.sploder.builder
{
   import com.sploder.asui.BButton;
   import com.sploder.asui.Cell;
   import com.sploder.asui.ClipButton;
   import com.sploder.asui.ClipChooser;
   import com.sploder.asui.Collection;
   import com.sploder.asui.CollectionItem;
   import com.sploder.asui.ColorClipChooser;
   import com.sploder.asui.ComboBox;
   import com.sploder.asui.Component;
   import com.sploder.asui.Create;
   import com.sploder.asui.Divider;
   import com.sploder.asui.DrawingMethods;
   import com.sploder.asui.HTMLField;
   import com.sploder.asui.Library;
   import com.sploder.asui.Position;
   import com.sploder.asui.Prompt;
   import com.sploder.asui.RadioButton;
   import com.sploder.asui.ScrollBar;
   import com.sploder.asui.Style;
   import com.sploder.asui.TabGroup;
   import com.sploder.asui.Tagtip;
   import com.sploder.asui.ToggleButton;
   import com.sploder.asui.VisualGrid;
   import com.sploder.builder.model.ModelObjectSprite;
   import com.sploder.builder.model.ModifierSprite;
   import com.sploder.builder.ui.DialogueActionMatrix;
   import com.sploder.builder.ui.DialogueAlert;
   import com.sploder.builder.ui.DialogueBackground;
   import com.sploder.builder.ui.DialogueClipboard;
   import com.sploder.builder.ui.DialogueConfirm;
   import com.sploder.builder.ui.DialogueEmbed;
   import com.sploder.builder.ui.DialogueEnvironment;
   import com.sploder.builder.ui.DialogueFileManager;
   import com.sploder.builder.ui.DialogueGoals;
   import com.sploder.builder.ui.DialogueMusicManager;
   import com.sploder.builder.ui.DialoguePublish;
   import com.sploder.builder.ui.DialoguePublishComplete;
   import com.sploder.builder.ui.DialogueServer;
   import com.sploder.builder.ui.DialogueTextureGen;
   import com.sploder.builder.ui.DialogueWelcome;
   import com.sploder.builder.ui.ModifierPropertiesEditor;
   import com.sploder.builder.ui.Notice;
   import com.sploder.builder.ui.PanelGraphics;
   import com.sploder.game.library.EmbeddedLibrary;
   import com.sploder.texturegen_internal.TextureRendering;
   import com.sploder.texturegen_internal.util.ThreadedQueue;
   import flash.display.BlendMode;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   
   public class CreatorUI extends Sprite
   {
      public static var stage:Stage;
      
      public static var fontLibrary:Library;
      
      public static var library:EmbeddedLibrary;
      
      protected var _creator:Creator;
      
      protected var FontLibrarySWF:Class;
      
      protected var LibrarySWF:Class;
      
      public var playfieldContainer:Cell;
      
      public var playfield:Cell;
      
      protected var _ui:Cell;
      
      public var menu:Cell;
      
      public var tools:TabGroup;
      
      protected var _subtools:Cell;
      
      public var gameProps:Cell;
      
      public var drawProps:Cell;
      
      public var paintProps:Cell;
      
      public var editProps:Cell;
      
      protected var menuButtonTitles:Array;
      
      protected var menuButtonPrompts:Array;
      
      public var vScroll:ScrollBar;
      
      public var hScroll:ScrollBar;
      
      public var zoomToggle:ClipButton;
      
      public var defaultLayer:int = 2;
      
      public var menuItems:Object;
      
      protected var _levelSelector:ComboBox;
      
      protected var _addLevelButton:BButton;
      
      protected var _removeLevelButton:BButton;
      
      protected var _moveLevelButton:BButton;
      
      protected var _tray:Cell;
      
      public var trayButtons:TabGroup;
      
      protected var _trayButtonTitles:Array;
      
      public var trays:Object;
      
      public var currentTray:Collection;
      
      protected var _trayObjectsPrefabs:Array;
      
      protected var _trayObjectsPrefabsAlts:Array;
      
      protected var _trayObjectsPhysics:Array;
      
      protected var _trayObjectsPhysicsAlts:Array;
      
      protected var _trayObjectsControls:Array;
      
      protected var _trayObjectsControlsAlts:Array;
      
      protected var _trayObjectsWidgets:Array;
      
      protected var _trayObjectsWidgetsAlts:Array;
      
      protected var _toolIconSymbols:Array;
      
      protected var _toolIconAlts:Array;
      
      public var shapes:ClipChooser;
      
      protected var _iconsShapes:Array;
      
      protected var _iconsShapesAlt:String;
      
      protected var _iconsShapesAlts:Array;
      
      public var constraints:ClipChooser;
      
      protected var _iconsConstraints:Array;
      
      protected var _iconsConstraintsAlt:String;
      
      protected var _iconsConstraintsAlts:Array;
      
      public var materials:ClipChooser;
      
      protected var _iconsMaterials:Array;
      
      protected var _iconsMaterialsAlt:String;
      
      protected var _iconsMaterialsAlts:Array;
      
      public var strengths:ClipChooser;
      
      protected var _iconsStrengths:Array;
      
      protected var _iconsStrengthsAlt:String;
      
      protected var _iconsStrengthsAlts:Array;
      
      public var moveLock:ClipButton;
      
      protected var _moveLockAlt:String;
      
      protected var _moveLockAltToggled:String;
      
      public var layersButton:ClipButton;
      
      protected var _layersButtonAlt:String;
      
      public var actionsButton:ClipButton;
      
      protected var _actionsButtonAlt:String;
      
      public var layers:Object;
      
      public var layersMenu:Cell;
      
      public var layersButtons:Cell;
      
      protected var _layersSensorSymbols:Array;
      
      public var ddLayerView:Cell;
      
      public var layerViewToggle:ClipButton;
      
      public var layerViewButtons:Array;
      
      public var layerDefaultButtons:TabGroup;
      
      public var ddLayerSelectionIndicators:Array;
      
      public var moveGroup:ClipButton;
      
      protected var _moveGroupAlt:String;
      
      protected var _moveGroupAltToggled:String;
      
      public var delSelection:ClipButton;
      
      public var _delSelectionAlt:String;
      
      public var testMask:Sprite;
      
      private var _testEndButtonContainer:Cell;
      
      private var _testEndButton:BButton;
      
      public var modifierPropertiesEditor:ModifierPropertiesEditor;
      
      public var world:BButton;
      
      public var bkgd:BButton;
      
      public var goals:BButton;
      
      public var music:BButton;
      
      public var clipboard:BButton;
      
      public var fills:ClipChooser;
      
      public var lines:ClipChooser;
      
      public var zlayers:ClipChooser;
      
      public var textures:ClipChooser;
      
      protected var _iconsTextures:Array;
      
      protected var _iconsTexturesAlt:String;
      
      public var ddEnvironment:DialogueEnvironment;
      
      public var ddBackground:DialogueBackground;
      
      public var ddConfirm:DialogueConfirm;
      
      public var ddAlert:DialogueAlert;
      
      public var notice:Notice;
      
      public var ddManager:DialogueFileManager;
      
      public var ddMusic:DialogueMusicManager;
      
      public var ddGraphics:PanelGraphics;
      
      public var ddTextureGen:DialogueTextureGen;
      
      public var opaque:ClipButton;
      
      public var scribble:ClipButton;
      
      public var graphicsPanelToggle:ClipButton;
      
      public var animationToggle:ClipButton;
      
      public var advancedTextureToggle:ClipButton;
      
      public var ddAnimation:Cell;
      
      public var animNormal:RadioButton;
      
      public var animFlip:RadioButton;
      
      public var animWalk:RadioButton;
      
      public var animRotate:RadioButton;
      
      public var animRotateWalk:RadioButton;
      
      public var ddClipboard:DialogueClipboard;
      
      public var ddActionMatrix:DialogueActionMatrix;
      
      public var ddPublish:DialoguePublish;
      
      public var ddPublishComplete:DialoguePublishComplete;
      
      public var ddEmbed:DialogueEmbed;
      
      public var ddServer:DialogueServer;
      
      public var ddGoals:DialogueGoals;
      
      public var trayPager:ToggleButton;
      
      public var prompt:Prompt;
      
      public var ddWelcome:DialogueWelcome;
      
      public var sensorLayersTitle:HTMLField;
      
      public var undoButton:SimpleButton;
      
      public var redoButton:SimpleButton;
      
      public var helpButton:SimpleButton;
      
      public function CreatorUI(param1:Creator)
      {
         this.FontLibrarySWF = CreatorUI_FontLibrarySWF;
         this.LibrarySWF = CreatorUI_LibrarySWF;
         super();
         this.init(param1);
      }
      
      public function get levelSelector() : ComboBox
      {
         return this._levelSelector;
      }
      
      public function get addLevelButton() : BButton
      {
         return this._addLevelButton;
      }
      
      public function get removeLevelButton() : BButton
      {
         return this._removeLevelButton;
      }
      
      public function get moveLevelButton() : BButton
      {
         return this._moveLevelButton;
      }
      
      public function get uiContainer() : Cell
      {
         return this._ui;
      }
      
      public function get testEndButtonContainer() : Cell
      {
         return this._testEndButtonContainer;
      }
      
      public function get testEndButton() : BButton
      {
         return this._testEndButton;
      }
      
      protected function init(param1:Creator) : void
      {
         this._creator = param1;
         CreatorUI.stage = this._creator.stage;
         this.menuButtonTitles = ["New","Load","Save","Save As","Test","Publish"];
         this.menuButtonPrompts = ["Click to start making a new game project.","Click to load a game project.","Click to save your game project. This will not publish or share your game.","Click to save your game as a different game project.","Click to test your game level in the creator","Click to publish your game to share it with others"];
         this._toolIconSymbols = [CreatorUIStates.TOOL_DRAW,CreatorUIStates.TOOL_SELECT,CreatorUIStates.TOOL_WINDOW,CreatorUIStates.TOOL_PAINT,CreatorUIStates.TOOL_PICK];
         this._toolIconAlts = ["Draw a new object","Select and edit a single object, or edit physics, controls and widgets","Select multiple objects, and hide physics, controls and widgets","View and change the appearance of objects","Pick appearance attributes from objects for copying with the paint tool"];
         this._iconsShapes = [CreatorUIStates.SHAPE_CIRCLE,CreatorUIStates.SHAPE_SQUARE,CreatorUIStates.SHAPE_BOX,CreatorUIStates.SHAPE_RAMP,CreatorUIStates.SHAPE_PENT,CreatorUIStates.SHAPE_HEX,CreatorUIStates.SHAPE_POLY];
         this._iconsShapesAlt = "Choose a type of shape to create or draw";
         this._iconsShapesAlts = ["Simple circular object with variable radius","Square object, same width and height","Rectangular object, variable width and/or height","Ramp shape (right triangle), variable width and/or height","Pentagon, variable size","Hexagon, variable size","Polygon that can be drawn and vertices tweaked"];
         this._iconsConstraints = [CreatorUIStates.MOVEMENT_FREE,CreatorUIStates.MOVEMENT_PIN,CreatorUIStates.MOVEMENT_SLIDE,CreatorUIStates.MOVEMENT_STATIC];
         this._iconsConstraintsAlt = "Choose how to constrain the physical motion of this object";
         this._iconsConstraintsAlts = ["Object moves and rotates naturally with no constraints","Object rotates but does not move, like it is pinned to the background","Object moves but does not rotate, as if it is sliding","Object does not move or rotate, ever"];
         this._iconsMaterials = [CreatorUIStates.MATERIAL_WOOD,CreatorUIStates.MATERIAL_STEEL,CreatorUIStates.MATERIAL_ICE,CreatorUIStates.MATERIAL_RUBBER,CreatorUIStates.MATERIAL_GLASS,CreatorUIStates.MATERIAL_TIRE,CreatorUIStates.MATERIAL_AIR_BALLOON,CreatorUIStates.MATERIAL_HELIUM_BALLOON,CreatorUIStates.MATERIAL_MAGNET,CreatorUIStates.MATERIAL_SUPERBALL];
         this._iconsMaterialsAlt = "Choose the materials physical properties for friction, bounce and density";
         this._iconsMaterialsAlts = ["Wood-like material with average friction, bounce and very low density","Steel-like material with average friction, bounce and very high density","Ice-like material with very low friction, low bounce and density","Rubber-like material with high friction, bounce, and high density","Glass-like material with low friction, bounce, and average density","Tire-like material with very high friction, high bounce and low density","Magic material with very low friction and no gravity effect","Magic material with very low friction and negative gravity effect","Permanent magnetic material with average friction and high density. Other steel objects stick to this","Super-bouncy material that launches objects away when touched"];
         this._iconsStrengths = [CreatorUIStates.STRENGTH_PERM,CreatorUIStates.STRENGTH_STRONG,CreatorUIStates.STRENGTH_MEDIUM,CreatorUIStates.STRENGTH_WEAK];
         this._iconsStrengthsAlt = "Choose how the object reacts to crushing forces";
         this._iconsStrengthsAlts = ["Object is not affected by curshing forces","Object is barely affected by crushing forces","Object can be crushed by average forces","Object is brittle, and can be crushed easily"];
         this._moveLockAlt = "Click to lock movement on this object";
         this._moveLockAltToggled = "Click to unlock movement on this object";
         this._layersButtonAlt = "Click to change collision and/or sensor layers";
         this._actionsButtonAlt = "Click to add actions to events that happen to this object";
         this._layersSensorSymbols = [CreatorUIStates.SUIT_CLUB,CreatorUIStates.SUIT_DIAMOND,CreatorUIStates.SUIT_HEART,CreatorUIStates.SUIT_SPADE,CreatorUIStates.SUIT_MON];
         this._moveGroupAlt = "Click to group objects together for convenient editing";
         this._moveGroupAltToggled = "Click to ungroup objects";
         this._delSelectionAlt = "Delete selected objects";
         this._iconsTextures = CreatorUIStates.textures_iconmap.concat();
         this._iconsTexturesAlt = "Click to change the texture of selected objects";
         this._trayButtonTitles = [{
            "text":CreatorUIStates.TRAY_PREFABS,
            "icon":Create.ICON_ARROW_LEFT,
            "first":"false",
            "iconToggled":Create.ICON_ARROW_DOWN
         },{
            "text":CreatorUIStates.TRAY_PHYSICS,
            "icon":Create.ICON_ARROW_LEFT,
            "first":"false",
            "iconToggled":Create.ICON_ARROW_DOWN
         },{
            "text":CreatorUIStates.TRAY_CONTROLS,
            "icon":Create.ICON_ARROW_LEFT,
            "first":"false",
            "iconToggled":Create.ICON_ARROW_DOWN
         },{
            "text":CreatorUIStates.TRAY_WIDGETS,
            "icon":Create.ICON_ARROW_LEFT,
            "first":"false",
            "iconToggled":Create.ICON_ARROW_DOWN
         }];
         this._trayObjectsPrefabs = [{
            "title":CreatorUIStates.TITLE_PLAYER,
            "icon":CreatorUIStates.TRAY_PREFAB_PLAYER,
            "value":CreatorUIStates.PREFAB_PLAYER
         },{
            "title":CreatorUIStates.TITLE_BADDIE,
            "icon":CreatorUIStates.TRAY_PREFAB_BADDIE,
            "value":CreatorUIStates.PREFAB_BADDIE
         },{
            "title":CreatorUIStates.TITLE_PLATFORM,
            "icon":CreatorUIStates.TRAY_PREFAB_PLATFORM,
            "value":CreatorUIStates.PREFAB_PLATFORM
         },{
            "title":CreatorUIStates.TITLE_COIN,
            "icon":CreatorUIStates.TRAY_PREFAB_COIN,
            "value":CreatorUIStates.PREFAB_COIN
         },{
            "title":CreatorUIStates.TITLE_SPIKES,
            "icon":CreatorUIStates.TRAY_PREFAB_SPIKES,
            "value":CreatorUIStates.PREFAB_SPIKES
         },{
            "title":CreatorUIStates.TITLE_EXTRALIFE,
            "icon":CreatorUIStates.TRAY_PREFAB_EXTRALIFE,
            "value":CreatorUIStates.PREFAB_EXTRALIFE
         },{
            "title":CreatorUIStates.TITLE_KEYDOOR,
            "icon":CreatorUIStates.TRAY_PREFAB_KEYDOOR,
            "value":CreatorUIStates.PREFAB_KEYDOOR
         },{
            "title":CreatorUIStates.TITLE_SHIP,
            "icon":CreatorUIStates.TRAY_PREFAB_SHIP,
            "value":CreatorUIStates.PREFAB_SHIP
         },{
            "title":CreatorUIStates.TITLE_TURRET,
            "icon":CreatorUIStates.TRAY_PREFAB_TURRET,
            "value":CreatorUIStates.PREFAB_TURRET
         },{
            "title":CreatorUIStates.TITLE_ROBOT,
            "icon":CreatorUIStates.TRAY_PREFAB_ROBOT,
            "value":CreatorUIStates.PREFAB_ROBOT
         },{
            "title":CreatorUIStates.TITLE_BALLOON,
            "icon":CreatorUIStates.TRAY_PREFAB_BALLOON,
            "value":CreatorUIStates.PREFAB_BALLOON
         },{
            "title":CreatorUIStates.TITLE_CAR,
            "icon":CreatorUIStates.TRAY_PREFAB_CAR,
            "value":CreatorUIStates.PREFAB_CAR
         }];
         this._trayObjectsPrefabsAlts = ["Drag this onto the canvas to create a new ready-made player that can jump and move from side to side","Drag this onto the canvas to create a new ready-made baddie that moves side to side randomly","Drag this onto the canvas to create a new ready-made platform that you can walk on","Drag this onto the canvas to create a new ready-made coin that will add to the score when the player touches it","Drag this onto the canvas to create a new ready-made spikes block that will cause the player to lose a life","Drag this onto the canvas to create a new ready-made extra-life block that will give the player an extra life when it is touched","Drag this onto the canvas to create a new ready-made key and door combo you can use to unlock an area in the game","Drag this onto the canvas to create a new ready-made ship you can use in top-down games without gravity","Drag this onto the canvas to create a new ready-made turret that shoots at your player if you get near it","Drag this onto the canvas to create a new ready-made robot that you can make walk back and forth and shoot","Drag this onto the canvas to create a new ready-made balloon with an electro-magnet that can pick up metal","Drag this onto the canvas to create a new ready-made Turret car that can roll back and forth and shoot"];
         this._trayObjectsPhysics = [{
            "title":CreatorUIStates.TITLE_MOTOR,
            "icon":CreatorUIStates.TRAY_MODIFIER_MOTOR,
            "value":CreatorUIStates.MODIFIER_MOTOR
         },{
            "title":CreatorUIStates.TITLE_PUSHER,
            "icon":CreatorUIStates.TRAY_MODIFIER_PUSHER,
            "value":CreatorUIStates.MODIFIER_PUSHER
         },{
            "title":CreatorUIStates.TITLE_PINJOINT,
            "icon":CreatorUIStates.TRAY_MODIFIER_PINJOINT,
            "value":CreatorUIStates.MODIFIER_PINJOINT
         },{
            "title":CreatorUIStates.TITLE_GROOVEJOINT,
            "icon":CreatorUIStates.TRAY_MODIFIER_GROOVEJOINT,
            "value":CreatorUIStates.MODIFIER_GROOVEJOINT
         },{
            "title":CreatorUIStates.TITLE_DAMPEDSPRING,
            "icon":CreatorUIStates.TRAY_MODIFIER_DAMPEDSPRING,
            "value":CreatorUIStates.MODIFIER_DAMPEDSPRING
         },{
            "title":CreatorUIStates.TITLE_LOOSESPRING,
            "icon":CreatorUIStates.TRAY_MODIFIER_LOOSESPRING,
            "value":CreatorUIStates.MODIFIER_LOOSESPRING
         },{
            "title":CreatorUIStates.TITLE_GEARJOINT,
            "icon":CreatorUIStates.TRAY_MODIFIER_GEARJOINT,
            "value":CreatorUIStates.MODIFIER_GEARJOINT
         }];
         this._trayObjectsPhysicsAlts = ["Drag this onto an object to make it turn at a set speed","Drag this onto an object to make it push objects that collide with it","Drag this onto an object to connect it to a fixed-length joint. You can drag both ends, and if you drag them together you make a special bolt joint that sticks objects together without colliding.","Drag this onto an object to connect it to a groove that it can slide along","Drag this onto an object to connect it to a tight spring","Drag this onto an object to connect it to a loose spring","Drag this onto an object to mirror the rotation of the parent object, as if it were connected by a gear"];
         this._trayObjectsControls = [{
            "title":CreatorUIStates.TITLE_ROTATOR,
            "icon":CreatorUIStates.TRAY_MODIFIER_ROTATOR,
            "value":CreatorUIStates.MODIFIER_ROTATOR
         },{
            "title":CreatorUIStates.TITLE_MOVER,
            "icon":CreatorUIStates.TRAY_MODIFIER_MOVER,
            "value":CreatorUIStates.MODIFIER_MOVER
         },{
            "title":CreatorUIStates.TITLE_SLIDER,
            "icon":CreatorUIStates.TRAY_MODIFIER_SLIDER,
            "value":CreatorUIStates.MODIFIER_SLIDER
         },{
            "title":CreatorUIStates.TITLE_JUMPER,
            "icon":CreatorUIStates.TRAY_MODIFIER_JUMPER,
            "value":CreatorUIStates.MODIFIER_JUMPER
         },{
            "title":CreatorUIStates.TITLE_ARCADEMOVER,
            "icon":CreatorUIStates.TRAY_MODIFIER_ARCADEMOVER,
            "value":CreatorUIStates.MODIFIER_ARCADEMOVER
         },{
            "title":CreatorUIStates.TITLE_SELECTOR,
            "icon":CreatorUIStates.TRAY_MODIFIER_SELECTOR,
            "value":CreatorUIStates.MODIFIER_SELECTOR
         },{
            "title":CreatorUIStates.TITLE_ADDER,
            "icon":CreatorUIStates.TRAY_MODIFIER_ADDER,
            "value":CreatorUIStates.MODIFIER_ADDER
         },{
            "title":CreatorUIStates.TITLE_LAUNCHER,
            "icon":CreatorUIStates.TRAY_MODIFIER_LAUNCHER,
            "value":CreatorUIStates.MODIFIER_LAUNCHER
         },{
            "title":CreatorUIStates.TITLE_AIMER,
            "icon":CreatorUIStates.TRAY_MODIFIER_AIMER,
            "value":CreatorUIStates.MODIFIER_AIMER
         },{
            "title":CreatorUIStates.TITLE_DRAGGER,
            "icon":CreatorUIStates.TRAY_MODIFIER_DRAGGER,
            "value":CreatorUIStates.MODIFIER_DRAGGER
         },{
            "title":CreatorUIStates.TITLE_THRUSTER,
            "icon":CreatorUIStates.TRAY_MODIFIER_THRUSTER,
            "value":CreatorUIStates.MODIFIER_THRUSTER
         },{
            "title":CreatorUIStates.TITLE_CLICKER,
            "icon":CreatorUIStates.TRAY_MODIFIER_CLICKER,
            "value":CreatorUIStates.MODIFIER_CLICKER
         }];
         this._trayObjectsControlsAlts = ["Rotates an object using the keyboard (left and right arrow keys or A and D keys)","Pushes an object with the keyboard (up and down arrow keys or W and S keys)","Pushes an object with the keyboard (left and right arrow keys or A and D keys)","Makes an object appear to jump by pushing it up quickly (up arrow key or W key)","Allows for tighter arcade movement without acceleration using WASD or arrow keys. Platformer mode in playfield with gravity","Allow ONLY ONE object to be controlled at a time by selecting (mouse click)","Adds a copy of the object to the game (spacebar)","Bounces touching objects towards the mouse (mouse click)","Allow an object to be aimed toward the location of the mouse","Allow an object to be dragged with the mouse","Pushes an object with the keyboard in one direction from any location you choose and any key you choose","Triggers the On Sensor event by clicking on the object with the mouse"];
         this._trayObjectsWidgets = [{
            "title":CreatorUIStates.TITLE_ELEVATOR,
            "icon":CreatorUIStates.TRAY_MODIFIER_ELEVATOR,
            "value":CreatorUIStates.MODIFIER_ELEVATOR
         },{
            "title":CreatorUIStates.TITLE_SPAWNER,
            "icon":CreatorUIStates.TRAY_MODIFIER_SPAWNER,
            "value":CreatorUIStates.MODIFIER_SPAWNER
         },{
            "title":CreatorUIStates.TITLE_CONNECTOR,
            "icon":CreatorUIStates.TRAY_MODIFIER_CONNECTOR,
            "value":CreatorUIStates.MODIFIER_CONNECTOR
         },{
            "title":CreatorUIStates.TITLE_FACTORY,
            "icon":CreatorUIStates.TRAY_MODIFIER_FACTORY,
            "value":CreatorUIStates.MODIFIER_FACTORY
         },{
            "title":CreatorUIStates.TITLE_UNLOCKER,
            "icon":CreatorUIStates.TRAY_MODIFIER_UNLOCKER,
            "value":CreatorUIStates.MODIFIER_UNLOCKER
         },{
            "title":CreatorUIStates.TITLE_SWITCHER,
            "icon":CreatorUIStates.TRAY_MODIFIER_SWITCHER,
            "value":CreatorUIStates.MODIFIER_SWITCHER
         },{
            "title":CreatorUIStates.TITLE_EMAGNET,
            "icon":CreatorUIStates.TRAY_MODIFIER_EMAGNET,
            "value":CreatorUIStates.MODIFIER_EMAGNET
         },{
            "title":CreatorUIStates.TITLE_POINTER,
            "icon":CreatorUIStates.TRAY_MODIFIER_POINTER,
            "value":CreatorUIStates.MODIFIER_POINTER
         },{
            "title":CreatorUIStates.TITLE_PROPELLER,
            "icon":CreatorUIStates.TRAY_MODIFIER_PROPELLER,
            "value":CreatorUIStates.MODIFIER_PROPELLER
         }];
         this._trayObjectsWidgetsAlts = ["Moves an object back and forth along a groove joint","Adds a copy of the object to the game at a specified interval","Select 2 objects and drag onto the main object to connect a smaller object. Connected objects do not collide with anything. Good for connecting spawners to moving objects","Drag this onto a set of grouped items to create a Spawner for the whole group (including joints, etc)","Drag this onto an object to make its events also happen to another object. After adding, drag the flag onto a target object, then apply an unlock, remove or explode action to the target.","Drag this onto an object with an elevator or motor to switch the direction randomly","Drag this onto an object to turn it into a magnet, which you can switch on and off with the keyboard (spacebar)","Drag this onto an object to make it always point at whichever object is being controlled with the keyboard or mouse","Drag this onto an object to have it propel in one direction from any location you choose"];
         Prompt.defaultMessage = "Need help? Hold your mouse over a button to find out what it does!";
         this.menuItems = {};
         this.layers = {};
         this.trays = {};
      }
      
      public function start() : void
      {
         this.initializeFontLibrary(this.LibrarySWF);
      }
      
      protected function initializeFontLibrary(param1:Class) : void
      {
         fontLibrary = new Library(this.FontLibrarySWF,true);
         fontLibrary.addEventListener(Event.INIT,this.onFontLibraryInitialized);
      }
      
      protected function onFontLibraryInitialized(param1:Event) : void
      {
         fontLibrary.removeEventListener(Library.INITIALIZED,this.onFontLibraryInitialized);
         Styles.initializeFonts(fontLibrary);
         this.initializeLibrary(this.LibrarySWF);
      }
      
      protected function initializeLibrary(param1:Class) : void
      {
         library = new EmbeddedLibrary(param1);
         library.addEventListener(Event.INIT,this.onLibraryInitialized);
      }
      
      protected function onLibraryInitialized(param1:Event) : void
      {
         library.removeEventListener(Library.INITIALIZED,this.onLibraryInitialized);
         Textures.library = library;
         ModelObjectSprite.library = library;
         ModifierSprite.library = library;
         ModifierSprite.mainStage = stage;
         TextureRendering.mainStage = stage;
         ThreadedQueue.mainStage = stage;
         this.build();
         dispatchEvent(new Event(Event.INIT));
      }
      
      protected function build() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Divider = null;
         var _loc3_:BButton = null;
         var _loc12_:Collection = null;
         var _loc20_:ClipChooser = null;
         var _loc23_:uint = 0;
         var _loc24_:uint = 0;
         var _loc25_:uint = 0;
         var _loc26_:uint = 0;
         var _loc33_:ToggleButton = null;
         var _loc34_:int = 0;
         var _loc35_:HTMLField = null;
         var _loc36_:ClipButton = null;
         var _loc38_:BButton = null;
         var _loc39_:ClipButton = null;
         var _loc40_:Shape = null;
         var _loc47_:String = null;
         Styles.initialize();
         Component.library = library;
         Tagtip.initialize(stage);
         graphics.clear();
         graphics.beginFill(13158);
         graphics.drawRect(136,90,724,480);
         graphics.endFill();
         this.playfieldContainer = new Cell(this,640,480,false,false,0,Styles.absPosition,Styles.playfieldStyle);
         this.playfieldContainer.x = 180;
         this.playfieldContainer.y = 90;
         this.playfield = new Cell(null,640,480,true,false,0,Styles.absPosition,Styles.playfieldStyle);
         this.playfield.fixedContentSize = true;
         this.playfieldContainer.addChild(this.playfield);
         this.playfield.addChild(new VisualGrid(null,1280,960));
         this.prompt = new Prompt();
         this.prompt.style = Styles.promptStyle;
         this.prompt.tween = false;
         this.prompt.promptWidth = 860;
         this.prompt.promptHeight = 30;
         this.prompt.promptTopMargin = 7;
         this.prompt.x = 0;
         this.prompt.y = 570;
         addChild(this.prompt);
         this._ui = new Cell(this,860,600);
         this.menu = new Cell(null,860,41,true,false,0,new Position({"zindex":100}),Styles.menuStyle);
         this._ui.addChild(this.menu);
         _loc1_ = 0;
         while(_loc1_ < this.menuButtonTitles.length)
         {
            _loc3_ = new BButton(null,this.menuButtonTitles[_loc1_],-1,NaN,41,false,false,false,Styles.floatPosition,Styles.menuStyle);
            _loc47_ = "";
            if(this.menuButtonTitles[_loc1_] is String)
            {
               _loc47_ = this.menuButtonTitles[_loc1_].split(" ").join("").toLowerCase();
            }
            else
            {
               _loc47_ = this.menuButtonTitles[_loc1_].text.split(" ").join("").toLowerCase();
            }
            this.menuItems[_loc47_] = _loc3_;
            this.menu.addChild(_loc3_);
            Prompt.connectButton(_loc3_.mc,this.menuButtonPrompts[_loc1_]);
            _loc2_ = new Divider(null,NaN,41,true,Styles.floatPosition,Styles.menuStyle);
            this.menu.addChild(_loc2_);
            _loc1_++;
         }
         this.menuItems.save.enabled = false;
         this.menuItems.saveas.enabled = false;
         var _loc4_:Position = new Position({
            "margin_right":2,
            "margin_top":9
         },-1,Position.PLACEMENT_FLOAT);
         var _loc5_:Position = new Position({
            "margin_left":144,
            "margin_top":9,
            "margin_right":1
         },-1,Position.PLACEMENT_FLOAT);
         var _loc6_:Style = new Style({
            "round":0,
            "font":"Myriad Web",
            "titleFont":"Myriad Web Bold",
            "buttonFont":"Myriad Web Bold",
            "embedFonts":true,
            "fontSize":11,
            "buttonFontSize":11,
            "buttonTextColor":13421772
         });
         var _loc7_:Style = new Style({
            "fontSize":10,
            "buttonFontSize":10
         });
         var _loc8_:Style = new Style({
            "borderWidth":2,
            "inactiveColor":6684774
         });
         this._levelSelector = new ComboBox(null,"Level",["Level 1"],0,"Level",100,_loc5_,_loc7_);
         this.menu.addChild(this._levelSelector);
         Prompt.connectButton(this._levelSelector.mc,"Click to change the level you are working on");
         var _loc9_:Divider = new Divider(null,1,23,true,_loc4_.clone({"margin_right":8}),_loc8_.clone({"borderColor":10027161}));
         this.menu.addChild(_loc9_);
         this._addLevelButton = new BButton(null,Create.ICON_PLUS,-1,23,23,false,false,false,_loc4_,_loc8_);
         this._addLevelButton.alt = "Click to add a level to your game";
         this.menu.addChild(this._addLevelButton);
         Prompt.connectButton(this._addLevelButton.mc,this._addLevelButton.alt);
         this._removeLevelButton = new BButton(null,Create.ICON_MINUS,-1,23,23,false,false,false,_loc4_,_loc8_);
         this._removeLevelButton.alt = "Click to remove this level from your game";
         this.menu.addChild(this._removeLevelButton);
         this._removeLevelButton.disable();
         Prompt.connectButton(this._removeLevelButton.mc,this._removeLevelButton.alt);
         this._moveLevelButton = new BButton(null,Create.ICON_ARROW_UP,-1,23,23,false,false,false,_loc4_,_loc8_);
         this._moveLevelButton.alt = "Click to move this level up so it plays before the previous level";
         this.menu.addChild(this._moveLevelButton);
         this._moveLevelButton.disable();
         Prompt.connectButton(this._moveLevelButton.mc,this._moveLevelButton.alt);
         this._ui.addChild(new Cell(null,860,2,true));
         this._tray = new Cell(null,135,stage.stageHeight - 73,true,false,0,Styles.floatPosition,Styles.trayStyle);
         this._ui.addChild(this._tray);
         var _loc10_:Cell = new Cell(null,1,stage.stageHeight - 73,false,false,0,Styles.floatPosition);
         this._ui.addChild(_loc10_);
         this.trayButtons = new TabGroup(null,this._trayButtonTitles,null,0,135,true,new Position({"align":Position.ALIGN_LEFT}),Styles.trayStyle);
         this._tray.addChild(this.trayButtons);
         var _loc11_:Cell = new Cell(null,135,NaN,false,false,0,new Position({
            "margin_left":3,
            "margin_top":-6
         }));
         this._tray.addChild(_loc11_);
         (_loc12_ = this.trays[CreatorUIStates.TRAY_PREFABS] = new Collection(null,129,384,125,60,4,new Position(null,-1,Position.PLACEMENT_ABSOLUTE),Styles.trayItemStyle)).allowDrag = true;
         _loc12_.maskContent = true;
         _loc12_.allowRemoveOnDrag = false;
         _loc12_.allowKeyboardEvents = false;
         _loc12_.defaultItemComponent = "Clip";
         _loc11_.addChild(_loc12_);
         _loc12_.addMembers(this._trayObjectsPrefabs,-1,false,true);
         _loc12_.addAlts(this._trayObjectsPrefabsAlts);
         _loc1_ = 0;
         while(_loc1_ < _loc12_.members.length)
         {
            Prompt.connectButton(CollectionItem(_loc12_.members[_loc1_]).mc,"Drag this onto the canvas to create new ready-made objects.");
            _loc1_++;
         }
         (_loc12_ = this.trays[CreatorUIStates.TRAY_PHYSICS] = new Collection(null,129,384,125,60,4,new Position(null,-1,Position.PLACEMENT_ABSOLUTE),Styles.trayItemStyle)).allowDrag = true;
         _loc12_.maskContent = true;
         _loc12_.allowRemoveOnDrag = false;
         _loc12_.allowKeyboardEvents = false;
         _loc12_.defaultItemComponent = "Clip";
         _loc11_.addChild(_loc12_);
         _loc12_.hide();
         _loc12_.addMembers(this._trayObjectsPhysics,-1,false,true);
         _loc12_.addAlts(this._trayObjectsPhysicsAlts);
         _loc1_ = 0;
         while(_loc1_ < _loc12_.members.length)
         {
            Prompt.connectButton(CollectionItem(_loc12_.members[_loc1_]).mc,"Drag this onto a game object to modify its physics behavior.");
            _loc1_++;
         }
         (_loc12_ = this.trays[CreatorUIStates.TRAY_CONTROLS] = new Collection(null,129,384,125,60,4,new Position(null,-1,Position.PLACEMENT_ABSOLUTE),Styles.trayItemStyle)).allowDrag = true;
         _loc12_.maskContent = true;
         _loc12_.allowRemoveOnDrag = false;
         _loc12_.allowKeyboardEvents = false;
         _loc12_.defaultItemComponent = "Clip";
         _loc11_.addChild(_loc12_);
         _loc12_.addMembers(this._trayObjectsControls,-1,false,true);
         _loc12_.addAlts(this._trayObjectsControlsAlts);
         _loc12_.hide();
         _loc1_ = 0;
         while(_loc1_ < _loc12_.members.length)
         {
            Prompt.connectButton(CollectionItem(_loc12_.members[_loc1_]).mc,"Drag this onto a game object to allow control with the keyboard or mouse.");
            _loc1_++;
         }
         (_loc12_ = this.trays[CreatorUIStates.TRAY_WIDGETS] = new Collection(null,129,384,125,60,4,new Position(null,-1,Position.PLACEMENT_ABSOLUTE),Styles.trayItemStyle)).allowDrag = true;
         _loc12_.maskContent = true;
         _loc12_.allowRemoveOnDrag = false;
         _loc12_.allowKeyboardEvents = false;
         _loc12_.defaultItemComponent = "Clip";
         _loc11_.addChild(_loc12_);
         _loc12_.addMembers(this._trayObjectsWidgets,-1,false,true);
         _loc12_.addAlts(this._trayObjectsWidgetsAlts);
         _loc12_.hide();
         _loc1_ = 0;
         while(_loc1_ < _loc12_.members.length)
         {
            Prompt.connectButton(CollectionItem(_loc12_.members[_loc1_]).mc,"Drag this onto a game object to add automated actions or controls.");
            _loc1_++;
         }
         var _loc13_:Style = Styles.dialogueStyle.clone();
         _loc13_.buttonColor = _loc13_.unselectedColor = _loc13_.inactiveColor = 0;
         _loc13_.round = 30;
         this.trayPager = new ToggleButton(null,Create.ICON_ARROW_DOWN,Create.ICON_ARROW_UP,false,-1,125,30,new Position(null,-1,Position.PLACEMENT_ABSOLUTE,-1,null,386,2),_loc13_);
         _loc11_.addChild(this.trayPager);
         Prompt.connectButton(this.trayPager.mc,"Click to view more items.");
         var _loc14_:Cell = new Cell(null,724,47,true,false,0,Styles.floatPosition);
         this._ui.addChild(_loc14_);
         this.ddGraphics = new PanelGraphics(this._creator);
         this.ddGraphics.create(_loc14_);
         this.ddAnimation = new Cell(null,145,130,true,true,0,Styles.absPosition.clone({
            "top":45,
            "left":560,
            "padding":20
         }),Styles.dialogueStyle);
         _loc14_.addChild(this.ddAnimation);
         this.ddAnimation.hide();
         this.ddAnimation.hideOnMouseOut = true;
         this.animNormal = new RadioButton(null,"Normal Mode","1","anim",true,NaN,NaN,"Graphic displays without changes from simulation",new Position({"margins":"12 0 0 15"}),Styles.dialogueStyle);
         this.ddAnimation.addChild(this.animNormal);
         this.animFlip = new RadioButton(null,"Flip Mode","1","anim",false,NaN,NaN,"Graphic flips horizontally depending on direction of movement",new Position({"margins":"0 0 0 15"}),Styles.dialogueStyle);
         this.ddAnimation.addChild(this.animFlip);
         this.animWalk = new RadioButton(null,"Walk Mode","1","anim",false,NaN,NaN,"Graphic flips and animates only on horizontal movement",new Position({"margins":"0 0 0 15"}),Styles.dialogueStyle);
         this.ddAnimation.addChild(this.animWalk);
         this.animRotate = new RadioButton(null,"Rotate Mode","1","anim",false,NaN,NaN,"Graphic rotates to match movement. Use only with sliding objects and no gravity.",new Position({"margins":"0 0 0 15"}),Styles.dialogueStyle);
         this.ddAnimation.addChild(this.animRotate);
         this.animRotateWalk = new RadioButton(null,"Walk & Rotate","1","anim",false,NaN,NaN,"Graphic rotates and animates only when moving. Use only with sliding objects and no gravity.",new Position({"margins":"0 0 0 15"}),Styles.dialogueStyle);
         this.ddAnimation.addChild(this.animRotateWalk);
         var _loc15_:Position = new Position({
            "placement":Position.PLACEMENT_FLOAT,
            "margin_top":2,
            "margin_left":3
         });
         var _loc16_:Style = new Style({
            "buttonColor":0,
            "border":0,
            "round":0,
            "borderColor":0,
            "selectedButtonColor":13209,
            "padding":0
         });
         this.tools = new TabGroup(null,this._toolIconSymbols,this._toolIconAlts,1,41,false,_loc15_,_loc16_);
         this.tools.clipMode = true;
         this.tools.clipScale = 1;
         _loc14_.addChild(this.tools);
         var _loc17_:Array = this.tools.tabs as Array;
         _loc1_ = 0;
         while(_loc1_ < _loc17_.length)
         {
            Prompt.connectButton(_loc17_[_loc1_].mc,this._toolIconAlts[_loc1_]);
            _loc1_++;
         }
         _loc2_ = new Divider(null,2,41,true,Styles.floatPosition.clone({
            "margin_left":10,
            "margin_right":10,
            "margin_top":2
         }),Styles.menuStyle.clone({"borderWidth":2}));
         _loc14_.addChild(_loc2_);
         this._subtools = new Cell(null,380,41,false,false,0,Styles.floatPosition);
         _loc14_.addChild(this._subtools);
         this.drawProps = new Cell(null,510,41,false,false,0,Styles.absPosition);
         this._subtools.addChild(this.drawProps);
         var _loc18_:Position = _loc15_.clone({
            "margin_left":0,
            "margin_right":4
         });
         var _loc19_:Style;
         (_loc19_ = _loc16_.clone({
            "buttonColor":0,
            "unselectedColor":3355443,
            "backgroundColor":5592405,
            "borderColor":16777215,
            "inactiveColor":1118481,
            "round":4
         })).buttonTextColor = 16777215;
         _loc19_.unselectedTextColor = 16777215;
         _loc19_.inactiveTextColor = 10066329;
         _loc19_.inverseTextColor = 16777215;
         var _loc21_:Position = new Position({
            "margin_top":5,
            "margin_left":5
         });
         (_loc20_ = new ClipChooser(null,"",this._iconsShapes,this._iconsShapesAlts,0,"",60,41,Position.POSITION_BELOW,_loc18_,_loc19_)).rowLength = 1;
         _loc20_.name = CreatorUIStates.SHAPE;
         _loc20_.alt = this._iconsShapesAlt;
         _loc20_.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.drawProps.addChild(_loc20_);
         this.shapes = _loc20_;
         (_loc20_ = new ClipChooser(null,"",this._iconsConstraints,this._iconsConstraintsAlts,0,"",60,41,Position.POSITION_BELOW,_loc18_,_loc19_)).rowLength = 1;
         _loc20_.name = CreatorUIStates.MOVEMENT;
         _loc20_.alt = this._iconsConstraintsAlt;
         _loc20_.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.drawProps.addChild(_loc20_);
         this.constraints = _loc20_;
         (_loc20_ = new ClipChooser(null,"",this._iconsMaterials,this._iconsMaterialsAlts,0,"",60,41,Position.POSITION_BELOW,_loc18_,_loc19_)).rowLength = 1;
         _loc20_.name = CreatorUIStates.MATERIAL;
         _loc20_.alt = this._iconsMaterialsAlt;
         _loc20_.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.drawProps.addChild(_loc20_);
         this.materials = _loc20_;
         (_loc20_ = new ClipChooser(null,"",this._iconsStrengths,this._iconsStrengthsAlts,0,"",60,41,Position.POSITION_BELOW,_loc18_,_loc19_)).rowLength = 1;
         _loc20_.name = CreatorUIStates.STRENGTH;
         _loc20_.alt = this._iconsStrengthsAlt;
         _loc20_.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.drawProps.addChild(_loc20_);
         this.strengths = _loc20_;
         this.paintProps = new Cell(null,510,41,false,false,0,Styles.absPosition);
         this._subtools.addChild(this.paintProps);
         var _loc22_:Array = [];
         _loc22_.push(CreatorUIStates.NONE);
         _loc22_.push(0);
         _loc26_ = 0;
         while(_loc26_ <= 255)
         {
            _loc22_.push(_loc26_ << 16 | _loc26_ << 8 | _loc26_);
            _loc26_ += 17;
         }
         _loc25_ = 0;
         while(_loc25_ <= 255)
         {
            _loc23_ = 0;
            while(_loc23_ <= 102)
            {
               _loc24_ = 0;
               while(_loc24_ <= 255)
               {
                  _loc22_.push(_loc23_ << 16 | _loc24_ << 8 | _loc25_);
                  _loc24_ += 51;
               }
               _loc23_ += 51;
            }
            _loc25_ += 51;
         }
         _loc25_ = 0;
         while(_loc25_ <= 255)
         {
            _loc23_ = 153;
            while(_loc23_ <= 255)
            {
               _loc24_ = 0;
               while(_loc24_ <= 255)
               {
                  _loc22_.push(_loc23_ << 16 | _loc24_ << 8 | _loc25_);
                  _loc24_ += 51;
               }
               _loc23_ += 51;
            }
            _loc25_ += 51;
         }
         (_loc20_ = new ColorClipChooser(null,"",_loc22_.concat(),["No Fill"],127,"",60,41,Position.POSITION_BELOW,_loc18_,_loc19_)).rowLength = 18;
         _loc20_.choicesPadding = 0;
         _loc20_.choicesShrink = 24;
         _loc20_.choicesOffsetX = -60;
         _loc20_.name = CreatorUIStates.DECORATE_FILL;
         _loc20_.alt = "Choose a new fill color for selected objects";
         _loc20_.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.paintProps.addChild(_loc20_);
         this.fills = _loc20_;
         _loc22_[1] = CreatorUIStates.GLOW;
         (_loc20_ = new ColorClipChooser(null,"",_loc22_,["No Line","Glowing Edges"],134,"",60,41,Position.POSITION_BELOW,_loc18_,_loc19_)).rowLength = 18;
         _loc20_.choicesPadding = 0;
         _loc20_.choicesShrink = 24;
         _loc20_.choicesOffsetX = -60;
         _loc20_.choicesLineMode = true;
         _loc20_.name = CreatorUIStates.DECORATE_LINE;
         _loc20_.alt = "Choose a new line color for selected objects";
         _loc20_.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.paintProps.addChild(_loc20_);
         this.lines = _loc20_;
         (_loc20_ = new ClipChooser(null,"",this._iconsTextures,[""],8,"",60,41,Position.POSITION_BELOW,_loc18_,_loc19_)).rowLength = 4;
         _loc20_.choicesShrink = 11;
         _loc20_.name = CreatorUIStates.TEXTURE;
         _loc20_.alt = this._iconsTexturesAlt;
         _loc20_.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.paintProps.addChild(_loc20_);
         this.textures = _loc20_;
         (_loc20_ = new ClipChooser(null,"",[CreatorUIStates.LAYER_1,CreatorUIStates.LAYER_2,CreatorUIStates.LAYER_3,CreatorUIStates.LAYER_4,CreatorUIStates.LAYER_5],["Front Layer","","","","Back Layer"],2,"",60,41,Position.POSITION_BELOW,_loc18_,_loc19_)).rowLength = 1;
         _loc20_.name = CreatorUIStates.DECORATE_ZLAYER;
         _loc20_.alt = "Choose the overlapping layer for selected objects. Higher layers are in front of others.";
         _loc20_.addEventListener(Component.EVENT_CLICK,this.onClick);
         this.paintProps.addChild(_loc20_);
         this.zlayers = _loc20_;
         this.paintProps.hide();
         this.editProps = new Cell(null,200,41,false,false,0,Styles.floatPosition);
         this.drawProps.addChild(this.editProps);
         var _loc27_:Position = Styles.floatPosition.clone({"margins":"13 0 0 6"});
         this.moveLock = new ClipButton(null,CreatorUIStates.MOVEMENT_UNLOCKED,CreatorUIStates.MOVEMENT_LOCKED,1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.moveLock.name = CreatorUIStates.LOCK;
         this.moveLock.alt = this._moveLockAlt;
         this.moveLock.toggledAlt = this._moveLockAltToggled;
         this.editProps.addChild(this.moveLock);
         this.layersButton = new ClipButton(null,CreatorUIStates.LAYERS,"",1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.layersButton.alt = this._layersButtonAlt;
         this.editProps.addChild(this.layersButton);
         this.actionsButton = new ClipButton(null,CreatorUIStates.ICON_ACTIONS,"",1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.actionsButton.alt = this._actionsButtonAlt;
         this.editProps.addChild(this.actionsButton);
         var _loc28_:Style;
         (_loc28_ = _loc19_.clone()).round = 0;
         _loc28_.background = false;
         _loc28_.gradient = false;
         this.moveGroup = new ClipButton(null,CreatorUIStates.MOVEMENT_UNGROUPED,CreatorUIStates.MOVEMENT_GROUPED,1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.moveGroup.alt = this._moveGroupAlt;
         this.moveGroup.toggledAlt = this._moveGroupAltToggled;
         this.editProps.addChild(this.moveGroup);
         this.delSelection = new ClipButton(null,CreatorUIStates.DELETE,"",1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.delSelection.alt = this._delSelectionAlt;
         this.editProps.addChild(this.delSelection);
         this.opaque = new ClipButton(null,CreatorUIStates.FILL_OPAQUE,CreatorUIStates.FILL_TRANSPARENT,1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.opaque.name = CreatorUIStates.OPAQUE;
         this.opaque.alt = "Click to make fills transparent";
         this.opaque.toggledAlt = "Click to make fills opaque";
         this.paintProps.addChild(this.opaque);
         this.scribble = new ClipButton(null,CreatorUIStates.EDGE_STRAIGHT,CreatorUIStates.EDGE_SCRIBBLE,1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.scribble.name = CreatorUIStates.SCRIBBLE;
         this.scribble.alt = "Click to make edges scribbly";
         this.scribble.toggledAlt = "Click to make edges straight";
         this.paintProps.addChild(this.scribble);
         this.graphicsPanelToggle = new ClipButton(null,CreatorUIStates.ICON_GRAPHICS_PANEL,CreatorUIStates.ICON_GRAPHICS_PANEL,1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.graphicsPanelToggle.name = CreatorUIStates.ICON_GRAPHICS_PANEL;
         this.graphicsPanelToggle.alt = "Click to show graphics panel";
         this.graphicsPanelToggle.toggledAlt = "Click to hide graphics panel";
         this.paintProps.addChild(this.graphicsPanelToggle);
         this.animationToggle = new ClipButton(null,CreatorUIStates.ICON_ANIMATION,CreatorUIStates.ICON_ANIMATION,1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.animationToggle.name = CreatorUIStates.ICON_ANIMATION;
         this.animationToggle.alt = "Click to show graphic animation choices";
         this.animationToggle.toggledAlt = "Click to hide graphic animation choices";
         this.paintProps.addChild(this.animationToggle);
         this.animationToggle.disable();
         this.advancedTextureToggle = new ClipButton(null,CreatorUIStates.ICON_ADVANCED_TEXTURES,CreatorUIStates.ICON_ADVANCED_TEXTURES,1,30,30,10,false,false,false,false,_loc27_,_loc19_);
         this.advancedTextureToggle.name = CreatorUIStates.ICON_ANIMATION;
         this.advancedTextureToggle.alt = "Click to show the advanced texture editor";
         this.advancedTextureToggle.toggledAlt = "Click to hide the advanced texture editor";
         this.paintProps.addChild(this.advancedTextureToggle);
         this.advancedTextureToggle.disable();
         var _loc29_:Style;
         (_loc29_ = _loc19_.clone()).backgroundColor = 3355443;
         _loc29_.borderColor = 0;
         _loc29_.borderWidth = 2;
         _loc29_.bgGradientColors = [4408131,1118481];
         _loc29_.bgGradientHeight = 100;
         _loc29_.bgGradient = true;
         this.layersMenu = new Cell(null,130,160,true,true,8,new Position(null,-1,Position.PLACEMENT_ABSOLUTE,-1,null,44,-46,2),_loc29_);
         this.editProps.addChild(this.layersMenu);
         this.layersMenu.hideOnMouseOut = true;
         this.layersMenu.hideOnlyAfterMouseOver = true;
         this.layersButtons = new Cell(null,110,140,false,false,0,new Position({"margins":"10 0 0 10"}));
         this.layersMenu.addChild(this.layersButtons);
         var _loc30_:Style;
         (_loc30_ = _loc19_.clone()).backgroundColor = 3355443;
         _loc30_.buttonFont = "Myriad Web Bold";
         _loc30_.embedFonts = true;
         _loc30_.buttonFontSize = 12;
         _loc30_.unselectedTextColor = 10066329;
         _loc30_.borderWidth = 1;
         _loc30_.buttonTextColor = 16777215;
         _loc30_.inverseTextColor = 16777215;
         _loc30_.unselectedBorderColor = 6710886;
         _loc30_.buttonBorderColor = 16777215;
         _loc30_.border = true;
         var _loc31_:Style;
         (_loc31_ = _loc30_.clone({})).buttonTextColor = 0;
         _loc31_.border = false;
         _loc31_.buttonColor = 7829367;
         var _loc32_:Position;
         (_loc32_ = Styles.floatPosition.clone({})).margin_right = 2;
         _loc32_.margin_bottom = 2;
         (_loc35_ = new HTMLField(null,"Collision Layers <a class=\"litelink\" href=\"event:showtag\">(?)</a>:",110,false,new Position({"margin_left":-3}),Styles.menuStyle)).alt = "Objects on the same layers will collide with eachother";
         this.layersButtons.addChild(_loc35_);
         _loc34_ = 0;
         while(_loc34_ < 5)
         {
            (_loc33_ = new ToggleButton(null,_loc34_ + "",_loc34_ + "",false,-1,20,20,_loc32_,_loc30_)).alt = "Click to add this object to the layer";
            _loc33_.toggledAlt = "Click to remove this object from the layer";
            this.layersButtons.addChild(_loc33_);
            this.layers["c_" + _loc34_] = _loc33_;
            _loc34_++;
         }
         (_loc35_ = new HTMLField(null,"Passthru Layers <a class=\"litelink\" href=\"event:showtag\">(?)</a>:",115,false,new Position({
            "margin_top":5,
            "margin_left":-3
         }),Styles.menuStyle)).alt = "Objects on the same layers will pass through eachother";
         this.layersButtons.addChild(_loc35_);
         _loc34_ = 0;
         while(_loc34_ < 5)
         {
            (_loc33_ = new ToggleButton(null,String.fromCharCode(65 + _loc34_),String.fromCharCode(65 + _loc34_),false,-1,20,20,_loc32_,_loc30_)).alt = "Click to add this object to the layer";
            _loc33_.toggledAlt = "Click to remove this object from the layer";
            this.layersButtons.addChild(_loc33_);
            this.layers["p_" + _loc34_] = _loc33_;
            _loc34_++;
         }
         (_loc35_ = new HTMLField(null,"Sensor Layers <a class=\"litelink\" href=\"event:showtag\">(?)</a>:",110,false,new Position({
            "margin_top":5,
            "margin_left":-3
         }),Styles.menuStyle)).alt = "Objects on the same layers will send out Sense events when they touch eachother";
         this.layersButtons.addChild(_loc35_);
         this.sensorLayersTitle = _loc35_;
         var _loc37_:Style;
         (_loc37_ = _loc30_.clone()).selectedButtonColor = 0;
         _loc34_ = 0;
         while(_loc34_ < 5)
         {
            (_loc36_ = new ClipButton(null,this._layersSensorSymbols[_loc34_],this._layersSensorSymbols[_loc34_] + "_selected",0.6,20,20,10,false,false,false,false,_loc32_,_loc37_)).alt = "Click to add this object to the layer";
            _loc36_.toggledAlt = "Click to remove this object from the layer";
            this.layersButtons.addChild(_loc36_);
            this.layers["s_" + _loc34_] = _loc36_;
            _loc34_++;
         }
         this.layersMenu.hide();
         this.drawProps.hide();
         this.ddLayerView = new Cell(null,135,154,true,true,0,Styles.absPosition.clone({
            "top":45,
            "left":585,
            "padding":0
         }),Styles.dialogueStyle);
         _loc14_.addChild(this.ddLayerView);
         this.ddLayerView.hide();
         this.ddLayerView.hideOnMouseOut = true;
         this.layerViewButtons = [];
         this.ddLayerSelectionIndicators = [];
         var _loc41_:Position;
         (_loc41_ = new Position()).placement = Position.PLACEMENT_ABSOLUTE;
         _loc41_.align = Position.ALIGN_LEFT;
         _loc41_.top = 2;
         _loc41_.left = 16;
         this.layerDefaultButtons = new TabGroup(null,["Layer 1","Layer 2","Layer 3","Layer 4","Layer 5"],null,2,100,true,_loc41_,Styles.trayStyle.clone({"padding":12}));
         this.ddLayerView.addChild(this.layerDefaultButtons);
         this.ddLayerView.addChild(new Cell(null,135,2));
         var _loc42_:Position = new Position({"margin_left":2});
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            (_loc39_ = new ClipButton(null,CreatorUIStates.EYE_CLOSED,CreatorUIStates.EYE,1,30,30,10,false,false,false,false,_loc42_,Styles.trayStyle)).name = "layerview_" + _loc1_;
            _loc39_.value = _loc1_ + "";
            this.ddLayerView.addChild(_loc39_);
            this.layerViewButtons.push(_loc39_);
            _loc40_ = new Shape();
            _loc40_.graphics.beginFill(16772096);
            _loc40_.graphics.drawCircle(0,0,4);
            _loc40_.graphics.endFill();
            _loc40_.x = 120;
            _loc40_.y = 17 + _loc1_ * 30;
            _loc40_.blendMode = BlendMode.SCREEN;
            _loc40_.visible = false;
            this.ddLayerView.mc.addChild(_loc40_);
            this.ddLayerSelectionIndicators.push(_loc40_);
            _loc1_++;
         }
         this.layerViewToggle = new ClipButton(null,CreatorUIStates.EYE,CreatorUIStates.EYE,1,30,30,10,false,false,false,false,Styles.absPosition.clone({
            "top":13,
            "left":690
         }),_loc19_);
         this.layerViewToggle.name = CreatorUIStates.LAYERS_VIEW;
         this.layerViewToggle.alt = "Click to show and hide layers";
         _loc14_.addChild(this.layerViewToggle);
         this.gameProps = new Cell(null,410,41,false,false,0,Styles.absPosition);
         this._subtools.addChild(this.gameProps);
         var _loc43_:Style = Styles.menuStyle.clone({
            "buttonColor":0,
            "round":"6",
            "buttonFontSize":12,
            "borderColor":3355443,
            "buttonBorderColor":3355443,
            "inverseTextColor":13421772,
            "border":true,
            "borderWidth":1
         });
         var _loc44_:Position = new Position({
            "placement":Position.PLACEMENT_FLOAT,
            "margin_top":17,
            "margin_right":3
         });
         this.world = new BButton(null,"Playfield",-1,80,NaN,false,false,false,_loc44_,_loc43_);
         this.world.alt = "Edit the size of this level";
         this.gameProps.addChild(this.world);
         this.bkgd = new BButton(null,"Background",-1,90,NaN,false,false,false,_loc44_,_loc43_);
         this.bkgd.alt = "Change the background image for this level";
         this.bkgd.forceWidth = true;
         this.gameProps.addChild(this.bkgd);
         this.goals = new BButton(null,"Goals",-1,50,NaN,false,false,false,_loc44_,_loc43_);
         this.goals.alt = "Manage and edit the goals for this level";
         this.goals.forceWidth = true;
         this.gameProps.addChild(this.goals);
         this.music = new BButton(null,"Music",-1,50,NaN,false,false,false,_loc44_,_loc43_);
         this.music.alt = "Add music to this level";
         this.music.forceWidth = true;
         this.gameProps.addChild(this.music);
         var _loc45_:Style;
         (_loc45_ = Styles.dialogueStyle.clone()).buttonColor = 0;
         _loc45_.unselectedColor = 0;
         this.vScroll = new ScrollBar(this,20,454,Position.ORIENTATION_VERTICAL,Styles.absPosition,_loc45_);
         this.vScroll.targetCell = this.playfieldContainer;
         this.vScroll.x = 838;
         this.vScroll.y = 92;
         this.vScroll.hide();
         this.hScroll = new ScrollBar(this,698,20,Position.ORIENTATION_HORIZONTAL,Styles.absPosition,_loc45_);
         this.hScroll.targetCell = this.playfieldContainer;
         this.hScroll.x = 138;
         this.hScroll.y = 548;
         this.hScroll.hide();
         this.zoomToggle = new ClipButton(this,CreatorUIStates.ZOOM_OUT,CreatorUIStates.ZOOM_IN,0.1,20,20,2,false,false,false,false,Styles.absPosition,_loc45_);
         this.zoomToggle.x = 838;
         this.zoomToggle.y = 548;
         this.zoomToggle.alt = "Zoom out and view whole game area";
         this.zoomToggle.toggledAlt = "Zoom in and view a part of the game for more precise editing";
         this.zoomToggle.hide();
         setChildIndex(this.playfieldContainer.mc,0);
         setChildIndex(this.vScroll.mc,1);
         setChildIndex(this.hScroll.mc,2);
         setChildIndex(this.zoomToggle.mc,3);
         this.clipboard = new BButton(this,"Clipboard",-1,100,30,false,false,false,null,_loc16_);
         this.clipboard.x = 860 - 100 - 61;
         this.clipboard.y = 600 - 30;
         this.clipboard.alt = "Copy and paste stuff into the game";
         this.undoButton = library.getDisplayObject(CreatorUIStates.BUTTON_UNDO) as SimpleButton;
         this.undoButton.x = 860 - 45;
         this.undoButton.y = 600 - 15;
         addChild(this.undoButton);
         this.redoButton = library.getDisplayObject(CreatorUIStates.BUTTON_REDO) as SimpleButton;
         this.redoButton.x = 860 - 15;
         this.redoButton.y = 600 - 15;
         addChild(this.redoButton);
         this.helpButton = library.getDisplayObject(CreatorUIStates.BUTTON_HELP) as SimpleButton;
         this.helpButton.x = 860 - 20;
         this.helpButton.y = 20;
         this.menu.mc.addChild(this.helpButton);
         this.modifierPropertiesEditor = new ModifierPropertiesEditor(this);
         this.buildDialogues();
         this.testMask = new Sprite();
         DrawingMethods.rect(this.testMask,true,0,0,stage.stageWidth,stage.stageHeight,0,0.25);
         DrawingMethods.rect(this.testMask,false,136,90,44,stage.stageHeight - 90 - 20,3355443,1);
         DrawingMethods.rect(this.testMask,false,820,90,40,stage.stageHeight - 90 - 20,3355443,1);
         addChild(this.testMask);
         this.testMask.visible = false;
         var _loc46_:Style;
         (_loc46_ = Styles.dialogueStyle.clone()).buttonColor = 0;
         _loc46_.round = 10;
         _loc46_.border = true;
         _loc46_.borderWidth = 2;
         _loc46_.unselectedBorderColor = 53687091;
         this._testEndButtonContainer = new Cell(this,724,43,true,false,0,Styles.absPosition,new Style({"backgroundColor":0}));
         this._testEndButtonContainer.x = 136;
         this._testEndButtonContainer.y = 44;
         this._testEndButtonContainer.addChild(new HTMLField(null,"<p>Testing Game Level:</p>",300,false,Styles.floatPosition.clone({"margins":"11 0 0 12"}),Styles.dialogueStyle.clone({"fontSize":16})));
         this._testEndButton = new BButton(null,"Click here when you are done testing",-1,240,32,false,false,false,new Position({
            "placement":Position.PLACEMENT_FLOAT,
            "margins":"5 0 0 164"
         }),_loc46_);
         this._testEndButtonContainer.addChild(this._testEndButton);
         this._testEndButtonContainer.hide();
      }
      
      protected function buildDialogues() : void
      {
         this.notice = new Notice();
         this.notice.style = Styles.dialogueStyle;
         this.notice.icon = CreatorUIStates.ALERT;
         stage.addChild(this.notice);
         this.ddWelcome = new DialogueWelcome(this._creator,320,320);
         this.ddWelcome.create();
         this.ddClipboard = new DialogueClipboard(this._creator,560,280,"Clipboard");
         this.ddClipboard.create();
         this.ddActionMatrix = new DialogueActionMatrix(this._creator,580,500,"Object Actions");
         this.ddActionMatrix.create();
         this.ddEnvironment = new DialogueEnvironment(this._creator,440,420,"Playfield Settings");
         this.ddEnvironment.create();
         this.ddBackground = new DialogueBackground(this._creator,580,420,"Background Settings");
         this.ddBackground.create();
         this.ddGoals = new DialogueGoals(this._creator,500,360,"Level Goals");
         this.ddGoals.create();
         this.ddConfirm = new DialogueConfirm(this._creator,440,150,"Confirm Action");
         this.ddConfirm.create();
         this.ddAlert = new DialogueAlert(this._creator,440,130,"");
         this.ddAlert.create();
         this.ddPublish = new DialoguePublish(this._creator,440,220,"Publish Game");
         this.ddPublish.create();
         this.ddPublishComplete = new DialoguePublishComplete(this._creator,440,240,"Game Publish");
         this.ddPublishComplete.create();
         this.ddEmbed = new DialogueEmbed(this._creator,440,240,"Embed your Game",["Cancel","Copy to Clipboard"]);
         this.ddEmbed.create();
         this.ddServer = new DialogueServer(this._creator,440,240,"Server Interaction",["Close"]);
         this.ddServer.create();
         this.ddManager = new DialogueFileManager(this._creator,480,420,"Load a Game",["Cancel","OK"]);
         this.ddManager.create();
         this.ddMusic = new DialogueMusicManager(this._creator,330,480,"Add Music",["Cancel","Remove Music","Select Music"]);
         this.ddMusic.create();
         this.ddTextureGen = new DialogueTextureGen(this._creator,560,410,"Advanced Texture Editor",[]);
         this.ddTextureGen.create();
      }
      
      protected function onClick(param1:Event) : void
      {
      }
   }
}

