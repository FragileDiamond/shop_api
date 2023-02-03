module API
  module V1
    class ShopsController < ApplicationController
      def show
        @shop = Shop.find(params[:id])

        render json: @shop
      end

      def update
        @shop = Shop.find(params[:id])

        if @shop.update(shop_params)
          render json: @shop
        else
          render json: {name: "Error"}
        end
      end

      def index
        @shops = Shop.all

        render json: @shops
      end

      def create
        @shop = Shop.new(shop_params)

        if @shop.save
          render json: @shop
        else
          render json: {name: "Error"}
        end
      end

      private

      def shop_params
        params.permit(:name)
      end
    end
  end
end
