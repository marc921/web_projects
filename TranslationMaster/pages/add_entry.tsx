import React from "react";
import { View, Text } from 'react-native';
import styles from './styles';
import { TextInput } from "react-native-gesture-handler";

export default class Home extends React.Component {
  static navigationOptions = {
    drawerLabel: 'Add Entry',
  };
  //state object
  state = {
    value: "hello"
  };
  render() {
    const onChangeText = (text) => alert(text);
    const { navigation } = this.props;
    const { value } = this.state;
    return (
      <View style={styles.view}>
        <Text>
          I am {navigation.getParam('name')}!
        </Text>
        <TextInput
          style={{ height: 40, borderColor: 'gray', borderWidth: 1 }}
          onChangeText={text => onChangeText(text)}
          value={value}
        />
      </View>
    );
  }
}