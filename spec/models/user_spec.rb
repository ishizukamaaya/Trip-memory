require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do

  it "名前とメールアドレスとパスワードがあれば登録できる" do
    expect(FactoryBot.create(:user)).to be_valid
  end

  it "名前がなければ登録できない" do
    expect(FactoryBot.build(:user, name: "")).to_not be_valid
  end

  it "メールアドレスがなければ登録できない" do
    expect(FactoryBot.build(:user, email: "")).to_not be_valid
  end

  it "パスワードがなければ登録できない"  do
    expect(FactoryBot.build(:user, password: "")).to_not be_valid
  end

end
