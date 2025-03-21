# 🚀 react-native-config-jsi

**Fast JSI-based React Native library to access `.env` variables natively with C++ performance.**

---

## 📦 Install

To install the library, use either npm or yarn:
```sh
npm install react-native-config-jsi

yarn add react-native-config-jsi
```

---

## 🔧 Quick Setup

1. Create `.env` at project root:
```env
#EXAMPLE
API_KEY=your_api_key
APP_NAME=MyAwesomeApp
...
```

2. **iOS:**
```bash
cd ios && pod install
```
Add to Xcode → Target → Build Phases → **+ New Run Script Phase**:
```bash
bash "${SRCROOT}/../node_modules/react-native-config-jsi/src/scripts/generate.sh"
```
---

## 🚀 Usage
> ⚠️ **Note:** After updating `.env`, rebuild or restart your app to apply changes.
```js
import { RNConfig } from "react-native-config-jsi";

const apiKey = RNConfig.get("API_KEY");
console.log("API_KEY:", apiKey);
```

---

## ⚡ Highlights

- 🔥 Ultra-fast JSI native access
- ⚙️ Built in C++
- 🧩 Synchronous API
- 🪶 No extra dependencies

---

## 📜 License

MIT

---

🎉 **Enjoy using react-native-config-jsi!** 🚀
