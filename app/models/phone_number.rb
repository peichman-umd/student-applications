class PhoneNumber < ActiveRecord::Base
  belongs_to :prospect
  validates :prospect, presence: true

  validates :number, presence: true, if: ->(a) { a.prospect && a.prospect.current_step == 'contact_info' }

  enum phone_type: %i(local cell other)
end
