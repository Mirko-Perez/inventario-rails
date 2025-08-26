require 'rails_helper'

RSpec.describe Person, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      person = Person.new(first_name: 'Juan', last_name: 'Pérez')
      expect(person).to be_valid
    end

    it 'is not valid without a first_name' do
      person = Person.new(last_name: 'Pérez')
      expect(person).not_to be_valid
      expect(person.errors[:first_name]).to include("can't be blank")
    end

    it 'is not valid without a last_name' do
      person = Person.new(first_name: 'Juan')
      expect(person).not_to be_valid
      expect(person.errors[:last_name]).to include("can't be blank")
    end

    it 'is not valid with first_name too short' do
      person = Person.new(first_name: 'J', last_name: 'Pérez')
      expect(person).not_to be_valid
      expect(person.errors[:first_name]).to include('is too short (minimum is 2 characters)')
    end

    it 'is not valid with last_name too short' do
      person = Person.new(first_name: 'Juan', last_name: 'P')
      expect(person).not_to be_valid
      expect(person.errors[:last_name]).to include('is too short (minimum is 2 characters)')
    end
  end

  describe 'associations' do
    let(:person) { create(:person) }

    it 'has many current_articles' do
      expect(person).to respond_to(:current_articles)
    end

    it 'has many transfers_from' do
      expect(person).to respond_to(:transfers_from)
    end

    it 'has many transfers_to' do
      expect(person).to respond_to(:transfers_to)
    end
  end

  describe '#full_name' do
    it 'returns the full name' do
      person = Person.new(first_name: 'Juan', last_name: 'Pérez')
      expect(person.full_name).to eq('Juan Pérez')
    end
  end

  describe '#transfer_history' do
    let(:person1) { create(:person, first_name: 'Juan', last_name: 'Pérez') }
    let(:person2) { create(:person, first_name: 'María', last_name: 'González') }
    let(:article) { create(:article, current_person: person1) }

    it 'returns transfers involving the person' do
      transfer = create(:transfer, article: article, from_person: person1, to_person: person2)
      
      expect(person1.transfer_history).to include(transfer)
      expect(person2.transfer_history).to include(transfer)
    end

    it 'orders transfers by date descending' do
      transfer1 = create(:transfer, article: article, from_person: person1, to_person: person2, transfer_date: 1.day.ago)
      transfer2 = create(:transfer, article: article, from_person: person2, to_person: person1, transfer_date: 2.days.ago)
      
      expect(person1.transfer_history.first).to eq(transfer1)
    end
  end
end
