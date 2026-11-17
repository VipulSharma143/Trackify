import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { Image, Platform, StyleSheet, Text, View } from 'react-native';
import { logo } from '../assets/images';
import { AppButton } from '../components/common/AppButton';
import { AppCard } from '../components/common/AppCard';
import { AppHeader } from '../components/common/AppHeader';
import {
  StatusIndicator,
  type StatusLevel,
} from '../components/common/StatusIndicator';
import { ScreenContainer } from '../components/layout/ScreenContainer';
import { APP_VERSION } from '../shared/appInfo';
import { formatTime } from '../utils/format';
import { useApiHealth, type CheckState } from '../hooks/useApiHealth';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { typography } from '../theme/typography';
import type { RootStackParamList } from '../types/navigation.types';

type Props = NativeStackScreenProps<RootStackParamList, 'Home'>;

const errorText = {
  timeout: 'Request timed out',
  network: 'Unreachable',
  http: 'Unexpected response',
  'invalid-response': 'Invalid response',
} as const;

function describe<T extends { status: string }>(
  check: CheckState<T>,
): { level: StatusLevel; detail: string } {
  if (check.status === 'loading')
    return { level: 'neutral', detail: 'Checking…' };
  if (check.status === 'error')
    return { level: 'error', detail: errorText[check.kind] };
  const healthy = ['healthy', 'ok'].includes(check.data.status.toLowerCase());
  return { level: healthy ? 'ok' : 'error', detail: check.data.status };
}

const stack: ReadonlyArray<{ title: string; text: string }> = [
  {
    title: 'React Native / TypeScript',
    text: 'React Native client with browser preview.',
  },
  { title: 'ASP.NET Core / C#', text: 'REST API (modular monolith).' },
  { title: 'PostgreSQL', text: 'Relational database via EF Core and Npgsql.' },
];

export function HomeScreen({ navigation }: Props): React.JSX.Element {
  const { api, database, system, lastSuccessAt, refresh } = useApiHealth();
  const apiView = describe(api);
  const dbView = describe(database);
  const backendName =
    system.status === 'success'
      ? `${system.data.applicationName} ${system.data.version}`
      : null;
  return (
    <ScreenContainer>
      <Image source={logo} style={styles.logo} accessibilityLabel="App logo" />
      <AppHeader title="My App" subtitle="Welcome to the project foundation." />
      {stack.map(item => (
        <AppCard key={item.title} title={item.title}>
          <Text style={styles.body}>{item.text}</Text>
        </AppCard>
      ))}
      <AppCard title="Status">
        <StatusIndicator label="Frontend" status="ok" detail="Running" />
        <StatusIndicator
          label="Backend API"
          status={apiView.level}
          detail={apiView.detail}
        />
        <StatusIndicator
          label="Database"
          status={dbView.level}
          detail={dbView.detail}
        />
        {backendName ? (
          <Text style={styles.body}>Backend: {backendName}</Text>
        ) : null}
        <Text style={styles.body}>
          Last successful check: {formatTime(lastSuccessAt)}
        </Text>
        <Text style={styles.body}>
          Version {APP_VERSION} · Platform {Platform.OS}
        </Text>
      </AppCard>
      <View style={styles.actions}>
        <AppButton
          title="Refresh status"
          variant="secondary"
          onPress={refresh}
        />
        <AppButton
          title="Settings"
          onPress={() => navigation.navigate('Settings')}
        />
        <AppButton
          title="About"
          variant="secondary"
          onPress={() => navigation.navigate('About')}
        />
      </View>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  body: { ...typography.body, color: colors.textMuted },
  logo: { width: 64, height: 64, marginBottom: spacing.md },
  actions: { gap: spacing.sm },
});
