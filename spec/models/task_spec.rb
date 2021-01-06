require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @task = FactoryBot.build(:task)
  end

  describe "タスク作成機能" do
    context "新規タスクを作成できるとき" do
      it "name,specificsがあれば作成できる" do
        expect(@task).to be_valid
      end

      it "specificsがなくても作成できる" do
        @task.specifics = ""
        expect(@task).to be_valid
      end
    end

    context "新規タスクを作成できないとき" do
      it "nameがないと作成できない" do
        @task.name = ""
        @task.valid?
        expect(@task.errors.full_messages).to include("Name can't be blank")
      end
    end
  end
end
