using GLib;

public class Desidia.Page : GLib.Object {
	
	public string name {get; set;}
	public string url {get; set;}
	
	public bool accepts_children {get; set;}
	public Page? parent {get; set;}
	
	public Page () {
		name = _("Unnamed Page");
		url = "unnamed";
		accepts_children = false;
	}
	
	public string get_full_url () {
		return ""; //app.current_project.get_full_url () + "/" + this.url;
	}
	
	public string render_html () {
		// var markdown = new Markdown.Document.gfm_format (source_buffer.text.data);
		// markdown.compile ();
		// string result;
		// markdown.get_document (out result);
		// return (result);
		return "";
	}
	
}
