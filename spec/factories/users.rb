FactoryBot.define do
  factory :user, class: Spree::User do

    factory :basic_user, aliases: [:viewer, :buyer, :boy_user] do
      email { 'buyer01@gmail.com' }
      username { 'bison' }
      display_name { 'Bison' }
    end

    factory :seller, aliases: [:basic_seller, :girl_user] do
      email { 'seller01@gmail.com' }
      username { 'sally' }
      display_name { 'Sally' }
    end
  end
end