(function(window){
  'use strict';
  function defineLibrary(){
    var JobNotifier = {};

    JobNotifier.init = function() {
      var body = document.querySelector('body');
      JobNotifier.jobIdentifier = body.dataset.identifier;

      setInterval(JobNotifier.poll, 5000);
    };

    JobNotifier.poll = function() {
      var oReq = new XMLHttpRequest();
      oReq.onload = JobNotifier.reqListener;
      oReq.onerror = JobNotifier.onError;
      oReq.open('get', '/job_notifier/jobs.json?identifier=' + JobNotifier.jobIdentifier, true);
      oReq.send();
    };

    JobNotifier.reqListener = function() {
      var data = JSON.parse(this.responseText);

      if(data.length > 0) {
        JobNotifier.onNotify(data);
      }
    };

    JobNotifier.onNotify = function(data) {
      console.info('Override this method with your own logic. Data: ', data);
    };

    JobNotifier.onError = function(err) {
      console.error('Error', err);
    };

    return JobNotifier;
  }

  if(typeof(JobNotifier) === 'undefined'){
    window.JobNotifier = defineLibrary();
  } else{
    console.log('JobNotifier already defined.');
  }
})(window);

document.addEventListener('DOMContentLoaded', JobNotifier.init);
