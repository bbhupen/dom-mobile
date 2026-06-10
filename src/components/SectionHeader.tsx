import { StyleSheet, Text, View } from 'react-native';
import { colors } from '../theme/colors';

type SectionHeaderProps = {
  title: string;
  hint: string;
};

export function SectionHeader({ title, hint }: SectionHeaderProps) {
  return (
    <View style={styles.sectionHeader}>
      <Text style={styles.sectionTitle}>{title}</Text>
      <Text style={styles.sectionHint}>{hint}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  sectionHeader: {
    marginBottom: 12,
  },
  sectionTitle: {
    color: colors.text,
    fontSize: 21,
    fontWeight: '800',
    lineHeight: 28,
  },
  sectionHint: {
    color: colors.textSubtle,
    fontSize: 14,
    lineHeight: 20,
    marginTop: 4,
  },
});
