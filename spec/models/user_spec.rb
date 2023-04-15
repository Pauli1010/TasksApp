# frozen_string_literal: true

RSpec.describe User, type: :model do
  subject { described_class.new }
  let(:user) { create(:user) }
  let(:pending_user) { create(:pending_user) }

  describe 'factory user' do
    it 'has activation state set as active' do
      expect(user.activation_state).to eql 'active'
      expect(user.activation_state_pending?).to be false
    end
  end

  describe 'factory pending user' do
    it 'has activation state set as pending' do
      expect(pending_user.activation_state).to eql 'pending'
      expect(pending_user.activation_state_pending?).to be true
    end
  end

  it 'respond to virtual attribute password_confirmation' do
    expect(subject.respond_to?(:password_confirmation)).to be true
  end
end
