class TransfersController < ApplicationController
  before_action :set_transfer, only: [ :show, :destroy, :restore ]

  def index
    @transfers = Transfer.active
                         .includes(:article, :from_person, :to_person)
                         .recent
                         .limit(50)
  end

  def show
  end

  def new
    @transfer = Transfer.new
    @transfer.article_id = params[:article_id] if params[:article_id]
    @articles = Article.includes(:current_person).order(:brand, :model)
    @people = Person.all.order(:first_name, :last_name)

    if @transfer.article_id
      @article = Article.find(@transfer.article_id)
      @transfer.from_person_id = @article.current_person_id
    end
  end

  def create
    @transfer = Transfer.new(transfer_params)

    if @transfer.save
      redirect_to @transfer.article, notice: "Transfer was successfully recorded."
    else
      @articles = Article.includes(:current_person).order(:brand, :model)
      @people = Person.all.order(:first_name, :last_name)
      @article = Article.find(@transfer.article_id) if @transfer.article_id
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @transfer.soft_delete!
    redirect_to transfers_url, notice: "Transfer was soft-deleted successfully."
  end

  def restore
    @transfer.restore!
    redirect_to transfer_path(@transfer), notice: "Transfer was restored successfully."
  end

  private

  def set_transfer
    @transfer = Transfer.find(params[:id])
  end

  def transfer_params
    params.require(:transfer).permit(:article_id, :from_person_id, :to_person_id, :transfer_date, :notes)
  end
end
