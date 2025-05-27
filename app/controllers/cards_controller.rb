# app/controllers/cards_controller.rb
class CardsController < ApplicationController
  def sort
    card = Card.find(params[:id])
    card.update(board_id: params[:board_id], position: params[:position])

    # Reorder all cards in the target board
    params[:card_ids].each_with_index do |id, index|
      Card.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end
end
