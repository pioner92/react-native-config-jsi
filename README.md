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

> **⚠️ Important:** Ensure your project supports **JSI** and has the proper build setup for C++.

---

## 🔧 Setup

### 1️⃣ Create a `.env` file in the root of your project

Add environment variables inside `.env`:
```
API_KEY=your_api_key
APP_NAME=MyAwesomeApp
```

---

### 2️⃣ Configure `android/app/build.gradle`

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

Since this library is **built on JSI**, it provides **instant access** to environment variables without relying on the React Native bridge.

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