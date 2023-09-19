import { NavigationProp } from '@react-navigation/native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';

type ScreenParamList = {
  /**
   * All app screen param types goes here. Params are undefined by default for all app screens.
   * example: [EAppScreens.Home]: { step: 0 };
   */
  book: { book: any };
};

export type Override<T, R> = Omit<T, keyof R> & R;

export enum EAppScreens {
  Home = 'home',
  Book = 'book',
}

type NavigationScreensParamList = Override<{ [K in EAppScreens]: undefined }, ScreenParamList>;

export type ScreenProps<K extends keyof NavigationScreensParamList> = NativeStackScreenProps<
  NavigationScreensParamList,
  K
>;

export type Navigation = NavigationProp<NavigationScreensParamList>;
