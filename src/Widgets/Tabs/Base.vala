using Gtk;
using Granite;

public class Ligo.Widgets.Tabs.Base : Granite.Widgets.Tab {
	
	public Gtk.ScrolledWindow scroller;
	public bool has_status_bar;
	public bool configurable;
	public bool has_changed {get; set;}
	
	public Base () {
		base ();
		has_status_bar = true;
		configurable = false;
		has_changed = false;
		
		scroller = new ScrolledWindow (null, null);
		page = scroller;
	}
	
	public virtual void on_changed () {
		has_changed = true;
		on_ui_update ();
	}
	
	public virtual void on_ui_update () {
		main_window.header.save_button.sensitive = has_changed;
	}
	
	public virtual void on_switched () {
		on_ui_update ();
		main_window.sidebar.page_settings.clear ();
	}
	
	public virtual void on_save () {
		has_changed = false;
		app.project_changed ();
		on_switched ();
	}
	
	public virtual void on_add_child () {}
	
	public virtual bool is_page_owner (Pages.Base page) {
		return false;
	}
	
	public virtual Pages.Base? get_page () {
		return null;
	}
	
}
