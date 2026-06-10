import { StyleSheet, View } from 'react-native';
import { Card, Text } from 'react-native-paper';
import { Workflow } from '../data/dashboard';
import { colors } from '../theme/colors';

type WorkflowListProps = {
  workflows: Workflow[];
};

export function WorkflowList({ workflows }: WorkflowListProps) {
  return (
    <View style={styles.workflowList}>
      {workflows.map((workflow) => (
        <WorkflowCard key={workflow.title} workflow={workflow} />
      ))}
    </View>
  );
}

type WorkflowCardProps = {
  workflow: Workflow;
};

export function WorkflowCard({ workflow }: WorkflowCardProps) {
  return (
    <Card mode="outlined" style={styles.workflowCard}>
      <Card.Content style={styles.workflowCardContent}>
        <View style={styles.workflowTopRow}>
          <Text numberOfLines={2} style={styles.workflowTitle}>
            {workflow.title}
          </Text>
          <Text numberOfLines={3} style={styles.workflowBody}>
            {workflow.body}
          </Text>
        </View>
        {/* <View style={styles.statusPill}>
          <Text numberOfLines={1} style={styles.statusPillText}>
            {workflow.status}
          </Text>
        </View> */}
      </Card.Content>
    </Card>
  );
}

const styles = StyleSheet.create({
  workflowList: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  workflowCard: {
    aspectRatio: 1,
    borderRadius: 8,
    flexBasis: '31%',
    flexGrow: 1,
    maxWidth: '32%',
    minWidth: 96,
  },
  workflowCardContent: {
    flex: 1,
    justifyContent: 'space-between',
    paddingHorizontal: 12,
    paddingVertical: 12,
  },
  workflowTopRow: {
    flexShrink: 1,
  },
  workflowTitle: {
    color: colors.text,
    fontSize: 14,
    fontWeight: '800',
    lineHeight: 18,
  },
  workflowBody: {
    color: colors.textMuted,
    fontSize: 11,
    lineHeight: 14,
    marginTop: 6,
  },
  statusPill: {
    alignSelf: 'flex-start',
    backgroundColor: colors.primarySoft,
    borderRadius: 8,
    maxWidth: '100%',
    minHeight: 24,
    paddingHorizontal: 9,
    paddingVertical: 4,
  },
  statusPillText: {
    color: colors.primary,
    fontSize: 11,
    fontWeight: '800',
    lineHeight: 14,
  },
});
