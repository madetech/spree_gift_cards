class Spree::Admin::GiftCardsController < Spree::Admin::BaseController
  before_filter :load_gift_card_history, only: [:show]
  before_filter :load_user, only: [:lookup, :redeem]
  before_filter :load_gift_card_for_redemption, only: [:redeem]

  helper_method :gift_card_currencies, :collection_url

  def new
    @gift_card = Spree::VirtualGiftCard.new
  end

  def create
    p = params[:virtual_gift_card]
    if p[:purchaser_id] && p[:amount] && p[:currency]
      @gift_card = Spree::VirtualGiftCard.create(purchaser_id: p[:purchaser_id],
                                    amount: p[:amount],
                                    currency: p[:currency])

      if @gift_card.valid?
        flash[:notice] = Spree.t(:gift_card_created, code: @gift_card.redemption_code)
      else
        flash[:error] = Spree.t(:gift_card_creation_errors)
      end
    else
      flash[:error] = Spree.t(:gift_card_creation_incomplete)
      redirect_to :back and return
    end

    redirect_to admin_gift_cards_path
  end

  def index; end

  def show; end

  def lookup; end

  def redeem
    if @gift_card.redeem(@user)
      redirect_to admin_user_store_credits_path(@user),
        succes: Spree.t("admin.gift_cards.redeemed_gift_card")
    else
      redirect_to lookup_admin_user_gift_cards_path(@user),
        error: Spree.t("admin.gift_cards.errors.unable_to_redeem_gift_card")
    end
  end

  def gift_card_currencies
    @currencies ||= Spree::Store
                      .all
                      .flat_map do |store|
                        store.supported_currencies.map do |currency|
                          display = ::Money::Currency.find(currency).try(:name)
                          value   = currency.upcase
                          [value, display]
                        end
                      end
                      .uniq
                      .sort_by(&:last)
  end

  def collection_url
    admin_gift_cards_path
  end

  private

  def load_gift_card_history
    redemption_code = Spree::RedemptionCodeGenerator.format_redemption_code_for_lookup(params[:id])
    @gift_cards = Spree::VirtualGiftCard.where(redemption_code: redemption_code)

    if @gift_cards.empty?
      flash[:error] = Spree.t('admin.gift_cards.errors.not_found')
      redirect_to(admin_gift_cards_path)
    end
  end

  def load_gift_card_for_redemption
    redemption_code = Spree::RedemptionCodeGenerator.format_redemption_code_for_lookup(params[:gift_card][:redemption_code])
    @gift_card = Spree::VirtualGiftCard.active_by_redemption_code(redemption_code)

    if @gift_card.blank?
      flash[:error] = Spree.t("admin.gift_cards.errors.not_found")
      render :lookup
    end
  end

  def load_user
    @user = Spree::User.find(params[:user_id])
  end
end
