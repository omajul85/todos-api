class ItemsController < ApplicationController
  # GET /todos/:todo_id/items
  def index
    todo = Todo.find(params[:todo_id])

    json_response(todo.items)
  end

  # GET /todos/:todo_id/items/:id
  def show
    todo = Todo.find(params[:todo_id])

    @item = todo.items.find_by!(id: params[:id]) if todo

    json_response(@item)
  end

  # POST /todos/:todo_id/items
  def create
    todo = Todo.find(params[:todo_id])

    todo.items.create!(item_params)

    json_response(todo, :created)
  end

  # PUT /todos/:todo_id/items/:id
  def update
    todo = Todo.find(params[:todo_id])

    @item = todo.items.find_by!(id: params[:id]) if todo

    @item.update(item_params)

    head :no_content
  end

  # DELETE /todos/:todo_id/items/:id
  def destroy
    todo = Todo.find(params[:todo_id])

    @item = todo.items.find_by!(id: params[:id]) if todo

    @item.destroy

    head :no_content
  end

  private

  def item_params
    params.permit(:name, :done)
  end
end
