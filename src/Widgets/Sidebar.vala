using Granite;

public class Desidia.Widgets.Sidebar : Gtk.Frame {

	public Granite.Widgets.SourceList source_list;
	
	public Granite.Widgets.SourceList.ExpandableItem pages;
	public Granite.Widgets.SourceList.ExpandableItem snippets;

	construct {
		
		pages = new Granite.Widgets.SourceList.ExpandableItem ("Pages");
		pages.collapsible = false;
		snippets = new Granite.Widgets.SourceList.ExpandableItem ("Snippets");
		snippets.collapsible = true;
		
		source_list = new Granite.Widgets.SourceList ();
		source_list.root.add (pages);
		source_list.root.add (snippets);
		add (source_list);
		
		// add_page ("Blog", "go-home");
		// add_page ("Works");
		// add_page ("Book");
		// add_page ("Contact");
		
		source_list.item_selected.connect (item => {
			item.activated ();
		});
	}
	
	public void add_page (Pages.Base page) {
		var item = new Granite.Widgets.SourceList.Item (page.name);
		item.icon = new ThemedIcon ("folder-documents");
		item.activated.connect (() => main_window.notebook.open_page (page));
		pages.add (item);
	}

}
