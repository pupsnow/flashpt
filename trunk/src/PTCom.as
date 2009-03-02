package {
	import fl.controls.Label;
	import fl.data.DataProvider;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.LocalConnection;
	
	import pt.containers.containersClasses.DialogBox;
	import pt.containers.containersClasses.MessageBox;
	import pt.controls.AutoSizeButton;
	import pt.controls.TabBar;
	import pt.effects.TweenLite;

	public class PTCom extends Sprite
	{ private var  buttonBar:TabBar;
	  private var btn:AutoSizeButton;
	  private var messageBox:MessageBox;
	  private var dialogBox:DialogBox;
	  private var label:Label;
		public function PTCom()
		{
			btn=new AutoSizeButton();
			btn.label="测试按钮这个是我的";
			this.addChild(btn);
			btn.move(300,0);
			btn.addEventListener(MouseEvent.CLICK,clickHander);
			var items:Array = [
			{label:"热         门", data:"11/19/1995"},
			{label:"国         产", data:"4/20/1993"},
			{label:"日         韩", data:"4/20/1993"},
			{label:"欧         美", data:"9/06/1997"},
			{label:"最近     观看", data:"9/06/1997"},
			{label:"收         藏", data:"9/06/1997"},
			{label:"搜         索", data:"9/06/1997"}]
			
			 buttonBar=new  TabBar();
			 buttonBar.dataProvider=new DataProvider(items);	
			 buttonBar.setSize(200,200);
			 buttonBar.width=400;
			 buttonBar.height=50;
			 this.addChild(buttonBar);
			 
			 			 
			 messageBox=new MessageBox();
			 
			  label=new Label();
			  label.text="wo de nifhgifhgifjhifgjhifgjhifgjiggg";			
			  messageBox.addChild(label);
			 
			 this.addChild(messageBox);
			 
			 
			 dialogBox=new DialogBox(this.stage);
			 this.addChild(dialogBox);
		 //	var autobtn:AutoSizeButton=new AutoSizeButton()
			 
			
		}
		private function clickHander(event:MouseEvent):void
		{ TweenLite.to(btn, 1, {x:46, y:43});
			
//		{   buttonBar.dataProvider =new DataProvider(null);
//			this.removeChild(buttonBar);
//			buttonBar=null;
//			btn.removeEventListener(MouseEvent.CLICK,clickHander);
//			this.removeChild(btn);
//			btn=null;
//			this.removeChild(messageBox);
//			messageBox=null;
//			this.removeChild(dialogBox);
//			dialogBox=null;
//			var  alert:Alert=new Alert();
//			alert=Alert.createAlert(this,"df");
			//GC();		
		}
		/**
		 *强制回收。 
		 * 
		 */		
		private function GC():void
	        {	    	
		    	try 
					{
						var lc1:LocalConnection = new LocalConnection();
						var lc2:LocalConnection = new LocalConnection();
			
						lc1.connect('name');
						lc2.connect('name');
					}
				catch (e:Error)
					{
						
					}
	    }
	}
}