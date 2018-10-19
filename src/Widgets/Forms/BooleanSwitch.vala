using Gtk;

public class Ligo.Widgets.Forms.BooleanSwitch : Switch {

	private static Type TYPE = typeof (bool);
	private weak Object my_object;

	public BooleanSwitch (Object obj, string param) {
		my_object = obj;
		halign = Align.START;
		
		Value current = Value (TYPE);
		my_object.get_property (param, ref current);
		active = current.get_boolean ();
		
		my_object.notify[param].connect (spec => {
			Value val = Value (TYPE);
			my_object.get_property (spec.name, ref val);
			active = val.get_boolean ();
		});
		
		state_set.connect (state => {
			Value val = Value (TYPE);
			val.set_boolean (state);
			my_object.set_property (param, val);
			notify_property ("changed");
			return state;
		});
		
	}

}
