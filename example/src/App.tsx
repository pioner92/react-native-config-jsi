import { useEffect } from 'react';
import { Text, View, StyleSheet, NativeModules } from 'react-native';
import { getValue } from 'react-native-config-jsi';

export default function App() {
  useEffect(() => {
    try {
      console.log('CALL', NativeModules.ReactNativeConfigJsi?.install);
      // console.log('RES', global.ConfigJSI.keys);
    } catch (e) {
      console.error('ERR', e);
    }
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result:2</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
