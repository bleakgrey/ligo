using Gtk;

public class Desidia.Widgets.StatusBar : Gtk.ActionBar {
	
	public Gtk.Label info;
	public Gtk.Button add_page_button;
	public Gtk.Button page_settings_button;
	
	construct {
		info = new Label ("0 words");
		
		add_page_button = new Button.from_icon_name ("list-add-symbolic", IconSize.MENU);
		add_page_button.tooltip_text = _("Add Article");
		add_page_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
		
		page_settings_button = new Button.from_icon_name ("document-properties-symbolic", IconSize.MENU);
		page_settings_button.tooltip_text = _("Page Settings");
		page_settings_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
		
		pack_end (page_settings_button);
		pack_end (add_page_button);
		pack_start (info);
	}
	
}
