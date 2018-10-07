using Gtk;
using Granite;

public class Desidia.Widgets.Tabs.PageList : AbstractTab {
	
	public Gtk.Label list;
	
	public PageList () {
		base ();
		label = "Blog Articles";
		list = new Label ("List of child article pages");
		scroller.add (list);
		scroller.show_all ();
	}
	
}
