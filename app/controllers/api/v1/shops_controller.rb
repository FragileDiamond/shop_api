include ErrorSerializer

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
          respond_with_errors(@shop)
        end
      end

      def index
        @shops = Shop.all
        @filter = params.permit({ filter: %i[user_id card_id] })
        if @filter[:filter].present?
          if @filter[:filter][:user_id].present?
            @shops = Shop.includes(:users).where(users: {id: @filter[:filter][:user_id]})
          elsif @filter[:filter][:card_id].present?
            @shops = Shop.includes(:cards).where(cards: {id: @filter[:filter][:card_id]})
          end
        end
        render json: @shops
      end

      def create
        @shop = Shop.new(shop_params)

        if @shop.save
          render json: @shop, status: :created
        else
          respond_with_errors(@shop)
        end
      end

      def buy
        buy_params = JSON.parse(request.raw_post)
        @shop = Shop.find(params[:id])
        @user = User.find_by(id: buy_params['user_id'])
        @card = Card.find_or_create_by(shop_id: @shop.id, user_id: @user.id)
        amount = buy_params['amount'].to_f.round
        use_bonuses = ActiveModel::Type::Boolean.new.cast(buy_params['use_bonuses'])
        if @user.negative_balance
          sum_cards = @user.cards.map(&:bonuses).sum
          if use_bonuses
            amount_due = (amount - sum_cards)
            if amount_due < 0
              amount_due = 0
              @remaining_bonus = (sum_cards - amount)
            else
              @remaining_bonus = 0
            end
          else
            amount_due = amount
            @remaining_bonus = @card.bonuses + (amount / 100) unless amount < 100
          end
        else
          if use_bonuses
            amount_due = (amount - @card.bonuses)
            if amount_due < 0
              amount_due = 0
              @remaining_bonus = (@card.bonuses - amount)
            else
              @remaining_bonus = 0
            end
          else
            amount_due = amount
            @remaining_bonus = @card.bonuses + (amount / 100) unless amount < 100
          end
        end
        @card.update(bonuses: @remaining_bonus.round) unless @remaining_bonus.nil?
        render json: { success: true, data: {amount_due: amount_due, remaining_bonus: @card.bonuses } }
      end

      private

      def shop_params
        JSON.parse(request.raw_post)['data']['attributes']
      end
    end
  end
end
