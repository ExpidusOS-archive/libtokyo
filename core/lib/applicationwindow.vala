namespace Tokyo {
  public class ApplicationWindow : Window {
    private Application? _application;
    private uint _dbus_menu_id;

    public Application? application {
      get {
        return this._application;
      }
      construct {
        this._application = value;
      }
    }

    internal override bool dbus_register(GLib.DBusConnection connection, string object_path) throws GLib.Error {
      return_val_if_fail(base.dbus_register(connection, object_path), false);

      if (this.application != null && this._dbus_menu_id == 0) {
        this._dbus_menu_id = connection.export_menu_model(object_path, this.application.get_menu());
      }
      return true;
    }

    internal override void dbus_unregister(GLib.DBusConnection connection, string object_path) {
      base.dbus_unregister(connection, object_path);

      if (this._dbus_menu_id > 0) {
        connection.unexport_menu_model(this._dbus_menu_id);
        this._dbus_menu_id = 0;
      }
    }

    public override void unmap() {
      base.unmap();

      if (this.application != null) {
        this.application.remove_window(this);
      }
    }
  }
}
