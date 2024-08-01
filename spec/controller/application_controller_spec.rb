require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    # ダミーアクションを定義
    def dummy_action
      render plain: "これはダミーアクションです"
    end
  end

  # before_actionフィルタが正しく機能することを確認する
  describe "before actions" do
    it "before_actionがtrueの時に呼び出されることの確認" do

      # receiveメソッドで、"controller"が configure_permitted_parametersメソッドを呼び出すことを期待するモックを設定する
      expect(controller).to receive(:configure_permitted_parameters)

      # テスト用のルートを定義する
      routes.draw { get "dummy_action" => "anonymous#dummy_action" }

      # dummy_actionアクションがGETリクエストで呼び出すことを確認する
      get :dummy_action
    end
  end

  describe "configure_permitted_parameters" do
    before do
      # "devise.mapping"変数に、mappingsメソッドで、Deviseが管理しているユーザーモデルに対応するマッピング情報を格納する
      # テストリクエストが正しくユーザー認証されるようにする
      @request.env["devise.mapping"] = Devise.mappings[:user]

      # テスト対象に、devise_controller?メソッドをスタブし、戻り値が常にtrueになるようにする
      # devose_controller?メソッドは、コントローラーがDevise関連であるかを確認するメソッド
      controller.stub(:devise_controller?).and_return(true)

      # sendメソッドを使って、privateまたはprotectメソッドを直接呼び出す
      controller.send(:configure_permitted_parameters)
    end

    it "サインアップ時にname,avatar,bioが許可されることを確認する" do
      # devise_parameter_sanitizerメソッドで、データが適切であることを確認し、includeメソッドで、許可するリストに入っているかを確認する
      expect(controller.devise_parameter_sanitizer.for(:sign_up)).to include(:name, :avatar, :bio)
    end

    it "アカウント情報更新時にname,avatar,bioが許可されることを確認する" do
      expect(controller.devise_parameter_sanitizer.for(:account_update)).to include(:name, :avatar, :bio)
    end
  end

  describe "after_sign_in_path_for" do
    it "サインイン後に書籍一覧ページに飛ぶことを確認する" do

      # FactoryBotを使ってユーザーを作成
      user = create(:user)

      expect(controller.after_sign_in_path_for(user)).to eq(books_path)
    end
  end
end