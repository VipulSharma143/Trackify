import { Platform, StyleSheet, Text } from 'react-native';
import { AppCard } from '../components/common/AppCard';
import { AppHeader } from '../components/common/AppHeader';
import { ScreenContainer } from '../components/layout/ScreenContainer';
import { APP_VERSION } from '../shared/appInfo';
import { colors } from '../theme/colors';
import { typography } from '../theme/typography';

export function SettingsScreen(): React.JSX.Element {
  return (
    <ScreenContainer>
      <AppHeader
        title="Settings"
        subtitle="Static demonstration only. Nothing is saved."
      />
      <AppCard title="Theme">
        <Text style={styles.body}>
          Light theme (switching is not implemented).
        </Text>
      </AppCard>
      <AppCard title="App version">
        <Text style={styles.body}>{APP_VERSION}</Text>
      </AppCard>
      <AppCard title="Platform">
        <Text style={styles.body}>{Platform.OS}</Text>
      </AppCard>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  body: { ...typography.body, color: colors.textMuted },
});
