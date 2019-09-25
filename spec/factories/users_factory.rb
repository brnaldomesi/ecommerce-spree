def find_or_create(factory_key, primary_search_attribute)
  new_obj = build(factory_key)
  existing = new_obj.class.where(primary_search_attribute => new_obj.send(primary_search_attribute) ).first
  unless existing
    new_obj.save
    existing = new_obj
  end
  existing
end

FactoryBot.define do
  factory :user, class: Spree::User do

    trait :real_ip do
      current_sign_in_ip { '98.110.194.34' }
    end

    factory :basic_user, aliases: [:viewer, :buyer, :boy_user] do
      email { 'buyer01@gmail.com' }
      username { 'bison' }
      display_name { 'Bison' }
    end

    factory :another_user, aliases: [:viewer_2, :buyer_2, :boy_user_2] do
      email { 'buyer02@gmail.com' }
      username { 'connor' }
      display_name { 'Connor' }
    end

    factory :seller, aliases: [:basic_seller, :girl_user] do
      email { 'seller01@gmail.com' }
      username { 'sally' }
      display_name { 'Sally' }
    end
  end

  factory :address, class: Spree::Address do
    factory :basic_address, aliases: [:boston, :usa_address, :business_address] do
      firstname { 'Mary' }
      lastname { 'Sanders' }
      address1 { '100 Washington ST' }
      city { 'Boston' }
      zipcode { '02161' }
      phone { '6177208112' }
      state_name { 'MA' }
      company { 'MS Merchandise' }
      country_id { find_or_create(:country_usa, :name).id }
      state_id { find_or_create(:ma_state, :name).id  }
    end
  end

  factory :country, class: Spree::Country do
    factory :country_usa, aliases: [:basic_country] do
      iso_name { 'UNITED STATES' }
      iso { 'US' }
      iso3 { 'USA' }
      name { 'United States' }
      numcode { 840 }
      states_required { true }
    end
  end

  factory :state, class: Spree::State do
    factory :state_ma, aliases: [:ma_state] do
      name { 'Massachusetts' }
      abbr { 'CA' }
      country_id { find_or_create(:country_usa, :name).id }
    end
  end
end