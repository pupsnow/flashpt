package  pt.controls
{
	/**
	 * The Alert class extends UIComponent and manages the queuing
	 * and displaying of Alerts.
	 *
	 * @see fl.core.UIComponent
	 */
	
	import fl.core.UIComponent;	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;	
	import pt.containers.containersClasses.DialogBox;
	import pt.utils.TextUtil;

	
	
	public class Alert extends UIComponent
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
			
		/**
         * @private (singleton constructor)
		 * 
		 * @param container - object calling the alert
		 */
		public function Alert(container:DisplayObject = null)
		{
			super();
			if(isLivePreview)
			{
				_livePreviewSkin = getDisplayObjectInstance("Background_skin") as Sprite;
				_livePreviewTitleBar = getDisplayObjectInstance("Title_skin") as Sprite;
				this.addChild(_livePreviewSkin);
				this.addChild(_livePreviewTitleBar);
			}
			else if(_allowInstantiation)
			{
				if(container != null)
				{
					_stage = container.stage;
				}
				else if(this.stage)
				{
					_stage = stage;
					parent.removeChild(this);
				}

				_allowInstantiation = false;
				
				if(_stage)
				{
					_stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
					_stage.addEventListener(Event.FULLSCREEN, stageResizeHandler, false, 0, true);	
					_stage.addChild(this);
				}
				
				_overlay = new Sprite();
				addChild(_overlay);
				_overlay.visible = false;
				
			}
		}
		
		/**
		 * @private
		 */
		private static function setStage(container:Stage):void
		{
			_stage = container;
			_stage.addEventListener(Event.RESIZE, _alert.stageResizeHandler, false, 0, true);
			_stage.addEventListener(Event.FULLSCREEN, _alert.stageResizeHandler, false, 0, true);
			_stage.addChild(_alert);
			_overlay = new Sprite();
			_alert.addChild(_overlay);
			_overlay.visible = false;											
		}		
		
	//--------------------------------------
	//  Properties
	//--------------------------------------		
		 
		/**
		 * @private 
		 */
		//array containing an object for each alert requested by the createAlert method
		//the object contains parameters for the dialog box
		private static var _alertQueue:Array = [];
		
		/**
		 * @private 
		 */
		private static var _dialogBox:DialogBox;
		
		
		/**
		 * @private 
		 */
		private static var _alert:Alert;

		/**
		 * @private
		 */		
		private static var _stage:Stage;

		/**
		 * @private
		 */
		//used to enforce singleton class
		private static var _allowInstantiation:Boolean = true;
						
		/**
		 * Alpha value of the overlay
		 */		
		public static var overlayAlpha:Number = .2;
		
		/**
		 * The blur value of the parent object when the alert is present and modal
		 */		
		public static var modalBackgroundBlur:int = 2;
		   
   		/**
   		 * Maximum width of the alert
   		 */
		public static var maxWidth:int = 360;

   		/**
   		 * Minimum width of the alert 
   		 */
		public static var minWidth:int = 300;

   		/**
   		 * Padding for the alert
   		 */
		public static var padding:int = 5;

   		/**
   		 * Amount of space between buttons on the alert
   		 */
		public static var buttonSpacing:int = 2;

   		/**
   		 * Amount of space between button rows on the alert
   		 */
		public static var buttonRowSpacing:int = 1;
		
		/**
		 * Height of the buttons on the alert
		 */
		public static var buttonHeight:int = 20;
		
   		/**
   		 * Color of the text for the title bar on the alert
   		 */		
		private static var _titleTextColor:uint;
		
		/**
		 * Gets or sets the text color for the title bar. <strong>Note:</strong> Text color can now be styled by passing 
		 * a <code>TextFormat</code> object to the <code>setTitleBarStyle</code> method.
   		 *
   		 * @deprecated
   		 */		
		public static function get titleTextColor():uint
		{
			Alert.getInstance();
			var tf:TextFormat;
			if(_alert.titleBarStyles.textFormat != null)
			{
				tf = _alert.titleBarStyles.textFormat as TextFormat;		
			}
			else if(_dialogBox.titleBar != null && (_dialogBox.titleBar as UIComponent).getStyle("textFormat") != null)
			{
				tf = (_dialogBox.titleBar as UIComponent).getStyle("textFormat") as TextFormat;
			}
			else
			{
				tf = new TextFormat("_sans", 11, 0xffffff, true, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			}
			return tf.color as uint;
		}
		
		/**
		 * @private (setter)
		 */
		public static function set titleTextColor(value:uint):void
		{
			if(isNaN(value)) return;
			Alert.getInstance();
			var tempTf:TextFormat;
			if(_alert.titleBarStyles.textFormat != null)
			{
				tempTf = _alert.titleBarStyles.textFormat as TextFormat;	
			}
			else if(_dialogBox.titleBar != null && (_dialogBox.titleBar as UIComponent).getStyle("textFormat") != null)
			{
				tempTf = (_dialogBox.titleBar as UIComponent).getStyle("textFormat") as TextFormat;
			}
			else
			{
				tempTf = new TextFormat("_sans", 11, 0xffffff, true, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			}
			Alert.setTitleBarStyle("textFormat", TextUtil.changeTextFormatProps(TextUtil.cloneTextFormat(tempTf), {color:value}));
		}
		
		
   		/**
   		 * Color of the message text on the alert. <strong>Note:</strong> Text color can now be styled by passing a <code>TextFormat</code>
   		 * object to the <code>setMessageBoxStyle</code> method.
   		 *
   		 * @deprecated
   		 */		
		public static function get textColor():uint
		{
			Alert.getInstance();
			var tf:TextFormat;
			if(_alert.messageBoxStyles.textFormat != null)
			{
				tf = _alert.messageBoxStyles.textFormat as TextFormat;		
			}
			else if(_dialogBox.messageBox != null && (_dialogBox.messageBox as UIComponent).getStyle("textFormat") != null)
			{
				tf = (_dialogBox.messageBox as UIComponent).getStyle("textFormat") as TextFormat;
			}
			else
			{
				tf = new TextFormat("_sans", 11, 0xffffff);
			}
			return tf.color as uint;
									
		}
		
		/**
		 * @private (setter)
		 */
		public static function set textColor(value:uint):void
		{
			if(isNaN(value)) return;
			Alert.getInstance();
			var tempTf:TextFormat;
			if(_alert.messageBoxStyles.textFormat != null)
			{
				tempTf = _alert.messageBoxStyles.textFormat as TextFormat;		
			}
			else if(_dialogBox.messageBox != null && (_dialogBox.messageBox as UIComponent).getStyle("textFormat") != null)
			{
				tempTf = (_dialogBox.messageBox as UIComponent).getStyle("textFormat") as TextFormat;
			}
			else
			{
				tempTf =new TextFormat("_sans", 11, 0xffffff);
			}
			Alert.setMessageBoxStyle("textFormat", TextUtil.changeTextFormatProps(TextUtil.cloneTextFormat(tempTf), {color:value}));
		}
		
		/**
		 * Indicates whether the alert has a drop shadow
		 */
		public static var hasDropShadow:Boolean = true;
		
		/**
		 * direction of the alert's drop shadow
		 */
		public static var shadowDirection:String = "right";
		
		/**
		 * @private
		 */
		private static var _overlay:Sprite;
		
		/**
		 * The DisplayObject that uses the createAlert method to display an alert.  The 
		 * Alert 
		 */
		protected var container:DisplayObject;
		
		/**
		 * @private (protected)
		 */	
		//Copy of container's filters property.  Used to return the container to it's original 
		//state when the alert is removed.
		protected var parentFilters:Array;
		
		/**
		 * @private
		 *
		 * Holds styles for TitleBar
		 */
		public var titleBarStyles:Object = {}; 
		
		/**
		 * @private 
		 *
		 * Holds styles for MessageBox
		 */
		public var messageBoxStyles:Object = {}; 
		
		/**
		 * @private
		 *
		 * Holds styles for Buttons
		 */
		private var buttonStyles:Object = {}; 
		
		/**
		 * @private
		 *
		 * Holds styles for DialogBox
		 */
		private var alertStyles:Object = {};
				
		/** 
		 * @private
		 */
		private var _livePreviewTitleBar:Sprite;
 
		/**
		 * @private 
		 */
		private var _livePreviewSkin:Sprite; 

	//--------------------------------------
	//  Public Methods
	//--------------------------------------		

	 	/**
	 	 * Creates an instance of Alert.
	 	 *
	 	 * @param container - display object creating an alert box
	 	 *
	 	 * @return Alert
	 	 */
		public static function getInstance(container:DisplayObject = null):Alert
		{
			if(_alert == null) 
			{
				_allowInstantiation = true;
				_alert = new Alert(container);			
				_allowInstantiation = false;
			}
			return _alert;
		}

		/**
		 * Creates an alert and puts it in the queue.  If it is the first alert or all 
		 * previous alerts have been displayed, it will show the alert.  If this is the 
		 * first alert, the class is instantiated. 
		 *
		 * @param container - display object creating an alert box
		 * @param message - message to be displayed
		 * @param title - text to show in the title bar
		 * @param buttons - array containing the name of the buttons to be displayed
		 * @param callBackFunction - function to be called when a button is pressed
		 * @param iconClass - string value indicating the library object to be used for an icon
		 * @param isModal - boolean indicating whether or not to prevent interaction with the parent while the message box is present
         * @param props - Optional parameters will only affect the single alert instance. Any of the following any of the following 
         * properties can be used:
		 * <br />
		 *  <table class="innertable" width="100%">
		 *  	<tr><th>Property</th><th>Purpose</th></tr>
		 * 		<tr><td>maxWidth</td><td>Indicates the maximum allowed width of the alert.</td></tr>
		 * 		<tr><td>minWidth</td><td>Indicates the minimum allowed width of the alert.</td></tr>
		 * 		<tr><td>padding</td><td>Indicates the amount of padding on the alert.</td></tr>
		 * 		<tr><td>buttonHeight</td><td>Indicates the height of buttons on an alert.</td></tr>
		 * 		<tr><td>buttonSpacing</td><td>Indicates the space between buttons on an alert.</td></tr>
		 * 		<tr><td>hadDropShadow</td><td>Indicates whether or not the alert has a drop shadow.</td></tr>
		 * 		<tr><td>shadowDirection</td><td>Indicates the direction of a drop shadow.</td></tr>
		 * 		<tr><td>titleBarStyles</td><td>Set styles on the title bar of the alert box.</td></tr>		 
		 * 		<tr><td>messageBoxStyles</td><td>Sets styles on the message text field of the alert.</td></tr>
		 * 		<tr><td>buttonStyles</td><td>Styles set on the alert buttons.</td></tr>
		 * 		<tr><td>alertStyles</td><td>Sets styles on the alert.</td></tr>
		 * 		<tr><td>textColor (deprecated)</td><td>Sets the color of the message text. <strong>Note:</code> this property has been
		 * deprecated in favor of using the <code>alertStyles.textFormat</code> style.</td></tr>
		 * 		<tr><td>titleTextColor (deprecated)</td><td>Sets the color of the title text. <strong>Note:</code> this property has 
		 * been deprecated in favor of using the <code>titleBarStyles.textFormat</code> style.</td></tr>	 
		 *  </table>	 
         *
         * @return Alert
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0		 
		 */			
		public static function createAlert(container:DisplayObject, 
							message:String, 
							title:String = "Alert", 
							buttons:Array = null, 
							callBackFunction:Function = null, 
							iconClass:String = null, 
							isModal:Boolean = true,
							props:Object = null):Alert
		{		
			Alert.getInstance(container);
			if(_stage == null) setStage(container.stage);
			if(_dialogBox == null) 
			{
				_dialogBox = new DialogBox(_stage);
				 _alert.addChild(_dialogBox);					
			}
			_alert.copyRendererStylesToChild(_dialogBox.titleBar, _alert.titleBarStyles);
			_alert.copyRendererStylesToChild(_dialogBox.messageBox, _alert.messageBoxStyles);
			_alert.setButtonStyles(_alert.buttonStyles);
			_alert.copyRendererStylesToChild(_dialogBox, _alert.alertStyles);
			
			if(buttons == null) buttons = ["OK"];
			var functions:Array = [];
			if(callBackFunction != null) functions.push(callBackFunction);
			functions.push(_alert.manageQueue);
			var alertParams:Object = {
				message:message, 
				title:title, 
				isModal:isModal, 
				buttons:buttons, 
				functions:functions, 
				iconClass:iconClass, 
				props:props,
				container:container
			};
			
			if(_alertQueue.length == 0)
			{
				_dialogBox.maxWidth = (props != null && !isNaN(props.maxWidth))?Math.round(props.maxWidth) as int:maxWidth;
				_dialogBox.minWidth = (props != null && !isNaN(props.minWidth))?Math.round(props.minWidth) as int:minWidth;
				_dialogBox.padding = (props != null && !isNaN(props.padding))?Math.round(props.padding) as int:padding;
				_dialogBox.buttonHeight = (props != null && !isNaN(props.buttonHeight))?Math.round(props.buttonHeight) as int:buttonHeight;
				_dialogBox.buttonRowSpacing = (props != null && !isNaN(props.buttonRowSpacing))?Math.round(props.buttonRowSpacing) as int:buttonRowSpacing;
				_dialogBox.buttonSpacing = (props != null && !isNaN(props.buttonSpacing))?Math.round(props.buttonSpacing) as int:buttonSpacing;
				_dialogBox.hasDropShadow = (props != null && props.hasDropShadow != null)?props.hasDropShadow:hasDropShadow;
				_dialogBox.shadowDirection = (props != null && props.shadowDirection != null)?props.shadowDirection:shadowDirection;
				if(props != null && props.titleBarStyles != null) _alert.copyRendererStylesToChild(_dialogBox.titleBar, props.titleBarStyles);
				if(props != null && props.messageBoxStyles != null) _alert.copyRendererStylesToChild(_dialogBox.messageBox, props.messageBoxStyles);
				if(props != null && !isNaN(props.textColor)) _dialogBox.messageBox.setStyle("textFormat", _alert.replaceUIComponentTextColor(_dialogBox.messageBox as UIComponent, props.textColor));//Alert.textColor = props.textColor as uint;
				if(props != null && !isNaN(props.titleTextColor)) _dialogBox.titleBar.setStyle("textFormat", _alert.replaceUIComponentTextColor(_dialogBox.titleBar as UIComponent, props.titleTextColor));
				if(props != null && props.buttonStyles != null) _alert.setButtonStyles(props.buttonStyles);
				if(props != null && props.alertStyles != null) _alert.copyRendererStylesToChild(_dialogBox, props.alertStyles);
				_dialogBox.update(message, title, buttons, functions, iconClass);
				_overlay.visible = isModal;
				if(isModal)
				{
					_alert.container = container; 
					var newFilters:Array;
					newFilters = _alert.container.filters.concat();
					 _alert.parentFilters = _alert.container.filters.concat();
					newFilters.push(_alert.getBlurFilter());	
					_alert.container.filters = newFilters;
				}
			}
			
			_alertQueue.push(alertParams);
			
			return _alert;
		}
		
		/**
		 * Removes the current alert from the messages array.  If there are more alerts, 
		 * call pass the params for the next alert to the DialogBox object.  Otherwise, 
		 * hide the alert object and the cover.</p>
		 *
		 * @evnt - Mouse event received from the DialogBox object 
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0		 
		 */ 
		public function manageQueue(evnt:MouseEvent):void
		{		
			_alertQueue.splice(0, 1);
			_alert.container.filters = _alert.parentFilters;
			if(_alertQueue.length > 0)
			{
				_stage.setChildIndex(this, _stage.numChildren - 1);
				var params:Object = _alertQueue[0];
				var props:Object = params.props;
				_dialogBox.maxWidth = (props != null && !isNaN(props.maxWidth))?Math.round(props.maxWidth) as int:maxWidth;
				_dialogBox.minWidth = (props != null && !isNaN(props.minWidth))?Math.round(props.minWidth) as int:minWidth;
				_dialogBox.padding = (props != null && !isNaN(props.padding))?Math.round(props.padding) as int:padding;
				_dialogBox.buttonHeight = (props != null && !isNaN(props.buttonHeight))?Math.round(props.buttonHeight) as int:buttonHeight;
				_dialogBox.buttonRowSpacing = (props != null && !isNaN(props.buttonRowSpacing))?Math.round(props.buttonRowSpacing) as int:buttonRowSpacing;
				_dialogBox.buttonSpacing = (props != null && !isNaN(props.buttonSpacing))?Math.round(props.buttonSpacing) as int:buttonSpacing;						
				_dialogBox.hasDropShadow = (props != null && props.hasDropShadow != null)?props.hasDropShadow:hasDropShadow;
				_dialogBox.shadowDirection = (props != null && props.shadowDirection != null)?props.shadowDirection:shadowDirection;
				if(props != null && props.titleBarStyles != null) _alert.copyRendererStylesToChild(_dialogBox.titleBar, props.titleBarStyles);
				if(props != null && props.messageBoxStyles != null) _alert.copyRendererStylesToChild(_dialogBox.messageBox, props.messageBoxStyles);				
				if(props != null && !isNaN(props.textColor)) _dialogBox.messageBox.setStyle("textFormat", _alert.replaceUIComponentTextColor(_dialogBox.messageBox as UIComponent, props.textColor));//Alert.textColor = props.textColor as uint;
				if(props != null && !isNaN(props.titleTextColor)) _dialogBox.titleBar.setStyle("textFormat", _alert.replaceUIComponentTextColor(_dialogBox.titleBar as UIComponent, props.titleTextColor));	
				if(props != null && props.buttonStyles != null) _alert.setButtonStyles(props.buttonStyles);
				if(props != null && props.alertStyles != null) _alert.copyRendererStylesToChild(_dialogBox, props.alertStyles);
				_dialogBox.update(params.message, params.title, params.buttons, params.functions, params.iconClass);
				_overlay.visible = params.isModal;
				if(params.isModal)
				{
				   _alert.container = params.container; 
					var newFilters:Array;
					newFilters = _alert.container.filters.concat();
					 _alert.parentFilters = _alert.container.filters.concat();
					newFilters.push(_alert.getBlurFilter());	
					_alert.container.filters = newFilters;
				}			
			}
			else
			{
				_dialogBox.visible = false;
				
				_overlay.visible = false;
			}
		}
		
		/**
		 * Gets a blur filter to add to the parent's <code>filters</code> property.
		 *
		 * @return BitmapFilter with specified blur values
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0		 
		 */
		public function getBlurFilter():BitmapFilter
		{
			var blurFilter:BlurFilter = new BlurFilter();
			blurFilter.blurX = modalBackgroundBlur;
			blurFilter.blurY = modalBackgroundBlur;
			blurFilter.quality = BitmapFilterQuality.HIGH;				
			return blurFilter;
		}
		
		/**
		 * Set styles on the TitleBar
		 *
		 * @see com.yahoo.astra.fl.controls.containerClasses.TitleBar		 
		 */
		public static function setTitleBarStyle(name:String, style:Object):void
		{
			Alert.getInstance();
			if (_alert.titleBarStyles[name] == style) return; 
			_alert.titleBarStyles[name] = style;
			if(_dialogBox != null && _dialogBox.titleBar != null) (_dialogBox.titleBar as UIComponent).setStyle(name, style);
		}	
		
		
		/**
		 * Sets styles on a the Alert message
		 * 
		 * @see com.yahoo.astra.fl.controls.containerClasses.MessageBox
		 */
		public static function setMessageBoxStyle(name:String, style:Object):void
		{
			Alert.getInstance();
			if (_alert.messageBoxStyles[name] == style) { return; }
			_alert.messageBoxStyles[name] = style;
			if(_dialogBox != null && _dialogBox.messageBox != null) (_dialogBox.messageBox as UIComponent).setStyle(name, style);			
		}
		
		/**
		 * Sets the styles for buttons
		 *
		 * @see com.yahoo.astra.fl.controls.containerClasses.AutoSizeButton	 
		 */
		public static function setButtonStyle(name:String, style:Object):void
		{
			Alert.getInstance();
			if(_alert.buttonStyles[name] == style) return;
			_alert.buttonStyles[name] = style;
			if(_dialogBox != null && _dialogBox.buttonBar != null) _dialogBox.buttonBar.setButtonStyle(name, style);
		}

		/**
		 * Sets styles for the Alert
		 *
		 * @see com.yahoo.astra.fl.controls.containerClasses.DialogBox	 
		 */
		public static function setAlertStyle(name:String, style:Object):void
		{
			Alert.getInstance();
			if(_alert.alertStyles[name] == style) return;
			_alert.alertStyles[name] = style;
			if(_dialogBox != null) _dialogBox.setStyle(name, style);
		}
		
		
	//--------------------------------------
	//  Protected Methods
	//-------------------------------------
	
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected override function configUI():void
		{
			super.configUI();

		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */	
		//Set the width and height to that of the stage and redraw the cover object. 
		protected override function draw():void
		{
			if(this.isLivePreview) 
			{
				_livePreviewSkin.width = this.width;
				_livePreviewSkin.height = this.height;
				_livePreviewTitleBar.width = this.width;
				_livePreviewTitleBar.height = Math.min(20,this.height/5);
			}
			else
			{
				//set the dimensions
				this.width = _stage.stageWidth;
				this.height = _stage.stageHeight;
				this.x = _stage.x;
				this.y = _stage.y;
				_overlay.x = _overlay.y = 0;
				_overlay.width = this.width;
				_overlay.height = this.height;
				_overlay.graphics.clear();
				_overlay.graphics.beginFill(0xeeeeee, overlayAlpha);
				_overlay.graphics.moveTo(0,0);
				_overlay.graphics.lineTo(this.width, 0);
				_overlay.graphics.lineTo(this.width, this.height);
				_overlay.graphics.lineTo(0, this.height);
				_overlay.graphics.lineTo(0, 0);
				_overlay.graphics.endFill();
				if(_dialogBox != null) _dialogBox.positionAlert();
			}
		}

        /**
         * @private (protected)
         *
         * @param evnt - event fired from the stage
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */			
		//Call the draw function when the stage is resized
		protected function stageResizeHandler(evnt:Event):void
		{
			draw();
		}		
		/**
		 * @private
		 *
		 * @param styleMap - styles to be set on the buttonBar instance
		 */
		private function setButtonStyles(styleMap:Object):void
		{
			for(var n:String in styleMap)
			{
				_dialogBox.buttonBar.setButtonStyle(n, styleMap[n])
			}
		}
		
		/**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function copyRendererStylesToChild(child:UIComponent,styleMap:Object):void 
		{
			for (var n:String in styleMap) 
			{
				child.setStyle(n, styleMap[n]);
			}
		}	
		
		/**
		 * @private
		 * Helper function used to handle deprecated text color properties
		 */
		private function replaceUIComponentTextColor(ui:UIComponent, value:uint):TextFormat
		{
			var tempTf:TextFormat;
			if(ui != null && ui.getStyle("textFormat") != null)
			{
				tempTf = ui.getStyle("textFormat") as TextFormat;		
			}
			else
			{
				tempTf = new TextFormat("_sans", 11, value);
			}
			return TextUtil.changeTextFormatProps(TextUtil.cloneTextFormat(tempTf), {color:value});
		}		
	}
}