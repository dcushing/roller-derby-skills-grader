User.create!(display_name: "Example User",
    alternate_name: "User Example",
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
    display_name = Faker::Name.name
    alternate_name = "D #{display_name}"
    email = "example-#{n+1}@rdsg.com"
    password = "password"
    User.create!(display_name: display_name,
        alternate_name: alternate_name,
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
