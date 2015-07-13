User.create!(name: "Example User",
    derby_name: "User Example",
    email: "example@rdsg.com",
    password: "foobar",
    password_confirmation: "foobar",
    admin: true,
    activated: true,
    activated_at: Time.zone.now)

99.times do |n|
    name = Faker::Name.name
    derby_name = "Derby #{name}"
    email = "example-#{n+1}@rdsg.com"
    password = "password"
    User.create!(name: name,
        derby_name: derby_name,
        email: email,
        password: password,
        password_confirmation: password,
        activated: true,
        activated_at: Time.zone.now)
end
