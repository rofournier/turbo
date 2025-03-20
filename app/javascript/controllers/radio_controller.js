import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "player", 
    "playButton", 
    "currentStation", 
    "volumeSlider", 
    "stationList",
    "indicator"
  ]

  connect() {
    console.log("radio controller connected")
    this.playing = false
    this.currentStation = null
    this.setInitialVolume()
    
    // Initialize SVG icons
    this.playIcon = `<svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>`
    
    this.pauseIcon = `<svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 9v6m4-6v6m7-3a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>`
  }

  setInitialVolume() {
    const volume = this.volumeSliderTarget.value / 100
    this.playerTarget.volume = volume
  }

  togglePlay() {
    if (!this.currentStation) {
      // If no station is selected, do nothing
      return
    }
    
    if (this.playing) {
      this.playerTarget.pause()
      this.playButtonTarget.innerHTML = this.playIcon
    } else {
      this.playerTarget.play()
      this.playButtonTarget.innerHTML = this.pauseIcon
    }
    
    this.playing = !this.playing
  }

  selectStation(event) {
    const stationElement = event.currentTarget
    const stationName = stationElement.dataset.stationName
    const stationUrl = stationElement.dataset.stationUrl
    
    // Update current station display
    this.currentStationTarget.textContent = stationName.charAt(0).toUpperCase() + stationName.slice(1)
    
    // Reset all indicators
    this.indicatorTargets.forEach(indicator => {
      indicator.classList.add("opacity-0")
    })
    
    // Highlight the selected station
    const indicator = stationElement.querySelector('[data-radio-target="indicator"]')
    indicator.classList.remove("opacity-0")
    
    // Update audio source
    this.playerTarget.src = stationUrl
    this.currentStation = stationName
    
    // Auto-play and update button state
    this.playerTarget.play()
    this.playButtonTarget.innerHTML = this.pauseIcon
    this.playing = true
  }

  changeVolume() {
    const volume = this.volumeSliderTarget.value / 100
    this.playerTarget.volume = volume
  }
}
