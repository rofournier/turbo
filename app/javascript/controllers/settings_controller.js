import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Settings controller connected")
  }
  
  toggleVisibility(event) {
    const widgetKey = event.target.dataset.settingsWidgetKeyParam
    const isVisible = event.target.checked
    
    this.sendUpdate(widgetKey, 'visible', isVisible)
    console.log(`Toggle visibility for ${widgetKey} to ${isVisible}`)
  }
  
  updateColor(event) {
    const widgetKey = event.target.dataset.settingsWidgetKeyParam
    const color = event.target.value
    
    this.sendUpdate(widgetKey, 'color', color)
    console.log(`Update color for ${widgetKey} to ${color}`)
  }
  
  updateOrder(event) {
    const widgetKey = event.target.dataset.settingsWidgetKeyParam
    const order = parseInt(event.target.value)
    
    this.sendUpdate(widgetKey, 'order', order)
    console.log(`Update order for ${widgetKey} to ${order}`)
  }
  
  sendUpdate(widgetKey, property, value) {
    const changes = {
      [widgetKey]: {
        [property]: value
      }
    }
    
    console.log('Sending update:', changes)
    fetch(`/settings/${widgetKey}`, {
      method: "PATCH",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify(changes)
    })
      .then(r => r.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }

}
