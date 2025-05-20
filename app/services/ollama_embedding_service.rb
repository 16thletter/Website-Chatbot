class OllamaEmbeddingService
  def self.embed(text)
    response = HTTParty.post("http://localhost:5001/embed",
      headers: { "Content-Type" => "application/json" },
      body: { text: text }.to_json
    )

    unless response.success?
      raise "Ollama embedding HTTP error: #{response.code} #{response.body}"
    end

    response.parsed_response["embedding"]

  rescue JSON::ParserError => e
    raise "Failed to parse embedding output: #{e.message}"
  end
end
