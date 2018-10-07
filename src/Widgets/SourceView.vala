using Gtk;

public class Desidia.Widgets.SourceView : Gtk.SourceView {

public static string text = """## Sub-heading ######

Paragraphs are separated by a blank line.
Two spaces at the end of a line produces a line break.

Text attributes _italic_, **bold**, `monospace`.

Horizontal rule:
---

Bullet list:
* apples
* oranges
* pears
Numbered list:
1. wash
2. rinse
3. repeat

A [link][example].
[example]: http://example.com

![Image](Image_icon.png "icon")

> Markdown uses email-style > characters for blockquoting.

<abbr title="Hypertext Markup Language">HTML</abbr>.
""";

	public SourceLanguageManager manager;
	public SourceBuffer source_buffer;

	construct {
		manager = Gtk.SourceLanguageManager.get_default ();
		source_buffer = new SourceBuffer (null);
		source_buffer.highlight_syntax = true;
		source_buffer.language = manager.get_language ("markdown");
		set_buffer (source_buffer);
		source_buffer.text = text;
		wrap_mode = WrapMode.WORD;
		monospace = true;
		highlight_current_line = true;
		
		var font = new GLib.Settings ("org.gnome.desktop.interface").get_string ("monospace-font-name");
		override_font (Pango.FontDescription.from_string (font));
		// space_drawer.enable_matrix = true;
		// space_drawer.set_types_for_locations (SourceSpaceLocationFlags.ALL, SourceSpaceTypeFlags.NONE);
		// space_drawer.set_types_for_locations (SourceSpaceLocationFlags.TRAILING, SourceSpaceTypeFlags.SPACE | SourceSpaceTypeFlags.TAB);
	}

	public SourceView () {
		
	}

}
