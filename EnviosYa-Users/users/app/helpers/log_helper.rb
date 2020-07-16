module LogHelper
  def self.save_info_in_log(message)
    Rails.logger.info(message)
  end

  def self.save_error_in_log(message)
    Rails.logger.error(message)
  end
end