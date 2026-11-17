import { Image, StyleSheet, Text, View } from 'react-native';
import { statusIcons } from '../../assets/icons';
import { colors } from '../../theme/colors';
import { spacing } from '../../theme/spacing';
import { typography } from '../../theme/typography';

export type StatusLevel = 'ok' | 'warning' | 'error' | 'neutral';

type StatusIndicatorProps = {
  label: string;
  status: StatusLevel;
  detail?: string;
};

const iconFor = {
  ok: statusIcons.ok,
  warning: statusIcons.pending,
  error: statusIcons.error,
  neutral: statusIcons.pending,
} as const;

export function StatusIndicator({
  label,
  status,
  detail,
}: StatusIndicatorProps): React.JSX.Element {
  return (
    <View style={styles.row}>
      <Image
        source={iconFor[status]}
        style={styles.icon}
        accessibilityIgnoresInvertColors
      />
      <Text style={styles.label}>{label}</Text>
      {detail ? <Text style={styles.detail}>{detail}</Text> : null}
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    flexWrap: 'wrap',
    marginBottom: spacing.xs,
  },
  icon: { width: 18, height: 18, marginRight: spacing.sm },
  label: {
    ...typography.body,
    color: colors.text,
    fontWeight: '600',
    marginRight: spacing.sm,
  },
  detail: { ...typography.caption, color: colors.textMuted },
});
