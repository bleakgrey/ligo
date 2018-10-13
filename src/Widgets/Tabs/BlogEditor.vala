using Gtk;
using Granite;

public class Ligo.Widgets.Tabs.BlogEditor : Base {
	
	protected Pages.Blog my_page;
	
	public Gtk.TreeView tree;
	public Gtk.ListStore list_store;
	public Gtk.CellRendererText cell;
	private Gtk.TreeIter iter;
	
	public BlogEditor (Pages.Blog page) {
		base ();
		my_page = page;
		label = my_page.name;
		
		list_store = new Gtk.ListStore (2, typeof (string), typeof (string));
		
		my_page.children.@foreach (page => {
			var article = page as Pages.BlogArticle;
			list_store.append (out iter);
			list_store.set (iter, 0, article.name, 1, article.date);
			return true;
		});
		
		tree = new Gtk.TreeView.with_model (list_store);
		cell = new Gtk.CellRendererText ();
		tree.insert_column_with_attributes (-1, "Title", cell, "text", 0);
		tree.insert_column_with_attributes (-1, "Date", cell, "text", 1);
		tree.row_activated.connect (on_row_clicked);
		main_window.status_bar.info.label = _("%i articles").printf (my_page.children.size);
		
		scroller.add (tree);
		scroller.show_all ();
	}
	
	private void on_row_clicked (Gtk.TreePath path, Gtk.TreeViewColumn column) {
		var i = path.get_indices () [0];
		var page = my_page.children.@get (i);
		main_window.notebook.open_page (page);
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
	}
	
	public override void on_save () {
		base.on_save ();
		my_page.save ();
	}
	
}
