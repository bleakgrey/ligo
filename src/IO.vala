public class Ligo.IO {
	
	public IO () {}
	
	public static string read_file (string path) {
		uint8[] data;
		string etag;
		var file = File.new_for_path (path);
		file.load_contents (null, out data, out etag);
		return (string) data;
	}
	
	public static Json.Object? read_json (string path) {
		var contents = read_file (path);
		var parser = new Json.Parser ();
		parser.load_from_data (contents, -1);
		var root = parser.get_root ().get_object ();
		return root;
	}
	
	public static void overwrite_file (string path, string contents) {
		var file = File.new_for_path (path);
		if (file.query_exists ())
			file.@delete ();
		
		FileOutputStream stream = file.create (FileCreateFlags.PRIVATE);
		stream.write (contents.data);
	}
	
	public static bool dir_exists (string path) {
		return GLib.FileUtils.test (path, GLib.FileTest.IS_DIR);
	}
	
	public static void make_dir (string path) {
		var dir = File.new_for_path (path);
		dir.make_directory_with_parents ();
	}
	
	
	
	
	
	public delegate void DirForEachDelegate (File file, string path);
	public void dir_foreach (string path, DirForEachDelegate d) {
		if (!dir_exists (path))
			return;
		
		var dir = File.new_for_path (path);
		try {
			var enumerator = dir.enumerate_children ("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
			FileInfo info = null;
			while ((info = enumerator.next_file (null)) != null) {
				if (info.get_file_type () != FileType.DIRECTORY) {
					var file_path = Path.build_filename (path, info.get_name ());
					var file = File.new_for_path (file_path);
					d (file, file_path);
				}
			}
		}
		catch (Error e) {
			warning (e.message);
		}
	}
	
}
