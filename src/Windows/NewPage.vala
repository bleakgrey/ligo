using Gtk;

public class Ligo.Windows.NewPage : Gtk.Dialog {

	private static NewPage instance;
	
	private Grid grid;
	private Entry page_name;
	private Entry permalink;
	private Widgets.Forms.PageTypeSelector page_type;
	private Button create_button;
	private Switch show_in_navigation;

	construct {
		grid = new Grid ();
		grid.column_spacing = 12;
		grid.row_spacing = 6;
		grid.margin = 6;
		
		page_name = new Entry ();
		page_name.hexpand = true;
		permalink = new Entry ();
		permalink.hexpand = true;
		page_type = new Widgets.Forms.PageTypeSelector ();
		show_in_navigation = new Switch ();
		show_in_navigation.halign = Align.START;
		show_in_navigation.active = true;
		
		grid.attach (new Widgets.FormLabel (_("Name:")), 0, 1);
		grid.attach (page_name, 1, 1);
		grid.attach (new Widgets.FormLabel (_("Permalink:")), 0, 2);
		grid.attach (permalink, 1, 2);
		grid.attach (new Widgets.FormLabel (_("Type:")), 0, 3);
		grid.attach (page_type, 1, 3);
		grid.attach (new Widgets.FormLabel (_("Show in Navigation:")), 0, 4);
		grid.attach (show_in_navigation, 1, 4);
		
		var content = get_content_area () as Gtk.Box;
		content.pack_start (grid, true, true, 0);
		
		create_button = add_button (_("_Create"), Gtk.ResponseType.APPLY) as Button;
		create_button.get_style_context ().add_class (STYLE_CLASS_SUGGESTED_ACTION);
		create_button.clicked.connect (create);
		
		show_all ();
	}

	public NewPage () {
		border_width = 6;
		title = _("New Page");
		transient_for = main_window;
	}
	
	public static void open () {
		if (instance == null) {
			instance = new NewPage ();
			instance.destroy.connect (() => {
				instance = null;
			});
		}
		instance.present ();
	}
	
	private void create () {
		var project = Project.opened;
		var page = page_type.create ();
		page.name = page_name.text;
		page.permalink = permalink.text;
		page.show_in_navigation = show_in_navigation.active;
		page.path = Path.build_filename (project.path, "pages", page.permalink + ".json");
		
		project.pages.add (page);
		main_window.sidebar.add_page (page);
		
		page.save ();
		project.save ();
		close ();
	}

}
