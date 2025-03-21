import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["colorDropdown"]
  static values = {
    taskId: Number
  }

  connect() {
    console.log("Tracker controller connected")
    // Close dropdown when clicking outside
    document.addEventListener('click', this.closeDropdownOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.closeDropdownOutside.bind(this))
  }

  closeDropdownOutside(event) {
    if (this.element.contains(event.target)) return
    this.colorDropdownTarget.classList.add('hidden')
  }

  toggleColorDropdown(event) {
    event.stopPropagation()
    this.colorDropdownTarget.classList.toggle('hidden')
  }

  selectColor(event) {
    const color = event.currentTarget.dataset.color
    this.updateTaskColor(color)
    this.colorDropdownTarget.classList.add('hidden')
  }

  async updateTaskColor(color) {
    try {
      const response = await fetch(`/tasks/${this.taskIdValue}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'text/vnd.turbo-stream.html'
        },
        body: JSON.stringify({ task: { color } }),
      })
      
      if (response.ok) {
        if (response.headers.get("Content-Type").includes("text/vnd.turbo-stream.html")) {
          const html = await response.text()
          Turbo.renderStreamMessage(html)
        }
      }
    } catch (error) {
      console.error("Error updating task color:", error)
    }
  }
}
