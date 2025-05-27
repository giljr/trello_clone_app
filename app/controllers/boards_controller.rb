# app/controllers/boards_controller.rb
class BoardsController < ApplicationController
  def show
    @boards = Board.order(:position)
  end

  def sort
    # For board sorting (if you want to reorder columns)
    params[:board].each_with_index do |id, index|
      Board.where(id: id).update_all(position: index + 1)
    end
    head :ok
  end
end
