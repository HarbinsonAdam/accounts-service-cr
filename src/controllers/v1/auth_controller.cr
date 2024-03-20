class AuthController < AccountsService::BaseController
  base "/api/v1/auth"

  @[AC::Route::POST("/login", body: :payload)]
  def login

  end

  @[AC::Route::POST("/refresh", body: :payload)]
  def login

  end

  @[AC::Route::DELETE("/logout")]
  def delete

  end
end