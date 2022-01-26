FactoryGirl.define do
  factory :application_deadline, class: "ApplicationDeadline" do
    name 'submit proposal deadline'
    submission_deadline Time.now + 8.hours
  end
end
