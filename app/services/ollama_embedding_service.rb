class OllamaEmbeddingService
  def self.embed(text)
    response = HTTParty.post("http://localhost:5001/embed",
      headers: { "Content-Type" => "application/json" },
      body: { text: text }.to_json
    )

    unless response.success?
      raise "Ollama embedding HTTP error: #{response.code} #{response.body}"
    end

    normalize_vector(response.parsed_response["embedding"])

  rescue JSON::ParserError => e
    raise "Failed to parse embedding output: #{e.message}"
  end

  def self.normalize_vector(embedding)
    norm = Math.sqrt(vec.sum { |x| x**2 })
    norm.zero? ? vec : vec.map { |x| x / norm }
  end
end
