require 'rails_helper'

RSpec.describe Contact, type: :model do
    let(:contact) { FactoryBot.build :contact }

    describe 'validations' do        
        it { should validate_presence_of :first_name }
        it { should validate_presence_of :last_name }
        it { should validate_presence_of :phone }
        it { expect(contact).to be_valid }

        context 'when phone does not have 10 digits' do
            let(:contact) { FactoryBot.build :contact, phone: '123-123-123' }

            it { expect(contact).to_not be_valid }
        end
    end

    describe '#full_name' do
        subject { contact.full_name }

        it { is_expected.to eq contact.first_name + ' ' + contact.last_name }
    end

    describe '.search_by_last_name' do
        subject { described_class.search_by_last_name(search) }

        let(:search) { 'John' }
        let(:last_name) { 'Johnson' }
        let!(:contact) { FactoryBot.create :contact, last_name: last_name }
        let!(:contact_2) { FactoryBot.create :contact }

        it { is_expected.to eq([contact]) }

        context 'when search blank' do
            let(:search) { '' }

            it { is_expected.to eq Contact.all }
        end
    end
end