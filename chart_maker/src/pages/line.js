import React from "react";
import ChartistGraph from "react-chartist";

export default class Line extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: {
        labels: ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'W9', 'W10'],
        series: [
          [1, 2, 4, 8, 6, -2, -1, -4, -6, -2],
          [12, 32, 14, 18, -6, -12, 10, -14, -16, -22]
        ]
      },
      options: {
        width: "33%",
        height: "33%",
        axisX: {
          labelInterpolationFnc: (value, index) => index % 2 === 0 ? value : null
        }
      },
      type: 'Line'
    };
  }
  
  render() {
    const {data, options, type} = this.state;
    return (
      <div>
        <h2>Look at my line!</h2>
        <ChartistGraph className={'ct-octave'} data={data} options={options} type={type} />
      </div>
    );
  }
}