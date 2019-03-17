require 'test_helper'

class TranslationsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @song = songs(:one)
    @translation = translations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:translations)
  end

  # removed 'should get new' test

  test "should create translation" do
    assert_difference('Translation.count') do
      post :create, id: 1, song_id: @song, translation: { link: 'http://translationLink',
      language_id: 1 }
    end

    assert_redirected_to song_path(@song)
  end

  test "should show translation" do
    get :show, id: @translation, song_id: @translation.song_id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @translation, song_id: @translation.song_id
    assert_response :success
  end

  test "should update translation" do
    patch :update, id: @translation, song_id: @translation.song_id, translation: { link: @translation.link,
    language_id: @translation.language_id }
    assert_redirected_to song_path(@translation.song_id)
  end

  test "should destroy translation" do
    assert_difference('Translation.count', -1) do
      delete :destroy, id: @translation, song_id: @translation.song_id
    end

    assert_redirected_to song_path(@translation.song_id)
  end
end
