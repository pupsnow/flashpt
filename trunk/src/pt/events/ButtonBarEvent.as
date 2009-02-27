package pt.events
{
	/**
	* ButtonBar的事件
	*/	
	import flash.events.Event;

	public class ButtonBarEvent extends Event
	{   
		
		public static const CHANG:String="chang";
		public static const ITEM_CLICK:String="item_click";
		public function ButtonBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}