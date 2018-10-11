using Granite;

public class Ligo.Widgets.Sidebar : Granite.Widgets.SourceList {
	
	public Granite.Widgets.SourceList.ExpandableItem pages;
	public Granite.Widgets.SourceList.ExpandableItem snippets;

	construct {
		pages = new Granite.Widgets.SourceList.ExpandableItem ("Pages");
		pages.collapsible = false;
		snippets = new Granite.Widgets.SourceList.ExpandableItem ("Snippets");
		snippets.collapsible = true;
	}
	
	public Sidebar () {
		root.add (pages);
		root.add (snippets);
		item_selected.connect (item => {
			item.activated ();
		});
	}
	
	public void add_page (Pages.Base page) {
		var item = new Granite.Widgets.SourceList.Item (page.name);
		item.icon = new ThemedIcon (page.icon_name);
		item.activated.connect (() => main_window.notebook.open_page (page));
		pages.add (item);
	}

}
