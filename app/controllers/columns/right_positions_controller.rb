class Columns::RightPositionsController < ApplicationController
  include ActionView::RecordIdentifier, ColumnScoped

  def create
    @right_column = @column.right_column
    @column.move_right
  end
end
