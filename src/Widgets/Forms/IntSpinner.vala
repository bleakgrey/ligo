using Gtk;

public class Ligo.Widgets.Forms.IntSpinner : SpinButton {

	private static Type TYPE = typeof (int64);
	private weak Object my_object;

	public IntSpinner (Object obj, string param, int min, int max) {
		my_object = obj;
		
		Value current = Value (TYPE);
		my_object.get_property (param, ref current);
		adjustment.page_size = 1;
		adjustment.page_increment = 1;
		adjustment.step_increment = 1;
		adjustment.lower = min;
		adjustment.upper = max + 1;
		adjustment.value = current.get_int64 ();
		
		my_object.notify[param].connect (spec => {
			Value val = Value (TYPE);
			my_object.get_property (spec.name, ref val);
			adjustment.value = current.get_int64 ();
		});
		
		changed.connect (() => {
			Value val = Value (TYPE);
			val.set_int64 ((int64) adjustment.value);
			my_object.set_property (param, val);
			GLib.Signal.emit_by_name (my_object, "changed");
		});
		
	}

}
