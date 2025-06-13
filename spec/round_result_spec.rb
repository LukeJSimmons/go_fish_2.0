require 'round_result'
require 'go_fish_player'
require 'card'

describe RoundResult do
  describe '#display_result_message_to' do
    let(:result) { RoundResult.new(
      current_player: GoFishPlayer.new('Player 1'),
      target: GoFishPlayer.new('Player 2'),
      card_request: 'A',
      matching_cards: [],
      fished_card: nil
      )
    }

    it 'displays card_request and target' do
      expect(result.display_result_message_to(:current_player)).to include "You requested #{result.card_request} from #{result.target.name}"
    end

    context 'when target has requested card' do
      let(:result) { RoundResult.new(
        current_player: GoFishPlayer.new('Player 1'),
        target: GoFishPlayer.new('Player 2'),
        card_request: 'A',
        matching_cards: [Card.new('A','C')],
        fished_card: nil
        )
      }

      it 'displays how many cards you took' do
        expect(result.display_result_message_to(:current_player)).to include "#{result.matching_cards.count}"
      end

      context 'when target has multiple matching cards' do
        let(:result) { RoundResult.new(
          current_player: GoFishPlayer.new('Player 1'),
          target: GoFishPlayer.new('Player 2'),
          card_request: 'A',
          matching_cards: [Card.new('A','C'),Card.new('A','S')],
          fished_card: nil
          )
        }
        
        it 'displays request in plural' do
          expect(result.display_result_message_to(:current_player)).to include "#{result.card_request}s"
        end
      end

      context 'when displaying to current_player' do
        it 'displays in the 2nd person' do
          expect(result.display_result_message_to(:current_player)).to match (/you/i)
        end
      end

      context 'when not displaying to current_player' do
        it 'displays in the 3rd person' do
          expect(result.display_result_message_to(:opponents)).to include "#{result.current_player.name}"
        end
      end
    end

    context 'when target does not have requested card' do
      context 'when fished card is not requested card' do
        let(:result) { RoundResult.new(
          current_player: GoFishPlayer.new('Player 1'),
          target: GoFishPlayer.new('Player 2'),
          card_request: 'A',
          matching_cards: [],
          fished_card: Card.new('2','H')
          )
        }

        it 'displays target' do
          expect(result.display_result_message_to(:current_player)).to include result.target.name
        end

        it 'displays card_request' do
          expect(result.display_result_message_to(:current_player)).to include result.card_request
        end

        it 'displays that the target did not have the card request' do
          expect(result.display_result_message_to(:current_player)).to match (/didn't/i)
        end

        context 'when displaying to current_player' do
          it 'displays in the 2nd person' do
            expect(result.display_result_message_to(:current_player)).to match (/you/i)
          end

          it 'displays fished card' do
            expect(result.display_result_message_to(:current_player)).to include "fished a #{result.fished_card.rank}"
          end
        end

        context 'when not displaying to current_player' do
          it 'displays in the 3rd person' do
            expect(result.display_result_message_to(:opponents)).to include "#{result.current_player.name}"
          end

          it 'does not display drawn card' do
            expect(result.display_result_message_to(:opponents)).to_not include "fished a #{result.fished_card.rank}"
          end
        end
      end
    end
  end
end