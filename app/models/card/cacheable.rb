module Card::Cacheable
  extend ActiveSupport::Concern

  def cache_invalidation_parts
    @cache_invalidation_parts ||= InvalidationParts.new(self)
  end

  class InvalidationParts
    attr_reader :card

    def initialize(card)
      @card = card
    end

    def for_perma(*other)
      [ card, Workflow.all, User.all, Tag.all, *other ]
    end

    def for_preview(*other)
      [ card, card.workflow, card.collection.entropy_configuration, card.collection.publication, *other ]
    end
  end
end
