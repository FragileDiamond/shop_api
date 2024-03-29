module API
  module V1
    class UsersController < ApplicationController
      def show
        @user = User.find(params[:id])

        render json: @user, meta: Hash
      end

      def update
        @user = User.find(params[:id])

        if @user.update(user_params)
          render json: @user
        else
          respond_with_errors(@user)
        end
      end

      def index
        @users = User.all

        @filter = params.permit({ filter: %i[shop_id card_id] })
        if @filter[:filter].present?
          if @filter[:filter][:shop_id].present?
            @users = User.includes(:shops).where(shops: {id: @filter[:filter][:shop_id]})
          elsif @filter[:filter][:card_id].present?
            @users = User.includes(:cards).where(cards: {id: @filter[:filter][:card_id]})
          end
        end
        render json: @users, meta: Hash
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created
        else
          respond_with_errors(@user)
        end
      end

      private

      def user_params
        JSON.parse(request.raw_post)['data']['attributes']
      end
    end
  end
end
