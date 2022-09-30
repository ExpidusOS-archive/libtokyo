#include <gio/gio.h>
#include <adwaita.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char** argv) {
  if (argc != 2) {
    fprintf(stderr, "%s: must have two arguments\n", argv[0]);
    return EXIT_FAILURE;
  }

  adw_init();

  GError* error = NULL;
  GBytes* bytes = g_resources_lookup_data(argv[1], G_RESOURCE_LOOKUP_FLAGS_NONE, &error);
  if (bytes == NULL) {
    fprintf(stderr, "%s: failed to look up \"%s\" %s:%d: %s\n", argv[0], argv[1], g_quark_to_string(error->domain), error->code, error->message);
    return EXIT_FAILURE;
  }

  size_t n_data = 0;
  gconstpointer data = g_bytes_get_data(bytes, &n_data);
  if (bytes == NULL || n_data == 0) {
    fprintf(stderr, "%s: failed to get data from bytes of resource \"%s\"\n", argv[0], argv[1]);
    return EXIT_FAILURE;
  }

  for (size_t i = 0; i < n_data; i++) printf("%c", ((char*)(data))[i]);
  g_bytes_unref(bytes);
  return EXIT_SUCCESS;
}
