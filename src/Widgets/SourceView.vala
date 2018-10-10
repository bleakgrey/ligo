using Gtk;

public class Ligo.Widgets.SourceView : Gtk.SourceView {

	public SourceLanguageManager manager;
	public SourceBuffer source_buffer;

	construct {
		manager = Gtk.SourceLanguageManager.get_default ();
		source_buffer = new SourceBuffer (null);
		source_buffer.highlight_syntax = true;
		source_buffer.language = manager.get_language ("markdown");
		set_buffer (source_buffer);
		wrap_mode = WrapMode.WORD;
		monospace = true;
		highlight_current_line = true;
		
		var font = new GLib.Settings ("org.gnome.desktop.interface").get_string ("monospace-font-name");
		override_font (Pango.FontDescription.from_string (font));
	}

	public SourceView () {}

}
