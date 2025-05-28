class PromptBuilder
  def self.build(context, question)
    <<~PROMPT
      You are an HR assistant. Use the following context to answer the user's question.#{' '}
      If the answer is not found in the context, say "I don't know" instead of guessing.

      Context:
      #{context}

      Question:
      #{question}

      Answer:
    PROMPT
  end
end
