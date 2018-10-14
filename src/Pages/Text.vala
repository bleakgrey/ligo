public class Ligo.Pages.Text : Pages.Base {
	
	public new const string TYPE = "text";
	
	public string content {get; set;}
	
	construct {
		content = "";
		icon_name = "text-markdown";
	}
	
	public Text () {}
	
	public override string get_display_type () {
		return _("Custom Text");
	}
	
	public override string get_page_type () {
		return TYPE;
	}
	
	public override Widgets.Tabs.Base? create_tab () {
		return new Widgets.Tabs.PageEditor (this);
	}
	
	public override void write_save_data (ref Json.Builder builder) {
		base.write_save_data (ref builder);
		builder.set_member_name ("content");
		builder.add_string_value (content);
	}
	
	public override void read_save_data (ref Json.Object data) {
		base.read_save_data (ref data);
		content = data.get_string_member ("content");
	}
	
	public override void inject_schema (Json.Builder schema) {
		base.inject_schema (schema);
		var html_content = render_markdown ();
		schema.set_member_name ("content");
		schema.add_string_value (html_content);
	}

	public string render_markdown () {
		var markdown = new Markdown.Document.gfm_format (content.data);
		markdown.compile ();
		string result;
		markdown.get_document (out result);
		return result;
	}

}
