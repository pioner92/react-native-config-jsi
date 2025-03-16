import { NativeModules } from 'react-native';

declare global {
  var getValue: (key: string) => string | undefined;
}

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
  get: (key: string) => {
    return _getValue(key);
  },
};
