class PeopleController < ApplicationController
  before_action :set_person, only: [ :show, :edit, :update, :destroy, :restore ]

  def index
    @people = Person.active.includes(:current_articles).order(:first_name, :last_name)
  end

  def show
    @current_articles = @person.current_articles.includes(:transfers)
    @transfer_history = @person.transfer_history
    # Si la persona está eliminada, no mostrar artículos actuales (aunque existan por estados previos)
    @current_articles = [] if @person.deleted?
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to @person, notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @person.update(person_params)
      redirect_to @person, notice: "Person was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.soft_delete!
    redirect_to people_url, notice: "Person was successfully deleted."
  end

  def restore
    @person.restore!
    redirect_to @person, notice: "Person was successfully restored."
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name)
  end
end
