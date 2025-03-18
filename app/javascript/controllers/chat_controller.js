import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["sender"]

  connect() {
    // Use event delegation on document to catch form submissions
    document.addEventListener('submit', (event) => {
      if (event.target.id === 'message_form') {
        this.handle_submit(event);
      }
    });
    
    this.handle_username();
  }

  handle_username() {
    if (localStorage.getItem('username') === null) {
      this.add_overlay();
    } else {
      this.username = localStorage.getItem('username');
    }
  }

  add_overlay() {
    const overlay = document.createElement('div');
    overlay.classList.add('fixed', 'inset-0', 'bg-grey', 'bg-opacity-80', 'flex', 'justify-center', 'items-center', 'z-50');
    const prompt = document.createElement('div');
    prompt.classList.add('bg-white', 'p-5', 'rounded', 'shadow-lg');
    prompt.innerHTML = `
      <label for="username" class="block mb-2">Enter your username:</label>
      <input type="text" id="username" name="username" class="mb-2 p-2 w-full border border-gray-300 rounded">
      <button id="save-username" class="px-4 py-2 bg-blue-500 text-white rounded">Save</button>
    `;
    overlay.appendChild(prompt);
    this.element.appendChild(overlay);

    document.getElementById('save-username').addEventListener('click', () => {
      const username = document.getElementById('username').value;
      if (username) {
        localStorage.setItem('username', username);
        this.username = username;
        this.element.removeChild(overlay);
      }
    });
  }

  handle_submit(event) {
    event.preventDefault(); // Prevent the default form submission
    
    const formTarget = event.target;
    this.senderTarget.value = this.username;
    
    const formData = new FormData(formTarget);
    formData.append('sender', this.username);
    
    fetch(formTarget.action, {
      method: 'POST',
      body: formData,
    }).then((response) => {
      return response.text();
    }).then((html) => {
      if (html) {
        Turbo.renderStreamMessage(html);
      }
    })
    .catch((error) => {
      console.error('Error:', error);
    });
  }
}
