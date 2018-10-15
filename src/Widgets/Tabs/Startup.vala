using Gtk;
using Granite;

public class Ligo.Widgets.Tabs.Startup : Base {

	public Granite.Widgets.Welcome welcome;

	construct {
		welcome = new Granite.Widgets.Welcome (_("Nothing to See Here"), _("Select a page to edit"));
		welcome.append ("document-new", _("New Page"), _("Create a new page"));
		welcome.append ("document-open", _("Open Project"), _("Open a site for editing"));
		welcome.activated.connect ((i) => {
			switch (i) {
				case 0:
					Windows.NewPage.open ();
					break;
				case 1:
					break;
			}
		});
	}

	public Startup () {
		base ();
		scroller.add (welcome);
		scroller.show_all ();
	}
	
	public override void on_switched () {
		main_window.status_bar.hide ();
	}

}
