export type OrgOwnerTab = 'home' | 'requests' | 'fleet' | 'pilots' | 'services';

export type BottomTabItem<TTab extends string> = {
  key: TTab;
  label: string;
  icon: string;
};
