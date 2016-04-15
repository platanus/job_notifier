document.addEventListener("DOMContentLoaded", init);

var jobIdentifier;

function init() {
  var body = document.querySelector("body");
  jobIdentifier = body.dataset.identifier;

  setInterval(poll, 5000);
}

function poll() {
  var oReq = new XMLHttpRequest();
  oReq.onload = reqListener;
  oReq.onerror = reqError;
  oReq.open('get', '/job_notifier/jobs.json?identifier=' + jobIdentifier, true);
  oReq.send();
}

function reqListener() {
  var data = JSON.parse(this.responseText);
  console.log(data);
}

function reqError(err) {
  console.log('Fetch Error :-S', err);
}
