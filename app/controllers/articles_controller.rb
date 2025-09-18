class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :edit, :update, :destroy, :restore ]

  def index
    @articles = Article.active.includes(:current_person)
    @articles = @articles.by_brand(params[:brand]) if params[:brand].present?
    @articles = @articles.by_model(params[:model]) if params[:model].present?
    @articles = @articles.by_entry_date(params[:entry_date]) if params[:entry_date].present?
    @articles = @articles.order(:brand, :model)
    @brands = Article.active.distinct.pluck(:brand).compact.sort
  end

  def show
    @transfer_history = @article.transfer_history
  end

  def new
    @article = Article.new
    @people = Person.all.order(:first_name, :last_name)
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      @people = Person.all.order(:first_name, :last_name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @people = Person.all.order(:first_name, :last_name)
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      @people = Person.all.order(:first_name, :last_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.soft_delete!
    redirect_to articles_url, notice: "Article was successfully deleted."
  end

  def restore
    @article.restore!
    redirect_to @article, notice: "Article was successfully restored."
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:model, :brand, :entry_date, :current_person_id)
  end
end
