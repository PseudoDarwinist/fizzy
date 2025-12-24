module Search::Record::PostgreSQL
  extend ActiveSupport::Concern

  included do
    before_save :set_account_key, :stem_content

    scope :matching, ->(query, account_id) do
      q = Search::Query.wrap(query)
      ts_query = sanitize_sql_array(["plainto_tsquery('english', ?)", q.terms])
      where(account_id: account_id)
        .where("to_tsvector('english', coalesce(title,'') || ' ' || coalesce(content,'')) @@ #{ts_query}")
    end
  end

  class_methods do
    def search_fields(query)
      sanitize_sql_array(["?::text AS query", Search::Query.wrap(query).terms])
    end

    def for(account_id)
      self
    end
  end

  def card_title
    card&.title
  end

  def card_description
    comment ? nil : card&.description&.to_plain_text
  end

  def comment_body
    comment&.body&.to_plain_text
  end

  private
    def stem_content
      self.title = Search::Stemmer.stem(title) if respond_to?(:title_changed?) && title_changed?
      self.content = Search::Stemmer.stem(content) if respond_to?(:content_changed?) && content_changed?
    end

    def set_account_key
      self.account_key = "account#{account_id}" if respond_to?(:account_key=) && account_id
    end
end
