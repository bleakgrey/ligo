using Gtk;

public class Ligo.Widgets.Forms.DatePicker : Granite.Widgets.DatePicker {

	public const string FORMAT = "%F";
	private static Type TYPE = typeof (int64);
	private weak Object my_object;
	
	public DatePicker (Object obj, string param) {
		my_object = obj;
		
		Value current = Value (TYPE);
		my_object.get_property (param, ref current);
		var raw_date = current.get_int64 ();
		date = new DateTime.from_unix_local (raw_date);
		
		date_changed.connect (() => {
			Value val = Value (TYPE);
			val.set_int64 (date.to_unix ());
			my_object.set_property (param, val);
			GLib.Signal.emit_by_name (my_object, "changed");
		});
		
	}
	
}
