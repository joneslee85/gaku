require 'spec_helper'

describe Gaku::Campus do

  describe 'concerns' do
    it_behaves_like 'contactable'
    it_behaves_like 'avatarable'
  end

  describe 'relations' do
    it { should belong_to :school }
    it { should have_one :address }
  end

	describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :school }
	end

  describe '#to_s' do
    let(:campus) { build(:campus) }
    specify { campus.to_s.should eq campus.name }
  end

  context 'counter_cache' do

    let!(:campus) { create(:campus) }

    context 'addresses_count' do

      let(:address) { build(:address) }
      let(:campus_with_address) { create(:campus, :with_one_address) }

      it 'increments addresses_count' do
        expect do
          campus.address = address
        end.to change { campus.reload.addresses_count }.by(1)
      end

      it 'decrements addresses_count' do
        expect do
          campus_with_address.address.destroy
        end.to change { campus_with_address.reload.addresses_count }.by(-1)
      end
    end

    context 'contacts_count' do

      let(:contact) { build(:contact) }
      let(:campus_with_contact) { create(:campus, :with_contact) }

      it 'increments contacts_count' do
        expect do
          campus.contacts << contact
        end.to change { campus.reload.contacts_count }.by(1)
      end

      it 'decrements contacts_count' do
        expect do
          campus_with_contact.contacts.last.destroy
        end.to change { campus_with_contact.reload.contacts_count }.by(-1)
      end
    end


  end

end
