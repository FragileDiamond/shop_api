module API
  module V1
    class CardsController < ApplicationController
      def show
        @card = Card.find(params[:id])

        render json: @card
      end

      def index
        @cards = Card.all
        @filter = params.permit({ filter: %i[user_id shop_id] })
        if @filter[:filter].present?
          if @filter[:filter][:user_id].present?
            @cards = User.find_by(id: @filter[:filter][:user_id]).cards
          elsif @filter[:filter][:shop_id].present?
            @cards = Shop.find_by(id: @filter[:filter][:shop_id]).cards
          end
        end
        render json: @cards
      end
    end
  end
end

