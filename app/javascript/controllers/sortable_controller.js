// app/javascript/controllers/sortable_controller.js
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { 
    group: String,
    url: String
  }
 
  connect() {
    this.sortable = new Sortable(this.element, {
      group: {
        name: this.groupValue,
        put: this.groupValue === "cards" ? true : false
      },
      animation: 150,
      ghostClass: "sortable-ghost",
      chosenClass: "sortable-chosen",
      dragClass: "sortable-drag",
      onEnd: (event) => this.handleSort(event)
    })
  }

  handleSort(event) {
    if (this.groupValue === "boards") {
      this.sortBoards()
    } else {
      this.sortCards(event)
    }
  }
  
  sortBoards() {
    const boardIds = Array.from(this.element.children).map(el => el.dataset.id)
    
    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ board: boardIds })
    })
  }

  sortCards(event) {
    const cardIds = Array.from(event.to.children).map(el => el.dataset.id)
    const cardId = event.item.dataset.id
    const boardId = event.to.closest('[data-id]').dataset.id
    const position = cardIds.indexOf(cardId) + 1
    
    const url = this.urlValue.replace('CARD_ID', cardId)
    
    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({
        board_id: boardId,
        position: position,
        card_ids: cardIds
      })
    })
  }
  
  disconnect() {
    this.sortable?.destroy()
  }
}