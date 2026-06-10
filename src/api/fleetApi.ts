import { CreateDroneInput, Drone } from '../types/fleet';

const API_BASE_URL = 'http://4.188.81.34:3000/api';

function toOptionalNumber(value: string) {
  const trimmed = value.trim();

  if (!trimmed) {
    return undefined;
  }

  return Number(trimmed);
}

async function requestFleet<TResponse>(path: string, token: string, init?: RequestInit) {
  const response = await fetch(`${API_BASE_URL}/fleet${path}`, {
    ...init,
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
      ...init?.headers,
    },
  });

  if (!response.ok) {
    const payload = (await response.json().catch(() => null)) as { message?: string } | null;
    throw new Error(payload?.message ?? 'Fleet request failed');
  }

  return (await response.json()) as TResponse;
}

export function fetchDrones(token: string) {
  return requestFleet<Drone[]>('/drones', token);
}

export function createDrone(token: string, input: CreateDroneInput) {
  return requestFleet<Drone>('/drones', token, {
    method: 'POST',
    body: JSON.stringify({
      name: input.name,
      manufacturer: input.manufacturer,
      model: input.model,
      serialNumber: input.serialNumber,
      uin: input.uin || undefined,
      category: input.category || undefined,
      weightKg: toOptionalNumber(input.weightKg),
      payloadCapacityKg: toOptionalNumber(input.payloadCapacityKg),
      notes: input.notes || undefined,
    }),
  });
}
