require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one)
  end

  test "should get index" do
    get people_url
    assert_response :success
  end

  test "should get show" do
    get person_url(@person)
    assert_response :success
  end

  test "should get new" do
    get new_person_url
    assert_response :success
  end

  test "should create person" do
    assert_difference("Person.count") do
      post people_url, params: { person: { first_name: "Test", last_name: "Person" } }
    end
    assert_redirected_to person_url(Person.last)
  end

  test "should get edit" do
    get edit_person_url(@person)
    assert_response :success
  end

  test "should update person" do
    patch person_url(@person), params: { person: { first_name: "Updated" } }
    assert_redirected_to person_url(@person)
  end

  test "should destroy person" do
    # Create a person without any articles
    person_without_articles = Person.create!(first_name: "Test", last_name: "Delete")

    assert_no_difference("Person.count") do
      delete person_url(person_without_articles)
    end
    person_without_articles.reload
    assert person_without_articles.deleted?
    assert_redirected_to people_url
  end
end
