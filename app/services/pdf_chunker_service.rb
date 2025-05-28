# app/services/pdf_chunker_service.rb
class PdfChunkerService
  def initialize(file_path)
    @file_path = file_path
  end

  def extract_chunks
    output = `/Users/developer/embedding-env/bin/python3 script/pdf_chunker.py "#{@file_path}"`
    chunks = JSON.parse(output, symbolize_names: true)

    chunks.map do |chunk|
      {
        heading:      chunk[:heading],
        content:      chunk[:content],
        page:         chunk[:page],
        chunk_index:  chunk[:chunk_index]
      }
    end
  end
end
