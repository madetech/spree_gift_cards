module SpreeGiftCards::UserDecorator
  def self.included(base)
    base.has_many :purchased_gift_cards,  foreign_key: :purchaser_id,
                                          class_name: Spree::VirtualGiftCard
    base.has_many :redeemed_gift_cards,   foreign_key: :redeemer_id,
                                          class_name: Spree::VirtualGiftCard
  end
end

Spree::User.include(SpreeGiftCards::UserDecorator)
