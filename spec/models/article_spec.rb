require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validations' do
    let(:person) { create(:person) }

    it 'is valid with valid attributes' do
      article = Article.new(
        brand: 'Dell',
        model: 'Latitude 5520',
        entry_date: Date.current,
        current_person: person
      )
      expect(article).to be_valid
    end

    it 'is not valid without a brand' do
      article = Article.new(model: 'Latitude 5520', entry_date: Date.current, current_person: person)
      expect(article).not_to be_valid
      expect(article.errors[:brand]).to include("can't be blank")
    end

    it 'is not valid without a model' do
      article = Article.new(brand: 'Dell', entry_date: Date.current, current_person: person)
      expect(article).not_to be_valid
      expect(article.errors[:model]).to include("can't be blank")
    end

    it 'is not valid without an entry_date' do
      article = Article.new(brand: 'Dell', model: 'Latitude 5520', current_person: person)
      expect(article).not_to be_valid
      expect(article.errors[:entry_date]).to include("can't be blank")
    end

    it 'is not valid without a current_person' do
      article = Article.new(brand: 'Dell', model: 'Latitude 5520', entry_date: Date.current)
      expect(article).not_to be_valid
      expect(article.errors[:current_person_id]).to include("can't be blank")
    end

    it 'is not valid with brand too short' do
      article = Article.new(brand: 'D', model: 'Latitude 5520', entry_date: Date.current, current_person: person)
      expect(article).not_to be_valid
      expect(article.errors[:brand]).to include('is too short (minimum is 2 characters)')
    end

    it 'is not valid with model too short' do
      article = Article.new(brand: 'Dell', model: 'L', entry_date: Date.current, current_person: person)
      expect(article).not_to be_valid
      expect(article.errors[:model]).to include('is too short (minimum is 2 characters)')
    end
  end

  describe 'associations' do
    let(:article) { create(:article) }

    it 'belongs to current_person' do
      expect(article).to respond_to(:current_person)
    end

    it 'has many transfers' do
      expect(article).to respond_to(:transfers)
    end
  end

  describe 'scopes' do
    let(:person) { create(:person) }
    let!(:dell_article) { create(:article, brand: 'Dell', model: 'Latitude', current_person: person) }
    let!(:hp_article) { create(:article, brand: 'HP', model: 'EliteBook', current_person: person) }

    describe '.by_brand' do
      it 'filters articles by brand' do
        expect(Article.by_brand('Dell')).to include(dell_article)
        expect(Article.by_brand('Dell')).not_to include(hp_article)
      end

      it 'returns all articles when brand is blank' do
        expect(Article.by_brand('')).to include(dell_article, hp_article)
      end
    end

    describe '.by_model' do
      it 'filters articles by model (case insensitive)' do
        expect(Article.by_model('latitude')).to include(dell_article)
        expect(Article.by_model('latitude')).not_to include(hp_article)
      end

      it 'returns all articles when model is blank' do
        expect(Article.by_model('')).to include(dell_article, hp_article)
      end
    end

    describe '.by_entry_date' do
      let!(:old_article) { create(:article, entry_date: 1.year.ago, current_person: person) }
      let!(:new_article) { create(:article, entry_date: Date.current, current_person: person) }

      it 'filters articles by entry date' do
        expect(Article.by_entry_date(Date.current)).to include(new_article)
        expect(Article.by_entry_date(Date.current)).not_to include(old_article)
      end
    end
  end

  describe '#transfer_history' do
    let(:person1) { create(:person) }
    let(:person2) { create(:person) }
    let(:article) { create(:article, current_person: person1) }

    it 'returns transfers for the article ordered by date' do
      transfer1 = create(:transfer, article: article, from_person: person1, to_person: person2, transfer_date: 2.days.ago)
      transfer2 = create(:transfer, article: article, from_person: person2, to_person: person1, transfer_date: 1.day.ago)
      
      expect(article.transfer_history.first).to eq(transfer2)
      expect(article.transfer_history.last).to eq(transfer1)
    end
  end

  describe '#previous_carriers' do
    let(:person1) { create(:person) }
    let(:person2) { create(:person) }
    let(:person3) { create(:person) }
    let(:article) { create(:article, current_person: person3) }

    it 'returns unique previous carriers' do
      create(:transfer, article: article, from_person: person1, to_person: person2)
      create(:transfer, article: article, from_person: person2, to_person: person3)
      
      expect(article.previous_carriers).to include(person1, person2)
      expect(article.previous_carriers).not_to include(person3)
    end
  end
end
