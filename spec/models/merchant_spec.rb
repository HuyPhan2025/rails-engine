require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "relationships" do
    it { should have_many :items}
    it { should have_many :invoices }
  end

  describe "#class method" do
    it "search for merchant, order alphabetically, and return the first merchant" do
      merchant1 = create(:merchant, name: "Christy")
      merchant2 = create(:merchant, name: "Christine")
      merchant3 = create(:merchant, name: "Sue")

      expect(Merchant.search_merchant("chris")).to eq(merchant2)
    end

    it "will return nil if no merchant is found" do
      merchant1 = create(:merchant, name: "Christy")
      merchant2 = create(:merchant, name: "Christine")
      merchant3 = create(:merchant, name: "Sue")

      expect(Merchant.search_merchant("abc")).to eq(nil)
    end
  end
end
