include ErrorSerializer

module API
  module V1
    class ShopsController < ApplicationController
      def show
        @shop = Shop.find(params[:id])

        render json: @shop, meta: Hash
      end

      def update
        @shop = Shop.find(params[:id])

        if @shop.update(shop_params)
          render json: @shop, meta: Hash
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
        render json: @shops, meta: Hash
      end

      def create
        @shop = Shop.new(shop_params)

        if @shop.save
          render json: @shop, status: :created, meta: Hash
        else
          respond_with_errors(@shop)
        end
      end

      def buy
        buy_params = JSON.parse(request.raw_post)
        @shop = Shop.find(params[:id])
        @user = User.find_by(id: buy_params['user_id'])
        errors = { success: false, errors: {} }
        errors[:errors][:user_id] = ['is required'] if @user.nil?
        case buy_params['amount']
        when nil
          errors[:errors][:amount] = ['is required']
        else
          errors[:errors][:amount] = ['must be greater than 0'] if buy_params['amount'].to_f <= 0
        end

        if errors[:errors].size.positive?
          render json: errors, status: 422
          return
        end
        Card.transaction do
          @card = Card.find_or_create_by(shop_id: @shop.id, user_id: @user.id)
          sum_cards = @user.cards.map(&:bonuses).sum
          amount = buy_params['amount'].to_f
          use_bonuses = ActiveModel::Type::Boolean.new.cast(buy_params['use_bonuses'])
          if @user.negative_balance
            if use_bonuses
              if @card.bonuses >= amount
                @remaining_bonus = @card.bonuses - to_int_if_whole(amount)
                amount_due = 0
              else
                if sum_cards >= amount
                  @remaining_bonus = @card.bonuses - to_int_if_whole(amount)
                  amount_due = 0
                else
                  @remaining_bonus = @card.bonuses - sum_cards
                  amount_due = amount - sum_cards
                end
              end
            elsif use_bonuses == false || use_bonuses == true && @card.bonuses == 0
              amount_due = amount
              @remaining_bonus = @card.bonuses + (amount / 100) unless amount < 100
            end
          else
            if use_bonuses && @card.bonuses != 0
              amount_due = (amount - @card.bonuses)
              if amount_due < 0
                amount_due = 0
                @remaining_bonus = (@card.bonuses - amount).round
              else
                @remaining_bonus = amount_due / 100
              end
            elsif use_bonuses == false || use_bonuses == true && @card.bonuses == 0
              amount_due = amount
              @remaining_bonus = @card.bonuses + (amount / 100) unless amount < 100
            end
          end
          @card.update(bonuses: @remaining_bonus.round) unless @remaining_bonus.nil?
          render json: { success: true, data: {amount_due: to_int_if_whole(amount_due), remaining_bonus: @card.bonuses } }
        end
      end

      private

      def shop_params
        JSON.parse(request.raw_post)['data']['attributes']
      end

      def to_int_if_whole(float)
        (float % 1 == 0) ? float.to_i : float
      end
    end
  end
end
