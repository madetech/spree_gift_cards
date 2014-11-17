module SpreeStoreCredits::OrderDecorator
  extend ActiveSupport::Concern

  included do
    prepend(InstanceMethods)
  end

  module InstanceMethods
    def finalize!
      create_gift_cards
      super
    end

    def create_gift_cards
      line_items.each do |item|
        item.quantity.times do
          Spree::VirtualGiftCard.create!(amount: item.price, currency: item.currency, purchaser: user, line_item: item) if item.gift_card?
        end
      end
    end
  end
end

Spree::Order.include SpreeStoreCredits::OrderDecorator
