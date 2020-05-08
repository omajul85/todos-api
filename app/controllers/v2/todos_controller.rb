module V2
  class TodosController < ApplicationController
    def index
      json_response( { message: 'Hello from V2' } )
    end
  end
end
