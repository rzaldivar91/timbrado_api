class Cliente < ApplicationRecord
  has_many :facturas, dependent: :restrict_with_error

  validates :nombre, :rfc, presence: true
end
