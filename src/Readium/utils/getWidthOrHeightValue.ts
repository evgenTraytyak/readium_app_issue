import { PixelRatio, Platform } from 'react-native';

export const getWidthOrHeightValue = (val: number) => {
  return Platform.OS === 'android' ? PixelRatio.getPixelSizeForLayoutSize(val) : val;
};
