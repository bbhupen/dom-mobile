import { useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { Avatar, Badge, IconButton, Menu, Snackbar, Surface, Text } from 'react-native-paper';
import { colors } from '../theme/colors';

type TopBarProps = {
  userName: string;
  onSignOut: () => void;
};

export function TopBar({ userName, onSignOut }: TopBarProps) {
  const [isProfileMenuVisible, setIsProfileMenuVisible] = useState(false);
  const [message, setMessage] = useState('');
  const firstName = userName.trim().split(/\s+/)[0] || 'there';
  const initials = userName
    .trim()
    .split(/\s+/)
    .slice(0, 2)
    .map((namePart) => namePart[0]?.toUpperCase())
    .join('');

  function showMessage(nextMessage: string) {
    setMessage(nextMessage);
  }

  return (
    <>
      <Surface elevation={2} style={styles.header}>
        <Text style={styles.greeting}>Hey, {firstName}!</Text>

        <View style={styles.actions}>
          <IconButton
            accessibilityLabel="Documents"
            icon="file-document-outline"
            onPress={() => showMessage('Documents will open here soon.')}
            size={21}
            style={styles.iconButton}
          />
          <IconButton
            accessibilityLabel="Work tray"
            icon="tray-arrow-down"
            onPress={() => showMessage('Work tray will open here soon.')}
            size={21}
            style={styles.iconButton}
          />
          <View style={styles.notificationWrap}>
            <IconButton
              accessibilityLabel="Notifications"
              icon="bell-outline"
              onPress={() => showMessage('You have 10+ notifications.')}
              size={21}
              style={styles.iconButton}
            />
            <Badge size={21} style={styles.badge}>
              10+
            </Badge>
          </View>
          <Menu
            visible={isProfileMenuVisible}
            onDismiss={() => setIsProfileMenuVisible(false)}
            anchor={
              <IconButton
                accessibilityLabel="Open profile menu"
                icon={({ size }) => (
                  <Avatar.Text
                    label={initials || 'U'}
                    size={size + 10}
                    style={styles.avatar}
                    labelStyle={styles.avatarLabel}
                  />
                )}
                onPress={() => setIsProfileMenuVisible(true)}
                size={24}
                style={styles.avatarButton}
              />
            }
          >
            <Menu.Item
              leadingIcon="account-outline"
              onPress={() => {
                setIsProfileMenuVisible(false);
                showMessage('Profile settings will open here soon.');
              }}
              title="Profile"
            />
            <Menu.Item
              leadingIcon="logout"
              onPress={() => {
                setIsProfileMenuVisible(false);
                onSignOut();
              }}
              title="Sign out"
            />
          </Menu>
        </View>
      </Surface>
      <Snackbar
        visible={Boolean(message)}
        onDismiss={() => setMessage('')}
        duration={2200}
        action={{
          label: 'OK',
          onPress: () => setMessage(''),
        }}
      >
        {message}
      </Snackbar>
    </>
  );
}

const styles = StyleSheet.create({
  header: {
    alignItems: 'center',
    backgroundColor: colors.card,
    borderBottomColor: colors.border,
    borderBottomWidth: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    minHeight: 64,
    paddingHorizontal: 18,
    paddingVertical: 8,
  },
  greeting: {
    color: colors.text,
    flex: 1,
    fontSize: 18,
    fontWeight: '800',
    lineHeight: 24,
  },
  actions: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 2,
  },
  iconButton: {
    margin: 0,
  },
  notificationWrap: {
    position: 'relative',
  },
  badge: {
    backgroundColor: '#ff4d5d',
    position: 'absolute',
    right: -4,
    top: 2,
  },
  avatarButton: {
    margin: 0,
  },
  avatar: {
    backgroundColor: colors.primarySoft,
  },
  avatarLabel: {
    color: colors.primary,
    fontSize: 11,
    fontWeight: '800',
  },
});
