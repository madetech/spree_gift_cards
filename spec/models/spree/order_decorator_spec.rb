require 'spec_helper'

describe "Order" do
  describe "#create_gift_cards" do
    let(:order) { create(:order_with_line_items) }
    let(:line_item) { order.line_items.first }
    subject { order.create_gift_cards }

    context "the line item is a gift card" do
      before do
        line_item.stub(:gift_card?).and_return(true)
        line_item.stub(:quantity).and_return(3)
      end

      it 'creates a gift card for each gift card in the line item' do
        expect { subject }.to change { Spree::VirtualGiftCard.count }.by(line_item.quantity)
      end

      it 'sets the purchaser, amount, and currency' do
        Spree::VirtualGiftCard.should_receive(:create!).exactly(3).times.with(amount: line_item.price, currency: line_item.currency, purchaser: order.user, line_item: line_item)
        subject
      end
    end

    context "the line item is not a gift card" do
      before { line_item.stub(:gift_card?).and_return(false) }

      it 'does not create a gift card' do
        Spree::VirtualGiftCard.should_not_receive(:create!)
        subject
      end
    end
  end

  describe "#finalize!" do
    context "the order contains gift cards and transitions to complete" do
      let(:order) { create(:order_with_line_items, state: 'complete') }

      subject { order.finalize! }

      it "calls #create_gift_cards" do
        order.should_receive(:create_gift_cards)
        subject
      end
    end
  end
end
