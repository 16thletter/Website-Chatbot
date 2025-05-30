class HomeController < ApplicationController
  include PreviousInfo
  def index
    @grouped_websites = Website.order(last_viewed_at: :desc).group_by do |website|
      viewed = website.last_viewed_at.to_date

      if viewed == Date.today
        "Today"
      elsif viewed == Date.yesterday
        "Yesterday"
      elsif viewed > 7.days.ago.to_date
        "Previous 7 Days"
      elsif viewed.year == Date.today.year
        viewed.strftime("%B")
      else
        viewed.strftime("%B %Y")
      end
    end
  end
end
