using Gee;

public class Ligo.Pages.BlogArticle : Pages.Text {
	
	public new const string TYPE = "blog_article";
	
	public string description {get; set;}
	public string date {get; set;}
	
	construct {
		date = "Unknown Date";
		description = "";
		show_in_navigation = false;
		is_home = false;
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
		builder.add_string_value (date);
	}
	
	public override void read_save_data (ref Json.Object data) {
		base.read_save_data (ref data);
		description = data.get_string_member ("description");
		date = data.get_string_member ("date");
	}
	
	public override void inject_schema (Json.Builder schema) {
		base.inject_schema (schema);
		schema.set_member_name ("description");
		schema.add_string_value (description);
		schema.set_member_name ("date");
		schema.add_string_value (date);
	}
	
}
