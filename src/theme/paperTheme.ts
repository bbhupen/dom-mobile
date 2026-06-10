import { MD3LightTheme } from 'react-native-paper';
import { colors } from './colors';

export const paperTheme = {
  ...MD3LightTheme,
  roundness: 8,
  colors: {
    ...MD3LightTheme.colors,
    primary: colors.primary,
    secondary: '#3b6f8f',
    background: colors.background,
    surface: colors.card,
    surfaceVariant: '#eef2f6',
    outline: colors.borderStrong,
    error: colors.danger,
    onSurface: colors.text,
    onSurfaceVariant: colors.textMuted,
  },
};
