using Gtk;
using Granite;

public class Ligo.Widgets.Tabs.PageEditor : Base {
	
	public Widgets.SourceView editor;
	protected Pages.Text my_page;
	
	private GtkSpell.Checker? spell;
	private string lang_dict;
	
	construct {
		editor = new Widgets.SourceView ();
		editor.source_buffer.changed.connect (on_content_changed);
	}
	
	public PageEditor (Pages.Text page) {
		base ();
		my_page = page;
		label = my_page.name;
		scroller.add (editor);
		scroller.show_all ();
		
		editor.source_buffer.begin_not_undoable_action ();
		editor.source_buffer.text = page.content;
		editor.source_buffer.end_not_undoable_action ();
		on_content_changed ();
		
		editor.source_buffer.changed.connect (() => {
			has_changed = true;
		});
		//attach_spell_check ();
	}
	
	public override void on_switched () {
		base.on_switched ();
		on_content_changed ();
		var status_bar = main_window.status_bar;
		status_bar.show ();
		status_bar.add_page_button.hide ();
		status_bar.delete_page_button.hide ();
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
		return my_page == page;
	}
	
	public override void on_save () {
		base.on_save ();
		my_page.content = editor.source_buffer.text;
		my_page.save ();
	}
	
	private void attach_spell_check () {
		try {
			if (GtkSpell.Checker.get_from_text_view (editor) == null) {
				spell = new GtkSpell.Checker ();
				var language_list = GtkSpell.Checker.get_language_list ();
				lang_dict = language_list.first ().data;
				spell.set_language (lang_dict);
				spell.attach (editor);
			}
		}
		catch (Error e) {
			warning (e.message);
		}
	}
	
}
