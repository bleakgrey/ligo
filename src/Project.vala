using GLib;
using Gee;

public class Desidia.Project : GLib.Object {

    public static Project? opened;
	
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
		
		var manifest_path = Path.build_filename (path, "project.json");
		var manifest = IO.read_file (manifest_path);
		var parser = new Json.Parser ();
		parser.load_from_data (manifest, -1);
		var root = parser.get_root ().get_object ();
		
		// Load pages
		var pages_array = root.get_array_member ("pages");
		pages_array.foreach_element ((array, i, node) => {
			var page_name = node.get_string ();
			var page_path = Path.build_filename (path, "pages", page_name + ".json");
			opened.load_page (page_path);
		});
		info ("Loaded %i pages", opened.pages.size);
	}
	
	private void load_page (string path) {
		info ("Loading page: %s", path);
		var contents = IO.read_file (path);
		var parser = new Json.Parser ();
		parser.load_from_data (contents, -1);
		var page = Pages.parse (parser.get_root ().get_object ());
				
		if (page == null)
			warning ("Can't read page: %s", path);
		else {
			pages.add (page);
			main_window.sidebar.add_page (page);
		}
	}
	
}
