FactoryGirl.define do

  factory :campus, class: Gaku::Campus do
    name 'Takiko Campus'
    school
  end

  trait :with_one_address do
    after(:create) do |campus|
      campus.address = create(:address, addressable: campus)
      campus.save
    end
  end

end
