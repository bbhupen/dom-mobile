export type DroneStatus = 'active' | 'under_maintenance' | 'grounded' | 'retired';

export type Drone = {
  id: string;
  organizationId: string;
  name: string;
  manufacturer: string;
  model: string;
  serialNumber: string;
  uin: string | null;
  category: string | null;
  weightKg: number | null;
  payloadCapacityKg: number | null;
  status: DroneStatus;
  totalFlightHours: number;
  notes: string | null;
  createdAt: string;
  updatedAt: string;
};

export type CreateDroneInput = {
  name: string;
  manufacturer: string;
  model: string;
  serialNumber: string;
  uin: string;
  category: string;
  weightKg: string;
  payloadCapacityKg: string;
  notes: string;
};
