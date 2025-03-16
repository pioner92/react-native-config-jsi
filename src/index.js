import { NativeModules } from 'react-native';
let _getValue = global.getValue;
// Автоинициализация
if (!_getValue) {
    if (NativeModules.ReactNativeConfigJsi?.install) {
        NativeModules.ReactNativeConfigJsi.install(); // Вызываем native install метод
        _getValue = global.getValue; // Сохраняем глобальную ссылку на объект SqlDb
        console.log('react-native-config initialized successfully');
    }
}
export const RNConfig = {
    get: (key) => {
        return _getValue(key);
    },
};
