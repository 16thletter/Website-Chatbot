require "json"

namespace :pdf do
  desc "Embed and store chunks from a sample PDF file"
  task embed_chunks: :environment do
    pdf_path = Rails.root.join("public/pdfs/sample_policy.pdf")
    puts "📄 Reading PDF: #{pdf_path}"

    website = Website.find_by!(url: "www.example.com")

    chunks = PdfChunkerService.new(pdf_path).extract_chunks
    puts "📦 Total chunks: #{chunks.size}"

    chunks.each_with_index do |chunk, i|
      print "🔢 Embedding chunk #{i + 1}/#{chunks.size}... "

      embedding = generate_embedding(chunk[:content])
      embedding = normalize_vector(embedding)

      PageChunk.create!(
        website:     website,
        content:     chunk[:content],
        heading:     chunk[:heading],
        page:        chunk[:page],
        chunk_index: chunk[:chunk_index],
        embedding:   embedding
      )

      puts "✓"
    end

    puts "✅ Done embedding #{chunks.size} chunks."
  end

  def generate_embedding(text)
    OllamaEmbeddingService.embed(text)
  end

  def normalize_vector(vec)
    norm = Math.sqrt(vec.sum { |x| x**2 })
    norm.zero? ? vec : vec.map { |x| x / norm }
  end
end
