import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { MetricGrid } from '../../components/MetricGrid';
import { SectionHeader } from '../../components/SectionHeader';
import { TopBar } from '../../components/TopBar';
import { WorkflowList } from '../../components/WorkflowList';
import { platformMetrics, platformWorkflows } from '../../data/dashboard';
import { colors } from '../../theme/colors';
import { AuthUser } from '../../types/auth';

type SuperAdminHomeScreenProps = {
  user: AuthUser;
  onSignOut: () => void;
};

export function SuperAdminHomeScreen({ user, onSignOut }: SuperAdminHomeScreenProps) {
  return (
    <View style={styles.shell}>
      <TopBar userName={user.name} onSignOut={onSignOut} />
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.header}>
          <Text style={styles.eyebrow}>Drone operations</Text>
          <Text style={styles.title}>Platform Super Admin</Text>
          <Text style={styles.subtitle}>
            Signed in as {user.name}. Monitor SaaS tenants, platform usage, and account health.
          </Text>
        </View>

        <MetricGrid metrics={platformMetrics} />

        <SectionHeader
          title="Platform Controls"
          hint="Super admin sees all tenant organizations across the SaaS platform."
        />

        <WorkflowList workflows={platformWorkflows} />
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  shell: {
    flex: 1,
  },
  container: {
    padding: 20,
    paddingBottom: 32,
  },
  header: {
    marginBottom: 22,
  },
  eyebrow: {
    color: colors.primary,
    fontSize: 13,
    fontWeight: '700',
    letterSpacing: 0,
    marginBottom: 8,
    textTransform: 'uppercase',
  },
  title: {
    color: colors.text,
    fontSize: 34,
    fontWeight: '800',
    letterSpacing: 0,
    lineHeight: 40,
  },
  subtitle: {
    color: colors.textMuted,
    fontSize: 16,
    lineHeight: 23,
    marginTop: 12,
  },
});
