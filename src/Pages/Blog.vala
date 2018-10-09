public class Desidia.Pages.Blog : Pages.Base {
	
	public Blog () {
		base ();
	}
	
	public override Widgets.Tabs.Base? create_tab () {
		return new Widgets.Tabs.BlogEditor (this);
	}
	
}
