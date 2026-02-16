require 'httparty'

class RotomBrain
  def self.ask(task, question)
    api_key = ENV['GEMINI_API_KEY']

    return simulation_mode(task) if api_key.blank?

    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=#{api_key}"

    #Prompt 
    prompt_text = <<~PROMPT
      Você é o Rotom-Dex, uma Pokédex inteligente habitada por um Pokémon Rotom.
      
      CONTEXTO DA MISSÃO:
      - Título: "#{task.title}"
      - Descrição: "#{task.description}"
      - Dificuldade: #{task.difficulty}
      
      PERGUNTA DO TREINADOR: "#{question}"
      
      SUA MISSÃO:
      Responda como se fosse uma Pokédex eletrônica e prestativa.
      1. Use gírias Pokémon (ex: "Super Efetivo", "Critical Hit", "Evoluir").
      2. Comece frases com "Bzzzt!" ou "Rotom analisando...".
      3. Seja breve (máximo 3 frases).
      4. Dê uma dica prática de produtividade relacionada à pergunta.
    PROMPT

    # Montagem do JSON
    body = {
      contents: [{
        parts: [{ text: prompt_text }]
      }]
    }.to_json

    response = HTTParty.post(url, 
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )

    if response.success?
      return response.parsed_response.dig('candidates', 0, 'content', 'parts', 0, 'text')
    else
      error_message = response.parsed_response.dig('error', 'message') || response.message
      return "Bzzzt! Erro no servidor Google: #{error_message} (Código: #{response.code})"
    end
  rescue StandardError => e
    return "Bzzzt! Falha crítica no sistema: #{e.message}"
  end

  def self.simulation_mode(task)
    [
      "Bzzzt! (Modo Offline) Para a missão '#{task.title}', sugiro usar um X-Speed e focar rápido!",
      "Rotom detecta que você está sem internet (ou sem API Key). Use Focus Energy!",
      "Bzzzt! Analisando '#{task.title}'... Divida em partes menores, como um Exeggcute!"
    ].sample
  end
end