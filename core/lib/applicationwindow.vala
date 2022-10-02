namespace Tokyo {
  public class ApplicationWindow : Window {
    private Application? _application;

    public Application? application {
      get {
        return this._application;
      }
      construct {
        this._application = value;
      }
    }
  }
}
