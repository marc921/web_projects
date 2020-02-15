import React from "react";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link
} from "react-router-dom";

import Home from "./pages/home";
import Line from "./pages/line";
import Pie from "./pages/pie";
import Bar from "./pages/bar";

import "./App.css";

export default function App() {
  return (
    <Router>
      <nav className="sidenav">
        <ul>
          <li><Link to="/">     Home  </Link></li>
          <li><Link to="/line"> Line  </Link></li>
          <li><Link to="/pie">  Pie  </Link></li>
          <li><Link to="/bar">  Bar  </Link></li>
        </ul>
      </nav>

      {/* A <Switch> looks through its children <Route>s and
          renders the first one that matches the current URL. */}
      <div id="main">
        <Switch>
          <Route path="/line">  <Line />  </Route>
          <Route path="/pie">   <Pie />   </Route>
          <Route path="/bar">   <Bar />   </Route>
          <Route path="/">      <Home />  </Route>
        </Switch>
      </div>
      <script src="./chartist.min.js"></script>
    </Router>
  );
}
