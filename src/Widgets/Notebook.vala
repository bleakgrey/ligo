using Gtk;
using Granite;

public class Desidia.Widgets.Notebook : Granite.Widgets.DynamicNotebook {
	
	construct {
		allow_duplication = false;
		allow_restoring = false;
		add_button_visible = false;
		tab_bar_behavior = Granite.Widgets.DynamicNotebook.TabBarBehavior.ALWAYS;
		get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
	}
	
	public Notebook () {
		var tab = new Granite.Widgets.Tab ();
		tab.label = "Home";
		var label = new Widgets.EditorView ();//new Label ("TEST");
		tab.page = label;
		insert_tab (tab, 0);
	}
	
}
