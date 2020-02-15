import React from "react";
import { View, Button, Text } from 'react-native';
import styles from './styles';

export default class Home extends React.Component {
  static navigationOptions = {
    drawerLabel: 'Home',
  };
  render() {
    const { navigate } = this.props.navigation;
    return (
      <View style={styles.view}>
        <Text>
          Welcome to Translation Master!{"\n"}
          Swipe for drawer menu.
        </Text>
        <Button
          title="Go to Mary's profile"
          onPress={() => navigate('Profile', {name: 'Mary'})} 
        />
      </View>
      
    );
  }
}