import { AuthResponse, LoginInput, SignupInput } from '../types/auth';

const API_BASE_URL = 'http://4.188.81.34:3000/api';

async function postAuth(path: 'login' | 'signup', body: LoginInput | SignupInput) {
  const response = await fetch(`${API_BASE_URL}/auth/${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    const payload = (await response.json().catch(() => null)) as { message?: string } | null;
    throw new Error(payload?.message ?? 'Unable to continue');
  }

  return (await response.json()) as AuthResponse;
}

export function login(input: LoginInput) {
  return postAuth('login', input);
}

export function signup(input: SignupInput) {
  return postAuth('signup', input);
}
