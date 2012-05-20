Factory.define :user do |user|
  user.name                  "John Smith"
  user.username              "jsmith"
  user.display_name          "J. Smith"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :name do |n|
	"Person #{n}"
end

Factory.sequence :username do |n|
	"jsmith#{n}"
end

Factory.sequence :display_name do |n|
	"J. Smith #{n}"
end

Factory.define :post do |post|
	post.title 'Hello World!'
	post.content 'This is your blog post.'
	post.association :user
end