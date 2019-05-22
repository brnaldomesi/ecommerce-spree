FactoryBot.define do
  factory :store, class: Spree::Store do

    factory :basic_store, aliases: [:sample_store, :clothing_store] do
      name { 'Sample Clothing Store' }
      url { 'localhost' }
      mail_from_address { 'sample_clothing_store@me.com' }
      code { 'stores/sample_clothing_store' }
    end
  end
end