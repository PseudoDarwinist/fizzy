module Mentions
  extend ActiveSupport::Concern

  included do
    has_many :mentions, as: :container, dependent: :destroy
    after_commit :collect_mentions_later, on: %i[ create update ]
  end

  def collect_mentions(mentioner: Current.user)
    scan_mentionees.each do |mentionee|
      mentionee.mentioned_by mentioner, at: self
    end
  end

  def mentionable_content
    self.class.reflect_on_all_associations(:has_one).filter { it.klass == ActionText::Markdown }.collect do |association|
      send(association.name).to_plain_text
    end.join(" ")
  end

  private
    def collect_mentions_later
      Mention::CollectJob.perform_later(self, mentioner: Current.user)
    end

    def scan_mentionees
      scan_mentioned_handles.filter_map do |mention|
        mentionable_users.find { |user| user.mentionable_handles.include?(mention) }
      end
    end

    def mentionable_users
      collection.users
    end

    def scan_mentioned_handles
      (mentionable_content || "").scan(/(?<!\w)@(\w+)/).flatten.uniq(&:downcase)
    end
end
