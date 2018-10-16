using Gtk;

public class Ligo.Windows.NewPage : Gtk.Dialog {

	private static NewPage instance;
	
	private Grid grid;
	private Entry page_name;
	private Widgets.Forms.PermalinkEntry permalink;
	private Widgets.Forms.PageTypeSelector page_type;
	private Button create_button;
	private Switch show_in_navigation;
	
	private static Type[]? allowed_types;
	private static Pages.Base? page_parent;
	private static bool allow_navigation;

	construct {
		border_width = 6;
		title = _("New Page");
		transient_for = main_window;
		
		grid = new Grid ();
		grid.column_spacing = 12;
		grid.row_spacing = 6;
		grid.margin = 6;
		
		page_name = new Entry ();
		page_name.hexpand = true;
		page_name.changed.connect (on_name_changed);
		permalink = new Widgets.Forms.PermalinkEntry ();
		permalink.hexpand = true;
		page_type = new Widgets.Forms.PageTypeSelector (allowed_types);
		
		grid.attach (new Widgets.FormLabel (_("Name:")), 0, 1);
		grid.attach (page_name, 1, 1);
		grid.attach (new Widgets.FormLabel (_("Permalink:")), 0, 2);
		grid.attach (permalink, 1, 2);
		grid.attach (new Widgets.FormLabel (_("Type:")), 0, 3);
		grid.attach (page_type, 1, 3);
		if (allow_navigation) {
			show_in_navigation = new Switch ();
			show_in_navigation.halign = Align.START;
			show_in_navigation.active = true;
		
			grid.attach (new Widgets.FormLabel (_("Show in Navigation:")), 0, 4);
			grid.attach (show_in_navigation, 1, 4);
		}
		
		var content = get_content_area () as Gtk.Box;
		content.pack_start (grid, true, true, 0);
		
		create_button = add_button (_("_Create"), Gtk.ResponseType.APPLY) as Button;
		create_button.get_style_context ().add_class (STYLE_CLASS_SUGGESTED_ACTION);
		create_button.clicked.connect (create);
		
		show_all ();
		page_name.buffer.set_text (_("New Page").data);
	}

	public NewPage () {}
	
	public static void open (Type[]? page_types = null, Pages.Base? parent = null) {
		if (instance != null)
			return;
		
		allowed_types = page_types;
		page_parent = parent;
		allow_navigation = page_parent == null;
		
		instance = new NewPage ();
		instance.destroy.connect (() => {
			instance = null;
		});
	}
	
	private void create () {
		var project = Project.opened;
		var page = page_type.create ();
		page.name = page_name.text;
		page.permalink = permalink.text;
		page.show_in_navigation = show_in_navigation.active;
		
		if (page_parent == null) {
			project.pages.add (page);
			main_window.sidebar.structure.add_page (page);
		}
		else {
			page_parent.children.add (page);
			page.parent = page_parent;
			page_parent.save ();
		}
		
		page.save ();
		project.save ();
		close ();
	}
	
	private void on_name_changed () {
		permalink.set_text (page_name.buffer.text);
	}

}
