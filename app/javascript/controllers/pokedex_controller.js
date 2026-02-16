import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chatWindow", "input", "messages", "loading"]
  static values = { taskId: Number }

  toggle() {
    this.chatWindowTarget.classList.toggle("hidden")
    this.chatWindowTarget.classList.toggle("flex")
    // Foca no input quando abrir
    if (!this.chatWindowTarget.classList.contains("hidden")) {
      setTimeout(() => this.inputTarget.focus(), 100)
    }
  }

  async send(event) {
    event.preventDefault()
    const question = this.inputTarget.value
    if (!question.trim()) return

    // Adiciona mensagem do usuário
    this.appendMessage(question, "user")
    this.inputTarget.value = ""
    this.loadingTarget.classList.remove("hidden")
    this.scrollToBottom()

    try {
      // Pega o token CSRF para segurança do Rails
      const token = document.querySelector('meta[name="csrf-token"]').content

      const response = await fetch("/ai/ask", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token
        },
        body: JSON.stringify({
          task_id: this.taskIdValue,
          question: question
        })
      })

      const data = await response.json()

      this.loadingTarget.classList.add("hidden")
      this.appendMessage(data.answer, "ai")
    } catch (error) {
      this.loadingTarget.classList.add("hidden")
      this.appendMessage("Bzzzt! Erro de conexão.", "ai")
    }
  }

  appendMessage(text, sender) {
    const isAi = sender === "ai"
    const align = isAi ? "justify-start" : "justify-end"
    const color = isAi ? "bg-green-900/80 text-green-100 border-green-700" : "bg-blue-600 text-white border-blue-500"
    const icon = isAi ? "⚡" : "👤"

    const html = `
      <div class="flex ${align} animate-[fadeIn_0.3s]">
        <div class="max-w-[90%] rounded-lg p-2 text-xs font-mono border ${color} shadow-sm backdrop-blur-sm">
          <span class="font-bold mr-1 align-middle">${icon}</span> 
          ${text}
        </div>
      </div>
    `
    this.messagesTarget.insertAdjacentHTML("beforeend", html)
    this.scrollToBottom()
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}