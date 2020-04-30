FactoryBot.define do
  factory :item do
    name { Faker::Games::Pokemon.name }
    done { false }
    todo_id { nil }
  end
end
