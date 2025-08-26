class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  def index
    @people = Person.includes(:current_articles).order(:first_name, :last_name)
  end

  def show
    @current_articles = @person.current_articles.includes(:transfers)
    @transfer_history = @person.transfer_history
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    
    if @person.save
      redirect_to @person, notice: 'Person was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @person.update(person_params)
      redirect_to @person, notice: 'Person was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @person.current_articles.any?
      redirect_to @person, alert: 'Cannot delete person who currently carries articles.'
    else
      @person.destroy
      redirect_to people_url, notice: 'Person was successfully deleted.'
    end
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name)
  end
end
