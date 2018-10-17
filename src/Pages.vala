namespace Ligo.Pages {

	public static Type[] get_all_types () {
		Type[] types = {};
		types += typeof (Pages.Text);
		types += typeof (Pages.Blog);
		return types;
	}

	public static Pages.Base? parse (ref Json.Object root, Pages.Base? parent = null) {
		Pages.Base page = null;
		var type = root.get_string_member ("type");
		switch (type) {
			case Pages.Text.TYPE:
				page = new Pages.Text ();
				break;
			case Pages.Blog.TYPE:
				page = new Pages.Blog ();
				break;
			case Pages.BlogArticle.TYPE:
				page = new Pages.BlogArticle ();
				break;
			default:
				warning ("Unknown page type: %s", type);
				return null;
		}
		page.parent = parent;
		page.read_save_data (ref root);
		
		// Read children pages
		var file_io = new IO ();
		file_io.dir_foreach (page.get_children_path (), (file, path) => {
			var child_root = IO.read_json (path);
			var child = Pages.parse (ref child_root, page);
			page.children.add (child);
		});
		if (page.children.size > 0)
			info ("Loaded %i child pages", page.children.size);
		
		return page;
	}
	
}
