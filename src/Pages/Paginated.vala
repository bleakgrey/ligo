using Gee;

public class Ligo.Pages.Paginated : Pages.Base {

	public int64 items_per_page {get; set;}
	public Gee.List<Base> items {get; set;}
	public Pages.Base? prev {get; set;}
	public Pages.Base? next {get; set;}
	public Paginator? paginator {get; set;}

	construct {
		items_per_page = 10;
		items = new ArrayList<Base> ();
		prev = null;
		next = null;
	}

	public Paginated () {}

	public override void write_save_data (ref Json.Builder builder) {
		base.write_save_data (ref builder);
		builder.set_member_name ("items_per_page");
		builder.add_int_value (items_per_page);
	}
	
	public override void read_save_data (ref Json.Object data) {
		base.read_save_data (ref data);
		items_per_page = data.get_int_member ("items_per_page");
	}

	public override void inject_schema (Json.Builder schema) {
		base.inject_schema (schema);
		
		if (children.size > 0) {
			paginator = new Paginator (this, children, items_per_page);
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
			if (article == null)
				return true;
			
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
			schema.add_string_value (page.get_relative_url (this));
			schema.end_object ();
			return true;
		});
		schema.end_array ();
	}

	public override void build_settings (Widgets.PageSettings settings) {
		base.build_settings (settings);
		
		settings.add_section (_("Pagination"));
		var pages_entry = new Widgets.Forms.IntSpinner (this, "items_per_page", 1, 20);
		settings.add_widget (pages_entry, _("Max Items:"));
	}

}
