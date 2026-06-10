import { useEffect, useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { Button, Card, Chip, Text, TextInput } from 'react-native-paper';
import { createDrone, fetchDrones } from '../../api/fleetApi';
import { colors } from '../../theme/colors';
import { CreateDroneInput, Drone } from '../../types/fleet';

type FleetScreenProps = {
  token: string;
};

const emptyDroneForm: CreateDroneInput = {
  name: '',
  manufacturer: '',
  model: '',
  serialNumber: '',
  uin: '',
  category: '',
  weightKg: '',
  payloadCapacityKg: '',
  notes: '',
};

export function FleetScreen({ token }: FleetScreenProps) {
  const [drones, setDrones] = useState<Drone[]>([]);
  const [form, setForm] = useState<CreateDroneInput>(emptyDroneForm);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    loadDrones();
  }, []);

  async function loadDrones() {
    setError('');
    setIsLoading(true);

    try {
      setDrones(await fetchDrones(token));
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : 'Unable to load fleet');
    } finally {
      setIsLoading(false);
    }
  }

  async function handleCreateDrone() {
    setError('');
    setIsSaving(true);

    try {
      const drone = await createDrone(token, form);
      setDrones((currentDrones) => [drone, ...currentDrones]);
      setForm(emptyDroneForm);
    } catch (saveError) {
      setError(saveError instanceof Error ? saveError.message : 'Unable to add drone');
    } finally {
      setIsSaving(false);
    }
  }

  function updateForm(field: keyof CreateDroneInput, value: string) {
    setForm((currentForm) => ({
      ...currentForm,
      [field]: value,
    }));
  }

  return (
    <View style={styles.container}>
      <Card mode="outlined" style={styles.card}>
        <Card.Content>
          <Text style={styles.cardTitle}>Add drone</Text>
          <View style={styles.formGrid}>
            <TextInput label="Drone name" mode="outlined" onChangeText={(value) => updateForm('name', value)} value={form.name} />
            <TextInput label="Manufacturer" mode="outlined" onChangeText={(value) => updateForm('manufacturer', value)} value={form.manufacturer} />
            <TextInput label="Model" mode="outlined" onChangeText={(value) => updateForm('model', value)} value={form.model} />
            <TextInput label="Serial number" mode="outlined" onChangeText={(value) => updateForm('serialNumber', value)} value={form.serialNumber} />
            <TextInput label="UIN / registration" mode="outlined" onChangeText={(value) => updateForm('uin', value)} value={form.uin} />
            <TextInput label="Category" mode="outlined" onChangeText={(value) => updateForm('category', value)} value={form.category} />
            <TextInput keyboardType="decimal-pad" label="Weight kg" mode="outlined" onChangeText={(value) => updateForm('weightKg', value)} value={form.weightKg} />
            <TextInput keyboardType="decimal-pad" label="Payload kg" mode="outlined" onChangeText={(value) => updateForm('payloadCapacityKg', value)} value={form.payloadCapacityKg} />
            <TextInput label="Notes" mode="outlined" multiline onChangeText={(value) => updateForm('notes', value)} value={form.notes} />
          </View>

          {error ? <Text style={styles.errorText}>{error}</Text> : null}

          <Button mode="contained" onPress={handleCreateDrone} disabled={isSaving} style={styles.actionButton}>
            {isSaving ? 'Adding drone...' : 'Add drone'}
          </Button>
        </Card.Content>
      </Card>

      <View style={styles.listHeader}>
        <Text style={styles.sectionTitle}>Registered drones</Text>
        <Text style={styles.sectionHint}>
          {isLoading ? 'Loading fleet...' : `${drones.length} drone${drones.length === 1 ? '' : 's'}`}
        </Text>
      </View>

      <View style={styles.list}>
        {drones.map((drone) => (
          <Card key={drone.id} mode="outlined" style={styles.card}>
            <Card.Content>
              <View style={styles.droneTopRow}>
                <View style={styles.droneTitleBlock}>
                  <Text style={styles.droneName}>{drone.name}</Text>
                  <Text style={styles.droneMeta}>
                    {drone.manufacturer} {drone.model}
                  </Text>
                </View>
                <Chip compact>{drone.status.replace('_', ' ')}</Chip>
              </View>
              <Text style={styles.droneDetail}>Serial: {drone.serialNumber}</Text>
              {drone.uin ? <Text style={styles.droneDetail}>UIN: {drone.uin}</Text> : null}
              {drone.category ? <Text style={styles.droneDetail}>Category: {drone.category}</Text> : null}
            </Card.Content>
          </Card>
        ))}

        {!isLoading && drones.length === 0 ? (
          <Card mode="outlined" style={styles.card}>
            <Card.Content>
              <Text style={styles.droneName}>No drones added yet</Text>
              <Text style={styles.droneMeta}>Add the first drone to start building this fleet.</Text>
            </Card.Content>
          </Card>
        ) : null}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingBottom: 8,
  },
  card: {
    borderRadius: 8,
  },
  cardTitle: {
    color: colors.text,
    fontSize: 18,
    fontWeight: '800',
    marginBottom: 12,
  },
  formGrid: {
    gap: 10,
  },
  actionButton: {
    alignSelf: 'flex-start',
    borderRadius: 8,
    marginTop: 16,
  },
  errorText: {
    color: colors.danger,
    fontSize: 14,
    lineHeight: 20,
    marginTop: 12,
  },
  listHeader: {
    marginBottom: 12,
    marginTop: 24,
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
  list: {
    gap: 12,
  },
  droneTopRow: {
    alignItems: 'flex-start',
    flexDirection: 'row',
    gap: 12,
    justifyContent: 'space-between',
  },
  droneTitleBlock: {
    flex: 1,
  },
  droneName: {
    color: colors.text,
    fontSize: 17,
    fontWeight: '800',
    lineHeight: 22,
  },
  droneMeta: {
    color: colors.textMuted,
    fontSize: 14,
    lineHeight: 20,
    marginTop: 4,
  },
  droneDetail: {
    color: colors.textSubtle,
    fontSize: 13,
    lineHeight: 18,
    marginTop: 8,
  },
});
