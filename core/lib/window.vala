namespace Tokyo {
  /**
   * Provider for windows
   */
  public interface WindowProvider : GLib.Object {
    public abstract uint get_id(Window win);
    
    public abstract void create(Window win);
    public abstract void destroy(Window win);

    public virtual signal void map(Window win);
    public virtual signal void unmap(Window win);

    public virtual signal void show(Window win);
    public virtual signal void hide(Window win);
  }

  /**
   * Base window type used for DBus
   */
  [DBus(name = "com.expidus.libtokyo.Window")]
  public interface BaseWindow : GLib.Object {
    public abstract uint id { get; }

    public abstract signal void map();
    public abstract signal void unmap();

    public abstract signal void show();
    public abstract signal void hide();
  }

  /**
   * Window class, used for showing widgets
   */
  public class Window : GLib.Object, BaseWindow {
    private Provider? _provider;

    private GLib.Mutex _map_mutex;
    private GLib.Mutex _unmap_mutex;

    private GLib.Mutex _show_mutex;
    private GLib.Mutex _hide_mutex;
    
    private ulong _map_id;
    private ulong _unmap_id;
    
    private ulong _show_id;
    private ulong _hide_id;

    private uint _dbus_obj_id;

    public uint id {
      get {
        return this.provider.get_window_provider().get_id(this);
      }
    }

    public Provider provider {
      get {
        if (this._provider == null) this._provider = Provider.get_global();
        return this._provider;
      }
      set construct {
        this._provider = value;
      }
    }

    construct {
      this._map_mutex = GLib.Mutex();
      this._unmap_mutex = GLib.Mutex();
      this._show_mutex = GLib.Mutex();
      this._hide_mutex = GLib.Mutex();

      this.provider.get_window_provider().create(this);

      this._map_id = this.provider.get_window_provider().map.connect((win) => {
        if (win.id == this.id) {
          if (this._map_mutex.trylock()) {
            this.map();
            this._map_mutex.unlock();
          }
        }
      });

      this._unmap_id = this.provider.get_window_provider().unmap.connect((win) => {
        if (win.id == this.id) {
          if (this._unmap_mutex.trylock()) {
            this.unmap();
            this._unmap_mutex.unlock();
          }
        }
      });

      this._show_id = this.provider.get_window_provider().show.connect((win) => {
        if (win.id == this.id) {
          if (this._show_mutex.trylock()) {
            this.show();
            this._show_mutex.unlock();
          }
        }
      });

      this._hide_id = this.provider.get_window_provider().hide.connect((win) => {
        if (win.id == this.id) {
          if (this._hide_mutex.trylock()) {
            this.hide();
            this._hide_mutex.unlock();
          }
        }
      });
    }

    ~Window() {
      this.provider.get_window_provider().disconnect(this._map_id);
      this.provider.get_window_provider().disconnect(this._unmap_id);
      this.provider.get_window_provider().destroy(this);
    }

    internal bool dbus_register(GLib.DBusConnection connection, string object_path) throws GLib.Error {
      if (this._dbus_obj_id == 0) {
        this._dbus_obj_id = connection.register_object(object_path, this as BaseWindow);
      }
      return true;
    }

    internal void dbus_unregister(GLib.DBusConnection connection, string object_path) {
      if (this._dbus_obj_id > 0) {
        connection.unregister_object(this._dbus_obj_id);
        this._dbus_obj_id = 0;
      }
    }

    public void map() {
      if (this._map_mutex.trylock()) {
        this.provider.get_window_provider().map(this);
        this._map_mutex.unlock();
      }
    }

    public void unmap() {
      if (this._unmap_mutex.trylock()) {
        this.provider.get_window_provider().unmap(this);
        this._unmap_mutex.unlock();
      }
    }

    public void show() {
      if (this._show_mutex.trylock()) {
        this.provider.get_window_provider().show(this);
        this._show_mutex.unlock();
      }
    }

    public void hide() {
      if (this._hide_mutex.trylock()) {
        this.provider.get_window_provider().hide(this);
        this._hide_mutex.unlock();
      }
    }
  }
}
