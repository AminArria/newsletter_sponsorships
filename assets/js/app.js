// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

import './bulma'


document.addEventListener('DOMContentLoaded', () => {
  // When creating a sponsorship sets the value of the issue_id selector
  (document.querySelectorAll('.modal-trigger[data-target="sponsor-form"]') || []).forEach(modalTrigger => {
    let target = document.getElementById(modalTrigger.dataset.target);
    let select = target.querySelector("select");
    let issueId = modalTrigger.dataset.issue;

    modalTrigger.addEventListener('click', () => {
      select.value = issueId;
    })
  });
});
