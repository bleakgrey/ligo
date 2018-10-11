using GLib;

public class Ligo.Pages.Base : GLib.Object {
	
	public const string TYPE = "unknown";
	
	public string icon_name {get; set;}
	public string path {get; set;}
	public string name {get; set;}
	public string url {get; set;}
	public bool show_in_navigation {get; set;}
	
	construct {
		icon_name = "unknown"; //"folder-documents";
		name = _("Unnamed Page");
		url = "unnamed";
		show_in_navigation = true;
	}
	
	public Base () {}
	
	public virtual string get_display_type () {
		return _("Unknown");
	}
	
	protected virtual string get_page_type () {
		return TYPE;
	}
	
	public virtual Widgets.Tabs.Base? create_tab () {
		return null;
	}
	
	public string get_full_url () {
		return ""; //app.current_project.get_full_url () + "/" + this.url;
	}
	
	public virtual string render () {
		return "";
	}
	
	public virtual void save () {
		var builder = new Json.Builder ();
		builder.begin_object ();
		builder.set_member_name ("version");
		builder.add_int_value (1);
		builder.set_member_name ("type");
		builder.add_string_value (get_page_type ());
		builder.set_member_name ("name");
		builder.add_string_value (name);
		builder.set_member_name ("url");
		builder.add_string_value (url);
		builder.set_member_name ("show_in_navigation");
		builder.add_boolean_value (show_in_navigation);
		write_save_data (builder);
		builder.end_object ();
		
		var generator = new Json.Generator ();
		generator.set_root (builder.get_root ());
		var data = generator.to_data (null);
		
		IO.overwrite_file (path, data);
	}
	
	public virtual void write_save_data (Json.Builder builder) {}
	public virtual void read_save_data (Json.Object data) {}
	
}

namespace Ligo.Pages {

	public static Type[] get_all_types () {
		Type[] types = {};
		types += typeof (Pages.Text);
		types += typeof (Pages.Blog);
		return types;
	}

	public static Pages.Base? parse (Json.Object root) {
		Pages.Base page = null;
		var type = root.get_string_member ("type");
		
		switch (type) {
			case Pages.Text.TYPE:
				page = new Pages.Text ();
				break;
			case Pages.Blog.TYPE:
				page = new Pages.Blog ();
				break;
			default:
				warning ("Unknown page type: %s", type);
				break;
		}
		
		page.name = root.get_string_member ("name");
		page.url = root.get_string_member ("url");
		page.show_in_navigation = root.get_boolean_member ("show_in_navigation");
		page.read_save_data (root);
		return page;
	}
	
}
