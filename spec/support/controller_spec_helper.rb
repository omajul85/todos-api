module ControllerSpecHelper
  def token_generator(user_id, expired: false)
    unless expired
      JsonWebToken.encode(user_id: user_id)
    else
      JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
    end
  end

  # return valid headers
  def valid_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json"
    }
  end

  # return invalid headers
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json"
    }
  end
end
