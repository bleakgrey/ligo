using Gee;

public class Ligo.Pages.Paginated : Pages.Base {

	public int articles_per_page {get; set;}
	public Gee.List<Base> items {get; set;}
	public Pages.Base? prev {get; set;}
	public Pages.Base? next {get; set;}

	construct {
		articles_per_page = 1;
		items = new ArrayList<Base> ();
		prev = null;
		next = null;
	}

	public Paginated () {}

	public override void inject_schema (Json.Builder schema) {
		base.inject_schema (schema);
		
		if (children.size > 0) {
			var paginator = new Paginator (this, children, articles_per_page);
			paginator.collate ();
		}
		
		if (prev != null) {
			schema.set_member_name ("prev_url");
			schema.add_string_value (prev.get_relative_url (this));
		}
		if (next != null) {
			schema.set_member_name ("next_url");
			schema.add_string_value (next.get_relative_url (this));
		}
		
		schema.set_member_name ("items");
		schema.begin_array ();
		items.@foreach (page => {
			var article = page as BlogArticle;
			schema.begin_object ();
			schema.set_member_name ("name");
			schema.add_string_value (article.name);
			schema.set_member_name ("description");
			schema.add_string_value (article.description);
			schema.set_member_name ("date");
			var localized_date = new DateTime.from_unix_local (article.date).format (Widgets.Forms.DatePicker.FORMAT);
			schema.add_string_value (localized_date);
			schema.set_member_name ("content");
			schema.add_string_value (article.render_markdown ());
			schema.set_member_name ("url");
			schema.add_string_value (page.get_url ());
			schema.end_object ();
			return true;
		});
		schema.end_array ();
	}

}
