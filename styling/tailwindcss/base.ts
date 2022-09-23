import Color from "color";

export const makePalletSet = (
  $colors: Record<string, string>,
  key: string
) => ({
  [key]: $colors[key],
  [`${key}-50`]: Color($colors[key]).lighten(0.05).hex(),
  [`${key}-100`]: Color($colors[key]).lighten(0.1).hex(),
  [`${key}-200`]: Color($colors[key]).lighten(0.15).hex(),
  [`${key}-300`]: Color($colors[key]).lighten(0.2).hex(),
  [`${key}-400`]: Color($colors[key]).lighten(0.25).hex(),
  [`${key}-500`]: Color($colors[key]).lighten(0.3).hex(),
  [`${key}-600`]: Color($colors[key]).darken(0.05).hex(),
  [`${key}-700`]: Color($colors[key]).darken(0.1).hex(),
  [`${key}-800`]: Color($colors[key]).darken(0.15).hex(),
  [`${key}-900`]: Color($colors[key]).darken(0.2).hex(),
});

export const makeTheme = ($colors: Record<string, string>) => ({
  primary: $colors["background"],
  "primary-content": $colors["text"],

  secondary: $colors["secondary-background"],
  "secondary-content": $colors["secondary-text"],

  accent: $colors.blue,
  "accent-content": $colors["neutral-text"],

  neutral: Color($colors["neutral-text"]).negate().hex(),
  "neutral-content": $colors["neutral-text"],

  "base-100": $colors.background,
  "base-200": Color($colors["background"])
    .mix(Color($colors["secondary-background"]), 0.5)
    .hex(),
  "base-300": $colors["secondary-background"],
  "base-content": $colors.text,

  info: $colors["blue-sky"],
  "info-content": $colors["neutral-text"],

  success: $colors.green,
  "success-content": $colors["neutral-text"],

  warning: $colors.orange,
  "warning-content": $colors["neutral-text"],

  error: $colors.red,
  "error-content": $colors["neutral-text"],

  ...makePalletSet($colors, "red"),
  ...makePalletSet($colors, "blue"),
  ...makePalletSet($colors, "green"),
  ...makePalletSet($colors, "brown"),
  ...makePalletSet($colors, "yellow"),
  ...makePalletSet($colors, "orange"),
  ...makePalletSet($colors, "purple"),
  ...makePalletSet($colors, "grey"),
});
