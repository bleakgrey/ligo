using Gtk;

public class Desidia.Windows.Main: Gtk.Window {

	public Widgets.HeaderBar header;
	public Paned paned;

	construct {
		default_height = 500;
		default_width = 800;
		
		var sidebar = new Widgets.Sidebar ();
		var notebook = new Widgets.Notebook ();
		
        paned = new Gtk.Paned (Orientation.HORIZONTAL);
        paned.position = 180;
        paned.pack1 (sidebar, false, false);
        paned.add2 (notebook);
		add (paned);
		
		header = new Widgets.HeaderBar ();
		set_titlebar (header);
		show_all ();
	}
	
	public Main (Gtk.Application _application) {
		application = _application;
		icon_name = "com.github.bleakgrey.desidia";
		resizable = true;
	}

}
