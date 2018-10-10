public class Desidia.Pages.Blog : Pages.Base {
	
	public new const string TYPE = "blog";
	
	public Blog () {
		base ();
		//purpose = "blog";
	}
	
	public override Widgets.Tabs.Base? create_tab () {
		return new Widgets.Tabs.BlogEditor (this);
	}
	
}
