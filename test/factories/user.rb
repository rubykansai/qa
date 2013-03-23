FactoryGirl.define do
  factory(:user) do |m|
    m.id 1
  end
  factory(:quentin, parent: :user) do |m|
    m.name  "quentin"
    m.email "quentin@example.com"
    m.password "monkey"
  end
  factory(:aaron, parent: :user) do |m|
    m.name  "aaron"
    m.email "aaron@example.com"
    m.password "monkey"
    m.subjects{|u|
      [u.association(:subject_with_question)]
    }
  end
  factory(:old_password_holder, parent: :user) do |m|
    m.name  "old_password_holder"
    m.email "salty_dog@example.com"
  end
  factory(:subject_holder, parent: :user) do |m|
    m.name  "holder"
    m.email "holder@example.com"
  end
  factory(:openid_user, parent: :user) do |m|
    m.name  "openid_user"
    m.email "openid@example.com"
  end
end

