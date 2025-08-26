require 'rails_helper'

RSpec.describe Transfer, type: :model do
  let(:person1) { create(:person, first_name: 'Juan', last_name: 'Pérez') }
  let(:person2) { create(:person, first_name: 'María', last_name: 'González') }
  let(:article) { create(:article, current_person: person1) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      transfer = Transfer.new(
        article: article,
        from_person: person1,
        to_person: person2,
        transfer_date: Date.current
      )
      expect(transfer).to be_valid
    end

    it 'is not valid without an article' do
      transfer = Transfer.new(from_person: person1, to_person: person2, transfer_date: Date.current)
      expect(transfer).not_to be_valid
      expect(transfer.errors[:article_id]).to include("can't be blank")
    end

    it 'is not valid without a from_person' do
      transfer = Transfer.new(article: article, to_person: person2, transfer_date: Date.current)
      expect(transfer).not_to be_valid
      expect(transfer.errors[:from_person_id]).to include("can't be blank")
    end

    it 'is not valid without a to_person' do
      transfer = Transfer.new(article: article, from_person: person1, transfer_date: Date.current)
      expect(transfer).not_to be_valid
      expect(transfer.errors[:to_person_id]).to include("can't be blank")
    end

    it 'is not valid without a transfer_date' do
      transfer = Transfer.new(article: article, from_person: person1, to_person: person2)
      expect(transfer).not_to be_valid
      expect(transfer.errors[:transfer_date]).to include("can't be blank")
    end

    it 'is not valid when from_person and to_person are the same' do
      transfer = Transfer.new(
        article: article,
        from_person: person1,
        to_person: person1,
        transfer_date: Date.current
      )
      expect(transfer).not_to be_valid
      expect(transfer.errors[:to_person_id]).to include("cannot be the same as from person")
    end

    it 'is not valid when from_person is not the current carrier' do
      transfer = Transfer.new(
        article: article,
        from_person: person2, # person2 is not the current carrier
        to_person: person1,
        transfer_date: Date.current
      )
      expect(transfer).not_to be_valid
      expect(transfer.errors[:from_person_id]).to include("must be the current carrier of the article")
    end
  end

  describe 'associations' do
    let(:transfer) { create(:transfer, article: article, from_person: person1, to_person: person2) }

    it 'belongs to article' do
      expect(transfer).to respond_to(:article)
    end

    it 'belongs to from_person' do
      expect(transfer).to respond_to(:from_person)
    end

    it 'belongs to to_person' do
      expect(transfer).to respond_to(:to_person)
    end
  end

  describe 'callbacks' do
    describe 'after_create' do
      it 'updates the article current_person after transfer creation' do
        expect(article.current_person).to eq(person1)
        
        transfer = Transfer.create!(
          article: article,
          from_person: person1,
          to_person: person2,
          transfer_date: Date.current
        )
        
        article.reload
        expect(article.current_person).to eq(person2)
      end
    end
  end

  describe 'scopes' do
    let!(:old_transfer) { create(:transfer, article: article, from_person: person1, to_person: person2, transfer_date: 2.days.ago) }
    let!(:new_transfer) { create(:transfer, article: article, from_person: person2, to_person: person1, transfer_date: 1.day.ago) }

    describe '.recent' do
      it 'orders transfers by date descending' do
        expect(Transfer.recent.first).to eq(new_transfer)
        expect(Transfer.recent.last).to eq(old_transfer)
      end
    end
  end

  describe 'transfer workflow' do
    it 'successfully transfers an article between people' do
      # Initial state
      expect(article.current_person).to eq(person1)
      expect(person1.current_articles).to include(article)
      expect(person2.current_articles).not_to include(article)
      
      # Create transfer
      transfer = Transfer.create!(
        article: article,
        from_person: person1,
        to_person: person2,
        transfer_date: Date.current,
        notes: 'Test transfer'
      )
      
      # Reload to get updated associations
      article.reload
      person1.reload
      person2.reload
      
      # Final state
      expect(article.current_person).to eq(person2)
      expect(person1.current_articles).not_to include(article)
      expect(person2.current_articles).to include(article)
      expect(transfer.notes).to eq('Test transfer')
    end

    it 'maintains transfer history' do
      person3 = create(:person, first_name: 'Carlos', last_name: 'Rodríguez')
      
      # First transfer: person1 -> person2
      transfer1 = Transfer.create!(
        article: article,
        from_person: person1,
        to_person: person2,
        transfer_date: 2.days.ago
      )
      
      article.reload
      
      # Second transfer: person2 -> person3
      transfer2 = Transfer.create!(
        article: article,
        from_person: person2,
        to_person: person3,
        transfer_date: 1.day.ago
      )
      
      # Check transfer history
      history = article.transfer_history
      expect(history).to include(transfer1, transfer2)
      expect(history.first).to eq(transfer2) # Most recent first
      
      # Check final state
      article.reload
      expect(article.current_person).to eq(person3)
    end
  end
end
