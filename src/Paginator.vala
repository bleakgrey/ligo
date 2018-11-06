using Gee;

public class Ligo.Paginator : GLib.Object {

	private Pages.Paginated owner;
	private Pages.Base root;
	private Gee.List<Pages.Base> pages;
	private Gee.List<Pages.Paginated> output;
	private int64 delta;

	public Paginator (Pages.Paginated _owner, Gee.List<Pages.Base> _pages, int64 _delta) {
		owner = _owner;
		pages = _pages;
		delta = _delta;
		output = new ArrayList<Pages.Paginated>();
	}

	public void collate () {
		var i = 0;
		var page_num = 0;
		var items = new ArrayList<Pages.Base>();
		
		Pages.Paginated? prev = null;
		Pages.Paginated? next = null;
		
		root = new Pages.Base ();
		root.permalink = "pages";
		root.parent = owner;
		owner.children.add (root);
		Project.opened.export_page (root);
		
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
					if (new_page.items.size > 0)
						root.children.add (new_page);
					
					if (prev != null && new_page.items.size > 0)
						prev.next = new_page;
					
					new_page.prev = prev;
					prev = new_page;
				}
				
				i = 0;
				items.clear ();
			}
			return true;
		});
		
		Project.opened.export_page (root);
		owner.children.remove (root);
	}

	private Pages.Paginated make_page (int i, Gee.List<Pages.Base> items) {
		var page = new Pages.Blog ();
		page.permalink = i.to_string ();
		page.parent = root;
		page.items.add_all (items);
		page.items.remove (root);
		return page;
	}

}
