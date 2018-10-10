using Gtk;
using Granite;

public class Desidia.Widgets.Tabs.PageEditor : Base {
	
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
		
		editor.source_buffer.begin_not_undoable_action ();
		editor.source_buffer.text = page.content;
		editor.source_buffer.end_not_undoable_action ();
		on_content_changed ();
	}
	
	public override void on_switched () {
		on_content_changed ();
		var status_bar = main_window.status_bar;
		status_bar.show ();
		status_bar.page_settings_button.show ();
		status_bar.add_page_button.hide ();
	}
	
	public void on_content_changed () {
		try {
			var reg = new Regex("[\\s\\W]+", RegexCompileFlags.OPTIMIZE);
			var text = editor.source_buffer.text;
			string result = reg.replace (text, text.length, 0, " ");
			
			var words = result.strip().split(" ").length;
			var read_time = words / 250;
			
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
	
	public void save_page () {
		var output = editor.source_buffer.text;
		info (output);
		
		var path = my_page.get_save_path ();
		var file = File.new_for_path (path);
		if (file.query_exists ())
			file.@delete ();
		
		var builder = new Json.Builder ();
		builder.begin_object ();
		builder.set_member_name ("content");
		builder.add_string_value (output);
		builder.end_object ();
		
		var generator = new Json.Generator ();
		generator.set_root (builder.get_root ());
		var data = generator.to_data (null);
		
		FileOutputStream stream = file.create (FileCreateFlags.PRIVATE);
		stream.write (data.data);
	}
	
}
