public class Ligo.Pages.Blog : Pages.Base {
	
	public new const string TYPE = "blog";
	
	public Blog () {
		base ();
	}
	
	public override Widgets.Tabs.Base? create_tab () {
		return new Widgets.Tabs.BlogEditor (this);
	}
	
	public override void read_save_data (Json.Object data) {}
	
}
