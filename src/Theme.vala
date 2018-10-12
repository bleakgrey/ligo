using GLib;
using Gee;

public class Ligo.Theme : GLib.Object {

	public string path {get; set;}
	public string partials_path {get; set;}
	public string name {get; set;}
	public string description {get; set;}
	public string author {get; set;}
	public string url {get; set;}

	public Theme () {}
	
	public static void load_available () {
        var axis = load_from_path ("/home/blue/Documents/Projects/SiteGenerator/data/themes/Axis/");
        themes.@set (axis.name, axis);

        info ("Loaded %i themes", themes.size);
	}
	
	private static Theme load_from_path (string path) {
		info ("Loading theme: %s", path);
		var theme = new Theme ();
		theme.path = path;
		theme.partials_path = Path.build_filename (path, "partials");
		
		var manifest_path = Path.build_filename (path, "theme.json");
		var manifest = IO.read_file (manifest_path);
		var parser = new Json.Parser ();
		parser.load_from_data (manifest, -1);
		var root = parser.get_root ().get_object ();
		
		theme.name = root.get_string_member ("name");
		theme.description = root.get_string_member ("description");
		theme.author = root.get_string_member ("author");
		theme.url = root.get_string_member ("url");
		
		return theme;
	}

	public string get_layout_path (Pages.Base page) {
		return Path.build_filename (path, page.get_page_type () + ".html");
	}

}
