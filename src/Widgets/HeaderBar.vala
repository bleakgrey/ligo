using Gtk;

public class Ligo.Widgets.HeaderBar: Gtk.HeaderBar {

	public Button open_button;
	public Button save_button;
	public Button publish_button;
	public Button settings_button;
	
	construct {
		open_button = new Button.from_icon_name ("document-open", IconSize.LARGE_TOOLBAR);
		open_button.tooltip_text = _("Open Site");
		
		save_button = new Button.from_icon_name ("document-save", IconSize.LARGE_TOOLBAR);
		save_button.tooltip_text = _("Save Page");
		save_button.sensitive = false;
		save_button.clicked.connect (() => {
			var tab = main_window.notebook.get_opened ();
			if (tab != null)
				tab.on_save ();
		});
		
		publish_button = new Button.from_icon_name ("document-send", IconSize.LARGE_TOOLBAR);
		publish_button.tooltip_text = _("Publish");
		publish_button.clicked.connect (() => {
			Project.opened.export ();
		});
		
		settings_button = new Button.from_icon_name ("open-menu", IconSize.LARGE_TOOLBAR);
		settings_button.tooltip_text = _("Settings");
	
		var mode_switch = new Granite.ModeSwitch.from_icon_name ("edit-symbolic", "system-search-symbolic");
		mode_switch.primary_icon_tooltip_text = ("Edit Mode");
		mode_switch.secondary_icon_tooltip_text = ("Preview Mode");
		mode_switch.valign = Gtk.Align.CENTER;
		
		show_close_button = true;
		custom_title = mode_switch;
		pack_start (open_button);
		pack_start (save_button);
		pack_end (settings_button);
		pack_end (publish_button);
	}

}
