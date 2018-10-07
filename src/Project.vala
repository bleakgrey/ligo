using GLib;

public class Desidia.Project : GLib.Object {
	
	public string name {get; set;}
	public string description {get; set;}
	
	public Project () {
		name = _("Unnamed Project");
		description = _("A simple site");
	}
	
}
