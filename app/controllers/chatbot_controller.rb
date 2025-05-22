class ChatbotController < ApplicationController
  before_action :store_question, only: :ask
  def show
    @website = Website.find(params[:id])
  end

  def ask
    context = website.generate_context(params[:question])
    @answer = ChatbotService.new(context, @question).call

    flash.now[:alert] = "LLM server error or no answer." if @answer.blank?

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to chatbot_path(website) }
    end
  end

  private

  def store_question
    @question = website.questions.create!(title: params[:question])
  end

  def website
    @website ||= Website.includes(questions: :answer).find(params[:id])
  end
end
