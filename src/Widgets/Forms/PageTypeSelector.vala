using Gtk;

public class Ligo.Widgets.Forms.PageTypeSelector : ComboBox {

	private Gtk.ListStore list_store;
	private TreeIter iter;

	public Type[]? allowed_types;

	construct {
		list_store = new Gtk.ListStore (2, typeof (string), typeof (string));
		
		var icon = new Gtk.CellRendererPixbuf ();
		this.pack_start (icon, true);
		this.add_attribute (icon, "icon-name", 0);
		this.active = 0;
		
		var text = new Gtk.CellRendererText ();
		this.pack_start (text, true);
		this.add_attribute (text, "text", 1);
		this.active = 0;
	}

	public PageTypeSelector (Type[]? types = null) {
		if (types == null)
			allowed_types = Pages.get_all_types ();
		else
			allowed_types = types;
			
		sensitive = allowed_types.length > 1;
		
		foreach (Type page_type in allowed_types) {
			var page = (Pages.Base) Object.@new (page_type);
			list_store.append (out iter);
			list_store.set (iter, 0, page.icon_name, 1, page.get_display_type ());
		}
		
		model = list_store;
	}
	
	public Pages.Base create () {
		var selected = get_active ();
		var page_type = allowed_types[selected];
		return (Pages.Base) Object.@new (page_type);
	}

}
