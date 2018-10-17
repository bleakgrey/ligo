using Gtk;
using Gee;
using Granite;

namespace Ligo {
    
    public static Application app;
    public static Windows.Main? main_window;
    public static HashMap<string,Theme> themes;
    
    public class Application : Granite.Application {
    
    	public signal void export_progress (int total, int completed);
    
        construct {
            application_id = "com.github.bleakgrey.ligo";
            flags = ApplicationFlags.FLAGS_NONE;
            program_name = "Ligo";
            build_version = "0.1";
            themes = new HashMap<string,Theme> ();
        }
    
        public static int main (string[] args) {
            Gtk.init (ref args);
            app = new Application ();
            return app.run (args);
        }
    
        protected override void activate () {
            main_window = new Windows.Main (this);
            main_window.present ();
			
			Theme.load_available ();
            Project.open_from_path ("/home/blue/Documents/Sites/Example");
        }
    
    }

}
