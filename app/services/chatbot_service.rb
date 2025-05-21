class ChatbotService
  def initialize(context, question)
    @prompt = PromptBuilder.build(context, question)
    @url = ENV.fetch("LLAMA_RESPONSE_GENERATE_API", "http://localhost:11434/api/generate")
  end

  def call
    response = HTTParty.post(@url, headers:, body:)

    if response.success?
      response.parsed_response["response"]
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
    { model: "llama2", prompt: @prompt, stream: false }.to_json
  end
end
