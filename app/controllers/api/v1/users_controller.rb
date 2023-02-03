module API
  module V1
    class UsersController < ApplicationController
      def show
        @user = user.find(params[:id])

        render json: @user
      end

      def update
        @user = user.find(params[:id])

        if @user.update(user_params)
          render json: @user
        else
          render json: {name: "Error"}
        end
      end

      def index
        @users = user.all

        render json: @users
      end

      def create
        @user = user.new(user_params)

        if @user.save
          render json: @user
        else
          render json: {name: "Error"}
        end
      end

      private

      def user_params
        params.permit(:email, :negative_balance)
      end
    end
  end
end
