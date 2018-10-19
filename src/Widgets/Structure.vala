using Gtk;
using Granite;

public class Ligo.Widgets.Structure : Granite.Widgets.SourceList {
	
	public Granite.Widgets.SourceList.ExpandableItem pages;
	public Granite.Widgets.SourceList.ExpandableItem snippets;

	protected class PageItem : Granite.Widgets.SourceList.Item {
		
		private Pages.Base page;
		
		public PageItem (Pages.Base new_page) {
			page = new_page;
			icon = new ThemedIcon (page.icon_name);
			name = page.name;
			activated.connect (() => {
				main_window.notebook.open_page (page);
			});
		}
		
		public override Gtk.Menu? get_context_menu () {
			var project = Project.opened;
			var menu = new Gtk.Menu ();
			
			if (!page.is_home) {
				var item_make_home = new Gtk.MenuItem.with_label (_("Set Home"));
				menu.add (item_make_home);
				menu.add (new Gtk.SeparatorMenuItem ());
			}
			
			if (page.can_be_removed ()) {
				var item_delete = new Gtk.MenuItem.with_label (_("Delete"));
				item_delete.activate.connect (() => {
					//TODO: Confirmation dialog
					page.remove ();
					main_window.sidebar.structure.pages.remove (this);
				});
				menu.add (item_delete);
			}
			
			var item_rename = new Gtk.MenuItem.with_label (_("Rename"));
			menu.add (item_rename);
			
			menu.show_all ();
			return menu;
		}
		
	}

	construct {
		pages = new Granite.Widgets.SourceList.ExpandableItem (_("Pages"));
		pages.expanded = true;
		snippets = new Granite.Widgets.SourceList.ExpandableItem (_("Snippets"));
	}
	
	public Structure () {
		root.add (pages);
		root.add (snippets);
		item_selected.connect (item => {
			item.activated ();
		});
	}
	
	public void add_page (Pages.Base page) {
		var item = new PageItem (page);
		pages.add (item);
	}

}
