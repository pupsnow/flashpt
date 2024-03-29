package  pt.containers.containersClasses
{
	
	/**
	* 标题栏，可以加背景。用在DialogBox上部显示标题。
	*/	
	import fl.controls.Label;
	import fl.core.InvalidationType;
	import fl.events.ComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import pt.utils.InstanceFactory;
	import pt.utils.UIComponentUtil;
		
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
   [Style(name="backgroundSkin", type="Class", inherit="no")]  
   
   [Style(name="textFormat", type="TextFormat", inherit="no")]
   
	public class TitleBar extends Label
	{

	//--------------------------------------
	//  Constructor
	//--------------------------------------	
	
		/**
		* Constructor
		*/
		public function TitleBar()
		{
			super();
			this.setTitleBarStyles();
		}		

	//--------------------------------------
	//  Properties
	//--------------------------------------		
		
		/**
		 * @private (protected)
		 */
		//background for the title bar
		protected var background:DisplayObject;
		
		/**
		 * Maximum width of the TitleBar instance
		 */
		public var maxWidth:int;		
		
		/**
		 * @private
		 * Default style values for the titlebar
		 */
		private static var defaultStyles:Object = 
		{
			backgroundSkin:"Title_skin",
			textFormat:new TextFormat("_sans", 11, 0xffffff, true, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)
		};
		
		/**
		 * @private
		 * Styles for titlebar
		 */
		private const TITLEBAR_STYLES:Object =
		{
			backgroundSkin:"backgroundSkin",
			textFormat:"textFormat"
		}
		
		/**
		 * @private
		 */
		private var _titleText:String = "";
			
		/**
		 * @private (setter)；
		 * override label set text adding setStyle
		 */		
		override public function set text(value:String):void
		{
			if (value == this.text) return;
			// Clear the HTML value, and redraw.
			_html = false;
			_titleText = value;
				
			textField.text = _titleText;
		
			// Value in the PI is the default.
			if (componentInspectorSetting && value == defaultLabel) 
			{
				return;
			}
			
			if (textField.autoSize != TextFieldAutoSize.NONE) 
			{ 
				invalidate(InvalidationType.SIZE);
			}
		}
		
		/**
		 * @private (setter)
		 *
		 */	
		override public function get height():Number
		{
			var ht:Number = actualHeight;
			if(!isNaN(ht)) ht = _height;
			if(!isNaN(ht)) ht = this.textField.height;
			return _height;
		}		
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------				
		
		/**
		 * @return defaultStyles
		 */
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles);
		}	
		
		/**
		 * Resizes the background skin
		 *
		 * @param wid - width to set the background

		 */	
		public function drawBackground(wid:Number):void
		{
			if(this.background != getDisplayObjectInstance(getStyleValue("backgroundSkin")))
			{
				if(this.getChildAt(0) == this.background) this.removeChild(this.background);				 
				this.background = getDisplayObjectInstance(getStyleValue("backgroundSkin"));
				this.addChildAt(background, 0);
			}
			if(this.background != null)
			{
				this.background.width = wid;	
				this.background.height = _height;
			}
		}
		
		/**
		 * @public
         *
		 * @copy fl.core.UIComponent#setStyle()
         *          

		 */			
		override public function setStyle(style:String, value:Object):void {
			//Use strict equality so we can set a style to null ... so if the instanceStyles[style] == undefined, null is still set.
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
	//  Protected methods
	//--------------------------------------				
				
		/**
		 * @private (protected)
		 *

		 */			 
		override protected function configUI():void
		{
			super.configUI();
			this.textField.mouseEnabled = false;
			this.wordWrap = false;
			this.textField.autoSize = TextFieldAutoSize.LEFT;
		}	
		
		/**
		 * @private (protected)
		 *

		 */
		 //Truncate the text field and call drawLayout if the text width is greater than  
		 //the maxWidth.  If not, dispatch the resize event
		override protected function drawLayout():void 
		{
			var resized:Boolean = false;
			
			textField.width = width;
			textField.height = height;			
			
			if (textField.autoSize != TextFieldAutoSize.NONE) 
			{
				
				var txtW:Number = textField.width;
				var txtH:Number = textField.height;
				
				resized = (_width != txtW || _height != txtH);				
				// set the properties directly, so we don't trigger a callLater:
				_width = txtW;
				_height = txtH;
				
				switch (textField.autoSize) 
				{
					case TextFieldAutoSize.CENTER:
						textField.x = (actualWidth/2)-(textField.width/2);
						break;
					case TextFieldAutoSize.LEFT:
						textField.x = 0;
						break;
					case TextFieldAutoSize.RIGHT:
						textField.x = -(textField.width - actualWidth);
						break;
				}
			} 
			else 
			{
				textField.width = actualWidth;
				textField.height = actualHeight;
				textField.x = 0;	
			}

			if(!isNaN(_width) && !isNaN(maxWidth) && maxWidth > 0 && _width > 0 &&  _width > maxWidth)
			{
				var truncatedText:String;					
				var tempText:String = _titleText;
				truncatedText = (tempText.lastIndexOf(" ") > 0)?tempText.slice(0, tempText.lastIndexOf(" ")) + "...":tempText.slice(0, this.textField.getCharIndexAtPoint(maxWidth, Math.round(_height/2)) - 3) + "...";
				textField.text = truncatedText;
				drawLayout();
			}
			else
			{
				dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE, true));
			}				
		}
		
		/**
		 * @private
		 *
		 * Set the styles for title bar
		 */
		private function setTitleBarStyles():void
		{
			for(var i:String in TITLEBAR_STYLES)
			{
				this.setStyle(TITLEBAR_STYLES[i], defaultStyles[i]);
			}
		}		
	}
}