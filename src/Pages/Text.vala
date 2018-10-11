public class Ligo.Pages.Text : Pages.Base {
	
	public new const string TYPE = "text";
	
	public string content {get; set;}
	
	construct {
		content = "";
		icon_name = "text-markdown";
	}
	
	public Text () {}
	
	public override string get_display_type () {
		return _("Markdown Text");
	}
	
	protected override string get_page_type () {
		return TYPE;
	}
	
	public override Widgets.Tabs.Base? create_tab () {
		return new Widgets.Tabs.PageEditor (this);
	}
	
	public override string render () {
		// var markdown = new Markdown.Document.gfm_format (content.data);
		// markdown.compile ();
		// string result;
		// markdown.get_document (out result);
		// return (result);
		return "";
	}
	
	public override void write_save_data (Json.Builder builder) {
		builder.set_member_name ("content");
		builder.add_string_value (content);
	}
	
	public override void read_save_data (Json.Object data) {
		content = data.get_string_member ("content");
	}

}
