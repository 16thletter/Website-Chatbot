class WebScraper
  def initialize(url)
    @url = url
  end

  def extract_text
    response = HTTParty.get(@url)
    doc = Nokogiri::HTML(response.body)
    content_node = doc.at("main") || doc.at("article") || doc.at("body")
    return [] unless content_node

    content_node.search("script, style, nav, footer, header, aside").remove

    chunks = []
    current_chunk = ""
    content_node.children.each do |node|
      if node.name =~ /^h[1-3]$/
        chunks << current_chunk unless current_chunk.empty?
        current_chunk = "#{node.text}\n"
      elsif node.name == "p"
        current_chunk << "#{node.text}\n"
      end
    end
    chunks << current_chunk unless current_chunk.empty?
    chunks.map(&:strip)
  end
end
