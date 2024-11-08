module Filter::Params
  extend ActiveSupport::Concern

  KNOWN_PARAMS = [ :indexed_by, :assignments, bucket_ids: [], assignee_ids: [], tag_ids: [] ]

  included do
    before_save { self.params_digest = hashed_params }
  end

  def as_params
    params = {}.tap do |h|
      h["tag_ids"]      = tags.ids
      h["bucket_ids"]   = buckets.ids
      h["assignee_ids"] = assignees.ids
      h["indexed_by"]   = indexed_by
      h["assignments"]  = assignments
    end

    params.compact_blank.reject { |k, v| default_fields[k] == v }
  end

  def to_params
    ActionController::Parameters.new(as_params).permit(*KNOWN_PARAMS).tap do |params|
      params[:filter_id] = id if persisted?
    end
  end

  def hashed_params
    Digest::MD5.hexdigest as_params.to_json
  end
end
