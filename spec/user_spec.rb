require 'user'

describe User do
  let(:user) { User.new('name', 'client', 'player') }
  describe '#initialize' do
    it 'has a name' do
      expect(user).to respond_to :name
    end

    it 'has a client' do
      expect(user).to respond_to :client
    end

    it 'has a player' do
      expect(user).to respond_to :player
    end
  end
end