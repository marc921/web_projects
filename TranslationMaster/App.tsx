import {createAppContainer} from 'react-navigation';
import { createDrawerNavigator } from 'react-navigation-drawer';

import HomeScreen from "./pages/home";
import ProfileScreen from "./pages/add_entry";

const MainNavigator = createDrawerNavigator(
  {
    Home: {screen: HomeScreen},
    Profile: {screen: ProfileScreen},
  },
  {
    drawerBackgroundColor: 'white',
  }
);

const App = createAppContainer(MainNavigator);

export default App;