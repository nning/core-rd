FactoryGirl.define do
  factory :typed_link do
    sequence(:path) { |n| "/test#{n}" }
  end
end
