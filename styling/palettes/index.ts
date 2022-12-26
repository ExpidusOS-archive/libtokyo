import defaultVars from "./default.scss";
import lightVars from "./light.scss";
import stormVars from "./storm.scss";

export type Names = "storm" | "light" | "default";
export const names = [ "storm", "light", "default" ];

const palettes: Record<Names, object> = {
  default: defaultVars.$colors,
  light: lightVars.$colors,
  storm: stormVars.$colors
};

export default palettes
