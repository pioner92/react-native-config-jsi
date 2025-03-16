import { useEffect } from 'react';
import { Text, View, StyleSheet } from 'react-native';
import { RNConfig } from 'react-native-config-jsi';
export default function App() {
    useEffect(() => {
        try {
            RNConfig.get('API_URL');
        }
        catch (e) {
            console.error('ERR', e);
        }
    }, []);
    return (<View style={styles.container}>
      <Text>Result:2</Text>
    </View>);
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
    },
});
