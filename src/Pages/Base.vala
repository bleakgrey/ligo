using GLib;

public class Ligo.Pages.Base : GLib.Object {
	
	public const string TYPE = "basic";
	
	public string path {get; set;}
	public string name {get; set;}
	public string url {get; set;}
	public string? content {get; set;}
	public bool show_in_navigation {get; set;}
	
	public Base () {
		name = _("Unnamed Page");
		url = "unnamed";
		content = "";
		show_in_navigation = true;
	}
	
	public virtual Widgets.Tabs.Base? create_tab () {
		return new Widgets.Tabs.PageEditor (this);
	}
	
	public string get_full_url () {
		return ""; //app.current_project.get_full_url () + "/" + this.url;
	}
	
	public string render () {
		// var markdown = new Markdown.Document.gfm_format (content.data);
		// markdown.compile ();
		// string result;
		// markdown.get_document (out result);
		// return (result);
		return "";
	}
	
	public void save () {
		var builder = new Json.Builder ();
		builder.begin_object ();
		builder.set_member_name ("version");
		builder.add_int_value (1);
		builder.set_member_name ("type");
		builder.add_string_value (TYPE);
		builder.set_member_name ("name");
		builder.add_string_value (name);
		builder.set_member_name ("url");
		builder.add_string_value (url);
		write_save_data (builder);
		builder.end_object ();
		
		var generator = new Json.Generator ();
		generator.set_root (builder.get_root ());
		var data = generator.to_data (null);
		
		IO.overwrite_file (path, data);
	}
	
	public virtual void write_save_data (Json.Builder builder) {
		builder.set_member_name ("content");
		builder.add_string_value (content);
	}
	
	public virtual void read_save_data (Json.Object data) {
		content = data.get_string_member ("content");
	}
	
}

namespace Ligo.Pages {

	public static Pages.Base? parse (Json.Object root) {
		Pages.Base page = null;
		var type = root.get_string_member ("type");
		
		switch (type) {
			case Pages.Blog.TYPE:
				page = new Pages.Blog ();
				break;
			default:
				page = new Pages.Base ();
				page.content = root.get_string_member ("content");
				break;
		}
		
		page.name = root.get_string_member ("name");
		page.url = root.get_string_member ("url");
		page.read_save_data (root);
		return page;
	}
	
}
