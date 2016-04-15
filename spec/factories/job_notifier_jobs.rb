FactoryGirl.define do
  factory :job_notifier_job, class: 'JobNotifier::Job' do
    identifier "MyString"
    result "MyText"
  end
end
