using Gtk;
using Granite;

public class Desidia.Widgets.Tabs.PageEditor : AbstractTab {
	
	public Widgets.SourceView editor;
	
	construct {
		editor = new Widgets.SourceView ();
		editor.source_buffer.changed.connect (on_content_changed);
	}
	
	public PageEditor () {
		base ();
		label = "Page Editor";
		scroller.add (editor);
		scroller.show_all ();
		on_content_changed ();
	}
	
	public void on_content_changed () {
		try {
			var reg = new Regex("[\\s\\W]+", RegexCompileFlags.OPTIMIZE);
			var text = editor.source_buffer.text;
			string result = reg.replace (text, text.length, 0, " ");
			
			var words = result.strip().split(" ").length;
			var read_time = words / 275; // Average words per minute
			
			main_window.status_bar.info.label = _("%i words (%i min read)").printf (words, read_time);
		}
		catch (Error e) {
			// Who cares?
		}
	}
	
}
