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
end