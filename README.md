# Running the app
  ### Environment setup
  - https://reactnative.dev/docs/next/environment-setup
  - run `yarn` to install dependencies
  - (Optional) if babel error appears, need to run `yarn --reset-cache`. It's required because of reanimated2 library and his babel config.

### iOS
  - Go to ios folder and `pod install` to install pods
  - Select required scheme in Xcode
  - Run the app over Xcode
  - (Optional) Run `yarn ios` or `yarn ios:prod` to run project on simulator

### Android
  - Run `yarn android` or `yarn android:prod` to run project on simulator

### Debugging
  - install the flipper (https://fbflipper.com)
  - install required extensions for flipper (main extensions: `react-native-navigation`, `rn-async-storage-flipper`, `react-native-performance`)
