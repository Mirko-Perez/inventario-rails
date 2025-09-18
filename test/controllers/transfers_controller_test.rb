require "test_helper"

class TransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
    @person_from = people(:one)
    @person_to = people(:two)
    @transfer = transfers(:one)
  end

  test "should get index" do
    get transfers_url
    assert_response :success
  end

  test "should get show" do
    get transfer_url(@transfer)
    assert_response :success
  end

  test "should get new" do
    get new_article_transfer_url(@article)
    assert_response :success
  end

  test "should create transfer" do
    # Create a simple transfer between two different people
    # Use article fixture 'one' which has current_person 'one'
    # Transfer to person 'two'

    assert_difference("Transfer.count") do
      post article_transfers_url(@article), params: {
        transfer: {
          article_id: @article.id,
          from_person_id: @article.current_person_id,
          to_person_id: @person_to.id,
          transfer_date: Date.current,
          notes: "Test transfer"
        }
      }
    end
    assert_redirected_to article_url(@article)
  end

  test "should destroy transfer (soft delete)" do
    transfer = transfers(:one)

    # Soft delete NO cambia la cantidad de filas
    assert_no_difference("Transfer.count") do
      delete transfer_path(transfer)
    end
    assert_redirected_to transfers_url

    # El registro sigue existiendo pero con deleted_at (soft-deleted)
    deleted = Transfer.with_deleted.find(transfer.id)
    assert deleted.deleted?, "Expected transfer to be soft-deleted (deleted_at present)"

    # La index lista solo activas, por lo que no debe aparecer
    get transfers_path
    assert_response :success
    refute_match transfer.id.to_s, @response.body
  end
end
