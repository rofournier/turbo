import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "canvas" ]  
  connect() {
    this.init()
    this.resizeCanvas()
    window.addEventListener('resize', this.resizeCanvas.bind(this))
  }

  init() {
    this.current_action = "pen"
    this.current_color = "black"
    this.current_linewidth = 1
    this.ctx = this.canvasTarget.getContext('2d')
    this.listeners()
  }

  resizeCanvas() {
    const container = this.canvasTarget.parentElement
    this.canvasTarget.width = container.clientWidth
    this.canvasTarget.height = container.clientHeight
  }

  draw(x, y) {
    this.ctx.strokeStyle = this.current_color
    this.ctx.lineWidth = 2
    this.ctx.lineCap = 'round'
    this.ctx.lineJoin = 'round'
    this.ctx.beginPath()
    
    const rect = this.canvasTarget.getBoundingClientRect()
    const canvasX = x - rect.left
    const canvasY = y - rect.top
    this.ctx.strokeStyle = this.current_color
    this.ctx.lineWidth = this.current_linewidth
    
    this.ctx.moveTo(this.lastX, this.lastY)
    this.ctx.lineTo(canvasX, canvasY)
    this.ctx.stroke()

    this.lastX = canvasX
    this.lastY = canvasY
  }

  listeners() {
    this.canvasTarget.addEventListener('mousedown', (e) => {
      this.drawing = true
      const rect = this.canvasTarget.getBoundingClientRect()
      this.lastX = e.clientX - rect.left
      this.lastY = e.clientY - rect.top
    })

    this.canvasTarget.addEventListener('mousemove', (e) => {
      if (this.drawing) {
        this.draw(e.clientX, e.clientY)
      }
    })
  
    this.canvasTarget.addEventListener('mouseup', () => {
      this.drawing = false
      this.ctx.closePath()
    })

    this.canvasTarget.addEventListener('mouseout', () => {
      this.drawing = false
      this.ctx.closePath()
    })
  }

  selectPen() {
    this.current_action = "pen"
    this.current_color = "black"
    this.ctx.lineWidth = 1;
  }

  setPenWidth(event) {
    this.current_linewidth = event.target.value;
  }

  clear() {
    this.ctx.clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height);
  }

  erase() {
    this.current_action = "erase"
    this.current_color = "white"
    this.ctx.lineWidth = 10;
  }


  setColor(event) {
    this.current_color = event.target.value;
  }
}