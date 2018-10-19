using Gtk;

public class Ligo.Widgets.Forms.Label : Gtk.Label {

    public Label (string text) {
        label = text;
        halign = Align.END;
        //margin_start = 12;
    }

}
