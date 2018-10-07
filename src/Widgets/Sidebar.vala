using Granite;

public class Desidia.Widgets.Sidebar : Gtk.Frame {

	public Granite.Widgets.SourceList source_list;
	
	public Granite.Widgets.SourceList.ExpandableItem pages;
	public Granite.Widgets.SourceList.ExpandableItem settings;

	construct {
		
		pages = new Granite.Widgets.SourceList.ExpandableItem ("Pages");
		pages.collapsible = false;
		settings = new Granite.Widgets.SourceList.ExpandableItem ("Settings");
		settings.collapsible = false;
		
		source_list = new Granite.Widgets.SourceList ();
		source_list.root.add (pages);
		add (source_list);
		
		add_page ("Blog", "go-home");
		add_page ("Works");
		add_page ("Book");
		add_page ("Contact");
	}
	
	public void add_page (string name, string icon_name = "folder-documents") {
		var item = new Granite.Widgets.SourceList.Item (name);
		item.icon = new ThemedIcon (icon_name);
		pages.add (item);
	}

}
