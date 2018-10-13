using Gee;

public class Ligo.Pages.BlogArticle : Pages.Text {
	
	public new const string TYPE = "blog_article";
	
	public string date;
	
	construct {
		date = "Unknown Date";
		show_in_navigation = false;
		is_home = false;
		//icon_name = "document-edit";
	}
	
	public BlogArticle () {}
	
	public override string get_display_type () {
		return _("Article");
	}
	
	public override string get_page_type () {
		return TYPE;
	}
	
}
