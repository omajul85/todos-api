class TodosController < ApplicationController
  # GET /todos
  def index
    @todos = current_user.todos

    json_response(@todos)
  end

  # POST /todos
  # Note that we're using create! instead of create. The model will raise an exception
  # ActiveRecord::RecordInvalid if is not valid. This way, we can avoid deep nested if statements in the controller.
  # Thus, we rescue from this exception in the ExceptionHandler module.
  def create
    @todo = current_user.todos.create!(todo_params)

    json_response(@todo, :created)
  end

  # GET /todos/:id
  def show
    @todo = current_user.todos.find(params[:id])

    json_response(@todo)
  end

  # PUT /todos/:id
  def update
    @todo = current_user.todos.find(params[:id])

    @todo.update(todo_params)

    head :no_content
  end

  # DELETE /todos/:id
  def destroy
    @todo = current_user.todos.find(params[:id])

    @todo.destroy

    head :no_content
  end

  private

  def todo_params
    # whitelist params
    params.permit(:title)
  end
end
