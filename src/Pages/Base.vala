using GLib;
using Gee;

public class Ligo.Pages.Base : GLib.Object {
	
	public signal void changed ();
	
	public const string TYPE = "unknown";
	
	public string icon_name {get; set;}
	public string name {get; set;}
	public string permalink {get; set;}
	public bool show_in_navigation {get; set;}
	public bool is_home {get; set;}
	
	public weak Pages.Base? parent {get; set;}
	public Gee.List<Pages.Base> children {get; set;}
	
	public string get_path () {
		if (parent == null)
			return Path.build_filename (Project.opened.path, "pages", permalink + ".json");
		else
			return Path.build_filename (parent.get_path ().replace (".json", ""), permalink + ".json");
	}
	public string get_children_path () {
		return get_path ().replace (".json", "");
	}
	
	construct {
		icon_name = "unknown";
		name = _("Unnamed Page");
		permalink = "unnamed";
		is_home = false;
		show_in_navigation = true;
		children = new ArrayList<Pages.Base> ();
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
		var base_path = permalink + ".html";
		if (parent == null)
			return base_path;
		else
			return parent.get_url ().replace (".html", "") + "/" + base_path;
	}
	
	public string get_relative_url (Pages.Base page) {
		return page.get_site_root_url () + "/" + get_url ();
	}
	
	public string get_site_root_url () {
		var lvl = get_level ();
		switch (lvl) {
			case 1:
				return ".";
			case 2:
				return "..";
			default:
				var a = "";
				for (var i=1; i <= lvl - 1; i++) {
					a += "../";
				}
				return a;
		}
	}
	
	public int get_level () {
		if (parent == null)
			return 1;
		else
			return parent.get_level () + 1;
	}
	
	public bool can_be_removed () {
		return Project.opened.pages.size > 1 && !is_home;
	}
	
	public void remove () {
		var project = Project.opened;
		if (parent == null)
			project.pages.remove (this);
		else
			parent.children.remove (this);
		
		//TODO: Remove page json
		main_window.notebook.close_page (this);
		Project.opened.save_dirty ();
	}
	
	public virtual void save () {
		var builder = new Json.Builder ();
		builder.begin_object ();
		write_save_data (ref builder);
		builder.end_object ();
		
		var generator = new Json.Generator ();
		generator.set_root (builder.get_root ());
		var data = generator.to_data (null);
		
		IO.overwrite_file (get_path (), data);
		Project.opened.save_dirty ();
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
	
	public virtual void inject_schema (Json.Builder schema) {
		schema.set_member_name ("page");
		schema.begin_object ();
		schema.set_member_name ("name");
		schema.add_string_value (name);
		schema.set_member_name ("type");
		schema.add_string_value (get_page_type ());
	}
	
	public virtual void build_settings (Widgets.PageSettings settings) {
		settings.add_section (_("General"));
		
		var name_entry = new Widgets.Forms.StringEntry (this, "name");
		settings.add_widget (name_entry, _("Name:"));
		
		var permalink_entry = new Widgets.Forms.PermalinkEntry (this);
		settings.add_widget (permalink_entry, _("Permalink:"));
		
		var nav_switch = new Widgets.Forms.BooleanSwitch (this, "show_in_navigation");
		settings.add_widget (nav_switch, _("Navigation:"));
	}
	
}
