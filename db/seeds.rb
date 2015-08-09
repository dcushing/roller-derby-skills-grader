User.create!(name: "Example User",
    derby_name: "User Example",
    email: "example@rdsg.com",
    password: "foobar",
    password_confirmation: "foobar",
    admin: true,
    activated: true,
    activated_at: Time.zone.now,
    league: "Example League",
    blocker: true,
    jammer: true,
    freshmeat: true,
    ref: true,
    nso: true)

99.times do |n|
    name = Faker::Name.name
    derby_name = "D #{name}"
    email = "example-#{n+1}@rdsg.com"
    password = "password"
    User.create!(name: name,
        derby_name: derby_name,
        email: email,
        password: password,
        password_confirmation: password,
        activated: true,
        activated_at: Time.zone.now,
        league: Faker::Lorem.word,
        blocker: true,
        jammer: false,
        freshmeat: false,
        ref: true,
        nso: false)
end

users = User.order(:created_at).take(6)
50.times do
    name = Faker::Lorem.word
    comments = Faker::Lorem.sentence(5)
    users.each { |user| user.skills.create!(name: name, level: 3, comments: comments) }
end
