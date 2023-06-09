class Contact < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :phone, presence: true, :phone_number => {:ten_digits => true}

    def full_name
        [first_name, last_name].join(' ')
    end
end
