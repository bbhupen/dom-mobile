import { StyleSheet, View } from 'react-native';
import { Card, Text } from 'react-native-paper';
import { Metric } from '../data/dashboard';
import { colors } from '../theme/colors';

type MetricGridProps = {
  metrics: Metric[];
};

export function MetricGrid({ metrics }: MetricGridProps) {
  return (
    <View style={styles.metricsGrid}>
      {metrics.map((metric) => (
        <Card key={metric.label} mode="outlined" style={styles.metricCard}>
          <Card.Content>
            <Text style={styles.metricValue}>{metric.value}</Text>
            <Text style={styles.metricLabel}>{metric.label}</Text>
          </Card.Content>
        </Card>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  metricsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
    marginBottom: 28,
  },
  metricCard: {
    borderRadius: 8,
    flexBasis: '47%',
    flexGrow: 1,
    minHeight: 92,
  },
  metricValue: {
    color: colors.text,
    fontSize: 28,
    fontWeight: '800',
    lineHeight: 34,
  },
  metricLabel: {
    color: colors.textSubtle,
    fontSize: 14,
    lineHeight: 18,
    marginTop: 6,
  },
});
