FactoryBot.define do
  factory :addresses, class: ::Spree::Address do
    factory :sample_address, aliases: [:sample_us_address] do
      firstname {'Supplier'}
      lastname { 'Inc' }
      address1 {'100 State St'}
      city {'Santa Barbara'}
      zipcode {'93101'}
      phone { '1234567890' }
      state_id { (::Spree::Country.where(name: 'California').first || create(:california_state) ).id }
      country_id { (::Spree::Country.where(name: 'United States').first || create(:united_states) ).id }
      timezone { '-07:00' }
    end
  end

  factory :states, class: ::Spree::State do
    factory :california_state, aliases: [:sample_state, :sample_us_state] do
      name {'California'}
      abbr {'CA'}
      country_id { (::Spree::Country.where(name: 'United States').first || create(:united_states) ).id }
    end
  end

  factory :countries, class: ::Spree::Country do
    factory :united_states, aliases: [:sample_country] do
      iso_name {'UNITED STATES'}
      iso {'US'}
      iso3 {'USA'}
      name {'United States'}
      numcode { 840 }
      states_required { true }
    end
  end
end