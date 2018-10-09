using Gtk;
using Granite;

namespace Desidia {
    
    public static Application app;
    public static Windows.Main? main_window;
    
    public class Application : Granite.Application {
    
        construct {
            application_id = "com.github.bleakgrey.desidia";
            flags = ApplicationFlags.FLAGS_NONE;
            program_name = "Desidia";
            build_version = "0.1";
        }
    
        public static int main (string[] args) {
            Gtk.init (ref args);
            app = new Application ();
            return app.run (args);
        }
    
        protected override void activate () {
            main_window = new Windows.Main (this);
            main_window.present ();
			
            Project.open_from_path ("/home/blue/Documents/Sites/Example");
        }
    
    }

}
