package pt.containers.containersClasses
{
	
	/**
	* 对话框控件。弹出对话框。警告框，等需要扩展于此控件
	*/	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import pt.controls.ButtonBar;
	import pt.utils.InstanceFactory;
	import pt.utils.UIComponentUtil;

	
   /** 
    *  
    *  skin用作TitleBar背景
    *  @default Background_skin
    */  
   [Style(name="skin", type="Class", inherit="no")]  
   
	
	public class DialogBox extends UIComponent
	{		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * 
		 * @param container 弹出此对话框的Stage；
		 * 
		 */		
		public function DialogBox(container:Stage) 
		{
			_stage = container;
			this.visible = false;
		}
		
	//--------------------------------------
	//  Constants
	//--------------------------------------		
	
		/**
		 * 标题
		 */
		protected const TITLE:String = "title";

		/**
		 * 按钮组
		 */		
		protected const BUTTONS:String = "buttons";
		
	//--------------------------------------
	//  Properties
	//--------------------------------------		

		/**
		 * @private (protected) 
		 */
		//初始化titleBar
		protected var _titleBar:TitleBar;
		
		public function get titleBar():TitleBar
		{
			return _titleBar;
		}
		
		public function setTitleBar(value:TitleBar):void
		{
			_titleBar = value;	
		}
		
		/**
		 * @private (protected) 
		 */		
	 	//Distance from the top of the component 
	 	//when the user presses his mouse on the 
	 	//title bar.  Used to calculate the drag.
	   	protected var _dragOffSetY:Number;

		/**
		 * @private (protected)		
		 */
		//Distance from the left of the component 
		//when the user presses his mouse on the 
		//title bar.  Used to calculate the drag.
		protected var _dragOffSetX:Number;

		/**
		 * @private (protected)
		 */
		//Reference to the ButtonBar class instance 
		//which manages the buttons
		protected var _buttonBar:ButtonBar;
		
		/**
		 * Manages the display of buttons
		 */
		public function get buttonBar():ButtonBar
		{
			return _buttonBar;
		}

		/**
		 * @private (protected) 
		 */
		protected var _minWidth:int;	
		
		/**
		 * Gets or sets the minimum width of the dialog box
		 */
		public function get minWidth():int
		{
			return _minWidth;
		}
		
		/**
		 * @private (setter)
		 */		
		public function set minWidth(value:int):void
		{
			_minWidth = value;
		}		

		/**
		 * @private (protected)
		 */
		protected var _maxWidth:int;
		
		/**
		 * Gets or sets the maximum width of the dialog box
		 */
		public function get maxWidth():int
		{
			return _maxWidth;
		}
		
		/**
		 * @private (setter)
		 */
		public function set maxWidth(value:int):void
		{
			_maxWidth = value;
			_buttonBar.maxWidth = _maxWidth - (_padding*2);
			_titleBar.maxWidth = _maxWidth;
		}		

		/**
		 * @private (protected)
		 */
		protected var _padding:int;
		
		/**
		 * Gets or sets the padding between components and edges
		 */
		public function get padding():int
		{
			return _padding;
		}
		
		/**
		 * @private (setter)
		 */		
		public function set padding(value:int):void
		{
			_padding = value;
			_buttonBar.maxWidth = _maxWidth - (_padding*2);
		}		

		/**
		 * @private (protected)
		 */
		//reference to the stage
		protected var _stage:Stage;

		/**
		 * @private (protected)
		 */
		//background skin 
		protected var _skin:DisplayObject;

		/**
		 * @private (protected)
		 */
		//MessageBox instance used for the text area of the dialog
		protected var _messageBox:MessageBox;
	
		/**
		 * Text field component that displays message
		 */
		public function get messageBox():MessageBox
		{
			return _messageBox;
		}

		/**
		 * @private (protected)
		 */
		//reference to the text field in the message box
		protected var _message:TextField;

		/**
		 * @private (protected)
		 */
		//text to be rendered in the dialog
		protected var messageText:String;
		
		/**
		 * @private (protected)
		 */
		//Boolean indicating whether title has been drawn. 
		// Used to determine whether 
		//the elements should be positioned.
		protected var _titleDrawn:Boolean;

		/**
		 * @private (protected)
		 */
		//Boolean indicating whether buttons have been drawn.  
		//Used to determine whether 
		//the elements should be positioned</p>		
		protected var _buttonsDrawn:Boolean;
	
		
		/**
		 * @private (protected)
		 */		
		//class to use for an icon image
		protected var _iconClass:DisplayObject;

		/**
		 * @private (protected)
		 */
		//Indicates whether to display an icon graphic
		protected var _hasIcon:Boolean;

		/**
		 * @private (protected)
		 */
		//collection of icons that can be reused		 		
		protected var _icons:Dictionary = new Dictionary();
		
		/**
		 * @private
		 */		
		private static var defaultStyles:Object = 
		{
			skin:"Background_skin"
		}; 
		
		/**
		 * Indicates whether the Alert has a drop shadow
		 */
		public var hasDropShadow:Boolean;
		
		/**
		 * Direction of the drop shadow
		 */
		public var shadowDirection:String;
		
		/**
		 * Gets or sets the height of the ButtonBar instance
		 */
		public function get buttonHeight():int
		{
			return _buttonBar.height;
		}
		
		/**
		 * @private (setter)
		 */		
		public function set buttonHeight(value:int):void
		{
			_buttonBar.height = value;
		}
		
		/**
		 * Gets or sets the value of the rowSpacing on the
		 *  buttonBar component
		 */
		public function get buttonRowSpacing():int
		{
			return _buttonBar.rowSpacing;
		}
		
		/**
		 * @private (setter)
		 */
		public function set buttonRowSpacing(value:int):void
		{
			_buttonBar.rowSpacing = value;
		}
	
		/**
		 * Gets or sets the value of the spacing on the
		 *  buttonBar component
		 */
		public function get buttonSpacing():int
		{
			return _buttonBar.spacing;	
		}
		
		/**
		 * @private (setter)
		 */		 
		public function set buttonSpacing(value:int):void
		{
			_buttonBar.spacing = value;
		}
				
	//--------------------------------------
	//  Public Methods
	//--------------------------------------			
		
		/**
		 * returns style definition
		 *
		 * @return defaultStyles object
		 */
		public static function getStyleDefinition():Object
		{
			return defaultStyles;
		}
		
		/**
		 *DialogBox	居中	 
		 */ 
		public function positionAlert():void
		{
			var left:int = _stage.stageWidth/2 - this.width/2;
			var top:int = _stage.stageHeight/3 - this.height/2;
			this.x = left>0?left:0;
			this.y = top>0?top:0;
		}		

		/**
		 * Draws a new DialogBox
		 *??????
		 * @param message - message to be displayed
		 * @param title - title to be displayed
		 * @param buttons - array of buttons to be drawn
		 * @param listeners - array of functions to be attached 
		 * to the buttons
		 */
		public function update(message:String, title:String, buttons:Array, listeners:Array, icon:String = null):void
		{						
			_hasIcon = icon != null;
			_iconClass = null;
			for(var i:String in _icons)
			{
				_icons[i].visible = false;
				if(_hasIcon && icon == i)
				{
					_iconClass = _icons[i];
					_iconClass.visible = true;
				}
			}
			if(_hasIcon && _iconClass == null) 
			{
				try
				{ 
					_iconClass = _icons[icon] = getDisplayObjectInstance(icon);
					this.addChild(_iconClass);
				}
				catch(e:Error)
				{
					_hasIcon = false;
					delete _icons[icon];
				}
			}
			
			_titleDrawn = _buttonsDrawn = false;
			this.setFocus();
			if(message != messageText)
			{
				messageText = message;
			}
			if(title != _titleBar.text)
			{
				_titleBar.text = title;
			}
			else
			{
				_titleDrawn = true;
			}
			
			_buttonBar.drawButtons(buttons, listeners);		
		}
		
		/**
		 * @private (setter)
		 *
		 * override label set text adding setStyle
		 */		
		override public function setStyle(style:String, value:Object):void 
		{
			//Use strict equality so we can set a style to null ... 
			//so if the instanceStyles[style] == undefined, null is still set.
			//We also need to work around the specific use case of TextFormats
			if (instanceStyles[style] === value && !(value is TextFormat)) { return; }
			if(value is InstanceFactory) 
			{
				instanceStyles[style] = UIComponentUtil.getDisplayObjectInstance(this, (value as InstanceFactory).createInstance());
			}
			else
			{
				instanceStyles[style] = value;
			}
			invalidate(InvalidationType.STYLES);
		}		
		
		
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------		
		
        /**
         * @private (protected)
         *增加头部和按钮组及其相关事件；
		 */
		protected override function configUI():void
		{	
			_titleBar = new TitleBar();
			_titleBar.buttonMode = true;
			_titleBar.useHandCursor = true;	
			_titleBar.name = TITLE;
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragAlert);			
			_titleBar.addEventListener(ComponentEvent.RESIZE, resizeHandler);//在调整组件大小后调度；
			this.addChild(_titleBar);
			_messageBox = new MessageBox();
			_message = _messageBox.textField;
			_message.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
			this.addChild(_message);
			_buttonBar = new ButtonBar();
			_buttonBar.name = BUTTONS;		
			this.addChild(_buttonBar);
			_buttonBar.addEventListener(ComponentEvent.RESIZE, resizeHandler);

		}
		
        /**
         * @private (protected)
         *
		 */
		//Fired by the resize event of the buttonBar and titleBar components. 
		// Calls the draw function.
		protected function resizeHandler(evnt:ComponentEvent):void
		{
			var targetName:String = evnt.target.name;
			if(targetName == TITLE)
			{
				_titleDrawn = true;
			}
			if(targetName == BUTTONS) _buttonsDrawn = true;
			if(_titleDrawn && _buttonsDrawn) this.drawMessage();
		}
		
        /**
         * @private (protected)
         *
		 */
		//Compare width of title, buttonBar and _maxWidth.  If buttonBar or titleBar 
		//width is greater than max width, set maxTextWidth and minTextWidth to the 
		//largest value minus total padding.  Otherwise, set maxTextWidth and minTextWidth 
		//to _maxWidth and _minWidth minus total padding, call drawMessage, position and 
		//set sizes of elements		
		protected function drawMessage():void
		{
			var minTextWidth:int;
			var maxTextWidth:int;
			var totalPadding:int = _padding*2;
			if(messageText != null)
			{
				var max:int = Math.max(_minWidth, (_buttonBar.width + totalPadding), _titleBar.width);
				if(max > _minWidth)
				{
					maxTextWidth = _maxWidth - totalPadding;
					minTextWidth = max - totalPadding;
				}
				else
				{
					maxTextWidth = _maxWidth - totalPadding;
					minTextWidth = _minWidth - totalPadding;
				}
				if(_hasIcon)
				{
					maxTextWidth -= _iconClass.width + _padding;
					minTextWidth -= _iconClass.width + _padding;
					_messageBox.autoSizeStyle = TextFieldAutoSize.LEFT;
					_iconClass.y = _titleBar.height + _padding;
				}
				else
				{
					_messageBox.autoSizeStyle = TextFieldAutoSize.CENTER;
				}
				
				_messageBox.drawMessage(maxTextWidth, minTextWidth, messageText);
				_titleBar.y = 0;
				_message.y = _titleBar.height + _padding;
				
				if(_hasIcon)
				{
					_buttonBar.y = Math.max(_message.getBounds(this).bottom, _iconClass.getBounds(this).bottom) + _padding;	
					this.setSize(_message.width+_padding*2+ (_iconClass.width+_padding), _buttonBar.height + _buttonBar.y  + _padding);	
					_iconClass.x = Math.round(this.width/2) - Math.round((_iconClass.width + _padding + _message.width)/2);
					_message.x = _iconClass.x + _iconClass.width + _padding;
				}
				else
				{
					_buttonBar.y = _message.getBounds(this).bottom + _padding;	
					this.setSize(_message.width+_padding*2, _buttonBar.height + _buttonBar.y  + _padding);	
					_message.x = Math.round(this.width/2) - Math.round(_message.width/2);
				}
				
				
				_buttonBar.x = Math.round((this.width)/2- (_buttonBar.width)/2);
				_titleBar.drawBackground(this.width);
				this.drawSkin();
				this.positionAlert();
				this.visible = true;
			}
		}
		
        /**
         * @private (protected)
         *
		 */		
		//Sets dimensions(面积，容器，容积) for the background skin of the message box
		protected function drawSkin():void
		{
			if(_skin != this.getDisplayObjectInstance(getStyleValue("skin")))
			{
				if(this.getChildAt(0) == _skin) this.removeChildAt(0);
				_skin = getDisplayObjectInstance(getStyleValue("skin"))
				this.addChildAt(_skin, 0);
			}
			if(_skin != null)
			{
				_skin.width = this.width;
				_skin.height = this.height;
				if(hasDropShadow)
				{
					var shadowAngle:int = (shadowDirection == "left")?135:45;
					var filters:Array = [];
					var dropShadow:DropShadowFilter	= new DropShadowFilter(2, shadowAngle, 0x000000, .5, 4, 4, 1, 1, false, false, false);
					filters.push(dropShadow);
					_skin.filters = filters;
				}
			}
		}				
		
        /**
         * @private (protected)
         *evnt.localX：事件发生点的相对于包含 Sprite 的水平坐标
		 */				
		 //Set x and y offsets based on of the mouse down location
		 //Add mouseMove and mouseUp listeners
		 //Remove the mouseDown listener 
		protected function startDragAlert(evnt:MouseEvent):void
		{
			_dragOffSetX = Math.round(evnt.localX*evnt.target.scaleX);//round 四舍五入
			_dragOffSetY = Math.round(evnt.localY*evnt.target.scaleY);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, dragAlert, false, 0, true);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stopAlertDrag, false, 0, true);
			_titleBar.removeEventListener(MouseEvent.MOUSE_DOWN, startDragAlert);
		}
		
        /**
         * @private (protected)
         *
		 */	
		//Moves the Dialog with the mouse 
		protected function dragAlert(evnt:MouseEvent):void
		{
			if(evnt.stageX < _stage.stageWidth && evnt.stageY < _stage.stageHeight && evnt.stageX > 0 && evnt.stageY > 0)
			{
				this.x = evnt.stageX - _dragOffSetX;
				this.y = evnt.stageY - _dragOffSetY;
				evnt.updateAfterEvent();//如果已修改显示列表，则此事件处理完成后将指示 Flash Player 呈现结果。		
			}
		}
		
        /**
         * @private (protected)
         *
		 */		
		 //Remove mouseMove and mouseUp listeners
		 //Add the mouseDown listener
		protected function stopAlertDrag(evnt:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragAlert);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stopAlertDrag);
			_stage.removeEventListener(Event.MOUSE_LEAVE, stopAlertDrag);
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragAlert);
		}	

		/**
		 * @private (protected)
		 *
		 * Sets focus on the first button.
		 *
		 * @param event FocusEvent
		 *
        
		 */		
		protected function keyFocusChangeHandler(event:FocusEvent):void
		{
			if(event.keyCode == Keyboard.TAB)
			{
				event.preventDefault();
				//reset focus to the first button
				_buttonBar.focusIndex = 0;
				//if shift key is pressed, set focus on the last button
				if(event.shiftKey) _buttonBar.setFocusIndex(event.shiftKey);
				_buttonBar.setFocus();
				_buttonBar.setFocusButton();
			}
		}
	}
}