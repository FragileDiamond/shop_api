module API
  module V1
    class UsersController < ApplicationController
      def show
        @user = User.find(params[:id])

        render json: @user
      end

      def update
        @user = User.find(params[:id])

        if @user.update(user_params)
          render json: @user
        else
          render json: {name: "Error"}
        end
      end

      def index
        @users = User.all

        render json: @users
      end

      def create
        @user = User.new(user_params)

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
