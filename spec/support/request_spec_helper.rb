module RequestSpecHelper
  # Parse json response to ruby Hash
  def json
    JSON.parse(response.body)
  end
end
