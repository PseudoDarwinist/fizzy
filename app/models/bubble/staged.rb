module Bubble::Staged
  extend ActiveSupport::Concern

  included do
    belongs_to :stage, class_name: "Workflow::Stage", optional: true
  end

  def workflow
    stage&.workflow
  end

  def toggle_stage(stage)
    if self.stage_id == stage.id
      transaction do
        update! stage: nil
        track_event :unstaged, stage_name: stage.name
      end
    else
      transaction do
        update! stage: stage
        track_event :staged, stage_name: stage.name
      end
    end
  end
end
