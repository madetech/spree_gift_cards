class ChangeSpreeVirtualGiftCardAmountToDecimal < ActiveRecord::Migration
  def change
    change_column :spree_virtual_gift_cards, :amount, :decimal, precision: 8, scale: 2,
                                                                default: 0.0, null: false
  end
end
