class FixExistingStoreCreditsOriginator < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute <<-SQL
      UPDATE `spree_store_credits` AS `sc`
      JOIN   `spree_virtual_gift_cards` AS `gc`
      ON     SUBSTR(`sc`.`memo`, 12) = `gc`.`redemption_code`
      SET    `sc`.`originator_type` = 'Spree::VirtualGiftCard',
             `sc`.`originator_id` = `gc`.`id`
      WHERE  `sc`.`originator_id` IS NULL
      AND    `sc`.`memo` LIKE 'Gift Card #%'
    SQL
  end
end
