class WebScraper
  def initialize(url)
    @url = url
  end

  def extract_text
    response = HTTParty.get(@url)
    doc = Nokogiri::HTML(response.body)
    doc.search("script, style, nav, footer, header").remove
    doc.css("p,h1,h2,h3").map(&:text).join("\n")
  rescue => e
    Rails.logger.error("Scraping failed: #{e}")
    nil
  end
end
