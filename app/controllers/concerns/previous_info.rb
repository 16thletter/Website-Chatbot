module PreviousInfo
  extend ActiveSupport::Concern

  included do
    before_action :set_grouped_websites
  end

  private

  def set_grouped_websites
    @grouped_websites = Website.order(last_viewed_at: :desc).group_by do |website|
      viewed = website.last_viewed_at&.to_date

      if viewed == Date.today
        "Today"
      elsif viewed == Date.yesterday
        "Yesterday"
      elsif viewed >= 7.days.ago.to_date && viewed < Date.yesterday
        "Previous 7 Days"
      elsif viewed.year == Date.today.year
        viewed.strftime("%B")
      else
        viewed.strftime("%B %Y")
      end
    end
  end
end
