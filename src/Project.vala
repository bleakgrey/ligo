using GLib;
using Gee;

public class Ligo.Project : GLib.Object {

    public static Project? opened;
	
	public string path {get; set;}
	public string name {get; set;}
	public string description {get; set;}
	
	public Gee.List<Pages.Base> pages {get; set;}
	
	public Project () {
		name = _("Unnamed Project");
		description = _("A simple site");
		pages = new ArrayList<Pages.Base> ();
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
		
		// Load pages
		var pages_array = root.get_array_member ("pages");
		pages_array.foreach_element ((array, i, node) => {
			var page_id = node.get_string ();
			var page_path = Path.build_filename (path, "pages", page_id + ".json");
			opened.load_page (page_path, page_id);
		});
		info ("Loaded %i pages", opened.pages.size);
		
		main_window.notebook.open_startup ();
	}
	
	public void save () {
		var manifest_path = Path.build_filename (path, "project.json");
		var builder = new Json.Builder ();
		builder.begin_object ();
		builder.set_member_name ("version");
		builder.add_int_value (1);
		builder.set_member_name ("pages");
		builder.begin_array ();
		pages.@foreach (page => {
			builder.add_string_value (page.url);
			return true;
		});
		builder.end_array ();
		builder.end_object ();
		
		var generator = new Json.Generator ();
		generator.set_root (builder.get_root ());
		var data = generator.to_data (null);
		
		IO.overwrite_file (manifest_path, data);
	}
	
	private void load_page (string path, string id) {
		info ("Loading page: %s", path);
		var contents = IO.read_file (path);
		var parser = new Json.Parser ();
		parser.load_from_data (contents, -1);
		var page = Pages.parse (parser.get_root ().get_object ());
				
		if (page == null)
			warning ("Can't read page: %s", path);
		else {
			page.url = id;
			page.path = path;
			pages.add (page);
			main_window.sidebar.add_page (page);
		}
	}
	
}
