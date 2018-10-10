using Gtk;
using Granite;

public class Ligo.Widgets.Tabs.BlogEditor : Base {
	
	protected Pages.Blog my_page;
	
	public Gtk.TreeView tree;
	public Gtk.ListStore list_store;
	public Gtk.CellRendererText cell;
	
	public BlogEditor (Pages.Blog page) {
		base ();
		my_page = page;
		label = my_page.name;
		
		list_store = new Gtk.ListStore (2, typeof (string), typeof (string));
		Gtk.TreeIter iter;
		
		list_store.append (out iter);
		list_store.set (iter, 0, "Carinthia", 1, "2 October 2018");
		list_store.append (out iter);
		list_store.set (iter, 0, "Lower Austria", 1, "2 October 2018");
		list_store.append (out iter);
		list_store.set (iter, 0, "Upper Austria", 1, "4 October 2018");
		list_store.append (out iter);
		list_store.set (iter, 0, "Salzburg", 1, "5 October 2018");
		list_store.append (out iter);
		list_store.set (iter, 0, "Vorarlberg", 1, "7 October 2018");
		
		tree = new Gtk.TreeView.with_model (list_store);
		cell = new Gtk.CellRendererText ();
		tree.insert_column_with_attributes (-1, "Title", cell, "text", 0);
		tree.insert_column_with_attributes (-1, "Date", cell, "text", 1);
		
		scroller.add (tree);
		scroller.show_all ();
	}
	
	public override bool is_page_owner (Pages.Base page) {
		return this.my_page == page;
	}
	
	public override void on_ui_update () {
		base.on_ui_update ();
		var status_bar = main_window.status_bar;
		status_bar.show ();
		status_bar.page_settings_button.show ();
		status_bar.add_page_button.show ();
		main_window.status_bar.info.label = _("%i articles").printf (5);
	}
	
	public override void on_save () {
		base.on_save ();
		my_page.save ();
	}
	
}
