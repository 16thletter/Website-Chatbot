class ChatbotController < ApplicationController
  def show
    @website = Website.find(params[:id])
  end

  def ask
    @website = Website.find(params[:id])
    @question = params[:question]

    context = @website.generate_context(params[:question])
    @answer = ChatbotService.new(context, params[:question]).call

    flash.now[:alert] = "LLM server error or no answer." if @answer.blank?

    render :show
  end
end
