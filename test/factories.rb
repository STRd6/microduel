Factory.sequence :email do |n|
  "test#{n}@example.com"
end

Factory.define :ability do |ability|
  ability.name "Bonus Fire"
  ability.star_cost 1
  ability.time_cost 0
  ability.effect Ability::Effect.new({})
end

Factory.define :game do |game|
  game.name "Test Game"
end

Factory.define :player do |player|
  player.association :user
  player.association :game
end

Factory.define :game_card do |game_card|
  game_card.association :player
  game_card.association :card
  game_card.position 0
end

Factory.define :user do |user|
    user.email {Factory.next(:email)}
    user.password "test1234"
end

Factory.define :card do |card|
  card.name "Test Card"
end
