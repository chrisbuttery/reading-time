require('./main.css');

const Elm = require('./Main.elm');
const root  = document.getElementById('elm-app');
const app = Elm.Main.embed(root);

let target;

function getTarget() {
  target = document.querySelector('.article');
  // ... or target the body
  // const target = document.documentElement;
}

getTarget();

if (!target) {
  var timer = setInterval(function() {
    getTarget();
    if (target){
       AddListener();
       clearInterval(timer);
    }
  }, 1000);
}

function AddListener () {
  window.addEventListener('scroll', function() {
    app.ports.onScroll.send({
      scrollTop: document.documentElement.scrollTop || document.body.scrollTop,
      targetScrollHeight: target.scrollHeight,
      clientHeight: document.documentElement.clientHeight
    });
  });
}
