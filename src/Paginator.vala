using Gee;

public class Ligo.Paginator : GLib.Object {

	private Pages.Paginated owner;
	private Pages.Base root;
	private Gee.List<Pages.Base> pages;
	private Gee.List<Pages.Paginated> output;
	private int delta;

	public Paginator (Pages.Paginated _owner, Gee.List<Pages.Base> _pages, int _delta) {
		owner = _owner;
		pages = _pages;
		delta = _delta;
		
		output = new ArrayList<Pages.Paginated>();
		
		root = new Pages.Base ();
		root.permalink = "pages";
		root.parent = owner;
		Project.opened.export_page (root);
	}

	public void collate () {
		var i = 0;
		var page_num = 0;
		var items = new ArrayList<Pages.Base>();
		
		Pages.Paginated? prev = null;
		Pages.Paginated? next = null;
		
		pages.@foreach (page => {
			items.add (page);
			i++;
			if (items.size >= delta) {
				page_num++;
				
				if (page_num == 1) {
					owner.items.clear ();
					owner.items.add_all (items);
					prev = owner;
				}
				else {
					var new_page = make_page (page_num, items);
					output.add (new_page);
					
					if (prev != null)
						prev.next = new_page;
					
					new_page.prev = prev;
					prev = new_page;
				}
				
				i = 0;
				items.clear ();
			}
			return true;
		});
		
		output.@foreach (page => {
			Project.opened.export_page (page);
			return true;
		});
		
	}

	private Pages.Paginated make_page (int i, Gee.List<Pages.Base> items) {
		warning ("CREATING PAGE NUM: %i", i);
		
		var page = new Pages.Blog ();
		page.permalink = i.to_string ();
		page.parent = root;
		page.items.add_all (items);
		return page;
	}

}
