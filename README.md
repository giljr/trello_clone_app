
# 📦 Drag & Drop Kanban with Rails 8

**Build a Trello-Style Board Using Stimulus, SortableJS, and Tailwind CSS**  
**Author: J3**  
**Time: ~5 min read**

---

## ✅ Overview

In this tutorial, we will build a Trello-like Kanban board where you can drag and drop tasks between columns using:

- **Rails 8**
- **Stimulus**
- **SortableJS**
- **Tailwind CSS**

Seamless drag-and-drop with [acts_as_list](https://github.com/brendon/acts_as_list) and [SortableJs](https://sortablejs.github.io/Sortable/)!

➡️ **Demo:** You can effortlessly move items within cards, across boards, or even rearrange entire boards.

> **Note:** If you get stuck, refer to the [page](https://medium.com/jungletronics/drag-drop-kanban-with-rails-8-9df6f576bde6).

---

### 🛠️ Step 1: Clone the Project

```ruby
git clone https://github.com/giljr/trello_clone_app.git
cd trello_clone_app
bin/setup
```
The app is pre-configured with TailwindCSS, Stimulus, Importmap, and acts_as_list.

### 🛠️ Step 2: Explore Models
`app/models/board.rb`

View on GitHub
```ruby
class Board < ApplicationRecord
  has_many :cards, -> { order(:position) }
end
```
`app/models/card.rb`

View on GitHub
```ruby
class Card < ApplicationRecord
  belongs_to :board
  acts_as_list scope: :board
end
```
### 🛠️ Step 3: Seed Sample Data

View seed file on GitHub
```ruby
%w[Backlog In-Progress Done].each_with_index do |name, index|
  board = Board.create!(name: name, position: index)

  3.times do |i|
    board.cards.create!(
      title: "#{name} Task #{i + 1}",
      body: "Description for #{name.downcase} task #{i + 1}",
      position: i + 1
    )
  end
end
```
Run:

    rails db:seed

### 🛠️ Step 4: Controllers
Boards Controller

View on GitHub
```ruby
class BoardsController < ApplicationController
  def show
    @boards = Board.order(:position)
  end

  def sort
    params[:board].each_with_index do |id, index|
      Board.where(id: id).update_all(position: index + 1)
    end
    head :ok
  end
end
```
Cards Controller

View on GitHub
```ruby
class CardsController < ApplicationController
  def sort
    card = Card.find(params[:id])
    card.update(board_id: params[:board_id], position: params[:position])

    params[:card_ids].each_with_index do |id, index|
      Card.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end
end
```
### 🛠️ Step 5: Routes

View on GitHub
```ruby
Rails.application.routes.draw do
  root "boards#show"

  resources :boards, only: [:show] do
    collection { patch :sort }
  end

  resources :cards, only: [] do
    member { patch :sort }
  end
end
```
### 🛠️ Step 6: Kanban View

View on GitHub
```ruby
<div class="p-6">
  <h1 class="text-3xl font-bold mb-8">My Kanban Board</h1>
  
  <div id="boards-container"
       data-controller="sortable"
       data-sortable-group-value="boards"
       data-sortable-url-value="<%= sort_boards_path %>"
       class="flex gap-4 overflow-x-auto pb-4">
    
    <% @boards.each do |board| %>
      <div data-id="<%= board.id %>"
           class="flex-shrink-0 w-72 bg-gray-50 rounded-lg p-4">
        
        <h2 class="font-bold text-lg mb-4"><%= board.name %></h2>
        
        <ul id="board-<%= board.id %>"
            data-controller="sortable"
            data-sortable-group-value="cards"
            data-sortable-url-value="<%= sort_card_path('CARD_ID') %>"
            class="space-y-3 min-h-[100px]">
          
          <% board.cards.each do |card| %>
            <li data-id="<%= card.id %>"
                class="bg-white p-3 rounded shadow cursor-move hover:shadow-md transition-shadow">
              <h3 class="font-medium"><%= card.title %></h3>
              <p class="text-sm text-gray-600"><%= card.body %></p>
            </li>
          <% end %>
        </ul>
      </div>
    <% end %>
  </div>
</div>
```
### 🛠️ Step 7: Stimulus Controller

View on GitHub
```ruby
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { group: String, url: String }

  connect() {
    this.sortable = new Sortable(this.element, {
      group: {
        name: this.groupValue,
        put: this.groupValue === "cards"
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
      body: JSON.stringify({ board_id: boardId, position, card_ids: cardIds })
    })
  }

  disconnect() {
    this.sortable?.destroy()
  }
}
```
### 🛠️ Step 8: Start Your Server

bin/dev

Access the app at http://localhost:3000.
🚀 Key Features:

✅ Drag & Drop columns and cards
✅ Responsive with Tailwind CSS
✅ Persistent sorting via DB updates
✅ Smooth animations with SortableJS
🌟 Potential Enhancements:

    Add new cards via Hotwire modals

    Inline editing for cards

    Color coding or tagging

    Due dates and reminders

    User assignments

Thanks for following along!
Feel free to ⭐ the repo: trello_clone_app
Stay tuned for the next episode with Turbo Streams!


## License

[MIT](https://choosealicense.com/licenses/mit/)


