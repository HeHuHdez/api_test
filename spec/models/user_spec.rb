# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  context 'with validations' do
    it { should allow_values('api.test@test.com', 'api_test@test.com', 'a@a.a').for(:email) }
    it { should_not allow_values('api.test@', 'api_test', 'a@a').for(:email) }
    it { should have_secure_password }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }

    it 'is expected to save the expires_at' do
      user.save
      user.reload
      expect(user.expires_at).not_to be_nil
    end
  end

  describe '.token_expired?' do
    context 'with expired token' do
      it '' do
        user = create(:user)
        allow(Time).to receive(:now).and_return(2.years.from_now)
        expect(user.token_expired?).to be true
      end
    end

    context 'with valid token' do
      subject{ create(:user).token_expired? }

      it { is_expected.to be false }
    end
  end
end
