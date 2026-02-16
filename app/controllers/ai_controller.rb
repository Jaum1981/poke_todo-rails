class AiController < ApplicationController
  def ask
    task = Task.find(params[:task_id])
    question = params[:question]
    answer = RotomBrain.ask(task, question)
    
    render json: { answer: answer }
  rescue ActiveRecord::RecordNotFound
    render json: { answer: "Bzzzt! Erro: Tarefa não encontrada no banco de dados." }, status: 404
  rescue => e
    render json: { answer: "Bzzzt! Erro crítico no sistema: #{e.message}" }, status: 500
  end
end