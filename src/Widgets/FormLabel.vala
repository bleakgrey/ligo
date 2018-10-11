using Gtk;

public class Ligo.Widgets.FormLabel : Label {

    public FormLabel (string text) {
        label = text;
        halign = Align.END;
        margin_start = 12;
    }

}
