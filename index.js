import {
  NativeModules,
  NativeEventEmitter,
} from 'react-native';

const { RNHeadphoneDetection } = NativeModules;
const eventEmitter = new NativeEventEmitter();

export default {
  ...RNHeadphoneDetection,
  addListener(callback) {
    return eventEmitter.addListener(
      RNHeadphoneDetection.AUDIO_DEVICE_CHANGED_NOTIFICATION,
      callback
    );
  },
};
