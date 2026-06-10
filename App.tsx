import { StatusBar } from 'expo-status-bar';
import { useState } from 'react';
import { SafeAreaView, StyleSheet } from 'react-native';
import { PaperProvider } from 'react-native-paper';
import { AuthScreen } from './src/screens/auth/AuthScreen';
import { OrgOwnerShell } from './src/screens/org/OrgOwnerShell';
import { SuperAdminHomeScreen } from './src/screens/super-admin/SuperAdminHomeScreen';
import { colors } from './src/theme/colors';
import { paperTheme } from './src/theme/paperTheme';
import { AuthSession } from './src/types/auth';

export default function App() {
  const [session, setSession] = useState<AuthSession | null>(null);

  if (!session) {
    return (
      <PaperProvider theme={paperTheme}>
        <StatusBar style="auto" />
        <AuthScreen onAuthenticated={setSession} />
      </PaperProvider>
    );
  }

  return (
    <PaperProvider theme={paperTheme}>
      <SafeAreaView style={styles.safeArea}>
        <StatusBar style="auto" />
        {session.user.role === 'super_admin' ? (
          <SuperAdminHomeScreen user={session.user} onSignOut={() => setSession(null)} />
        ) : (
          <OrgOwnerShell session={session} onSignOut={() => setSession(null)} />
        )}
      </SafeAreaView>
    </PaperProvider>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: colors.background,
  },
});
