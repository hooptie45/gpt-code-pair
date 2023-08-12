class CommandsController < ApplicationController
  def execute
    command = params[:command]
    result = CommandParser.parse(command)
    render json: { result: result }
  end
end
