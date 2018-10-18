using Gtk;

public class Ligo.Windows.Main: Gtk.Window {

	public Paned paned;
	public Box box;
	public Widgets.HeaderBar header;
	public Widgets.StatusBar status_bar;
	public Widgets.Notebook notebook;
	public Widgets.Sidebar sidebar;
	public Overlay overlay;
	public Granite.Widgets.OverlayBar overlay_bar;

	construct {
		default_height = 500;
		default_width = 800;
		
		sidebar = new Widgets.Sidebar ();
		notebook = new Widgets.Notebook ();
		status_bar = new Widgets.StatusBar ();
		
		var overlay = new Gtk.Overlay ();
		overlay_bar = new Granite.Widgets.OverlayBar (overlay);
		overlay_bar.active = true;
		overlay.add (notebook);
		
		var box = new Box (Orientation.VERTICAL, 0);
		box.pack_end (status_bar, false, false, 0);
		box.pack_start (overlay, true, true, 0);
		
        paned = new Gtk.Paned (Orientation.HORIZONTAL);
        paned.position = 180;
        paned.pack1 (sidebar, false, false);
        paned.add2 (box);
		add (paned);
		
		header = new Widgets.HeaderBar ();
		set_titlebar (header);
		show_all ();
		
		update_progress ();
	}
	
	public Main (Gtk.Application _application) {
		application = _application;
		icon_name = "com.github.bleakgrey.ligo";
		resizable = true;
	}
	
	public void update_progress (string? text = null) {
		if (text == null) {
			overlay_bar.visible = false;
		}
		else {
			overlay_bar.visible = true;
			overlay_bar.label = text;
		}
	}
	
	public override bool delete_event (Gdk.EventAny event) {
		var proj = Project.opened;
		if (proj.dirty)
			proj.save ();
		return false;
	}

}
