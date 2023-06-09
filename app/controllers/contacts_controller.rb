class ContactsController < ApplicationController
    before_action :find_contact, only: [:edit, :update, :destroy]

    def index
        @contacts = Contact.search_by_last_name(params[:search])
    end

    def new
        @contact = Contact.new
    end

    def create
        @contact = Contact.new(contact_params)

        if @contact.save
            flash[:success] = "New contact created!"
            redirect_to contacts_path
        else
            render 'new', status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @contact.update(contact_params)
            flash[:success] = "Contact updated!"
            redirect_to contacts_path
        else
            render 'edit', status: :unprocessable_entity
        end
    end

    def destroy
        @contact.destroy
        flash[:success] = "Contact deleted!"
        redirect_to contacts_path
    end

    private

    def contact_params
        params.require(:contact).permit(:first_name, :last_name, :phone)
    end

    def find_contact
        @contact ||= Contact.find(params[:id])
    end
end
