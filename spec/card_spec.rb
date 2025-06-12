require 'card'

describe Card do
  let(:card) { Card.new('A') }

  it 'has a rank' do
    expect(card).to respond_to :rank
  end
end