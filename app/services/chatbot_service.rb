class ChatbotService
  def initialize(context, question)
    @question = question
    @prompt = PromptBuilder.build(context, question.title)
    @url = "http://localhost:11434/api/generate"
  end

  def call
    response = HTTParty.post(@url, headers:, body:)

    if response.success?
      @question.create_answer(content: response.parsed_response["response"])
    else
      raise "Error: #{response.code} - #{response.message}"
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  private

  def headers
    { "Content-Type" => "application/json" }
  end

  def body
    { model: "mistral", prompt: @prompt, stream: false, temperature: 0.3 }.to_json
  end
end
