# db/seeds.rb
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
