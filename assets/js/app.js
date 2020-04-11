// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css";

// Bootstrap
import "bootstrap";

// FontAwesome
import { library } from "@fortawesome/fontawesome";
import { faFacebook } from "@fortawesome/fontawesome-free-brands";
import {
  faPlusCircle, faCogs, faTimes, faSignInAlt, faGavel
} from "@fortawesome/fontawesome-free-solid";
library.add(faFacebook, faPlusCircle, faCogs, faSignInAlt, faGavel);

import "./browser_timezone";
import "./markdown_editor";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
