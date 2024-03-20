class AccountsController < AccountsService::BaseController
  base "/api/v1/accounts"

  @[AC::Route::GET("/")]
  def index
    users = User.all

    render json: users
  end

  @[AC::Route::GET("/:account_id")]
  def show(account_id : Int64)
    user = User.find! account_id

    render json: user
  end

  @[AC::Route::POST("/", body: :payload)]
  def create(payload : AccountsService::V1::AccountPayload)
    user = User.create!(
      first_name: payload.first_name,
      last_name: payload.last_name,
      dob: payload.dob,
      password: payload.password,
      email: payload.email
    )

    render json: user
  end

  @[AC::Route::PATCH("/:account_id", body: :payload)]
  def update(account_id : Int64, payload : AccountsService::V1::AccountPayload)
    user = User.find! account_id

    updated_user = user.update!(
      first_name: payload.first_name,
      last_name: payload.last_name,
      dob: payload.dob,
      password: payload.password,
      email: payload.email
    )

    render json: updated_user
  end

  @[AC::Route::DELETE("/:account_id")]
  def delete(account_id : Int64)
    user = User.find! account_id
    user.destroy!

    render status: 200
  end
end