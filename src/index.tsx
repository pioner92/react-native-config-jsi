import { NativeModules } from 'react-native';

declare global {
  type TGetValue = (key: string) => void;
  type TConfigJSI = {
    keys: string[];
    get: TGetValue;
  };

  var getValue: TGetValue;
  var ConfigJSI: TConfigJSI;
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
export const getValue = _getValue;
