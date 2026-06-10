import { StyleSheet } from 'react-native';
import { BottomNavigation } from 'react-native-paper';
import { colors } from '../theme/colors';
import { BottomTabItem } from '../types/navigation';

type BottomNavProps<TTab extends string> = {
  activeTab: TTab;
  tabs: Array<BottomTabItem<TTab>>;
  onChangeTab: (tab: TTab) => void;
};

export function BottomNav<TTab extends string>({ activeTab, tabs, onChangeTab }: BottomNavProps<TTab>) {
  const navigationState = {
    index: Math.max(
      tabs.findIndex((tab) => tab.key === activeTab),
      0,
    ),
    routes: tabs.map((tab) => ({
      key: tab.key,
      title: tab.label,
      focusedIcon: tab.icon,
      unfocusedIcon: tab.icon,
    })),
  };

  return (
    <BottomNavigation.Bar
      activeColor={colors.primary}
      inactiveColor={colors.textSubtle}
      navigationState={navigationState}
      onTabPress={({ route }) => onChangeTab(route.key as TTab)}
      style={styles.bottomNav}
    />
  );
}

const styles = StyleSheet.create({
  bottomNav: {
    backgroundColor: colors.card,
    borderColor: colors.border,
    borderTopWidth: 1,
    bottom: 0,
    left: 0,
    position: 'absolute',
    right: 0,
  },
});
