using Gtk;

public class Ligo.Widgets.Sidebar : Box {

	public Stack stack;
	public StackSwitcher switcher;
	
	public Widgets.Structure structure;
	public Label page_config;

	construct {
		orientation = Orientation.VERTICAL;
		get_style_context ().add_class (Gtk.STYLE_CLASS_SIDEBAR);
		
		structure = new Widgets.Structure ();
		page_config = new Label ("No Settings Available");
		
		stack = new Stack ();
		stack.transition_type = StackTransitionType.SLIDE_LEFT_RIGHT;
		stack.add_named (structure, "structure");
		stack.child_set_property (structure, "icon-name", "folder-symbolic");
		stack.add_named (page_config, "page_config");
		stack.child_set_property (page_config, "icon-name", "document-properties-symbolic");
		
		switcher = new StackSwitcher ();
		switcher.stack = stack;
		switcher.homogeneous = true;
		switcher.hexpand = true;
		switcher.halign = Align.FILL;
		
		pack_start (switcher, false, false, 0);
		pack_start (stack, true, true, 0);
	}
	
	public Sidebar () {
		
	}

}
