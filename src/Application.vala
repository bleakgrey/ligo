using Gtk;
using Granite;

namespace Desidia {
    
    public static Application app;
    
    public class Application : Granite.Application {
    
        public static Gtk.Window main_window;
    
        construct {
            application_id = "com.github.bleakgrey.desidia";
            flags = ApplicationFlags.FLAGS_NONE;
            program_name = "Desidia";
            build_version = "0.1";
        }
    
        public static int main (string[] args) {
            Gtk.init (ref args);
            Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.INFO;
            app = new Application ();
            return app.run (args);
        }
    
        protected override void activate () {
            main_window = new Windows.Main (this);
            main_window.present ();
        }
    
    }

}
