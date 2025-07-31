import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "image", "dialog", "zoomedImage" ]

  connect() {
    this.dialogTarget.addEventListener('transitionend', this.handleTransitionEnd.bind(this))
  }

  disconnect() {
    this.dialogTarget.removeEventListener('transitionend', this.handleTransitionEnd.bind(this))
  }

  open(event) {
    this.dialogTarget.showModal()
    this.#set(event.target.closest("a"))
  }

  // Wait for the transition to finish before resetting the image
  handleTransitionEnd(event) {
    if (event.target === this.dialogTarget && !this.dialogTarget.open) {
      this.reset()
    }
  }

  reset() {
    this.zoomedImageTarget.src = ""
    this.dispatch('closed')
  }

  #set(target) {
    this.zoomedImageTarget.src = target.href
  }
}
