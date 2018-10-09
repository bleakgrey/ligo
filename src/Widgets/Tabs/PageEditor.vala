using Gtk;
using Granite;

public class Desidia.Widgets.Tabs.PageEditor : AbstractTab {
	
	public Widgets.SourceView editor;
	protected Pages.Base my_page;
	
	construct {
		editor = new Widgets.SourceView ();
		editor.source_buffer.changed.connect (on_content_changed);
	}
	
	public PageEditor (Pages.Base page) {
		base ();
		my_page = page;
		label = my_page.name;
		scroller.add (editor);
		scroller.show_all ();
		on_content_changed ();
	}
	
	public override void on_switched () {
		on_content_changed ();
		main_window.status_bar.show ();
	}
	
	public void on_content_changed () {
		try {
			var reg = new Regex("[\\s\\W]+", RegexCompileFlags.OPTIMIZE);
			var text = editor.source_buffer.text;
			string result = reg.replace (text, text.length, 0, " ");
			
			var words = result.strip().split(" ").length;
			var read_time = words / 275; // Average words per minute
			
			if (read_time <= 0)
				main_window.status_bar.info.label = _("%i words").printf (words);
			else
				main_window.status_bar.info.label = _("%i words (%i min read)").printf (words, read_time);
		}
		catch (Error e) {
			// Who cares?
		}
	}

	public override bool is_page_owner (Pages.Base page) {
		return this.my_page == page;
	}
	
}
