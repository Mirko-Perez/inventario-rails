require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one)
    @article = articles(:one)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get show" do
    get article_url(@article)
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { brand: "Test Brand", model: "Test Model", entry_date: Date.current, current_person_id: @person.id } }
    end
    assert_redirected_to article_url(Article.last)
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { brand: "Updated Brand" } }
    assert_redirected_to article_url(@article)
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end
    assert_redirected_to articles_url
  end
end
