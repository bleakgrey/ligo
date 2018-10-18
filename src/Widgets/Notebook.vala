using Gtk;
using Granite;

public class Ligo.Widgets.Notebook : Granite.Widgets.DynamicNotebook {
	
	private Widgets.Tabs.Startup? startup_tab;
	
	construct {
		allow_duplication = false;
		allow_restoring = false;
		add_button_visible = true;
		tab_bar_behavior = Granite.Widgets.DynamicNotebook.TabBarBehavior.ALWAYS;
		get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
		
		tab_switched.connect (on_tab_switched);
		tab_removed.connect (on_tab_removed);
		new_tab_requested.connect (() => Windows.NewPage.open ());
	}
	
	public Notebook () {
		base ();
	}
	
	public Widgets.Tabs.Base? get_opened () {
		return (Widgets.Tabs.Base) current;
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
		var tab = current as Widgets.Tabs.Base;
			tab.on_switched ();
	}
	
	private void on_tab_removed (Granite.Widgets.Tab tab) {
		if (n_tabs <= 0)
			open_startup ();
	}
	
	public void open_page (Pages.Base page) {
		var i = -1;
		tabs.@foreach (tab => {
			var custom_tab = (Widgets.Tabs.Base) tab;
			if (custom_tab.is_page_owner (page)) {
				i = get_tab_position (tab);
			}
		});
		
		if (i < 0) {
			var tab = page.create_tab ();
			insert_tab (tab, -1);
			i = get_tab_position (tab);
			current = tab;
		}
		(get_child () as Gtk.Notebook).set_current_page (i);
		var curr = get_tab_by_index (i) as Widgets.Tabs.Base;
		curr.on_switched ();
		
		close_startup ();
	}
	
	public void close_page (Pages.Base page) {
		tabs.@foreach (tab => {
			var custom_tab = (Widgets.Tabs.Base) tab;
			if (custom_tab.is_page_owner (page))
				custom_tab.close ();
		});
	}
	
}
