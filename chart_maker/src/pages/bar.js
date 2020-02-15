import React from "react";
import ChartistGraph from "react-chartist";

export default class Pie extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: {
        labels: ['Rent', 'Food', 'Drinks', 'Books', 'Projects'],
        series: [
          [1000, 500, 200, 100, 300],
          [1200, 600, 300, 200, 500],
          [800, 400, 100, 50, 200]
        ]
      },
      options: {
        width: "33%",
        height: "33%"
      },
      type: 'Bar'
    };
  }
  
  render() {
    const {data, options, type} = this.state;
    return (
      <div>
        <h2>Look at my bar!</h2>
        <ChartistGraph className={'ct-octave'} data={data} options={options} type={type} />
      </div>
    );
  }
}