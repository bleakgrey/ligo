using Gtk;
using Granite;

public class Desidia.Widgets.Notebook : Granite.Widgets.DynamicNotebook {
	
	private Widgets.Tabs.Startup? startup_tab;
	
	construct {
		allow_duplication = false;
		allow_restoring = false;
		add_button_visible = true;
		tab_bar_behavior = Granite.Widgets.DynamicNotebook.TabBarBehavior.ALWAYS;
		get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
		
		tab_switched.connect (on_tab_switched);
		tab_removed.connect (on_tab_removed);
	}
	
	public Notebook () {
		base ();
	}
	
	public void open_startup () {
		if (startup_tab == null) {
			startup_tab = new Widgets.Tabs.Startup ();
			tab_bar_behavior = Granite.Widgets.DynamicNotebook.TabBarBehavior.NEVER;
			insert_tab (startup_tab, -1);
		}
	}
	
	public void close_startup () {
		if (startup_tab != null) {
			remove_tab (startup_tab);
			tab_bar_behavior = Granite.Widgets.DynamicNotebook.TabBarBehavior.ALWAYS;
			startup_tab.destroy ();
			startup_tab = null;
		}
	}
	
	private void on_tab_switched (Granite.Widgets.Tab? old, Granite.Widgets.Tab current) {
		var custom_tab = current as Widgets.Tabs.AbstractTab;
		custom_tab.on_switched ();
	}
	
	private void on_tab_removed (Granite.Widgets.Tab tab) {
		if (n_tabs <= 0)
			open_startup ();
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
		
		close_startup ();
	}
	
}
