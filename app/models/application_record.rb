class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  connects_to database: { writing: :primary, reading: :replica }

  attribute :id, :uuid, default: -> { ActiveRecord::Type::Uuid.generate }
end
