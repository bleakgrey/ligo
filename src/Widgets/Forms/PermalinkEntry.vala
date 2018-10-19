using Gtk;

public class Ligo.Widgets.Forms.PermalinkEntry : Entry {

	private weak Pages.Base? my_page;

	public PermalinkEntry (Pages.Base? page = null) {
		my_page = page;
		if (my_page != null) {
			text = my_page.permalink;
		
			my_page.notify["permalink"].connect (() => {
				set_text (my_page.permalink);
			});
			
			changed.connect (() => {
				my_page.permalink = text;
				my_page.changed ();
			});
			
			editable = false;
			secondary_icon_activatable = true;
			secondary_icon_name = "changes-prevent-symbolic";
			secondary_icon_tooltip_markup = _("Old permalink will no longer be valid!\nClick to unlock editing");
			icon_press.connect (() => {
				secondary_icon_name = null;
				editable = true;
			});
		}
	}
	
	public new void set_text (string text) {
		var normalized = text
			.chomp ()
			.chug ()
			.down ()
			.replace (" ", "-")
			.replace (".", "")
			.replace (",", "")
			.replace ("'", "")
			.replace ("~", "")
			.replace ("?", "")
			.replace ("!", "");
		base.set_text (normalized);
	}

}
