class UsersController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
# before_action :authorize, only: :show    

def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
          render json: user
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
      end



    private

    def record_invalid(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def authorize
        render json: { error: "Not authorized"}, status: :unauthorized
    end

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end
end
