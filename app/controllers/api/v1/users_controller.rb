module API
  module V1
    class UsersController < ApplicationController
      def show
        @user = User.find(params[:id])

        render json: @user
      end

      def update
        @user = User.find(params[:id])

        if @user.update(shop_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def index
        @users = User.all

        render json: @users
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        JSON.parse(request.raw_post)['data']['attributes']
      end
    end
  end
end
