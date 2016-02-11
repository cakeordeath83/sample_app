require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
		@user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
=begin
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 245 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end
  
  test "email validation should not accept invalid addresses" do
    invalid_addresses = %w[user@example,com USER#@foo.COM A_US-ER@foo
                         firstlast@foo+bar.jp alice+bob@baz_/.cn]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
	test "password should be present" do 
		@user.password = @user.password_confirmation = "      "
		assert_not @user.valid?
	end
	
	test "password should be greater than 5 characters" do 
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end
	
	test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
	end
  
  test "associated microposts should be destroyed" do
    # Save so that the user gets an id and therefore makes the micropost valid
    @user.save
    @user.microposts.create!(content: "Nonsense")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    clair = users(:clair)
    malory = users(:malory)
    assert_not clair.following?(malory)
    clair.follow(another)
    assert clair.following?(another)
    assert another.followers.include?(clair)
    clair.unfollow(another)
    assert_not clair.following?(another)
  end
=end

  test "feed should have the right posts" do
    clair = users(:clair)
    malory = users(:malory)
    another = users(:another)
    lana = users(:lana)
    # Posts from followed user
    another.microposts.each do |post_following|
      assert clair.feed.include?(post_following)
    end
    # Posts from self
    clair.microposts.each do |post_self|
     assert clair.feed.include?(post_self)
    end
    # Posts from unfollowed user
    malory.microposts.each do |post_unfollowed|
      assert_not clair.feed.include?(post_unfollowed)
    end
    
  end
  
end
