using Gtk;

public class Ligo.Widgets.StatusBar : Gtk.ActionBar {
	
	public Label info;
	public Button add_page_button;
	public Button delete_page_button;
	
	// private Popover add_page_popover;
	// private Entry add_page_name;
	// private Widgets.Forms.PermalinkEntry add_page_permalink;
	// private Button add_page_submit;
	
	construct {
		info = new Label ("0 words");
		
		add_page_button = new Button.from_icon_name ("list-add-symbolic", IconSize.MENU); //new MenuButton ();
		add_page_button.tooltip_text = _("Add Article");
		add_page_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
		add_page_button.clicked.connect (() => {
			var opened_tab = main_window.notebook.get_opened ();
			if (opened_tab != null)
				opened_tab.on_add_child ();
		});
		//add_page_button.image = new Image.from_icon_name ("list-add-symbolic", IconSize.MENU);
		
		// 
		// 
		// // Add page popover
		// add_page_popover = new Popover (add_page_button);
		// add_page_button.popover = add_page_popover;
		// 
		// var grid = new Grid ();
		// grid.column_spacing = 12;
		// grid.row_spacing = 6;
		// grid.margin = 6;
		// 
		// add_page_name = new Entry ();
		// add_page_name.hexpand = true;
		// add_page_name.changed.connect (() => {
		// 	add_page_permalink.set_text (add_page_name.buffer.text);
		// });
		// add_page_permalink = new Widgets.Forms.PermalinkEntry ();
		// add_page_permalink.hexpand = true;
		// 
		// add_page_submit = new Button.with_label (_("Create"));
		// 
		// grid.attach (new Widgets.FormLabel (_("Name:")), 0, 1);
		// grid.attach (add_page_name, 1, 1);
		// grid.attach (new Widgets.FormLabel (_("Permalink:")), 0, 2);
		// grid.attach (add_page_permalink, 1, 2);
		// grid.attach (add_page_submit, 1, 3);
		// grid.show_all ();
		// add_page_popover.add (grid);
		
		
		delete_page_button = new Button.from_icon_name ("list-remove-symbolic", IconSize.MENU);
		delete_page_button.tooltip_text = _("Delete Article");
		delete_page_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
		
		var size_holder = new Button.from_icon_name ("list-remove-symbolic", IconSize.MENU);
		size_holder.opacity = 0;
		size_holder.sensitive = false;
		
		pack_end (add_page_button);
		pack_end (delete_page_button);
		pack_end (size_holder);
		pack_start (info);
	}
	
}
