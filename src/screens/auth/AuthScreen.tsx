import { useState } from 'react';
import { SafeAreaView, ScrollView, StyleSheet, View } from 'react-native';
import { Button, Card, Text, TextInput } from 'react-native-paper';
import { login, signup } from '../../api/authApi';
import { colors } from '../../theme/colors';
import { AuthSession } from '../../types/auth';

type AuthScreenProps = {
  onAuthenticated: (session: AuthSession) => void;
};

export function AuthScreen({ onAuthenticated }: AuthScreenProps) {
  const [authMode, setAuthMode] = useState<'login' | 'signup'>('login');
  const [name, setName] = useState('');
  const [organizationName, setOrganizationName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  async function handleAuthSubmit() {
    setError('');
    setIsSubmitting(true);

    try {
      const payload =
        authMode === 'login'
          ? await login({ email, password })
          : await signup({ name, email, password, organizationName });

      onAuthenticated(payload);
    } catch (authError) {
      setError(authError instanceof Error ? authError.message : 'Authentication failed');
    } finally {
      setIsSubmitting(false);
    }
  }

  function switchAuthMode(nextMode: 'login' | 'signup') {
    setAuthMode(nextMode);
    setError('');
    setEmail('');
    setPassword('');
  }

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.loginContainer}>
        <Card mode="outlined" style={styles.loginPanel}>
          <Card.Content>
            <Text style={styles.eyebrow}>Drone operations</Text>
            <Text style={styles.loginTitle}>
              {authMode === 'login' ? 'Sign in' : 'Create account'}
            </Text>
            <Text style={styles.subtitle}>
              {authMode === 'login'
                ? 'Use your organization account to manage requests, missions, pilots, and fleet readiness.'
                : 'Create your drone service company account and become the organization owner.'}
            </Text>

            <View style={styles.authSwitch}>
              <Button
                mode={authMode === 'login' ? 'contained' : 'text'}
                onPress={() => switchAuthMode('login')}
                style={styles.authSwitchButton}
                labelStyle={styles.authSwitchLabel}
              >
                Sign in
              </Button>
              <Button
                mode={authMode === 'signup' ? 'contained' : 'text'}
                onPress={() => switchAuthMode('signup')}
                style={styles.authSwitchButton}
                labelStyle={styles.authSwitchLabel}
              >
                Create account
              </Button>
            </View>

          <View style={styles.form}>
            {authMode === 'signup' ? (
              <>
                <View style={styles.field}>
                  <Text style={styles.label}>Full name</Text>
                  <TextInput
                    autoCapitalize="words"
                    mode="outlined"
                    onChangeText={setName}
                    placeholder="Aarav Sharma"
                    style={styles.input}
                    value={name}
                  />
                </View>

                <View style={styles.field}>
                  <Text style={styles.label}>Organization</Text>
                  <TextInput
                    mode="outlined"
                    onChangeText={setOrganizationName}
                    placeholder="Aarav Solar Pvt Ltd"
                    style={styles.input}
                    value={organizationName}
                  />
                </View>
              </>
            ) : null}

            <View style={styles.field}>
              <Text style={styles.label}>Email</Text>
              <TextInput
                autoCapitalize="none"
                keyboardType="email-address"
                mode="outlined"
                onChangeText={setEmail}
                placeholder="admin@droneops.in"
                style={styles.input}
                value={email}
              />
            </View>

            <View style={styles.field}>
              <Text style={styles.label}>Password</Text>
              <TextInput
                mode="outlined"
                onChangeText={setPassword}
                placeholder="password123"
                secureTextEntry
                style={styles.input}
                value={password}
              />
            </View>

            {error ? <Text style={styles.errorText}>{error}</Text> : null}

            <Button
              mode="contained"
              disabled={isSubmitting}
              onPress={handleAuthSubmit}
              style={styles.primaryButton}
              contentStyle={styles.primaryButtonContent}
              labelStyle={styles.primaryButtonText}
            >
              {isSubmitting
                ? authMode === 'login'
                  ? 'Signing in...'
                  : 'Creating account...'
                : authMode === 'login'
                  ? 'Sign in'
                  : 'Create account'}
            </Button>

          </View>

          {authMode === 'login' ? (
            <Text style={styles.helperText}>Demo users: admin@droneops.in or owner@example.com</Text>
          ) : null}
          </Card.Content>
        </Card>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: colors.background,
  },
  loginContainer: {
    flexGrow: 1,
    justifyContent: 'center',
    padding: 20,
  },
  loginPanel: {
    alignSelf: 'center',
    borderRadius: 8,
    maxWidth: 460,
    width: '100%',
  },
  eyebrow: {
    color: colors.primary,
    fontSize: 13,
    fontWeight: '700',
    letterSpacing: 0,
    marginBottom: 8,
    textTransform: 'uppercase',
  },
  loginTitle: {
    color: colors.text,
    fontSize: 30,
    fontWeight: '800',
    letterSpacing: 0,
    lineHeight: 36,
  },
  subtitle: {
    color: colors.textMuted,
    fontSize: 16,
    lineHeight: 23,
    marginTop: 12,
  },
  authSwitch: {
    backgroundColor: '#eef2f6',
    borderRadius: 8,
    flexDirection: 'row',
    gap: 6,
    marginTop: 20,
    padding: 4,
  },
  authSwitchButton: {
    borderRadius: 8,
    flex: 1,
  },
  authSwitchLabel: {
    fontSize: 13,
    fontWeight: '800',
  },
  form: {
    gap: 14,
    marginTop: 24,
  },
  field: {
    gap: 7,
  },
  label: {
    color: '#344054',
    fontSize: 14,
    fontWeight: '700',
    lineHeight: 18,
  },
  input: {
    backgroundColor: colors.card,
  },
  errorText: {
    color: colors.danger,
    fontSize: 14,
    lineHeight: 20,
  },
  helperText: {
    color: colors.textSubtle,
    fontSize: 13,
    lineHeight: 18,
    marginTop: 18,
  },
  primaryButton: {
    borderRadius: 8,
  },
  primaryButtonContent: {
    minHeight: 48,
  },
  primaryButtonText: {
    fontSize: 16,
    fontWeight: '800',
    lineHeight: 20,
  },
});
