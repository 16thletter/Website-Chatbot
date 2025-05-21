class PromptBuilder
  def self.build(context, question)
    return "Answer this programming question clearly and concisely:\n#{question}" if context.blank?

    <<~PROMPT
      You are a knowledgeable programming assistant. Use the following context to answer the user's question.#{' '}
      If the answer is not found in the context, say "I don't know" instead of guessing.

      Context:
      #{context}

      Question:
      #{question}

      Answer:
    PROMPT
  end
end
