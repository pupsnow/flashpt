   package  pt.controls
  {
      /**
	 *2009-2-27
	 *根据文字改变大小的按钮
	*/  	
	import fl.controls.Button;
	import fl.core.InvalidationType;
	import fl.events.ComponentEvent;
	
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import pt.utils.InstanceFactory;
	import pt.utils.UIComponentUtil;

	public class AutoSizeButton extends Button
	{
			
		public function AutoSizeButton()
		{
			super();
		}			
		/**
		 * @private 默认样式显示按钮的样式；
		 */
		private static var defaultStyles:Object =
		{
			focusRectPadding: 1,
			icon: null,
			upSkin: "Button_upSkin",
			downSkin: "Button_downSkin",
			overSkin: "Button_overSkin",
			disabledSkin: "Button_disabledSkin",
			selectedUpSkin: "Button_selectedUpSkin",
			selectedDownSkin: "Button_selectedUpSkin",
			selectedOverSkin: "Button_selectedUpSkin",
			selectedDisabledSkin: "Button_selectedDisabledSkin",
			focusRectSkin: "focusRectSkin",
			textPadding: 10,
			verticalTextPadding: 2,
			textFormat:null, 
			disabledTextFormat:null,
			embedFonts:false			
		};	
		
		public static function getStyleDefinition():Object
		{
			return defaultStyles;
		}

		/**
		 * 
		 * 根据文字改变按钮的大小。
		 */
		override public function set label(value:String):void
		{
			this._label = value;
		}		
		/**
		 * @private (protected)
		 * 定义根据文字而不是根据avatar来改变尺寸；
		 */
		override protected function configUI():void
		{
			super.configUI();
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this.setStyle("focusRectPadding", getStyleDefinition().focusRectPadding);
		}
		
		/**
		 * @private (protected)
		 */
		override protected function draw():void
		{
			if(this.textField.text != this._label)
			{
				this.textField.text = this._label;
				this.width = this.textField.width + (this.getStyleValue("textPadding") as Number) * 2;
				this.dispatchEvent(new ComponentEvent(ComponentEvent.LABEL_CHANGE));
			}
			super.draw();
			this.drawFocus(isFocused);
		}
		
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
		
	}

}