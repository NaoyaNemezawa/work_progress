require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @project = FactoryBot.build(:project)
  end

  describe "プロジェクト作成機能" do
    context "プロジェクトを作成できるとき" do
      it "プロジェクト名あれば作成できる" do
      expect(@project).to be_valid
      end
    end

    context "プロジェクトを作成できないとき" do
      it "プロジェクト名が無いと作成できない" do
        @project.name = ""
        @project.valid?
        expect(@project.errors.full_messages).to include("Name can't be blank")
      end
    end
  end
end
