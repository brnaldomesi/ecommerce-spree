FactoryBot.define do
  factory :user, class: Spree::User do

    factory :basic_user, aliases: [:viewer, :buyer] do
      email { 'buyer01@gmail.com' }
    end

    factory :seller, aliases: [:basic_seller] do
      email { 'seller01@gmail.com' }
    end
  end
end