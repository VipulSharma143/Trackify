import { StyleSheet, Text } from 'react-native';
import { AppCard } from '../components/common/AppCard';
import { AppHeader } from '../components/common/AppHeader';
import { ScreenContainer } from '../components/layout/ScreenContainer';
import { colors } from '../theme/colors';
import { typography } from '../theme/typography';

export function AboutScreen(): React.JSX.Element {
  return (
    <ScreenContainer>
      <AppHeader title="About" />
      <AppCard title="Project">
        <Text style={styles.body}>
          Initial technical foundation for a cross-platform mobile app with an
          API and a database. It contains no product features.
        </Text>
      </AppCard>
      <AppCard title="Technology stack">
        <Text style={styles.body}>
          React Native, TypeScript · ASP.NET Core, C# · PostgreSQL, EF Core,
          Npgsql
        </Text>
      </AppCard>
      <AppCard title="Development status">
        <Text style={styles.body}>
          Foundation in progress. See the repository README for verified status.
        </Text>
      </AppCard>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  body: { ...typography.body, color: colors.textMuted },
});
