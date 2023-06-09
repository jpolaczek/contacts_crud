class Contact < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :phone, presence: true, :phone_number => {:ten_digits => true}

    scope :by_last_name, ->(search) { where("last_name LIKE ?", "%#{search}%") }

    def full_name
        [first_name, last_name].join(' ')
    end

    def self.search_by_last_name(search)
        if search.blank?
            self.all
        else
            self.by_last_name(search)
        end
    end
end
