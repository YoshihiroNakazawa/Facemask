class Topic < ActiveRecord::Base
  validates :title, presence: true
  # new -> confirm
  validates :submited, acceptance: true
  # confirm -> create
  validates :confirmed, acceptance: true

  after_validation :confirming

  private
    def confirming
      if self.submited == ""
        self.submited = errors.include?(:submited) && errors.size == 1 ? "1" : ""
      end
      if self.confirmed == ""
        self.submited  = nil
        self.confirmed = nil
      end
      clear_confirming_errors
    end

    def clear_confirming_errors
      errors.delete :submited
      errors.delete :confirmed
    end
end
