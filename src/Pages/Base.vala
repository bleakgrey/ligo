using GLib;

public class Desidia.Pages.Base : GLib.Object {
	
	public string name {get; set;}
	public string url {get; set;}
	
	public Base () {
		name = _("Unnamed Page");
		url = "unnamed";
	}
	
	public virtual Widgets.Tabs.Base? create_tab () {
		return new Widgets.Tabs.PageEditor (this);
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

namespace Desidia.Pages {

	public static Pages.Base? parse (Json.Object root) {
		Pages.Base page = null;
		
		var type = root.get_string_member ("type");
		switch (type) {
			case "blog":
				page = new Pages.Blog ();
				break;
			default:
				page = new Pages.Base ();
				break;
		}
		
		page.url = root.get_string_member ("url");
		page.name = root.get_string_member ("name");
		
		return page;
	}
	
}
