package pt.controls
{
	import fl.controls.Button;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import fl.managers.IFocusManagerComponent;	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;	
	import pt.events.ButtonBarEvent;
	public class TabBar extends  UIComponent  implements IFocusManagerComponent
	{  
	   /**
	    *按钮的排列方向，竖排及横排。默认的时候显示为竖排。 
	    */	  
	   public  var direction:String;
	   [Inspectable()]
	   public  var space:Number=3;//按钮与按钮之间的距离、
	   private var _livePreviewMessage:Button;//当没有数据的时候显示信息；
	   /**
		 * @private
		 * Storage for the selectionFollowsFocus property.
		 */
		private var _selectionFollowsFocus:Boolean = true;
		
		[Inspectable(defaultValue=true)]
		/**
		 * If true, selection will follow keyboard focus. If false, a tab
		 * must be manually selected after changing keyboard focus.
		 */
		public function get selectionFollowsKeyboardFocus():Boolean
		{
			return this._selectionFollowsFocus;
		}
		
		/**
         * @private
		 */
		public function set selectionFollowsKeyboardFocus(value:Boolean):void
		{
			if(this._selectionFollowsFocus != value)
			{
				this._selectionFollowsFocus = value;
				this.invalidate();
			}
		}
		 /**
		 * @private
		 * 重绘的时候。按钮保存在里面以便重用；
		 * When redrawing, buttons are saved in this cache for reuse.
		 */
		protected var _cachedButtons:Array = [];
		
		/**
		 * @private
		 * 保存在Button里面显示的按钮
		 */
		protected var buttons:Array = [];
		protected var _labelFunction:Function = null;
		public function get labelFunction():Function
		{
			return this._labelFunction;	
		}
		
		/**
         * @private
		 */
		public function set labelFunction(value:Function):void
		{
			if(this._labelFunction != value)
			{
				this._labelFunction = value;
				this.invalidate(InvalidationType.DATA);
			}
		}
		/**
		 * 
		 * @param item
		 * @return 
		 * 
		 */		
		public function itemToIndex(item:Object):int
		{
			return this._dataProvider.getItemIndex(item);
		}
		/**
		 * 
		 * @param item
		 * @return 
		 * 
		 */		
		public function itemToLabel(item:Object):String
		{
			if(this.labelFunction != null)
			{
				this.labelFunction(item, this.itemToIndex(item));
			}
			else if(this.labelField && item.hasOwnProperty(this.labelField))
			{
				return item[this.labelField];
			}
			return "";
		}
		
		
		protected var _labelField:String = "label";
		
		[Inspectable(defaultValue="label")]
		
		public function get labelField():String
		{
			return this._labelField;	
		}
		
		/**
         * @private
		 */
		public function set labelField(value:String):void
		{
			if(this._labelField != value)
			{
				this._labelField = value;
				this.invalidate(InvalidationType.DATA);
			}
		}	
		/**
		 * @private
		 * Storage for the autoSizeTabsToTextWidth property.
		 */
		private var _autoSizeTabsToTextWidth:Boolean = true;
		
		[Inspectable(defaultValue=false)]
		/**
		 * If true, the width value of the TabBar will be ignored. The tabs
		 * will determine their size based on the size of the text they display.
		 * If false, the tabs will stay in the bounds of the TabBar. The text
		 * may be truncated.
		 */
		public function get autoSizeTabsToTextWidth():Boolean
		{
			return this._autoSizeTabsToTextWidth;
		}		
		/**
         * @private
		 */
		public function set autoSizeTabsToTextWidth(value:Boolean):void
		{
			if(this._autoSizeTabsToTextWidth != value)
			{
				this._autoSizeTabsToTextWidth = value;
				this.invalidate();
			}
		}
			/**
			 *样式 
			 */		
		 	private static const TAB_STYLES:Object = 
		     {
				embedFonts: "embedFonts",
				disabledTextFormat: "disabledTextFormat",
				textFormat: "textFormat",
				selectedTextFormat: "selectedTextFormat",
				textPadding: "textPadding"
	    	 };
			protected var rendererStyles:Object = {};
		 /**
		  * _dataProvider
		  */		
		 protected var _dataProvider:DataProvider;
	
	     public function get dataProvider():DataProvider
		{
			return this._dataProvider;
		}
		
		[Collection(collectionClass="fl.data.DataProvider", collectionItem="fl.data.SimpleCollectionItem", identifier="item")]
		/**
         * @private
		 */
		 public function set dataProvider(value:DataProvider):void
		 {
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE, dataChangeHandler);
			}
			
			this._dataProvider = value;
			
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, dataChangeHandler, false, 0, true);
			}
			
			this.invalidate(InvalidationType.DATA);
		}
		
		/**
		 *数据改变时执行； 
		 * @param event
		 * 
		 */		
		private function dataChangeHandler(event:DataChangeEvent):void
		{
			this.invalidate(InvalidationType.DATA);
		}
		 public var _focusIndex:int=-1;
		 public function get focusIndex():int
		{
			return this._focusIndex;
		}
		
		/**
		 * @private
		 */
		public function set focusIndex(value:int):void
		{
			this._focusIndex = value;
			this.invalidate("focus");
				
			//internal event used for accessibility
			//similar implementation in Flex TabBar control.
			this.dispatchEvent(new Event("focusUpdate"));
		}
		 public var _selectedIndex:int=-1;
		 [Inspectable]
		 public function get selectedIndex():int
		 {
			return this._selectedIndex;
		 }
		 public function set selectedIndex(value:int):void
		 {
			if(value < 0 || value >= this._dataProvider.length)
			{
				value = -1;
			}
			
			if(this._selectedIndex != value)
			{
				this._selectedIndex = value;
				this.focusIndex = value;
				this.invalidate();
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		public function TabBar()
		{
			super();
			//this.focusEnabled=true;
			if (dataProvider == null) {
				   dataProvider = new DataProvider(); 
				 }
			//this.addEventListener(KeyboardEvent.KEY_DOWN,KeyDownHander);
		}
		
		
		override  protected function configUI():void
		{
			super.configUI();
			if(this.isLivePreview)//在还没有添加数据的时候显示；
			{
			   this._livePreviewMessage=new Button();
			   this._livePreviewMessage.label="ButtonBar";
			   this.addChild(_livePreviewMessage);
			   
			}
		}
		/**
		 *复写draw方法。当数据变化的时候改变按钮个数 
		 * 
		 */		
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(InvalidationType.DATA);
			if(dataInvalid)
		 	 {   this.createCache();
		 	     if(this._dataProvider)
		 	     {
			 	    updateButtons();
		 	     }
		 	     this.clearCache();
			 }
			this.drawButtons();		
			super.draw();
		}		
		/**
		 * @private
		 * 
		 * Saves the buttons from the last redraw so that they may be reused.
		 */
		protected function createCache():void
		{
			this._cachedButtons = this.buttons.concat();
			this.buttons = [];
		}
		/**
		 * @private
		 * 删除被缓存重绘的 不需要的按钮。并移出相应的事件；
		 * Removes unneeded buttons that were cached for a redraw.
		 */
		protected function clearCache():void
		{
			var cacheLength:int = this._cachedButtons.length;
			for(var i:int = 0; i < cacheLength; i++)
			{
				var button:Button = this._cachedButtons.pop() as  Button;
				button.removeEventListener(Event.CHANGE, buttonChangeHandler);
				button.removeEventListener(MouseEvent.CLICK, buttonClickHandler);				
				this.removeChild(button);
				button=null;
			}
		}
				
		/**
		 *chang事件； 点击不同按钮的时候。切换selectedIndex；
		 * @param event
		 * 
		 */		
		protected function  buttonChangeHandler(event:Event):void
		{
			var changedButton:Button=event.target as Button;
			if(changedButton.selected)
			{
				var index:int = this.buttons.indexOf(changedButton);
				this.selectedIndex = index;
			}
			
		}
		/**
		 *点击事件 派发ITEM_CLICK事件；
		 * @param event
		 * 
		 */		
		protected function buttonClickHandler(event:MouseEvent):void
		{
			
		   var button:Button = event.currentTarget as Button;
			var index:int = this.buttons.indexOf(button);
			var item:Object = this._dataProvider.getItemAt(index);
			this.dispatchEvent(new ButtonBarEvent(ButtonBarEvent.ITEM_CLICK, false, false));
		}
		/**
		 *更新按钮属性； 
		 * 
		 */		
		protected function updateButtons():void
		{  if(this.dataProvider!=null)
		    {
				  var buttonCount:int=this.dataProvider.length;
				  for (var i:int=0;i<buttonCount;i++)
				  {
				    var button:Button=this.getButton();
				    this.buttons.push(button);				   			   
				    var item:Object = this._dataProvider.getItemAt(i);
					button.label = this.itemToLabel(item);
					button.buttonMode = this.buttonMode;
					button.useHandCursor = this.useHandCursor;
				  }
			 }
			
		}
		/**
		 *要么检索一个按钮。要么新建一个按钮。 
		 * @return 
		 * 
		 */		
		protected function getButton():Button
		{
			 var button:Button;
			 if(this._cachedButtons.length>0)
			 {
			 	button = this._cachedButtons.shift() as  Button;
			 }
			 else
			 {
			 	button=new Button();
			 	button.toggle=true;
			 	button.focusEnabled=false;
			 	button.addEventListener(Event.CHANGE, buttonChangeHandler, false, 0, true);
				button.addEventListener(MouseEvent.CLICK, buttonClickHandler, false, 0, true);
			 	this.addChild(button);
			 }
			 return button;
		}		
		 /**
		 *按钮的位置和大小；
		 * 
		 */		
		protected function drawButtons():void
		{
			var stylesInvalid:Boolean = this.isInvalid(InvalidationType.STYLES);
			var rendererStylesInvalid:Boolean = this.isInvalid(InvalidationType.RENDERER_STYLES);
			
			var xPosition:Number = 100;
			var yPosition:Number = 0;
			var buttonCount:int = this.buttons.length;
			for(var i:int = 0; i < buttonCount; i++)
			{
				var button:Button = Button(this.buttons[i]);
				button.selected = this._selectedIndex == i;
				button.enabled = this.enabled;
				if(i == this._focusIndex)
				{
					button.setMouseState("over");
				}
				else
				{
					button.setMouseState("up");
				}
				
				if(stylesInvalid)
				{
					this.copyStylesToChild(button, TAB_STYLES);
				}
				
				if(rendererStylesInvalid)
				{
					for(var prop:String in this.rendererStyles)
					{
						button.setStyle(prop, this.rendererStyles[prop]);
					}
				}
				button.y = yPosition;
			   //button.width = NaN; //always auto-size at first???????????????
				button.height = this.height;
				button.drawNow();
				yPosition += (button.height+this.space);
			}
			
			if(this.autoSizeTabsToTextWidth)
			{
				//width changes automatically based on the size of the tabs.
				this._width = xPosition;
			}
			else
			{
				//we need to fit the tabs into the specified bounds
				var totalWidth:Number = xPosition;
				xPosition = 0;
				var totalHeight:Number = yPosition;
					yPosition =0;
				for(i = 0; i < buttonCount; i++)
				{
					button = Button(this.buttons[i]);
					button.y = yPosition;
					button.width = this.width * (button.width / totalWidth);
					button.drawNow();
					yPosition += (button.height+this.space); 
				}
			}
			
			if(rendererStylesInvalid)
			{
				//clear old renderer styles
				for(prop in this.rendererStyles)
				{
					if(this.rendererStyles[prop] == null)
					{
						delete this.rendererStyles[prop];
					}
				}
			}
		}
		/**
		 *键盘事件。左右移动，改变选中按钮； 
		 * @param event
		 * 
		 */		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
				switch (event.keyCode)
				{
					case Keyboard.UP:
					case Keyboard.LEFT:					
					index = (this.focusIndex == 0) ? (this.numChildren - 1) : (this.focusIndex - 1);
					if(this.selectionFollowsKeyboardFocus)
					{
						this.selectedIndex = index;
					}
					else
					{
						this.focusIndex = index;
					}
					break;
					case Keyboard.DOWN:
					case Keyboard.RIGHT:
					   var index:int = (this.focusIndex == this.numChildren - 1) ? 0 : (this.focusIndex + 1);
						if(this.selectionFollowsKeyboardFocus)
						{
							this.selectedIndex = index;
						}
						else
						{
							this.focusIndex = index;
						}
					 break;
				}		
		}		 
	}
}