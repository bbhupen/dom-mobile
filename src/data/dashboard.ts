import { BottomTabItem, OrgOwnerTab } from '../types/navigation';

export type Metric = {
  label: string;
  value: string;
};

export type Workflow = {
  title: string;
  body: string;
  status: string;
};

export const orgOwnerTabs: Array<BottomTabItem<OrgOwnerTab>> = [
  { key: 'home', label: 'Home', icon: 'home-outline' },
  { key: 'requests', label: 'Requests', icon: 'clipboard-text-outline' },
  { key: 'fleet', label: 'Fleet', icon: 'quadcopter' },
  { key: 'pilots', label: 'Pilots', icon: 'account-group-outline' },
  { key: 'services', label: 'Services', icon: 'briefcase-outline' },
];

export const platformMetrics: Metric[] = [
  { label: 'Organizations', value: '18' },
  { label: 'Active users', value: '126' },
  { label: 'Total drones', value: '74' },
  { label: 'Open support items', value: '5' },
];

export const companyMetrics: Metric[] = [
  { label: 'Open requests', value: '12' },
  { label: 'Scheduled missions', value: '7' },
  { label: 'Fleet ready', value: '5' },
  { label: 'Pilots available', value: '3' },
];

export const platformWorkflows: Workflow[] = [
  {
    title: 'Organizations',
    body: 'Review tenant accounts, owners, subscriptions, and organization status.',
    status: 'Super admin',
  },
  {
    title: 'Platform health',
    body: 'Monitor total users, fleet counts, request volume, and operational alerts.',
    status: 'Super admin',
  },
  {
    title: 'Access control',
    body: 'Manage platform-level support, impersonation policy, and audit trails.',
    status: 'Next',
  },
];

export const companyWorkflows: Workflow[] = [
  {
    title: 'Service requests',
    body: 'Manage client requests, send quotes, and convert approved work into missions.',
    status: 'MVP',
  },
  {
    title: 'Mission planning',
    body: 'Convert approved requests into missions with pilot, drone, site, and checklist details.',
    status: 'MVP',
  },
  {
    title: 'Fleet registry',
    body: 'Add drones, track UIN records, maintenance state, batteries, and equipment.',
    status: 'MVP',
  },
  {
    title: 'Pilots and staff',
    body: 'Invite pilots, assign roles, and keep certification details current.',
    status: 'MVP',
  },
  {
    title: 'Services offered',
    body: 'Configure the drone services this company sells to its clients.',
    status: 'Next',
  },
];
