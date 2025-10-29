class Columns::LeftPositionsController < ApplicationController
  include ActionView::RecordIdentifier, ColumnScoped

  def create
    @left_column = @column.left_column
    @column.move_left
  end
end
