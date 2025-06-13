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

      it 'does not display book' do
        expect(result.display_result_message_to(:current_player)).to_not include "You got a book of #{result.card_request}s!"
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

      context 'when requested card made a book' do
        let(:result) { RoundResult.new(
          current_player: GoFishPlayer.new('Player 1'),
          target: GoFishPlayer.new('Player 2'),
          card_request: 'A',
          matching_cards: [Card.new('A','C'),Card.new('A','S'),Card.new('A','D')],
          fished_card: nil
          )
        }

        before do
          result.current_player.hand = [Card.new('A','H')]
          result.matching_cards.each { |card| result.current_player.add_card(card) }
        end

        it 'displays book' do
          expect(result.display_result_message_to(:current_player)).to include "You got a book of #{result.card_request}s!"
        end
      end
    end

    context 'when target does not have requested card' do
      let(:result) { RoundResult.new(
        current_player: GoFishPlayer.new('Player 1'),
        target: GoFishPlayer.new('Player 2'),
        card_request: 'A',
        matching_cards: [],
        fished_card: nil
        )
      }

      it 'displays that the target did not have the card request' do
        expect(result.display_result_message_to(:current_player)).to match (/didn't/i)
      end

      context 'when fished card is not requested card' do
        let(:result) { RoundResult.new(
          current_player: GoFishPlayer.new('Player 1'),
          target: GoFishPlayer.new('Player 2'),
          card_request: 'A',
          matching_cards: [],
          fished_card: Card.new('2','H')
          )
        }

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

        context 'when fished card made a book' do
          let(:result) { RoundResult.new(
            current_player: GoFishPlayer.new('Player 1'),
            target: GoFishPlayer.new('Player 2'),
            card_request: 'A',
            matching_cards: [],
            fished_card: Card.new('A','S')
            )
          }

          before do
            result.current_player.hand = [Card.new('A','H'),Card.new('A','D'),Card.new('A','C')]
            result.current_player.add_card(result.fished_card)
          end

          it 'displays book' do
            expect(result.display_result_message_to(:current_player)).to include "You got a book of #{result.card_request}s!"
          end
        end
      end

      context 'when fished card is requested card' do
        let(:result) { RoundResult.new(
          current_player: GoFishPlayer.new('Player 1'),
          target: GoFishPlayer.new('Player 2'),
          card_request: 'A',
          matching_cards: [],
          fished_card: Card.new('A','D')
          )
        }

        it 'displays with !' do
          expect(result.display_result_message_to(:current_player)).to match (/!/i)
        end

        context 'when fished card made a book' do
          let(:result) { RoundResult.new(
            current_player: GoFishPlayer.new('Player 1'),
            target: GoFishPlayer.new('Player 2'),
            card_request: '2',
            matching_cards: [],
            fished_card: Card.new('A','S')
            )
          }

          before do
            result.current_player.hand = [Card.new('A','H'),Card.new('A','D'),Card.new('A','C'),Card.new('2','H')]
            result.current_player.add_card(result.fished_card)
          end

          it 'displays book' do
            expect(result.display_result_message_to(:current_player)).to include "You got a book of #{result.fished_card.rank}s!"
          end

          context 'when fished card made a book' do
          let(:result) { RoundResult.new(
            current_player: GoFishPlayer.new('Player 1'),
            target: GoFishPlayer.new('Player 2'),
            card_request: 'A',
            matching_cards: [],
            fished_card: Card.new('A','S')
            )
          }

          before do
            result.current_player.hand = [Card.new('A','H'),Card.new('A','D'),Card.new('A','C')]
            result.current_player.add_card(result.fished_card)
          end

          it 'displays book' do
            expect(result.display_result_message_to(:current_player)).to include "You got a book of #{result.card_request}s!"
          end
        end
        end
      end
    end
  end
end