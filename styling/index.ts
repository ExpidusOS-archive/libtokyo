import { default as palettes } from "./palettes";

export { default as tailwindcss } from "./tailwindcss";
export { default as palettes } from "./palettes";

function createPrism(colors: Record<string, string>, name: string): object {
  return {
    colors: {
      AlternateBase: colors.background,
      Base: colors.background,
      BrightText: colors["accent-text"],
      Button: colors.background,
      ButtonText: colors.text,
      Highlight: colors["blue-dark"],
      Link: colors.blue,
      ToolTipBase: colors.text,
      ToolTipText: colors.text,
      Window: colors.background,
      WindowText: colors.text,
      fadeAmount: 0.5,
      fadeColor: colors.background
    },
    name: name,
    widgets: "adwaita"
  };
}

export const prism: Record<string, object> = {
  default: createPrism(palettes.default, "Tokyo Night"),
  light: createPrism(palettes.light, "Tokyo Night Light"),
  storm: createPrism(palettes.storm, "Tokyo NIght Storm")
};
