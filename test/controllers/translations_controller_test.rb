require 'test_helper'

class TranslationsControllerTest < ActionController::TestCase
  setup do
    #@song = songs(:one)
    #@translation = @song.translations.first
    @translation = translations(:one)
    get :index, song_id: 1
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:translations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create translation" do
    assert_difference('Translation.count') do
      post :create, id: 1, translation: { link: 'http://translationLink',
      language_id: 1,
      song_id: 1 }
    end

    assert_redirected_to translation_path(assigns(:translation))
  end

  test "should show translation" do
    get :show, id: @translation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @translation
    assert_response :success
  end

  test "should update translation" do
    patch :update, id: @translation, translation: { link: @translation.link,
    language_id: @translation.language_id,
    song_id: @translation.song_id }
    assert_redirected_to translation_path(assigns(:translation))
  end

  test "should destroy translation" do
    assert_difference('Translation.count', -1) do
      delete :destroy, id: @translation
    end

    assert_redirected_to translations_path
  end
end
