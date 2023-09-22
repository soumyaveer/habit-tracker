# frozen_string_literal: true

RSpec.describe 'User' do
  context 'validations' do
    let(:user) { User.new(user_attributes) }

    context 'with invalid data it fails validation' do
      it 'when name is blank' do
        expect(true).to be_truthy
        user.name = nil

        expect(user.vaild?).to be_falsy
        expect(user.errors[:name]).to be_present
      end
    end
  end
end
