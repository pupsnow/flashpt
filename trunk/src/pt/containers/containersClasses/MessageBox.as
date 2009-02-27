/**
 *2009-2-27
 * V-1 
 */
package  pt.containers.containersClasses
{
	import fl.core.UIComponent;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	//--------------------------------------
	//  Styles
	//--------------------------------------
	
   /**
    * 文字样式.
    *
    * @默认为TextFormat("_sans", 11, 0xffffff)
    */
   [Style(name="textFormat", type="TextFormat", inherit="no")]
   
	//--------------------------------------
	//  Class description
	//--------------------------------------

	/**
	 * MessageBox extends UIComponent and creates a 
	 * text field based on minimum and 
	 * maximum widths
	 */	
	public class MessageBox extends UIComponent
	{

	//--------------------------------------
	//  Constructor
	//--------------------------------------

		/**
		 * Constructor
		 * TextFieldAutoSize 类是在设置 TextField 类的 
		 * autoSize 属性时使用的常数值的枚举。
		 */
		public function MessageBox()
		{
			_textField = new TextField();
			_autoSizeStyle = TextFieldAutoSize.CENTER;//将指定文本设置为居中对齐文本。
			this.setStyle("textFormat", defaultStyles["textFormat"] as TextFormat);//设置默认文本样式
		}

	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private (protected)
		 */
		protected var _textField:TextField;	
		
		/**
		 * Gets the value of the text field. (read-only)
		 */
		public function get textField():TextField
		{
			return _textField;
		}		
		
		/**
		 * @private (protected)
		 */		
		protected var _autoSizeStyle:String;
		
		/**
		 * Gets or sets autoSizeStyle
		 */
		public function get autoSizeStyle():String
		{
			return _autoSizeStyle;	
		}
		
		/**
		 * @private (setter)
		 */	
		public function set autoSizeStyle(value:String):void {_autoSizeStyle = value;}		
		
		/**
		 * @private
		 */
		private var defaultStyles:Object = 
		{
			textFormat:new TextFormat("_sans", 11, 0xffffff)
		}
		 
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------		

		/**
		 * Displays the message text and updates the height 
		 * of the MessageBox
		 * @param maxTextWidth - maximum width allowed for textfield		 
		 * @param minTextWidth - minimum width allowed for textfield
		 * @param messageText - string to display in the text field
		 */ 
		public function drawMessage(maxTextWidth:int, minTextWidth:int, messageText:String):void
		{
			var textFieldWidth:int = getTextFieldWidth(messageText, maxTextWidth, minTextWidth);
			_textField.multiline = false;
			_textField.wordWrap = true;
			_textField.autoSize = _autoSizeStyle;
			_textField.width = textFieldWidth;
			_textField.height = 5;
			var tF:TextFormat = getStyle("textFormat") as TextFormat;
			tF.align = _autoSizeStyle;
			_textField.defaultTextFormat = tF;//指定应用于新插入文本的格式。 
			_textField.text = messageText;
			this.width = _textField.width;
		}
	
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 *
		 * @private (protected)
		 * 得到 text field 的 宽度.
		 *
		 * @param message - text to use
		 * @param maxTextWidth - maximum width allowed for textfield		 
		 *
		 * @return int
		 */
		 
		protected function getTextFieldWidth(message:String, maxTextWidth:int, minTextWidth:int):int
		{
			var textFieldWidth:int;
			var tempText:TextField = new TextField();
			var tF:TextFormat = new TextFormat("_sans", 11);
			tF.align = _autoSizeStyle;	
			tempText.defaultTextFormat = this.getStyle("textFormat") as TextFormat;			
			tempText.width = 10;
			tempText.height = 5;
			tempText.wordWrap = false;//指定文本是否自动换行；
			tempText.multiline = false;//指示文本字段是否为多行文本字段;
			tempText.antiAliasType=AntiAliasType.ADVANCED;//消除锯齿；。。。
			tempText.autoSize = TextFieldAutoSize.LEFT;//控制文本字段的自动大小调整和对齐
			tempText.text = message;
			var tempTextWidth:int = Math.round(tempText.width);
			if(tempTextWidth > maxTextWidth)
			{
				textFieldWidth = maxTextWidth;				
			}
			else if(tempTextWidth > minTextWidth)
			{
				textFieldWidth = tempTextWidth;
			}
			else
			{
				textFieldWidth = minTextWidth;
			}		
			if(_autoSizeStyle == TextFieldAutoSize.LEFT) textFieldWidth += 1;
			return textFieldWidth;			
		}		
	}
}