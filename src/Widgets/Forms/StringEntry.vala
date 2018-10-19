using Gtk;

public class Ligo.Widgets.Forms.StringEntry : Entry {

	private static Type TYPE = typeof (string);
	private weak Object my_object;

	public StringEntry (Object obj, string param) {
		my_object = obj;
		
		Value current = Value (TYPE);
		my_object.get_property (param, ref current);
		text = current.get_string ();
		
		my_object.notify[param].connect (spec => {
			Value val = Value (TYPE);
			my_object.get_property (spec.name, ref val);
			text = val.get_string ();
		});
		
		changed.connect (() => {
			Value val = Value (TYPE);
			val.set_string (text);
			my_object.set_property (param, val);
			GLib.Signal.emit_by_name (my_object, "changed");
		});
		
	}

}
