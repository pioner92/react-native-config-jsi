# 🚀 react-native-config-jsi

A **high-performance** JSI-based React Native library for accessing `.env` variables natively.  
Built using **C++ and JSI** for ultra-fast access without the need for a bridge.

---

## 📦 Installation

### Using npm
```sh
npm install react-native-config-jsi
```

### Using yarn
```sh
yarn add react-native-config-jsi
```

---

## 🔧 Setup

### 1️⃣ Create a `.env` file in the root of your project

Add environment variables inside `.env`:
```
API_KEY=your_api_key
APP_NAME=MyAwesomeApp
```

---

## 🍏 iOS

### 1. Install CocoaPods dependencies:
```bash
cd ./ios
pod install
```

### 2. Add the custom script to Xcode Build Phases:
Open Xcode → select your Target → go to **Build Phases** → click **+ New Run Script Phase**  
and paste the following command:
```bash
bash "${SRCROOT}/../node_modules/react-native-config-jsi/src/scripts/generate-xcconfig.sh"
```

---

## 🤖 Android

At the **bottom** of `android/app/build.gradle`, add the following line:

```gradle
apply from: project(':react-native-config-jsi').projectDir.getPath() + "/dotenv.gradle"
```

This will ensure that the `.env` variables are properly loaded into the build.

---

## 🚀 Usage

Import the library and retrieve environment variables natively:

```javascript
import { RNConfig } from "react-native-config-jsi";

const apiKey = RNConfig.get("API_KEY");
console.log("API_KEY:", apiKey);
```

---

## ⚡ Features

- ✅ **Blazing fast** thanks to JSI (JavaScript Interface)
- ✅ **Written in C++** for performance optimization
- ✅ **No async calls** – variables are accessed synchronously
- ✅ **No extra dependencies** – lightweight and efficient

---

## 📜 License

MIT

---

Now you're all set! 🎉 Happy coding with **react-native-config-jsi**! 🚀
