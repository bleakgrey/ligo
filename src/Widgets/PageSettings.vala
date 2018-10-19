using Gtk;

public class Ligo.Widgets.PageSettings : Grid {

	private int i = 0;

	construct {
		//column_spacing = 12;
		//row_spacing = 6;
		margin = 6;
	}

	public PageSettings () {}
	
	public void clear () {
		@foreach (child => child.destroy ());
		i = 0;
	}
	
	public void add_section (string name) {
		var label = new Label (name);
		label.halign = Align.START;
		label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
		attach (label, 0, i);
		label.show ();
		i++;
	}

	public void add_widget (Widget widget, string name) {
		var label = new Widgets.Forms.Label (name);
		attach (label, 0, i);
		label.show ();
		widget.hexpand = true;
		attach (widget, 1, i);
		widget.show ();
		i++;
	}

}
