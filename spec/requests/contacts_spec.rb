require 'rails_helper'

RSpec.describe 'Contacts CRUD', type: :request do
    describe '#index' do      
        let!(:contact) { FactoryBot.create :contact }
        let!(:contact_1) { FactoryBot.create :contact, last_name: "Johnson" }
        let(:query) { 'John' }
        subject { get '/contacts/', params: params }

        let(:params) { { search: query } }

        it 'searches for records' do
            expect(Contact).to receive(:search_by_last_name).with(query).and_call_original
            subject
            expect(response).to render_template("index")
        end

        context 'when seach param blank' do
            let(:query)      { '' }

            it 'renders all records' do
                expect(Contact).to receive(:search_by_last_name).with(query).and_call_original
                subject
                expect(response).to render_template("index")
            end
        end
    end
    describe '#create' do        
        subject { post '/contacts', params: params }

        let(:params) do
            { 
                contact: {
                    first_name: first_name,
                    last_name: last_name,
                    phone: phone
                }
            }
        end
        let(:first_name) { 'John' }
        let(:last_name)  { 'Doe' }
        let(:phone)      { '111-111-1111' }

        it 'creates a record and redirects to index', :aggregate_errors do
            expect { subject }.to change { Contact.all.size }.from(0).to(1)
            expect(Contact.last.first_name).to eq(first_name)
            expect(Contact.last.last_name).to eq(last_name)
            expect(Contact.last.phone).to eq(phone)

            response.should redirect_to '/contacts'
        end

        context 'when params incorrect' do
            let(:phone)      { '1' }

            it 'does not add a new record', :aggregate_errors do
                expect { subject }.to_not change { Contact.all.size }
                expect(response).to render_template("new")
            end
        end
    end

    describe '#update' do      
        let!(:contact) { FactoryBot.create :contact }

        subject { patch '/contacts/' + contact.id.to_s, params: params }

        let(:params) do
            { 
                contact: {
                    first_name: first_name,
                    last_name: last_name,
                    phone: phone
                }
            }
        end
        let(:first_name) { 'John' }
        let(:last_name)  { 'Doe' }
        let(:phone)      { '111-111-1111' }

        it 'updates a record and redirects to index', :aggregate_errors do
            subject

            expect(contact.reload.first_name).to eq(first_name)
            expect(contact.reload.last_name).to eq(last_name)
            expect(contact.reload.phone).to eq(phone)

            response.should redirect_to '/contacts'
        end

        context 'when params incorrect' do
            let(:phone)      { '1' }

            it 'does not add a new record', :aggregate_errors do
                subject

                expect { subject }.to_not change { contact.reload.first_name }
                expect { subject }.to_not change { contact.reload.last_name }
                expect { subject }.to_not change { contact.reload.phone }
                expect(response).to render_template("edit")
            end
        end
    end

    describe '#destroy' do
        let!(:contact) { FactoryBot.create :contact }

        subject { delete '/contacts/' + contact.id.to_s }

        it 'deletes a requested record' do
            expect { subject }.to change { Contact.all.size }.from(1).to(0)
            expect { Contact.find(contact.id)}.to raise_error(ActiveRecord::RecordNotFound)
            response.should redirect_to '/contacts'
        end
    end
end