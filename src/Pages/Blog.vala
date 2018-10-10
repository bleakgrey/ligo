public class Ligo.Pages.Blog : Pages.Base {
	
	public new const string TYPE = "blog";
	
	public Blog () {
		base ();
	}
	
	protected override string get_page_type () {
		return TYPE;
	}
	
	public override Widgets.Tabs.Base? create_tab () {
		return new Widgets.Tabs.BlogEditor (this);
	}
	
}
