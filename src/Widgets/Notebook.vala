using Gtk;
using Granite;

public class Desidia.Widgets.Notebook : Granite.Widgets.DynamicNotebook {
	
	construct {
		allow_duplication = false;
		allow_restoring = false;
		add_button_visible = false;
		tab_bar_behavior = Granite.Widgets.DynamicNotebook.TabBarBehavior.ALWAYS;
		get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
		
		tab_switched.connect (on_tab_switched);
	}
	
	public Notebook () {
		base ();
	}
	
	private void on_tab_switched (Granite.Widgets.Tab? old, Granite.Widgets.Tab current) {
		var custom_tab = current as Widgets.Tabs.AbstractTab;
		custom_tab.on_switched ();
	}
	
	public void open_page (Pages.Base page) {
		var i = -1;
		tabs.@foreach (tab => {
			var custom_tab = (Widgets.Tabs.AbstractTab) tab;
			if (custom_tab.is_page_owner (page)) {
				i = get_tab_position (tab);
			}
		});
		
		if (i < 0)
			insert_tab (page.create_tab (), -1);
		else
			(get_child () as Gtk.Notebook).set_current_page (i); // Setting "current" param throws error
	}
	
}
