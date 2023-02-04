module API
  module V1
    class CardsController < ApplicationController
      def show
        @card = Card.find(params[:id])

        render json: @card
      end

      def index
        @cards = Card.all

        render json: @cards
      end
    end
  end
end

