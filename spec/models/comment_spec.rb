require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe "コメント投稿機能" do
    context "コメント投稿できるとき" do
      it "コメントと画像があれば投稿できる" do
        expect(@comment).to be_valid
      end
      it "commmentがあれば投稿できる" do
        @comment.img = nil
        expect(@comment).to be_valid
      end
      
      it "画像があれば投稿できる" do
        @comment.comment = nil
        expect(@comment).to be_valid
      end
    end

    context "コメント投稿できないとき" do
      it "commentが空だと投稿できない" do
        @comment.comment = ""
        @comment.img = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Comment can't be blank")
      end
    end
  end
end
