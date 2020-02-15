import React from "react";
import ChartistGraph from "react-chartist";

export default class Pie extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: {
        labels: ['Rent', 'Food', 'Drinks', 'Books', 'Projects'],
        series: [1000, 500, 200, 100, 300]
      },
      options: {
        donut: true,
        width: "33%",
        height: "33%",
        labelInterpolationFnc: (value, index) => value,
        donutWidth: 50,
        chartPadding: 30,
        labelOffset: 30,
        labelDirection: 'explode'
      },
      type: 'Pie'
    };
  }
  
  render() {
    const {data, options, type} = this.state;
    return (
      <div>
        <h2>Look at my pie!</h2>
        <ChartistGraph className={'ct-octave'} data={data} options={options} type={type} />
      </div>
    );
  }
}