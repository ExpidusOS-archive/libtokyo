namespace Tokyo {
  /**
   * Enums of the color schemes
   */
  public enum ColorScheme {
    /**
     * Tokyo Night, the default color scheme.
     */
    NIGHT = 0,

    /**
     * Tokyo Night Light, its like Tokyo Night but its a light color scheme.
     */
    LIGHT,

    /**
     * Tokyo Night Storm, similar to Tokyo Night but with alternative colors.
     */
    STORM
  }

  /**
   * Provider for StyleManager
   */
  public interface StyleManagerProvider : GLib.Object {
    public abstract unowned StyleManager? get_default();
    public abstract void ensure();

    public abstract void create(StyleManager style_manager);
    public abstract void destroy(StyleManager style_manager);
    public abstract ColorScheme get_color_scheme(StyleManager style_manager);
  }

  /**
   * Management class used for providing styles
   */
  public sealed class StyleManager : GLib.Object {
    private Provider? _provider;

    public Provider provider {
      get {
        if (this._provider == null) this._provider = Provider.get_global();
        return this._provider;
      }
      set construct {
        this._provider = value;
      }
    }

    public ColorScheme color_scheme {
      get {
        var color = GLib.Environment.get_variable("TOKYO_COLOR");
        if (color != null) {
          if (color == "night" || color == "default") {
            return ColorScheme.NIGHT;
          }
          if (color == "light") {
            return ColorScheme.LIGHT;
          }
          if (color == "storm") {
            return ColorScheme.STORM;
          }
        }

        return this.provider.get_style_manager_provider().get_color_scheme(this);
      }
    }

    public StyleManager() {
      Object();
    }

    public StyleManager.with_provider(Provider provider) {
      Object(provider: provider);
    }

    construct {
      this.provider.get_style_manager_provider().create(this);
    }

    ~StyleManager() {
      this.provider.get_style_manager_provider().destroy(this);
    }

    public static StyleManager get_default() {
      var def = Provider.get_global().get_style_manager_provider().get_default();
      assert(def != null);
      return def;
    }

    public static void ensure() {
      Provider.get_global().get_style_manager_provider().ensure();
    }
  }
}
