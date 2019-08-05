
# react-native-headphone-detection

## Getting started

`$ yarn add react-native-headphone-detection`

### Mostly automatic installation

- For `react-native` 0.60+:

  ```bash
  $ cd ios && pod install && cd ..
  ```

- For previous versions:

  ```bash
  $ react-native link react-native-headphone-detection
  ```

Add permissions for android:
```java
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH" />
```

## Usage
```javascript
import HeadphoneDetection from 'react-native-headphone-detection';

// Function
HeadphoneDetection.isAudioDeviceConnected().then(console.log);
/*
  Output:
  {
    audioJack: boolean,
    bluetooth: boolean,
  }
*/

// You can also use it as an event listener
HeadphoneDetection.addListener(console.log);

// Don't forget to remove the listener!
if (HeadphoneDetection.remove) { // The remove is not necessary on Android
  HeadphoneDetection.remove();
}
```
