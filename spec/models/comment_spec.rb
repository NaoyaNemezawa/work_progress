require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe "コメント投稿機能" do
    context "コメント投稿できるとき" do
      it "commmentがあれば投稿できる" do
        expect(@comment).to be_valid
      end
    end

    context "コメント投稿できないとき" do
      it "commentが空だと投稿できない" do
        @comment.comment = ""
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Comment can't be blank")
      end
    end
  end
end
