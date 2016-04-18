//= require_tree .
//= require job_notifier/notifier

JobNotifier.onNotify = function(data) {
  console.info('On notify', data);
};
