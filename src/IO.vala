public class Ligo.IO {
	
	public static string read_file (string path) {
		uint8[] data;
		string etag;
		var file = File.new_for_path (path);
		file.load_contents (null, out data, out etag);
		return (string) data;
	}
	
	public static void overwrite_file (string path, string contents) {
		var file = File.new_for_path (path);
		if (file.query_exists ())
			file.@delete ();
		
		FileOutputStream stream = file.create (FileCreateFlags.PRIVATE);
		stream.write (contents.data);
	}
	
}
