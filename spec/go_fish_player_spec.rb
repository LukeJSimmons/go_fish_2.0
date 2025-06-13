require_relative '../lib/go_fish_player'
require_relative '../lib/card'

describe GoFishPlayer do
    let(:player) { GoFishPlayer.new("name") }
    it 'has a name' do
        expect(player).to respond_to :name
    end

    it 'has a hand' do
      expect(player).to respond_to :hand
    end

    describe '#display_hand' do
      it 'returns a string of cards in hand' do
        expect(player.display_hand).to eq player.hand.join(' ')
      end
    end

    describe '#has_card_of_rank?' do
      context 'when hand does not contain card' do
        it 'returns false' do
          expect(player.has_card_of_rank?('A')).to eq false
        end
      end

      context 'when hand does contain card' do
        it 'returns true' do
            player.hand = [Card.new('A','H')]
          expect(player.has_card_of_rank?('A')).to eq true
        end
      end
    end

    describe '#add_card' do
      before do
        player.hand = [Card.new('A','H')]
      end

      it 'adds a card to the front of the array' do
        new_card = Card.new('2','C')
        player.add_card(new_card)
        expect(player.hand.first).to eq new_card
      end

      it 'returns the added card' do
        new_card = Card.new('2','C')
        expect(player.add_card(new_card)).to eq new_card
      end

      describe 'checks for a book' do
        context 'when player does not have a book' do
          before do
            player.hand = [Card.new('A','H'),Card.new('A','D')]
          end

          it 'does not remove anything from the hand' do
            expect {
              player.add_card(Card.new('A','S'))
            }.to change(player.hand, :count).by 1
          end
        end

        context 'when player does have a book' do
          before do
            player.hand = [Card.new('A','H'),Card.new('A','D'),Card.new('A','C')]
          end

          it 'removes the book from the hand' do
            expect {
              player.add_card(Card.new('A','S'))
            }.to change(player.hand, :count).by (-3)
          end
        end
      end
    end
end