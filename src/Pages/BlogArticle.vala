using Gee;

public class Ligo.Pages.BlogArticle : Pages.Text {
	
	public new const string TYPE = "blog_article";
	
	public string description {get; set;}
	public int64 date {get; set;}
	public bool draft {get; set;}
	
	construct {
		date = new DateTime.now_local ().to_unix ();
		description = "";
		show_in_navigation = false;
		is_home = false;
		draft = false;
	}
	
	public BlogArticle () {}
	
	public override string get_display_type () {
		return _("Blog Article");
	}
	
	public override string get_page_type () {
		return TYPE;
	}
	
	public override void write_save_data (ref Json.Builder builder) {
		base.write_save_data (ref builder);
		builder.set_member_name ("description");
		builder.add_string_value (description);
		builder.set_member_name ("date");
		builder.add_int_value (date);
		builder.set_member_name ("draft");
		builder.add_boolean_value (draft);
	}
	
	public override void read_save_data (ref Json.Object data) {
		base.read_save_data (ref data);
		description = data.get_string_member ("description");
		date = data.get_int_member ("date");
		draft = data.get_boolean_member ("draft");
	}
	
	public override void inject_schema (Json.Builder schema) {
		base.inject_schema (schema);
		schema.set_member_name ("description");
		schema.add_string_value (description);
		schema.set_member_name ("date");
		var localized_date = new DateTime.from_unix_local (date).format (Widgets.Forms.DatePicker.FORMAT);
		schema.add_string_value (localized_date);
		schema.set_member_name ("draft");
		schema.add_boolean_value (draft);
	}
	
	public override void build_settings (Widgets.PageSettings settings) {
		settings.add_section (_("General"));
		
		var name_entry = new Widgets.Forms.StringEntry (this, "name");
		settings.add_widget (name_entry, _("Name:"));
		
		var description_entry = new Widgets.Forms.StringEntry (this, "description");
		settings.add_widget (description_entry, _("Description:"));
		
		var date_entry = new Widgets.Forms.DatePicker (this, "date");
		settings.add_widget (date_entry, _("Date:"));
		
		var permalink_entry = new Widgets.Forms.PermalinkEntry (this);
		settings.add_widget (permalink_entry, _("Permalink:"));
		
		var draft_switch = new Widgets.Forms.BooleanSwitch (this, "draft");
		settings.add_widget (draft_switch, _("Is Draft:"));
	}
	
}
