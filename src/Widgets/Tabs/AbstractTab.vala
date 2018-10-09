using Gtk;
using Granite;

public class Desidia.Widgets.Tabs.AbstractTab : Granite.Widgets.Tab {
	
	public Gtk.ScrolledWindow scroller;
	public bool has_status_bar;
	public bool configurable;
	
	public AbstractTab () {
		base ();
		has_status_bar = true;
		configurable = false;
		scroller = new ScrolledWindow (null, null);
		page = scroller;
	}
	
	public virtual bool is_page_owner (Pages.Base page) {
		return false;
	}
	
	public virtual void on_switched () {
		
	}
	
}