import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import React, { useEffect } from 'react';
import RNBootSplash from 'react-native-bootsplash';

import BookScreen from '../screens/BookScreen';
import HomeScreen from '../screens/HomeScreen';
import { EAppScreens } from '../typescript';

const Stack = createNativeStackNavigator<any>();

export const AppNavigator = () => {
  useEffect(() => {
    RNBootSplash.hide();
  }, []);
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName={EAppScreens.Home}>
        <Stack.Group>
          <Stack.Screen
            name={EAppScreens.Home}
            component={HomeScreen}
            options={{ headerTransparent: true }}
          />
          <Stack.Screen
            name={EAppScreens.Book}
            component={BookScreen}
            options={{ headerTransparent: true }}
          />
        </Stack.Group>
      </Stack.Navigator>
    </NavigationContainer>
  );
};
