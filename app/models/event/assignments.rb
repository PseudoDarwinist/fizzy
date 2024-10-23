module Event::Assignments
  extend ActiveSupport::Concern

  included do
    store_accessor :particulars, :assignee_names
  end
end
