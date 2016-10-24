# Days of the week the applicant is available work
class AvailableDay < ActiveRecord::Base
  belongs_to :available_time
  enum day: %i(sunday monday tuesday wednesday thursday friday saturday)
end
