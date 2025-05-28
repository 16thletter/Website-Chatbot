class WebScraper
  USER_AGENT = "Mozilla/5.0 (compatible; WebScraperBot/1.0)"

  def initialize(url, website_id:)
    @url = url
    @website = Website.find(website_id)
  end

  def extract_and_save_chunks
    response = HTTParty.get(@url, headers: { "User-Agent" => USER_AGENT })

    return unless response.success?

    doc = Nokogiri::HTML(response.body)

    # Try specific tags first
    content_node = doc.at("main") || doc.at("article") || doc.at("body")

    # Heuristic fallback if none found
    unless content_node
      content_node = find_largest_content_block(doc)
      return unless content_node
    end

    # Remove common unwanted elements
    content_node.search("script, style, nav, footer, header, aside, noscript").remove

    heading = nil
    buffer = []

    content_node.xpath(".//*").each do |node|
      next if node.text.strip.blank?

      if node.name =~ /^h[1-3]$/
        save_chunk(heading, buffer) if heading && buffer.any?
        heading = node.text.strip
        buffer = []
      elsif node.name.in?(%w[p li pre code blockquote span div])
        text = node.text.strip
        buffer << text unless text.blank?
      end
    end

    save_chunk(heading, buffer) if heading && buffer.any?
  end

  private

  def find_largest_content_block(doc)
    candidates = doc.search("div, section, article").reject { |node| node.text.strip.blank? }
    candidates.max_by { |node| node.text.strip.length }
  end

  def save_chunk(heading, buffer)
    content = buffer.join("\n").squish
    return if content.blank?

    words = content.split
    max_words = 200
    overlap = 50
    step = max_words - overlap

    words.each_slice(step).with_index do |slice, index|
      chunk_words = words[index * step, max_words] || []
      chunk_text = chunk_words.join(" ")
      next if chunk_text.blank?

      embedding = OllamaEmbeddingService.embed(chunk_text)

      PageChunk.create!(
        website: @website,
        heading: heading,
        content: chunk_text,
        embedding: embedding
      )
    end
  rescue => e
    Rails.logger.error("Failed to save chunk: #{e.message}")
  end
end
