module API
  module V1
    class CardsController < ApplicationController
      def show
        @card = Card.find(params[:id])

        render json: @card, meta: Hash
      end

      def index
        @cards = Card.all
        @filter = params.permit({ filter: %i[user_id shop_id], stats: :bonuses })
        if @filter[:filter].present?
          if @filter[:filter][:user_id].present?
            @cards = User.find_by(id: @filter[:filter][:user_id]).cards
          elsif @filter[:filter][:shop_id].present?
            @cards = Shop.find_by(id: @filter[:filter][:shop_id]).cards
          end
        end
        @cards = Card.all if @cards.nil?
        if @filter[:stats].present? && @filter[:stats][:bonuses] == 'sum'
          render json: @cards, meta: { stats: { bonuses: { sum: @cards.map(&:bonuses).sum }}}
          return
        end
        render json: @cards, meta: Hash
      end
    end
  end
end

