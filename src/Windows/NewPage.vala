using Gtk;

public class Desidia.Windows.NewPage : Gtk.Dialog {

	private static NewPage instance;

	construct {
		show_all ();
	}

	public NewPage () {
		border_width = 6;
		title = _("New Page");
		transient_for = main_window;
	}
	
	public static void open () {
		if (instance == null) {
			instance = new NewPage ();
		}
		instance.present ();
	}

}
