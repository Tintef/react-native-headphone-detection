import {
  NativeModules,
  NativeEventEmitter,
  Platform
} from 'react-native';

const { RNHeadphoneDetection } = NativeModules;
const eventEmitter = new NativeEventEmitter(Platform.OS == "android" ? null : RNHeadphoneDetection);

export default {
  ...RNHeadphoneDetection,
  addListener(callback) {
    return eventEmitter.addListener(
      RNHeadphoneDetection.AUDIO_DEVICE_CHANGED_NOTIFICATION,
      callback
    );
  },
};
