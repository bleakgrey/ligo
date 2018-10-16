using Gtk;
using Granite;

public class Ligo.Widgets.Tabs.Base : Granite.Widgets.Tab {
	
	public Gtk.ScrolledWindow scroller;
	public bool has_status_bar;
	public bool configurable;
	
	private bool _has_changed;
	public bool has_changed {
		get {
			return _has_changed;
		}
		set {
			_has_changed = value;
			on_ui_update ();
		}
	}
	
	public Base () {
		base ();
		has_status_bar = true;
		configurable = false;
		has_changed = false;
		
		scroller = new ScrolledWindow (null, null);
		page = scroller;
	}
	
	public virtual bool is_page_owner (Pages.Base page) {
		return false;
	}
	
	public virtual void on_ui_update () {
		main_window.header.save_button.sensitive = has_changed;
	}
	
	public virtual void on_switched () {
		on_ui_update ();
	}
	public virtual void on_save () {
		has_changed = false;
		on_switched ();
	}
	
	public virtual void on_add_child () {}
	
}
