using GLib;

public class Ligo.Pages.Base : GLib.Object {
	
	public const string TYPE = "unknown";
	
	public string icon_name {get; set;}
	public string path {get; set;}
	public string name {get; set;}
	public string permalink {get; set;}
	public bool show_in_navigation {get; set;}
	public bool is_home {get; set;}
	
	construct {
		icon_name = "unknown"; //"folder-documents";
		name = _("Unnamed Page");
		permalink = "unnamed";
		is_home = false;
		show_in_navigation = true;
	}
	
	public Base () {}
	
	public virtual string get_display_type () {
		return _("Unknown");
	}
	
	public virtual string get_page_type () {
		return TYPE;
	}
	
	public virtual Widgets.Tabs.Base? create_tab () {
		return null;
	}
	
	public string get_url () {
		return permalink + ".html";
	}
	
	public bool can_be_removed () {
		return Project.opened.pages.size > 1 && !is_home;
	}
	
	public virtual void save () {
		var builder = new Json.Builder ();
		builder.begin_object ();
		write_save_data (ref builder);
		builder.end_object ();
		
		var generator = new Json.Generator ();
		generator.set_root (builder.get_root ());
		var data = generator.to_data (null);
		
		IO.overwrite_file (path, data);
	}
	
	public virtual void write_save_data (ref Json.Builder builder) {
		builder.set_member_name ("version");
		builder.add_int_value (1);
		builder.set_member_name ("type");
		builder.add_string_value (get_page_type ());
		builder.set_member_name ("name");
		builder.add_string_value (name);
		builder.set_member_name ("permalink");
		builder.add_string_value (permalink);
		builder.set_member_name ("show_in_navigation");
		builder.add_boolean_value (show_in_navigation);
		builder.set_member_name ("is_home");
		builder.add_boolean_value (is_home);
	}
	public virtual void read_save_data (ref Json.Object data) {
		name = data.get_string_member ("name");
		permalink = data.get_string_member ("permalink");
		show_in_navigation = data.get_boolean_member ("show_in_navigation");
		is_home = data.get_boolean_member ("is_home");
	}
	
	public virtual void inject_schema (ref Json.Builder schema) {
		schema.set_member_name ("page");
		schema.begin_object ();
		schema.set_member_name ("name");
		schema.add_string_value (name);
		schema.set_member_name ("type");
		schema.add_string_value (get_page_type ());
	}
	
}

namespace Ligo.Pages {

	public static Type[] get_all_types () {
		Type[] types = {};
		types += typeof (Pages.Text);
		types += typeof (Pages.Blog);
		return types;
	}

	public static Pages.Base? parse (ref Json.Object root) {
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
		
		page.read_save_data (ref root);
		return page;
	}
	
}
