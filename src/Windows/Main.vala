using Gtk;

public class Desidia.Windows.Main: Gtk.Window {

	public Widgets.HeaderBar header;
	public Paned paned;
	public Widgets.Sidebar sidebar;
	public Widgets.StatusBar status_bar;
	public Widgets.Notebook notebook;
	public Box box;

	construct {
		default_height = 500;
		default_width = 800;
		
		sidebar = new Widgets.Sidebar ();
		status_bar = new Widgets.StatusBar ();
		notebook = new Widgets.Notebook ();
		var box = new Box (Orientation.VERTICAL, 0);
		
		box.pack_end (status_bar, false, false, 0);
		box.pack_start (notebook, true, true, 0);
		
        paned = new Gtk.Paned (Orientation.HORIZONTAL);
        paned.position = 180;
        paned.pack1 (sidebar, false, false);
        paned.add2 (box);
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
	
	public void reopen_tabs () {
		var tab = new Widgets.Tabs.PageEditor ();
		notebook.insert_tab (tab, -1);
		var tab2 = new Widgets.Tabs.PageList ();
		notebook.insert_tab (tab2, -1);
	}

}
