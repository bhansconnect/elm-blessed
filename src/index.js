import blessed from 'blessed';
import { Elm } from './Main.elm';


const screen = blessed.screen({
  autoPadding: true,
  smartCSR: true,
  title: 'Elm + blessed = <3'
});
screen.key(['escape', 'q', 'C-c'], function (ch, key) {
  return process.exit(0);
});


let state;
const elm = Elm.Main.init();

function createElement(parent, node) {
  let elem;
  node.props.parent = parent
  if (node.kind === "root") {
    elem = screen;
  } else {
    elem = blessed[node.kind](node.props);
  }
  node.events.forEach(x => {
    elem.on(x.kind, data => {
      let cmd = x.command;
      cmd.data = data;
      elm.ports.recieveMessage.send(cmd);
    })
  });

  node.children.map(x => createElement(elem, x));
  return elem;
}

function clean(elem) {
  elem.children.forEach(clean);
  elem.destroy();
}

elm.ports.sendState.subscribe((newState) => {
  //console.log(JSON.stringify(newState, null, 2));
  screen.children.forEach(clean);
  createElement(null, newState);
  screen.render();
  state = newState;
});

elm.ports.sendError.subscribe((err) => {
  console.error(err)
});