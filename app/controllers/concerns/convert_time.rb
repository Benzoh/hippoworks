require 'active_support/concern'

module ConvertTime
  extend ActiveSupport::Concern

  included do
    # ここにcallback等
    # scope :disabled, -> { where(disabled: true) }
  end

  # メソッド
  def to_sec(h, m, s)
    secs = h.to_i * 3600 + m.to_i * 60 + s.to_i
  end

  private

  # privateメソッド

end