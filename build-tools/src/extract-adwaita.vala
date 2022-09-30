public static int main(string[] args) {
  if (args.length != 2) {
    stderr.printf("%s: must have one argument\n", args[0]);
    return 1;
  }

  Adw.init();

  try {
    var bytes = GLib.resources_lookup_data(args[1], GLib.ResourceLookupFlags.NONE).get_data();
    assert(bytes != null);
    for (var i = 0; i < bytes.length; i++) stdout.printf("%c", bytes[i]);
  } catch (GLib.Error e) {
    stderr.printf("%s: failed to pull resource \"%s\": %s:%d: %s\n", args[0], args[1], e.domain.to_string(), e.code, e.message);
    return 1;
  }
  return 0;
}
