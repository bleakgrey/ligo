using Gtk;

public class Ligo.Widgets.HeaderBar: Gtk.HeaderBar {

	public Button open_button;
	public Button save_button;
	public MenuButton publish_button;
	public Button settings_button;
	
	private Popover popover;
	private Grid grid;
	private Label publish_status;
	private ProgressBar publish_progress;
	private Overlay publish_overlay;
	private Image publish_icon;
	private Image publish_icon_emblem;
	
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
		
		publish_status = new Label ("");
		publish_progress = new ProgressBar ();
		
		grid = new Grid ();
		grid.column_spacing = 12;
		grid.row_spacing = 6;
		grid.margin = 6;
		grid.attach (publish_status, 0, 1);
		grid.attach (publish_progress, 0, 2);
		grid.show_all ();
		
		publish_icon = new Image.from_icon_name ("applications-internet", IconSize.LARGE_TOOLBAR); //document-send
		publish_icon_emblem = new Image.from_icon_name ("process-completed", IconSize.MENU);
		publish_icon_emblem.halign = Align.END;
		publish_icon_emblem.valign = Align.END;
		
		publish_overlay = new Overlay ();
		publish_overlay.add (publish_icon);
		publish_overlay.add_overlay (publish_icon_emblem);
		publish_overlay.set_overlay_pass_through (publish_icon_emblem, true);
		publish_overlay.show_all ();
		
		publish_button = new MenuButton ();
		publish_button.image = publish_overlay; //new Image.from_icon_name ("document-send", IconSize.LARGE_TOOLBAR);
		publish_button.tooltip_text = _("Publish");
		publish_button.toggled.connect (() => {
			if (publish_button.active && Project.export_thread == null)
				export ();
		});
		
		popover = new Popover (publish_button);
		popover.add (grid);
		publish_button.popover = popover;
		
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

	public HeaderBar () {
		app.project_changed.connect (on_project_changed);
		app.export_progress.connect (on_export_progress);
	}

	public void export () {
		publish_status.label = _("Preparing...");
		publish_progress.fraction = 0;
		Project.opened.start_export ();
	}
	
	private void on_project_changed () {
		publish_icon_emblem.icon_name = "software-update-available";
	}
	
	private void on_export_progress (int total, int completed) {
		if (completed > total) {
			publish_status.label = _("Publish Successful!");
			publish_progress.fraction = 1;
			publish_icon_emblem.icon_name = "process-completed";
		}
		else {
			publish_status.label = _("Publishing %i/%i...").printf (completed, total);
			publish_progress.fraction = (double) completed / total;
			publish_icon_emblem.icon_name = "process-working-symbolic";
		}
	}

}
