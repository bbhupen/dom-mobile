export type UserRole =
  | 'super_admin'
  | 'org_owner'
  | 'org_admin'
  | 'pilot'
  | 'maintenance'
  | 'client';

export type AuthUser = {
  id: string;
  organizationId: string;
  name: string;
  email: string;
  role: UserRole;
};

export type AuthResponse = {
  token: string;
  user: AuthUser;
};

export type AuthSession = AuthResponse;

export type LoginInput = {
  email: string;
  password: string;
};

export type SignupInput = LoginInput & {
  name: string;
  organizationName: string;
};
