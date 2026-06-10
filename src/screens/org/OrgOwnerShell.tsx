import { useState } from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { BottomNav } from '../../components/BottomNav';
import { MetricGrid } from '../../components/MetricGrid';
import { SectionHeader } from '../../components/SectionHeader';
import { TopBar } from '../../components/TopBar';
import { WorkflowCard, WorkflowList } from '../../components/WorkflowList';
import { companyMetrics, companyWorkflows, orgOwnerTabs } from '../../data/dashboard';
import { colors } from '../../theme/colors';
import { AuthSession } from '../../types/auth';
import { OrgOwnerTab } from '../../types/navigation';
import { FleetScreen } from './FleetScreen';

type OrgOwnerShellProps = {
  session: AuthSession;
  onSignOut: () => void;
};

export function OrgOwnerShell({ session, onSignOut }: OrgOwnerShellProps) {
  const [activeTab, setActiveTab] = useState<OrgOwnerTab>('home');
  const user = session.user;
  const activeTabLabel =
    orgOwnerTabs.find((tab) => tab.key === activeTab)?.label ?? orgOwnerTabs[0].label;

  return (
    <View style={styles.appShell}>
      <TopBar userName={user.name} onSignOut={onSignOut} />
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.header}>
          <Text style={styles.eyebrow}>Drone operations</Text>
          <Text style={styles.title}>
            {activeTab === 'home' ? 'Company Command Center' : activeTabLabel}
          </Text>
          <Text style={styles.subtitle}>
            {activeTab === 'home'
              ? `Signed in as ${user.name}. Manage your company's requests, services, pilots, drones, and reports.`
              : `Signed in as ${user.name}. ${activeTabLabel} workspace for your drone service company.`}
          </Text>
        </View>

        {activeTab === 'home' ? (
          <>
            <MetricGrid metrics={companyMetrics} />

            <SectionHeader
              title="Company Operations"
              hint="Organization owners manage only their own drone service company."
            />

            <WorkflowList workflows={companyWorkflows} />
          </>
        ) : activeTab === 'fleet' ? (
          <FleetScreen token={session.token} />
        ) : (
          <WorkflowCard
            workflow={{
              title: activeTabLabel,
              body: `This section will become the ${activeTabLabel.toLowerCase()} management workspace.`,
              status: 'Next',
            }}
          />
        )}
      </ScrollView>

      <BottomNav activeTab={activeTab} tabs={orgOwnerTabs} onChangeTab={setActiveTab} />
    </View>
  );
}

const styles = StyleSheet.create({
  appShell: {
    flex: 1,
  },
  container: {
    padding: 20,
    paddingBottom: 118,
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
