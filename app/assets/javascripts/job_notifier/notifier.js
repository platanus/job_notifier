(function(window){
  'use strict';
  function defineLibrary(){
    var MILLISECONDS_TO_GET_JOBS = 5000;
    var JobNotifier = {};

    JobNotifier.init = function() {
      var body = document.querySelector('body');
      JobNotifier.jobIdentifier = body.dataset.identifier;

      if(!JobNotifier.jobIdentifier) {
        return;
      }

      JobNotifier.rootUrl = body.dataset.rootUrl;
      JobNotifier.findJobs();
    };

    JobNotifier.performRequest = function(method, action, onLoadCallback) {
      var oReq = new XMLHttpRequest();
      oReq.onload = onLoadCallback;
      oReq.onerror = JobNotifier.onError;
      var url = JobNotifier.rootUrl + 'job_notifier/' + JobNotifier.jobIdentifier + '/jobs/' + action + '.json';
      oReq.open(method, url, true);
      oReq.send();
    };

    JobNotifier.findJobs = function() {
      setTimeout(JobNotifier.findPendingJobs, MILLISECONDS_TO_GET_JOBS);
    };

    JobNotifier.findPendingJobs = function() {
      JobNotifier.performRequest('get', 'pending', JobNotifier.onPendingJobsLoad);
    };

    JobNotifier.notifyJobs = function() {
      JobNotifier.performRequest('put', 'notify', JobNotifier.onNotifyJobsLoad);
    };

    JobNotifier.onPendingJobsLoad = function() {
      var data = JSON.parse(this.responseText);

      if (data.jobs) {
        data = data.jobs;
      }

      if(data.length === 0) {
        JobNotifier.findJobs();
        return;
      }

      JobNotifier.onNotify(data);
      JobNotifier.notifyJobs();
    };

    JobNotifier.onNotifyJobsLoad = function() {
      JobNotifier.findJobs();
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
