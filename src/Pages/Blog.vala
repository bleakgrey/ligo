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

	public override void inject_schema (Json.Builder schema) {
		base.inject_schema (schema);
		schema.set_member_name ("pagination");
		schema.begin_object ();
		schema.set_member_name ("prev_page_url");
		schema.add_string_value ("#");
		schema.set_member_name ("next_page_url");
		schema.add_string_value ("#");
		
		schema.set_member_name ("items");
		schema.begin_array ();
		children.@foreach (page => {
			var article = page as BlogArticle;
			schema.begin_object ();
			schema.set_member_name ("name");
			schema.add_string_value (article.name);
			schema.set_member_name ("description");
			schema.add_string_value (article.description);
			schema.set_member_name ("date");
			schema.add_string_value (article.date);
			schema.set_member_name ("content");
			schema.add_string_value (article.render_markdown ());
			schema.set_member_name ("url");
			schema.add_string_value (page.get_url ());
			schema.end_object ();
			return true;
		});
		schema.end_array ();
		
		schema.end_object ();
	}

}
