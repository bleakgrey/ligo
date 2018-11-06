using GLib;
using Gee;

public class Ligo.Project : GLib.Object {

    public static Project? opened;
    public static Thread<bool>? export_thread;
	
	public bool dirty = false;
	public string path {get; set;}
	public string name {get; set;}
	public string description {get; set;}
	public Theme theme {get; set;}
	
	public Gee.List<Pages.Base> pages {get; set;}
	public Pages.Base? home_page {get; set;}
	
	public Project () {
		name = _("Unnamed Project");
		description = _("A simple site");
		pages = new ArrayList<Pages.Base> ();
		theme = themes.@get ("Axis");
	}
	
	public static void open_from_path (string path) {
		info ("Opening project: %s", path);
		opened = new Project ();
		opened.path = path;
		
		var manifest_path = Path.build_filename (path, "project.json");
		var manifest = IO.read_file (manifest_path);
		var parser = new Json.Parser ();
		parser.load_from_data (manifest, -1);
		var root = parser.get_root ().get_object ();
		
		// General info
		// opened.name = root.get_string_member ("name");
		// opened.description = root.get_string_member ("description");
		opened.dirty = root.get_boolean_member ("dirty");
		
		// Load pages
		var pages_array = root.get_array_member ("pages");
		pages_array.foreach_element ((array, i, node) => {
			var page_id = node.get_string ();
			var page_path = Path.build_filename (path, "pages", page_id + ".json");
			opened.load_page (page_path, page_id);
		});
		info ("Loaded %i pages", opened.pages.size);
		
		main_window.notebook.open_startup ();
		if (opened.dirty)
			app.project_changed ();
	}
	
	public void save () {
		var manifest_path = Path.build_filename (path, "project.json");
		var builder = new Json.Builder ();
		builder.begin_object ();
		builder.set_member_name ("version");
		builder.add_int_value (1);
		builder.set_member_name ("dirty");
		builder.add_boolean_value (dirty);
		builder.set_member_name ("pages");
		builder.begin_array ();
		pages.@foreach (page => {
			builder.add_string_value (page.permalink);
			return true;
		});
		builder.end_array ();
		builder.end_object ();
		
		var generator = new Json.Generator ();
		generator.set_root (builder.get_root ());
		var data = generator.to_data (null);
		
		IO.overwrite_file (manifest_path, data);
		dirty = false;
		
		info ("Saved project manifest");
	}
	
	public void save_dirty () {
		dirty = true;
		save ();
		dirty = true;
		app.project_changed ();
	}
	
	private void load_page (string path, string id) {
		info ("Loading page: %s", path);
		var root = IO.read_json (path);
		var page = Pages.parse (ref root);
				
		if (page == null)
			warning ("Can't read page: %s", path);
		else {
			page.permalink = id;
			pages.add (page);
			main_window.sidebar.structure.add_page (page);
			
			if (page.is_home)
				home_page = page;
		}
	}
	
	public Json.Builder build_schema (Pages.Base page) {
		var schema = new Json.Builder ();
		
		// General site info
		schema.begin_object ();
		schema.set_member_name ("site");
		schema.begin_object ();
		schema.set_member_name ("name");
		schema.add_string_value (name);
		schema.set_member_name ("root");
		schema.add_string_value (page.get_site_root_url ());
		schema.set_member_name ("home_url");
		schema.add_string_value (home_page.get_relative_url (page));
		schema.end_object ();
		
		// Navigation links
		schema.set_member_name ("navigation");
		schema.begin_array ();
		pages.@foreach (nav_page => {
			if (nav_page.show_in_navigation) {
				schema.begin_object ();
				schema.set_member_name ("name");
				schema.add_string_value (nav_page.name);
				schema.set_member_name ("url");
				var rel = nav_page.get_relative_url (page);
				schema.add_string_value (rel);
				schema.end_object ();
			}
			return true;
		});
		schema.end_array ();
		
		// Theme settings. WIP.
		schema.set_member_name ("theme");
		schema.begin_object ();
		schema.set_member_name ("color");
		schema.add_string_value ("blue");
		schema.end_object ();
		
		return schema;
	}
	
	public void start_export () {
		export_thread = new Thread<bool>.try ("Export Thread", export);
	}
	
	private bool export () {
		GLib.Thread.usleep (200000);
		//main_window.update_progress (_("Rendering pages..."));
		
		var total = pages.size;
		int current = 0;
		pages.@foreach (page => {
			current++;
			app.export_progress (total, current);
			return export_page (page);
		});
		//main_window.update_progress ();
		app.export_progress (total, total + 1);
		
		export_thread = null;
		dirty = false;
		save ();
		return true;
	}
	
	public bool export_page (Pages.Base page) {
		info ("Exporting page: %s", page.get_url ());
		
		//Prepare schema
		var schema = build_schema (page);
		page.inject_schema (schema);
		schema.end_object ();
		schema.end_object ();
		
		var generator = new Json.Generator ();
		generator.set_root (schema.get_root ());
		var schema_data = generator.to_data (null);
		
		//Pass to the templating engine
		var layout_path = theme.get_layout_path (page);
		var output_path = Path.build_filename (path, "export", page.get_url ());
		if (page.parent != null) {
			var dir_path = output_path.replace (page.permalink + ".html", "");
			IO.make_dir (dir_path);
		}
		var schema_path = Path.build_filename (path, "export", page.get_url () + ".schema.json");
		IO.overwrite_file (schema_path, schema_data);
		
		string stdout;
		var cmd = "chevron -d \"%s\" -p \"%s\" -e \"part\" \"%s\""
			.printf (schema_path, theme.partials_path, layout_path);
		Process.spawn_command_line_sync (cmd, out stdout);
		if (stdout != "")
			IO.overwrite_file (output_path, stdout);
		//IO.remove_file (schema_path);
		
		//Now export children
		page.children.@foreach (child => {
			return export_page (child);
		});
		
		return true;
	}
	
}
