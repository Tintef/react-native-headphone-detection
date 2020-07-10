import { useState, useEffect } from 'react';
import { NativeModules, NativeEventEmitter, EventSubscription } from 'react-native';

export interface ConnectedResult {
  audioJack: boolean
  bluetooth: boolean
}

const RNHeadphoneDetection = NativeModules.RNHeadphoneDetection;
const eventEmitter = new NativeEventEmitter(RNHeadphoneDetection);

export interface IHeadphoneDetection {
  isAudioDeviceConnected: () => Promise<ConnectedResult>
  AUDIO_DEVICE_CHANGED_NOTIFICATION: string
  addListener: (callback: (connection: ConnectedResult) => void) => EventSubscription
}
const HeadphoneDetection: IHeadphoneDetection = {
  ...RNHeadphoneDetection,
  addListener(callback) {
    return eventEmitter.addListener(
      RNHeadphoneDetection.AUDIO_DEVICE_CHANGED_NOTIFICATION,
      callback
    );
  },
};

export const useHeadphonesDetection = () => {
  const [result, setResult] = useState<ConnectedResult>({
    audioJack: false,
    bluetooth: false
  })
  useEffect(() => {
    HeadphoneDetection.isAudioDeviceConnected().then(setResult);
    const subscription = HeadphoneDetection.addListener(setResult);
    return () => {
      subscription.remove();
    };
  }, []);
  return result;
}

export default HeadphoneDetection;
