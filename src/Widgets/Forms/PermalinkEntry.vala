using Gtk;

public class Ligo.Widgets.Forms.PermalinkEntry : Entry {

	public PermalinkEntry () {}
	
	public new void set_text (string text) {
		var normalized = text
			.chomp ()
			.chug ()
			.down ()
			.replace (" ", "-")
			.replace (".", "")
			.replace (",", "")
			.replace ("'", "");
		base.set_text (normalized);
	}

}
