FactoryGirl.define do
  factory :typed_link do
    sequence(:uri) { |n| "coap://[2001:db8::#{n}]/test#{n}" }
  end
end
