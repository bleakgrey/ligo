using Gee;

public class Ligo.Pages.Blog : Pages.Base {
	
	public new const string TYPE = "blog";
	
	construct {
		icon_name = "document-edit";
	}
	
	public Blog () {}
	
	public override string get_display_type () {
		return _("Blog");
	}
	
	public override string get_page_type () {
		return TYPE;
	}
	
	public override Widgets.Tabs.Base? create_tab () {
		return new Widgets.Tabs.BlogEditor (this);
	}
	
}
