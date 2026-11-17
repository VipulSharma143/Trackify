export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
} as const;

export const radius = { md: 12, pill: 999 } as const;

/** Content never grows wider than this, so wide browser windows stay readable. */
export const maxContentWidth = 720;
