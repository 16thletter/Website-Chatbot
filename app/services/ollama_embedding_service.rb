require "net/http"
require "uri"
require "json"

class OllamaEmbeddingService
  def self.embed(text)
    uri = URI("http://localhost:11434/api/embeddings")
    body = {
      model: "llama2", # or whichever embedding-capable model you're using
      prompt: text
    }.to_json

    response = Net::HTTP.post(uri, body, "Content-Type" => "application/json")

    unless response.is_a?(Net::HTTPSuccess)
      raise "Ollama embedding HTTP error: #{response.code} #{response.body}"
    end

    json = JSON.parse(response.body)
    json["embedding"]
  rescue JSON::ParserError => e
    raise "Failed to parse embedding output: #{e.message}"
  end
end
