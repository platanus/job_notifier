FactoryGirl.define do
  factory :job_notifier_job, class: 'JobNotifier::Job' do
    identifier "MyString"
    status "MyString"
    result "MyText"
  end
end
