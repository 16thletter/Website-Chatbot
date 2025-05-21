class PromptBuilder
  def self.build(context, question)
    return "Answer this programming question clearly and concisely:\n#{question}" if context.blank?

    <<~PROMPT
      Answer the following question based only on the provided context.

      Context:
      #{context}

      Question:
      #{question}

      Answer:
    PROMPT
  end
end
