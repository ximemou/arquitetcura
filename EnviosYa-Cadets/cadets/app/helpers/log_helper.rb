module LogHelper
  def self.saveInfoInLog(message)
    Rails.logger.info(message)
  end
  def self.saveErrorInLog(message)
    Rails.logger.error(message)
  end
end