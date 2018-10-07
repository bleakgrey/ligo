using GLib;

public class Desidia.Page : GLib.Object {
	
	public string name {get; set;}
	public string purpose {get; set;}
	
	public Page () {
		name = _("Unnamed Page");
	}
	
}
